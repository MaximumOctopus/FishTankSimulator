; ============================================================================
; =                                                                          =
; = Fish Tank Simulator for GameBoy v2.0                                     =
; = (C) Paul Alan Freshney 1999 - 2023                                       =
; =                                                                          =
; = Main, everything starts here                                             =
; =                                                                          =
; =                                                                          =
; = February 12th 2023                                                       =
; =                                                                          =
; ============================================================================

; ============================================================================
; == General Information =====================================================
; ============================================================================

; Controls
; START     : Start Simulator / Return to Menu
; SELECT    : Pause
; A         : Toggle menu
; B         : Activate "special"
; UP/DOWN   : Cycle through menu options
; LEFT/RIGHT: Select from selected menu
; 

; Attract Mode
; Sprites: 0-7: FISHTANK, 8-12: SIMULATOR, 13-16: Circle Fish
; Sprites: 17-22: PRESS START

; Simulator Mode
; Sprites: 0-15: Fish, 16-19: bubbles, 20-23: chest bubbles
; Sprites: 34: octopus, 35: crab, 36: snail, 37: jellyfish

; ============================================================================
; == banks ===================================================================
; ============================================================================

;	0 : Important routines, data
;	1 : Attract mode code
;	2 : Fish tank simulator code, backgrounds, tiles
;	3 : Instructions, code, background and tiles
;   4 : Designer, code and tiles
;   5 : Credits, code and tiles

; ============================================================================
; == offsets for variables in HRAM $FF00 + x =================================
; ============================================================================

__RandomPtr			EQU $89
__SimulatorMode		EQU $8A		; 0 is attract mode, 255 is simulator mode
__PauseMode			EQU $8B		; $00 is on; $FF is off
__JoyNew			EQU	$8C
__JoyOld			EQU	$8D

; ============================================================================
; == constants ===============================================================
; ============================================================================

_XX					EQU $AF	; 
_tilestreamendchar	EQU $F5
_StreamEndCredits   EQU $FE

maxmenuitem 		EQU $03 ; indexed from zero
_maxmenu1item		EQU	$07 ; background options
_maxmenu2item		EQU	$04 ; fish types
_maxmenu4item		EQU $03 ; specials
_bubblesprite		EQU $ED ; tile 237
_burstbubblesprite	EQU $EE ; tile 238
_burstbubblesprite2	EQU	$EF ; tile 239
_blanksprite 		EQU $00 ; tile 85
_maxfish			EQU $10 ; maximum of fish on screen
_maxsimulatorright  EQU  86 ; maximum right xcoord for SIMULATOR sprite
_maxsimulatorleft 	EQU  55 ; maximum left xcoord for SIMULATOR sprite

_scrollytextlength  EQU 200

; == tank - sprite x/y coordinate limits =====================================
_leftsideoftank		EQU  10 ; sprite xcoord of left side of tank
_rightsideoftank	EQU 159 ; sprite xcoord of right side of tank
_topsideoftank		EQU  24 ; sprite ycoord for top side of tank
_bottomsideoftank	EQU 136 ; sprite ycoord for bottom side of tank

; == wave tiles ==============================================================
_firstwavetilel		EQU  50 ; fisrt tile, light
_endwavetilel		EQU  57 ; end tile, light
_firstwavetiled		EQU	 74 ; first tile, dark
_endwavetiled		EQU	 81 ; end tile, dark

; == fish frames =============================================================
_fish1frame1		EQU	  6 ; 
_fish1frame2		EQU	  7 ; 
_fish2frame1		EQU	  8 ;
_fish2frame2		EQU	  9 ;
_fish3frame1		EQU	 10 ;
_fish3frame2		EQU	 11 ;
_fish4frame1		EQU	 12 ;
_fish4frame2		EQU	 13 ;

; == crab frames =============================================================
_crabframe1			EQU	132 ;
_crabframelast		EQU	133 ;
_crabwaitcount		EQU	 20 ;

; == octopus frames ==========================================================
_octopusframe1		EQU	  4 ;
_octopusframelast	EQU	  5 ;
_octopuswaitcount	EQU	 20 ;

; == worm frames =============================================================
_snailframe1		EQU	 14 ;
_snailframelast		EQU	 15 ;
_snailwaitcount		EQU	 30 ;

