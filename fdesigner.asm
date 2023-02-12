; ============================================================================
; =                                                                          =
; = Fish Tank Simulator for GameBoy v2.0                                     =
; = (C) Paul Alan Freshney 1999 - 2023                                       =
; =                                                                          =
; = Fish Tank Designer                                                       =
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
__currentontile		EQU $8E				; 
__currentofftile	EQU $8F				; 
__currentpalette    EQU $90				;
__PaletteMode		EQU	$91				; 0 = day, 1 = dark
__MenuItem			EQU $92
__MenuSubItem	    EQU $93
__GridMode			EQU $94

__DPOffTile         EQU $53
__GridTile          EQU $F0

__MaxXAxis          EQU $A2

; ============================================================================

_bouncedelay EQU 250

	SECTION "DesignerMode", ROMX, BANK[4]
	
SetupDesignerMode:	
	
	xor	a
	ldh	[$42], a
	ldh	[$43], a						; reset x and y scroll offsets

	ld  hl, OAMDATA

	ld	b, 160							; number of bytes of the OAM to clear	

.EraseSpritesLoop:

	ld	[hl+], a
	dec	b	
	
	jr 	nz, .EraseSpritesLoop
	
	; ============================================================================
	; == set up tiles ============================================================
	; == copies tile from ROM -> RAM decompressing as it goes -> Tile RAM ========
	; ============================================================================
	
	ld 	hl, DesignerTiles	  			; Get Tile data address
    ld 	de, $D000        	   			; Write To Tile RAM

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

	ld	hl, CustomMap					; copy the current custom screen to RAM
	ld	de, $9800
	ld	bc, 512
	
	call CopyHVSync
	
	ld	hl, OAMDATA						; first sprite is "mouse" cursor
	ld	a, 80
	ld	[hl+], a						; y coord
	ld	[hl+], a						; x coord
	ld	a, $55								
	ld	[hl+], a						; cursor sprite
	ld	[hl], 0							; flags
	
	xor	a
	ldh	[__currentpalette], a
	ldh	[__PaletteMode], a
	ldh [__MenuItem], a
	ldh	[__GridMode], a
	
	call WaitVB
	
	ldh	[__currentofftile], a
	ld	[$9800 + (17*32) + 17], a		; "b" button select tile
	
	ld	a, 1
	ldh	[__MenuSubItem], a

	ld	a, 47
	ldh	[__currentontile], a
	ld	[$9800 + (16*32) + 17], a		; "a" button select tile
	
	ld	a, 41
	ld	[$9800 + (17*32) + 18], a		; "B:" tile
	dec	a
	ld	[$9800 + (16*32) + 18], a		; "A:" tile
	
	call ShowPalette

	ret
	
	; ===================================================================================
	; ===================================================================================
	; ===================================================================================	
	
DesignerLoopEntry:

	ei
	
	ld	de, _bouncedelay							; de is used as a up/down key wait variable
	
	call FadeIn		
	
DesignerLoop:	

	call ReadJoyNoBounce      			; Get Joypad button status, no bouncing of the buttons
	
	ldh	a, [__JoyNew]
	
	and	_key_start
	jp	z, TestSelect

	ldh	a, [__MenuItem]
	
	or	a
	jr	nz, .menuselect
	
.menuon:

	ld	a, 1
	ldh	[__MenuItem], a
	
	call DrawMenu
	
	call WaitForNoKeys

	jr TestSelect

.menuselect:
	
	cp	6
	jr	z, .exitdesigner
	
	cp	5
	jr	z, .exitdesignersave
	
	cp	4
	jr	z, .select
	
	cp	3
	jr	z, .gridtoggle	
	
	cp	2
	jr	z, .clearscreen
	
.menuoff:
	
	xor	a
	ldh	[__MenuItem], a
	
	call ShowPalette

	call WaitForNoKeys	
	
	ld	de, _bouncedelay
	
	jr TestSelect
	
.clearscreen:

	ld	hl, $9800
	ld	de, 512
	
.clearscreenloop:

