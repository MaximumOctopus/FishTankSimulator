; ============================================================================
; =                                                                          =
; = Fish Tank Simulator for GameBoy v2.0                                     =
; = (C) Paul Alan Freshney 1999 - 2023                                       =
; =                                                                          =
; = FishEngine (Simulator section)                                           =
; =                                                                          =
; =                                                                          =
; = February 12th 2023                                                       =
; =                                                                          =
; ============================================================================

; ============================================================================
; Uses HRAM $FF80->$FFFE for speed
; Bytes $FF80-$FF88 are used by the sprite copy routine! 
; FF89 is the RandomPtr, FF8A is simulatormode, FF8B is pausemode
; FF8C is JoyNew, FF8D is JoyOld
;
; sprite copy           $80 - $88
; random pointer        $89
; simulatormode         $8a
; pausemode             $8b
; joy new               $8c
; joy old               $8d
__menuitem			EQU $8E				; current item being displayed ($FF8A)
__wavetile			EQU $8F
__wavetilebegin   	EQU $90
__wavetileend		EQU $91
__wavetiledelay		EQU $92
__MenuStatus        EQU $93
__MenuItem1Idx		EQU $94				; which subitem is menu 1 one displaying
__MenuItem2Idx		EQU $95				; which subitem is menu 2 one displaying
__MenuItem3Idx    	EQU $96				; which subitem is menu 3 one displaying
__MenuItem4Idx    	EQU $97				; which subitem is menu 3 one displaying
__MenuMainIdx       EQU $98
__NumFish			EQU	$99
__CrabCount			EQU $9A				; delay crab octopus appears
__OctopusCount		EQU $9B				; delay before octopus appears
__ProcessCrab		EQU $9C
__ProcessSnail		EQU $9D
__ProcessOctopus	EQU $9E
__ProcessJellyFish	EQU $9F
__FishAnimData		EQU $A0 			; -> $C2

_FishCountScreenRAM EQU $9C25			; screen RAM location of fish count 1 - 16
;
; ============================================================================

        SECTION "FishEngine",ROMX,BANK[2]
		
FishTankEngineSetup:

	; ============================================================================
	; == set up tiles ============================================================
	; == copies tile from ROM -> RAM decompressing as it goes -> Tile RAM ========
	; ============================================================================

	ld 	hl, FishTiles     	   			; Get Tile data address
    ld 	de, $D000        	  	  		; Write To buffer RAM

.decompress:

	ld	a, [hl+]
	
	cp	_XX								; RLE stream begin, <tilestreamchar>,<byte>,<count>
	jr	z, .rlestream
	
	cp	_tilestreamendchar				; end of data stream
	jr	z, .finish
	
	ld	[de], a
	inc	de
	
	
	jr	.decompress
	
.rlestream:
	
	ld	a, [hl+]						; tile id
	ld	b, [hl]							; count
	inc	hl
	
.rlestreamloop:

	ld	[de], a
	inc	de
	
	dec	b
	jr	nz, .rlestreamloop
	
	jr	.decompress

.finish:

	ld a, _tilestreamendchar
	ld [de], a
	inc	de	
	ld[de], a
	
.copyfromRAMtoVRAM:	

	ld 	hl, $D000
    ld 	de, $8000        	  	  		; Write To Tile RAM

.copy:

	push hl
	ld   hl, $FF41     ; STAT Register
.wait:
    bit  1, [hl]       ; Wait until Mode is 0 or 1
    jr   nz, .wait
	pop hl

	ld a, [hl+]
	ld [de], a
	inc de
	
	ld a, [hl+]
	ld [de], a
	inc de
	
	cp _tilestreamendchar
	jp nz, .copy

	; ============================================================================

	ld	hl, $9800
	ld	bc, 32*32						; clear entire buffer
	
.clearscreen

.waitVRAMx								; copying to VRAM MUST happen during HSync or VSync
	ldh a, [$ff41]
	and 2
	jr nz, .waitVRAMx

	xor	a
	ld	[hl+], a
	
    dec bc              				; Decrement Count
    ld	a, b            				; Check If bc = 0
    or	c
	jr	nz, .clearscreen
	
	; ===================================================================================	
	
	ld	hl, $9C00						; top row of status window
	ld	de, $9C20						; bottom row of status window
	ld	b, 20
	
.createwindow

.waitVRAM								; copying to VRAM MUST happen during HSync or VSync
	ldh a, [$ff41]
	and 2
	jr nz, .waitVRAM

	ld	a, $52
	ld	[hl+], a						; 
	
	xor	a
	ld	[de], a
	inc de
	
	dec	b
	jr	nz, .createwindow
	
.paflogo
	
	ld	hl, $9C31						; row 18, column 18 
	ld	a, 156
	ld	[hl+], a
	inc a
	ld	[hl+], a
	inc	a
	ld	[hl], a
	
	; ===================================================================================

	ld	a, 16
	ldh	[__NumFish], a					; number of fish on screen to update

	xor	a
	ldh [__menuitem], a
	ldh	[__MenuStatus], a	
	ldh	[__wavetiledelay], a
	ldh	[__MenuItem1Idx], a				; subitem 1, set to first item
	ldh	[__MenuItem2Idx], a				; subitem 2, set to first item
	ldh	[__MenuItem3Idx], a				; subitem 3, set to first item
	ldh	[__MenuItem4Idx], a				; subitem 4, set to first item
	ldh	[__MenuMainIdx], a
	
	ld	a, $FF
	ldh	[__PauseMode], a				; pause mode off	

	ret
		
FishTankEngineLoopEntry:

	ei
	
	call FadeIn		
	
FishTankEngineLoop:

.waitvb
	ldh	a, [$44]     					; Get Raster Position
	cp 144        					    ; Check for VBlank Start
    jr nz, .waitvb   					; Loop Till In VBlank

	call ReadJoy         			   	; Get Joypad button status

	ldh	a, [__JoyNew]
	and	_key_start						; test start key, toggles attractmode/fish mode
	jr	z, checkmenu

	call RandomNumber
	
	ldh	a, [__MenuStatus]
	or	a
	jr	nz, checkmenu
	
	ldh	a, [__MenuMainIdx]
	
	or	a
	jr	z, .mainmenuon
	
	cp	1
	jr	z, .mainmenuoff
	
	xor	a
	ldh	[__SimulatorMode], a			; opening screen, mode 0

	di
	call FadeOut
	
	call TurnMenuOff
	
	; ===================================================================================
	; == give control back to the menu code =============================================
	; ===================================================================================
	
	ret
	
.mainmenuon

	inc	a 								; a=1
	ldh	[__MenuMainIdx], a
	
	call DrawSystemMenu

	jr	z, testup
	
.mainmenuoff

	xor	a
	ldh	[__MenuMainIdx], a
	
	ld	hl, $9C20
	ld	[hl+], a
	ld	[hl+], a
	ld	[hl], a

checkmenu:

	ldh	a, [__MenuMainIdx]
	or	a
	jr	nz, testup
	
.checkmenucont

	ldh	a, [__MenuStatus]				; if menu is off don't bother...
	or	a	
	jp	z, testselect					; ...checking the arrow keys

	; ===================================================================================
	
testup:

	ldh	a, [__JoyNew]
	and	_key_up
	jr	z, testdown
	
	ldh	a, [__MenuMainIdx]
	or	a
	jr	z, .gamemenuup
	
	cp	1
	jr	z, testdown						; can't go up from top menu
	
	dec	a
	ldh [__MenuMainIdx], a
	
	call DrawSystemMenu
	
	jr	testdown
	
