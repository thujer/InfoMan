@ECHO OFF
REM       Univerzalni davkovy soubor pro radkouvou kompilaci
REM  pokud v adresari kompilovaneho zdrojaku neexistuje, zkopiruje se
REM  tam, jinak se preda rizeni batchi se stejnym jmenem v cilovem adresari
REM ------------------------------------------------------------------------
REM        1. Parametr - Cesta k tomuto souboru (napr. "C:\PRGJAZ\MODEM")
REM        2. Parametr - Jmeno souboru bez pripony (napr. "MODEM")
REM        3. Parametr - Pripona souboru (napr. ".A51")
REM        4. Parametr - RUN_ISP_LOADER ... Po kompilaci spusti ISP loader
REM                      INDIVIDUAL ... Spusti se batch v cilovem adresari
REM ------------------------------------------------------------------------
IF "%1"=="" GOTO HELPEXIT
IF "%4"=="INDIVIDUAL" GOTO RUNBATCH
IF EXIST %1COMPILE.BAT GOTO NEXT
COPY %0 %1COMPILE.BAT
ECHO Vytvoren individualni davkovy soubor v adresari %1

:NEXT
C:
CD %1
COMPILE.BAT %1 %2 %3 INDIVIDUAL

:RUNBATCH
REM --------------- Rozliseni kompilatoru podle pripony --------------------
IF %3==.PAS GOTO PAS_PREKLAD
IF %3==.A51 GOTO A51_4_PREKLAD
IF %3==.C51 GOTO C51_4_PREKLAD
IF %3==.C   GOTO CPlus_PREKLAD
IF %3==.C32 GOTO C32_PREKLAD
IF %3==.BAT GOTO BAT_ECHO
GOTO UNSIGNED_EXTENSION
REM ------------------------------------------------------------------------



REM ------------------------ Preklad pro PAS -------------------------------
:PAS_PREKLAD
ECHO Kompilace Turbo Pascal
C:
CD %1
IF NOT EXIST %2.PAS ECHO Soubor nenalezen "%2.PAS"
ECHO ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
C:\PRGJAZ\PASCAL\BP7\TPC.EXE %2.PAS
ECHO ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
PAUSE > NUL
%2.EXE
PAUSE > NUL
GOTO QUIT
REM ------------------------------------------------------------------------


REM ------------------------ Preklad pro C51 v4.01 -------------------------
:C51_4_PREKLAD
ECHO Kompilace C51 v4.01
C:\PRGJAZ\CPU51\LOADER\ENABLE.EXE 378h
SET C51LIB=c:\PRGJAZ\CPU51\C51_v401\LIB
SET C51INC=c:\PRGJAZ\CPU51\C51_v401\INC
SET C51PATH=c:\PRGJAZ\CPU51\C51_v401\BIN
CD %1
IF NOT EXIST %2.C51 ECHO Soubor nenalezen "%2.C51"
ECHO ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
ECHO C51: "%2.C51" TO "%2.obj"
c:\PRGJAZ\CPU51\C51_v401\BIN\C51.EXE %2.C51 DEBUG CODE LISTINCLUDE |MORE
ECHO ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

PAUSE >nul
CLS

IF NOT EXIST %2.OBJ ECHO Soubor nenalezen "%2.obj"
ECHO ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
ECHO L51: "%2.obj" TO "%2.omf"

IF EXIST %2.CMD GOTO CX4
IF EXIST LINKER.CMD GOTO CLINKER4
ECHO.
ECHO Soubor LINKER.CMD nenalezen !
GOTO CNOT4

:CLINKER4
 c:\PRGJAZ\CPU51\C51_v401\BIN\L51.EXE @LINKER.CMD | more
GOTO CNOT4

:CX4
c:\PRGJAZ\CPU51\C51_v401\BIN\L51.EXE @%2.CMD | more

:CNOT4
ECHO ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

PAUSE >nul
CLS

IF NOT EXIST %2.OMF ECHO Soubor nenalezen "%2.omf"
ECHO ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
ECHO OHS51: "%2.omf" TO "%2.hex"
c:\PRGJAZ\CPU51\C51_v401\BIN\OH51.EXE %2.OMF
ECHO ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

PAUSE >NUL
IF %%4==RUN_ISP_LOADER GOTO RUN_ISP_LOADER
GOTO QUIT
REM ------------------------------------------------------------------------


REM ------------------------ Preklad pro C51 v6.12 -------------------------
:C51_6_PREKLAD
ECHO Kompilace C51 v6.12
SET C51LIB=C:\PRGJAZ\CPU51\C51_v612\C51\LIB
SET C51INC=C:\PRGJAZ\CPU51\C51_v612\C51\INC
SET C51PATH=C:\PRGJAZ\CPU51\C51_v612\C51\BIN
CD %1
IF NOT EXIST %2.C51 ECHO Soubor nenalezen "%2.C51"
ECHO ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
ECHO C51: "%2.C51" TO "%2.obj"
c:\PRGJAZ\CPU51\C51_v612\C51\Bin\C51.EXE %2.C51 DEBUG CODE LISTINCLUDE |MORE
ECHO ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

PAUSE >nul
CLS

ECHO Linker v4.13
IF NOT EXIST %2.OBJ ECHO Soubor nenalezen "%2.obj"
ECHO ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
ECHO L51: "%2.obj" TO "%2.omf"
IF EXIST %2.CMD GOTO CX6
IF EXIST LINKER.CMD GOTO CLINKER6
ECHO.
ECHO Soubor LINKER.CMD nenalezen !
GOTO CNOT6

:CLINKER6
C:\PRGJAZ\CPU51\C51_v612\C51\Bin\BL51.EXE @LINKER.CMD | more
GOTO CNOT

