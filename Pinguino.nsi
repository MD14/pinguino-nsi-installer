;----------------------------------------------------
;Pinguino IDE Installation Script
;Public Domain License 2014
;Coded by Victor Villarreal <mefhigoseth@gmail.com>
;----------------------------------------------------
;Defines

!define FILE_NAME 'pinguino-ide'
!define FILE_VERSION '11'
!define FILE_INSTVERSION '11.0.0.1'
!define FILE_OWNER 'Pinguino Project'
!define FILE_URL 'http://www.pinguino.cc/'
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\orange-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\orange-uninstall.ico"
!define MUI_INSTFILESPAGE_PROGRESSBAR "smooth"
!define MUI_WELCOMEFINISHPAGE_BITMAP "Pinguino-welcomePage.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "Pinguino-welcomePage.bmp"
!define ADD_REMOVE "Software\Microsoft\Windows\CurrentVersion\Uninstall\${FILE_NAME}"
!define Python27 "http://python.org/ftp/python/2.7.6/python-2.7.6.msi"
!define PyPIP "https://raw.github.com/pypa/pip/master/contrib/get-pip.py"
!define IntelHex "http://www.bialix.com/intelhex/intelhex-1.5.zip"
!define PySIDE "http://download.qt-project.org/official_releases/pyside/PySide-1.2.1.win32-py2.7.exe"

;--------------------------------
;Includes

!include "MUI2.nsh"
!include "FileFunc.nsh"

;--------------------------------
;General Settings

Name '${FILE_NAME} v${FILE_VERSION}'
OutFile '${FILE_NAME}-${FILE_VERSION}-setup.exe'
BrandingText '${FILE_OWNER}'
InstallDir 'C:\${FILE_NAME}'
ShowInstDetails show

VIAddVersionKey "ProductName" '${FILE_NAME}'
VIAddVersionKey "ProductVersion" '${FILE_VERSION}'
VIAddVersionKey "CompanyName" '${FILE_OWNER}'
VIAddVersionKey "LegalCopyright" 'Copyright 2014 ${FILE_OWNER}'
VIAddVersionKey "FileDescription" '${FILE_NAME} Installer'
VIAddVersionKey "FileVersion" '${FILE_INSTVERSION}'
VIProductVersion '${FILE_INSTVERSION}'

;--------------------------------
;Pages

!insertmacro MUI_PAGE_WELCOME
;!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

;--------------------------------
;Languages

!insertmacro MUI_LANGUAGE "Spanish"
!insertmacro MUI_LANGUAGE "English"

;--------------------------------
;Installer Sections

Section "Install"

  ;Default installation folder
  ;strCpy $InstallDest '$PROGRAMFILES' 2
  ;InstallDir '$InstallDest\${FILE_NAME}

  ;Seteamos el directorio de salida para las instrucciones FILE.
  SetOutPath "$INSTDIR\v${FILE_VERSION}"
  ;Tipo de instalacion: AllUsers.
  SetShellVarContext all

  IfFileExists "C:\Python27\python.exe" PyPIP +1
  DetailPrint "Python v2.7 not detected in your system."
  DetailPrint "We'll download and install it for you, in 5 secs."
  Sleep 5000
  inetc::get ${Python27} $EXEDIR\python-2.7.6.msi
  Pop $R0
  StrCmp $R0 "OK" +2
  Abort "Python v2.7 download failed: $R0!"
  ExecWait '"msiexec" /i "$EXEDIR\python-2.7.6.msi"' $0
  ${if} $0 != "0"
    Abort "Python v2.7 instalation failed. Exit code was $0!"
  ${endif}
  DetailPrint "Python v2.7 installation success. Continue..."

  PyPIP:
    IfFileExists "C:\Python27\Scripts\pip.exe" Wheel +1
    DetailPrint "PyPIP module not detected in your system."
    DetailPrint "We'll download and install it for you, in 5 secs."
    Sleep 5000
    inetc::get ${PyPIP} $EXEDIR\get-pip.py
    Pop $R0
    StrCmp $R0 "OK" +2
    Abort "Download PyPIP module failed: $R0!"
    ExecWait '"C:\Python27\python" "$EXEDIR\get-pip.py"' $0
    ${if} $0 != "0"
      Abort "PyPIP instalation failed. Exit code was $0!"
    ${endif}
    DetailPrint "PyPIP installation success. Continue..."

  Wheel:
    IfFileExists "C:\Python27\Scripts\wheel.exe" IntelHex +1
    nsExec::Exec '"C:\Python27\Scripts\pip.exe" install wheel'
    Pop $R0
    ${if} $R0 != "0"
      Abort "Wheel module installation failed. Exit code was $R0!"
    ${endif}
    DetailPrint "wheel installation success. Continue..."

  IntelHex:
    IfFileExists "C:\Python27\Scripts\bin2hex.py" Soup4 +1
    nsExec::Exec '"C:\Python27\Scripts\pip.exe" install ${IntelHex}'
    Pop $R0
    ${if} $R0 != "0"
      Abort "IntelHex module installation failed. Exit code was $R0!"
    ${endif}
    DetailPrint "IntelHex installation success. Continue..."

  Soup4:
    IfFileExists "C:\Python27\Scripts\soup4.exe" GITpython +1
    nsExec::Exec '"C:\Python27\Scripts\pip.exe" install beautifulsoup4'
    Pop $R0
    ${if} $R0 != "0"
      Abort "beautifulsoup4 module installation failed. Exit code was $R0!"
    ${endif}
    DetailPrint "beautifulsoup4 installation success. Continue..."

  GITpython:
    IfFileExists "C:\Python27\Scripts\soup4.exe" PyUSB +1
    nsExec::Exec '"C:\Python27\Scripts\pip.exe" install gitpython'
    Pop $R0
    ${if} $R0 != "0"
      Abort "GIT-Python module installation failed. Exit code was $R0!"
    ${endif}
    DetailPrint "GIT-Python installation success. Continue..."

  PyUSB:
    IfFileExists "C:\Python27\Scripts\soup4.exe" PySIDE +1
    nsExec::Exec '"C:\Python27\Scripts\pip.exe" install pyusb==1.0.0b1'
    Pop $R0
    ${if} $R0 != "0"
      Abort "PyUSB module installation failed. Exit code was $R0!"
    ${endif}
    DetailPrint "PyUSB installation success. Continue..."

  PySIDE:
    IfFileExists "C:\Python27\Scripts\pyside-uic.exe" pausa +1
    DetailPrint "PySIDE not detected in your system."
    DetailPrint "We'll download and install it for you, in 5secs."
    Sleep 5000
    inetc::get ${PySIDE} $EXEDIR\PySide-1.2.1.win32-py2.7.exe
    Pop $R0
    StrCmp $R0 "OK" +2
    Abort "PySIDE download failed: $R0!"
    ExecWait '"$EXEDIR\PySide-1.2.1.win32-py2.7.exe"' $0
    ${if} $0 != "0"
      Abort "PySIDE instalation failed. Exit code was $0!"
    ${endif}
    DetailPrint "PySIDE installation success. Continue..."

  pausa:
  Sleep 5000

  ;Install libUSB...
  Call libUSB

  ;Copy files...
  Call InstallFiles

  ;Publish the project info to the system...
  Call PublishInfo
  
  ;Make shorcuts...
  Call MakeShortcuts

  ;Creamos el Unistaller.
  WriteUninstaller "$INSTDIR\v${FILE_VERSION}\uninstall.exe"

