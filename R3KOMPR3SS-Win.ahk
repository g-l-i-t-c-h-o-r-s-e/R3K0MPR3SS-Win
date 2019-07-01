#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
SetBatchLines -1
;ffmpeg := "C:\Users\Username\Desktop\wao\ffmpeg.exe"
;ffplay := "C:\Users\Username\Desktop\wao\ffplay.exe"

ArrayListIndex := 0
 loop, read, files\vcodecs.txt
 {
  ArrayList%A_Index% := A_LoopReadLine
   ArrayList0 = %A_Index%
    }
     Loop,%ArrayList0%
      List .= ArrayList%A_Index%  . "|" 

       ArrayListIndex := 1
       loop, read, files\acodecs.txt
        {
         ArrayList%A_Index% := A_LoopReadLine
          ArrayList1 = %A_Index%
           }
            Loop,%ArrayList1%
             List2 .= ArrayList%A_Index%  . "|" 
	
              ArrayListIndex := 2
               loop, read, files\adecoders.txt
                {
                 ArrayList%A_Index% := A_LoopReadLine
                  ArrayList2 = %A_Index%
                   }
                    Loop,%ArrayList2%
                     List3 .= ArrayList%A_Index%  . "|" 	
	
                      ArrayListIndex := 3
                       loop, read, files\pixfmts.txt
                        {
                         ArrayList%A_Index% := A_LoopReadLine
                          ArrayList3 = %A_Index%
                           }
                            Loop,%ArrayList3%
                             List4 .= ArrayList%A_Index%  . "|" 		
	
                             ArrayListIndex := 4
                             loop, read, files\pixfmts.txt
                             {
                            ArrayList%A_Index% := A_LoopReadLine
                           ArrayList4 = %A_Index%
                          }
                         Loop,%ArrayList4%
                        List5 .= ArrayList%A_Index%  . "|" 

                       ArrayListIndex := 5
                      loop, read, files\vdecoders.txt
                     {
                   ArrayList%A_Index% := A_LoopReadLine
                  ArrayList5 = %A_Index%
                 }
                Loop,%ArrayList5%
               List6 .= ArrayList%A_Index%  . "|"
 
              ArrayListIndex := 6
             loop, read, files\soxfx.txt
            {
           ArrayList%A_Index% := A_LoopReadLine
          ArrayList6 = %A_Index%
         }
        Loop,%ArrayList6%
       List7 .= ArrayList%A_Index%  . "|"
	
      ArrayListIndex := 7
     loop, read, files\afilters.txt
    {
   ArrayList%A_Index% := A_LoopReadLine
  ArrayList7 = %A_Index%
 } 
Loop,%ArrayList7%
List8 .= ArrayList%A_Index%  . "|"

;=======================================================================================

Gui Add, ComboBox, x6 y152 w120 vAEnc Choose24, %List2%
Gui Add, ComboBox, x6 y179 w120 vADec Choose89, %List3%
;Disabled until I add more
GuiControl, Disable, ADec
Gui Add, ComboBox, x269 y152 w120 vVEnc Choose30, %List%
Gui Add, ComboBox, x269 y179 w120 vVDec Choose68, %List6%
;Disabled until I add more
GuiControl, Disable, VDec
Gui Add, Button, x138 y174 w116 h40 gGO, GO
Gui Add, Button, x19 y123 w80 h23 gInputA, Input A
Gui Add, Button, x282 y124 w80 h23 gInputV, Input V

Gui Add, Button, x9 y35 w80 h23 gffmpegbinary, FFMpeg Path
Gui Add, Button, x9 y10 w80 h23 gffplaybinary, FFplay Path

Gui Add, Edit, x5 y204 w120 h21 vAudioParams, -strict -2
Gui Add, Edit, x269 y204 w120 h21 vVideoParams
Gui Add, Edit, x155 y142 w82 h25 vIterAmount, 30
Gui Add, Edit, x174 y112 w35 h25 vFormat, nut
Gui, Add, Text, x175 y95 w35 h15, Format
Gui Add, StatusBar,%abc%,

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
gui, Submit
if (RunVar = 1)
{
runwait, %ffmpeg% -i "%UserInputA%" -f %Format% -c:a %AEnc% -q:a 32 -vn %AudioParams% -t 10 1out.%Format% -y

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

FileDelete, %rem%
}
FileDelete, %old%
runwait, %ffplay% -i %file%
;return
}

if (RunVar = 2)
{
runwait, %ffmpeg% -i "%UserInputV%" -f %Format% -c:v %VEnc% -q:v 32 -an %VideoParams% -t 5 1out.%Format% -y

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