; == jellyfish frames ========================================================
_jellyfishframe1	EQU	130 ;
_jellyfishframelast	EQU	131 ;
_jellyfishwaitcount	EQU	 20 ;

; == chest frames ============================================================
_chestopen			EQU	143 ;
_chestclosed		EQU	142	;

; ============================================================================
; ============================================================================
	
	include	"characters.asm"			; ASCII -> tile mapping
    include "GBHFish.asm"				; GB header  
    include "fishlib.asm"				; util library
    include "fengine.asm"				; fish movement
	include	"fattract.asm"				; attract mode code
	include	"finstructions.asm" 		; instructions code
	include	"fdesigner.asm" 			; designer code
	include	"fcredits.asm"	 			; designer code
	include "backgrounds_com.asm"       ; compressed backgrounds
	include "fishtiles_com.asm"         ; compressed tiles

; ============================================================================
; ============================================================================
	
	SECTION	"Main", ROM0

Begin:

	di               	    			; Disable interrupts
	ld	sp, $FFF4     	    			; Setup stack
	ld	a, %00000000   	     			; No Interrupts
	ldh	[$FF], a

	call SetupGB        	    		; Set GB to a defined state
	;ei                   	   			; Enable interrupts

	ld	hl, $FF26						; don't use sound, so save some
	ld	[hl],$0							; power consumption ;)
	
	ld	a, 128     						; this sets up the windows y cordinates to be near the bottom of screen
	ldh	[$4A],a
	
	; copy scrolly text data to RAM so we can do some *cool* effects with it
	
	ld 	hl, scrollytextdata
	ld 	bc, _scrollytextlength + 22
	ld 	de, scrollytextcopy
	
	call CopyVBLoop
	
	; ===================================================================================
	; clears the RAM space used by the user-defined fish tank background
	; ===================================================================================
	
	ld hl, CustomMap
	ld bc, 512
	
.clearcustomloop	
	xor a
	ld [hl+], a
	dec bc
    ld	a, b            				; Check If bc = 0
    or	c
	jr nz, .clearcustomloop
	
	; ===================================================================================

	ld	hl, CustomMap
	ld	b, 20
	ld	a, $32
	
.createwaveloop

	ld	[hl+], a
	dec	b
	jr	nz, .createwaveloop
	
	; ===================================================================================

	; set up the startup stuff, the word FISHTANK in sprites

	xor	a
	ldh	[__SimulatorMode], a			; SimulatorMode is now attractmode
	ldh [__PressStart], a				; flashing "press start" text
	
	
	ld	a, $FF
	ldh	[__PauseMode], a				; Pause mode off
	
    call SetupAttractMode

	; ===================================================================================

	ei
	
	ld	hl, $9C00						; top row of status window
	ld	de, $9C20						; bottom row of status window
	ld	b, 20							; bytes to copy
	
.createwindow

.waitVRAM								; copying to VRAM MUST happen during HSync or VSync
	ldh a, [$ff41]
	and 2
	jr nz, .waitVRAM

	ld	a, $01
	ld	[hl+], a						; 
	
	xor	a
	ld	[de], a
	inc de
	
	dec	b
	jr	nz, .createwindow
	
.paflogo

	call WaitVB
	
	ld	hl, $9C31						; row 18, column 18 
	ld	a, 156							; first of three tiles that make the "(C)PAF" graphic

	ld	[hl+], a
	inc a
	ld	[hl+], a
	inc	a
	ld	[hl], a
	
	; ===================================================================================
	
	call SetMenuBackground
	
	; ===================================================================================	
		
	ld	hl, TimerEnable
	set	0, [hl]             			; Start sprite engine

	ld	a, %11110011        			; LCD/Sprites/Window on, tiles at $8000
	ldh	[$40], a            			; Main screen at $9800, window at $9C00
	
	jr	WaitForStart

	; ===================================================================================
	; ===================================================================================
	; == Main Loop ======================================================================
	; ===================================================================================
	; ===================================================================================

ReturnFromModule:

	call RestoreAttractMode

MainLoopEntry:
	
	ei
	
	call FadeIn
	
WaitForStart:
    
	call ReadJoy            			; Get Joypad button status

	ldh	a, [__JoyNew]
	and	_key_start						; test start key, starts simulator mode
	jr	z, .amtestup

	call RandomNumber
	
	ldh	a, [__PressStart]
	
	cp  4
	jr	z, .opencredits
	
	cp	3
	jr	z, .opendesigner
	
	cp	2
	jr	z, .openinstructions
	
	cp	1
	jr	nz, .pressstart	

