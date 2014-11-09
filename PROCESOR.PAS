Program MainCPUType;
Uses Crt,Dos;
Var a:byte;
begin
Asm
  {A 100}
  PUSHF
  MOV AX,0
  PUSH AX
  POPF
  PUSHF
  POP AX
  CMP AH,$F0
  {JNZ $114}
  NOP
  NOP
  MOV AL,00
  {JMP $14A}
  NOP
  MOV AX,$F000
  PUSH AX
  POPF
  PUSHF
  POP AX
  CMP AH,0
  {JNZ $127}
  NOP
  NOP
  MOV AL,2
  {JMP $14A}
  NOP
  DB $0F,$20,$C0
  DB $66,$8B,$D8
  DB $66,$35,$00,$00,$00,$20
  DB $0F,$22,$C0
  DB $0F,$20,$C0
  DB $66,$3B,$C3
  DB $75,$07
  DB $90,$90
  DB $B0,$03
  DB $EB,$06
  DB $90
  DB $0F,$22,$C3
  MOV AL,4
  POPF
  MOV AH,$4C
  INT $21
  Mov a,ah
end;
  Writeln('AH : ',a);
end.