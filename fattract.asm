; ============================================================================
; =                                                                          =
; = Fish Tank Simulator for GameBoy v2.0                                     =
; = (C) Paul Alan Freshney 1999 - 2023                                       =
; =                                                                          =
; = Attract Mode                                                             =
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
__scrolloffset		EQU $8E				; current item being displayed ($FF8E)
__StartFlashDelay	EQU $8F
__csOne				EQU	$90				; circle sprite index to co-ordinates lookup table
__csTwo				EQU $91
__csThree			EQU	$92				;
__csFour			EQU	$93				;
__AttractData		EQU $94     		; $94-$9E
__PressStart        EQU $9F     		; press start mode

;
; ============================================================================

	SECTION "AttractMode", ROMX, BANK[1]

SetupAttractMode:

	; ============================================================================
	; == set up tiles ============================================================
	; == copies tile from ROM -> RAM decompressing as it goes -> Tile RAM ========
	; ============================================================================

	ld 	hl, MenuTiles     	   			; Get Tile data address
    ld 	de, $D000        	  	  		; Write To Tile RAM

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
	
copyfromRAMtoVRAM:	

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

	xor	a
	ldh	[__scrolloffset], a

	ld  hl, OAMDATA

	ld	b, 160							; number of bytes of the OAM to clear	

.EraseSpritesLoop:

	ld	[hl+], a
	dec	b	
	
	jr 	nz, .EraseSpritesLoop

	ld	c, __AttractData
	xor	a
	ld	d, 5
	ld	b, 8							; FISHTANK sprites

.ClearAttractDataLoop:

	ld	[c], a
	inc	c
	add a, d

	dec b
	jr	nz, .ClearAttractDataLoop
	
	ld	a, $FF
	ld	[c], a							; SIMULATOR sprites control

	; == copy sprite data from ROM to the OAM =======================================

	ld	hl, attractspritedata			; 4 bytes per sprite located in ROM
	ld	bc, 4*17						; 23 sprites
	ld	de, OAMDATA
	
	call CopyVB
   
	xor	a
	ld	b, 15
	ldh	[__csOne], a
	add a, b
	ldh	[__csTwo], a
	add a, b
	ldh	[__csThree], a
	add a, b
	ldh	[__csFour], a	
	
	ld	a, 5
	ldh	[__StartFlashDelay], a			; set delay counter to 5 frames	
   
	ret
	
; ===================================================================================
; ===================================================================================
; ===================================================================================	
	
AttractMode:	

	; ==========================================================================
	; == update circle sprites =================================================
	; ==========================================================================
	
	ld	b, 4							; number of sprites
	
	ld	c, __csOne						; load the current coordinate index for this fish
	ld	hl, OAMDATA+(4*13)				; load sprite address	

	ld	d, $51							
	
nextcirclefish:	
	
	ld	a, [c]							; current sprite's offset to a
	
	dec	d								; load the sprite circle coord index to de, y-coords start at $5000
	ld	e, a							; set a (offset) to address to get ycoord/xcoord pair
	
	ld	a, [de]							; copy y coord from sprite circle coords (in hl)
	ld	[hl+], a
	inc	d
	ld	a, [de]							; copy x coord from sprite circle coords (in hl)
	ld	[hl+], a

	inc hl								; move to flags
	
	ld	a, [c]							; current sprite's offset to a
	
	cp	28								; 90' around the circle
	jr	z, .flipcsright
	
	cp	59								; 270' around the circle
	jr	nz, .continue
	
.flipcsleft

	res	5, [hl]							; unflip sprite in x-axis
	
	jr	.continue
	
.flipcsright

	set	5, [hl]							; flip sprite in x-axis
	
.continue

	inc hl								; sprite, 4 bytes per sprite	(6,3)

	cp 	59								; 59 is last lookup table item
	jr 	z, .resetindex					; either move to next item...

	inc	a								; move to next set of y,x coords
	
	jr 	.savevalue
	
