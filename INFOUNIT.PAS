Unit InfoUnit;

interface
Uses Dos,Crt,Graph;
Var
  IntSave : Procedure;
  Volba     :Char;
  Mouse     :Boolean;
  Regs      :Registers;
  n,GrDriver,GrMode,Error  :Integer;
  Out       :Byte;
  Ver       :Word;
  xx,yy     :Integer;
  h,m,s,st,y,d,dow             :Word;
  Test   :Byte absolute 0:$0417;
  Press  :Byte absolute 0:$418;
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

const
  Days:array[0..6] of String[9]=
    ('Nedele','Pondeli','Utery','Streda','Ctvrtek','Patek','Sobota');

Procedure TestMouseDriver;
Procedure ShowMouse;
Procedure HideMouse;
Function DoubleClick:Boolean;
Procedure SetMouseRateX(xmin,xmax:word);
Procedure SetMouseRateY(ymin,ymax:word);
Procedure FeelMouse(x,y:word);
Procedure CurrentMousePosition(Var x,y:Integer);
Procedure SetMousePosition(X,Y:Integer);
Procedure TestButton(Tlacitko:Byte;Var Stav:Byte);
Procedure Ikona(x0,y0:Integer;cislo,s,Soubor:String);
Procedure Help(i:integer;s:string);
Procedure InitGraphic;
Procedure Locks;
Procedure SwapLPT;
Procedure SwapCOM;
Function Disketa(A:Byte):Boolean;
Function TypDrive(s:string):String;
Procedure ViewAutoex;
Procedure ViewConfig;
Procedure InitDesktop;
Procedure MainInfo;
Procedure Init;
Procedure Done;
Procedure InitIcons;
Procedure InitMouse;
Procedure Back;
Procedure VideoRomBIOS;

Implementation

Procedure Init;
begin
  HideMouse;
  SetViewPort(0,20,536,400,ClipOn);
  ClearViewPort;
  SetViewPort(550,80,605,150,ClipOn);
  ClearViewPort;
  Ikona(560,100 , 'ESC' , 'Zpet  ' , '.\data\exit.ico');
  SetViewPort(0,0,GetMaxX,GetMaxY,ClipOn);
  SetMousePosition(300,200);
  TextColor(7);
  SetColor(15);
  SetTextStyle(0,0,1);
  ShowMouse;
end;

Procedure InitDesktop;
begin
  SetBkColor(8);
  SetColor(7);
  Line(540,0,540,70);
  Line(540,70,640,70);

  SetColor(1);
  Rectangle(0,0,GetMaxX-100,16);
  SetColor(15);
  SetFillStyle(1,1);
  FloodFill(5,5,1);
  SetColor(10);
  SetTextStyle(1,0,1);OutTextXY(250,-4,'INFO MANAZER');

  SetColor(7);
  SetTextStyle(0,0,1);
  OutTextXY(185,430,'NumLock');
  OutTextXY(285,430,'CapsLock');
  OutTextXY(385,430,'ScrollLock');
  OutTextXY(565,242,'R Shift');
  OutTextXY(565,257,'L Shift');
  OutTextXY(565,272,'R Control');
  OutTextXY(565,287,'L Control');
  OutTextXY(565,302,'R Alt');
  OutTextXY(565,317,'L Alt');

  If Test and 32=32 then SetFillStyle(1,10) Else SetFillStyle(1,0);
  FillEllipse(210,420,5,5);
  If Test and 64=64 then SetFillStyle(1,10) Else SetFillStyle(1,0);
  FillEllipse(310,420,5,5);
  If Test and 16=16 then SetFillStyle(1,10) Else SetFillStyle(1,0);
  FillEllipse(410,420,5,5);
  SetFillStyle(1,0);
  FillEllipse(550,245,5,5);
  FillEllipse(550,260,5,5);
  FillEllipse(550,275,5,5);
  FillEllipse(550,290,5,5);
  FillEllipse(550,305,5,5);
  FillEllipse(550,320,5,5);

  If Mouse then SetFillStyle(1,1);
  If Mouse then Rectangle(550,350,600,420);
  If Mouse then Line(551,377,599,377);
  If Mouse then OutTextXY(555,400,'Mouse');
  SetColor(1);
  Rectangle(0,450,GetMaxX,GetMaxY);
end;

