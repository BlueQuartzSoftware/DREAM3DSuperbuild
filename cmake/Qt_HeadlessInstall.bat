
@echo off

REM Setup some environment variables in order to collect those into a single location
set DREAM3D_SDK=@DREAM3D_SDK@


@QT5_ONLINE_INSTALLER@ --script @JSFILE@

