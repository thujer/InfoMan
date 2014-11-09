{$M 8192,0,0}
Uses Crt,Dos;
Var
  Ver,h,m,s,st,y,d,dow         :Word;
  Volba                        :Char;
  Hex                          :LongInt;
  Out                          :Byte;
  Regs                         :Registers;
  Test                         :Byte absolute 0:$0417;
  Press                        :Byte absolute 0:$418;
  xx,yy,n,Error                :Integer;
  CB,Mouse,Konec               :Boolean;
  Free   :Word absolute 0:$413;
  BIOS0  :Word absolute $F000:$8100;
  BIOS1  :Word absolute $F000:$8101;
  BIOS2  :Word absolute $F000:$8102;
  BIOS3  :Word absolute $F000:$8103;
  BIOS4  :Word absolute $F000:$8104;
  BIOS5  :Word absolute $F000:$8105;
  BIOS6  :Word absolute $F000:$8106;
  BIOS7  :Word absolute $F000:$8107;
  BIOS8  :Word absolute $F000:$8108;
  BIOS9  :Word absolute $F000:$8109;
  BIOSA  :Word absolute $F000:$810A;
  BIOSB  :Word absolute $F000:$810B;
  BIOSC  :Word absolute $F000:$810C;
  BIOSD  :Word absolute $F000:$810D;
  BIOSE  :Word absolute $F000:$810E;
  BIOSF  :Word absolute $F000:$810F;
  BIOS10 :Word absolute $F000:$8110;
  BIOS11 :Word absolute $F000:$8111;
  BIOS12 :Word absolute $F000:$8112;
  BIOS13 :Word absolute $F000:$8113;
  BIOS14 :Word absolute $F000:$8114;
  BIOS15 :Word absolute $F000:$8115;
  BIOS16 :Word absolute $F000:$8116;
  BIOS17 :Word absolute $F000:$8117;
  BIOS18 :Word absolute $F000:$8118;
  BIOS19 :Word absolute $F000:$8119;
  BIOS1A :Word absolute $F000:$811A;
  BIOS1B :Word absolute $F000:$811B;
  BIOS1C :Word absolute $F000:$811C;
  BIOS1D :Word absolute $F000:$811D;
  BIOS1E :Word absolute $F000:$811E;
  BIOS1F :Word absolute $F000:$811F;
  BIOS20 :Word absolute $F000:$8120;
  BIOS21 :Word absolute $F000:$8121;
  BIOS22 :Word absolute $F000:$8122;
  BIOS23 :Word absolute $F000:$8123;
  BIOS24 :Word absolute $F000:$8124;
  BIOS25 :Word absolute $F000:$8125;
  BIOS26 :Word absolute $F000:$8126;
  BIOS27 :Word absolute $F000:$8127;
  BIOS28 :Word absolute $F000:$8128;
  Date1  :Word absolute $FFFF:$0005;
  Date2  :Word absolute $FFFF:$0006;
  Date3  :Word absolute $FFFF:$0007;
  Date4  :Word absolute $FFFF:$0008;
  Date5  :Word absolute $FFFF:$0009;
  Date6  :Word absolute $FFFF:$000a;
  Date7  :Word absolute $FFFF:$000b;
  Date8  :Word absolute $FFFF:$000c;
  VIDEO01 :Word absolute $C000:$0039;
  VIDEO02 :Word absolute $C000:$003A;
  VIDEO03 :Word absolute $C000:$003B;
  VIDEO04 :Word absolute $C000:$003C;
  VIDEO05 :Word absolute $C000:$003D;
  VIDEO06 :Word absolute $C000:$003E;
  VIDEO07 :Word absolute $C000:$003F;
  VIDEO08 :Word absolute $C000:$0040;
  VIDEO09 :Word absolute $C000:$0041;
  VIDEO0A :Word absolute $C000:$0042;
  VIDEO0B :Word absolute $C000:$0043;
  VIDEO0C :Word absolute $C000:$0044;
  VIDEO0D :Word absolute $C000:$0045;
  VIDEO0E :Word absolute $C000:$0046;
  VIDEO0F :Word absolute $C000:$0047;
  VIDEO10 :Word absolute $C000:$0048;
  VIDEO11 :Word absolute $C000:$0049;
  VIDEO12 :Word absolute $C000:$004A;
  VIDEO13 :Word absolute $C000:$004B;
  VIDEO14 :Word absolute $C000:$004C;
  VIDEO15 :Word absolute $C000:$004D;
  VIDEO16 :Word absolute $C000:$004E;
  VIDEO17 :Word absolute $C000:$004F;
  VIDEO18 :Word absolute $C000:$0050;
  VIDEO19 :Word absolute $C000:$0051;
  VIDEO1A :Word absolute $C000:$0052;
  VIDEO1B :Word absolute $C000:$0053;
  VIDEO1C :Word absolute $C000:$0054;
  VIDEO1D :Word absolute $C000:$0055;
  VIDEO1E :Word absolute $C000:$0056;
  VIDEO1F :Word absolute $C000:$0057;
  VIDEO20 :Word absolute $C000:$0058;
  VIDEO21 :Word absolute $C000:$0059;
  VIDEO22 :Word absolute $C000:$005A;
  VIDEO23 :Word absolute $C000:$005B;
  VIDEO24 :Word absolute $C000:$005C;
  VIDEO25 :Word absolute $C000:$005D;
  VIDEO26 :Word absolute $C000:$005E;
  VIDEO27 :Word absolute $C000:$005F;
  VIDEO28 :Word absolute $C000:$0060;