.waitVRAM								; copying to VRAM MUST happen during HSync or VSync
	ldh a, [$ff41]
	and 2
	jr nz, .waitVRAM

	xor	a
	ld	[hl+], a
	
	dec	de
	
	ld	a, d				            ; Check If de = 0
    or	e
	jr	nz, .clearscreenloop
	
	ld	de, _bouncedelay

	jr TestSelect
	
.select:

	call DChangeBackground
	
	ld	de, _bouncedelay

	jr	TestSelect
	
.gridtoggle:

	call ToggleGrid	
	
	call WaitForNoKeys
	
	ld	de, _bouncedelay

	jr	TestSelect
	
	; ===================================================================================
	
.exitdesignersave:
	
	ld	a, [__GridMode]
	or	a
	jr	z, .contwithoutgridoff
	
	call ToggleGrid
	
.contwithoutgridoff:	
	
	ld	hl, $9800						; copy the current custom screen to RAM
	ld	de, CustomMap
	ld	bc, 512
	
	call CopyHVSync
	
.exitdesigner:	
	
	di

	xor a
	ldh	[__SimulatorMode], a
	
	call FadeOut
	
	; ===================================================================================
	; == give control back to the menu code =============================================
	; ===================================================================================
	
	ret

	; ===================================================================================
	
TestSelect:

	ldh	a, [__JoyNew]
	and _key_select
	jr	z, .iltestup
	
	dec	de
	
	ld	a, d							; once de reaches zero the window can scroll
	or	e		
	jr	nz, .iltestup	
	
	ldh	a, [__currentpalette]
	
	cp	2
	jr	z, .firstpalette
	
.nextpalette:

	inc	a
	
	jr	.updatepalette

.firstpalette:

	xor	a

.updatepalette:
	
	ldh	[__currentpalette], a
	
	call ShowPalette
	
	call WaitForNoKeys
	
	; ===================================================================================
	
.iltestup:
	
	ldh	a, [__JoyNew]
	and	$40
	jr	z, .iltestdown
	
	dec	de
	
	ld	a, d							
	or	e		
	jr	nz, .iltestdown

	ld	de, _bouncedelay	
	
	ldh	a, [__MenuItem]
	
	or	a
	jr	nz, .menuonu
	
	ld	hl, OAMDATA						
	dec	[hl]
	
	jr	.iltestdown
	
.menuonu:

	cp	1
	jr	z, .iltestdown
	
	dec	a
	ldh	[__MenuItem], a
	
	call DrawMenu
	
	call WaitForNoKeys

	; ===================================================================================

.iltestdown:

	ldh	a, [__JoyNew]
	and	$80
	jr	z, .iltestleft
	
	dec	de
	
	ld	a, d							
	or	e
	jr	nz, .iltestleft
	
	ld	de, _bouncedelay	
	
	ldh	a, [__MenuItem]
	
	or	a
	jr	nz, .menuond	
	
	ld	hl, OAMDATA						
	inc	[hl]
	
	jr	.iltestleft
	
.menuond:

	cp	6
	jr	z, .iltestleft
	
	inc	a
	ldh	[__MenuItem], a
	
	call DrawMenu
	
	call WaitForNoKeys
	
	; ===================================================================================
	
.iltestleft:
	
	ldh	a, [__JoyNew]
	and	$20
	jr	z, .iltestright
	
	dec	de
	
	ld	a, d							; once de reaches zero the window can scroll
	or	e		
	jr	nz, .iltestright
	
	ld	de, _bouncedelay	
	
	ldh a, [__MenuItem]
	
	cp	4
	jr	z, .selectleft	
	
	ld	hl, OAMDATA+1					; move the mouse cursor left one
	ld	a, [hl]
	
	cp	8								; only move if >8 pixels in x
	jr	z, .iltestright
	
	dec	[hl]
	
	jr	.iltestright
	
.selectleft:

	ldh	a, [__MenuSubItem]

	cp	1
	jr	z, .iltestright
	
	dec	a
	ldh	[__MenuSubItem], a
	
	call DrawSubMenu
	
	call WaitForNoKeys	

	; ===================================================================================