.gamemenuup

	ldh	a, [__menuitem]
	
	cp	maxmenuitem						; maxnumber for menu item *****
	jr	z, testuptopmenu

  	inc	a
	ldh	[__menuitem], a
	
	jr	testupcont

testuptopmenu:

	xor	a
	ldh	[__menuitem], a

testupcont:

	call DrawMainMenuItem	

	; ===================================================================================

testdown:

	ldh	a, [__JoyNew]
	and	_key_down
	jr	z, testleft
	
	ldh	a, [__MenuMainIdx]
	or	a
	jr	z, .gamemenudown
	
	cp	2
	jr	z, testleft						; can't go down from bottom menu
	
	inc	a
	ldh [__MenuMainIdx], a
	
	call DrawSystemMenu
	
	jr	testleft
	
.gamemenudown
	
	ldh	a, [__menuitem]
	
	or	a								; minumber for menu item *****
	jr	z, testdowntopmenu

  	dec	a
	ldh	[__menuitem], a
	
	jr	testdowncont

testdowntopmenu:

	ld	a, maxmenuitem
	ldh	[__menuitem], a

testdowncont:

	call DrawMainMenuItem		

	; ===================================================================================

testleft:

	ldh	a, [__JoyNew]
	and	_key_left						; check for "left"
	jr	z, testright

	ldh	a, [__MenuStatus]				; is the >Back / >Menu showing?
	or	a
	jr	z, testright					; if it is then don't do any more testing, left/right not valid here
	
	ldh	a, [__menuitem]

	cp	1
	jr	z, checkleftformenu2
	
	cp	2
	jr	z, checkleftformenu3	
	
	cp	3
	jr	z, checkleftformenu4
	
	ldh	a, [__MenuItem1Idx]
	
	or	a
	jr	z, .menu1max
	
	dec	a
	ldh	[__MenuItem1Idx], a
	
	jr	.updatemenu1	
	
.menu1max

	ld	a, _maxmenu1item
	ldh	[__MenuItem1Idx], a

.updatemenu1
	
	call DrawSubMenuItem
	call ChangeBackgroundScroll

	jr	testright

checkleftformenu2:						; fish count menu

	ldh	a, [__NumFish]
	
	cp	1
	jp	z, testselect	
			
	dec	a
	ldh	[__NumFish], a
	
	add	a, 239
	
	ld	[_FishCountScreenRAM], a

	call RefreshSpritesDeleted

	jp	testselect
	
checkleftformenu3:

	ldh	a, [__MenuItem3Idx]
	
	or	a
	jr	nz, .nextlmenu3
	
	ld	a, _maxmenu2item
	
	jr	updatelmenu3
	
.nextlmenu3

	dec	a
	
updatelmenu3:
	
	ldh	[__MenuItem3Idx], a

	call DrawSubMenuItem
	
	call ChangeFishies	
	
	jr	testright
	
checkleftformenu4:

	ldh	a, [__MenuItem4Idx]
	
	or	a
	jr	nz, .nextlmenu4
	
	ld	a, _maxmenu4item
	
	jr	.updatelmenu4
	
.nextlmenu4

	dec	a
	
.updatelmenu4
	
	ldh	[__MenuItem4Idx], a

	call DrawSubMenuItem

	; ===================================================================================
	
testright:

	ldh	a, [__JoyNew]
	and	_key_right						; check for "right"
	jr	z, testselect

	ldh	a, [__MenuStatus]				; is the >Back / >Menu showing?
	or	a
	jr	z, testselect					; if it is then don't do any more testing, left/right not valid here	
	
	ldh	a, [__menuitem]

	cp	1
	jr	z, checkrightformenu2
	
	cp	2
	jr	z, checkrightformenu3
	
	cp	3
	jr	z, checkrightformenu4

	ldh	a, [__MenuItem1Idx]
	
	cp	_maxmenu1item
	jr	z, .resetmenu1
	
	inc	a
	ldh	[__MenuItem1Idx], a

	jr	.updatemenu1
	
.resetmenu1

	xor	a
	ldh	[__MenuItem1Idx], a
	
.updatemenu1

	call DrawSubMenuItem
	call ChangeBackgroundScroll

	jr	testselect

checkrightformenu2:						; fish count menu

	ldh	a, [__NumFish]

	cp	_maxfish
	jr	z, testselect	
			
	inc	a
	ldh	[__NumFish], a
	
	add	a, 239
	
	ld	[_FishCountScreenRAM], a	

	call RefreshSpritesAdded
	
	jr	testselect
	
checkrightformenu3:

	ldh	a, [__MenuItem3Idx]
	
	cp _maxmenu2item
	jr	nz, nextrmenu3
	
	xor	a
	
	jr	updatermenu3
	
nextrmenu3:

	inc	a
	
updatermenu3:
	
	ldh	[__MenuItem3Idx], a

	call DrawSubMenuItem	
	call ChangeFishies
	
checkrightformenu4:

	ldh	a, [__MenuItem4Idx]

	cp _maxmenu4item
	jr	nz, .nextrmenu4
	
	xor	a
	
	jr	.updatermenu4
	
.nextrmenu4:

	inc	a
	
.updatermenu4
	
	ldh	[__MenuItem4Idx], a

	call DrawSubMenuItem	

	; --------------------------------------------------------------------------------------

testselect:								; check for select button (pause toggle)

	ldh	a, [__JoyNew]
	and	_key_select
	jr	z, testabutton

	call RandomNumber
	
	ldh	a, [__menuitem]
	cp	3
	jr	z, .selectspecial

	ldh	a, [__PauseMode]
	cpl									; toggle pausemode
	ldh	[__PauseMode], a

	or	a	
	jr	z, .pausemodeon

.pausemodeoff

	ld	hl, menuoff
	
	jr	.dopauseupdate
	
.pausemodeon

	ld	hl, pauseondata		

.dopauseupdate

	ld	a, [hl+]
	ld	[$9C2A], a						; tile 1 screen RAM location
	ld	a, [hl+]
	ld	[$9C2B], a						; tile 2 screen RAM location
	ld	a, [hl]
	ld	[$9C2C], a						; tile 3 screen RAM location
	
	jr	testabutton
	
	; --------------------------------------------------------------------------------------	
	
.selectspecial

	ldh	a, [__MenuItem4Idx]
	
	or	a
	jr	z, .specialcrab
	
	cp	3
	jr	z, .specialjellyfish
	
	cp	1
	jr	z, .specialoctopus
	
.specialsnail

	xor	a
	ld	[snailcount], a					; clear counter, causes snail to appear

	jr	testabutton

.specialcrab

	xor	a
	ldh	[__CrabCount], a				; clear counter, causes crab to appear

	jr	testabutton

.specialoctopus

	xor	a
	ldh	[__OctopusCount], a				; clear counter, causes octopus to appear

	jr	testabutton
	
.specialjellyfish

	xor	a
	ld	[jellyfishcount], a				; clear counter, causes jellyfish to appear
	
	; --------------------------------------------------------------------------------------	