const
  Days:array[0..6] of String[9]=
    ('Nedele','Pondeli','Utery','Streda','Ctvrtek','Patek','Sobota');


Procedure MainInfo;
begin
  TextColor(7);
  GetDate(y,m,d,dow);
  GotoXY(10,10);Write('Dnes je ',days[dow],'  ',m:0,'.', d:0,'.', y:0);
  {Kontrola zalozni baterie pro CMOS}
  GotoXY(10,12);Write('Napajeni CMOS : ');
  asm
  Mov al,$d
  Out $70,al
  In al,$71
  Mov Out,al
  end;
  If (Out and 128)=128 then Write('v poradku')
  Else Write('vymente zalozni baterii !!!');

  {Zjisteni matem. koprocesoru}
  GotoXY(10,14);
  Write('Matematicky koprocesor : ');
  asm
  Mov al,$14
  Out $70,al
  In al,$71
  Mov Out,al
  end;
  If (Out and 2)=2 then Write('Present')
  Else Write('Nenalezen');

  {Zjisteni poctu disketovych mechanik}
  GotoXY(10,16);
  Write('Pocet disketovych mechanik : ');
  asm
  Mov al,$14
  Out $70,al
  In al,$71
  Mov Out,al
  end;
  If ((Out and 64)=0)and((Out and 128)=0) then
  Writeln('1');
  If ((Out and 128)=0)and((Out and 64)=64) then
  Writeln('2');
  If ((Out and 128)=128)and((Out and 64)=0) then
  Writeln('3');
  If ((Out and 64)=64)and((Out and 128)=128) then
  Writeln('4');
end;

Procedure Locky;
Var
  Tik1                         :Word absolute 0:$46c;
  Tik2                         :Word absolute 0:$46e;