Procedure ViewAutoex;
begin
  HideMouse;
  ClearDevice;
  SetBkColor(0);
  GotoXY(2,2);
  SetColor(10);
  SwapVectors;
  Exec(GetEnv('COMSPEC'),'/C TYPE C:\AUTOEXEC.BAT |More');
  SwapVectors;
  Repeat until ReadKey=#27;
  ClearDevice;
  InitDeskTop;
  SetColor(7);
  Ikona(560,100 , 'ESC' , 'Zpet  ' , '.\data\exit.ico');
  SetMousePosition(300,200);
  TextColor(7);
  SetColor(15);
  SetTextStyle(0,0,1);
  Ikona(50 , 50 , '1' , 'Zobrazit AUTOEXEC.BAT' , '.\data\porty.ico');
  Ikona(300, 50 , '2' , 'Zobrazit CONFIG.SYS' , '.\data\porty.ico');
  Ver:=DosVersion;
  GotoXY(2,9);Write('Verze DOSu : ',Lo(Ver),'.',Hi(Ver));
  GotoXY(2,10);
  Write('Datum BIOSu : ',Chr(Date1),Chr(Date2),Chr(Date3),
  Chr(Date4),Chr(Date5),Chr(Date6),Chr(Date7),Chr(Date8));
  GotoXY(2,11);
  {Write('Typ BIOSu : ',Chr(BIOS0),Chr(BIOS1),Chr(BIOS2),Chr(BIOS3),
  Chr(BIOS4),Chr(BIOS5),Chr(BIOS6),Chr(BIOS7),Chr(BIOS8),Chr(BIOS9),
  Chr(BIOSA),Chr(BIOSB),Chr(BIOSC),Chr(BIOSD),Chr(BIOSE),Chr(BIOSF),
  Chr(BIOS10),Chr(BIOS11));
  GotoXY(1,12);}
  Write('Video ROM BIOS : ',Chr(VIDEO01),Chr(VIDEO02),Chr(VIDEO03),
  Chr(VIDEO04),Chr(VIDEO05),Chr(VIDEO06),Chr(VIDEO07),Chr(VIDEO08),
  Chr(VIDEO09),Chr(VIDEO0A),Chr(VIDEO0B),Chr(VIDEO0C),Chr(VIDEO0D),
  Chr(VIDEO0E),Chr(VIDEO0F));
  SetColor(10);OutTextXY(10,200,'Promenne prostredi :');
  SetColor(7);
  yy:=0;
  For Out:=0 to EnvCount do
  begin
    yy:=yy+1;
    If yy<27 then
    begin
      OutTextXY(1,yy*10+200,'   '+Copy(EnvStr(Out),0,60));
      If Length(EnvStr(Out))>60 then
      begin
        yy:=yy+1;
        OutTextXY(1,yy*10+200,'     '+Copy(EnvStr(Out),61,128));
        yy:=yy+1;
        If Length(EnvStr(Out))>128 then
        begin
          yy:=yy+1;
          OutTextXY(1,yy*10+200,'       '+
            Copy(EnvStr(Out),129,Length(EnvStr(Out))));
          yy:=yy+1;
        end;
      end;
    end;
  end;
  ShowMouse;
end;