:CX6
C:\PRGJAZ\CPU51\C51_v612\C51\Bin\BL51.EXE @%2.CMD | more

:CNOT6
ECHO ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
PAUSE >nul
CLS
IF NOT EXIST %2.OMF ECHO Soubor nenalezen "%2.omf"
ECHO ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
ECHO OHS51: "%2.omf" TO "%2.hex"
c:\PRGJAZ\CPU51\C51_v612\C51\Bin\OH51.EXE %2.OMF
ECHO ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

PAUSE >NUL
IF %%4==RUN_ISP_LOADER GOTO RUN_ISP_LOADER
GOTO QUIT
REM ------------------------------------------------------------------------




REM ------------------------ Preklad pro A51 v4.4 -------------------------
:A51_4_PREKLAD
CLS
ECHO Kompilace A51 V4.4
CD %1
REM IF NOT EXIST REG51.INC COPY C:\PRGJAZ\CPU51\A51\INC\REG51.INC >NUL
REM IF NOT EXIST REG52.INC COPY C:\PRGJAZ\CPU51\A51\INC\REG52.INC >NUL
ECHO ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
ECHO A51: "%2%3" TO "%2.obj"
C:\PRGJAZ\CPU51\A51\A51.EXE %2%3 DEBUG SYMBOLS XREF ERRORPRINT |MORE
IF ERRORLEVEL==1 ECHO ERROR IN "%2%3"
ECHO ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
PAUSE >NUL
IF %%4==RUN_ISP_LOADER GOTO RUN_ISP_LOADER
GOTO QUIT

REM ------------------------ Preklad pro A51 v6.12 -------------------------
:A51_6_PREKLAD
CLS
ECHO Kompilace A51
CD %1
IF NOT EXIST REG51.H COPY C:\PRGJAZ\CPU51\C51_V612\INC\REG51.INC >NUL
IF NOT EXIST REG52.H COPY C:\PRGJAZ\CPU51\C51_V612\INC\REG52.INC >NUL
ECHO ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
ECHO A51: "%2%3" TO "%2.obj"
REM C:\PRGJAZ\CPU51\A51\A51.EXE %2%3 DEBUG SYMBOLS XREF NOMOD51 ERRORPRINT |MORE
C:\PRGJAZ\CPU51\C51_V612\A51.EXE %2%3 NODEBUG SYMBOLS XREF NOMOD51 ERRORPRINT |MORE
IF ERRORLEVEL==1 ECHO ERROR IN "%2%3"
ECHO ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
PAUSE >NUL
IF %%4==RUN_ISP_LOADER GOTO RUN_ISP_LOADER
GOTO QUIT
REM ------------------------------------------------------------------------


REM ------------------------ ISP Loader ------------------------------------
:RUN_ISP_LOADER
C:\PRGJAZ\CPU51\FLASHER\rd2f.exe -f %3.hex -c COM1 -b 19200 -m 0 -p 0 -t 2
GOTO QUIT
REM ------------------------------------------------------------------------


REM ------------------------ Preklad pro C++ -------------------------------
:CPlus_PREKLAD
CLS
ECHO Kompilace C++
CD %1
ECHO %1%2%3
ECHO ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
C:\PrgJaz\C\BC\BIN\BC.EXE /b /p %2%3
IF ERRORLEVEL==1 ECHO ERROR IN "%2%3"
ECHO ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
PAUSE >NUL
%2.EXE
GOTO QUIT
REM ------------------------------------------------------------------------


REM ------------------------ Preklad pro C++ 32 -------------------------------
:C32_PREKLAD
CLS
ECHO Kompilace C++ 32
SET PATH=%PATH%; C:\PrgJaz\C\BC5\BIN;
ECHO %1%2%3
ECHO ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
C:\PrgJaz\C\BC5\BIN\BCC32.EXE -n%1 -IC:\PRGJAZ\C\BC5\Include %2%3 | more
IF ERRORLEVEL==1 ECHO ERROR IN "%2%3"
ECHO ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
PAUSE >NUL
rem %2.EXE
GOTO QUIT
REM ------------------------------------------------------------------------

:BAT_ECHO
ECHO ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
ECHO     Soubory BAT nejsou soucasti netopyra a neni tudiz treba je prekladat!
ECHO ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
PAUSE >NUL
GOTO QUIT
REM ------------------------------------------------------------------------

REM ------------------- Pro priponu neni definovan preklad -----------------
:UNSIGNED_EXTENSION
ECHO ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
ECHO       Pro soubor %2%3 neni definovan zadny prekladac !
ECHO ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
PAUSE >NUL
GOTO QUIT
REM ------------------------------------------------------------------------

:HELPEXIT
ECHO              Univerzalni davkovy soubor pro radkouvou kompilaci
ECHO  ------------------------------------------------------------------------
ECHO   pokud v adresari kompilovaneho zdrojaku neexistuje, zkopiruje se
ECHO   tam, jinak se preda rizeni batchi se stejnym jmenem v cilovem adresari
ECHO  ------------------------------------------------------------------------
ECHO         1. Parametr - Cesta k tomuto souboru (napr. "C:\PRGJAZ\MODEM")
ECHO         2. Parametr - Jmeno souboru bez pripony (napr. "MODEM")
ECHO         3. Parametr - Pripona souboru (napr. ".A51")
ECHO         4. Parametr - RUN_ISP_LOADER ... Po kompilaci spusti ISP loader
ECHO                       INDIVIDUAL ... Spusti se batch v cilovem adresari
ECHO  ------------------------------------------------------------------------
ECHO  Spustte s pozadovanymi parametry.



:QUIT