.opensimulator
	
	ld	a, 1
	ldh	[__SimulatorMode], a

	di
	
	call FadeOut
	
	; ===================================================================================
	; == switch in bank 2, contains all simulator code/data =============================
	; ===================================================================================
	
	ld	a, $02							; switch to bank 2
	ld	[$2000], a						; activate!
	
	; ===================================================================================	
	; ===================================================================================		
	
	xor	a
	ldh	[$43], a
		
	call FishTankEngineSetup
	call ChangeBackground
	call SetupFish

	call FishTankEngineLoopEntry
	
	jp ReturnFromModule
	
	; ===================================================================================	
	; ===================================================================================	

.openinstructions

	ld	a, 2
	ldh	[__SimulatorMode], a

	di
	
	call FadeOut
	
	; ===================================================================================
	; == switch in bank 3, contains all instruction code/data ===========================
	; ===================================================================================
	
	ld	a, $03							; switch to bank 2
	
	call PrepareForNewMode
	
	call SetupInstructionMode
	
	call InstructionsLoopEntry
	
	jp ReturnFromModule
	
	; ===================================================================================	
	; ===================================================================================
	
.opencredits

	ld	a, 4
	ldh	[__SimulatorMode], a
	
	di
	
	call FadeOut
	
	; ===================================================================================
	; == switch in bank 5, contains all instruction code/data ===========================
	; ===================================================================================
	
	ld	a, $05							; switch to bank 5
	
	call PrepareForNewMode
	
	call SetupCreditsMode
	
	call CreditsLoopEntry
	
	jp ReturnFromModule
	
	; ===================================================================================	
	; ===================================================================================
	
.opendesigner

	ld	a, 3
	ldh	[__SimulatorMode], a

	di
	
	call FadeOut
	
	; ===================================================================================
	; == switch in bank 3, contains all simulator code/data =============================
	; ===================================================================================
	
	ld	a, $04							; switch to bank 4
	
	call PrepareForNewMode
	
	call SetupDesignerMode
	
	call DesignerLoopEntry
	
	jp ReturnFromModule
	
	; ===================================================================================	
	; ===================================================================================
	
.pressstart

	ld	a, 1
	ldh	[__PressStart], a	
	
	call ChangeMenuTo
	
.amtestup

	ldh	a, [__JoyNew]
	and	_key_up
	jr	z, .amtestdown
	
	ldh	a, [__PressStart]
	
	or	a
	jr	z, .amtestdown
	
	call RandomNumber
	
	ld	hl, $FF00+__PressStart
	dec	[hl]
	
	call ChangeMenuTo

.amtestdown

	ldh	a, [__JoyNew]
	and	_key_down
	jr	z, .amcont
	
	ldh	a, [__PressStart]
	
	cp	4
	jr	z, .amcont
	
	call RandomNumber
	
	ld	hl, $FF00+__PressStart
	inc	[hl]	
	
	call ChangeMenuTo
	
.amcont
	
	jp WaitForStart
	

; ===================================================================================
; ===================================================================================
; ===================================================================================

; bank to set, must be in a

PrepareForNewMode:

	ld	[$2000], a						; activate!
	
	; ===================================================================================	
	; ===================================================================================		
	
	ld	a, %10010011        			; LCD/Sprites/Window on, tiles at $8000
	ldh	[$40], a            			; Main screen at $9800, window at $9C00
	
	ret	

; ===================================================================================
; ===================================================================================
; ===================================================================================

RestoreAttractMode:

	ld	a, $01							; switch to bank 1
	ld	[$2000], a						; activate!
	
	call SetupAttractMode
	call SetMenuBackground
	
	ld	a, %11110011        			; LCD/Sprites/Window off, tiles at $8000
	ldh	[$40], a            			; Main screen at $9800, window at $9C00	
	
	ld 	hl, scrollytextdata
	ld 	bc, _scrollytextlength
	ld 	de, scrollytextcopy				; other modules might trash this part of RAM
	
	call CopyVBLoop	
	
	ret

; ===================================================================================
; ===================================================================================
; ===================================================================================
	
SetMenuBackground:

	ld	hl, $9800
	ld	bc, 32*32						; clear entire buffer
	
