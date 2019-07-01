#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
SetBatchLines -1
#Include files/TheArray.ahk

Gui Add, ComboBox, x6 y152 w120 vAEnc Choose24, %List2%
Gui Add, ComboBox, x6 y179 w120 vADec Choose89, %List3%
;Disabled until I add more
GuiControl, Disable, ADec
Gui Add, ComboBox, x269 y152 w120 vVEnc Choose31, %List%
Gui Add, ComboBox, x269 y179 w120 vVDec Choose68, %List6%
;Disabled until I add more
GuiControl, Disable, VDec
Gui Add, Button, x138 y174 w116 h40 gGO, GO
Gui Add, Button, x19 y123 w80 h23 gInputA, Input A
Gui Add, Button, x282 y124 w80 h23 gInputV, Input V
Gui Add, Button, x9 y35 w80 h23 gffmpegbinary, FFMpeg Path
Gui Add, Button, x9 y10 w80 h23 gffplaybinary, FFplay Path
Gui Add, Edit, x5 y204 w120 h21 vAudioParams, -strict -2 -t 10
Gui Add, Edit, x269 y204 w120 h21 vVideoParams, -t 5
Gui Add, Edit, x155 y142 w82 h25 vIterAmount, 30
Gui Add, Edit, x174 y112 w35 h25 vFormat, nut
Gui, Add, Text, x175 y95 w35 h15, Format
Gui Add, StatusBar,,%abc%
Gui Add, Slider, x10 y81 w100 h28 +Tooltip Range0-32 vAudioQuality, 32
Gui Add, Slider, x270 y82 w100 h28 +Tooltip Range0-32 vVideoQuality, 10

Gui Show, w394 h257, R3K0MPR3SS 4 W1ND0WZ
Return

ffmpegbinary:
FileSelectFile, ffmpeg
return

ffplaybinary:
FileSelectFile, ffplay
return

InputA:
FileSelectFile, UserInputA
RunVar := 1
return

InputV:
FileSelectFile, UserInputV
RunVar := 2
return

GO:
Gui, Submit, NoHide
if (RunVar = 1)
{
runwait, %ffmpeg% -i "%UserInputA%" -f %Format% -c:a %AEnc% -q:a %AudioQuality% -vn %AudioParams% 1out.%Format% -y

abc := 1
while abc < IterAmount
{
file := (abc - 0) . "out.%Format%"
old := (abc - 1) . "out.%Format%"
rem := (abc - 2) . "out.%Format%"
transform, file, Deref, %file%
transform, old, Deref, %old%
transform, rem, Deref, %rem%

runwait, %ffmpeg% -i "%old%" -f %Format% -c:a %AEnc% %AudioParams% %file% -y
Sleep, 100
abc +=1
SB_SetText("Compressing File; Loop Number = " abc)

FileDelete, %rem%
}
FileDelete, %old%
runwait, %ffplay% -i %file%
;return
}

if (RunVar = 2)
{
runwait, %ffmpeg% -i "%UserInputV%" -f %Format% -c:v %VEnc% -q:v %VideoQuality% -an %VideoParams% 1out.%Format% -y

abc := 1
while abc < IterAmount
{
file := (abc - 0) . "out.%Format%"
old := (abc - 1) . "out.%Format%"
rem := (abc - 2) . "out.%Format%"
transform, file, Deref, %file%
transform, old, Deref, %old%
transform, rem, Deref, %rem%

runwait, %ffmpeg% -i "%old%" -f %Format% -c:v %VEnc% %VideoParams% %file% -y
Sleep, 100
abc +=1
SB_SetText("Compressing File; Loop Number = " abc)

FileDelete, %rem%
}
FileDelete, %old%
runwait, %ffplay% -i %file%
;return
}

Gui, Show
return

GuiEscape:
GuiClose:
    ExitApp
