; ============================================================================
; =                                                                          =
; = Fish Tank Simulator for GameBoy v2.0                                     =
; = (C) Paul Alan Freshney 1999 - 2023                                       =
; =                                                                          =
; = Background Tiles                                                         =
; =                                                                          =
; =                                                                          =
; = February 12th 2023                                                       =
; =                                                                          =
; ============================================================================
; =                                                                          =
; =  background tiles, compressed										     =
; =  the last entry MUST BE "DB _tileendchar"		                         =
; =                                                                          =
; ============================================================================

	SECTION "MenuTiles", ROM0

MenuTiles: 							; 1217
DB _XX,$00,$14,$FF,$FF,$00,$FF,$FF,$00,$FF,_XX,$00,$05,$08,$08,$04,$0C,$02,$0E,$02
DB $0E,$04,$0C,$08,$08,_XX,$00,$04,$7C,$7C,$82,$82,$BA,$82,$82,$A2,$BA,$BA,$82,$82
DB $7C,$7C,_XX,$00,$04,$06,$0F,$FC,$78,$D6,$DF,$FC,$78,$06,$0F,_XX,$00,$04,$0C,$0E
DB $10,$18,$FC,$7E,$D4,$D8,$FC,$7E,$10,$18,$0C,$0E,$00,$00,$18,$0C,$18,$39,$7F,$7D
DB $FF,$DE,$FF,$FE,$7F,$7D,$18,$39,$18,$0C,$18,$0C,$18,$3A,$7E,$7E,$FE,$DE,$FE,$FE
DB $7E,$7E,$18,$3A,$18,$0C,$38,$10,$38,$7D,$FF,$7D,$FF,$DE,$FF,$7D,$38,$7D,$38,$10
DB $00,$00,$38,$10,$38,$7E,$FE,$7E,$FE,$DE,$FE,$7E,$38,$7E,$38,$10,_XX,$00,$05,$09
DB $BF,$7D,$FE,$DE,$BB,$7D,$00,$01,_XX,$00,$07,$0A,$BE,$7E,$FE,$DE,$BA,$7E,$00,$02
DB _XX,$00,$08,$30,$24,$7C,$78,$28,$74,_XX,$00,$0A,$30,$28,$78,$78,$20,$78,_XX,$00
DB $06,$03,$03,$04,$04,_XX,$05,$06,$04,$04,$03,$03,$00,$00,$C0,$C0,$2E,$20,$A0,$AA
DB $20,$2E,$A8,$A8,$28,$28,$C0,$C0,_XX,$00,$04,$EE,$00,$00,$A8,$00,$EC,_XX,$A8,$04
DB _XX,$00,$06,$02,$02,$06,$06,$0C,$0C,$18,$18,$30,$30,$60,$60,$00,$00,$7E,$00,$00
DB $7E,$60,$60,_XX,$78,$04,$60,$60,$00,$60,$60,$00,$7E,$00,$00,$7E,_XX,$18,$08,$00
DB $7E,$7E,$00,$3E,$00,$00,$7E,$60,$60,_XX,$7E,$04,$06,$06,$00,$7E,$7C,$00,$66,$00
DB $00,$66,$66,$66,_XX,$7E,$04,$66,$66,$00,$66,$66,$00,$7E,$00,$00,$7E,_XX,$18,$08
DB $00,$18,$18,$00,$3C,$00,$00,$7E,$66,$66,_XX,$7E,$04,$66,$66,$00,$66,$66,$00,$3C
DB $00,$00,$7E,_XX,$66,$08,$00,$66,$66,$00,$66,$00,$00,$66,$66,$66,_XX,$7C,$04,$66
DB $66,$00,$66,$66,$00,$EE,$EE,$00,$84,$E4,$E4,_XX,$24,$04,$EE,$EE,_XX,$00,$04,$AA
DB $AA,$00,$EA,_XX,$AA,$06,$AE,$AE,_XX,$00,$04,$8E,$8E,$00,$8A,$8E,$8E,_XX,$8A,$04
DB $EA,$EA,_XX,$00,$04,$EE,$EE,$00,_XX,$4A,$07,$4E,$4E,_XX,$00,$04,$E0,$E0,$00,$A0
DB $A0,$A0,$C0,$C0,_XX,$A0,$04,_XX,$00,$04,$EE,$EE,$00,_XX,$4A,$07,$EA,$EA,_XX,$00
DB $04,$EE,$EE,$00,$84,$E4,$E4,_XX,$24,$04,$E4,$E4,_XX,$00,$04,$EA,$EA,$00,$AA,$CA
DB $CA,_XX,$AA,$04,$AE,$AE,_XX,$00,$04,$EE,$EE,$00,_XX,$84,$07,$E4,$E4,_XX,$00,$04
DB $EE,$EE,$00,_XX,$4A,$07,$EE,$EE,_XX,$00,$04,$EE,$EE,$00,$A8,$AE,$AE,_XX,$A2,$04
DB $AE,$AE,_XX,$00,$04,$CE,$CE,$00,$A8,$AC,$AC,_XX,$A8,$04,$CE,$CE,_XX,$00,$04,$EE
DB $EE,$00,$84,$E4,$E4,_XX,$24,$04,$EE,$EE,_XX,$00,$04,$EE,$EE,$00,$8A,$8A,$8A,_XX
DB $AA,$04,$EA,$EA,_XX,$00,$04,$EE,$EE,$00,$8A,$CC,$CC,_XX,$8A,$04,$EA,$EA,_XX,$00
DB $04,$2E,$2E,$20,$2A,$2E,$2E,_XX,$28,$04,$20,$20,$3F,$3F,$00,$00,$EE,$EE,$00,$A8
DB $CC,$CC,$A8,$A8,$AE,$AE,$00,$00,$FF,$FF,$00,$00,$EE,$EE,$00,$88,$EE,$EE,$22,$22
DB $EE,$EE,$00,$00,$FF,$FF,$00,$00,$3B,$3B,$00,$21,$39,$39,$09,$09,$39,$39,$00,$00
DB $FF,$FF,$00,$00,$BB,$BB,$00,$2A,$3B,$3B,_XX,$2A,$04,$00,$00,$FF,$FF,$00,$00,$BA
DB $BA,$02,$92,$12,$12,_XX,$92,$04,$02,$02,$FE,$FE,_XX,$00,$04,$28,$00,$7C,$00,$7C
DB $00,$38,$00,$10,_XX,$00,$05,$6C,$00,$FE,$00,$FE,$00,$FE,$00,$7C,$00,$38,$00,$10
DB _XX,$00,$0D,_XX,$18,$04,$00,$00,$3B,$3B,$00,$21,$39,$39,$09,$09,$3B,$3B,$00,$00
DB $BF,$7F,$00,$00,$AA,$AA,$00,$3A,_XX,$2A,$04,$AB,$AB,$00,$00,$FF,$FF,$00,$00,$A3
DB $A3,$00,$A2,$A3,$A3,$A2,$A2,$BA,$BA,$00,$00,$FF,$FF,$00,$00,$BB,$BB,$00,_XX,$92
DB $05,$93,$93,$00,$00,$FF,$FF,$00,$00,$B8,$B8,$00,$A8,$B0,$B0,_XX,$A8,$04,$00,$00
DB $FA,$FC,$00,$00,$18,$00,$00,$38,_XX,$18,$08,_XX,$3C,$04,$7E,$00,$00,$7E,$06,$06
DB $7E,$7E,$60,$60,_XX,$7E,$07,$00,$00,$7E,$06,$06,$3E,$3E,$06,$06,_XX,$7E,$06,$66
DB $00,$00,$66,_XX,$7E,$04,_XX,$06,$08,$7E,$00,$00,$7E,$60,$60,$7E,$7E,$06,$06,_XX
DB $7E,$07,$00,$00,$7E,$60,$60,$7E,$7E,$66,$66,_XX,$7E,$07,$00,$00,$7E,$06,$06,_XX
DB $1E,$04,_XX,$06,$06,$7E,$00,$00,$7E,$66,$66,$7E,$7E,$66,$66,_XX,$7E,$07,$00,$00
DB $7E,$66,$66,$7E,$7E,_XX,$06,$08,$7E,$00,$00,$7E,_XX,$66,$06,_XX,$7E,$06,$3C,$00
DB $00,$7E,$66,$66,_XX,$7E,$04,_XX,$66,$06,$7C,$00,$00,$7E,$66,$66,_XX,$7C,$04,$66
DB $66,$7E,$7E,$7C,$7C,$7E,$00,$00,$7C,_XX,$60,$08,$7C,$7C,$7E,$7E,$7C,$00,$00,$7E
DB _XX,$66,$08,$7E,$7E,$7C,$7C,$7E,$00,$00,$7E,$60,$60,_XX,$78,$04,$60,$60,_XX,$7E
DB $05,$00,$00,$7E,$60,$60,_XX,$78,$04,_XX,$60,$06,$7E,$00,$00,$7E,$60,$60,_XX,$6E
DB $04,$66,$66,_XX,$7E,$04,$66,$00,$00,$66,$66,$66,_XX,$7E,$04,_XX,$66,$06,$7E,$00
DB $00,$7E,_XX,$18,$08,_XX,$7E,$05,$00,$00,$7E,_XX,$18,$08,_XX,$78,$04,$66,$00,$00
DB $66,$66,$66,_XX,$7C,$04,_XX,$66,$06,$60,$00,$00,_XX,$60,$09,_XX,$7E,$04,$66,$00
DB $00,$7E,$7E,$7E,_XX,$66,$0A,$3C,$00,$00,$7E,_XX,$66,$0C,$3C,$00,$00,$7E,_XX,$66
DB $08,$7E,$7E,$3C,$3C,$7E,$00,$00,$7E,$66,$66,_XX,$7E,$04,_XX,$60,$06,$7E,$00,$00
DB $7E,_XX,$66,$06,$6E,$6E,_XX,$7E,$05,$00,$00,$7E,$66,$66,$7C,$7C,$7E,$7E,_XX,$66
DB $06,$7E,$00,$00,$7E,$60,$60,_XX,$7E,$04,$06,$06,_XX,$7E,$05,$00,$00,$7E,_XX,$18
DB $0C,$66,$00,$00,_XX,$66,$09,$7E,$7E,$3C,$3C,$66,$00,$00,_XX,$66,$07,$7E,$7E,$3C
DB $3C,$18,$18,$66,$00,$00,_XX,$66,$07,_XX,$7E,$04,$66,$66,$66,$00,$00,$66,$3C,$3C
DB _XX,$18,$04,$3C,$3C,_XX,$66,$05,$00,$00,$66,$66,$66,$7E,$7E,$3C,$3C,_XX,$18,$06
DB $7E,$00,$00,$7E,$06,$06,$0C,$0C,$18,$18,$30,$30,_XX,$7E,$04,$EE,$EE,$00,$8A,$8C
DB $8C,_XX,$8A,$04,$EA,$EA,_XX,$00,$04,$EC,$EC,$00,$8A,$CA,$CA,_XX,$8A,$04,$EC,$EC
DB _XX,$00,$04,$EE,$EE,$00,_XX,$44,$07,$E4,$E4,_XX,$00,$04,$E0,$E0,$00,$80,$E0,$E0
DB _XX,$20,$04,$E0,$E0,_XX,$00,$08,$FF,$FF,$00,$FF,_XX,$00,$0C,$F0,$00,$0F,_XX,$00
DB $0D,$E1,$00,$1E,_XX,$00,$0D,$C3,$00,$3C,_XX,$00,$0D,$87,$00,$78,_XX,$00,$0D,$0F
DB $00,$F0,_XX,$00,$0D,$1E,$00,$E1,_XX,$00,$0D,$3C,$00,$C3,_XX,$00,$0D,$78,$00,$87
DB _XX,$00,$09
DB _tilestreamendchar