.resetindex:

	xor	a								; ... or go back to the beginning
	
.savevalue:
 
	ld	[c], a							; store the new offset
	inc	c								; move to next sprite's offset
		
	dec	b								; move to next sprite
	
	jr	nz, nextcirclefish				; continue if we still have sprites to process
	
updatescrolltext:	
	
	; ==========================================================================
	; == update scrolly text ===================================================
	; ==========================================================================
	
	ldh	a, [$43]						; animate the scroll text every 1/8 scrolly speed
	or	a								; only update when scrollx = 0
	jr	nz, finishanimating
	
	;ld	hl, scrollytextcopy		
	;ldh	a, [__scrolloffset]

	;ld	b, 0
	;ld	c, a							; c is least significant byte of bc
	;add	hl, bc
	
	ld	h, $C5
	ldh	a, [__scrolloffset]
	ld	l, a
	
	ld	b, 21
	
.animatescrolly:

	ld	a, [hl]
	
	cp 	_fish1frame1					; fish facing left, closed fins
	jr 	z, .animateleftfish
	
	cp 	_fish1frame2					; fish facing right, closed fins
	jr 	z, .animaterightfish
	
	inc	hl								; move to next character
	
	dec	b
	jr 	nz, .animatescrolly
	
	jr	finishanimating
	
.animateleftfish:

	inc	[hl]
	inc	hl

	jr 	.animatescrolly

.animaterightfish:

	dec	[hl]
	inc	hl
	
	jr 	.animatescrolly
	
finishanimating:	
	
	; ==========================================================================
		
	ld	h, $C5							; start of scrolltext is $C500
	ldh	a, [__scrolloffset]
	ld	l, a							; move to a-th byte
	
	ldh	a, [$43]
	
	cp	7
	jr	z, .ResetWindow

	ldh	a, [$43]
	inc	a
	ldh	[$43], a
	jr	.scroll3
	
.ResetWindow:

	xor a
	ldh	[$43], a
	ld de, $99E0
	
	ld b, 21
	
.loop:	
	
.waitVRAM								; copying to VRAM MUST happen during HSync or VSync
	ldh a, [$ff41]
	and 2
	jr nz, .waitVRAM	

	ld	a, [hl+]						; unrolled loop, scroller starts at $99E0 in VRAM
	ld	[de], a
	inc de
	
	dec b
	jr nz, .loop

	ldh	a, [__scrolloffset]
	inc	a
	
	cp	_scrollytextlength				; end of the scroll text
	jr	nz, .scroll2

	xor	a
	
.scroll2:

	ldh	[__scrolloffset], a
	
.scroll3

AttractLogo:

	; ==========================================================================
	; == update FISHTANK logo sprites ==========================================
	; ==========================================================================

	ld	c, __AttractData				; load the current coordinate index for this letter
	ld	hl, OAMDATA						; load sprite address
	ld	b, 59
	
	ld	d, $52							; sinecoords are at $5200

	; == 1 =====================================================================
	
	ld	a, [c]	

	cp 	b								; 59 is last lookup table item
	jr 	z, .resetindex1					; either move to next item...

	inc	a								; move to next set of y coords
	
	jr 	.savevalue1
	
.resetindex1:

	xor	a								; ... or go back to the beginning
	
.savevalue1:
 
	ld	[c], a							; store the new index	
	
	ld 	e, a							; set de to $520a
	
	ld	a, [de]							; copy y coord from sine ycoords (in hl)
	ld	[hl], a	
	
	ld	hl, OAMDATA+4
	
	inc	c
	
	; == 2 =====================================================================
	
	ld	a, [c]	

	cp 	b								; 59 is last lookup table item
	jr 	z, .resetindex2					; either move to next item...

	inc	a								; move to next set of y coords
	
	jr 	.savevalue2
	
.resetindex2:

	xor	a								; ... or go back to the beginning
	
