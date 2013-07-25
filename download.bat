@echo off

set CUR_DIR="%CD%"
set NW_PATH=%CUR_DIR%\build\nw\
set NW_VERSION=0.6.3
set URL_CDN=https://s3.amazonaws.com/node-webkit/v%NW_VERSION%
set ARCHIVE_WIN=node-webkit-v%NW_VERSION%-win-ia32.zip
set ARCHIVE_L32=node-webkit-v%NW_VERSION%-linux-ia32.tar.gz
set ARCHIVE_L64=node-webkit-v%NW_VERSION%-linux-x64.tar.gz
set ARCHIVE_MAC=node-webkit-v%NW_VERSION%-osx-ia32.zip
set WIN_URL=%URL_CDN%/%ARCHIVE_WIN%

echo Download start...
echo %WIN_URL%

 > %temp%\~download.vbs echo sUrl = "%WIN_URL%"
>> %temp%\~download.vbs echo sFolder = "./build/nw"
>> %temp%\~download.vbs (findstr "'--VBS" "%0" | findstr /v "findstr")
cscript //nologo %temp%\~download.vbs
del /q %temp%\~download.vbs
goto :eof

'--- figure out temp file & folder
With CreateObject("WScript.Shell")  '--VBS
    sTempFile = .Environment("Process").Item("TEMP") & "\tempfile.zip"  '--VBS 
    sTempFolder = .Environment("Process").Item("TEMP") & "\tempfile.zip.extracted"  '--VBS
End With    '--VBS

'--- download
WiTh CreateObject("MSXML2.XMLHTTP") '--VBS
    .Open "GET", sUrl, false    '--VBS
    .Send() '--VBS
    If .Status = 200 Then   '--VBS
        ResponseBody = .ResponseBody    '--VBS
        With Createobject("Scripting.FileSystemObject") '--VBS
            If .FileExists(sTempFile) Then  '--VBS
                .DeleteFile sTempFile   '--VBS
            End If  '--VBS
        End With    '--VBS
        With CreateObject("ADODB.Stream")   '--VBS
            .Open   '--VBS
            .Type = 1 ' adTypeBinary    '--VBS
            .Write ResponseBody '--VBS
            .Position = 0   '--VBS
            .SaveToFile sTempFile   '--VBS
        End With    '--VBS
    End If  '--VBS
End With    '--VBS

'--- extract
With CreateObject("Scripting.FileSystemObject") '--VBS
    On Error Resume Next    '--VBS
    .CreateFolder sFolder   '--VBS
    .DeleteFolder sTempFolder, True '--VBS
    .CreateFolder sTempFolder   '--VBS
    On Error GoTo 0 '--VBS
    With CreateObject("Shell.Application")  '--VBS
        .NameSpace(sTempFolder).CopyHere .NameSpace(sTempFile).Items    '--VBS
    End With    '--VBS
    .CopyFolder sTempFolder, sFolder, True  '--VBS
    .DeleteFolder sTempFile, True   '--VBS
    .DeleteFile sTempFile, True '--VBS
End With    '--VBS

