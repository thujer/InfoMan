{$M 8000,0,30000}
Uses Dos,Crt,Graph,InfoUnit;
Var
  Hex         :LongInt;
  CB,Konec    :Boolean;

Procedure Disky;
Var
  DskX,DskY,i :Integer;
  Celkem      :LongInt;
begin
  Init;
  GotoXY(1,10);
  dskX:=0;dskY:=0;
  HideMouse;
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
      If Out<>0 then Writeln('Na disketovou jednotku A: je mozne se odkazat i jako na B:');
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
    If i<=2 then
    begin
      If (i=1)and(TypDrive('A:')='3.5') then Ikona(10+dskX*60,50,'',' '+chr(i+64)+': ','.\data\disk3-5.ico');
      If (i=1)and(TypDrive('A:')='5.25') then Ikona(10+dskX*60,50,'',' '+chr(i+64)+': ','.\data\disk5-25.ico');
      If (i=2)and(TypDrive('B:')='5.25') then Ikona(10+dskX*60,50,'',' '+chr(i+64)+': ','.\data\disk5-25.ico');
      If (i=2)and(TypDrive('B:')='3.5') then Ikona(10+dskX*60,50,'',' '+chr(i+64)+': ','.\data\disk3-5.ico');
      dskX:=dskX+1;
    end;
    If DiskFree(i)<>-1 then
    begin
      If DskX=9 then DskY:=DskY+1;If DskX=18 then DskY:=DskY+1;
      If (i<>1)and(i<>2) then Ikona(10+dskX*60,50+dskY*80,'',' '+chr(i+64)+': ','.\data\disk.ico');

      If (DiskFree(i) div 1024)>1500 then
      Writeln('Disk '+chr(i+64)+' : ',(DiskFree(i) div 1024)div 1024,
      ' Mb volnych , Celkem : ',(DiskSize(i) div 1024)div 1024,' Mb')
      Else
      Writeln('Disk '+chr(i+64)+' : ',DiskFree(i) div 1024, ' Kb volnych , ',
      'Celkem : ',DiskSize(i) div 1024,' Kb');
      If i>2 then dskX:=dskX+1;
    end;
  end;
  ShowMouse;
  Konec:=False;
  Repeat
    If Mouse then CurrentMousePosition(xx,yy);
    If Mouse then GotoXY(71,3);If Mouse then Write('x= ',xx,'  ');
    If Mouse then GotoXY(71,4);If Mouse then Write('y= ',yy,'  ');
    GetTime(h,m,s,st);GotoXY(71,1);Write(h,':',m,':',s,'  ');
    Locks;
    TestButton(1,Out);
    If (Out=1)and(xx>=560)and(yy>=100)and(xx<=595)and(yy<=135)then Konec:=True;
    If (Out=2)and(xx>=560)and(yy>=100)and(xx<=595)and(yy<=135)then Help(0,'Porty');
    If Port[$60]=68 then Done;
  until (port[$60]=1)or(Konec=True);
  Back;
end;

Procedure Porty;
begin
  Init;TextColor(7);SetColor(15);SetTextStyle(0,0,1);
  Ikona(50 , 50 , '1' , 'Prohodit COM1 a COM2' , '.\data\porty.ico');
  Ikona(300, 50 , '2' , 'Prohodit LPT1 a LPT2' , '.\data\porty.ico');
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
  ShowMouse;
  Konec:=False;
  repeat
    If Mouse then CurrentMousePosition(xx,yy);
    If Mouse then GotoXY(71,3);If Mouse then Write('x= ',xx,'  ');
    If Mouse then GotoXY(71,4);If Mouse then Write('y= ',yy,'  ');
    GetTime(h,m,s,st);GotoXY(71,1);Write(h,':',m,':',s,'  ');
    If Mouse then TestButton(1,Out);
    If (Out=1)and(xx>=560)and(yy>=100)and(xx<=595)and(yy<=135)then Konec:=True;
    If (Port[$60]=2)or((Out=1)and(xx>= 50)and(yy>=50)and(xx<= 85)and(yy<100))then SwapCOM;
    If (Port[$60]=3)or((Out=1)and(xx>=300)and(yy>=50)and(xx<=335)and(yy<100))then SwapLPT;
    If Port[$60]=68 then Done;
    If (Out=2)and(xx>=560)and(yy>=100)and(xx<=595)and(yy<=135)then Help(0,'Porty');
    If (Port[$60]=59)or((Out=2)and(xx>= 50)and(yy>=50)and(xx<= 85)and(yy<100))then Help(1,'Porty');
    If (Port[$60]=60)or((Out=2)and(xx>=300)and(yy>=50)and(xx<=335)and(yy<100))then Help(2,'Porty');
    Locks;
  until (port[$60]=1)or(Konec=True);
  Back;
end;

Procedure Pamet;
Var
  Celkem,Volnych    :Word;
  CelkemK,VolnychK  :LongInt;