testabutton:

	ldh	a, [__JoyNew]
	and	_key_a          	 			; Check For 'A' Button
	jr	z, .testbbutton        
	
	ldh	a, [__MenuStatus]
	
	or	a
	jr	nz, .turnmenuoff

	cpl
	ldh	[__MenuStatus], a				; set menu to ON

	xor	a
	ldh	[__menuitem], a					; current menu item = 0

	call DrawMainMenuItem
	
	jr	.testbbutton
	
.turnmenuoff

	call TurnMenuOff

	; --------------------------------------------------------------------------------------

.testbbutton:

	ldh	a, [__JoyNew]
	and	_key_b		           			; Check For 'B' Button
	jp	z, FishTankEngineLoop        

	ldh	a, [__MenuItem1Idx]
	ld	c, a
	
	ld	hl, chestoffsets
	sla	a								; *2, 2 bytes per offset
	
	add l								; add offset to hl
	ld 	l, a
	jr	nc, .notcarry
	inc h
.notcarry:

	ld	a, [hl+]						; copy chest offset to hl
	ld	b, [hl]
	
	or	a
	jp	z, FishTankEngineLoop			; offset high byte = 0 then no chest
	
	ld	l, a
	ld	h, b
	
	ld	a, [hl]
	
	cp	_chestclosed
	jr	z, .openchest

	ld	[hl], _chestclosed
	
	jp FishTankEngineLoop
	
.openchest
	
	ld	[hl], _chestopen
	
	ld	hl, chestactive
	ld	[hl], 1
	
	ld	hl, chestoffsetsxy				; lookup table of y,x coords for bubbles

	ld	b, 0
	sla	c								; multiply x2, 2 bytes per chest coordinate
	
	add	hl, bc
	
	ld	a, [hl+]						; ycoord to appear from
	ld	b, [hl]							; xcoord to appear from
	
	ld	hl, OAMDATA+$50					; sprite 20
	
	ld	[hl+], a						; ycoord
	ld	a, b
	ld	[hl+], a						; xcoord
	ld	a, _bubblesprite
	ld	[hl], a							; bubble	

	jp	FishTankEngineLoop
	
; ===================================================================================
; ===================================================================================
; ===================================================================================
		
UpdateSprites:

	; ========================================================================
	; == start with the crab =================================================
	; ========================================================================
	
	ld	a, [OAMDATA+140]				; crab's ycoord
	
	or	a								; if the crab is offscreen then do inc
	jr	nz, updateoctopus				; the crab delay variable
	
	call RandomNumber
	
	or	a
	jr	nz, updateoctopus
	
	ld	hl, $FF00+__CrabCount
	dec	[hl]
	
	jr	updatefish
	
	; ========================================================================		
	; == now the octopus =====================================================
	; ========================================================================	
	
updateoctopus:	
	
	ld	a, [OAMDATA+144]				; octopus's ycoord
	
	or	a								; if the octopus is offscreen then do inc
	jr	nz, updatejellyfish				; the crab delay variable
	
	call RandomNumber
	
	or	a
	jr	nz, updatejellyfish
	
	ld	hl, $FF00+__OctopusCount
	dec	[hl]
	
	jr	updatefish
	
	; ========================================================================		
	; == now the octopus =====================================================
	; ========================================================================	
	
updatejellyfish:	
	
	ld	a, [OAMDATA+152]				; octopus's ycoord
	
	or	a								; if the octopus is offscreen then do inc
	jr	nz, updatesnail					; the crab delay variable
	
	call RandomNumber
	
	or	a
	jr	nz, updatesnail
	
	ld	hl, jellyfishcount
	dec	[hl]

	jr	updatefish
	
	; ========================================================================		
	; == now the snail =======================================================
	; ========================================================================		
	
updatesnail:

	ld	a, [OAMDATA+148]				; snail's ycoord
	
	or	a								; if the octopus is offscreen then do inc
	jr	nz, updatefish					; the crab delay variable
	
	call RandomNumber
	
	or	a
	jr	nz, updatefish
	
	ld	hl, snailcount
	dec	[hl]
	
	; ========================================================================

updatefish:
	
 	ldh	a, [__NumFish]       			; the number of fish active
	ld	b, a

	ld  hl, OAMDATA     			 	; hl -> the addess of the current sprite

UpdateSpriteLoop:
	
	inc hl								; move to xcoord
	ld	a, [hl-]						; xcoord to a, hl back to ycoord

    cp	_rightsideoftank				; right edge of the tank
	jp	z, ChangeToGoLeft
	cp  _leftsideoftank					; left edge of the tank
	jp  z, ChangeToGoRight
	
	; ========================================================================
	
	call RandomNumber

	; ========================================================================

	cp	249 							; if random number <=249 then dont bother to check
	jp	c, 	nochange					; for random events
		
	; ========================================================================		
		
	cp	254								; arbitary number
	jp	z, ChangeToGoLeft	
	cp	253								; arbitary number
	jp	z, ChangeToGoRight
  	
	cp	252
	jr	z, GoDown
	cp	251
	jr	z, GoUp
	
	cp	250
	jr	z, CreateBubble

	jr	nochange
	
CreateBubble:

	ld	d, h							; backup hl, current fish
	ld	e, l

	ld	a, [OAMDATA+$40]				; sprite #16, ycoord reference
	ld	c, 0
	
	or	a								; is set to 0
	jr	z, ok
		
	ld	a, [OAMDATA+$44]				; sprite #17, ycoord reference
	inc	c
	
	or 	a								; is set to 0
	jr	z, ok

	ld	a, [OAMDATA+$48]				; sprite #18, ycoord reference
	inc	c
	
	or 	a			 					; is set to 0
	jr	z, ok	
	
	ld	a, [OAMDATA+$4C]				; sprite #19, ycoord reference
	inc	c
	
	or 	a								; is set to 0
	jr	z, ok	
	
	ld	h, d							; restore hl, current fish
	ld	l, e
	
	jr	nochange

ok:
	
	ld	h, d							; restore hl, current fish
	ld	l, e

	push hl	
	
	ld	a, [hl+]						; hl contains address of current fish sprite, copy y-coord to d
	ld	d, a
	ld	e, [hl]							; copy x-coord to e
	
	ld	a, c							; load sprite id to a
	
	ld	hl, OAMDATA+$40					; address of first bubble sprite
	
	sla	a								;
	sla a								; multiply sprite count by 4 (4 bytes per sprite)
	
	add l								; now add a to hl
	ld 	l, a							; assumes hl lies on a $xx00 boundary (which it does!)

	ld	a, d							; set bubble's xcoord to that of the host fish
	ld	[hl+], a
	ld	a, e							; set bubble's ycoord to that of the host fish
	ld	[hl+], a			
	ld	a, _bubblesprite				; set tile
	ld	[hl+], a
	xor a
	ld	[hl], a
	
	pop	hl
		   
	jr	nochange

GoDown:

	ld	a, [hl]							; put sprite's ycoord in a
	cp	_bottomsideoftank				; if the fish is already at $88 then
	jr	z, nochange						; don't move any further
	
	add	a, 2							; move the fish down 2 pixels
	ld	[hl], a
	
	jr	nochange

GoUp:

	ld	a, [hl]							; put sprite's ycoord in a
	cp 	_topsideoftank					; if the fish is already at 16 then
	jr 	z, nochange						; don't move any further
	
	sub	a, 2							; move the fish up 2 pixels
	ld	[hl], a
	
	jr 	nochange

ChangeToGoRight:
    
	ld	de, 3
	add	hl, de							; points to sprite's flags
	
	ld	a, $20
	ld	[hl-], a
	
	dec	hl
	dec	hl

	jr	nochange
	
