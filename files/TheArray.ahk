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