; ================================================================================
; ================================================================================

	SECTION "Tiles", ROMX, BANK[2]

; Start of tile array.
FishTiles::								; 2811
DB _XX,$00,$10,$BB,$BB,$80,$AA,$BB,$BB,_XX,$A2,$04,$80,$80,$FF,$FF,$00,$00,$AB,$AB
DB $00,$AA,$AB,$AB,$A8,$A8,$BB,$BB,$00,$00,$FF,$FF,$00,$00,$BA,$BA,$02,$22,$B2,$B2
DB $A2,$A2,$BA,$BA,$02,$02,$FE,$FE,_XX,$00,$04,$06,$0F,$FC,$78,$D6,$DF,$FC,$78,$06
DB $0F,_XX,$00,$04,$0C,$0E,$10,$18,$FC,$7E,$D4,$D8,$FC,$7E,$10,$18,$0C,$0E,$00,$00
DB $18,$0C,$18,$39,$7F,$7D,$FF,$DE,$FF,$FE,$7F,$7D,$18,$39,$18,$0C,$18,$0C,$18,$3A
DB $7E,$7E,$FE,$DE,$FE,$FE,$7E,$7E,$18,$3A,$18,$0C,$38,$10,$38,$7D,$FF,$7D,$FF,$DE
DB $FF,$7D,$38,$7D,$38,$10,$00,$00,$38,$10,$38,$7E,$FE,$7E,$FE,$DE,$FE,$7E,$38,$7E
DB $38,$10,_XX,$00,$05,$09,$BF,$7D,$FE,$DE,$BB,$7D,$00,$01,_XX,$00,$07,$0A,$BE,$7E
DB $FE,$DE,$BA,$7E,$00,$02,_XX,$00,$08,$30,$24,$7C,$78,$28,$74,_XX,$00,$0A,$30,$28
DB $78,$78,$20,$78,_XX,$00,$06,$10,$10,$08,$08,$10,$10,$18,$18,$08,_XX,$00,$07,_XX
DB $10,$08,$18,$10,$08,$08,_XX,$00,$16,$02,$02,$06,$06,$0C,$0C,$18,$18,$30,$30,$60
DB $60,$00,$00,$FF,$80,$FF,$B3,$D5,$AA,$FF,$B3,$FF,$AA,$FF,$B2,$FF,$80,$FF,$FF,$FF
DB $00,$FF,$BA,$5D,$A2,$FF,$A3,$FF,$A2,$FF,$BA,$FF,$00,$FF,$FF,$FF,$00,$FF,$B3,$55
DB $AA,$FF,$2B,$FF,$AA,$FF,$B2,$FF,$00,$FF,$FF,$FF,$00,$FF,$BB,$55,$AA,$FF,$2B,$FF
DB $AA,$FF,$BA,$FF,$00,$FF,$FF,$FF,$01,$FF,$81,$7F,$81,$FF,$81,$FF,$01,$FF,$01,$FF
DB $01,$FF,$FF,$FF,$80,$FF,$BB,$DE,$A1,$FF,$B1,$FF,$A1,$FF,$A3,$FF,$80,$FF,$FF,$FF
DB $00,$FF,$BA,$DD,$22,$FF,$3B,$FF,$0A,$FF,$BA,$FF,$00,$FF,$FF,$FF,$00,$FF,$80,$7F
DB $80,$FF,$80,$FF,$80,$FF,$80,$FF,$00,$FF,$FF,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF
DB $00,$FF,$00,$FF,$00,$FF,$FF,$FF,$01,$FF,$01,$FF,$01,$FF,$01,$FF,$01,$FF,$01,$FF
DB $01,$FF,$FF,$00,$00,$77,$77,$00,$42,$72,$72,$12,$12,$72,$72,$00,$00,$FF,$FF,$00
DB $00,$54,$54,$00,$54,$74,$74,$24,$24,$27,$27,$00,$00,$FF,$FF,$00,$00,$70,$70,$00
DB $40,$60,$60,$40,$40,$70,$70,$00,$00,$FF,$FF,_XX,$01,$0E,$FF,$FF,_XX,$00,$2E,$FF
DB $FF,_XX,$00,$10,$FF,$80,$FF,$BB,$DE,$A1,$FF,$B1,$FF,$A1,$FF,$A3,$FF,$80,$FF,$FF
DB $FF,$00,$FF,$BA,$DD,$22,$FF,$3B,$FF,$0A,$FF,$BA,$FF,$00,$FF,$FF,$FF,$00,$FF,$BB
DB $6D,$92,$FF,$93,$FF,$92,$FF,$BB,$FF,$00,$FF,$FF,$FF,$00,$FF,$B8,$DF,$20,$FF,$38
DB $FF,$08,$FF,$B8,$FF,$00,$FF,$FF,$00,$00,$0E,$0E,$00,$2A,$0E,$0E,$2A,$2A,$0A,$0A
DB _XX,$00,$06,$0C,$0C,$00,$2A,$0C,$0C,$2A,$2A,$0C,$0C,_XX,$00,$0A,$FF,$00,$00,_XX
DB $FF,$05,$00,$00,$40,$00,$60,$00,$62,$00,$F7,$00,$FF,$00,$FF,$00,$FF,$00,$FF,_XX
DB $00,$05,$01,$00,$3F,$00,$7F,$00,$FF,$00,$FF,$00,$FF,$00,$01,$00,$83,$00,$C3,$00
DB $E7,$00,$FF,$00,$FF,$00,$FF,$00,$FF,_XX,$00,$05,$80,$00,$C0,$00,$E0,$00,$FD,$00
DB $FF,$00,$FF,_XX,$00,$09,$08,$00,$5A,$00,$FF,$00,$FF,_XX,$00,$0B,$04,$00,$4E,$00
DB $FF,_XX,$00,$0B,$20,$00,$B5,$00,$FF,_XX,$00,$07,$F0,$00,$0F,_XX,$00,$0D,$E1,$00
DB $1E,_XX,$00,$0D,$C3,$00,$3C,_XX,$00,$0D,$87,$00,$78,_XX,$00,$0D,$0F,$00,$F0,_XX
DB $00,$0D,$1E,$00,$E1,_XX,$00,$0D,$3C,$00,$C3,_XX,$00,$0D,$78,$00,$87,_XX,$00,$09
DB $77,$77,$00,$45,$67,$67,_XX,$45,$04,$00,$00,$FF,$FF,$00,$00,$70,$70,$00,_XX,$20
DB $07,$00,$00,$FF,$FF,$00,$00,$75,$75,$00,$55,$75,$75,$45,$45,$47,$47,$00,$00,$FF
DB $FF,$00,$00,$77,$77,$00,$44,$66,$66,_XX,$44,$04,$00,$00,$FF,$FF,$00,$00,$77,$77
DB $00,$45,$66,$66,$45,$45,$75,$75,$00,$00,$FF,$FF,$00,$00,$77,$77,$10,$55,$67,$67
DB _XX,$55,$04,$00,$00,$FF,$FF,$00,$00,$76,$76,$00,_XX,$55,$05,$56,$56,$00,$00,$FF
DB $FF,$00,$00,$75,$75,$00,$57,_XX,$55,$04,$75,$75,$00,$00,$FF,$FF,$00,$00,$28,$00
DB $7C,$00,$7C,$00,$38,$00,$10,_XX,$00,$05,$6C,$00,$FE,$00,$FE,$00,$FE,$00,$7C,$00
DB $38,$00,$10,_XX,$00,$6A,$F0,$F0,$0F,$FF,$00,$FF,$00,$FF,_XX,$00,$08,$E1,$E1,$1E
DB $FF,$00,$FF,$00,$FF,_XX,$00,$08,$C3,$C3,$3C,$FF,$00,$FF,$00,$FF,_XX,$00,$08,$87
DB $87,$78,$FF,$00,$FF,$00,$FF,_XX,$00,$08,$0F,$0F,$F0,$FF,$00,$FF,$00,$FF,_XX,$00
DB $08,$1E,$1E,$E1,$FF,$00,$FF,$00,$FF,_XX,$00,$08,$3C,$3C,$C3,$FF,$00,$FF,$00,$FF
DB _XX,$00,$08,$78,$78,$87,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$00,$FF
DB $00,_XX,$FF,$05,$00,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00
DB $FF,_XX,$00,$2B,_XX,$18,$04,_XX,$00,$52,$18,$00,$00,$38,_XX,$18,$08,_XX,$3C,$04
DB $7E,$00,$00,$7E,$06,$06,$7E,$7E,$60,$60,_XX,$7E,$07,$00,$00,$7E,$06,$06,$3E,$3E
DB $06,$06,_XX,$7E,$06,$66,$00,$00,$66,_XX,$7E,$04,_XX,$06,$08,$7E,$00,$00,$7E,$60
DB $60,$7E,$7E,$06,$06,_XX,$7E,$07,$00,$00,$7E,$60,$60,$7E,$7E,$66,$66,_XX,$7E,$07
DB $00,$00,$7E,$06,$06,_XX,$1E,$04,_XX,$06,$06,$7E,$00,$00,$7E,$66,$66,$7E,$7E,$66
DB $66,_XX,$7E,$07,$00,$00,$7E,$66,$66,$7E,$7E,_XX,$06,$08,$7E,$00,$00,$7E,_XX,$66
DB $06,_XX,$7E,$06,$3C,$00,$00,$7E,$66,$66,_XX,$7E,$04,_XX,$66,$06,$7C,$00,$00,$7E
DB $66,$66,_XX,$7C,$04,$66,$66,$7E,$7E,$7C,$7C,$7E,$00,$00,$7C,_XX,$60,$08,$7C,$7C
DB $7E,$7E,$7C,$00,$00,$7E,_XX,$66,$08,$7E,$7E,$7C,$7C,$7E,$00,$00,$7E,$60,$60,_XX
DB $78,$04,$60,$60,_XX,$7E,$05,$00,$00,$7E,$60,$60,_XX,$78,$04,_XX,$60,$06,$7E,$00
DB $00,$7E,$60,$60,_XX,$6E,$04,$66,$66,_XX,$7E,$04,$66,$00,$00,$66,$66,$66,_XX,$7E
DB $04,_XX,$66,$06,$7E,$00,$00,$7E,_XX,$18,$08,_XX,$7E,$05,$00,$00,$7E,_XX,$18,$08
DB _XX,$78,$04,$66,$00,$00,$66,$66,$66,_XX,$7C,$04,_XX,$66,$06,$60,$00,$00,_XX,$60
DB $09,_XX,$7E,$04,$66,$00,$00,$7E,$7E,$7E,_XX,$66,$0A,$3C,$00,$00,$7E,_XX,$66,$0C
DB $3C,$00,$00,$7E,_XX,$66,$08,$7E,$7E,$3C,$3C,$7E,$00,$00,$7E,$66,$66,_XX,$7E,$04
DB _XX,$60,$06,$7E,$00,$00,$7E,_XX,$66,$06,$6E,$6E,_XX,$7E,$05,$00,$00,$7E,$66,$66
DB _XX,$7C,$04,_XX,$66,$06,$7E,$00,$00,$7E,$60,$60,_XX,$7E,$04,$06,$06,_XX,$7E,$05
DB $00,$00,$7E,_XX,$18,$0C,$66,$00,$00,_XX,$66,$09,$7E,$7E,$3C,$3C,$66,$00,$00,_XX
DB $66,$07,$7E,$7E,$3C,$3C,$18,$18,$66,$00,$00,_XX,$66,$07,_XX,$7E,$04,$66,$66,$66
DB $00,$00,$66,$3C,$3C,_XX,$18,$04,$3C,$3C,_XX,$66,$05,$00,$00,$66,$66,$66,$7E,$7E
DB $3C,$3C,_XX,$18,$06,$7E,$00,$00,$7E,$06,$06,$0C,$0C,$18,$18,$30,$30,_XX,$7E,$04
DB _XX,$00,$22,$78,$30,$78,$78,$7C,$74,$7A,$2A,$14,$14,$08,$08,_XX,$00,$04,$3C,$18
DB $78,$38,$7C,$74,$7A,$6A,$55,$14,$0A,$08,$04,_XX,$00,$05,$03,$41,$43,$C2,$24,$3C
DB $3C,$3C,$7E,$5A,$42,$42,_XX,$00,$04,$C0,$82,$C2,$43,$24,$3C,$3C,$3C,$7E,$5A,$84
DB $84,_XX,$00,$0A,$48,$00,$7F,$AA,$FB,$FF,_XX,$00,$06,$04,$00,$01,$54,$7D,$54,$FA
DB $97,$B3,$FF,$20,$00,$02,$20,$00,$92,$64,$92,$01,$54,$7D,$54,$F6,$9B,$9B,$FF,$00
DB $00,$75,$75,$00,_XX,$45,$05,$77,$77,$00,$00,$FF,$FF,$00,$00,$77,$77,$00,$42,$72
DB $72,$12,$12,$72,$72,$00,$00,$FF,$FF,$00,$00,$75,$75,$00,$57,_XX,$55,$04,$75,$75
DB $00,$00,$FF,$FF,$FE,$03,$FF,$13,$7F,$CC,$FF,$8C,$FF,$92,$7F,$A0,$3F,$C4,$9B,$FC
DB $03,$02,$13,$13,$CC,$44,$8C,$88,$92,$92,$20,$A0,$84,$44,$5C,$B8,_XX,$00,$04,$FF
DB $7E,$7E,$81,$FF,$FF,$F7,$99,$F7,$99,$BD,$C3,$7E,$7E,$81,$FF,$81,$FF,$7E,$FF,$FF
DB $FF,$F7,$99,$F7,$99,$BD,$C3,_XX,$00,$12,$77,$77,$10,$52,$72,$72,$42,$42,$47,$47
DB $00,$00,$FF,$FF,$00,$00,$57,$57,$00,$54,$66,$66,$54,$54,$57,$57,$00,$00,$FF,$FF
DB $00,$00,$77,$77,$00,_XX,$22,$05,$27,$27,$00,$00,$FF,$FF,$00,$00,$75,$75,$00,$55
DB $57,$57,_XX,$52,$04,$00,$00,$FF,$FF,$BF,$00,$9F,$00,$9D,$00,$08,_XX,$00,$09,$FF
DB $00,$FF,$00,$FE,$00,$C0,$00,$80,_XX,$00,$07,$FE,$00,$7C,$00,$3C,$00,$18,_XX,$00
DB $09,$FF,$00,$FF,$00,$7F,$00,$3F,$00,$1F,$00,$02,_XX,$00,$05,$FF,$00,$FF,$00,$FF
DB $00,$FF,$00,$F7,$00,$A5,_XX,$00,$05,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FB
DB $00,$B1,$00,$00,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$DF,$00,$4A,$00,$00
DB $00,$03,$03,$04,$04,_XX,$05,$06,$04,$04,$03,$03,$00,$00,$C0,$C0,$2E,$20,$A0,$AA
DB $20,$2E,$A8,$A8,$28,$28,$C0,$C0,_XX,$00,$04,$EE,$00,$00,$A8,$00,$EC,_XX,$A8,$04
DB _XX,$00,$04,$FF,$80,$FF,$BB,$DD,$A2,$FF,$BB,$FF,$8A,$FF,$BA,$FF,$80,$FF,$FF,$FF
DB $00,$FF,$BB,$5D,$A2,$FF,$B2,$FF,$22,$FF,$3B,$FF,$00,$FF,$FF,$FF,$00,$FF,$BB,$ED
DB $12,$FF,$13,$FF,$12,$FF,$BA,$FF,$00,$FF,$FF,$FF,$00,$FF,$A0,$5F,$A0,$FF,$A0,$FF
DB $A0,$FF,$B8,$FF,$00,$FF,$FF,$00,$00,$77,$77,$00,$45,$46,$46,$45,$45,$75,$75,$00
DB $00,$FF,$FF,$00,$00,$76,$76,$00,$55,$76,$76,$55,$55,$56,$56,$00,$00,$FF,$FF,$00
DB $00,$77,$77,$00,_XX,$54,$05,$77,$77,$00,$00,$FF,$FF,$00,$00,$77,$77,$00,_XX,$25
DB $05,$27,$27,$00,$00,$FF,$FF,$00,$00,$75,$75,$00,$55,$75,$75,$45,$45,$47,$47,$00
DB $00,$FF,$FF,$01,$01,$71,$71,$01,$41,$71,$71,$11,$11,$71,$71,$01,$01,$FF,$FF,$00
DB $00,$57,$57,$00,$55,$55,$55,$75,$75,$57,$57,$00,$00,$FF,$FF,$00,$00,$75,$75,$00
DB $57,$65,$65,_XX,$55,$04,$00,$00,$FF,$FF,$00,$00,$77,$77,$00,$14,$16,$16,$14,$14
DB $67,$67,$00,$00,$FF,$FF,$00,$00,$44,$44,$00,_XX,$44,$05,$77,$77,$00,$00,$FF,$FF
DB $00,$00,$50,$50,$00,$50,$70,$70,_XX,$20,$04,$00,$00,$FF,$FF,$EE,$EE,$00,$84,$E4
DB $E4,_XX,$24,$04,$EE,$EE,_XX,$00,$04,$AA,$AA,$00,$EA,_XX,$AA,$06,$AE,$AE,_XX,$00
DB $04,$8E,$8E,$00,$8A,$8E,$8E,_XX,$8A,$04,$EA,$EA,_XX,$00,$04,$EE,$EE,$00,_XX,$4A
DB $07,$4E,$4E,_XX,$00,$04,$E0,$E0,$00,$A0,$A0,$A0,$C0,$C0,_XX,$A0,$04,_XX,$00,$04
DB $EE,$EE,$00,_XX,$4A,$07,$EA,$EA,_XX,$00,$04,$EE,$EE,$00,$84,$E4,$E4,_XX,$24,$04
DB $E4,$E4,_XX,$00,$04,$EA,$EA,$00,$AA,$CA,$CA,_XX,$AA,$04,$AE,$AE,_XX,$00,$04,$EE
DB $EE,$00,_XX,$84,$07,$E4,$E4,_XX,$00,$04,$EE,$EE,$00,_XX,$4A,$07,$EE,$EE,_XX,$00
DB $04,$EE,$EE,$00,$A8,$AE,$AE,_XX,$A2,$04,$AE,$AE,_XX,$00,$04,$CE,$CE,$00,$A8,$AC
DB $AC,_XX,$A8,$04,$CE,$CE,_XX,$00,$04,$EE,$EE,$00,$84,$E4,$E4,_XX,$24,$04,$EE,$EE
DB _XX,$00,$04,$EE,$EE,$00,$8A,$8A,$8A,_XX,$AA,$04,$EA,$EA,_XX,$00,$04,$EE,$EE,$00
DB $8A,$CC,$CC,_XX,$8A,$04,$EA,$EA,_XX,$00,$04,$03,$00,$03,$00,$01,$00,$01,$00,$01
DB $00,$01,_XX,$00,$05,$C0,$00,$C0,$00,$80,$00,$80,$00,$80,$00,$80,_XX,$00,$05,$C0
DB $00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$03,$00,$03,$00,$03
DB $00,$03,$00,$03,$00,$03,$00,$03,$00,$03,$00,$FF,$00,$FC,$00,$F0,$00,$E0,$00,$E0
DB $00,$C0,$00,$C0,$00,$C0,$00,$FF,_XX,$00,$0F,$FF,$00,$3F,$00,$0F,$00,$07,$00,$07
DB $00,$03,$00,$03,$00,$03,$00,$0F,$00,$3F,$00,$7F,$00,$7F,$00,$FF,$00,$FF,$00,$FF
DB $00,$FF,$00,$F0,$00,$FC,$00,$FE,$00,$FE,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF
DB _XX,$00,$8F,$FC,$00,$FC,$00,$FE,$00,$FE,$00,$FE,$00,$FE,$00,$FF,$00,$FF,$00,$3F
DB $00,$3F,$00,$7F,$00,$7F,$00,$7F,$00,$7F,$00,$FF,$00,$FF,$00,$3F,$00,$3F,$00,$3F
DB $00,$3F,$00,$3F,$00,$3F,$00,$3F,$00,$3F,$00,$FC,$00,$FC,$00,$FC,$00,$FC,$00,$FC
DB $00,$FC,$00,$FC,$00,$FC,$00,$00,$00,$03,$00,$0F,$00,$1F,$00,$1F,$00,$3F,$00,$3F
DB $00,$3F,$00,$00,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$00
DB $00,$C0,$00,$F0,$00,$F8,$00,$F8,$00,$FC,$00,$FC,$00,$FC,$00,$F0,$00,$C0,$00,$80
DB $00,$80,_XX,$00,$09,$0F,$00,$03,$00,$01,$00,$01,_XX,$00,$0B,$FF,$00,$FF,$00,$FF
DB $00,$FF,$00,$FF,$00,$FF,$00,$FF,_XX,$00,$F1,$08,$08,$04,$0C,$02,$0E,$02,$0E,$04
DB $0C,$08,$08,_XX,$00,$04,$CE,$CE,$00,$AA,$CE,$CE,_XX,$AA,$04,$CA,$CA,_XX,$00,$04
DB $EA,$EA,$00,$8A,$8C,$8C,_XX,$8A,$04,$EA,$EA,_XX,$00,$04,$AE,$AE,$00,$E8,$AC,$AC
DB _XX,$A8,$04,$AE,$AE,_XX,$00,$04,$EA,$EA,$00,_XX,$AA,$07,$AE,$AE,_XX,$00,$07,$60
DB $40,$90,$00,$90,$00,$60,_XX,$00,$09,$20,$00,$80,$00,$10,$00,$40,_XX,$00,$08,$20
DB $00,$80,$00,$10,$00,$40,_XX,$00,$07,$01,$01,$05,$05,$01,_XX,$05,$07,$01,$01,$FF
DB $FF,$01,$01,$1D,$1D,$01,$05,$1D,$1D,$11,$11,$1D,$1D,$01,$01,$FF,$FF,$01,$01,$1D
DB $1D,$01,$05,$0D,$0D,$05,$05,$1D,$1D,$01,$01,$FF,$FF,$01,$01,$15,$15,$01,$15,$1D
DB $1D,_XX,$05,$04,$01,$01,$FF,$FF,$01,$01,$1D,$1D,$01,$11,$1D,$1D,$05,$05,$1D,$1D
DB $01,$01,$FF,$FF,$01,$01,$1D,$1D,$01,$11,$1D,$1D,$15,$15,$1D,$1D,$01,$01,$FF,$FF
DB $01,$01,$1D,$1D,$01,$05,$0D,$0D,_XX,$05,$04,$01,$01,$FF,$FF,$01,$01,$1D,$1D,$01
DB $15,$1D,$1D,$15,$15,$1D,$1D,$01,$01,$FF,$FF,$01,$01,$1D,$1D,$01,$15,$1D,$1D,_XX
DB $05,$04,$01,$01,$FF,$FF,$01,$01,$5D,$5D,$01,_XX,$55,$05,$5D,$5D,$01,$01,$FF,$FF
DB $01,$01,$45,$45,$01,_XX,$45,$07,$01,$01,$FF,$FF,$01,$01,$5D,$5D,$01,$45,$5D,$5D
DB $51,$51,$5D,$5D,$01,$01,$FF,$FF,$01,$01,$5D,$5D,$01,$45,$4D,$4D,$45,$45,$5D,$5D
DB $01,$01,$FF,$FF,$01,$01,$55,$55,$01,$55,$5D,$5D,_XX,$45,$04,$01,$01,$FF,$FF,$01
DB $01,$5D,$5D,$01,$51,$5D,$5D,$45,$45,$5D,$5D,$01,$01,$FF,$FF,$01,$01,$5D,$5D,$01
DB $51,$5D,$5D,$55,$55,$5D,$5D,$01,$01,$FF,$FF
DB _tilestreamendchar