.iltestright:
	
	ldh	a, [__JoyNew]
	and	$10
	jr	z, .iltesta
	
	dec	de
	
	ld	a, d							
	or	e		
	jr	nz, .iltesta

	ld	de, _bouncedelay
	
	ldh a, [__MenuItem]
	
	cp	4
	jr	z, .selectright

	ld	hl, OAMDATA+1					; move the mouse cursor right one
	ld	a, [hl]
	
	cp	__MaxXAxis						; only move if <$A2 pixels in x
	jr	z, .iltesta

	inc	[hl]
	
	jr	.iltesta
	
.selectright:

	ldh	a, [__MenuSubItem]
	
	cp	8
	jr	z, .iltesta	

	inc	a
	ldh	[__MenuSubItem], a
	
	call DrawSubMenu
	
	call WaitForNoKeys
	
	; ===================================================================================
	
.iltesta:
	
	ldh	a, [__JoyNew]
	and	_key_a
	jr	z, .iltestb
	
	dec	de
	
	ld	a, d							
	or	e		
	jr	nz, .iltestb
	
	; =============================================================
	; == convert mouse pointer x,y coordinates in to tile x,y =====
	; =============================================================
	
	ld	hl, OAMDATA+1
	ld	a, [hl-]
	sub 8								; sprite's x/y coords are + 8
	sra a								; /2 = /2
	sra a								; /2 = /4
	sra a								; /2 = /8	
	
	cp	240								; 240 comes out if y=16, 241 if y=17 (not sure why!)
	jr	c, .contwithaxc
	
.fixvalueaxc:

	sub	224
	
.contwithaxc:
	
	ld	c, a							; actual x-coord in c
	
	ld	a, [hl]
	
	sub 8								; sprite's x/y coords are + 8
	sra a								; /2 = /2
	sra a								; /2 = /4
	sra a								; /2 = /8 - y-coordinate in a
	
	cp	240								; 240 comes out if y=16, 241 if y=17 (not sure why!)
	jr	c, .contwitha
	
.fixvaluea:

	sub	224
	
.contwitha:
	
	ld	b, a							; make a backup of the y-coordinate
	
	sla	a								; x2, two bytes per lookup table item
	
	ld	hl, table32						; lookup table of x*32 values
	ld	d, 0
	ld	e, a							; set de to a*2
	
	add	hl, de							; move to correct lookup item for a*32
	
	ld	e, [hl]							; put value in lookup table to de
	inc	hl								;
	ld	d, [hl]							; value is little endian!
	
	ld	hl, $9800						; start of video RAM
	add	hl, de							; add a*32 to hl
	
	ld	d, 0							; set x-offset to de
	ld	e, c							;
	
	add	hl, de							; now add c to hl, giving tile offset! cool!

	ld	a, b							; restore the y-coordinate
	
	cp	16								; if xcoord >=16 then we picking from the tile palette
	jr	nc, .getnewontile
	
.drawontile:							; draw the current ON tile to the map

	ldh	a, [__currentontile]
	
	cp	248								; shape tiles are 250+
	jr	c, .drawsingletile
	
	; ===================================================================================
	; == Draw shape                                                                    ==
	; ===================================================================================
	
	push hl
	
	sub	248								; 0-indexed array
	
	ld	b, a
	
	ldh	a, [__PaletteMode]
	or	a
	jr	nz, .darkpalette	
	
.lightpalette:
	
	ld	hl, clear						; 0th shape data light palette
	
	jr	.getshapedata
	
.darkpalette:

	ld	hl, cleard						; 0th shape data dark palette
	
.getshapedata:
	
	ld	a, b
	
	swap a								; x16, 16 bytes per shape (last 4 blank)
	
	ld	d, 0
	ld	e, a
	
	add	hl, de							; move to shape data
	
	ld	d, h							; set de to data source
	ld	e, l
	
	pop hl								; restore hl as destination

	call Draw4x3
		
	jr	.pressacont
	
	; ===================================================================================
	
.drawsingletile:
	
	ld	[hl], a
	
	jr	.pressacont
	
.getnewontile:							; make the selected palette tile our new ON tile

