.model small

.stack 100h

.data

        nl db 10,13,'$'                                         ;new line

        intro db 10,13,''                                       ;intro structure
        db 10,13,'                   ||---------------||'
        db 10,13,'                   ||               ||'
        db 10,13,'                   ||     WATCH     ||'
        db 10,13,'                   ||    -------    ||'
        db 10,13,'                   ||   THE BLOCK   ||'
        db 10,13,'                   ||  -----------  ||'
        db 10,13,'                   ||               ||'
        db 10,13,'                   || Made by:      ||'
        db 10,13,'                   ||  Jatin Bhosale||'
        db 10,13,'                   ||               ||'
        db 10,13,'                   ||               ||'
        db 10,13,'                   ||  Press :      ||'
        db 10,13,'                   ||     S - Start ||'
        db 10,13,'                   ||     E - Exit  ||'
        db 10,13,'                   ||               ||'
        db 10,13,'                   ||---------------||'
        db 10,13,'$'

        lose1 db 10,13,''                                       ;lost msg 1
        db 10,13,'                   ||---------------||'       
        db 10,13,'                   ||               ||'
        db 10,13,'                   ||     WATCH     ||'
        db 10,13,'                   ||    -------    ||'
        db 10,13,'                   ||   THE BLOCK   ||'
        db 10,13,'                   ||  -----------  ||'
        db 10,13,'                   ||               ||'
        db 10,13,'                   ||   YOU LOSE    ||'
        db 10,13,'                   ||               ||'
        db 10,13,'                   ||  SCORE : $'

        lose2 db '  ||'                                         ;lost msg 2
        db 10,13,'                   ||               ||'
        db 10,13,'                   ||  TRY AGAIN ?  ||'
        db 10,13,'                   ||               ||'
        db 10,13,'                   || PRESS ANY KEY ||'
        db 10,13,'                   ||               ||'
        db 10,13,'                   ||---------------||'
        db 10,13,'$'

        howtoplaystr db 10,13,''                                ;how to play 
        db 10,13,'                   ||---------------||'
        db 10,13,'                   ||               ||' ;1
        db 10,13,'                   ||  HOW TO PLAY  ||'
        db 10,13,'                   ||  -----------  ||' ;2
        db 10,13,'                   ||               ||'
        db 10,13,'                   ||  CONTROLS :   ||' ;3
        db 10,13,'                   ||               ||'
        db 10,13,'                   ||    D - LEFT   ||' ;4
        db 10,13,'                   ||    K - RIGHT  ||' ;5
        db 10,13,'                   ||               ||'
        db 10,13,'                   || SAVE THE {*}  ||' ;6
        db 10,13,'                   ||FROM THE BLOCKS||'
        db 10,13,'                   ||               ||'
        db 10,13,'                   || PRESS ANY KEY ||'
        db 10,13,'                   ||               ||'
        db 10,13,'                   ||---------------||'
        db 10,13,'$'
                                                                
        disp db 10,13,'                   ||---------------||$' ;top and bottom        

        b db 10,13,'                   ||               ||$'    ;blank
        b0 db 10,13,'                   ||###            ||$'   ;block pos 1
        b1 db 10,13,'                   ||   ###         ||$'   ;block pos 2
        b2 db 10,13,'                   ||      ###      ||$'   ;block pos 3
        b3 db 10,13,'                   ||         ###   ||$'   ;block pos 4
        b4 db 10,13,'                   ||            ###||$'   ;block pos 5

        pos0 db 10,13,'                   ||{*}            ||$' ;plyr pos 1
        pos1 db 10,13,'                   ||   {*}         ||$' ;plyr pos 2
        pos2 db 10,13,'                   ||      {*}      ||$' ;plyr pos 3
        pos3 db 10,13,'                   ||         {*}   ||$' ;plyr pos 4
        pos4 db 10,13,'                   ||            {*}||$' ;plyr pos 5

        scor1 db 10,13,'                   ||------SCORE:$'     ;score line 1
        scor2 db '||$'                                          ;score line 2

        ;;variables used in the program
        pos db 02h                              ;position
        r1 db 06h                               ;row 1 pos
        r2 db 06h                               ;ros 2 pos
        r3 db 06h                               ;row 3 pos
        r4 db 06h                               ;row 4 pos
        r5 db 06h                               ;row 5 pos
        r6 db 06h                               ;row 6 pos
        scrh db 30h                             ;score hundreds place
        scrt db 30h                             ;score tens place
        scro db 30h                             ;score ones place
        curtim db 00h