; ================================================================================
; ================================================================================

	SECTION "InstructionsTiles", ROMX, BANK[3]

InstructionsTiles:						; 863
DB _XX,$00,$10,$FF,$BB,$FF,$A2,$FF,$BB,$FF,$8A,$FF,$BB,$FF,$80,$FF,$FF,$00,$00,$FF
DB $A3,$FF,$22,$FF,$23,$FF,$22,$FF,$BB,$FF,$00,$FF,$FF,$00,$00,$FF,$BB,$FF,$21,$FF
DB $21,$FF,$21,$FF,$B9,$FF,$00,$FF,$FF,$00,$00,$E0,$A0,$E0,$20,$E0,$20,$E0,$20,$E0
DB $20,$E0,$20,$E0,$E0,$00,$00,$FF,$BB,$FF,$A1,$FF,$B9,$FF,$89,$FF,$B9,$FF,$80,$FF
DB $FF,$00,$00,$FF,$BB,$FF,$2A,$FF,$3B,$FF,$2A,$FF,$2A,$FF,$00,$FF,$FF,$00,$00,$FE
DB $BA,$FE,$92,$FE,$12,$FE,$92,$FE,$92,$FE,$02,$FE,$FE,$00,$00,$FE,$BA,$FE,$AA,$FE
DB $BA,$FE,$AA,$FE,$AA,$FE,$82,$FE,$FE,$00,$00,$FE,$B2,$FE,$AA,$FE,$B2,$FE,$AA,$FE
DB $B2,$FE,$82,$FE,$FE,$00,$00,$3F,$2A,$3F,$2A,$3F,$2A,$3F,$2A,$3F,$2E,$3F,$20,$3F
DB $3F,$00,$00,$F8,$E8,$F8,$A8,$F8,$E8,$F8,$88,$F8,$88,$F8,$08,$F8,$F8,$00,$00,$3F
DB $2C,$3F,$2A,$3F,$2A,$3F,$2A,$3F,$2C,$3F,$20,$3F,$3F,$00,$00,$FF,$EA,$FF,$AA,$FF
DB $AA,$FF,$AE,$FF,$EA,$FF,$00,$FF,$FF,$00,$00,$F8,$E8,$F8,$A8,$F8,$A8,$F8,$A8,$F8
DB $A8,$F8,$08,$F8,$F8,$00,$00,$3F,$28,$3F,$28,$3F,$28,$3F,$28,$3F,$2E,$3F,$20,$3F
DB $3F,$00,$00,$FF,$EE,$FF,$88,$FF,$CC,$FF,$88,$FF,$E8,$FF,$00,$FF,$FF,$00,$00,$F8
DB $E8,$F8,$48,$F8,$48,$F8,$48,$F8,$48,$F8,$08,$F8,$F8,$00,$00,$FF,$BB,$FF,$A9,$FF
DB $B1,$FF,$A9,$FF,$AB,$FF,$80,$FF,$FF,$00,$00,$FF,$BA,$FF,$22,$FF,$2B,$FF,$2A,$FF
DB $BA,$FF,$00,$FF,$FF,$00,$00,$FE,$BA,$FE,$92,$FE,$92,$FE,$92,$FE,$92,$FE,$02,$FE
DB $FE,_XX,$00,$04,$FF,$FF,$FF,_XX,$00,$FF,_XX,$00,$FF,_XX,$00,$FF,_XX,$00,$FF,_XX
DB $00,$17,_XX,$18,$04,_XX,$00,$26,$06,$06,$0C,$0C,$18,$18,$30,$30,$60,$60,_XX,$00
DB $0C,_XX,$18,$04,$30,$30,_XX,$00,$04,_XX,$18,$04,$00,$00,_XX,$18,$04,_XX,$00,$04
DB $18,$00,$00,$38,_XX,$18,$06,_XX,$3C,$04,$00,$00,$7E,$00,$00,$7E,$06,$06,$7E,$7E
DB $60,$60,_XX,$7E,$04,$00,$00,$7E,$00,$00,$7E,$06,$06,$3E,$3E,$06,$06,_XX,$7E,$04
DB $00,$00,$66,$00,$00,$66,_XX,$7E,$04,_XX,$06,$06,$00,$00,$7E,$00,$00,$7E,$60,$60
DB $7E,$7E,$06,$06,_XX,$7E,$04,$00,$00,$7E,$00,$00,$7E,$60,$60,$7E,$7E,$66,$66,_XX
DB $7E,$04,$00,$00,$7E,$00,$00,$7E,$06,$06,_XX,$1E,$04,_XX,$06,$04,$00,$00,$7E,$00
DB $00,$7E,$66,$66,$7E,$7E,$66,$66,_XX,$7E,$04,$00,$00,$7E,$00,$00,$7E,$66,$66,$7E
DB $7E,_XX,$06,$06,$00,$00,$7E,$00,$00,$7E,_XX,$66,$06,_XX,$7E,$04,$00,$00,$3C,$00
DB $00,$7E,$66,$66,_XX,$7E,$04,_XX,$66,$04,$00,$00,$7C,$00,$00,$7E,$66,$66,$7C,$7C
DB $66,$66,$7E,$7E,$7C,$7C,$00,$00,$7E,$00,$00,$7C,_XX,$60,$06,$7C,$7C,$7E,$7E,$00
DB $00,$7C,$00,$00,$7E,_XX,$66,$06,$7E,$7E,$7C,$7C,$00,$00,$7E,$00,$00,$7E,$60,$60
DB $78,$78,$60,$60,_XX,$7E,$04,$00,$00,$7E,$00,$00,$7E,$60,$60,_XX,$78,$04,_XX,$60
DB $04,$00,$00,$7E,$00,$00,$7E,$60,$60,$6E,$6E,$66,$66,_XX,$7E,$04,$00,$00,$66,$00
DB $00,$66,$66,$66,$7E,$7E,_XX,$66,$06,$00,$00,$7E,$00,$00,$7E,_XX,$18,$06,_XX,$7E
DB $04,$00,$00,$7E,$00,$00,$7E,_XX,$18,$06,_XX,$78,$04,$00,$00,$66,$00,$00,$66,$66
DB $66,$7C,$7C,_XX,$66,$06,$00,$00,$60,$00,$00,_XX,$60,$07,_XX,$7E,$04,$00,$00,$66
DB $00,$00,$7E,$7E,$7E,_XX,$66,$08,$00,$00,$3C,$00,$00,$7E,_XX,$66,$0A,$00,$00,$3C
DB $00,$00,$7E,_XX,$66,$06,$7E,$7E,$3C,$3C,$00,$00,$7E,$00,$00,$7E,$66,$66,_XX,$7E
DB $04,_XX,$60,$04,$00,$00,$7E,$00,$00,$7E,_XX,$66,$04,$6E,$6E,$7C,$7C,$7A,$7A,$00
DB $00,$7E,$00,$00,$7E,$66,$66,$7C,$7C,$64,$64,_XX,$66,$04,$00,$00,$7E,$00,$00,$7E
DB $60,$60,$7E,$7E,$06,$06,_XX,$7E,$04,$00,$00,$7E,$00,$00,$7E,_XX,$18,$0A,$00,$00
DB $66,$00,$00,_XX,$66,$07,$7E,$7E,$3C,$3C,$00,$00,$66,$00,$00,_XX,$66,$07,$3C,$3C
DB $18,$18,$00,$00,$66,$00,$00,_XX,$66,$05,_XX,$7E,$04,$66,$66,$00,$00,$66,$00,$00
DB $66,$3C,$3C,$18,$18,$3C,$3C,$7E,$7E,$66,$66,$00,$00,$66,$00,$00,$66,$66,$66,$7E
DB $7E,$3C,$3C,_XX,$18,$04,$00,$00,$7E,$00,$00,$7E,$0C,$0C,$18,$18,$30,$30,_XX,$7E
DB $04,$00,$00
DB _tilestreamendchar