ChangeToGoLeft:
    
	ld	de, 3
	add	hl, de							; points to sprite's flags

	xor	a
	ld	[hl-], a
	
	dec	hl
	dec	hl
	
nochange:

	ld	de, 3
	add	hl, de							; points to sprite's flags
	
	ld	a, [hl-]

	or	a								; flipped in y-direction?
	jr	z, GoingLeft 

GoingRight:

	dec	hl								; hl at sprite's xcoord

	inc	[hl]
	inc	hl
	
	jr	AnimateFish

GoingLeft:
	
	dec	hl								; hl at sprite's xcoord

	dec	[hl]
	inc	hl

AnimateFish:

	push hl
	
	ld	c, __FishAnimData				; animation speed data
	ld	a, b
	sla a								; x2
	
	add	c								; move to sprites position
	
	ld	a, [c]
	dec	a
	
	or	a
	jr	z, .animatenow
	
.notthistime

	ld	[c], a
	
	pop hl								; sprite tile id
	
	inc	hl
	
	jr	NextFishQ
	
.animatenow	

	inc	c
	ld	a, [c]
	dec	c
	ld	[c], a
	
	pop hl

	ld	a, [hl]							; hl at sprite's tile id
	
	bit	0, a
	jr	nz, .oddframe
	
.evenframe

	inc	a
	ld	[hl+], a	
	
	jr	NextFishQ	
	
.oddframe

	dec	a
	ld	[hl+], a

	ld	a, 1
	ld	[c], a	

NextFishQ:
	
	inc	hl								; move to next fish
	
	dec b
	jp	nz, UpdateSpriteLoop

	;ret
	
; ===================================================================================
; ===================================================================================
; ===================================================================================	

UpdateBubbles:

	ld	b, 5							; number of bubbles to process (1-4 = fish, 5 = chest)
	ld	d, 0							; clear the msb
	ld	e, 4

	ld  hl, OAMDATA+$40					; hl -> the addess of the first bubble
	
UpdateBubblesLoop:

	ld  a, [hl]							; ycoord to a
	
    cp  18								; top edge of the tank
	jr 	z, PreKillSprite				; change the sprite to "popped bubble"
	
	cp	17
	jr 	z, PreKillSprite2				; second burst anim frame		
	
	cp	16
	jr 	z, KillSprite					; remove the sprite from the screen	
	
	or	a
	jr 	z, NextBubble
	
	dec [hl]							; move sprite up

	jr	NextBubble

PreKillSprite:

	dec [hl]
	inc	hl
	inc	hl
	
	ld	a, _burstbubblesprite
	ld	[hl+], a						; this is a burst char        
	inc	hl								;

	jr	NextBubbleQ
	
PreKillSprite2:

	dec	[hl]
	inc	hl
	inc	hl
	
	ld	a, _burstbubblesprite2
	ld	[hl+], a						; this is the 2nd burst char
	inc	hl								;
	
	jr	NextBubbleQ	
	
KillSprite:

	xor a
	ld	[hl+], a						; move sprite off screen
	ld	[hl+], a						; set x/y coords to 0
	ld	[hl+], a						; $00 is blank character
	
	inc	hl								; hl at address on next sprite
	
	jr	NextBubbleQ	
		
NextBubble:

	add	hl, de							; move to next sprite

NextBubbleQ:							; jump here when hl is at xcoord of next sprite

	dec	b 								; move to next bubble
	
	jp	nz, UpdateBubblesLoop

	ldh	a, [__wavetiledelay]

	cpl

	ldh	[__wavetiledelay], a	
	
	or	a
	jp	z, SetupWave
	
	ret	

; ===================================================================================
; ===================================================================================
; ===================================================================================

UpdateCrab:

	ld	hl, OAMDATA+140					; sprite #37, ycoord reference
	ld	a, [hl]							; check to see if ycoord is currently
	
	or 	a								; set to 0
	jr	nz, MoveCrab
	
CreateCrab:

	ldh	a, [__CrabCount]
	
	or	a
	jr	nz, UpdateSnail
	
	ld	a, _crabwaitcount
	ldh	[__CrabCount], a
	
	call RandomNumber
	
	bit	0, a
	jr	z, .rightside	

.leftside
	
	ld	a, 140							; crab's ycoord
	ld	[hl+], a
	xor a								; crab's xcoord (0)
	ld	[hl+], a
	ld	a, _crabframe1
	ld	[hl+], a
	ld	[hl], $00

	jr	UpdateSnail

.rightside

	ld	a, 140							; crab's ycoord
	ld	[hl+], a
	ld	a, 167							; crab's xcoord (0)
	ld	[hl+], a
	ld	a, _crabframe1
	ld	[hl+], a
	ld	[hl], $20

	jr	UpdateSnail
	
MoveCrab:

	ld	de, crabdelay
	ld	a, [de]
	
	or	a	
	jr	nz, SlowCrab
	
	ld	a, 2
	ld	[de], a

	; ===================================================================================
		
	ld	hl, OAMDATA+143					; sprite flags
	ld	a, [hl-]
	
	or	a								; $00 = right moving, $20 = left moving
	jr	z, .movingright
	
.movingleft

	dec	hl

	ld	a, [hl+]
	
	cp	1	
	jr	z, KillCrab

	; ===================================================================================

	ld	a, [hl]
	
	cp	_crabframelast
	
	jr	nz, CrabAnim
	
	ld	a, _crabframe1
	ld	[hl-], a						; sprite in hl, then move to x-coord
	
	dec	[hl]							; move one pixel left
		
	jr	UpdateSnail	
	
.movingright

	dec	hl
	
	ld	a, [hl+]
	
	cp	167	
	jr	z, KillCrab
	
	; ===================================================================================
	
	ld	a, [hl]
	
	cp	_crabframelast
	
	jr	nz, CrabAnim
	
	ld	a, _crabframe1
	ld	[hl-], a						; sprite in hl, then move to x-coord
	
	inc	[hl]							; move one pixel right
		
	jr	UpdateSnail
	
KillCrab:

	ld	hl, OAMDATA+140
	
	xor	a
	ld	[hl+], a						; ycoord
	ld	[hl+], a						; xcoord
	ld	[hl], a							; sprite (blank)
	
	jr	UpdateSnail
	
SlowCrab:

	dec	a
	ld	[de], a
	
	jr	UpdateSnail

CrabAnim:

	inc	[hl]							; moves to next frame
		
FinishedCrab:

	;ret	
	
; ===================================================================================
; ===================================================================================
; ===================================================================================

UpdateSnail:

	ld	hl, OAMDATA+148					; sprite #39, ycoord reference
	ld	a, [hl]							; check to see if ycoord is currently
	
	or	a								; set to 0
	jr	nz, MoveSnail
	
CreateSnail:

	ld	de, snailcount
	ld	a, [de]
	
	or	a
	jr	nz, UpdateOctopus
	
	ld	a, _snailwaitcount
	ld	[de], a
	
	call RandomNumber
	
	bit	0, a
	jr	z, .rightside
	
.leftside

	ld	a, 10							; crab's ycoord
	ld	[hl+], a
	ld	a, 5
	ld	[hl+], a
	ld	a, _snailframe1
	ld	[hl+], a
	ld	[hl], $00						; clear x-axis flip
	
	jr	UpdateOctopus
	