.savevalue2:
 
	ld	[c], a							; store the new index	
	
	ld 	e, a							; set de to $520a
	
	ld	a, [de]							; copy y coord from sine ycoords (in hl)
	ld	[hl], a	
	
	ld	hl, OAMDATA+8
	
	inc	c
	
	; == 3 =====================================================================
	
	ld	a, [c]	

	cp 	b								; 59 is last lookup table item
	jr 	z, .resetindex3					; either move to next item...

	inc	a								; move to next set of y coords
	
	jr 	.savevalue3
	
.resetindex3:

	xor	a								; ... or go back to the beginning
	
.savevalue3:
 
	ld	[c], a							; store the new index	
	
	ld 	e, a							; set de to $520a	
	
	ld	a, [de]							; copy y coord from sine ycoords (in hl)
	ld	[hl], a	
	
	ld	hl, OAMDATA+12
	
	inc	c	
	
	; == 4 =====================================================================
	
	ld	a, [c]	

	cp 	b								; 59 is last lookup table item
	jr 	z, .resetindex4					; either move to next item...

	inc	a								; move to next set of y coords
	
	jr 	.savevalue4
	
.resetindex4:

	xor	a								; ... or go back to the beginning
	
.savevalue4:
 
	ld	[c], a							; store the new index	
	
	ld 	e, a							; set de to $520a		
	
	ld	a, [de]							; copy y coord from sine ycoords (in hl)
	ld	[hl], a	
	
	ld	hl, OAMDATA+16
	
	inc	c	
	
	; == 5 =====================================================================
	
	ld	a, [c]	

	cp 	b								; 59 is last lookup table item
	jr 	z, .resetindex5					; either move to next item...

	inc	a								; move to next set of y coords
	
	jr 	.savevalue5
	
.resetindex5:

	xor	a								; ... or go back to the beginning
	
.savevalue5:
 
	ld	[c], a							; store the new index	
	
	ld 	e, a							; set de to $520a	
	
	ld	a, [de]							; copy y coord from sine ycoords (in hl)
	ld	[hl], a	
	
	ld	hl, OAMDATA+20
	
	inc	c	

	; == 6 =====================================================================
	
	ld	a, [c]	

	cp 	b								; 59 is last lookup table item
	jr 	z, .resetindex6					; either move to next item...

	inc	a								; move to next set of y coords
	
	jr 	.savevalue6
	
.resetindex6:

	xor	a								; ... or go back to the beginning

.savevalue6:
 
	ld	[c], a							; store the new index	
	
	ld 	e, a							; set de to $520a
	
	ld	a, [de]							; copy y coord from sine ycoords (in hl)
	ld	[hl], a	
	
	ld	hl, OAMDATA+24
	
	inc	c	

	; == 7 =====================================================================
	
	ld	a, [c]	

	cp 	b								; 59 is last lookup table item
	jr 	z, .resetindex7					; either move to next item...

	inc	a								; move to next set of y coords
	
	jr 	.savevalue7
	
.resetindex7:

	xor	a								; ... or go back to the beginning
	
.savevalue7:
 
	ld	[c], a							; store the new index	
	
	ld 	e, a							; set de to $520a		
	
	ld	a, [de]							; copy y coord from sine ycoords (in hl)
	ld	[hl], a	
	
	ld	hl, OAMDATA+28
	
	inc	c	

	; == 8 =====================================================================
	
	ld	a, [c]	

	cp 	b								; 59 is last lookup table item
	jr 	z, .resetindex8					; either move to next item...

	inc	a								; move to next set of y coords
	
	jr 	.savevalue8
	
.resetindex8:

	xor	a								; ... or go back to the beginning
	
.savevalue8:
 
	ld	[c], a							; store the new index	
	
	ld 	e, a							; set de to $520a		
	
	ld	a, [de]							; copy y coord from sine ycoords (in hl)
	ld	[hl], a	
		
	; ==========================================================================
	; ==========================================================================
	
MoveSimulatorSprites:

	ld	hl, OAMDATA+33
	ld	d, 0							; clear MSB of de
	
	ld	c, __AttractData+8
	ld	a, [c]

	or	a
	jr	nz, SimulatorLeft

