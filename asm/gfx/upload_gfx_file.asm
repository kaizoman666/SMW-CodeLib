
; Uploads a GFX file to VRAM.
;; A = 16-bit GFX file number
;; Y = 16-bit VRAM destination (e.g. $4000 = LG1)
; $00-$02 is overwritten by this.

; Example for iterating over multiple files, in this case four:
;   LDY #$0000          ; VRAM address to load into
;   LDX #$0000
; .loop
;   LDA GfxFileList,x
;   PHY
;   JSL upload_gfx_4bpp
;   PLA
;   CLC : ADC #$0800	; #$0800 for a 4bpp file, #$0400 for a 2bpp
;   TAY
;   INX #2
;   CPX #$0008
;   BCC .loop

; Upload a 4bpp file
upload_gfx_4bpp:
    PHP
    PEA $1000
    BRA +

; Upload a 2bpp file
upload_gfx_2bpp:
    PHP
    PEA $0800
  +
    PHA
    LDA #$7E00      ; decompress to $7EAD00
    STA $01
    LDA #$AD00
    STA $00
    PLA
    JSL $0FF900
    SEP #$20
    
    LDA #$80
    STA $2115
    STY $2116
    PLY : STY $4315
    
    LDA #$7E
    STA $4314
    LDY #$AD00
    STY $4312
    
    LDY #$1801
    STY $4310
    LDA #$02
    STA $420B
    PLP
    RTL