.code

main proc                                       ;main process
        mov ax,@data                            
        mov ds,ax

        jmp menu                                ;jump to menu

key_pressed:                                    
        mov ah,00h                              ;input key
        int 16h

        cmp al,'d'                              ;if d goto left
        je left
        cmp al,'D'                              ;if D goto left
        je left

        cmp al,'k'                              ;if k goto right
        je right
        cmp al,'K'                              ;if K goto right
        je right

        jmp game                                ;if neither goto game

    left:
        cmp pos,00h                             ;if pos is 0 goto up
        je up

        sub pos,01h                             ;subtract 1 from pos
        jmp skip
    up: jmp skip

   right:
        cmp pos,04h                             ;if pos is 4 goto up
        je up

        add pos,01h                             ;add 1 to pos
        jmp up

main_loop:                                      ;main loop
        mov scrh,30h                            ;scrh = 0
        mov scrt,30h                            ;scrt = 0
        mov scro,30h                            ;scro = 0
        mov r1,06h                              ;initialise all rows pos to 0
        mov r2,06h
        mov r3,06h
        mov r4,06h
        mov r5,06h
        mov r6,06h
        mov pos,02h                             ;imitialise pos to 2

           

   game:                                        ;game starts here
        mov ah,01h                              ;check if leypressed
        int 16h
        jnz key_pressed                         ;if key pressed goto key_pressed

        mov ah,2ch                              ;get current time
        int 21h

        cmp dh,curtim                           ;compare dh with current time
        jne jmphelp                             ;if equal goto jmphelp
 
        cmp dh,59d                              ;if dh is 59 goto lp2
        je lp2
        add dh,01h                              ;increment dh
        mov curtim,dh                           
        jmp cont1
  jmphelp:jmp noref           

    lp2:
        mov curtim,00h
  cont1:
        mov ah,02h
        mov dl,34h
        int 21h
        mov cl,r6                               ;if r6 equals pos, lost
        cmp cl,pos
        je lost
        mov cl,r5                               ;shift blocks dowm
        mov r6,cl
        mov cl,r4
        mov r5,cl
        mov cl,r3
        mov r4,cl
        mov cl,r2
        mov r3,cl
        mov cl,r1
        mov r2,cl
        call gen_ran                            ;generate random number between 0 to 4
        mov r1,ch                               ;mov random no to r1
        inc scro
        cmp scro,3ah                            ;increment score
        jne skip
        mov scro,30h
        inc scrt
        cmp scrt,3ah
        jne skip
        mov scrt,30h
        inc scrh
        cmp scrh,3ah
        jne skip
        jmp lost                                ;if score 999, game lost
   skip:
        call refresh                            ;refresh screen
  noref:
        jmp game                                ;goto game

lost:
        call clr                                ;clear screen
        mov ah,09h                              ;print lose1
        lea dx,lose1
        int 21h
        mov ah,02h                              ;print score
        mov dl,scrh
        int 21h
        mov dl,scrt
        int 21h
        mov dl,scro
        int 21h
        mov ah,09h
        lea dx,lose2                            ;print lose2
        int 21h
        mov ah,01h
        int 21h
        jmp menu                                ;goto menu
         
   menu:
        call clr                                ;clear screen
        mov ah,09h                              ;print intro
        lea dx,intro
        int 21h                                 

        mov ah,01h                              ;input character
        int 21h

        cmp al,'e'                              ;if 'e' close
        je close                                
        cmp al,'E'                              ;if 'E' close
        je close

        cmp al,'s'                              ;if 's' goto howtoplay
        je howtoplay

        cmp al,'S'                              ;if 'S' goto howtoplay
        je howtoplay

        jmp menu                                ;else jump menu
    