SimulatorRight:	

	ld	a, [hl]
	inc	a
	ld	[hl], a

	ld	e, 4
	add	hl, de

	cp	_maxsimulatorright
	jr	nz, SimulatorRightCont
	
	ld	a, [c]
	cpl
	ld	[c], a
	
SimulatorRightCont:
	
	inc	[hl]
	add	hl, de
	inc	[hl]
	add	hl, de
	inc	[hl]
	add	hl, de
	inc	[hl]

	jr	MoveSimCont

SimulatorLeft:	

	ld	a, [hl]
	dec	a
	ld	[hl], a

	ld	e, 4
	add	hl, de

	cp	_maxsimulatorleft
	jr	nz, SimulatorLeftCont

	ld	a, [c]
	cpl
	ld	[c], a

SimulatorLeftCont:	

	dec	[hl]
	add	hl, de
	dec	[hl]
	add	hl, de
	dec	[hl]
	add	hl, de
	dec	[hl]

MoveSimCont: 

	ldh	a, [__StartFlashDelay] 

	or	a
	jr	z, StartTextFlash

	dec	a
	ldh	[__StartFlashDelay], a

	ret		
	
; ===================================================================================
; ===================================================================================
; ===================================================================================		
	
StartTextFlash:

	ldh	a, [__PressStart]
	
	or	a
	ret	nz

	ld	a, 6
	ldh	[__StartFlashDelay], a			; set delay counter to 6

	ld	de, $9C21						; press start text screen offset
	ld	a, [de]
	
	or	a								; tile ID of "off" sprites
	jr	z, pressstarton
	
.pressstartoff:
	
	ld hl, $9C21
	ld b, 4
	
.loop:
	
.waitVRAM								; copying to VRAM MUST happen during HSync or VSync
	ldh a, [$ff41]
	and 2
	jr nz, .waitVRAM
	
	xor a
	ld	[hl+], a
	ld	[hl+], a

	dec b
	jr nz, .loop
	
	ret
	
pressstarton:	
	
	ld	hl, pressstarttext
	dec	de

	ld b, 7
	
.loop:
	
.waitVRAM								; copying to VRAM MUST happen during HSync or VSync
	ldh a, [$ff41]
	and 2
	jr nz, .waitVRAM
	
	ld	a, [hl+]
	ld	[de], a
	inc	de

	dec b
	jr nz, .loop

	ret
	
; ===================================================================================
; ===================================================================================
; ===================================================================================	
	
ChangeMenuTo:

	ldh	a, [__PressStart]
	
	swap a
	sra	a
	
	ld	d, 0
	ld	e, a
	
	ld	hl, pressstarttext
	add	hl, de
	ld	de, $9C20
	
	ld b, 7
	
.loop:
	
.waitVRAM								; copying to VRAM MUST happen during HSync or VSync
	ldh a, [$ff41]
	and 2
	jr nz, .waitVRAM
	
	ld	a, [hl+]
	ld	[de], a
	inc	de

	dec b
	jr nz, .loop
	
	ret

; ===================================================================================
; ===================================================================================
; ===================================================================================