.clearscreen

.waitVRAM								; copying to VRAM MUST happen during HSync or VSync
	ldh a, [$ff41]
	and 2
	jr nz, .waitVRAM

	xor	a
	ld	[hl+], a
	
    dec bc              				; Decrement Count
    ld	a, b            				; Check If bc = 0
    or	c
	jr	nz, .clearscreen

	ld hl, waves
	ld bc, 21
	ld de, $9800
	
	call CopyHVSync
	
	ld	hl, $9C00						; top row of status window
	ld	b, 20							; bytes to copy
	
.divider

.waitVRAMd								; copying to VRAM MUST happen during HSync or VSync
	ldh a, [$ff41]
	and 2
	jr nz, .waitVRAMd

	ld	a, $01
	ld	[hl+], a						; 
	
	dec	b
	jr	nz, .divider	
	
	ret

; ===================================================================================
; ===================================================================================
; ===================================================================================
	
TurnMenuOff:

	xor	a
	ldh	[__MenuStatus], a				; set menu to OFF
	ld b, 5
	
	ld	hl, $9C20	
	
.loop:
	
.waitVRAM								; copying to VRAM MUST happen during HSync or VSync
	ldh a, [$ff41]
	and 2
	jr nz, .waitVRAM	
	
	xor	a
	ld	[hl+], a
	ld	[hl+], a
	
	dec b
	jr nz, .loop
	
	ret	

; ===================================================================================
; ===================================================================================
; ===================================================================================
	
Do_Timer:

	push af
	push bc
	push de
	push hl
		
	ldh	a, [__SimulatorMode]

	cp	1
	jr	z, rommodefish
	
	;cp	3
	;jr	z, rommmodedesigner
	
	or	a
	jr	z, rommodeattract
	
rommodeinstructions:

	;call InstructionsMode

	pop hl
	pop de
	pop	bc
	pop	af
	
	reti
	
rommmodedesigner:

	pop hl
	pop de
	pop	bc
	pop	af
	
	reti
	
rommodefish:							; do this bit when in fish move mode
	
	ldh	a, [__PauseMode]	

	or	a
	jr	z, .nofish
	
	call UpdateSprites  				; Call sprite/bubble engine
	call UpdateCrab						; update crab/snail/octopus
	
.nofish	
	
	pop hl
	pop de
	pop	bc
	pop	af
	
	reti	

rommodeattract:
	
	call AttractMode
	
	pop hl
	pop de
	pop	bc
	pop	af
	
	reti

; ===================================================================================
; ===================================================================================
; ===================================================================================
	
FadeOut:

	ld	b, 4							; number of palette changes
	ld	hl, fadedata
	
.fadeoutloop:

	call WaitVB
	call WaitVB	

	ld	a, [hl+]
	ldh	[$47], a						; BG palette data
	ldh	[$48], a						; Object Palette 0 
	ldh	[$49], a						; Object Palette 1
	
	dec	b
	jr	nz, .fadeoutloop

	ret
	
	; ===================================================================================
	; ===================================================================================
	; ===================================================================================		
	
FadeIn:

	ld	b, 4							; number of palette changes
	ld	hl, fadedata+3					; end of palette for a fade in
	
.fadeinloop:

	call WaitVB
	call WaitVB	

	ld	a, [hl-]
	ldh	[$47], a						; BG palette data
	ldh	[$48], a						; Object Palette 0 
	ldh	[$49], a						; Object Palette 1
	
	dec	b
	jr	nz, .fadeinloop

	ret
	
	; ===================================================================================
	; ===================================================================================
	; ===================================================================================	
	
RLEDecompress:							; hl contains compressed data address

	ld	de, decompressbuffer
	
.decompress

	ld	a, [hl+]
	
	cp	$FF								; RLE stream begin, $FF,<byte>,<count>
	jr	z, .rlestream
	
	cp	$FE								; end of data stream
	jr	z, .finish
	
	ld	[de], a
	inc	de
	
	jr	.decompress
	
.rlestream
	
	ld	a, [hl+]						; tile id
	ld	b, [hl]							; count
	inc	hl
	
.rlestreamloop

	ld	[de], a
	inc	de
	
	dec	b
	jr	nz, .rlestreamloop
	
	jr	.decompress

.finish
	
	ret
	
	; ===================================================================================
	; ===================================================================================
	; ===================================================================================		
	