howtoplay:
        call clr                                ;clear screen
        mov ah,09h                              ;print howtoplay string
        lea dx,howtoplaystr
        int 21h

        mov ah,01h                              ;input character
        int 21h

        mov ah,2ch                              ;get time
        int 21h
        cmp dh,59d                              ;if dh is 59 goto lp1
        je lp1

        add dh,01h                              ;increment dh
        mov curtim,dh

        jmp main_loop                           ;goto main loop

    lp1:
        mov curtim,00h

        jmp main_loop

  close:        
        call clr                        ;clear screen
        mov ah,4ch                      ;close
        int 21h

main endp                               ;end of main proc

clr proc near                           ;clr proc used to clear screen
        mov bh,30h                      ;set bh as 30h to run loop 30h times
        mov ah,09h
        lea dx,nl                       
    agn:                                ;this repeats until bh becomes 0
        int 21h                         ;print new line
        dec bh                          ;decrement bh
        jnz agn                         ;go to agn until bh is zero
        ret
clr endp                                ;end clr proc

gen_ran proc near

        mov ah,00h                      ;get current time
        int 1ah

        mov ax,dx                       
        xor dx,dx                       ;xor dx wth dx
        mov cx,5
        div cx                          ;div by cx

        mov ch,dl                       ;move remainder to ch

        ret

gen_ran endp


refresh proc near

        call clr                        ;clear screen

        mov ah,09h                      ;print score1

        lea dx,scor1
        int 21h

        mov ah,02h                      ;print score
        mov dl,scrh
        int 21h
        mov dl,scrt
        int 21h
        mov dl,scro
        int 21h

        mov ah,09h

        lea dx,scor2                    ;print score2
        int 21h

        lea dx,disp                     ;print disp
        int 21h

        mov cl,r1                       ;print blocks at respective rows and positions
        call print

        mov cl,r2
        call print

        mov cl,r3
        call print

        mov cl,r4
        call print

        mov cl,r5
        call print

        mov cl,r6
        call print

        mov ah,09h
        lea dx,disp                     ;print disp
        int 21h

        cmp pos,00h                     ;print player pos
        jne p2
        lea dx,pos0
        int 21h
        jmp p6

     p2:
        cmp pos,01h
        jne p3
        lea dx,pos1
        int 21h
        jmp p6

     p3:
        cmp pos,02h
        jne p4
        lea dx,pos2
        int 21h
        jmp p6

     p4:
        cmp pos,03h
        jne p5
        lea dx,pos3
        int 21h
        jmp p6

     p5:
        cmp pos,04h
        jne p6
        lea dx,pos4
        int 21h

     p6:

        lea dx,disp
        int 21h

        ret


refresh endp

print proc near

        mov ah,09h

        cmp cl,00h
        jne chk1

        lea dx,b0
        int 21h
        int 21h
        jmp chk6

   chk1:
        cmp cl,01h
        jne chk2

        lea dx,b1
        int 21h
        int 21h
        jmp chk6

   chk2:
        cmp cl,02h
        jne chk3

        lea dx,b2
        int 21h
        int 21h
        jmp chk6

   chk3:
        cmp cl,03h
        jne chk4

        lea dx,b3
        int 21h
        int 21h
        jmp chk6

   chk4:
        cmp cl,04h
        jne chk5

        lea dx,b4
        int 21h
        int 21h
        jmp chk6

   chk5:
        cmp cl,06h
        jne chk6

        lea dx,b
        int 21h
        int 21h
        
   chk6:
        ret

print endp


end main