.rightside

	ld	a, 10							; crab's ycoord
	ld	[hl+], a
	ld	a, 163
	ld	[hl+], a						; crab's xcoord
	ld	a, _snailframe1
	ld	[hl+], a
	ld	[hl], $20						; flip in x-axis
	
	jr	UpdateOctopus
	
MoveSnail:

	ld	de, snaildelay
	ld	a, [de]
	
	or	a	
	jr	nz, SlowSnail
	
	ld	a, 2
	ld	[de], a

	; ===================================================================================
	
	ld	a, [hl]							; ycoord
	
	cp	140
	
	jr	z, KillSnail
	
	; ===================================================================================
	
	ld	hl, OAMDATA+150					; sprite data
	
	ld	a, [hl]
	
	cp	_snailframelast
	
	jr	nz, SnailAnim
	
	ld	a, _snailframe1
	ld	[hl-], a						; xcoord in hl

	dec	hl
	inc	[hl]							; move one pixel down
		
	jr	UpdateOctopus
	
KillSnail:

	dec	hl
	xor	a
	ld	[hl+], a						; ycoord
	ld	[hl+], a						; xcoord
	ld	[hl], a							; sprite (blank)
	
	jr	UpdateOctopus
	
SlowSnail:

	dec	a
	ld	[de], a
	
	jr	UpdateOctopus

SnailAnim:

	inc	[hl]							; moves to next frame
		
FinishedSnail:

	;ret
	
; ===================================================================================
; ===================================================================================
; ===================================================================================
	
UpdateOctopus:

	ld	a, [OAMDATA+144]				; sprite #38, ycoord reference

	or	a								; check to see if ycoord is currently, set to 0

	jr	nz, MoveOctopus
	
CreateOctopus:

	ldh	a, [__OctopusCount]
	
	or	a
	jp	nz, UpdateJellyFish
	
	ld	a, _octopuswaitcount
	ldh	[__OctopusCount], a

	call RandomNumber	
	
	ld	b, a
	
	and	$4F								; gives us a number between 0 and 111
	add	a, 25							; gives a range of 25-136 (sort of...!)

	ld	hl, OAMDATA+144
	ld	[hl+], a
	
	bit	0, b
	jr	z, .movingright
	
.movingleft
	
	ld	a, 167							; octopuses's xcoord
	ld	[hl+], a
	ld	a, _octopusframe1
	ld	[hl+], a
	ld	[hl], $00

	jp	UpdateJellyFish
	
.movingright

	ld	a, 0							; octopuses's xcoord
	ld	[hl+], a
	ld	a, _octopusframe1
	ld	[hl+], a
	ld	[hl], $20
	
	jp	UpdateJellyFish
	
MoveOctopus:

	ld	hl, OAMDATA+147
	ld	a, [hl]
	
	or	a
	jr	z, .leftmoving
	
.rightmoving

	ld	a, [octopusmode]
	
	or	a
	jr	z, .slowmoder
	
.fastmoder

	ld	hl, OAMDATA+145	
	
	ld	a, [hl]
	
	cp	165								; if xcoord >=165 then kill sprite
	jr	nc, KillOctopus
	
	add	5
	ld	[hl], a

	ld	de, octopusdelay
	ld	a, [de]
	
	dec	a
	
	or	a
	jr	z, .changemodetoslow

	ld	[de], a
	
	jr	UpdateJellyFish

.slowmoder

	ld	hl, OAMDATA+145

	ld	a, [hl]
	
	cp	165	 							; if xcoord >= 165 then kill sprite
	jr	nc, KillOctopus	
	
	inc	[hl]							; move octopus left

	ld	de, octopusdelay
	ld	a, [de]
	
	dec	a
	
	or	a
	jr	z, .changemodetofast

	ld	[de], a
	
	jr	UpdateJellyFish

.leftmoving

	ld	a, [octopusmode]
	
	or	a
	jr	z, .slowmodel
	
.fastmodel

	ld	hl, OAMDATA+145
	
	ld	a, [hl]
	
	cp	5								; if xcoord <= 5 then kill sprite
	jr	c, KillOctopus
	
	sub	5
	ld	[hl], a

	ld	de, octopusdelay
	ld	a, [de]
	
	dec	a
	
	or	a
	jr	z, .changemodetoslow

	ld	[de], a
	
	jr	UpdateJellyFish

.slowmodel

	ld	hl, OAMDATA+145

	ld	a, [hl]
	
	cp	5 								; if xcoord <= 5 then kill sprite
	jr	c, KillOctopus	
		
	dec	[hl]							; move octopus left

	ld	de, octopusdelay
	ld	a, [de]
	
	dec	a
	
	or	a
	jr	z, .changemodetofast

	ld	[de], a
	
	jr	UpdateJellyFish
	
.changemodetofast

	inc	hl
	ld	[hl], _octopusframe1

	ld	a, 3
	ld	[de], a
	
	ld	a, 1
	ld	[octopusmode], a
	
	jr	UpdateJellyFish
	
.changemodetoslow

	inc	hl
	ld	[hl], _octopusframelast

	ld	a, 8
	ld	[de], a
	
	xor	a
	ld	[octopusmode], a
	
	jr	UpdateJellyFish
	
KillOctopus:

	dec	hl
	xor	a
	ld	[hl+], a						; ycoord
	ld	[hl+], a						; xcoord
	ld	[hl], a							; sprite (blank)

; ===================================================================================
; ===================================================================================
; ===================================================================================	

UpdateJellyFish:

	ld	a, [OAMDATA+152]				; sprite #40, ycoord reference

	or	a								; check to see if ycoord is currently, set to 0

	jr	nz, MoveJellyFish
	
CreateJellyFish:

	ld	de, jellyfishcount
	ld	a, [de]
	
	or	a
	ret	nz
	
	ld	a, _jellyfishwaitcount
	ld	[de], a

	call RandomNumber	
	
	ld	b, a
	
	and	$4F								; gives us a number between 0 and 111
	add	a, 25							; gives a range of 25-136 (sort of...!)

	ld	hl, OAMDATA+152
	ld	[hl+], a
	
	bit	0, b
	jr	z, .movingright
	
.movingleft
	
	ld	a, 167							; octopuses's xcoord
	ld	[hl+], a
	ld	a, _jellyfishframe1
	ld	[hl+], a
	ld	[hl], $00

	ret
	
.movingright

	xor	a								; octopuses's xcoord
	ld	[hl+], a
	ld	a, _jellyfishframe1
	ld	[hl+], a
	ld	[hl], $20
	
	ret
	
MoveJellyFish:

	ld	hl, OAMDATA+155
	ld	a, [hl]
	
	or	a
	jr	z, .leftmoving
	
.rightmoving

	ld	a, [jellyfishmode]
	
	or	a
	jr	z, .slowmoder
	
.fastmoder

	ld	hl, OAMDATA+152

	dec	[hl]							; move jelly fish up
	inc	hl								; move to x-coord
	
	ld	a, [hl]
	
	cp	165								; if xcoord >=165 then kill sprite
	jr	nc, KillJellyFish
	
	add	5
	ld	[hl], a

	ld	de, jellyfishdelay
	ld	a, [de]
	
	dec	a
	
	or	a
	jr	z, .changemodetoslow

	ld	[de], a
	
	ret

