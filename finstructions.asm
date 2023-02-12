; ============================================================================
; =                                                                          =
; = Fish Tank Simulator for GameBoy v2.0                                     =
; = (C) Paul Alan Freshney 1999 - 2023                                       =
; =                                                                          =
; = Instructions                                                             =
; =                                                                          =
; =                                                                          =
; = February 12th 2023                                                       =
; =                                                                          =
; ============================================================================

	SECTION "InstructionsMode", ROMX, BANK[3]

SetupInstructionMode:

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
	
	ld 	hl, InstructionsTiles  			; Get Tile data address
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

; ============================================================================

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

	ld	hl, InstructionsMap
	
	call RLEDecompress
	
	ld	hl, decompressbuffer	
	ld	bc, 32*32						; 32 rows, 32 columns
	ld	de, $9800						; Setup Main Screen, $9800 is beginning of 'screen RAM' 
	
	call CopyHVSync

	ret
	
	; ===================================================================================
	; ===================================================================================
	; ===================================================================================	
	
InstructionsLoopEntry:

	ei
	
	ld	de, 512							; de is used as a up/down key wait variable
	
	call FadeIn		
	
InstructionsLoop:

	call ReadJoyNoBounce      			; Get Joypad button status, no bouncing of the buttons

	ldh	a, [__JoyNew]
	and	_key_start						; test start key, exits instructions mode
	jr	z, .iltestup

	xor a
	ldh	[__SimulatorMode], a

	di
	call FadeOut
	
	; ===================================================================================
	; == give control back to the menu code =============================================
	; ===================================================================================
	
	ret
	
	; ===================================================================================
	; == switch in bank 1, contains all attract mode code/data ==========================
	; ===================================================================================
	
	ld	a, $01							; switch to bank 1
	ld	[$2000], a						; activate!
	
	; ===================================================================================	
	; ===================================================================================	
	
	xor	a
	ldh	[$43], a						; clear y-scroll index

	call SetupAttractMode
	call SetMenuBackground
	
	jp	MainLoopEntry

	; ===================================================================================
	
.iltestup:

	ldh	a, [__JoyNew]
	and	_key_up
	jr	z, .iltestdown
	
	dec	de
	
	ld	a, d							; once de reaches zero the window can scroll
	or	e		
	jr	nz, .iltestdown

	ld	de, 512	
	
	ldh	a, [$42]						; scroll the window 1 pixel upwards	
	dec	a								;
	ldh	[$42], a						;

	; ===================================================================================

.iltestdown:

	ldh	a, [__JoyNew]
	and	_key_down
	jr	z, .end
	
	dec	de
	
	ld	a, d							; once de reaches zero the window can scroll
	or	e
	jr	nz, .end
	
	ld	de, 512	
	
	ldh	a, [$42]						; scroll the window 1 pixel downwards
	inc	a								;
	ldh	[$42], a						;
	
.end:
	
	jr InstructionsLoop
	
	; ===================================================================================
	; ===================================================================================
	; ===================================================================================		
	
InstructionsMode:

	ret
	