Procedure ViewConfig;
begin
  HideMouse;
  SetBkColor(0);
  ClearDevice;
  GotoXY(2,2);
  SetColor(10);
  SwapVectors;
  Exec(GetEnv('COMSPEC'),'/C TYPE C:\CONFIG.SYS |More');
  SwapVectors;
  Repeat until ReadKey=#27;
  ClearDevice;
  InitDeskTop;
  SetColor(7);
  Ikona(560,100 , 'ESC' , 'Zpet  ' , '.\data\exit.ico');
  SetMousePosition(300,200);
  TextColor(7);
  SetColor(15);
  SetTextStyle(0,0,1);
  Ikona(50 , 50 , '1' , 'Zobrazit AUTOEXEC.BAT' , '.\data\porty.ico');
  Ikona(300, 50 , '2' , 'Zobrazit CONFIG.SYS' , '.\data\porty.ico');
  Ver:=DosVersion;
  GotoXY(2,9);Write('Verze DOSu : ',Lo(Ver),'.',Hi(Ver));
  GotoXY(2,10);
  Write('Datum BIOSu : ',Chr(Date1),Chr(Date2),Chr(Date3),
  Chr(Date4),Chr(Date5),Chr(Date6),Chr(Date7),Chr(Date8));
  GotoXY(2,11);
  {Write('Typ BIOSu : ',Chr(BIOS0),Chr(BIOS1),Chr(BIOS2),Chr(BIOS3),
  Chr(BIOS4),Chr(BIOS5),Chr(BIOS6),Chr(BIOS7),Chr(BIOS8),Chr(BIOS9),
  Chr(BIOSA),Chr(BIOSB),Chr(BIOSC),Chr(BIOSD),Chr(BIOSE),Chr(BIOSF),
  Chr(BIOS10),Chr(BIOS11));}
  Write('Video ROM BIOS : ',Chr(VIDEO01),Chr(VIDEO02),Chr(VIDEO03),
  Chr(VIDEO04),Chr(VIDEO05),Chr(VIDEO06),Chr(VIDEO07),Chr(VIDEO08),
  Chr(VIDEO09),Chr(VIDEO0A),Chr(VIDEO0B),Chr(VIDEO0C),Chr(VIDEO0D),
  Chr(VIDEO0E),Chr(VIDEO0F));
  SetColor(10);OutTextXY(10,200,'Promenne prostredi :');
  SetColor(7);
  yy:=0;
  For Out:=0 to EnvCount do
  begin
    yy:=yy+1;
    If yy<27 then
    begin
      OutTextXY(1,yy*10+200,'   '+Copy(EnvStr(Out),0,60));
      If Length(EnvStr(Out))>60 then
      begin
        yy:=yy+1;
        OutTextXY(1,yy*10+200,'     '+Copy(EnvStr(Out),61,128));
        yy:=yy+1;
        If Length(EnvStr(Out))>128 then
        begin
          yy:=yy+1;
          OutTextXY(1,yy*10+200,'       '+
            Copy(EnvStr(Out),129,Length(EnvStr(Out))));
          yy:=yy+1;
        end;
      end;
    end;
  end;
  ShowMouse;
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


Procedure Ikona(x0,y0:Integer;cislo,s,Soubor:String);
Var
  F:file of Byte;
  P:Byte;
  x,y:Integer;
  i:LongInt;

begin
  SetViewPort(x0,y0,x0+32,y0+32,Clipon);
  {$I-}
  Assign(F,Soubor);
  FileMode:=0;
  Reset(F);
  {$I+}
  If IOResult<>0 then
  begin
    For n:=0 to 15000 do
    PutPixel(Random(100),Random(100),Random(15));
    SetViewPort(0,0,GetMaxX,GetMaxY,Clipon);
    OutTextXY(x0,y0+40,s);
    Exit;
  end;
  For y:=1 to 126 do read(F,P);
  For y:=32 downto 1 do
  For x:=1 to 16 do
    begin
      If EOF(F) then
        begin
          SetViewPort(0,0,GetMaxX,GetMaxY,Clipon);
          OutTextXY(x0,y0+40,s);
          Exit;
        end;
      Read(F,P);

      If test and 16=16 then
      begin
        Repeat
          Volba:=ReadKey;
          If Volba=#27 then Halt;
        until Volba=#13;
        GotoXY(10,10);Write(P,'  ');
      end;

      If Soubor='.\data\disk5-25.ico' then If P=0 then P:=1;{Nastaveni modre ikony B:}
      If Soubor='.\data\pamet.ico' then If P=8 then P:=1;{Nastaveni modre ikony pamet}
      If Soubor='.\data\pamet.ico' then If P=7 then P:=1;
      If Soubor='.\data\pamet.ico' then If P=16 then P:=1;
      If Soubor='.\data\pamet.ico' then If P=24 then P:=1;
      {Nastaveni zakladnich barev ikony :}
      If P=151 then P:=14;
      If P=121 then P:=14;
      If P=4 then P:=0;
      If P=34 then P:=9;
      If P=154 then P:=2;
      If P=78 then P:=9;
      If P=238 then P:=9;
      If P=11 then P:=14;
      If P=251 then P:=14;
      If P=112 then P:=0;
      If P=153 then P:=12;
      If P=17 then P:=4;
      If P=187 then P:=14;
      If P=68 then P:=0;
      If P=102 then P:=2;
      If P=204 then P:=1;
      If P=228 then P:=1;
      If P=25 then P:=12;
      If P=129 then P:=12;
      PutPixel(x*2,y,P);
      i:=(x*2)+1;
      PutPixel(i,y,P);
    end;
  SetViewPort(0,0,GetMaxX,GetMaxY,Clipon);
  OutTextXY(x0,y0+40,s);
  OutTextXY(x0+5,y0-15,Cislo);
  Close(F);
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