.waitVRAM								; copying to VRAM MUST happen during HSync or VSync
	ldh a, [$ff41]
	and 2
	jr nz, .waitVRAM

	ld	a, [hl]
	ld	[$9800 + (16*32) + 17], a		; "a" button selected tile
	
	ldh	[__currentontile], a	
	
.pressacont:
	
	ld	de, _bouncedelay
	
	; ===================================================================================
	
.iltestb:
	
	ldh	a, [__JoyNew]
	and	_key_b
	jr	z, .end
	
	dec	de
	
	ld	a, d							; once de reaches zero the window can scroll
	or	e		
	jr	nz, .end
	
	; =============================================================
	; == convert mouse pointer x,y coordinates in to tile x,y =====
	; =============================================================
	
	ld	hl, OAMDATA+1
	ld	a, [hl-]
	sub 8								; sprite's x/y coords are + 8
	sra a								; /2 = /2
	sra a								; /2 = /4
	sra a								; /2 = /8	
	
	cp	240								; 240 comes out if y=16, 241 if y=17 (not sure why!)
	jr	c, .contwithbxc
	
.fixvaluebxc:

	sub	224
	
.contwithbxc:
	
	ld	c, a
	
	ld	a, [hl+]
	
	sub 8								; sprite's x/y coords are + 8
	sra a								; /2 = /2
	sra a								; /2 = /4
	sra a								; /2 = /8 - y-coordinate in a
	
	cp	240								; 240 comes out if y=16, 241 if y=17 (not sure why!)
	jr	c, .contwithb
	
.fixvalueb:

	sub	224
	
.contwithb:
	
	ld	b, a							; make a backup of the y-coordinate
	
	sla	a								; x2, two bytes per lookup table item
	
	ld	hl, table32						; lookup table of x*32 values
	ld	d, 0
	ld	e, a							; set de to a*2
	
	add	hl, de							; move to correct lookup item for a*32
	
	ld	e, [hl]							; put value in lookup table to de
	inc	hl								;
	ld	d, [hl]							; value is little endian!
	
	ld	hl, $9800						; start of video RAM
	add	hl, de							; add a*32 to hl
	
	ld	d, 0							; set x-offset to de
	ld	e, c							;
	
	add	hl, de							; now add c to hl, giving tile offset! cool!

	ld	a, b							; restore the y-coordinate
	
	cp	16								; if xcoord >=16 then we picking from the tile palette
	jr	nc, .getnewofftile
	
.drawofftile:							; draw the current ON tile to the map
	
	ldh	a, [__currentofftile]
	
	cp	248								; shape tiles are 250+
	jr	c, .drawsingleofftile
	
	; ===================================================================================
	; == Draw shape                                                                    ==
	; ===================================================================================
	
	push hl
	
	sub	248								; 0-indexed array
	
	ld	b, a
	
	ldh	a, [__PaletteMode]
	or	a
	jr	nz, .darkbpalette	
	
.lightbpalette:
	
	ld	hl, clear						; 0th shape data light palette
	
	jr	.getbshapedata
	
.darkbpalette:

	ld	hl, cleard						; 0th shape data dark palette
	
.getbshapedata:
	
	ld	a, b
	
	swap a								; x16, 16 bytes per shape (last 4 blank)
	
	ld	d, 0
	ld	e, a
	
	add	hl, de							; move to shape data
	
	ld	d, h							; set de to data source
	ld	e, l
	
	pop hl								; restore hl as destination

	call Draw4x3
		
	jr	.pressbcont
	
	; ===================================================================================
	
.drawsingleofftile:
		
	ld	[hl], a
	
	jr	.pressbcont
	
.getnewofftile:							; make the selected palette tile our new ON tile

.waitVRAMx								; copying to VRAM MUST happen during HSync or VSync
	ldh a, [$ff41]
	and 2
	jr nz, .waitVRAMx

	ld	a, [hl]
	ld	[$9800 + (17*32) + 17], a		; "b" button selected tile

	ldh	[__currentofftile], a
	
.pressbcont:
	
	ld	de, _bouncedelay			
	