.slowmoder

	ld	hl, OAMDATA+153

	ld	a, [hl]
	
	cp	165	 							; if xcoord >= 165 then kill sprite
	jr	nc, KillJellyFish	
	
	inc	[hl]							; move octopus left

	ld	de, jellyfishdelay
	ld	a, [de]
	
	dec	a
	
	or	a
	jr	z, .changemodetofast

	ld	[de], a
	
	ret

.leftmoving

	ld	a, [jellyfishmode]
	
	or	a
	jr	z, .slowmodel
	
.fastmodel

	ld	hl, OAMDATA+152

	dec	[hl]							; move jelly fish up
	inc	hl								; move to x-coord
	
	ld	a, [hl]
	
	cp	5								; if xcoord <= 5 then kill sprite
	jr	c, KillJellyFish
	
	sub	5
	ld	[hl], a

	ld	de, jellyfishdelay
	ld	a, [de]
	
	dec	a
	
	or	a
	jr	z, .changemodetoslow

	ld	[de], a
	
	ret

.slowmodel

	ld	hl, OAMDATA+153

	ld	a, [hl]
	
	cp	5 								; if xcoord <= 5 then kill sprite
	jr	c, KillJellyFish	
		
	dec	[hl]							; move octopus left

	ld	de, jellyfishdelay
	ld	a, [de]
	
	dec	a
	
	or	a
	jr	z, .changemodetofast

	ld	[de], a
	
	ret
	
.changemodetofast

	inc	hl
	ld	[hl], _jellyfishframe1

	ld	a, 3
	ld	[de], a
	
	ld	a, 1
	ld	[jellyfishmode], a
	
	ret
	
.changemodetoslow

	inc	hl
	ld	[hl], _jellyfishframelast

	ld	a, 8
	ld	[de], a
	
	xor	a
	ld	[jellyfishmode], a
	
	ret
	
KillJellyFish:

	dec	hl
	xor	a
	ld	[hl+], a						; ycoord
	ld	[hl+], a						; xcoord
	ld	[hl], a							; sprite (blank)
	
	ret
	
; ===================================================================================
; ===================================================================================
; ===================================================================================	
   
SetupWave:								; background 1

	ldh	a, [__wavetile]
	ld	hl, $9800						; start of video RAM, top left corner of the fish tank

	ld b, 20

.loop:

.waitVRAMx								; copying to VRAM MUST happen during HSync or VSync
	ldh a, [$ff41]
	and 2
	jr nz, .waitVRAMx

	ldh	a, [__wavetile]
	ld	[hl+], a						; tile 1
	
	dec b
	jr nz, .loop
	
	ld	b, a
	ldh	a, [__wavetileend]
	
	cp	b
	jr	nz, WaveUpFrame

	ldh	a, [__wavetilebegin]
	ldh	[__wavetile], a	

	ret
	
; ===================================================================================
; ===================================================================================
; ===================================================================================	

WaveUpFrame:

	inc	b
	ld	a, b
	ldh	[__wavetile], a

	ret

; ===================================================================================
; ===================================================================================
; ===================================================================================		

DrawSystemMenu:							; item in a

	dec	a								; 0-indexed array
	
	ld	hl, systemmenu					; Get Tile data start address

	sla	a								;  x2
	sla	a								;  x2   = x4 (4 bytes per menu item)
	
	ld	d, 0
	ld	e, a
	add hl, de	
	
	ld	a, [hl+]
	ld	[$9C20], a
	ld	a, [hl+]
	ld	[$9C21], a
	ld	a, [hl]
	ld	[$9C22], a
	
	ret

; ===================================================================================
; ===================================================================================
; ===================================================================================		

DrawMainMenuItem:  						; menu item to draw in a

	ld	hl, menu1one					; Get Tile data start address

	swap a								; x16
	sra	a								;  /2   = x8
	
	ld	d, 0
	ld	e, a
	add hl, de		

.dodraw:
	
	ld	a, [hl+]
	ld	[$9C20], a						; tile 1
	ld	a, [hl+]
	ld	[$9C21], a						; tile 2
	ld	a, [hl+]
	ld	[$9C22], a						; tile 3
	ld	a, [hl+]
	ld	[$9C23], a						; tile 4
	ld	a, [hl+]
	ld	[$9C24], a						; tile 5
	
	;ret

; ===================================================================================
; ===================================================================================
; ===================================================================================

DrawSubMenuItem:				;

	ldh	a, [__menuitem]					; a contains the index to the current main menu displayed (primary level)

	ld	c, __MenuItem1Idx				; get the first memory location of menusubitemindexes (secondary level)
	add	a, c							; a is the correct menuitemidx reference
	ld	c, a

	ld	hl, menu1onelist				; list of menu graphics	
	
	ldh	a, [__menuitem]
	
	swap a								; x16 (16 bytes per menu item set)
	ld	d, 0
	ld	e, a
	add	hl, de							; move to menu item location

.dsmitlocation:

	ld	a, [hl+]						; hl contains the ADDRESS to the location of the menu map
	ld	b, [hl]

	ld	h, b
	ld	l, a							; hlnow stores the LOCATION for the menu map

	ld	a, [c]							; de contains the address of the correct menuitemidx	
	sla	a
	ld	d, 0
	ld	e, a							; de now equals a
	add	hl, de							; so we add its contents to get the submenu for the menu
	add	hl, de

	ld	a, [hl+]						
	ld	[$9C25], a						; tile 1
	ld	a, [hl+]
	ld	[$9C26], a						; tile 2
	ld	a, [hl+]
	ld	[$9C27], a						; tile 3
	ld	a, [hl]
	ld	[$9C28], a						; tile 4
	
	ldh	a, [__menuitem]					; a contains the index to the current main menu displayed (primary level)
	
	cp 1
					
	ret	nz								; show fish count to menu if the fish selection menu is active
	
	ldh	a, [__NumFish]					; put number of fish in to a
			
	add	a, 239							; tile 239 represents 1 fish text
	
	ld	[$9C25], a						; put the "number of fish" tile on screen

	ret

; ===================================================================================
; ===================================================================================
; ===================================================================================

ChangeFishies:

	ldh	a, [__MenuItem3Idx]

	sla	a								; x2 = offset from jumptable
	ld	hl, changefishjt				; list of jump locations
	
	ld	e, a
	ld	d, 0
	add	hl, de							; add offset to jumptable

	ld	a, [hl+]
	ld	h, [hl]
	ld	l, a
	
	jp	hl								; jump to routine

SetFishiesFat:

	ld	d, 6
	ld	e, 7
	
	jr	CopySpriteFramesSetup

SetFishiesPuffer:
	
	ld	d, 8
	ld	e, 9
	
	jr	CopySpriteFramesSetup
	
SetFishiesPike:

	ld	d, 10
	ld	e, 11
	
	jr	CopySpriteFramesSetup
	
SetFishiesTiny:

	ld	d, 12
	ld	e, 13
	
CopySpriteFramesSetup:

	ld	hl, OAMDATA+2					; move to sprite image byte of sprite 0
	ld	c, 16							; number of sprites to update

CopySpriteFramesLoop:
	
	bit	0, c							; pseudo random element to fish image (not great)
	jr	z, .oddfish
	
.evenfish:

	ld	a, d
	jr	.contfish

.oddfish:
	
	ld	a, e
	
.contfish:

	ld	[hl+], a
	inc	hl
	inc	hl
	inc	hl
	
	dec	c
	jr	nz, CopySpriteFramesLoop 
	
	ret