scrollytextdata:DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ;  20
				DB _CR,$00, _P, _A, _U, _L,$00, _A,$00, _F, _R, _E, _S, _H, _N, _E, _Y,$00, _2, _0 ;  40
				DB  _2, _3,$00,$06,$00,$07,$00,$06,$00, _W, _W, _W,_DT, _F, _R, _E, _S, _H, _N, _E ;  60
				DB  _Y,_DT, _O, _R, _G,$00,$06,$00,$07,$00,$06,$00, _H, _E, _L, _L, _O,$00, _T, _O ;  80
				DB $00, _T, _H, _E,$00, _D, _E, _V, _E, _L, _O, _P, _M, _E, _N, _T,$00, _C, _A, _T ; 100
				DB  _S,$00, _R, _U, _T, _H, _E, _R, _F, _O, _R, _D,$00, _F, _R, _E, _E, _M, _A, _N ; 120
				DB $00, _A, _N, _D,$00, _M, _A, _X, _W, _E, _L, _L,$00,$06,$00,$07,$00,$06,$00, _U ; 140
				DB  _L, _T, _I, _M, _A, _T, _E,$00, _G, _A, _M, _E, _B, _O, _Y,$00, _F, _I, _S, _H ; 160
				DB  _T, _A, _N, _K,$00, _S, _I, _M, _U, _L, _A, _T, _O, _R,$00,$06,$00,$07,$00,$06 ; 180
				DB $00, _1, _2,_SL, _0, _2,_SL, _2, _0, _2, _3,$00,$06,$00,$07,$00,$06,$00,$00,$00 ; 200
				DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 220
				DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FF             ; 240
				
pressstarttext: DB   0,$29,$2A,$2B,$2C,$2D,$2E, 0
				DB   2,$1A,$1B,$1C,$1D,$1E,  0, 0
				DB   2,$1F,$20,$21,$22,$23,$24, 0
				DB   2,$25,$26,$27,$28,  0,  0, 0
				DB   2,$5B,$5C,$5D,$5E,  0,  0, 0

	SECTION "OptYData", ROMX[$5000], BANK[1]

sy: 			; lookup table of y,x coords for a circle of radius 50, at x80,y72
				DB  72,  77,  82,  87, 92, 97,101,105,109,112
				DB 115, 118, 120, 121,122,122,122,121,120,118
				DB 115, 112, 109, 105,101, 97, 92, 87, 82, 77 
				DB  72,  67,  62,  57, 52, 47, 43, 39, 35, 32
				DB  29,  26,  24,  23, 22, 22, 22, 23, 24, 26
				DB  29,  32,  35,  39, 43, 47, 52, 57, 62, 67				


	SECTION "OptXData", ROMX[$5100], BANK[1]

sx: ; 			lookup table of y,x coords for a circle of radius 50, at x80,y72
				DB 134,134,133,132,130,127,124,121,117,113
				DB 109,104, 99, 94, 89, 84, 79, 74, 69, 64
				DB  59, 55, 51, 47, 44, 41, 38, 36, 35, 34 
				DB  34, 34, 35, 36, 38, 41, 44, 47, 51, 55
				DB  59, 64, 69, 74, 79, 84, 89, 94, 99,104
				DB 109,113,117,121,124,127,130,132,133,134		
				
	SECTION "SineyData", ROMX[$5200], BANK[1]
				
				; optimisations to code mean that the address of this should always have a low LSB byte of <=194.
sineyaxis:		DB	61, 63, 64, 66, 67, 69, 70, 71, 72, 73, 74, 75, 75, 76, 76, 76, 76, 76, 75, 75
				DB  74, 73, 72, 71, 70, 69, 67, 66, 64, 63, 61, 59, 58, 56, 55, 54, 52, 51, 50, 49
				DB  48, 47, 47, 46, 46, 46, 46, 46, 47, 47, 48, 49, 50, 51, 52, 54, 55, 56, 58, 59
				
attractspritedata: 
				; 4 bytes per sprite
				;   y,  x, spriteID, flags
				DB  50, 56, $12, $00, 52, 64, $13, $00, 54, 72, $14, $00, 56, 80, $15, $00						; FISH
				DB  58, 88, $16, $00, 60, 96, $17, $00, 62,104, $18, $00, 64,112, $19, $00						; TANK
				DB  87, 60, $32, $00, 87, 68, $33, $00, 87, 76, $34, $00, 87, 84, $35, $00, 87, 92, $36, $00	; simulator

circlesprites:
				; 4 bytes per sprite
				;   y,  x, spriteID, flags
				DB  72,134, $06, $20
				DB  72,134, $06, $20
				DB  72,134, $06, $20
				DB  72,134, $06, $20
				
; ===================================================================================
; ===================================================================================
; ===================================================================================	