.end	
	
	jp	DesignerLoop
	
	; ===================================================================================
	; ===================================================================================
	; ===================================================================================
	
DesignerMode:

	ret
	
	; ===================================================================================
	; === draws a 4 tiles by 3 tiles block at hl ========================================
	; ===================================================================================	
	
Draw4x3:	; de = source, hl = destination

	ld	bc, 28

	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	
	add	hl, bc							; move to next row
	
	ld	a, h							; high byte of the destination to a
	
	cp	$9A								; exit if draw address >=$9A00
	ret	nc								; this is the palette part of the screen
	
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de	
	
	add	hl, bc							; move to next row
	
	ld	a, h							; high byte of the destination to a
	
	cp	$9A								; exit if draw address >=$9A00
	ret	nc								; this is the palette part of the screen

	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a
	inc	de
	ld	a, [de]
	ld	[hl+], a

	ret
	
	; ===================================================================================
	; ===================================================================================
	; ===================================================================================
	
ShowPalette:							

	ldh	a, [__currentpalette]
	
	swap a
	
	ld	d, 0
	ld	e, a
	
	ldh	a, [__PaletteMode]
	or	a
	jr	nz, .darkpalette
	
.lightpalette:

	ld	hl, palette1
	
	jr	.contpalette

.darkpalette:
	
	ld	hl, palette1dark
	
.contpalette:
	
	add	hl, de							; move to correct palette

	ld	de, $9800 + (16*32)
	
	ld	b, 16
	
.loop:

.waitVRAM								; copying to VRAM MUST happen during HSync or VSync
	ldh a, [$ff41]
	and 2
	jr nz, .waitVRAM

	ld	a, [hl+]
	ld	[de], a
	inc	de
	
	dec	b
	jr	nz, .loop
	
	ld	de, $9800 + (17*32)
	
	ld	b, 16
	
.loop2:

	ld	a, [hl+]
	ld	[de], a
	inc	de
	
	dec	b
	jr	nz, .loop2	
	
	ld	de, _bouncedelay	

	ret
	
; ===================================================================================
; ===================================================================================
; ===================================================================================
	
DrawMenu:

	dec	a
	
	swap a
	
	ld	d, 0
	ld	e, a
	
	ld	hl, menu
	add	hl, de
	
	ld	de, $9800 + (16*32)
	
	ld	b, 16
	
.menuloop:

.waitVRAM								; copying to VRAM MUST happen during HSync or VSync
	ldh a, [$ff41]
	and 2
	jr nz, .waitVRAM

	ld	a, [hl+]
	ld	[de], a
	inc	de
	
	dec	b
	jr	nz, .menuloop
	
	ldh	a, [__MenuItem]
	
	cp	4
	jr	z, DrawSubMenu
	
	xor	a
	jr	contdrawsubmenu
	
DrawSubMenu:

	ldh	a, [__MenuSubItem]

contdrawsubmenu:
	
	swap a
	
	ld	d, 0
	ld	e, a
	
	ld	hl, submenu
	add	hl, de
	
	ld	de, $9800 + (17*32)
	
	ld	b, 16
	
.menuloops:

.waitVRAM								; copying to VRAM MUST happen during HSync or VSync
	ldh a, [$ff41]
	and 2
	jr nz, .waitVRAM

	ld	a, [hl+]
	ld	[de], a
	inc	de
	
	dec	b
	jr	nz, .menuloops
	
	ld	de, _bouncedelay	
	
	ret
	
; ===================================================================================
; ===================================================================================
; ===================================================================================	

DChangeBackground:

	ldh	a, [__MenuSubItem]
	
	dec	a	

	ld	b, a	
	
	; ===================================================================================	
	
	ld	hl, backgroundtype
	
	ld	d, 0
	ld	e, a
	add	hl, de
	
	ld	a, [hl]
	
	ldh	[__PaletteMode], a
	
	ld	a, b
	
	; ===================================================================================
	
	cp	7
	jr	z, .usecustommap
	
	sla	a								; x2 = offset from jumptable
	ld	hl, dbackgroundsjt				; list of jump locations
	
	ld	e, a
	ld	d, 0
	add	hl, de							; add offset to jumptable
	
	ld	a, [hl+]
	ld	b, [hl]
	
	ld	l, a
	ld	h, b
	
	call RLEDecompress
	
	ld	hl, decompressbuffer			; rledata uncompressed to here
	
	jr	.copydata

