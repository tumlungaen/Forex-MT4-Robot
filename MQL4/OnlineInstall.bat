@echo off
setlocal enabledelayedexpansion

set Web=******** YOUR DOWNLOAD URL HERE ********
set Indicator_List=THFX_Helper.ex4 THFX_RiskParameter.ex4
set Expert_List=THFX_AutoTPSL_Magic-0.ex4
set Template_List=default_tum.tpl default.tpl default_tum_scalping.tpl
set Script_List=THFX-Merge-TP-Buy.ex4 THFX-Merge-TP-Sell.ex4
set Preset_List=.

::------------------------------| VARIABLE
set Access=Invoke-WebRequest
set MyMT4Path=%UserProfile%\AppData\Roaming\MetaQuotes\Terminal\
set CopyOption=/E/H/I/C/Y/S
set FX_INSTALL_FOLDER=%UserProfile%\Downloads\THFX_PACKAGES
::------------------------------| HEADER
echo **** THAILAND FX WARRIOR, INSTALL PACKAGE ****
echo .
echo .
::------------------------------| MAKE FOLDER
mkdir %FX_INSTALL_FOLDER% 2> NUL
mkdir %FX_INSTALL_FOLDER%\MQL4\Experts\trader_tum 2> NUL
mkdir %FX_INSTALL_FOLDER%\MQL4\Scripts\trader_tum 2> NUL
mkdir %FX_INSTALL_FOLDER%\MQL4\Indicators\trader_tum 2> NUL
mkdir %FX_INSTALL_FOLDER%\MQL4\Presets\trader_tum 2> NUL
mkdir %FX_INSTALL_FOLDER%\templates 2> NUL
::------------------------------| DOWNLOAD ALL FILE IN WEBSITE
cd %FX_INSTALL_FOLDER%\templates
for %%I in (%Template_List%) do ( powershell -Command "%Access% %Web%/templates/%%I -OutFile %%I" )
echo Downloading 'Templates' ....... COMPLETE 

cd %FX_INSTALL_FOLDER%\MQL4\Scripts\trader_tum
for %%I in (%Script_List%) do ( powershell -Command "%Access% %Web%/MQL4/Scripts/trader_tum/%%I -OutFile %%I" )
echo Downloading 'Scripts' ....... COMPLETE

cd %FX_INSTALL_FOLDER%\MQL4\Indicators\trader_tum
for %%I in (%Indicator_List%) do ( powershell -Command "%Access% %Web%/MQL4/Indicators/trader_tum/%%I -OutFile %%I" )
echo Downloading 'Indicators' ....... COMPLETE

cd %FX_INSTALL_FOLDER%\MQL4\Experts\trader_tum
set File=THFX_AutoTPSL_Magic-0.ex4
for %%I in (%Expert_List%) do ( powershell -Command "%Access% %Web%/MQL4/Experts/trader_tum/%%I -OutFile %%I" )
echo Downloading 'Expert Advisor' ....... COMPLETE 

:: pause

echo .
echo ------------------------
echo INSTALLING PROCESS
echo ------------------------

::------------------------------| COPY PACKAGE TO EACH FOLDER
for /d %%I in (%MyMT4Path%*) do (
	mkdir %MyMT4Path%%%~nxI\MQL4\Experts\trader_tum 2> NUL
	mkdir %MyMT4Path%%%~nxI\MQL4\Indicators\trader_tum 2> NUL
	mkdir %MyMT4Path%%%~nxI\MQL4\Scripts\trader_tum 2> NUL
	xcopy %FX_INSTALL_FOLDER%\templates %MyMT4Path%%%~nxI\templates %CopyOption%
	xcopy %FX_INSTALL_FOLDER%\MQL4\Experts\trader_tum %MyMT4Path%%%~nxI\MQL4\Experts\trader_tum %CopyOption%
	xcopy %FX_INSTALL_FOLDER%\MQL4\Indicators\trader_tum %MyMT4Path%%%~nxI\MQL4\Indicators\trader_tum %CopyOption%
	xcopy %FX_INSTALL_FOLDER%\MQL4\Scripts\trader_tum %MyMT4Path%%%~nxI\MQL4\Scripts\trader_tum %CopyOption%
)

@rmdir /s /q %FX_INSTALL_FOLDER%

echo .
echo ------------------------
echo THANKS YOU VERY MUCH, by THAILAND FX WARRIOR
echo FINISH, PRESS ANY KEY TO EXIT
echo ------------------------
:: pause