RandomNumber:

    ldh	a, [__RandomPtr]
    inc	a
    ldh	[__RandomPtr], a
    ld	de, RandTable
    add	a, e
    ld	e, a
    jr 	nc, .skip
    inc	d
	
.skip:
	
	ld	a, [de]
	
    ret
	
	; ===================================================================================
	; ===================================================================================
	; ===================================================================================

fadedata:		DB $E4,$90,$40,$00
				
spritemenu:
				DB 174,175,176,177,178,  0
				DB 180,181,182,183,184,185
				DB 186,187,188,189,  0,  0
				
RandTable:		DB $3B,$02,$B7,$6B,$08,$74,$1A,$5D,$21,$99,$95,$66,$D5,$59,$05,$42
				DB $F8,$03,$0F,$53,$7D,$8F,$57,$FB,$48,$26,$F2,$4A,$3D,$E4,$1D,$D9
				DB $9D,$DC,$2F,$F5,$92,$5C,$CC,$00,$73,$15,$BF,$B1,$BB,$EB,$9E,$2E
				DB $32,$FC,$4B,$CD,$A7,$E6,$C2,$10,$11,$80,$52,$B2,$DA,$77,$4F,$EC
				DB $13,$54,$64,$ED,$94,$8C,$C6,$9A,$19,$9F,$75,$FA,$AA,$8D,$FE,$91
				DB $01,$23,$07,$C1,$40,$18,$51,$76,$3C,$BD,$2A,$88,$2D,$F1,$8A,$72
				DB $F6,$98,$35,$97,$68,$93,$B3,$0C,$82,$4E,$CB,$39,$D8,$5F,$C7,$D4
				DB $CE,$AE,$6D,$A3,$7C,$6A,$B8,$A6,$6F,$5E,$E5,$1B,$F4,$B5,$3A,$14
				DB $78,$FD,$D0,$7A,$47,$2C,$A8,$1E,$EA,$2B,$9C,$86,$83,$E1,$7B,$71
				DB $F0,$FF,$D1,$C3,$DB,$0E,$46,$1C,$C9,$16,$61,$00,$AD,$36,$81,$F3
				DB $DF,$43,$C5,$B4,$AF,$79,$7F,$AC,$F9,$37,$E7,$0A,$22,$D3,$A0,$5A
				DB $06,$17,$EF,$67,$60,$87,$20,$FF,$45,$D7,$6E,$58,$A9,$B0,$62,$BA
				DB $E3,$0D,$25,$09,$DE,$44,$49,$69,$9B,$65,$B9,$E0,$41,$A4,$6C,$CF
				DB $A1,$31,$D6,$29,$A2,$3F,$E2,$96,$34,$EE,$DD,$C0,$CA,$63,$33,$5B
				DB $70,$27,$F7,$1F,$BE,$12,$B6,$50,$BC,$4D,$28,$C8,$84,$30,$A5,$4C
				DB $AB,$E9,$8E,$E8,$7E,$C4,$89,$8B,$0B,$24,$85,$3E,$38,$04,$D2,$90

waves:			DB $60,$61,$62,$63,$64,$65,$66,$67,$60,$61,$62,$63,$64,$65,$66,$67,$60,$61,$62,$63,$64
			
	; ===================================================================================
	; ===================================================================================
	; ===================================================================================

        SECTION "Variables",WRAM0
		
OAMDATA:		    DS      $A0     ; Used for copying to OAM RAM
TEMPDATA:	      	DB              ; Used in functions when a temp store is needed
TimerEnable: 	   	DB   	       	; Bit 0 = sprite engine off/on
TimerDiv0:	     	DB   	       	; 4096 slowdown for sprites
chestactive:		DB
crabdelay:			DB
octopusmode:		DB
octopusdelay:		DB
jellyfishmode:		DB
jellyfishdelay:		DB
jellyfishcount:		DB				; delay before jellyfish appears
snaildelay:         DB
snailcount:         DB
CustomMap:          DS 512			; 32x16
decompressbuffer:	DS (32*16)+1	; used when decompressing background maps

        SECTION "ScrollyText",WRAM0[$C500]
		
scrollytextcopy:	DS $FF			; aligned to $C500, optimised for speed

	; ===================================================================================
	; ===================================================================================
	; ===================================================================================