.usecustommap:

	ld	hl, CustomMap

.copydata:
	
	ld	bc, 32*16						; 32 cols, 16 rows
	ld	de, $9800
	
	call CopyHVSync  
	
	ret
	
; ===================================================================================
; == Waits for key presses to stop ==================================================
; ===================================================================================		
		
WaitForNoKeys:

.loop

	call ReadJoyNoBounce
	
	ldh	a, [__JoyNew]
	
	or	a

	jr	nz, .loop

	ret
	
; ===================================================================================
; == Toggle grid tile in blank tiles ================================================
; ===================================================================================
	
ToggleGrid:

	ld	hl, $9800
	ld	bc, 16*32

	ldh	a, [__GridMode]
	
	or	a
	jr	z, .gridon
	
	ldh	a, [__PaletteMode]
	
	or	a
	jr	z, .gridofflight
	
	ld	d, __DPOffTile					; dark palette "off" tile

	jr	.gridoffloop
	
.gridofflight:

	ld	d, 0							; light palette "off" tile	
	
.gridoffloop:

	ld	a, [hl]
	
	cp	__GridTile
	jr	nz, .gridoffloopcont

.waitVRAM								; copying to VRAM MUST happen during HSync or VSync
	ldh a, [$ff41]
	and 2
	jr nz, .waitVRAM

	ld	[hl], d
	
.gridoffloopcont:	

	inc	hl
	
	dec	bc
	
	ld	a, b            ; Check If BC = 0
    or c
	jr	nz, .gridoffloop

	xor	a
	ldh	[__GridMode], a

	ret
	
	; ===================================================================================

.gridon:

	ldh	a, [__PaletteMode]
	
	or	a
	jr	z, .gridonlight
	
	ld	d, 83							; dark palette "on" tile

	jr	.gridonloop
	
.gridonlight:

	ld	d, 0							; light palette "on" tile
	
.gridonloop:

	ld	a, [hl]
	
	cp	d
	jr	nz, .gridonloopcont

.waitVRAMgo								; copying to VRAM MUST happen during HSync or VSync
	ldh a, [$ff41]
	and 2
	jr nz, .waitVRAMgo

	ld	[hl], __GridTile
	
.gridonloopcont:

	inc	hl
	
	dec	bc
	
	ld	a, b            				; Check If BC = 0
    or c
	jr	nz, .gridonloop
	
	ld	a, 1
	ldh	[__GridMode], a
	
	ret
	
; ===================================================================================
; ===================================================================================
; ===================================================================================
		
palette1:		DB   0,211,212,212,213, 43, 44, 45, 46, 47,  0,  0,248,249,250,254
palette2:		DB  83,209,214,215,210,207,208,141,142, 48, 49,  0,251,252,253,255
palette3:		DB 102,103,104,105,106,107,108,109,110,111,112,113,114,115,  0,  0
palette4:		DB 116,117,118,119,120,121,122,123,124,125,126,127, 66, 67,  0,  0
palette1dark:	DB  83,193,194,194,195,149,150,151,152,153, 83,  0,248,249,250,254
palette2dark:	DB   0,191,196,197,192,189,190,140,142,154,155,  0,251,252,253,255
palette3dark:	DB 102,103,104,105,106,107,108,109,110,111,112,113,114,115,  0,  0
palette4dark:	DB 116,117,118,119,120,121,122,123,124,125,126,127, 66, 67,  0,  0
	
menu:			DB $10,_B_,_A_,_C_,_K_,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
				DB $10,_C_,_L_,_E_,_A_,_R_,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
				DB $10,_G_,_R_,_I_,_D_,  0,_O_,_N_,_SL_,_O_,_F_,_F_,  0,  0,  0,  0	
				DB $10,_S_,_E_,_L_,_E_, _C_,_T_,  0,  0,  0,  0,  0,  0,  0,  0,  0
				DB $10,_S_,_A_,_V_,_E_,_SL_,_E_,_X_,_I_,_T_,  0,  0,  0,  0,  0,  0
				DB $10,_E_,_X_,_I_,_T_,   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
	