begin
  GotoXY(70,13);Write(Press,'  ',Test,'  ');
  GotoXY(70,14);Write(Port[$60],'  ');

  {If (Test and 8=8)and(Press=2) then{L Alt}
  {begin
    TextColor(10);
    GotoXY(35,24);Write('o');
  end
  Else
  begin
    If port[$60]=184 then
    begin
      port[$60]:=1;
      TextColor(0);
      GotoXY(35,24);Write('o');
    end;
  end;


  If (Test and 8=8)and(Press=0) then{R Alt}
  {begin
    TextColor(10);
    GotoXY(37,24);Write('o');
  end
  Else
  begin
    If port[$60]=184 then
    begin
      port[$60]:=1;
      TextColor(0);
      GotoXY(37,24);Write('o');
    end;
  end;

  If (Test and 4=4)and(Press=0) then{R Control}
  {begin
    SetFillStyle(1,10);
    FillEllipse(550,275,5,5);
  end
  Else
  begin
    If port[$60]=157 then
    begin
      port[$60]:=1;
      SetFillStyle(1,0);
      FillEllipse(550,275,5,5);
    end;
  end;

  If (Test and 4=4)and(Press=1) then{L Control}
  {begin
    SetFillStyle(1,10);
    FillEllipse(550,290,5,5);
  end
  Else
  begin
    If port[$60]=157 then
    begin
      port[$60]:=1;
      SetFillStyle(1,0);
      FillEllipse(550,290,5,5);
    end;
  end;

  If Test and 1=1 then    {R Shift}
  {begin
    SetFillStyle(1,10);
    FillEllipse(550,245,5,5);
  end
  Else
  begin
    If port[$60]=182 then
    begin
      port[$60]:=0;
      SetFillStyle(1,0);
      FillEllipse(550,245,5,5);
    end;
  end;

  If Test and 2=2 then  {L Shift}
  {begin
    SetFillStyle(1,10);
    FillEllipse(550,260,5,5);
  end
  Else
  begin
    If port[$60]=170 then
    begin
      port[$60]:=0;
      SetFillStyle(1,0);
      FillEllipse(550,260,5,5);
    end;
  end;

  If Press and 32=32 then  {NumLock}
  {begin
    If Test and 32=32 then SetFillStyle(1,10) Else SetFillStyle(1,0);
    FillEllipse(210,420,5,5);
  end;

  If Press and 64=64 then  {CapsLock}
  {begin
    If Test and 64=64 then SetFillStyle(1,10) Else SetFillStyle(1,0);
    FillEllipse(310,420,5,5);
  end;

  If Press and 16=16 then  {ScrollLock}
  {begin
    If Test and 16=16 then SetFillStyle(1,10) Else SetFillStyle(1,0);
    FillEllipse(410,420,5,5);
  end;

  If Mouse then If Out and 1=1 then SetFillStyle(1,10) Else SetFillStyle(1,0);
  If Mouse then Bar(551,351,565,375);

  If Mouse then If Out and 2=2 then SetFillStyle(1,10) Else SetFillStyle(1,0);
  If Mouse then Bar(585,351,599,375);

  If Mouse then If Out and 4=4 then SetFillStyle(1,10) Else SetFillStyle(1,0);
  If Mouse then Bar(567,351,583,375);}

  GotoXY(70,11);Writeln(Tik2,Tik1);
  Asm
    Mov ah,$0C
    Int $21
    Mov Out,al
  end;
end;

Procedure InitDesktop;
begin
  GotoXY(35,1);Write('INFO MANAZER');
  If Test and 32=32 then TextColor(10) Else TextColor(0);
  GotoXY(35,22);Write('o');
  If Test and 64=64 then TextColor(10) Else TextColor(0);
  GotoXY(35,22);Write('o');
  If Test and 16=16 then TextColor(10) Else TextColor(0);
  GotoXY(35,22);Write('o');
end;

Function Disketa(A:Byte):Boolean;
{Zjisti, je-li v mechanice disketa}
begin
  Disketa:=False;
  Asm
    Mov ah,$44
    Mov al,$e
    Mov bl,1
    Int $21
    Mov Out,al
  end;

  If a=1 then
  begin
    Disketa:=False;
    Regs.Ah:=$1C;
    Regs.Dl:=1;
    Intr($21,regs);
    If (regs.ds<>0)and(regs.bx<>0) then Disketa:=True;
  end;

  If a=2 then
  begin
    Disketa:=False;
    Regs.Ah:=$1C;
    Regs.Dl:=2;
    Intr($21,regs);
    If (regs.ds<>0)and(regs.bx<>0) then Disketa:=True;
  end;
end;

Function TypDrive(s:string):String;
{Zjisteni typu mechaniky A: nebo B:}
begin
  asm
    Mov al,$10
    Out $70,al
    In al,$71
    Mov Out,al
  end;
  If s='A:' then {Typ disketove mechaniky A: }
  begin
    If (Out and 16)=16 then TypDrive:='5.25';
    If (Out and 32)=32 then TypDrive:='5.25';
    If (Out and 48)=28 then TypDrive:='3.5';
    If (Out and 64)=64 then TypDrive:='3.5';
  end;
  If s='B:' then {Typ disketove mechaniky B: }
  begin
    If (Out and 1)=1 then TypDrive:='5.25';
    If (Out and 2)=2 then TypDrive:='5.25';
    If (Out and 3)=3 then TypDrive:='3.5';
    If (Out and 4)=4 then TypDrive:='3.5';
  end;
end;

Procedure Done;
Var i,n:integer;
begin
  ClrScr;
  TextBackground(0);
  TextBackground(0);
  TextColor(7);
  Writeln('Ukonceno normalne');
  Asm
    Mov ah,$0C
    Int $21
    Mov Out,al
  end;
  Halt(0);
end;

Procedure Disky;
Var
  DskX,DskY,i:Integer;
  Celkem:LongInt;
begin
  ClrScr;
  GotoXY(1,10);
  dskX:=0;
  dskY:=0;
  For i:=1 to 26 do
  begin
    If i=1 then
    begin
      asm
      Mov ah,$44
      Mov al,$f
      Mov bl,1
      Int $21
      Mov ah,$44
      Mov al,$e
      Mov bl,1
      Int $21
      Mov Out,al
      end;
      If Out<>0 then
        Writeln('Na disketovou jednotku A: je mozne se odkazat i jako na B:');
    end;

    If i=2 then
    begin
      Asm
      Mov ah,$44
      Mov al,$f
      Mov bl,2
      Int $21
      end;
    end;

    If DiskFree(i)<>-1 then
    begin
      If DskX=9 then DskY:=DskY+1;
      If DskX=18 then DskY:=DskY+1;
      If (i<>1)and(i<>2) then

      If (DiskFree(i) div 1024)>1500 then
      Writeln('Disk '+chr(i+64)+' : ',(DiskFree(i) div 1024)div 1024,
      ' Mb volnych , Celkem : ',(DiskSize(i) div 1024)div 1024,' Mb')
      Else
      Writeln('Disk '+chr(i+64)+' : ',DiskFree(i) div 1024, ' Kb volnych , ',
      'Celkem : ',DiskSize(i) div 1024,' Kb');
      If i>2 then dskX:=dskX+1;
    end;
  end;
  Konec:=False;
  Repeat
    GetTime(h,m,s,st);GotoXY(71,1);Write(h,':',m,':',s,'  ');
    Locky;
    If Port[$60]=68 then Done;
  until port[$60]=1;
  MainInfo;
  While Port[$60]=1 do;
  ClrScr;
end;

Procedure SwapLPT;
begin
  TextColor(12);
  GotoXY(20,20);Write('Po teto operaci musi byt tento program ukoncen.');
  GotoXY(30,21);Write('Chcete pokracovat (A/) ?');
  Volba:=ReadKey;
  If UpCase(Volba)='A' then
  begin
    TextBackground(0);
    TextColor(7);
    Writeln('Porty LPT1 a LPT2 byly prohozeny');
    asm
    Mov ax,$40
    Mov ds,ax
    Mov ax,Word[8]
    Mov bx,Word[$a]
    Mov Word[8],bx
    Mov Word[$a],ax
    Mov ah,$4c
    Int $21
    end;
  end
  Else
  begin
    TextColor(7);
    GotoXY(20,20);Write('                                               ');
    GotoXY(30,21);Write('                        ');
  end;
end;

Procedure SwapCOM;
begin
  TextColor(12);
  GotoXY(20,20);Write('Po teto operaci musi byt tento program ukoncen.');
  GotoXY(30,21);Write('Chcete pokracovat (A/) ?');
  Volba:=ReadKey;
  If UpCase(Volba)='A' then
  begin
    TextBackground(0);
    TextColor(7);
    Writeln('Porty COM1 a COM2 byly prohozeny');
    asm
    Mov ax,$40
    Mov ds,ax
    Mov ax,Word[0]
    Mov bx,Word[2]
    Mov Word[0],bx
    Mov Word[2],ax
    Mov ah,$4c
    Int $21
    end;
  end
  Else
  begin
    TextColor(7);
    GotoXY(20,20);Write('                                               ');
    GotoXY(30,21);Write('                        ');
  end;
end;

Procedure Porty;
begin
  ClrScr;
  TextColor(7);
  asm
    Mov al,[$11]
    Mov cl,6
    Sar al,cl
    Mov Out,al
  end;
  GotoXY(10,9);Write('Pocet paralelnich portu : ',Out);
  Out:=0;
  asm
    Mov al,[$11]
    Mov cl,1
    Sar al,cl
    And al,7
    Mov Out,al
  end;
  GotoXY(10,11);Write('Pocet seriovych portu : ',Out);
  Konec:=False;
  repeat
    GetTime(h,m,s,st);GotoXY(71,1);Write(h,':',m,':',s,'  ');
    If Port[$60]=2 then SwapCOM;
    If Port[$60]=3 then SwapLPT;
    If Port[$60]=68 then Done;

    Locky;
  until (port[$60]=1)or(Konec=True);
  MainInfo;
  While Port[$60]=1 do;
  ClrScr;
end;

Procedure Pamet;
Var
  Celkem,Volnych:Word;
  CelkemK,VolnychK:LongInt;
begin
  ClrScr;
  TextColor(7);
  {Zjisteni velikosti zakladni pameti}
  Hex:=0;
  asm
  Mov al,$16
  Out $70,al
  In al,$71
  Mov Out,al
  end;
  If (Out and 128)=128 then hex:=32768;
  If (Out and 64)=64 then hex:=hex+16384;
  If (Out and 32)=32 then hex:=hex+8192;
  If (Out and 16)=16 then hex:=hex+4096;
  If (Out and 8)=8 then hex:=hex+2048;
  If (Out and 4)=4 then hex:=hex+1024;
  If (Out and 2)=2 then hex:=hex+512;
  If (Out and 1)=1 then hex:=hex+256;
  asm
  Mov al,$15
  Out $70,al
  In al,$71
  Mov Out,al
  end;
  If (Out and 128)=128 then hex:=hex+128;
  If (Out and 64)=64 then hex:=hex+64;
  If (Out and 32)=32 then hex:=hex+32;
  If (Out and 16)=16 then hex:=hex+16;
  If (Out and 8)=8 then hex:=hex+8;
  If (Out and 4)=4 then hex:=hex+4;
  If (Out and 2)=2 then hex:=hex+2;
  If (Out and 1)=1 then hex:=hex+1;
  Writeln(#13#10#13#10'Velikost zakladni pameti : ',hex,' K');
  {Zjisteni velikosti rozsirene pameti}
  Hex:=0;
  asm
  Mov al,$18
  Out $70,al
  In al,$71
  Mov Out,al
  end;
  If (Out and 128)=128 then hex:=32768;
  If (Out and 64)=64 then hex:=hex+16384;
  If (Out and 32)=32 then hex:=hex+8192;
  If (Out and 16)=16 then hex:=hex+4096;
  If (Out and 8)=8 then hex:=hex+2048;
  If (Out and 4)=4 then hex:=hex+1024;
  If (Out and 2)=2 then hex:=hex+512;
  If (Out and 1)=1 then hex:=hex+256;
  asm
  Mov al,$17
  Out $70,al
  In al,$71
  Mov Out,al
  end;
  If (Out and 128)=128 then hex:=hex+128;
  If (Out and 64)=64 then hex:=hex+64;
  If (Out and 32)=32 then hex:=hex+32;
  If (Out and 16)=16 then hex:=hex+16;
  If (Out and 8)=8 then hex:=hex+8;
  If (Out and 4)=4 then hex:=hex+4;
  If (Out and 2)=2 then hex:=hex+2;
  If (Out and 1)=1 then hex:=hex+1;
  Writeln(#13#10'Velikost rozsirene pameti : ',hex,' K');
  If Free <> 640 then
  begin
   TextColor(4);
   Writeln('Podezreni na rezidentni virus ,nesouhlasi velikost',
    #10#13'konvencni pameti radeji spustte ANTIVIR !!!');
   Writeln('Toto hlaseni muze byt mylne ,pokud pouzivate jinou',
   #10#13'velikost konvencni pameti nez 640 K.');
   TextColor(7);
  end;
  VolnychK:=0;
  asm
    Mov ah,$48
    Mov bx,$0ffff
    Int $21
    Mov Volnych,bx
  end;
  VolnychK:=Volnych;
  Writeln(#10#13'Volna konvencni pamet : ',(VolnychK*16+MaxAvail) div 1024,' Kb');
  asm
    Mov ah,$42
    Int $67
    Mov Celkem,dx
    Mov Volnych,bx
  end;
  CelkemK:=Celkem;
  VolnychK:=Volnych;
  Writeln(#10#13'Celkem pameti EMS v systemu : ',CelkemK*16,' K');
  Writeln(#10#13'Volna pamet EMS v systemu : ',VolnychK*16,' K');

  Konec:=False;
  repeat
    GetTime(h,m,s,st);GotoXY(71,1);Write(h,':',m,':',s,'  ');
    If Port[$60]=68 then Done;

    Locky;
  until (port[$60]=1)or(Konec=True);
  MainInfo;
  While Port[$60]=1 do;
  ClrScr;
end;

Procedure ViewAutoex;
begin
  GotoXY(2,2);
  SwapVectors;
  Exec(GetEnv('COMSPEC'),'/C TYPE C:\AUTOEXEC.BAT |More');
  SwapVectors;
  Repeat until ReadKey=#27;
  InitDeskTop;
  TextColor(7);
  GotoXY(1,9);
  Write('Typ BIOSu : ',Chr(BIOS0),Chr(BIOS1),Chr(BIOS2),Chr(BIOS3),
  Chr(BIOS4),Chr(BIOS5),Chr(BIOS6),Chr(BIOS7),Chr(BIOS8),Chr(BIOS9),
  Chr(BIOSA),Chr(BIOSB),Chr(BIOSC),Chr(BIOSD),Chr(BIOSE),Chr(BIOSF),
  Chr(BIOS10),Chr(BIOS11),Chr(BIOS12),Chr(BIOS13),Chr(BIOS14),Chr(BIOS15),
  Chr(BIOS16),Chr(BIOS17),Chr(BIOS18),Chr(BIOS19),Chr(BIOS1A),Chr(BIOS1B),
  Chr(BIOS1C),Chr(BIOS1D),Chr(BIOS1E),Chr(BIOS1F),Chr(BIOS20),Chr(BIOS21),
  Chr(BIOS22),Chr(BIOS23),Chr(BIOS24),Chr(BIOS25),Chr(BIOS26),Chr(BIOS27),
  Chr(BIOS28));
  GotoXY(1,10);
  Write('Video ROM BIOS : ',Chr(VIDEO01),Chr(VIDEO02),Chr(VIDEO03),
  Chr(VIDEO04),Chr(VIDEO05),Chr(VIDEO06),Chr(VIDEO07),Chr(VIDEO08),
  Chr(VIDEO09),Chr(VIDEO0A),Chr(VIDEO0B),Chr(VIDEO0C),Chr(VIDEO0D),
  Chr(VIDEO0E),Chr(VIDEO0F),Chr(VIDEO10),Chr(VIDEO11),Chr(VIDEO12),
  Chr(VIDEO13),Chr(VIDEO14),Chr(VIDEO15),Chr(VIDEO16),Chr(VIDEO17),
  Chr(VIDEO18),Chr(VIDEO19),Chr(VIDEO1A),Chr(VIDEO1B),Chr(VIDEO1C),
  Chr(VIDEO1D),Chr(VIDEO1E),Chr(VIDEO1F),Chr(VIDEO20),Chr(VIDEO21),
  Chr(VIDEO22),Chr(VIDEO23),Chr(VIDEO24),Chr(VIDEO25),Chr(VIDEO26));
  yy:=0;
  For Out:=0 to EnvCount do
  begin
    yy:=yy+1;
    If yy<27 then
    begin
      If Length(EnvStr(Out))>60 then
      begin
        yy:=yy+1;
        yy:=yy+1;
        If Length(EnvStr(Out))>128 then
        begin
          yy:=yy+1;
          yy:=yy+1;
        end;
      end;
    end;
  end;
end;

Procedure ViewConfig;
begin
  GotoXY(2,2);
  SwapVectors;
  Exec(GetEnv('COMSPEC'),'/C TYPE C:\CONFIG.SYS |More');
  SwapVectors;
  Repeat until ReadKey=#27;
  InitDeskTop;
  TextColor(7);
  GotoXY(1,9);
  Write('Typ BIOSu : ',Chr(BIOS0),Chr(BIOS1),Chr(BIOS2),Chr(BIOS3),
  Chr(BIOS4),Chr(BIOS5),Chr(BIOS6),Chr(BIOS7),Chr(BIOS8),Chr(BIOS9),
  Chr(BIOSA),Chr(BIOSB),Chr(BIOSC),Chr(BIOSD),Chr(BIOSE),Chr(BIOSF),
  Chr(BIOS10),Chr(BIOS11),Chr(BIOS12),Chr(BIOS13),Chr(BIOS14),Chr(BIOS15),
  Chr(BIOS16),Chr(BIOS17),Chr(BIOS18),Chr(BIOS19),Chr(BIOS1A),Chr(BIOS1B),
  Chr(BIOS1C),Chr(BIOS1D),Chr(BIOS1E),Chr(BIOS1F),Chr(BIOS20),Chr(BIOS21),
  Chr(BIOS22),Chr(BIOS23),Chr(BIOS24),Chr(BIOS25),Chr(BIOS26),Chr(BIOS27),
  Chr(BIOS28));
  GotoXY(1,10);
  Write('Video ROM BIOS : ',Chr(VIDEO01),Chr(VIDEO02),Chr(VIDEO03),
  Chr(VIDEO04),Chr(VIDEO05),Chr(VIDEO06),Chr(VIDEO07),Chr(VIDEO08),
  Chr(VIDEO09),Chr(VIDEO0A),Chr(VIDEO0B),Chr(VIDEO0C),Chr(VIDEO0D),
  Chr(VIDEO0E),Chr(VIDEO0F),Chr(VIDEO10),Chr(VIDEO11),Chr(VIDEO12),
  Chr(VIDEO13),Chr(VIDEO14),Chr(VIDEO15),Chr(VIDEO16),Chr(VIDEO17),
  Chr(VIDEO18),Chr(VIDEO19),Chr(VIDEO1A),Chr(VIDEO1B),Chr(VIDEO1C),
  Chr(VIDEO1D),Chr(VIDEO1E),Chr(VIDEO1F),Chr(VIDEO20),Chr(VIDEO21),
  Chr(VIDEO22),Chr(VIDEO23),Chr(VIDEO24),Chr(VIDEO25),Chr(VIDEO26));
  yy:=0;
  For Out:=0 to EnvCount do
  begin
    yy:=yy+1;
    If yy<27 then
    begin
      If Length(EnvStr(Out))>60 then
      begin
        yy:=yy+1;
        yy:=yy+1;
        If Length(EnvStr(Out))>128 then
        begin
          yy:=yy+1;
          yy:=yy+1;
        end;
      end;
    end;
  end;
end;

Procedure DosUtils;
begin
  TextColor(7);

  Ver:=DosVersion;
  GotoXY(2,9);Write('Verze DOSu : ',Lo(Ver),'.',Hi(Ver));
  GotoXY(2,10);
  Write('Datum BIOSu : ',Chr(Date1),Chr(Date2),Chr(Date3),
  Chr(Date4),Chr(Date5),Chr(Date6),Chr(Date7),Chr(Date8));
  GotoXY(2,11);
  Write('Typ BIOSu : ',Chr(BIOS0),Chr(BIOS1),Chr(BIOS2),Chr(BIOS3),
  Chr(BIOS4),Chr(BIOS5),Chr(BIOS6),Chr(BIOS7),Chr(BIOS8),Chr(BIOS9),
  Chr(BIOSA),Chr(BIOSB),Chr(BIOSC),Chr(BIOSD),Chr(BIOSE),Chr(BIOSF),
  Chr(BIOS10),Chr(BIOS11),Chr(BIOS12),Chr(BIOS13),Chr(BIOS14),Chr(BIOS15),
  Chr(BIOS16),Chr(BIOS17),Chr(BIOS18),Chr(BIOS19),Chr(BIOS1A),Chr(BIOS1B),
  Chr(BIOS1C),Chr(BIOS1D),Chr(BIOS1E),Chr(BIOS1F),Chr(BIOS20),Chr(BIOS21),
  Chr(BIOS22),Chr(BIOS23),Chr(BIOS24),Chr(BIOS25),Chr(BIOS26),Chr(BIOS27),
  Chr(BIOS28));
  GotoXY(2,12);
  Write('Video ROM BIOS : ',Chr(VIDEO01),Chr(VIDEO02),Chr(VIDEO03),
  Chr(VIDEO04),Chr(VIDEO05),Chr(VIDEO06),Chr(VIDEO07),Chr(VIDEO08),
  Chr(VIDEO09),Chr(VIDEO0A),Chr(VIDEO0B),Chr(VIDEO0C),Chr(VIDEO0D),
  Chr(VIDEO0E),Chr(VIDEO0F),Chr(VIDEO10),Chr(VIDEO11),Chr(VIDEO12),
  Chr(VIDEO13),Chr(VIDEO14),Chr(VIDEO15),Chr(VIDEO16),Chr(VIDEO17),
  Chr(VIDEO18),Chr(VIDEO19),Chr(VIDEO1A),Chr(VIDEO1B),Chr(VIDEO1C),
  Chr(VIDEO1D),Chr(VIDEO1E),Chr(VIDEO1F),Chr(VIDEO20),Chr(VIDEO21),
  Chr(VIDEO22),Chr(VIDEO23),Chr(VIDEO24),Chr(VIDEO25),Chr(VIDEO26));
  yy:=0;
  For Out:=0 to EnvCount do
  begin
    yy:=yy+1;
    If yy<27 then
    begin
      If Length(EnvStr(Out))>60 then
      begin
        yy:=yy+1;
        yy:=yy+1;
        If Length(EnvStr(Out))>128 then
        begin
          yy:=yy+1;
          yy:=yy+1;
        end;
      end;
    end;
  end;

  Konec:=False;
  repeat
    GetTime(h,m,s,st);GotoXY(71,1);Write(h,':',m,':',s,'  ');
    If Port[$60]=2 then ViewAutoex;
    If Port[$60]=3 then ViewConfig;
    If Port[$60]=68 then Done;

    Locky;
  until (port[$60]=1)or(Konec=True);
  MainInfo;
  While Port[$60]=1 do;
end;

Procedure HelpMe;
Var
  F: Text;
  Ch: Char;
begin
  GotoXY(2,2);
  Assign(F,'.\DATA\HELP.DAT');
  Reset(F);
  While not Eof(F) do
  begin
    Read(F, Ch);
    Write(Ch);
  end;
  Close(F);
  Writeln(#10#13'                         Copyright (C) 1998  Tomas Hujer');
  GotoXY(35,25);Write('Stiskni ESC');
  Repeat until ReadKey=#27;
  InitDeskTop;
  TextColor(7);
  InitDeskTop;
  MainInfo;
end;

Procedure Ostatni;
begin
  TextColor(7);

  {Zjisti stav verify v DOSu}
  GotoXY(2,3);Write('VERIFY : ');
  Asm
  Mov ah,$54
  Int $21
  Mov Out,Al
  end;
  If Out=1 then Writeln('ON')
  Else Writeln('OFF');

  {Zjisti stav kontroly BREAK v DOSu'}
  GotoXY(2,5);Write('BREAK  : ');
  GetCBreak(CB);
  If CB then Writeln('ON')
  Else Writeln('OFF');

  Konec:=False;
  repeat
    GetTime(h,m,s,st);GotoXY(71,1);Write(h,':',m,':',s,'  ');
    If Port[$60]=68 then Done;
    Locky;
  until (port[$60]=1)or(Konec=True);
  MainInfo;
  While Port[$60]=1 do;
end;

Begin
  ClrScr;
  InitDesktop;
  MainInfo;
  Repeat
    GetTime(h,m,s,st);GotoXY(71,1);Write(h,':',m,':',s,'  ');
    If Port[$60]=2 then DosUtils;
    If Port[$60]=3 then Disky;
    If Port[$60]=4 then Ostatni;
    If Port[$60]=5 then Pamet;
    If Port[$60]=6 then Porty;
    If Port[$60]=7 then HelpMe;
    Locky;
  until port[$60]=1;
  Done;
end.