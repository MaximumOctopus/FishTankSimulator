; ============================================================================
; =                                                                          =
; = Fish Tank Simulator for GameBoy v2.0                                     =
; = (C) Paul Alan Freshney 1999 - 2023                                       =
; =                                                                          =
; = GameBoy Header                                                           =
; =                                                                          =
; =                                                                          =
; = February 9th 2023                                                        =
; =                                                                          =
; ============================================================================
;
; NB: Program must have a Begin label as this is the start point!
;
; ============================================================================
; ============================================================================
; ============================================================================

	SECTION	"Startup", ROM0[$0000]

RST_00: jp      Begin
	DS	5
RST_08: jp      Begin
	DS	5
RST_10: jp      Begin
	DS	5
RST_18: jp      Begin
	DS	5
RST_20: jp      Begin
	DS	5
RST_28: jp      Begin
	DS	5
RST_30: jp      Begin
	DS	5
RST_38: jp      Begin
	DS	5
    jp  CopySpr         	; VBlank
    DS  5
    reti                    ; LCDC
    DS  7
    jp  Do_Timer	        ; Timer
    DS  5
    reti                    ; Serial
    DS  7
    reti                    ; ????
    DS  7
    DS  $100-$68

    nop
	
    jp  Begin

; ===================================================================================
; == Nintendo Scrolling Title Graphic ===============================================
; ===================================================================================

	DB	$CE,$ED,$66,$66,$CC,$0D,$00,$0B,$03,$73,$00,$83,$00,$0C,$00,$0D
	DB	$00,$08,$11,$1F,$88,$89,$00,$0E,$DC,$CC,$6E,$E6,$DD,$DD,$D9,$99
	DB	$BB,$BB,$67,$63,$6E,$0E,$EC,$CC,$DD,$DC,$99,$9F,$BB,$B9,$33,$3E

; ===================================================================================
; ===================================================================================
; ===================================================================================

    DB  "FISHTANK GB v2.5"              ;Title of the game
    DB  0, 0, 0                         ;Not used
    DB  1                               ;Cartridge type: Rom only
                                        ; 0 - Rom only      3 - ROM+MBC1+RAM+Battery
                                        ; 1 - ROM+MBC1      5 - ROM+MBC2
                                        ; 2 - ROM+MBC1+RAM  6 - ROM+MBC2+Battery
    DB  2                               ;Rom Size:
                                        ; 0 - 256kBit =  32kB =  2 banks
                                        ; 1 - 512kBit =  64kB =  4 banks
                                        ; 2 -   1MBit = 128kB =  8 banks
                                        ; 3 -   2MBit = 256kB = 16 banks
                                        ; 4 -   4MBit = 512kB = 32 banks
    DB  2                               ;Ram Size:
                                        ; 0 - None
                                        ; 1 -  16kBit =  2kB = 1 bank
                                        ; 2 -  64kBit =  8kB = 1 bank
                                        ; 3 - 256kBit = 32kB = 4 banks
    DW  $8080                           ;Manufacturer code:
    DB  2                               ;Version Number
    DB  $00                             ;Complement check
    DW  $0000                           ;Checksum

; ===================================================================================
; ===================================================================================
; ===================================================================================