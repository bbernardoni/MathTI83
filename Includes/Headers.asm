; ===============================================================
; HEADERS.ASM - Bennett Bernardoni 2013
; ===============================================================

; ===============================================================
; Definitions
; ===============================================================

.include "ti83plus.inc"
.define bcallz(label) jr nz,$+5 \ rst rBR_CALL \ .dw label
.define bcallnz(label) jr z,$+5 \ rst rBR_CALL \ .dw label
.define bcallc(label) jr nc,$+5 \ rst rBR_CALL \ .dw label
.define bcallnc(label) jr c,$+5	\ rst rBR_CALL \ .dw label
.define bjumpz(label) jr nz,$+7 \ call 50h \ .dw label
.define bjumpnz(label) jr z,$+7 \ call 50h \ .dw label
.define bjumpc(label) jr nc,$+7 \ call 50h \ .dw label
.define bjumpnc(label) jr c,$+7	\ call 50h \ .dw label

; ===============================================================
; Set up TIOS ASCII-mapping
; ===============================================================

.include "ASCII Mapping.asm"

; ===============================================================
; Set up settings
; ===============================================================

.binarymode ti8xapp
.variablename [%PROJECT_BINARY%]
.defpage 0, $4000, $4000          ; Page 0 definition
.page 0
.block 128

; ===============================================================
; The main source code
; ===============================================================

.include "../Program.asm"