; ================================================================================
; ================================================================================

	SECTION "DesignerTiles", ROMX, BANK[4]

; Start of tile array.
DesignerTiles::							; 1657
DB _XX,$00,$10,_XX,$FF,$30,$00,$00,$06,$0F,$FC,$78,$D6,$DF,$FC,$78,$06,$0F,_XX,$00
DB $04,$0C,$0E,$10,$18,$FC,$7E,$D4,$D8,$FC,$7E,$10,$18,$0C,$0E,$00,$00,$18,$0C,$18
DB $39,$7F,$7D,$FF,$DE,$FF,$FE,$7F,$7D,$18,$39,$18,$0C,$18,$0C,$18,$3A,$7E,$7E,$FE
DB $DE,$FE,$FE,$7E,$7E,$18,$3A,$18,$0C,$38,$10,$38,$7D,$FF,$7D,$FF,$DE,$FF,$7D,$38
DB $7D,$38,$10,$00,$00,$38,$10,$38,$7E,$FE,$7E,$FE,$DE,$FE,$7E,$38,$7E,$38,$10,_XX
DB $00,$05,$09,$BF,$7D,$FE,$DE,$BB,$7D,$00,$01,_XX,$00,$07,$0A,$BE,$7E,$FE,$DE,$BA
DB $7E,$00,$02,_XX,$00,$08,$30,$24,$7C,$78,$28,$74,_XX,$00,$0A,$30,$28,$78,$78,$20
DB $78,_XX,$00,$06,$10,$10,$08,$08,$10,$10,$18,$18,$08,_XX,$00,$07,_XX,$10,$08,$18
DB $10,$08,$08,_XX,$00,$16,$02,$02,$06,$06,$0C,$0C,$18,$18,$30,$30,$60,$60,_XX,$00
DB $FF,_XX,$00,$67,$0E,$0E,$00,$2A,$0E,$0E,$2A,$2A,$0A,$0A,_XX,$00,$06,$0C,$0C,$00
DB $2A,$0C,$0C,$2A,$2A,$0C,$0C,_XX,$00,$08,$FF,$00,$00,_XX,$FF,$05,$00,$00,$40,$00
DB $60,$00,$62,$00,$F7,$00,$FF,$00,$FF,$00,$FF,$00,$FF,_XX,$00,$05,$01,$00,$3F,$00
DB $7F,$00,$FF,$00,$FF,$00,$FF,$00,$01,$00,$83,$00,$C3,$00,$E7,$00,$FF,$00,$FF,$00
DB $FF,$00,$FF,_XX,$00,$05,$80,$00,$C0,$00,$E0,$00,$FD,$00,$FF,$00,$FF,_XX,$00,$09
DB $08,$00,$5A,$00,$FF,$00,$FF,_XX,$00,$0B,$04,$00,$4E,$00,$FF,_XX,$00,$0B,$20,$00
DB $B5,$00,$FF,_XX,$00,$07,$F0,$00,$0F,_XX,$00,$0D,$E1,$00,$1E,_XX,$00,$0D,$C3,$00
DB $3C,_XX,$00,$0D,$87,$00,$78,_XX,$00,$0D,$0F,$00,$F0,_XX,$00,$0D,$1E,$00,$E1,_XX
DB $00,$0D,$3C,$00,$C3,_XX,$00,$0D,$78,$00,$87,_XX,$00,$89,$28,$00,$7C,$00,$7C,$00
DB $38,$00,$10,_XX,$00,$05,$6C,$00,$FE,$00,$FE,$00,$FE,$00,$7C,$00,$38,$00,$10,_XX
DB $00,$6A,$F0,$F0,$0F,$FF,$00,$FF,$00,$FF,_XX,$00,$08,$E1,$E1,$1E,$FF,$00,$FF,$00
DB $FF,_XX,$00,$08,$C3,$C3,$3C,$FF,$00,$FF,$00,$FF,_XX,$00,$08,$87,$87,$78,$FF,$00
DB $FF,$00,$FF,_XX,$00,$08,$0F,$0F,$F0,$FF,$00,$FF,$00,$FF,_XX,$00,$08,$1E,$1E,$E1
DB $FF,$00,$FF,$00,$FF,_XX,$00,$08,$3C,$3C,$C3,$FF,$00,$FF,$00,$FF,_XX,$00,$08,$78
DB $78,$87,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$00,$FF,$00,_XX,$FF,$05
DB $00,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,_XX,$00,$13
DB $02,$02,$04,$04,$48,$48,$10,$50,$00,$60,$48,$38,_XX,$00,$0C,_XX,$18,$04,_XX,$00
DB $52,$18,$00,$00,$38,_XX,$18,$08,_XX,$3C,$04,$7E,$00,$00,$7E,$06,$06,$7E,$7E,$60
DB $60,_XX,$7E,$07,$00,$00,$7E,$06,$06,$3E,$3E,$06,$06,_XX,$7E,$06,$66,$00,$00,$66
DB _XX,$7E,$04,_XX,$06,$08,$7E,$00,$00,$7E,$60,$60,$7E,$7E,$06,$06,_XX,$7E,$07,$00
DB $00,$7E,$60,$60,$7E,$7E,$66,$66,_XX,$7E,$07,$00,$00,$7E,$06,$06,_XX,$1E,$04,_XX
DB $06,$06,$7E,$00,$00,$7E,$66,$66,$7E,$7E,$66,$66,_XX,$7E,$07,$00,$00,$7E,$66,$66
DB $7E,$7E,_XX,$06,$08,$7E,$00,$00,$7E,_XX,$66,$06,_XX,$7E,$06,$3C,$00,$00,$7E,$66
DB $66,_XX,$7E,$04,_XX,$66,$06,$7C,$00,$00,$7E,$66,$66,_XX,$7C,$04,$66,$66,$7E,$7E
DB $7C,$7C,$7E,$00,$00,$7C,_XX,$60,$08,$7C,$7C,$7E,$7E,$7C,$00,$00,$7E,_XX,$66,$08
DB $7E,$7E,$7C,$7C,$7E,$00,$00,$7E,$60,$60,_XX,$78,$04,$60,$60,_XX,$7E,$05,$00,$00
DB $7E,$60,$60,_XX,$78,$04,_XX,$60,$06,$7E,$00,$00,$7E,$60,$60,_XX,$6E,$04,$66,$66
DB _XX,$7E,$04,$66,$00,$00,$66,$66,$66,_XX,$7E,$04,_XX,$66,$06,$7E,$00,$00,$7E,_XX
DB $18,$08,_XX,$7E,$05,$00,$00,$7E,_XX,$18,$08,_XX,$78,$04,$66,$00,$00,$66,$66,$66
DB _XX,$7C,$04,_XX,$66,$06,$60,$00,$00,_XX,$60,$09,_XX,$7E,$04,$66,$00,$00,$7E,$7E
DB $7E,_XX,$66,$0A,$3C,$00,$00,$7E,_XX,$66,$0C,$3C,$00,$00,$7E,_XX,$66,$08,$7E,$7E
DB $3C,$3C,$7E,$00,$00,$7E,$66,$66,_XX,$7E,$04,_XX,$60,$06,$7E,$00,$00,$7E,_XX,$66
DB $06,$6E,$6E,_XX,$7E,$05,$00,$00,$7E,$66,$66,_XX,$7C,$04,_XX,$66,$06,$7E,$00,$00
DB $7E,$60,$60,_XX,$7E,$04,$06,$06,_XX,$7E,$05,$00,$00,$7E,_XX,$18,$0C,$66,$00,$00
DB _XX,$66,$09,$7E,$7E,$3C,$3C,$66,$00,$00,_XX,$66,$07,$7E,$7E,$3C,$3C,$18,$18,$66
DB $00,$00,_XX,$66,$07,_XX,$7E,$04,$66,$66,$66,$00,$00,$66,$3C,$3C,_XX,$18,$04,$3C
DB $3C,_XX,$66,$05,$00,$00,$66,$66,$66,$7E,$7E,$3C,$3C,_XX,$18,$06,$7E,$00,$00,$7E
DB $06,$06,$0C,$0C,$18,$18,$30,$30,_XX,$7E,$04,_XX,$00,$22,$78,$30,$78,$78,$7C,$74
DB $7A,$2A,$14,$14,$08,$08,_XX,$00,$04,$3C,$18,$78,$38,$7C,$74,$7A,$6A,$55,$14,$0A
DB $08,$04,_XX,$00,$05,$03,$41,$43,$C2,$24,$3C,$3C,$3C,$7E,$5A,$42,$42,_XX,$00,$04
DB $C0,$82,$C2,$43,$24,$3C,$3C,$3C,$7E,$5A,$84,$84,_XX,$00,$0A,$48,$00,$7F,$AA,$FB
DB $FF,_XX,$00,$06,$04,$00,$01,$54,$7D,$54,$FA,$97,$B3,$FF,$20,$00,$02,$20,$00,$92
DB $64,$92,$01,$54,$7D,$54,$F6,$9B,$9B,$FF,_XX,$00,$30,$FE,$03,$FF,$13,$7F,$CC,$FF
DB $8C,$FF,$92,$7F,$A0,$3F,$C4,$9B,$FC,$03,$02,$13,$13,$CC,$44,$8C,$88,$92,$92,$20
DB $A0,$84,$44,$5C,$B8,_XX,$00,$04,$FF,$7E,$7E,$81,$FF,$FF,$F7,$99,$F7,$99,$BD,$C3
DB $7E,$7E,$81,$FF,$81,$FF,$7E,$FF,$FF,$FF,$F7,$99,$F7,$99,$BD,$C3,_XX,$00,$50,$BF
DB $00,$9F,$00,$9D,$00,$08,_XX,$00,$09,$FF,$00,$FF,$00,$FE,$00,$C0,$00,$80,_XX,$00
DB $07,$FE,$00,$7C,$00,$3C,$00,$18,_XX,$00,$09,$FF,$00,$FF,$00,$7F,$00,$3F,$00,$1F
DB $00,$02,_XX,$00,$05,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$F7,$00,$A5,_XX,$00,$05,$FF
DB $00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FB,$00,$B1,$00,$00,$00,$FF,$00,$FF,$00,$FF
DB $00,$FF,$00,$FF,$00,$DF,$00,$4A,_XX,$00,$FF,_XX,$00,$FF,_XX,$00,$15,$03,$00,$03
DB $00,$01,$00,$01,$00,$01,$00,$01,_XX,$00,$05,$C0,$00,$C0,$00,$80,$00,$80,$00,$80
DB $00,$80,_XX,$00,$05,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0
DB $00,$03,$00,$03,$00,$03,$00,$03,$00,$03,$00,$03,$00,$03,$00,$03,$00,$FF,$00,$FC
DB $00,$F0,$00,$E0,$00,$E0,$00,$C0,$00,$C0,$00,$C0,$00,$FF,_XX,$00,$0F,$FF,$00,$3F
DB $00,$0F,$00,$07,$00,$07,$00,$03,$00,$03,$00,$03,$00,$0F,$00,$3F,$00,$7F,$00,$7F
DB $00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$F0,$00,$FC,$00,$FE,$00,$FE,$00,$FF,$00,$FF
DB $00,$FF,$00,$FF,$00,$FF,_XX,$00,$8F,$FC,$00,$FC,$00,$FE,$00,$FE,$00,$FE,$00,$FE
DB $00,$FF,$00,$FF,$00,$3F,$00,$3F,$00,$7F,$00,$7F,$00,$7F,$00,$7F,$00,$FF,$00,$FF
DB $00,$3F,$00,$3F,$00,$3F,$00,$3F,$00,$3F,$00,$3F,$00,$3F,$00,$3F,$00,$FC,$00,$FC
DB $00,$FC,$00,$FC,$00,$FC,$00,$FC,$00,$FC,$00,$FC,$00,$00,$00,$03,$00,$0F,$00,$1F
DB $00,$1F,$00,$3F,$00,$3F,$00,$3F,$00,$00,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF
DB $00,$FF,$00,$FF,$00,$00,$00,$C0,$00,$F0,$00,$F8,$00,$F8,$00,$FC,$00,$FC,$00,$FC
DB $00,$F0,$00,$C0,$00,$80,$00,$80,_XX,$00,$09,$0F,$00,$03,$00,$01,$00,$01,_XX,$00
DB $0B,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,_XX,$00,$FF,_XX,$00,$45
DB $60,$40,$90,$00,$90,$00,$60,_XX,$00,$09,$20,$00,$80,$00,$10,$00,$40,_XX,$00,$08
DB $20,$00,$80,$00,$10,$00,$40,_XX,$00,$07,$80,$00,$2A,$80,$80,$00,$2A,$80,$80,$00
DB $2A,$80,$80,$00,$55,$AA,_XX,$00,$70,$AA,$AA,$01,$01,$80,$80,$01,$01,$80,$80,$01
DB $01,$80,$80,$55,$55,$AA,$AA,$01,$01,$80,$98,$01,$25,$80,$A4,$01,$25,$80,$80,$55
DB $55,$AA,$AA,$01,$01,$80,$80,$01,$19,$80,$BC,$01,$3D,$80,$80,$55,$55,$AA,$AA,$01
DB $01,$80,$84,$01,$0D,$80,$9C,$01,$3D,$80,$80,$55,$55,$AA,$AA,$01,$01,$80,$A8,$01
DB $3D,$80,$BC,$01,$3D,$80,$80,$55,$55,$AA,$AA,$01,$01,$80,$A0,$01,$31,$80,$B8,$01
DB $3D,$80,$80,$55,$55,$AA,$AA,$01,$01,$80,$80,$01,$25,$80,$BC,$01,$3D,$80,$80,$55
DB $55,$AA,$AA,$01,$01,$80,$80,$01,$3D,$80,$BC,$01,$3D,$80,$80,$55,$55
DB _tilestreamendchar