SectionEnd

;--------------------------------
;Uninstaller Section

Section "Uninstall"

  ;Tipo de instalacion: AllUsers.
  SetShellVarContext all

  ;Eliminamos todos los ficheros que instalamos...
  ;Delete /REBOOTOK "$INSTDIR\*.*"
  RMDir /r /REBOOTOK $INSTDIR

  ;Delete "$DESKTOP\BarraITS.lnk"
  ;RMDir /r "$SMPROGRAMS\${FILE_OWNER}\"
  DeleteRegKey /ifempty HKCU "Software\Pinguino"
  DeleteRegKey HKLM "${ADD_REMOVE}"

SectionEnd

;---------------------------------
; Functions

Function InstallFiles
  ;Copy all the files to the installation folder...
  DetailPrint "CopyFiles begin..."
  File /r /x .git ..\${FILE_NAME}\*.*
FunctionEnd

Function PublishInfo
  ;Publish info for the "Add & Remove Software" system tool...
  DetailPrint "PublishInfo begin..."
  WriteRegStr HKCU "Software\Pinguino" "" "$INSTDIR\v${FILE_VERSION}"
  WriteRegStr HKLM "${ADD_REMOVE}" "DisplayName" "${FILE_NAME} v${FILE_VERSION}"
  WriteRegStr HKLM "${ADD_REMOVE}" "UninstallString" "$\"$INSTDIR\v${FILE_VERSION}\uninstall.exe$\""
  WriteRegStr HKLM "${ADD_REMOVE}" "QuietUninstallString" "$\"$INSTDIR\v${FILE_VERSION}\uninstall.exe$\" /S"
  WriteRegStr HKLM "${ADD_REMOVE}" "HelpLink" "${FILE_URL}"
  WriteRegStr HKLM "${ADD_REMOVE}" "URLInfoAbout" "${FILE_URL}"
  WriteRegStr HKLM "${ADD_REMOVE}" "Publisher" "${FILE_OWNER}"
FunctionEnd

Function MakeShortcuts
  ;Make shortcuts into desktop and start menu to our program...
  DetailPrint "MakeShortcuts begin..."
  ;CreateShortCut "$DESKTOP\BarraITS.lnk" "$INSTDIR\${FILE_NAME}\barraITS.exe"
  ;CreateDirectory "$SMPROGRAMS\${FILE_OWNER}\"
  ;CreateShortCut "$SMPROGRAMS\${FILE_OWNER}\BarraITS.lnk" "$INSTDIR\${FILE_NAME}\barraITS.exe"
FunctionEnd

Function libUSB
  File "/oname=$SYSDIR\libusb0.dll" ..\libusb\libusb0_x86.dll
  File "/oname=$SYSDIR\drivers\libusb0.sys" ..\libusb\libusb0.sys
  File "/oname=$SYSDIR\testlibusb.exe" ..\libusb\testlibusb.exe

  nsExec::Exec '"$SYSDIR\testlibusb.exe"'
  Pop $R0
  ${if} $R0 != "0"
    Abort "libUSB installation failed. Exit code was $R0!"
  ${endif}
    DetailPrint "libUSB installation success. Continue..."
FunctionEnd