SetFishiesRandom:

	ld	hl, OAMDATA+2					; move to sprite image byte of sprite 0
	ld	c, 16							; number of sprites to update
	ld	b, 6

setfishiesrandomloop:

	call RandomNumber

	and $03								; isolate first two bits, gives a number between 0 and 3 
										; there are four fish to choose from

	sla	a								; gives us a number from 0-6 (0-3 times 2)
	add	a, b							; add 6 to give a frame number between (6 and 12)

	ld	[hl+], a
	
	ld	de, 3
	add	hl, de
	
	dec	c
	jr	nz, setfishiesrandomloop 

	ret

; ===================================================================================
; ===================================================================================
; ===================================================================================

SetupFish:

	ld	hl, $FF00+__FishAnimData
	ld	de, fishanimdefault
	ld	b, 17
	
.fishanimloopc

	ld	a, [de]
	inc	de
	ld	[hl+], a						; even numbered bytes are current value
	ld	[hl+], a						; odd numbered bytes are reset value
	
	dec	b
	jr	nz, .fishanimloopc
	
	; ===============================================================================

	ld  hl, OAMDATA

	ld	b, 160							; number of bytes of the OAM to clear
	xor	a

EraseSpritesLoop:

	ld	[hl+], a
	dec	b	
	
	jr 	nz, EraseSpritesLoop
	
	; == copy sprite data from ROM to the OAM =======================================

	ld 	b, 0							; clear b
	
	ldh	a, [__NumFish]					; number of fish to show in c
	ld	c, a
	
	sla c								; c = c*2
	sla c								; c = c*2, c now = 4*c = number of bytes per sprite
	
	ld	hl, fishspritedata				; 4 bytes per sprite located in ROM	
	ld	de, OAMDATA
	
	call CopyVB     
	
	; =============================================================
	; =============================================================
	; =============================================================
	
	ld	a, $FF
	ld	[__ProcessCrab], a
	ld	[__ProcessSnail], a
	ld	[__ProcessOctopus], a
	ld	[__ProcessJellyFish], a	

	; =============================================================
	; == clear crab ===============================================
	; =============================================================
	
	ld	hl, crabdelay
	ld	[hl], 2
	ld	hl, $FF00+__CrabCount
	ld	[hl], _crabwaitcount
	
	ld	hl, OAMDATA+140
	xor	a
	ld	[hl+], a						; ycoord
	ld	[hl+], a						; xcoord
	ld	[hl+], a						; sprite
	ld	[hl+], a						; flags clear
	
	; =============================================================
	; == clear octopus ============================================
	; =============================================================
	
	ld	hl, octopusdelay
	ld	[hl], 2
	ld	hl, $FF00+__OctopusCount
	ld	[hl], _octopuswaitcount
	ld	hl, octopusmode
	ld	[hl], 1							; fast move mode
	
	ld	hl, OAMDATA+144
	xor	a
	ld	[hl+], a						; ycoord
	ld	[hl+], a						; xcoord
	ld	[hl+], a						; sprite
	ld	[hl], a							; flags clear

	; =============================================================
	; == clear snail ==============================================
	; =============================================================	
	
	ld	hl, snaildelay
	ld	[hl], 2
	ld	hl, snailcount
	ld	[hl], _snailwaitcount
	
	ld	hl, OAMDATA+148
	xor	a
	ld	[hl+], a						; ycoord
	ld	[hl+], a						; xcoord
	ld	[hl+], a						; sprite
	ld	[hl], a							; flags clear
	
	; =============================================================
	; == clear jellyfish ==========================================
	; =============================================================	
	
	ld	hl, jellyfishdelay
	ld	[hl], 2
	ld	hl, jellyfishcount
	ld	[hl], _jellyfishwaitcount
	
	ld	hl, OAMDATA+152
	xor	a
	ld	[hl+], a						; ycoord
	ld	[hl+], a						; xcoord
	ld	[hl+], a						; sprite
	ld	[hl], a							; flags clear	
	
	; =============================================================
	; == bubbles ==================================================
	; =============================================================

	ld	hl, OAMDATA+$40
	ld	b, 5							; number of bubbles
	
	xor a
	
.clearbubblesloop	
	
	ld	[hl+], a        				; y coordinate
	ld	[hl+], a        				; x coordinate
	ld	[hl+], a						; index to sprite tile, blank sprite
	ld	[hl+], a						; flags
	
	dec	b
	
	jr	nz, .clearbubblesloop
	
	; =============================================================
	; =============================================================

	ld	hl, menuoff  	     			; Get Tile data address
	ld	b, 9	     		  			; 9=number of tiles
	ld	de, $9A20						; Write To Tile RAM

.copymenuitemoff

	ld	a, [hl+]
	ld	[de], a
	inc de
	
	dec b
	
	jr 	nz, .copymenuitemoff	

	ret

; ===================================================================================
; ===================================================================================
; ===================================================================================

RefreshSpritesDeleted:

	ldh	a, [__NumFish]

	sla	a
	sla	a								; multiply by 4 to get offset to deleted fish

	ld	hl, OAMDATA						; point to the beginning of sprite data	
	
	ld	d, 0
	ld	e, a
	
	add	hl, de							; hl points to fish to be deleted

	xor	a
	ld	[hl+], a						; ycoord
	ld	[hl+], a						; xcoord
	ld	[hl], a							; sprite id

	ret
	
; ===================================================================================
; ===================================================================================
; ===================================================================================	

RefreshSpritesAdded:

	ldh	a, [__NumFish]

	dec	a								; gives us a 0-indexed list

	ld	hl, OAMDATA
	
	sla	a						
	sla a								; multiply by 4 (4 bytes per sprite)
	ld	e, a
	ld	d, 0
	add	hl, de							; move to sprites ycoord
	
	ld	b, h							; make a backup of hl
	ld	c, l
	
	ld	hl, fishspritedata
	add	hl, de							; move to sprites ycoord data
	
	ld	d, b							; restore address to de
	ld	e, c

.RSAReady:

	ld	a, [hl+]						; now put the fish on screen
	ld	[de], a
	inc	de
	ld	a, [hl+]
	ld	[de],a
	inc	de
	ld	a, [hl]
	ld	[de], a

	ret

; ===================================================================================
; ===================================================================================
; ===================================================================================

ChangeBackgroundScroll:

	ldh	a, [__MenuItem1Idx]
	
	cp	7
	jr	z, .showcustommap	
	
	sla	a								; x2 = offset from jumptable
	ld	hl, backgroundsjt				; list of jump locations
	
	ld	e, a
	ld	d, 0
	add	hl, de							; add offset to jumptable
	
	ld	a, [hl+]
	ld	b, [hl]
	
	ld	l, a
	ld	h, b
	
	call RLEDecompress					; background now in buffer
	
.showcustommap
	
	ld	b, 16

	ld	de, 4
	
	; =============================================================
	; == disable interrupts, turn off sprites =====================
	; =============================================================
	
	di
	ld	a, %11110001        			; LCD/Window on, sprites off, tiles at $8000
	ldh	[$40], a            			; Main screen at $9800, window at $9C00
	
	; =============================================================
	; == scroll the fishtank down =================================
	; =============================================================
	
.scrollout	

	call WaitVB
	call WaitVB
	call WaitVB
	call WaitVB
	call WaitVB							; far too fast without this delay!

	ldh	a, [$42]
	sub 8
	ldh	[$42], a
	
	dec	b
	jr	nz, .scrollout
	
	; =============================================================
	; == put the new fishtank in place ============================
	; =============================================================
	
	ldh	a, [__MenuItem1Idx]
	cp	7
	jr	nz, .decompressbuffer
	