; ================================================================================
; ================================================================================

	SECTION "CreditsTiles", ROMX, BANK[5]

CreditsTiles:						
DB _XX,$00,$10,$EE,$EE,_XX,$8A,$06,$EE,$EE,_XX,$00,$06,$CE,$CE,_XX,$A4,$06,$CE,$CE
DB _XX,$00,$06,$EE,$EE,_XX,$A8,$04,$AA,$AA,$AE,$AE,_XX,$00,$06,$EE,$EE,$8A,$8A,$8C
DB $8C,$AA,$AA,$EA,$EA,_XX,$00,$06,$EE,$EE,$AA,$AA,$EE,$EE,_XX,$A8,$04,_XX,$00,$06
DB $AE,$AE,$A4,$A4,$E4,$E4,$A4,$A4,$AE,$AE,_XX,$00,$06,$EE,$EE,$88,$88,$8E,$8E,$82
DB $82,$EE,$EE,_XX,$00,$06,$EA,$EA,$4A,$4A,$4E,$4E,_XX,$4A,$04,_XX,$00,$06,$EE,$EE
DB $AA,$AA,$EA,$EA,_XX,$AA,$04,_XX,$00,$06,$AE,$AE,$A8,$A8,$CE,$CE,$A2,$A2,$AE,$AE
DB _XX,$00,$06,$CE,$CE,$A8,$A8,$AC,$AC,$A8,$A8,$CE,$CE,_XX,$00,$06,$AE,$AE,$A8,$A8
DB $AC,$AC,$A8,$A8,$4E,$4E,_XX,$00,$06,$8E,$8E,_XX,$8A,$06,$EE,$EE,_XX,$00,$06,$EA
DB $EA,$AE,$AE,$EA,$EA,_XX,$8A,$04,_XX,$00,$06,$EE,$EE,$8A,$8A,$CA,$CA,$8A,$8A,$EA
DB $EA,_XX,$00,$06,$E3,$E3,_XX,$42,$06,$43,$43,_XX,$00,$06,$BB,$BB,$29,$29,$39,$39
DB $29,$29,$A9,$A9,_XX,$00,$06,$B8,$B8,$20,$20,$38,$38,$08,$08,$38,$38,_XX,$00,$08
DB $EE,$EE,$AA,$AA,$EE,$EE,_XX,$8A,$04,_XX,$00,$06,$73,$73,$8A,$8A,$B3,$B3,$82,$82
DB $7A,$7A,_XX,$00,$06,$BB,$BB,$2A,$2A,$33,$33,$2A,$2A,$2B,$2B,_XX,$00,$06,$BA,$BA
DB $22,$22,$BB,$BB,$0A,$0A,$BA,$BA,_XX,$00,$06,$BB,$BB,$AA,$AA,$AB,$AB,$AA,$AA,$AB
DB $AB,_XX,$00,$06,$A8,$A8,$28,$28,$38,$38,$12,$12,$10,$10,_XX,$00,$06,$EE,$EE,$AA
DB $AA,$AC,$AC,$AA,$AA,$EA,$EA,_XX,$00,$06,$E0,$E0,_XX,$80,$04,$A0,$A0,$E0,$E0,_XX
DB $00,$06,$EE,$EE,_XX,$84,$04,$A4,$A4,$EE,$EE,_XX,$00,$06,$EA,$EA,$4A,$4A,$4E,$4E
DB _XX,$4A,$04,_XX,$00,$06,$AC,$AC,$AA,$AA,$AC,$AC,$AA,$AA,$EC,$EC,_XX,$00,$06,$3B
DB $3B,_XX,$22,$04,$A2,$A2,$3B,$3B,_XX,$00,$06,$A8,$A8,$B8,$B8,$A9,$A9,$AA,$AA,$A8
DB $A8,_XX,$00,$06,$2B,$2B,$BA,$BA,$2B,$2B,_XX,$2A,$04,_XX,$00,$06,$AB,$AB,$A9,$A9
DB $91,$91,$A9,$A9,$AB,$AB,_XX,$00,$06,$AA,$AA,$3A,$3A,_XX,$2A,$04,$AB,$AB,_XX,$00
DB $06,$AB,$AB,$BA,$BA,_XX,$AA,$04,$AB,$AB,_XX,$00,$06,$BB,$BB,_XX,$A1,$06,$B9,$B9
DB _XX,$00,$06,$BB,$BB,$2A,$2A,$2B,$2B,$2A,$2A,$3A,$3A,_XX,$00,$06,$AB,$AB,$AA,$AA
DB $AB,$AB,$28,$28,$3B,$3B,_XX,$00,$06,$80,$80,$00,$00,_XX,$80,$06,_XX,$00,$06,$EE
DB $EE,_XX,$8A,$06,$EE,$EE,_XX,$00,$06,$EE,$EE,_XX,$A4,$08,_XX,$00,$06,$EE,$EE,$A8
DB $A8,$E8,$E8,$A8,$A8,$AE,$AE,_XX,$00,$06,$E0,$E0,_XX,$40,$08,_XX,$00,$06,$EE,$EE
DB $8A,$8A,$EA,$EA,$2A,$2A,$EE,$EE,_XX,$00,$06,$AE,$AE,$AA,$AA,$AC,$AC,$AA,$AA,$EA
DB $EA,_XX,$00,$06,$EE,$EE,$88,$88,$8C,$8C,$88,$88,$EE,$EE,_XX,$00,$06,$3B,$3B,_XX
DB $22,$06,$3B,$3B,_XX,$00,$06,$B3,$B3,$AA,$AA,$AB,$AB,$AA,$AA,$B3,$B3,_XX,$00,$06
DB $80,$80,_XX,$00,$06,$80,$80,_XX,$00,$06,_XX,$A8,$08,$EE,$EE,_XX,$00,$04,$CE,$CE
DB $A8,$A8,$AC,$AC,$A8,$A8,$CE,$CE,_XX,$00,$06,$CE,$CE,_XX,$A4,$06,$CE,$CE,_XX,$00
DB $06,$EE,$EE,$8A,$8A,$8E,$8E,$8A,$8A,$EA,$EA,_XX,$00,$06,$EE,$EE,$48,$48,$4C,$4C
DB $48,$48,$4E,$4E,_XX,$00,$06,$C3,$C3,_XX,$A1,$06,$C1,$C1,_XX,$00,$06,$B8,$B8,_XX
DB $28,$06,$38,$38,_XX,$00,$FF,_XX,$00,$F8,$FF,$FF,_XX,$00,$3D,$18,$00,$00,$38,_XX
DB $18,$08,_XX,$3C,$04,$7E,$00,$00,$7E,$06,$06,$7E,$7E,$60,$60,_XX,$7E,$07,$00,$00
DB $7E,$06,$06,$3E,$3E,$06,$06,_XX,$7E,$06,$66,$00,$00,$66,_XX,$7E,$04,_XX,$06,$08
DB $7E,$00,$00,$7E,$60,$60,$7E,$7E,$06,$06,_XX,$7E,$07,$00,$00,$7E,$60,$60,$7E,$7E
DB $66,$66,_XX,$7E,$07,$00,$00,$7E,$06,$06,_XX,$1E,$04,_XX,$06,$06,$7E,$00,$00,$7E
DB $66,$66,$7E,$7E,$66,$66,_XX,$7E,$07,$00,$00,$7E,$66,$66,$7E,$7E,_XX,$06,$08,$7E
DB $00,$00,$7E,_XX,$66,$06,_XX,$7E,$06,$3C,$00,$00,$7E,$66,$66,_XX,$7E,$04,_XX,$66
DB $06,$7C,$00,$00,$7E,$66,$66,_XX,$7C,$04,$66,$66,$7E,$7E,$7C,$7C,$7E,$00,$00,$7C
DB _XX,$60,$08,$7C,$7C,$7E,$7E,$7C,$00,$00,$7E,_XX,$66,$08,$7E,$7E,$7C,$7C,$7E,$00
DB $00,$7E,$60,$60,_XX,$78,$04,$60,$60,_XX,$7E,$05,$00,$00,$7E,$60,$60,_XX,$78,$04
DB _XX,$60,$06,$7E,$00,$00,$7E,$60,$60,_XX,$6E,$04,$66,$66,_XX,$7E,$04,$66,$00,$00
DB $66,$66,$66,_XX,$7E,$04,_XX,$66,$06,$7E,$00,$00,$7E,_XX,$18,$08,_XX,$7E,$05,$00
DB $00,$7E,_XX,$18,$08,_XX,$78,$04,$66,$00,$00,$66,$66,$66,_XX,$7C,$04,_XX,$66,$06
DB $60,$00,$00,_XX,$60,$09,_XX,$7E,$04,$66,$00,$00,$7E,$7E,$7E,_XX,$66,$0A,$3C,$00
DB $00,$7E,_XX,$66,$0C,$3C,$00,$00,$7E,_XX,$66,$08,$7E,$7E,$3C,$3C,$7E,$00,$00,$7E
DB $66,$66,_XX,$7E,$04,_XX,$60,$06,$7E,$00,$00,$7E,_XX,$66,$06,$6E,$6E,_XX,$7E,$05
DB $00,$00,$7E,$66,$66,_XX,$7C,$04,_XX,$66,$06,$7E,$00,$00,$7E,$60,$60,_XX,$7E,$04
DB $06,$06,_XX,$7E,$05,$00,$00,$7E,_XX,$18,$0C,$66,$00,$00,_XX,$66,$09,$7E,$7E,$3C
DB $3C,$66,$00,$00,_XX,$66,$07,$7E,$7E,$3C,$3C,$18,$18,$66,$00,$00,_XX,$66,$07,_XX
DB $7E,$04,$66,$66,$66,$00,$00,$66,$3C,$3C,_XX,$18,$04,$3C,$3C,_XX,$66,$05,$00,$00
DB $66,$66,$66,$7E,$7E,$3C,$3C,_XX,$18,$06,$7E,$00,$00,$7E,$06,$06,$0C,$0C,$18,$18
DB $30,$30,_XX,$7E,$04
DB _StreamEndCredits

; ================================================================================
; ================================================================================