Procedure Help(i:integer;s:string);
begin
  SetColor(11);
  SetTextStyle(1,0,2);
  If s='MAIN' then
    Case i of
    0:begin
        OutTextXY(10,450,'ESC ... Konec programu');
      end;
    1:begin
        OutTextXY(10,450,'1 ... Informace o DOSu');
      end;
    2:begin
      OutTextXY(10,450,'2 ... Informace o discich');
      end;
    3:begin
        OutTextXY(10,450,'3 ... Ostatni informace');
      end;
    4:begin
        OutTextXY(10,450,'4 ... Informace o pameti');
      end;
    5:begin
        OutTextXY(10,450,'5 ... Informace o portech');
      end;
    6:begin
        OutTextXY(10,450,'6 ... Napoveda k programu');
      end;
    7:begin
        OutTextXY(10,450,'Infomace o stisnutych tlacitkach na mysi');
      end;
    8:begin
        OutTextXY(10,450,'Stav NUMLOCK');
      end;
    9:begin
        OutTextXY(10,450,'Stav CAPSLOCK');
      end;
    10:begin
        OutTextXY(10,450,'Stav SCROLLLOCK');
      end;
    11:begin
        OutTextXY(10,450,'Aktualni cas');
      end;
    12:begin
        OutTextXY(10,450,'Aktualni souradnice kurzoru mysi');
      end;
    13:begin
        OutTextXY(10,450,'Stav klavesy SCROLLLOCK');
      end;
    14:begin
        OutTextXY(10,450,'Zobrazuje aktualni stav funkcnich klaves');
      end;
    15:begin
        OutTextXY(10,450,'Zobrazuje pocet tiku od resetu (1 tik - 55ms)');
      end;
    end;

  If s='Porty' then
    Case i of
    0:begin
        OutTextXY(10,450,'Navrat do hlavniho menu');
      end;
    1:begin
        OutTextXY(10,450,'Prohodi porty COM1 a COM2');
      end;
    2:begin
      OutTextXY(10,450,'Prohodi porty LPT1 a LPT2');
      end;
    3:begin
        OutTextXY(10,450,'Obecne informace o portech');
      end;
    4:begin
        OutTextXY(10,450,'Napoveda');
      end;
    end;

  Repeat
   If Mouse then TestButton(1,Out);
   Delay(1000);
  until (Out=0);

  SetColor(1);
  Rectangle(0,450,GetMaxX,GetMaxY);
  SetFillStyle(0,1);
  FloodFill(2,451,1);
  SetTextStyle(0,0,1);
end;

Procedure InitGraphic;
begin
  Writeln('Instaluje se graficky driver ...');
  DirectVideo:=False;
  DetectGraph(GrDriver,GrMode);
  InitGraph(GrDriver,GrMode,'.\data');
  Error:=-GraphResult;
  If Error<>0 then Write('CHYBA  c. ',Error,' : ');
  Case Error of
    0 :;
    1 : begin Writeln('Grafika (BGI) neinstalovana.');Halt(1);end;
    2 : begin Writeln('Nebyl zjisten graficky hardware.');Halt(1);end;
    3 : begin Writeln('Nenalezen soubor s driverem zarizeni.');Halt(1);end;
    4 : begin Writeln('Neplatny soubor s driverem zarizeni.');Halt(1);end;
    5 : begin Writeln('Malo pameti pro zaveden¡ driveru.');Halt(1);end;
    6 : begin Writeln('Vycerpana pamet pri vyplnovani typu scan.');Halt(1);end;
    7 : begin Writeln('Vycerpana pamet pri vyplnovani typu flood.');Halt(1);end;
    8 : begin Writeln('Nenalezen soubor s fontem.');Halt(1);end;
    9 : begin Writeln('Malo pameti k zaveden¡ fontu.');Halt(1);end;
    10 : begin Writeln('Neplatny graficky rezim pro zvoleny driver.');Halt(1);end;
    11 : begin Writeln('Chyba grafiky (generick  chyba).');Halt(1);end;
    12 : begin Writeln('Vstupne/Vystupn¡ chyba grafiky.');Halt(1);end;
    13 : begin Writeln('Neplatny soubor s fontem.');Halt(1);end;
    14 : begin Writeln('Neplatne cislo fontu.');Halt(1);end
    Else begin Writeln('Neznama chyba pri inicializaci grafickeho driveru.');Halt(1);end;
  end;
end;

Procedure Locks;
Var
  Tik1                         :Word absolute 0:$46c;
  Tik2                         :Word absolute 0:$46e;
