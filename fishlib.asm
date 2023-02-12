; ============================================================================
; =                                                                          =
; = Fish Tank Simulator for GameBoy v2.0                                     =
; = (C) Paul Alan Freshney 1999 - 2023                                       =
; =                                                                          =
; = Library Functions                                                        =
; =                                                                          =
; =                                                                          =
; = February 12th 2023                                                       =
; =                                                                          =
; ============================================================================

        SECTION "Library", ROM0

; ===================================================================================
; == ClearSprites *  Clears OAM Table of Sprite =====================================
; ===================================================================================

ClearSprites:
        ld	hl, OAMDATA
        ld  c, $A0
		
.ClearLoop:
        ld	a, $FF                   ; We overwrite OAM memory
        ld  [hl+], a                 ; with $FF to ensure all sprites
        dec c                       ; are placed off screen
        ld  a, c
        cp  $00                     ; Test for end of clear
        jr  nz, .ClearLoop            ; Loop till clear
        ret

; ===================================================================================
;* SetupGB *  Sets the gameboy to some pre-
;*********** defined state, ready for some
;*           coding to be performed. After
;*           this function is called LCD
;*           will be on.
; ===================================================================================

SetupGB:
        xor a	                     ; Reset Value
        ldh [$41], a                 ; Clear LCDC Status
        ldh [$42], a                 ; Clear X and Y Scroll
        ldh [$43], a
		ld	a, %00000000
        ldh [$40], a                 ; LCD Controller = Off
									 ; WindowBank = $9800 (Not used)
									 ; Window = OFF
									 ; BG Chr = $8000
									 ; BG Bank= $9800
									 ; Sprites= 8x8 (Size Assembly, 1=8x16)
									 ; Sprites= Off (Sprites on or off)
									 ; BG     = On

        ld  a, 122+24
        ldh [$4A], a                 ; Window Y Position
        ld  a, 7
        ldh [$4B], a                 ; Window X Position
        
        ld  a, %11100100             ; Set palette to default
        ldh [$47], a
        ldh [$48], a                 ; May as well make sprites
        ldh [$49], a                 ; the same

        ld  hl, SprDMACopyStart
        ld  de, $FF80                ; DMA Copy Routine Address
        ld  bc, SprDMACopyStop-SprDMACopyStart
        call CopyVBLoop

        call ClearSprites

        ld  a, %10000000
        ldh [$40], a                 ; Turn LCD On ONLY - Allows VBlank

		ld	a, $FF
		ld	[$04], a
        ld  a, $00                   ; Setup timer
        ldh [$06], a                 ; 4096 Times per second
        ld  a, 4
        ldh [$07], a                 ; Set timer ok.

        ld  a, %00000000
        ldh [$0F], a                 ; Reset IF flag

        ld  a, %00000101             ; Enable VBlank Interrupt & Timer
        ldh [$FF], a

        ret                          ; End of initial setup

; ===================================================================================
; == CopySpr *  Copies sprite data to OAM table at VBlank ===========================
; ===================================================================================

CopySpr:
        push af
        ld	a, OAMDATA/$100
        jp $FF80                   ; copy routine (which is copied to
                                        ; HRAM due to a flaw in GB).

; The Following (SprDMACopyStart To SprDMACopyStop) is copied to $FF80 by SetupGB

SprDMACopyStart:

        ldh	[$46], a                 ; DMA copy from bank A to OAM
        ld	a, $28

SprDMAWait:
        
		dec a
        jr nz, SprDMAWait           ; 4+12 cycles * 40 = 460 cycles
        pop af

        reti

SprDMACopyStop:

; ===================================================================================
;* CopyVB *  Copies some data during the
;********** VBlank period of the LCD.
; ===================================================================================
;* IN    :       HL = Source
;*               DE = Destination
;*               BC = Amount of Bytes To Copy
; ===================================================================================

CopyVB:

		ldh	a, [$44]       ; Get Raster Position
		cp 144             ; Check for VBlank Start
        jr nz, CopyVB      ; Loop Till In VBlank
		
CopyVBLoop:

        ld	a, [hl+]        ; Get Byte from source + Inc Source
        ld	[de], a         ; Store To Destination
        inc de              ; Move To Next Dest Byte
        dec bc              ; Decrement Count
        ld	a, b            ; Check If BC = 0
        or c
        jr nz, CopyVBLoop   ; Loop till done

        ret
		