begin
  Init;TextColor(7);SetColor(15);
  {Zjisteni velikosti zakladni pameti:}
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
  {Zjisteni velikosti rozsirene pameti:}
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
   Writeln('... nemusi platit pokud mate jinou',
   #10#13'velikost konvencni pameti nez 640 K.');
   TextColor(7);
  end;
  VolnychK:=0;
  asm
    Mov ah,48h
    Mov bx,0fffh
    Int $21
    Mov Volnych,bx
  end;
  VolnychK:=Volnych;
  Writeln(#10#13'Volna konvencni pamet : ',(VolnychK*16+MaxAvail) div 1024,' Kb');
  {asm
    Mov ah,42h
    Int 67h
    Mov Celkem,dx
    Mov Volnych,bx
  end;
  CelkemK:=Celkem;VolnychK:=Volnych;
  Writeln(#10#13'Celkem pameti EMS v systemu : ',CelkemK*16,' K');
  Writeln(#10#13'Volna pamet EMS v systemu : ',VolnychK*16,' K');}
  ShowMouse;Konec:=False;
  repeat
    If Mouse then CurrentMousePosition(xx,yy);
    If Mouse then GotoXY(71,3);If Mouse then Write('x= ',xx,'  ');
    If Mouse then GotoXY(71,4);If Mouse then Write('y= ',yy,'  ');
    GetTime(h,m,s,st);GotoXY(71,1);Write(h,':',m,':',s,'  ');
    If Mouse then TestButton(1,Out);
    If (Out=1)and(xx>=560)and(yy>=100)and(xx<=595)and(yy<=135)then Konec:=True;
    If Port[$60]=68 then Done;
    If (Out=2)and(xx>=560)and(yy>=100)and(xx<=595)and(yy<=135)then Help(0,'Porty');
    Locks;
  until (port[$60]=1)or(Konec=True);
  Back;
end;


Procedure DosUtils;
begin
  Init;TextColor(7);SetColor(15);
  SetTextStyle(0,0,1);
  Ikona(50 , 50 , '1' , 'Zobrazit AUTOEXEC.BAT' , '.\data\porty.ico');
  Ikona(300, 50 , '2' , 'Zobrazit CONFIG.SYS' , '.\data\porty.ico');

  Ver:=DosVersion;
  GotoXY(2,9);Write('Verze DOSu : ',Lo(Ver),'.',Hi(Ver));
  GotoXY(2,10);Write('Datum BIOSu : ',Chr(Date1),Chr(Date2),Chr(Date3),
  Chr(Date4),Chr(Date5),Chr(Date6),Chr(Date7),Chr(Date8));
  GotoXY(2,11);VideoRomBios;
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
  Konec:=False;
  repeat
    If Mouse then CurrentMousePosition(xx,yy);
    If Mouse then GotoXY(71,3);If Mouse then Write('x= ',xx,'  ');
    If Mouse then GotoXY(71,4);If Mouse then Write('y= ',yy,'  ');
    GetTime(h,m,s,st);GotoXY(71,1);Write(h,':',m,':',s,'  ');
    If Mouse then TestButton(1,Out);
    If (Out=1)and(xx>=560)and(yy>=100)and(xx<=595)and(yy<=135)then Konec:=True;
    If (Port[$60]=2)or((Out=1)and(xx>= 50)and(yy>=50)and(xx<= 85)and(yy<100))then ViewAutoex;
    If (Port[$60]=3)or((Out=1)and(xx>=300)and(yy>=50)and(xx<=335)and(yy<100))then ViewConfig;
    If Port[$60]=68 then Done;
    If (Out=2)and(xx>=560)and(yy>=100)and(xx<=595)and(yy<=135)then Help(0,'Porty');
    If (Port[$60]=59)or((Out=2)and(xx>= 50)and(yy>=50)and(xx<= 85)and(yy<100))then Help(1,'DOS');
    If (Port[$60]=60)or((Out=2)and(xx>=300)and(yy>=50)and(xx<=335)and(yy<100))then Help(2,'DOS');
    Locks;
  until (port[$60]=1)or(Konec=True);
  Back;
end;

Procedure HelpMe;
Var
  F   :Text;
  Ch  :Char;
begin
  HideMouse;
  SetViewPort(0,0,GetMaxX,GetMaxY,ClipOFF);
  SetBkColor(0);
  ClearDevice;
  SetColor(10);
  Assign(F,'.\DATA\HELP.DAT');
  {$I-}
  Reset(F);
  {$I+}
  If IOResult<>0 then
  begin
    GotoXY(20,5);Write('Soubor HELP.DAT nenalezen.  Stiskni ESC.');
    Repeat until ReadKey=#27
  end
  Else
  begin
    GotoXY(2,2);
    While not Eof(F) do
    begin
      Read(F, Ch);
      Write(Ch);
    end;
    Close(F);
    Writeln(#10#13'                         Copyright (c) 1998  Tomas Hujer');
    GotoXY(35,25);Write('Stiskni ESC');
    Repeat until ReadKey=#27;
  end;
  ClearDevice;
  InitDeskTop;
  SetColor(7);
  Ikona(560,100 , 'ESC' , 'Zpet  ' , '.\data\exit.ico');
  SetMousePosition(300,200);
  TextColor(7);SetColor(15);
  SetTextStyle(0,0,1);
  InitDeskTop;InitIcons;
  MainInfo;
  ShowMouse;
end;

Procedure Ostatni;
begin
  Init;
  GotoXY(2,3);Write('VERIFY : ');
  Asm
  Mov ah,$54
  Int $21
  Mov Out,Al
  end;
  If Out=1 then Writeln('ON') else Writeln('OFF');
  GotoXY(2,5);Write('BREAK  : ');
  GetCBreak(CB); If CB then Writeln('ON') else Writeln('OFF');
  ShowMouse;
  Konec:=False;
  repeat
    If Mouse then CurrentMousePosition(xx,yy);
    If Mouse then GotoXY(71,3);If Mouse then Write('x= ',xx,'  ');
    If Mouse then GotoXY(71,4);If Mouse then Write('y= ',yy,'  ');
    GetTime(h,m,s,st);GotoXY(71,1);Write(h,':',m,':',s,'  ');
    If Mouse then TestButton(1,Out);
    If (Out=1)and(xx>=560)and(yy>=100)and(xx<=595)and(yy<=135)then Konec:=True;
    If (Out=2)and(xx>=560)and(yy>=100)and(xx<=595)and(yy<=135)then Help(0,'Porty');
    If Port[$60]=68 then Done;
    Locks;
  until (port[$60]=1)or(Konec=True);
  Back;
end;

Begin
  TextBackground(0);
  TestMouseDriver;
  InitMouse;InitGraphic;InitDesktop;InitIcons;
  MainInfo;
  If Mouse then ShowMouse;
  Repeat
    If Mouse then CurrentMousePosition(xx,yy);
    If Mouse then GotoXY(71,3);If Mouse then Write('x= ',xx,'  ');
    If Mouse then GotoXY(71,4);If Mouse then Write('y= ',yy,'  ');
    GetTime(h,m,s,st);GotoXY(71,1);Write(h,':',m,':',s,'  ');
    If Mouse then TestButton(1,Out);
    If (Out=1)and(xx>=560)and(yy>=100)and(xx<=595)and(yy<=135)then Done;
    If (Port[$60]=2)or((Out=1)and(xx>= 40)and(yy>=50)and(xx<= 75)and(yy<100))then DosUtils;
    If (Port[$60]=3)or((Out=1)and(xx>=125)and(yy>=50)and(xx<=160)and(yy<100))then Disky;
    If (Port[$60]=4)or((Out=1)and(xx>=210)and(yy>=50)and(xx<=245)and(yy<100))then Ostatni;
    If (Port[$60]=5)or((Out=1)and(xx>=295)and(yy>=50)and(xx<=330)and(yy<100))then Pamet;
    If (Port[$60]=6)or((Out=1)and(xx>=380)and(yy>=50)and(xx<=415)and(yy<100))then Porty;
    If (Port[$60]=7)or((Out=1)and(xx>=465)and(yy>=50)and(xx<=500)and(yy<100))then HelpMe;
    If (Out=2)and(xx>=560)and(yy>=100)and(xx<=595)and(yy<=135)then Help(0,'MAIN');
    If (Port[$60]=59)or((Out=2)and(xx>= 40)and(yy>=50)and(xx<= 75)and(yy<100))then Help(1,'MAIN');
    If (Port[$60]=60)or((Out=2)and(xx>=125)and(yy>=50)and(xx<=160)and(yy<100))then Help(2,'MAIN');
    If (Port[$60]=61)or((Out=2)and(xx>=210)and(yy>=50)and(xx<=245)and(yy<100))then Help(3,'MAIN');
    If (Port[$60]=62)or((Out=2)and(xx>=295)and(yy>=50)and(xx<=330)and(yy<100))then Help(4,'MAIN');
    If (Port[$60]=63)or((Out=2)and(xx>=380)and(yy>=50)and(xx<=415)and(yy<100))then Help(5,'MAIN');
    If (Port[$60]=64)or((Out=2)and(xx>=465)and(yy>=50)and(xx<=500)and(yy<100))then Help(6,'MAIN');
    If (Out=2)and(xx>=550)and(yy>=350)and(xx<=600)and(yy<420)then Help(7,'MAIN');
    If (Out=2)and(xx>=180)and(yy>=400)and(xx<=245)and(yy<440)then Help(8,'MAIN');
    If (Out=2)and(xx>=280)and(yy>=400)and(xx<=350)and(yy<440)then Help(9,'MAIN');
    If (Out=2)and(xx>=380)and(yy>=400)and(xx<=460)and(yy<440)then Help(10,'MAIN');
    If (Out=2)and(xx>=540)and(yy>=0)and(xx<=GetMaxX)and(yy<20)then Help(11,'MAIN');
    If (Out=2)and(xx>=540)and(yy>=21)and(xx<=GetMaxX)and(yy<70)then Help(12,'MAIN');
    If (Out=2)and(xx>=530)and(yy>=230)and(xx<=630)and(yy<330) then Help(14,'MAIN');
    If (Out=2)and(xx>=550)and(yy>=160)and(xx<=600)and(yy<175) then Help(15,'MAIN');
    Locks;
  until port[$60]=1;
  While port[$60]=1 do;
  Done;
end.