begin
  SetColor(7);
  GotoXY(70,13);Write(Press,'  ',Test,'  ');
  GotoXY(70,14);Write(Port[$60],'  ');

  If (Test and 8=8)and(Press=2) then{L Alt}
  begin
    SetFillStyle(1,10);
    FillEllipse(550,320,5,5);
  end
  Else
  begin
    If port[$60]=184 then
    begin
      port[$60]:=1;
      SetFillStyle(1,0);
      FillEllipse(550,320,5,5);
    end;
  end;


  If (Test and 8=8)and(Press=0) then{R Alt}
  begin
    SetFillStyle(1,10);
    FillEllipse(550,305,5,5);
  end
  Else
  begin
    If port[$60]=184 then
    begin
      port[$60]:=1;
      SetFillStyle(1,0);
      FillEllipse(550,305,5,5);
    end;
  end;

  If (Test and 4=4)and(Press=0) then{R Control}
  begin
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
  begin
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
  begin
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
  begin
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
  begin
    If Test and 32=32 then SetFillStyle(1,10) Else SetFillStyle(1,0);
    FillEllipse(210,420,5,5);
  end;

  If Press and 64=64 then  {CapsLock}
  begin
    If Test and 64=64 then SetFillStyle(1,10) Else SetFillStyle(1,0);
    FillEllipse(310,420,5,5);
  end;

  If Press and 16=16 then  {ScrollLock}
  begin
    If Test and 16=16 then SetFillStyle(1,10) Else SetFillStyle(1,0);
    FillEllipse(410,420,5,5);
  end;

  If Mouse then If Out and 1=1 then SetFillStyle(1,10) Else SetFillStyle(1,0);
  If Mouse then Bar(551,351,565,375);

  If Mouse then If Out and 2=2 then SetFillStyle(1,10) Else SetFillStyle(1,0);
  If Mouse then Bar(585,351,599,375);

  If Mouse then If Out and 4=4 then SetFillStyle(1,10) Else SetFillStyle(1,0);
  If Mouse then Bar(567,351,583,375);

  GotoXY(70,11);Writeln(Tik2,Tik1);
  Asm
    Mov ah,$0C
    Int $21
    Mov Out,al
  end;
end;


Procedure TestMouseDriver;
{Test pritomnosti driveru mysi v pameti}
begin
  Mouse:=False;
  Regs.ax:=$00;
  Intr($33,regs);
  If Regs.ax=$0000 then
  Begin
    Writeln('Driver mysi neni instalovan');
    Writeln('chcete ho nyni spustit (A/N) ? ');
    Repeat until keypressed;
    Writeln;
    Volba:=ReadKey;
    If (Volba='A')or(Volba='a') then
    begin
      SwapVectors;
      Exec(GetEnv('COMSPEC'),'/C mouse.com');
      SwapVectors;
      if (DosError<>0)or(IOResult<>0) then
      begin
        Writeln('Nelze spustit driver mysi.');
        Writeln('Driver nebude instalovan.');
      end
      Else Mouse:=True;
    end;
  end
  Else Mouse:=True;
end;

Procedure ShowMouse;Assembler;
{Zobrazit kurzor}
asm
 Mov ax,1
 Int $33
end;

Procedure HideMouse;Assembler;
{Skryt kurzor}
asm
 Mov ax,2
 Int $33
end;

Function DoubleClick:Boolean;
Var n:byte;
Begin
  DoubleClick:=False;
  Regs.ax:=$05;
  Regs.bx:=$00;
  Intr($33,Regs);
  n:=Regs.bx;
  If n>1 then DoubleClick:=True;
end;

Procedure SetMouseRateX(xmin,xmax:word);Assembler;
{Nastaven¡ horizont ln¡ho rozsahu sou©adnic}
asm
  Mov ax,7
  Mov cx,xmin
  Mov dx,xmax
  Int $33
end;

Procedure SetMouseRateY(ymin,ymax:word);Assembler;
{Nastaven¡ vertikalniho rozsahu souradnic}
Asm
  Mov ax,8
  Mov cx,ymin
  Mov dx,ymax
  Int $33
end;


Procedure FeelMouse(x,y:word);Assembler;
{Citivost kurzoru na pohyb mysi}
Asm
  Mov ax,$0f
  Mov cx,x
  Mov dx,y
  Int $33
end;

