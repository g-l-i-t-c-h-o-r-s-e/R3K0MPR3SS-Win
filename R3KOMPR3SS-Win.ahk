#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
SetBatchLines -1
ffmpeg := "C:\Users\Execute\Desktop\ao\ffmpeg.exe"
ffplay := "C:\Users\Execute\Desktop\ao\ffplay.exe"

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
Gui Add, ComboBox, x269 y152 w120 vVEnc Choose30, %List%
Gui Add, ComboBox, x269 y179 w120 vVDec Choose68, %List6%
Gui Add, Button, x138 y174 w116 h40 gGO, GO
Gui Add, Button, x19 y123 w80 h23 gInputA, Input A
Gui Add, Button, x282 y124 w80 h23 gInputV, Input V
Gui Add, Edit, x5 y204 w120 h21
Gui Add, Edit, x269 y204 w120 h21
Gui Add, Edit, x155 y142 w82 h25 vIterAmount, 30
Gui Add, StatusBar,%abc%,

Gui Show, w394 h257, Window
Return

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
runwait, %ffmpeg% -i "%UserInputA%" -f nut -c:a %AEnc% -q:a 32 -t 10 1out.nut -y

abc := 1
while abc < IterAmount
{
file := (abc - 0) . "out.nut"
old := (abc - 1) . "out.nut"
rem := (abc - 2) . "out.nut"

runwait, %ffmpeg% -i "%old%" -vn -f nut -c:a %AEnc% %file% -y
Sleep, 100
abc +=1

FileDelete, %rem%
}
FileDelete, %old%
runwait, %ffplay% -i %file%
 return
}

if (RunVar = 2)
{
runwait, %ffmpeg% -i "%UserInputV%" -f nut -c:v %VEnc% -q:v 32 -an -t 5 1out.nut -y

abc := 1
while abc < IterAmount
{
file := (abc - 0) . "out.nut"
old := (abc - 1) . "out.nut"
rem := (abc - 2) . "out.nut"

runwait, %ffmpeg% -i "%old%" -f nut -c:v %VEnc% %file% -y
Sleep, 100
abc +=1

FileDelete, %rem%
}
FileDelete, %old%
runwait, %ffplay% -i %file%
 return
}


GuiEscape:
GuiClose:
    ExitApp
