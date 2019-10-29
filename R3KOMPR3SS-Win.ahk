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
Gui Add, Button, x138 y215 w80 h23 gGoImg, Img
Gui Add, Edit, x220 y215 w33 h23 vPreContainerFormat, nut
Gui Add, Button, x19 y123 w80 h23 gInputA, Input A
Gui Add, Button, x282 y124 w80 h23 gInputV, Input V
;Gui Add, Button, x9 y35 w80 h23 gffmpegbinary, FFMpeg Path
;Gui Add, Button, x9 y10 w80 h23 gffplaybinary, FFplay Path
Gui Add, Edit, x5 y204 w120 h21 vAudioParams, -strict -2 -t 10
Gui Add, Edit, x269 y204 w120 h21 vVideoParams, -pix_fmt bgr24 -t 5
Gui Add, Edit, x155 y142 w82 h25 vIterAmount, 30
Gui Add, Edit, x174 y112 w35 h25 vFormat, nut
Gui, Add, Text, x175 y95 w35 h15, Format
Gui Add, StatusBar,,%abc%
Gui Add, Slider, x10 y81 w100 h28 Range0-320 vAudioQuality gSlide1 AltSubmit, 32
Gui Add, Slider, x270 y82 w100 h28 Range0-320 vVideoQuality gSlide2 AltSubmit, 10

val := "1.0" ;Default video/audio quality.

Gui Show, w394 h265, R3K0MPR3SS 4 W1ND0WZ
Return

Slide1:
Gui,Submit,NoHide
int := AudioQuality/3
fra := Mod(int, 3)
fra := SubStr(fra, InStr(fra,".")+1, 1 )
val :=  Floor(int) "." fra
tooltip % val
SetTimer, RemoveToolTip1, 500
return

RemoveToolTip1:
SetTimer, RemoveToolTip1, Off
ToolTip
return

Slide2:
Gui,Submit,NoHide
int := VideoQuality/10
fra := Mod(int, 10)
fra := SubStr(fra, InStr(fra,".")+1, 1 )
val :=  Floor(int) "." fra
tooltip % val
SetTimer, RemoveToolTip2, 500
return

RemoveToolTip2:
SetTimer, RemoveToolTip2, Off
ToolTip
return


InputA:
FileSelectFile, UserInputA
RunVar := 1
return

InputV:
FileSelectFile, UserInputV
RunVar := 2
If RegExMatch(UserInputV,"(bmp|xwd|tiff|targa|jpg|jpeg|png|raw)")
{
msgbox, Image Input Detected! Use the "Img" button to Recompress.
return
}
return

;Compress image with video codec, change container format to bmp, tiff, xwd, etc
GoImg:
Gui, Submit, NoHide
sleep, 100

If !RegExMatch(format,"(bmp|xwd|tiff|targa|jpg|jpeg|raw)")
{
msgbox, 
(
pls change Format to an image container (such as bmp ,xwd, tiff, targa)
if it still fails then change the second container from "nut" to avi, mkv, etc
)
return
}

runwait, %ComSpec% /c ffmpeg -i "%UserInputV%" %VideoParams% 0out.%Format% -y,,Min

abc := 0
while abc < IterAmount
{
	abc +=1	
	
    file := (abc - 0) . "out." . Format
	old := (abc - 1) . "out." . Format
	rem := (abc - 2) . "out." . Format
    last := (abc + 1) . "out." . Format	
	
	
	runwait, %ComSpec% /c ffmpeg -i %old% -f %PreContainerFormat% -c:v %VEnc% -q:v %val% %VideoParams% - | ffmpeg -i - %VideoParams% %file% -y,,Min
	Sleep, 100
	abc +=1
	SB_SetText("Recompressing File; Loop Number " abc " of " IterAmount)
	
	FileDelete, %rem%
}
FileDelete, %old%
runwait, ffplay -i %file%

Gui, Show
return

GO:
Gui, Submit, NoHide

if (RunVar = 1)
{
	Gui, Submit, NoHide	
	runwait, cmd.exe /c ffmpeg -i "%UserInputA%" -f %Format% -c:a %AEnc% -q:a %val% -vn %AudioParams% 0out.%Format% -y,,Min
	
	abc := 0
	while abc < IterAmount
	{
		abc +=1
		SB_SetText("Recompressing File; Loop Number " abc " of " IterAmount)				
		
		
		file := (abc - 0) . "out." . Format
		old := (abc - 1) . "out." . Format
		rem := (abc - 2) . "out." . Format
		last := (abc + 1) . "out." . Format	
		
		runwait, cmd.exe /c ffmpeg -i "%old%" -f %Format% -c:a %AEnc% %AudioParams% %file% -y,,Min
		abc +=1
		sleep, 100
		SB_SetText("Recompressing File; Loop Number " abc " of " IterAmount)		
		runwait, cmd.exe /c ffmpeg -i "%file%" -f %Format% -c:a %AEnc% %AudioParams% %last% -y,,Min
		
          FileDelete, %old%		
		FileDelete, %rem%
	}
	FileDelete, %last%
	runwait, ffplay -i %file%
;return
}

if (RunVar = 2)
{
	Gui, Submit, NoHide	
	runwait, cmd.exe /c ffmpeg -i "%UserInputV%" -f %Format% -c:v %VEnc% -q:v %val% -an %VideoParams% 0out.%Format% -y,,Min
	
	abc := 0
	while abc < IterAmount
	{
		abc +=1
		SB_SetText("Recompressing File; Loop Number " abc " of " IterAmount)
		
		file := (abc - 0) . "out." . Format
		old := (abc - 1) . "out." . Format
		rem := (abc - 2) . "out." . Format
		last := (abc + 1) . "out." . Format		
		
		
		runwait, cmd.exe /c ffmpeg -i "%old%" -f %Format% -c:v %VEnc% %VideoParams% %file% -y,,Min
		abc +=1		
		SB_SetText("Recompressing File; Loop Number " abc " of " IterAmount)
          sleep, 100		
		runwait, cmd.exe /c ffmpeg -i "%file%" -f %Format% -c:v %VEnc% %VideoParams% %last% -y,,Min
		
		
		FileDelete, %old%
		FileDelete, %rem%
	}
	FileDelete, %last%
	runwait, cmd.exe /k ffplay -i %file%
;return
}

Gui, Show
return

F5::
msgbox, %val%
return

GuiEscape:
GuiClose:
    ExitApp