.CustomMap	
	
	ld	hl, CustomMap
	
	jr	.copydata
	
.decompressbuffer
	
	ld	hl, decompressbuffer			; rledata uncompressed to here

.copydata
	
	ld	bc, 32*16						; 32 cols, 16 rows
	ld	de, $9800
	
	call CopyHVSync 
	
	; =============================================================
	
	call WaveSetup
	
	ld	b, 16

	ld	de, 4	
	
	; =============================================================
	; == scroll the fishtank up ===================================
	; =============================================================
	
.scrollin	

	call WaitVB
	call WaitVB
	call WaitVB
	call WaitVB
	call WaitVB	

	ldh	a, [$42]
	add	8
	ldh	[$42], a

	dec	b
	jr	nz, .scrollin	
	
	; =============================================================
	; == enable interrupts, turn on sprites =======================
	; =============================================================
	
	ld	a, %11110011	       			; LCD/Sprites/Window on, tiles at $8000
	ldh	[$40], a            			; Main screen at $9800, window at $9C00
	ei
	
	ret
	
; ===================================================================================
; ===================================================================================
; ===================================================================================

ChangeBackground:

	ldh	a, [__MenuItem1Idx]
	
	cp	7
	jr	z, .showcustommap
	
	sla	a								; x2 = offset from jumptable
	ld	hl, backgroundsjt				; list of jump locations
	
	ld	e, a
	ld	d, 0
	add	hl, de							; add offset to jumptable
	
	ld	a, [hl+]
	ld	b, [hl]
	
	ld	l, a
	ld	h, b
	
	call RLEDecompress
	
	ld	hl, decompressbuffer			; rledata uncompressed to here
	
	jr	.startcopy
	
.showcustommap	

	ld	hl, CustomMap
	
.startcopy
	
	ld	bc, 32*16						; 32 cols, 16 rows
	ld	de, $9800
	
	call CopyHVSync 

.paflogo
	
	ld	hl, $9C31						; row 18, column 18 
	ld	a, 156
	ld	[hl+], a
	inc a
	ld	[hl+], a
	inc	a
	ld	[hl], a
	
WaveSetup:

	ldh	a, [__MenuItem1Idx]
	
	ld	hl, backgroundtype
	
	ld	b, 0
	ld	c, a
	add	hl, bc
	
	ld	a, [hl]						
	
	or	a
	jr	nz, .darkwaves
	
.daywaves

	ld	a, _firstwavetilel
	ld	hl, $FF00+__wavetile			; setup animating water :)
	ld	[hl+], a						; current tile
	ld	[hl+], a						; first in animation
	ld	[hl], _endwavetilel				; last frame of animation
	
	ret
	
.darkwaves

	ld	a, _firstwavetiled
	ld	hl, $FF00+__wavetile			; setup animating water :)
	ld	[hl+], a						; current tile
	ld	[hl+], a						; first in animation
	ld	[hl], _endwavetiled				; last frame of animation
	
	ret
	
; ===================================================================================
; ===================================================================================
; ===================================================================================	

systemmenu:	
	DB	$E8,$E9,$EA,$00					; >BACK
	DB	$E8,$EB,$EC,$00					; >MENU
	
fishspritedata:	; 4 bytes per sprite
				;   y,  x, spriteID, flags
				DB  50, 50, _fish1frame2, $00 ; 0
				DB  90, 30, _fish2frame2, $20 ; 1 
				DB 110, 90, _fish1frame1, $20 ; 2
				DB  60,122, _fish2frame1, $00 ; 3
				DB 130, 90, _fish1frame2, $00 ; 4
				DB 100, 64, _fish1frame2, $20 ; 5
				DB  40, 46, _fish1frame1, $00 ; 6
				DB  80, 38, _fish2frame1, $20 ; 7
				DB  40, 80, _fish1frame2, $20 ; 8
				DB  90,100, _fish1frame1, $00 ; 9
				DB 130, 40, _fish2frame2, $20 ; 10
				DB  28,120, _fish2frame1, $00 ; 11
				DB  50, 80, _fish1frame2, $00 ; 12
				DB  60, 80, _fish1frame2, $20 ; 13
				DB  74, 42, _fish2frame1, $00 ; 14
				DB 120, 54, _fish1frame1, $20 ; 15
				
menuoff:		DB $00,$00,$00,$00,$00,$00,$00,$00,$00
menu1one:		DB $12,$13,$14,$15,$16,  0,  0,  0 ; 8 byte aligned for speed
menu1two:		DB $17,$18,$19,$1A,$1B,  0,  0,  0
menu1three:		DB $24,$25,$26,$27,$1B,  0,  0,  0
menu1four:		DB $9F,$A0,$A1,$A2,$1B,  0,  0,  0

menu1onelist:	DW m1a,m1b,m1c,m1d,m1e,m1f,m1g,m1h ; 16 byte aligned for speed!
				DW m2a,  0,  0,  0,  0,  0,  0,  0
				DW m3a,m3b,m3c,m3d,m3e,  0,  0,  0
				DW m4a,m4b,m4c,m5c,  0,  0,  0,  0
m1a:			DB $1C,$1D,$1E,$F0			; map1
m1b:			DB $1C,$1D,$1E,$F1			; map2
m1c:			DB $1C,$1D,$1E,$F2			; map3
m1d:			DB $1C,$1D,$1E,$F3			; map4
m1e:			DB $1C,$1D,$1E,$F4			; map5
m1f:			DB $1C,$1D,$1E,$F5			; map6
m1g:			DB $1C,$1D,$1E,$F6			; map7
m1h:			DB $89,$8A,$8B,$1F			; custom
m2a:			DB $00,$00,$00,$00			; fish count
m3a:			DB $3A,$3B,$22,$1F			; fish type: fat
m3b:			DB $3C,$3D,$3E,$1F			; fish type: puffer
m3c:			DB $91,$92,$22,$1F			; fish type: pike
m3d:			DB $93,$94,$22,$1F			; fish type: small
m3e:			DB $3F,$40,$41,$1F			; fish type: random
m4a:			DB $A3,$A4,$22,$1F			; special  : crab
m4b:			DB $A5,$A6,$A7,$A8			; special  : octopus
m4c:			DB $A9,$AA,$22,$1F			; special  : worm
m5c:			DB $AB,$AC,$AD,$1F			; special  : jellyfish

pauseondata:	DB $01,$02,$03				; pauseoff uses menuoff
				
fishanimdefault:DB $04,$05,$03,$03,$04,$05,$04,$05,$03,$05,$04,$05,$03,$04,$04,$03,$05,$04

chestoffsets:	DW   0,  0,  $998E,  0,  0,  $9982,  0
chestoffsetsxy: DB 0,0,0,0,$70,$7A,0,0,0,0,$70,$1A,0,0 

changefishjt:	DW SetFishiesFat,SetFishiesPuffer,SetFishiesPike,SetFishiesTiny,SetFishiesRandom
backgroundsjt:	DW FISHMAP, FISHMAP2, FISHMAP3, FISHMAP4, FISHMAP5, FISHMAP6, FISHMAP7
backgroundtype: DB 0, 0, 0, 1, 1, 0, 0, 0