submenu:		DB   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
				DB   0, _M_, _A_, _P_,_DT_, _1_,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
				DB   0, _M_, _A_, _P_,_DT_, _2_,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
				DB   0, _M_, _A_, _P_,_DT_, _3_,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
				DB   0, _M_, _A_, _P_,_DT_, _4_,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
				DB   0, _M_, _A_, _P_,_DT_, _5_,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
				DB   0, _M_, _A_, _P_,_DT_, _6_,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
				DB   0, _M_, _A_, _P_,_DT_, _7_,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
				DB   0, _M_, _A_, _P_,_DT_, _C_, _U_, _S_, _T_, _O_, _M_,   0,   0,   0,   0,   0
	
dbackgroundsjt:	DW DFISHMAP, DFISHMAP2, DFISHMAP3, DFISHMAP4, DFISHMAP5, DFISHMAP6, DFISHMAP7
	
; ===================================================================================

table32:		; 32x table lookup	
				DW   0,  32,  64,  96, 128, 160, 192, 224, 256, 288, 320
				DW 352, 384, 416, 448, 480, 512, 544, 576, 608, 640, 672
	
; ===================================================================================
; == light palette block data =======================================================
; ===================================================================================

clear:			DB   0,  0,  0,  0
				DB   0,  0,  0,  0
				DB   0,  0,  0,  0
				DB   0,  0,  0,  0
				
bridge: 		DB 211,212,212,213
				DB 209,214,215,210
				DB 208, 47, 49,207
				DB   0,  0,  0,  0
				
mound:			DB   0, 48, 47,  0
				DB  44, 83, 83, 46
				DB  83, 83, 83, 83
				DB   0,  0,  0,  0
				
leftslope:		DB   0,  0,  0, 49
				DB   0, 48, 44, 83
				DB  43, 83, 83, 83
				DB   0,  0,  0,  0
				
flat:			DB  49, 47, 49, 48
				DB  83, 83, 83, 83
				DB  83, 83, 83, 83
				DB   0,  0,  0,  0
				
rightslope:		DB  48, 47,  0,  0
				DB  83, 83, 46, 49
				DB  83, 83, 83, 83
				DB   0,  0,  0,  0
				
dip:			DB  48,  0,  0, 47
				DB  83, 46, 44, 83
				DB  83, 83, 83, 83
				DB   0,  0,  0,  0
				
block:			DB  83, 83, 83, 83
				DB  83, 83, 83, 83
				DB  83, 83, 83, 83
				DB   0,  0,  0,  0	
	
; ===================================================================================
; == dark palette block data ========================================================
; ===================================================================================

cleard:			DB  83, 83, 83, 83
				DB  83, 83, 83, 83
				DB  83, 83, 83, 83
				DB  83, 83, 83, 83
				
bridged: 		DB 193,194,194,195
				DB 191,196,197,192
				DB 190,153,155,189
				DB   0,  0,  0,  0
				
moundd:			DB  83,154,153, 83
				DB 150,  0,  0,152
				DB   0,  0,  0,  0
				DB   0,  0,  0,  0
				
leftsloped:		DB  83, 83, 83,155
				DB  83,154,150,  0
				DB 149,  0,  0,  0
				DB   0,  0,  0,  0
				
flatd:			DB 155,153,155,154
				DB   0,  0,  0,  0
				DB   0,  0,  0,  0
				DB   0,  0,  0,  0
				
rightsloped:	DB 154,153, 83, 83
				DB   0,  0,152,155
				DB   0,  0,  0,  0
				DB   0,  0,  0,  0

dipd:			DB 154, 83, 83,153
				DB   0,152,150,  0
				DB   0,  0,  0,  0
				DB   0,  0,  0,  0
					
blockd:			DB   0,  0,  0,  0
				DB   0,  0,  0,  0
				DB   0,  0,  0,  0
				DB   0,  0,  0,  0	