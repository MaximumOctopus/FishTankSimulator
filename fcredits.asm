; ============================================================================
; =                                                                          =
; = Fish Tank Simulator for GameBoy v2.0                                     =
; = (C) Paul Alan Freshney 1999 - 2023                                       =
; =                                                                          =
; = Credits                                                                  =
; =                                                                          =
; =                                                                          =
; = February 12th 2023                                                       =
; =                                                                          =
; ============================================================================

	SECTION "CreditsMode", ROMX, BANK[5]

SetupCreditsMode:

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

	ld 	hl, CreditsTiles     	   		; Get Tile data address
    ld 	de, $D000        	  	  		; Write To Tile RAM

.decompress:

	ld	a, [hl+]
	
	cp	_XX								; RLE stream begin, <tilestreamchar>,<byte>,<count>
	jr	z, .rlestream
	
	cp	_StreamEndCredits				; end of data stream
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

	ld a, _StreamEndCredits
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
	
	cp _StreamEndCredits
	jp nz, .copy

	ld	hl, CreditsMap
	
	call RLEDecompress
	
	ld	hl, decompressbuffer	
	ld	bc, 32*32						; 32 rows, 32 columns
	ld	de, $9800						; Setup Main Screen, $9800 is beginning of 'screen RAM' 
	
	call CopyHVSync

	ret
	
	; ===================================================================================
	; ===================================================================================
	; ===================================================================================	
	
CreditsLoopEntry:

	ei
	
	ld	de, 450							; de is used as a up/down key wait variable
	
	call FadeIn		
	
CreditsLoop:

	call ReadJoyNoBounce      			; Get Joypad button status, no bouncing of the buttons

	ldh	a, [__JoyNew]
	and	_key_start						; test start key, exits credits mode
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
	
.iltestup

	ldh	a, [__JoyNew]
	and	_key_up
	jr	z, .iltestdown
	
	dec	de
	
	ld	a, d							; once de reaches zero the window can scroll
	or	e		
	jr	nz, .iltestdown

	ld	de, 450	
	
	ldh	a, [$42]						; scroll the window 1 pixel upwards	
	dec	a								;
	ldh	[$42], a						;

	; ===================================================================================

.iltestdown

	ldh	a, [__JoyNew]
	and	_key_down
	jr	z, .end
	
	dec	de
	
	ld	a, d							; once de reaches zero the window can scroll
	or	e
	jr	nz, .end
	
	ld	de, 450	
	
	ldh	a, [$42]						; scroll the window 1 pixel downwards
	inc	a								;
	ldh	[$42], a						;
	
.end	
	
	jr CreditsLoop
	
	; ===================================================================================
	; ===================================================================================
	; ===================================================================================		
	
CreditsMode:

	ret
	
; ===================================================================================
; ===================================================================================
; ===================================================================================			