; ===================================================================================
;* CopyHVSync   *  Copies some data during the HSync and VSync
;                  Essential when copying to VRAM
; ===================================================================================
;* IN    :       HL = Source
;*               DE = Destination
;*               BC = Amount of Bytes To Copy
; ===================================================================================
	
CopyHVSync:

.waitVRAM								; copying to VRAM MUST happen during HSync or VSync
		ldh a, [$ff41]
		and 2
		jr nz, .waitVRAM
	
        ld	a, [hl+]        ; Get Byte from source + Inc Source
        ld	[de], a         ; Store To Destination
        inc de              ; Move To Next Dest Byte
        dec bc              ; Decrement Count
        ld	a, b            ; Check If BC = 0
        or c
        jr nz, CopyHVSync   ; Loop till done
		
    ret		
		
; ===================================================================================
; == CopyVB optimised for <256 bytes to copy ========================================
; ===================================================================================
;* IN    :       HL = Source
;*               DE = Destination
;*               B  = Amount of Bytes To Copy
; ===================================================================================				
		
CopyVBQ:

		ldh	a, [$44]       ; Get Raster Position
		cp 144             ; Check for VBlank Start
        jr nz, CopyVB      ; Loop Till In VBlank
		
CopyVBQLoop:

        ld	a, [hl+]        ; Get Byte from source + Inc Source
        ld	[de], a         ; Store To Destination
        inc de              ; Move To Next Dest Byte

        dec b	            ; Decrement Count

        jr nz, CopyVBQLoop   ; Loop till done

        ret		

; ===================================================================================
; == WaitVB *  Wait For VBlank Then Return ==========================================
; ===================================================================================

WaitVB:

        ldh	a, [$44]        ; Get Raster Position
        cp 144              ; Check for VBlank Start
        jr nz, WaitVB       ; Loop Till In VBlank
		
        ret

; ===================================================================================
; == ReadJoy *  Reads Joypad Into Global Vars JOYNEW & JOYOLD =======================
; ===================================================================================

ReadJoy:
        ld	a, $20          ; Bit 5
        ldh [$00], a        ; Turn On P15
        ldh a, [$00]
        ldh a, [$00]        ; Wait a few cycles
        cpl                 ; invert a
        and $0F             ; Get Low nibble
        swap a              ; swap nibbles
        ld  b, a
        ld  a, $10          ; Bit 4
        ldh [$00], a        ; Turn On P14
        ldh a, [$00]
        ldh a, [$00]
        ldh a, [$00]
        ldh a, [$00]
        ldh a, [$00]
        ldh a, [$00]        ; Wait a few more cycles
        cpl                 ; invert a
        and $0F             ; Get low nibble
        or 	b               ; join nibbles together for full joy info

        ld  b, a            ; copy joy info
        ldh  a, [__JoyOld]  ; get old info
        xor b               ; toggle w/current button bit
        and b               ; get current bit back
        ldh	[__JoyNew], a	; save joy info
        ld  a, b
        ldh  [__JoyOld], a	; save old info

        ld  a, $30          ; turn on P14 and P15
        ldh [$00], a        ; RESET joypad data
		
        ret
		
ReadJoyNoBounce:
        ld	a, $20          ; Bit 5
        ldh [$00], a        ; Turn On P15
        ldh a, [$00]
        ldh a, [$00]        ; Wait a few cycles
        cpl                 ; invert a
        and $0F             ; Get Low nibble
        swap a              ; swap nibbles
        ld  b, a
        ld  a, $10          ; Bit 4
        ldh [$00], a        ; Turn On P14
        ldh a, [$00]
        ldh a, [$00]
        ldh a, [$00]
        ldh a, [$00]
        ldh a, [$00]
        ldh a, [$00]        ; Wait a few more cycles
        cpl                 ; invert a
        and $0F             ; Get low nibble
        or 	b               ; join nibbles together for full joy info

        ldh  [__JoyNew], a	; save joy info

        ld  a, $30          ; turn on P14 and P15
        ldh [$00], a        ; RESET joypad data
		
        ret		

		; down   - $80
		; up     - $40
		; left   - $20
		; right  - $10
		; start  - $08
		; select - $04
		; b      - $02
		; a      - $01