Procedure CurrentMousePosition(Var x,y:Integer);
{Zjisti aktualni pozici kurzoru mysi}
Begin
  Regs.ax:=$03;
  Intr($33,Regs);
  x:=Regs.cx;
  y:=Regs.dx;
end;

Procedure SetMousePosition(X,Y:Integer);Assembler;
Asm
  Mov ax,4
  Mov cx,x
  Mov dx,y
  Int $33
end;

Procedure TestButton(Tlacitko:Byte;Var Stav:Byte);
{Zjisti stav tlacitek}
begin
  Regs.AX:=$05;
  Regs.BX:=Tlacitko;
  Intr ($33,Regs);
  Stav:=Regs.ax;
end;

Procedure SwapLPT;
begin
  TextColor(12);
  GotoXY(20,20);Write('Po teto operaci musi byt tento program ukoncen.');
  GotoXY(30,21);Write('Chcete pokracovat (A/) ?');
  Volba:=ReadKey;
  If UpCase(Volba)='A' then
  begin
    CloseGraph;
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
    CloseGraph;
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

Procedure MainInfo;
begin
  TextColor(7);
  GetDate(y,m,d,dow);
  GotoXY(10,10);Write('Dnes je ',days[dow],'  ',m:0,'.', d:0,'.', y:0);
  GotoXY(10,12);Write('Procesor : ');
  If Test8086=0 then Write('8086');
  If Test8086=1 then Write('80286');
  If Test8086=2 then Write('80386 nebo vyssi');
  {Kontrola zalozni baterie pro CMOS}
  GotoXY(10,14);Write('Napajeni CMOS : ');
  asm
  Mov al,$d
  Out $70,al
  In al,$71
  Mov Out,al
  end;
  If (Out and 128)=128 then Write('v poradku')
  Else Write('vymente zalozni baterii !!!');

  {Zjisteni matem. koprocesoru}
  GotoXY(10,16);
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
  GotoXY(10,18);
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

Procedure Done;
Var i,n:integer;
begin
  i:=30;
  repeat
    i:=i-5;
    SetRGBPalette(8,i,i,i);
    SetRGBPalette(56,i,i,i);
    SetRGBPalette(59,i,i,i);
    SetRGBPalette(61,i,i,i);
    SetRGBPalette(62,i,i,i);
    SetRGBPalette(60,i,i,i);
    SetRGBPalette(61,i,i,i);
    SetRGBPalette(62,i,i,i);
    SetRGBPalette(63,i,i,i);
    SetRGBPalette(64,i,i,i);
  until i<1;
  TextBackground(0);
  SetBkColor(0);
  CloseGraph;
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

Procedure InitMouse;
begin
  SetMouseRateX(0,630);
  SetMouseRateY(0,470);
  FeelMouse(7,7);
end;

Procedure InitIcons;
begin
  TextColor(7);
  SetColor(15);
  SetTextStyle(0,0,1);
  Ikona(40 , 50 , '1' , 'DOS' , '.\data\dos.ico');
  Ikona(125, 50 , '2' , 'Disky' , '.\data\disk.ico');
  Ikona(210, 50 , '3' , 'Ostatni' , '.\data\config.ico');
  Ikona(295, 50 , '4' , 'Pamet' , '.\data\pamet.ico');
  Ikona(380, 50 , '5' , 'Porty' , '.\data\porty.ico');
  Ikona(465, 50 , '6' , 'Help' , '.\data\help.ico');
  Ikona(560,100 , 'ESC' , 'Konec' , '.\data\exit.ico');
end;

Procedure Back;
begin
  HideMouse;
  SetViewPort(0,20,536,400,ClipOn);
  ClearViewPort;
  SetViewPort(550,80,605,150,ClipOn);
  ClearViewPort;
  SetViewPort(0,0,GetMaxX,GetMaxY,ClipOn);
  SetMousePosition(300,200);
  InitMouse;
  InitIcons;
  MainInfo;
  ShowMouse;
  While Port[$60]=1 do;
end;

Procedure VideoRomBIOS;
begin
  Write('Video ROM BIOS : ',Chr(VIDEO01),Chr(VIDEO02),Chr(VIDEO03),
  Chr(VIDEO04),Chr(VIDEO05),Chr(VIDEO06),Chr(VIDEO07),Chr(VIDEO08),
  Chr(VIDEO09),Chr(VIDEO0A),Chr(VIDEO0B),Chr(VIDEO0C),Chr(VIDEO0D),
  Chr(VIDEO0E),Chr(VIDEO0F));
end;

Begin
end.