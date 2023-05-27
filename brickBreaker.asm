.model huge
.stack 1024h
.data
	
	row dw ?
	col dw ?
	row1 dw ?
	col1 dw ?
	size_sq dw 0
    size_rect1 dw 0
    size_rect2 dw 0
    ball_y dw 186
    ball_x dw 160
    bar_c1 dw 190
    bar_c2 dw 130
    ball_direction db 2
    saveflag dw ?
    bar_len dw 70

	pause_k db 0
	Filehandler dw ?
    buffer db 5000 dup("$")

	min db 0
	sec_t2 db 0
	sec_t1 db 0
	sec db 0

	lives db 3

	level_counter db 1

	level_bricks db 0

	brick_width dw 40
	brick_len dw 10

	game_name db "BRICK BREAKER", '$'

    gamerule1 db '1.Hit the bricks with the ball', "$"
	gamerule2 db '2.Different brick colors have', "$"
	gamerule3 db '  different Points ', "$"
	gamerule4 db '3.Use Arrow Keys to move the slider', "$"
	gamerule5 db '4.Do not let the ball touch the ',"$"
	gamerule6 db '  Lower Boundary ' , "$" 
	gamerule7 db '5.Time Limit of each Level is 4 mins' , "$" 
	gamerule8 db '6.There will be random Power-ups',"$"

    msg1 db 'Enter Name:',"$"
	msg2 db 'Player Name:' ,"$"
	msg3 db 'You Lost !' , "$"
	msg4 db 'Your score was : ', "$"
	msg5 db 'Press P to resume', "$"
	msg6 db 'You Finished the game', "$"
	namestr db 10 DUP(?)
	;namestr db "Luqman", '$'
	namesize dw ?

	filename1 db "scores.txt",0

	menu_op db 1

    lvl1_hits dw 1
    lvl2_hits dw 2
    lvl3_hits dw 3

	score1 db 0
	score2 db 0
	score3 db 0
	score_msg db "Score: ",'$'

    temp dw ?
    ball_speed dw 150

    brick_x1 dw 20
    brick_y1 dw 30
    Brick1_times_hit dw 0
    Brick1_hit_required dw 1

    brick_x2 dw 80
    brick_y2 dw 30
    Brick2_times_hit dw 0
    Brick2_hit_required dw 1

    brick_x3 dw 135
    brick_y3 dw 30
    Brick3_times_hit dw 0
    Brick3_hit_required dw 1

    brick_x4 dw 190
    brick_y4 dw 30
    Brick4_times_hit dw 0
    Brick4_hit_required dw 1

    brick_x5 dw 250
    brick_y5 dw 30
    Brick5_times_hit dw 0
    Brick5_hit_required dw 1

    brick_x6 dw 15
    brick_y6 dw 50
    Brick6_times_hit dw 0
    Brick6_hit_required dw 1

    brick_x7 dw 65
    brick_y7 dw 50
    Brick7_times_hit dw 0
    Brick7_hit_required dw 1

    brick_x8 dw 115
    brick_y8 dw 50
    Brick8_times_hit dw 0
    Brick8_hit_required dw 1

    brick_x9 dw 165
    brick_y9 dw 50
    Brick9_times_hit dw 0
    Brick9_hit_required dw 1

    brick_x10 dw 215
    brick_y10 dw 50
    Brick10_times_hit dw 0
    Brick10_hit_required dw 1

    brick_x11 dw 265
    brick_y11 dw 50
    Brick11_times_hit dw 0
    Brick11_hit_required dw 1

    brick_x12 dw 20
    brick_y12 dw 70
    Brick12_times_hit dw 0
    Brick12_hit_required dw 1

    brick_x13 dw 80
    brick_y13 dw 70
    Brick13_times_hit dw 0
    Brick13_hit_required dw 1

	brick_x14 dw 135
    brick_y14 dw 70
    Brick14_times_hit dw 0
    Brick14_hit_required dw 1

	brick_x15 dw 190
    brick_y15 dw 70
    Brick15_times_hit dw 0
    Brick15_hit_required dw 1

	brick_x16 dw 250
    brick_y16 dw 70
    Brick16_times_hit dw 0
    Brick16_hit_required dw 1
	
.code
	
	jmp start
	
	clear proc
	
	mov ax, 0
	mov bx, 0
	mov cx, 0
	mov dx, 0
	
	ret
	clear endp

    delay macro del
	local L1, L2, exit
    call clear
	mov ax, del
	.if ax == 0
		jmp exit
	.endif
		call clear
		mov cx,del
		L1:
			mov dx,del
			L2:
				dec dx
				cmp dx,0
				jne L2
			Loop L1

		exit:
	endm

	add_score macro V
		local n1,n2,  exit
			add score1, V
			mov al, score1

			cmp al, 9h
			jg n1

			jmp exit

			n1:
			sub score1, 10
			inc score2
			mov al, score2
			cmp al, 9h
			jg n2
			jmp exit

			n2:
			mov score2, 0
			inc score3
			exit:
		endm

	print_score macro
		local n1, n2
			call clear

			mov ah,02h  
			mov dh,1    ;row 
			mov dl,8     ;column
			int 10h

			

			cmp score3, 0
			jz n1

			mov ah, 02h ; num print
			mov dl, score3
			add dl, "0"
			int 21h

			n1:
			cmp score2, 0
			jz n2

			call clear
			mov ah, 02h ; num print
			mov dl, score2
			add dl, "0"
			int 21h

			n2:
			call clear
			mov ah, 02h ; num print
			mov dl, score1
			add dl, "0"
			int 21h
		
			

		endm

    introLevel macro 
	
		;;;;;;;;;;;;;;;;; border for intro page ;;;;;;;;;;;;;;;;
	
		drawRectangle_notFill 10, 10, 298, 180, 07h
        drawRectangle_notFill 5, 5, 308, 190, 08h
		
	
		;;;;;;;;;;;;;;;;;;;;;; printing level title ;;;;;;;;;;;;;;;;;;;;;;;;;;

        call clear
		
		mov ah,02h  
		mov dh, 10 ;row 
		mov dl,15     ;column
		int 10h
		mov ah,09h
		mov bl,0ch   ;colour
		mov cx,1      ;no.of times
		mov al,'L'     ;print B
		int 10h 
		
		delay 300

		mov ah,02h  
		mov dh,10      ;row 
		mov dl,16     ;column
		int 10h
		mov ah,09h
		mov bl,0ch     ;colour
		mov cx,1       ;no.of times
		mov al,'E'     ;print B
		int 10h 
		
		delay 300

		mov ah,02h  
		mov dh,10     ;row 
		mov dl,17     ;column
		int 10h
		mov ah,09h
		mov bl,0ch     ;colour
		mov cx,1       ;no.of times
		mov al,'V'     ;print B
		int 10h 
				
		delay 300

		mov ah,02h  
		mov dh,10     ;row 
		mov dl,18     ;column
		int 10h
		mov ah,09h
		mov bl,0ch     ;colour
		mov cx,1       ;no.of times
		mov al,'E'     ;print B
		int 10h 
				
		delay 300

		mov ah,02h  
		mov dh,10      ;row 
		mov dl,19     ;column
		int 10h
		mov ah,09h
		mov bl,0ch     ;colour
		mov cx,1       ;no.of times
		mov al,'L'     ;print B
		int 10h 
				
		delay 300
		
		mov ah,02h  
		mov dh,10    ;row 
		mov dl,21     ;column
		int 10h

		.if level_counter == 1
        	mov al, '1'
		
		.elseif level_counter == 2
			mov al, '2'
		
		.elseif level_counter == 3
			mov al, '3'
		.endif

		mov ah,09h
		mov bl,0ch     ;colour
		mov cx,1       ;no.of times
		;mov al,'1'     ;print B
		int 10h 
	endm

    title_page macro
	local  printrow1, printcol1, printrow2, printcol2

        drawRectangle_notFill 10, 10, 298, 180, 07h
        drawRectangle_notFill 5, 5, 308, 190, 08h

		;;;;;;;;;;;;;;title display;;;;;;;;;;;;;;;;;;
        call clear

		mov ah,02h  
		mov dh,3      ;row 
		mov dl,14     ;column
		int 10h
		mov ah,09h
		mov bl,0ch   ;colour
		mov cx,1      ;no.of times
		mov al,'I'     ;print B
		int 10h 
		
		delay 300

		mov ah,02h  
		mov dh,3      ;row 
		mov dl,15     ;column
		int 10h
		mov ah,09h
		mov bl,0ch     ;colour
		mov cx,1       ;no.of times
		mov al,'N'     ;print B
		int 10h 
		
		delay 300

		mov ah,02h  
		mov dh,3      ;row 
		mov dl,16     ;column
		int 10h
		mov ah,09h
		mov bl,0ch     ;colour
		mov cx,1       ;no.of times
		mov al,'S'     ;print B
		int 10h 
				
		delay 300

		mov ah,02h  
		mov dh,3     ;row 
		mov dl,17     ;column
		int 10h
		mov ah,09h
		mov bl,0ch     ;colour
		mov cx,1       ;no.of times
		mov al,'T'     ;print B
		int 10h 
				
		delay 300

		mov ah,02h  
		mov dh,3      ;row 
		mov dl,18     ;column
		int 10h
		mov ah,09h
		mov bl,0ch     ;colour
		mov cx,1       ;no.of times
		mov al,'R'     ;print B
		int 10h 
				
		delay 300

		mov ah,02h  
		mov dh,3    ;row 
		mov dl,19     ;column
		int 10h
		mov ah,09h
		mov bl,0ch     ;colour
		mov cx,1       ;no.of times
		mov al,'U'     ;print B
		int 10h 
				
		delay 300

		mov ah,02h  
		mov dh,3     ;row 
		mov dl,20     ;column
		int 10h
		mov ah,09h
		mov bl,0ch     ;colour
		mov cx,1       ;no.of times
		mov al,'C'     ;print B
		int 10h 
		
		delay 300

		mov ah,02h  
		mov dh,3      ;row 
		mov dl,21    ;column
		int 10h
		mov ah,09h
		mov bl,0ch   ;colour
		mov cx,1      ;no.of times
		mov al,'T'     ;print B
		int 10h 
				
		delay 300

		mov ah,02h  
		mov dh,3    ;row 
		mov dl,22    ;column
		int 10h
		mov ah,09h
		mov bl,0ch   ;colour
		mov cx,1      ;no.of times
		mov al,'I'     ;print B
		int 10h 
				
		delay 300

        mov ah,02h  
		mov dh,3    ;row 
		mov dl,23    ;column
		int 10h
		mov ah,09h
		mov bl,0ch   ;colour
		mov cx,1      ;no.of times
		mov al,'O'     ;print B
		int 10h 
				
		delay 300

        mov ah,02h  
		mov dh,3    ;row 
		mov dl,24    ;column
		int 10h
		mov ah,09h
		mov bl,0ch   ;colour
		mov cx,1      ;no.of times
		mov al,'N'     ;print B
		int 10h 
				
		delay 300

        mov ah,02h  
		mov dh,3    ;row 
		mov dl,25    ;column
		int 10h
		mov ah,09h
		mov bl,0ch   ;colour
		mov cx,1      ;no.of times
		mov al,'S'     ;print B
		int 10h 
				
		delay 300
		
		;;;;;;;;;;;;;;;game rules;;;;;;;;;;;;;;;;;;
		
		mov ah, 02h
		mov bx, 0
		mov dl, 2
		mov dh, 6
		int 10h
		mov dx,offset gamerule1
		mov ah, 09h
		int 21h
		
		delay 300
		
		mov ah, 02h
		mov bx, 0
		mov dl, 2
		mov dh, 8
		int 10h
		mov dx,offset gamerule2
		mov ah, 09h
		int 21h

		mov ah, 02h
		mov bx, 0
		mov dl, 2
		mov dh, 10
		int 10h
		mov dx,offset gamerule3
		mov ah, 09h
		int 21h

		delay 300

		mov ah, 02h
		mov bx, 0
		mov dl, 2
		mov dh, 12
		int 10h
		mov dx,offset gamerule4
		mov ah, 09h
		int 21h

		delay 300
		
		mov ah, 02h
		mov bx, 0
		mov dl, 2
		mov dh, 14
		int 10h
		mov dx,offset gamerule5
		mov ah, 09h
		int 21h
		
		mov ah, 02h
		mov bx, 0
		mov dl, 2
		mov dh, 16
		int 10h
		mov dx,offset gamerule6
		mov ah, 09h
		int 21h

		delay 300

		mov ah, 02h
		mov bx, 0
		mov dl, 2
		mov dh, 18
		int 10h
		mov dx,offset gamerule7
		mov ah, 09h
		int 21h

		delay 300

		mov ah, 02h
		mov bx, 0
		mov dl, 2
		mov dh, 20
		int 10h
		mov dx,offset gamerule8
		mov ah, 09h
		int 21h
		
		delay 300

		;print_Enter
		
	endm

    level_main macro

        level_loop:

        call clear

        mov_ball ball_y, ball_x

		.if level_bricks == 13

			.if level_counter == 1	
				level2_reset
				inc level_counter
				jmp level_start

			.elseif level_counter == 2
				level3_reset
				inc level_counter
				jmp level_start
			.endif
		
		.elseif level_bricks == 11 && level_counter == 3
			jmp game_lose

		.endif

        drawRectangle_fill bar_c1, bar_c2, bar_len, 4, 0Bh    

		time

		.if min == 4
			jmp game_lose
	
		.endif

        call clear

        mov ah,1
        int 16h
        jz level_loop

        mov ah,0
        int 16h

        cmp al,13
        je exit	;;;;; remove later

		cmp al,27
        je exit

        cmp ah, 4Bh
        jne n1
        call clear
        mov ax, bar_c2
        mov temp, ax
        sub bar_c2, 5      ;change bar mov length here

        .if bar_c2 > 0
            mov_Bar bar_c1, bar_c2, temp
        .else
            add bar_c2,5   ;change bar mov length here
        .endif

        jmp level_loop

        n1:
        cmp ah,4Dh
        jne n2
        call clear
        mov ax, bar_c2
        mov temp, ax
        add bar_c2, 5      ;change bar mov length here
        
		.if bar_len == 70
			.if bar_c2 < 250
				mov_Bar bar_c1, bar_c2, temp
			.else
				sub bar_c2, 5      ;change bar mov length here
			.endif
		
		.elseif bar_len == 55
			.if bar_c2 < 265
				mov_Bar bar_c1, bar_c2, temp
			.else
				sub bar_c2, 5      ;change bar mov length here
			.endif


        .endif   

		n2:
		cmp al, 112
		jne level_loop

		mov ax, 0
        mov al, 13h
        int 10h

		drawRectangle_notFill 10, 10, 298, 180, 07h
        drawRectangle_notFill 5, 5, 308, 190, 08h

		call clear

		drawRectangle_notFill 40, 90, 130, 22, 04h
		drawRectangle_notFill 35, 85, 140, 32, 0Ch
		printbrickbreaker 0

		mov pause_k, 1
		jmp main_menu_2


        jmp level_loop

    endm

    print_Enter macro
		
		mov ah,02h  
		mov dh, 22   ;row 
		mov dl,9     ;column
		int 10h
		mov ah,09h
		mov bl,0ch   ;colour
		mov cx,1      ;no.of times
		mov al,'P'     ;print B
		int 10h 
				
		delay 200

		mov ah,02h  
		mov dh, 22 ;row 
		mov dl,10     ;column
		int 10h
		mov ah,09h
		mov bl,0ch   ;colour
		mov cx,1      ;no.of times
		mov al,'R'     ;print B
		int 10h 
				
		delay 200

		mov ah,02h  
		mov dh, 22 ;row 
		mov dl,11    ;column
		int 10h
		mov ah,09h
		mov bl,0ch   ;colour
		mov cx,1      ;no.of times
		mov al,'E'     ;print B
		int 10h 
				
		delay 200

		mov ah,02h  
		mov dh, 22 ;row 
		mov dl,12     ;column
		int 10h
		mov ah,09h
		mov bl,0ch   ;colour
		mov cx,1      ;no.of times
		mov al,'S'     ;print B
		int 10h 
				
		delay 200

		mov ah,02h  
		mov dh, 22 ;row 
		mov dl,13     ;column
		int 10h
		mov ah,09h
		mov bl,0ch   ;colour
		mov cx,1      ;no.of times
		mov al,'S'     ;print B
		int 10h 
				
		delay 200

		mov ah,02h  
		mov dh, 22 ;row 
		mov dl,15     ;column
		int 10h
		mov ah,09h
		mov bl,0ch   ;colour
		mov cx,1      ;no.of times
		mov al,'E'     ;print B
		int 10h 
				
		delay 200

		mov ah,02h  
		mov dh, 22 ;row 
		mov dl,16     ;column
		int 10h
		mov ah,09h
		mov bl,0ch   ;colour
		mov cx,1      ;no.of times
		mov al,'N'     ;print B
		int 10h
		
		delay 200

		mov ah,02h  
		mov dh, 22 ;row 
		mov dl,17     ;column
		int 10h
		mov ah,09h
		mov bl,0ch   ;colour
		mov cx,1      ;no.of times
		mov al,'T'     ;print B
		int 10h 
				
		delay 200

		mov ah,02h  
		mov dh, 22 ;row 
		mov dl,18     ;column
		int 10h
		mov ah,09h
		mov bl,0ch   ;colour
		mov cx,1      ;no.of times
		mov al,'E'     ;print B
		int 10h 
				
		delay 200

		mov ah,02h  
		mov dh, 22 ;row 
		mov dl,19     ;column
		int 10h
		mov ah,09h
		mov bl,0ch   ;colour
		mov cx,1      ;no.of times
		mov al,'R'     ;print B
		int 10h 
				
		delay 200

		
		mov ah,02h  
		mov dh, 22 ;row 
		mov dl,21     ;column
		int 10h
		mov ah,09h
		mov bl,0ch   ;colour
		mov cx,1      ;no.of times
		mov al,'T'     ;print B
		int 10h 
				
		delay 200

		mov ah,02h  
		mov dh, 22 ;row 
		mov dl,22     ;column
		int 10h
		mov ah,09h
		mov bl,0ch   ;colour
		mov cx,1      ;no.of times
		mov al,'O'     ;print B
		int 10h 
				
		delay 200

		mov ah,02h  
		mov dh, 22 ;row 
		mov dl,24     ;column
		int 10h
		mov ah,09h
		mov bl,0ch   ;colour
		mov cx,1      ;no.of times
		mov al,'C'     ;print B
		int 10h 
				
		delay 200

		mov ah,02h  
		mov dh, 22 ;row 
		mov dl,25     ;column
		int 10h
		mov ah,09h
		mov bl,0ch   ;colour
		mov cx,1      ;no.of times
		mov al,'O'     ;print B
		int 10h 
				
		delay 200

		mov ah,02h  
		mov dh, 22 ;row 
		mov dl,26     ;column
		int 10h
		mov ah,09h
		mov bl,0ch   ;colour
		mov cx,1      ;no.of times
		mov al,'N'     ;print B
		int 10h 
				
		delay 200

		mov ah,02h  
		mov dh, 22 ;row 
		mov dl,27     ;column
		int 10h
		mov ah,09h
		mov bl,0ch   ;colour
		mov cx,1      ;no.of times
		mov al,'T'     ;print B
		int 10h 
				
		delay 200

		mov ah,02h  
		mov dh, 22 ;row 
		mov dl,28     ;column
		int 10h
		mov ah,09h
		mov bl,0ch   ;colour
		mov cx,1      ;no.of times
		mov al,'I'     ;print B
		int 10h

		delay 200

		mov ah,02h  
		mov dh, 22 ;row 
		mov dl,29     ;column
		int 10h
		mov ah,09h
		mov bl,0ch   ;colour
		mov cx,1      ;no.of times
		mov al,'N'     ;print B
		int 10h 

		delay 200

		mov ah,02h  
		mov dh, 22 ;row 
		mov dl,30     ;column
		int 10h
		mov ah,09h
		mov bl,0ch   ;colour
		mov cx,1      ;no.of times
		mov al,'U'     ;print B
		int 10h

		delay 200

		mov ah,02h  
		mov dh, 22 ;row 
		mov dl,31     ;column
		int 10h
		mov ah,09h
		mov bl,0ch   ;colour
		mov cx,1      ;no.of times
		mov al,'E'     ;print B
		int 10h
		
	endm

    drawRectangle_fill macro a1, a2, s1, s2, color
	    local l1, l2, l3, l4, l5, j1, j2, j3, j4, j5

	    call clear

        mov ax, a1
        mov bx, a2
        mov cx, s1
		mov dx, s2

        mov row, bx
        mov col, ax
        mov size_rect2, dx
        mov size_rect1, cx
	
        l5:
            call clear
            
            
        l1:
            mov ah, 0cH                  ; for pixels
            mov al, color
            mov cx, row                  ; x axis
            mov dx, col                  ; y axis
            int 10h
            
            inc col                      ; print line
            inc bx
            cmp bx, size_rect2
            
            je j1
            jne L1
            
        j1:
            
            call clear
            
        l2:
            mov ah, 0cH                  ; for pixels
            mov al, color
            mov cx, row                  ; x axis
            mov dx, col                  ; y axis
            int 10h
            
            inc row                      ; print line
            inc bx
            cmp bx, size_rect1
            
            je j2
            jne L2
            
        j2:
            
            call clear
            
        l3:
            mov ah, 0cH                  ; for pixels
            mov al, color
            mov cx, row                  ; x axis
            mov dx, col                  ; y axis
            int 10h
            
            dec col                      ; print line
            inc bx
            cmp bx, size_rect2
            
            je j3
            jne L3
            
        j3:
            
            call clear
            
        l4:
            mov ah, 0cH                  ; for pixels
            mov al, color
            mov cx, row                  ; x axis
            mov dx, col                  ; y axis
            int 10h
            
            dec row                      ; print line
            inc bx
            cmp bx, size_rect1
            
            je j4
            jne L4
            
        j4:
            
            ; square
            
            call clear
            
            dec size_rect2
            
            cmp size_rect2, 0
            jne l5
            
	endm

    drawRectangle_notFill macro a1, a2, s1, s2, color
	    local l1, l2, l3, l4, l5, j1, j2, j3, j4, j5

	    call clear

        mov ax, a1
        mov bx, a2
        mov cx, s1

        mov row, bx
        mov col, ax
        mov size_rect2, s2
        mov size_rect1, cx 

        call clear        
            
        l1:
            mov ah, 0cH                  ; for pixels
            mov al, color
            mov cx, row                  ; x axis
            mov dx, col                  ; y axis
            int 10h
            
            inc col                      ; print line
            inc bx
            cmp bx, size_rect2
            
            je j1
            jne L1
            
        j1:
            
            call clear
            
        l2:
            mov ah, 0cH                  ; for pixels
            mov al, color
            mov cx, row                  ; x axis
            mov dx, col                  ; y axis
            int 10h
            
            inc row                      ; print line
            inc bx
            cmp bx, size_rect1
            
            je j2
            jne L2
            
        j2:
            
            call clear
            
        l3:
            mov ah, 0cH                  ; for pixels
            mov al, color
            mov cx, row                  ; x axis
            mov dx, col                  ; y axis
            int 10h
            
            dec col                      ; print line
            inc bx
            cmp bx, size_rect2
            
            je j3
            jne L3
            
        j3:
            
            call clear
            
        l4:
            mov ah, 0cH                  ; for pixels
            mov al, color
            mov cx, row                  ; x axis
            mov dx, col                  ; y axis
            int 10h
            
            dec row                      ; print line
            inc bx
            cmp bx, size_rect1
            
            je j4
            jne L4
            
        j4:
                    
	endm

    printBrickBreaker macro c1
	
		;;;;;;;;;;;;;;;; title display ;;;;;;;;;;;;;;;;;;;

		call clear
	
		mov ah,02h  
		mov dh, 6 ;row 
		mov dl,13     ;column
		int 10h
		mov ah,09h
		mov bl,0ch   ;colour
		mov cx,1      ;no.of times
		mov al,'B'     ;print B
		int 10h 
		
		delay c1

		mov ah,02h  
		mov dh,6      ;row 
		mov dl,14     ;column
		int 10h
		mov ah,09h
		mov bl,0ch     ;colour
		mov cx,1       ;no.of times
		mov al,'R'     ;print B
		int 10h 
		
		delay c1

		mov ah,02h  
		mov dh,6      ;row 
		mov dl,15     ;column
		int 10h
		mov ah,09h
		mov bl,0ch     ;colour
		mov cx,1       ;no.of times
		mov al,'I'     ;print B
		int 10h 
				
		delay c1

		mov ah,02h  
		mov dh,6     ;row 
		mov dl,16     ;column
		int 10h
		mov ah,09h
		mov bl,0ch     ;colour
		mov cx,1       ;no.of times
		mov al,'C'     ;print B
		int 10h 
				
		delay c1

		mov ah,02h  
		mov dh,6      ;row 
		mov dl,17     ;column
		int 10h
		mov ah,09h
		mov bl,0ch     ;colour
		mov cx,1       ;no.of times
		mov al,'K'     ;print B
		int 10h 
				
		delay c1

		mov ah,02h  
		mov dh,6    ;row 
		mov dl,19     ;column
		int 10h
		mov ah,09h
		mov bl,0ch     ;colour
		mov cx,1       ;no.of times
		mov al,'B'     ;print B
		int 10h 
				
		delay c1

		mov ah,02h  
		mov dh,6     ;row 
		mov dl,20     ;column
		int 10h
		mov ah,09h
		mov bl,0ch     ;colour
		mov cx,1       ;no.of times
		mov al,'R'     ;print B
		int 10h 
		
		delay c1

		mov ah,02h  
		mov dh,6      ;row 
		mov dl,21    ;column
		int 10h
		mov ah,09h
		mov bl,0ch   ;colour
		mov cx,1      ;no.of times
		mov al,'E'     ;print B
		int 10h 
				
		delay c1

		mov ah,02h  
		mov dh,6    ;row 
		mov dl,22    ;column
		int 10h
		mov ah,09h
		mov bl,0ch   ;colour
		mov cx,1      ;no.of times
		mov al,'A'     ;print B
		int 10h 
				
		delay c1

		mov ah,02h  
		mov dh,6   ;row 
		mov dl,23     ;column
		int 10h
		mov ah,09h
		mov bl,0ch   ;colour
		mov cx,1      ;no.of times
		mov al,'K'     ;print B
		int 10h 
				
		delay c1

		mov ah,02h  
		mov dh,6   ;row 
		mov dl,24     ;column
		int 10h
		mov ah,09h
		mov bl,0ch   ;colour
		mov cx,1      ;no.of times
		mov al,'E'     ;print B
		int 10h 
				
		delay c1

		mov ah,02h  
		mov dh,6   ;row 
		mov dl,25     ;column
		int 10h
		mov ah,09h
		mov bl,0ch   ;colour
		mov cx,1      ;no.of times
		mov al,'R'     ;print B
		int 10h 
				
		delay c1

	endm

    name_input macro 
	local first, first1,printrow1,printcol1,printrow2,printcol2
	

		;border
        drawRectangle_notFill 10, 10, 298, 180, 07h
        drawRectangle_notFill 5, 5, 308, 190, 08h

        call clear
		drawRectangle_notFill 40, 90, 130, 22, 04h
		drawRectangle_notFill 35, 85, 140, 32, 0Ch
		printbrickbreaker 300
		
		call clear
		mov row, 60
		mov col, 88

		;printing name box
		
		printrow1:
			mov ah,0ch
			mov al,0ch
			mov bx,0
			mov cx,row
			mov dx,col
			int 10h
			inc row
			cmp row,260
		jbe printrow1
		
		printcol1:
			mov ah,0ch
			mov al,0ch
			mov bx,0
			mov cx,row
			mov dx,col
			int 10h
			inc col
			cmp col,110
		jbe printcol1
		
		printrow2:
			mov ah,0ch
			mov al,0ch
			mov bx,0
			mov cx,row
			mov dx,col
			int 10h
			dec row
			cmp row,60
		jae printrow2
		
		printcol2:
			mov ah,0ch
			mov al,0ch
			mov bx,0
			mov cx,row
			mov dx,col
			int 10h
			dec col
			cmp col,88
		jae printcol2

		;delay 300
		
		;;;;;;;;;;;;;;;;;taking name input;;;;;;;;;;;;;;;;
		
		mov ah, 02h
		mov bx, 0
		mov dl, 9
		mov dh, 12
		int 10h
		mov dx,offset msg1
		mov ah, 09h
		int 21h
		
		mov dx , offset namestr
		mov ah , 3Fh
		int 21h
		mov bx , 0
		first:
			cmp namestr[bx] , 13
			je first1

			inc bx
			jmp first

		first1:

		inc bx
		mov namestr[bx], '$'
		dec bx
		mov namesize, bx
		
	endm

	filehandling macro 

		mov dx, offset filename1 
		mov al, 0 ; Open filename1 (read-only)
		mov ah, 3dh ; Load File Handler and store in ax
		int 21h

		mov bx, ax ; Move filename1 Handler to bx
		mov dx, offset buffer ; Load address of string in which filename1 contents will be stored after reading

		mov ah, 3fh ; Interrupt to read filename1
		int 21h

		mov dx, offset filename1 ; Load address of String “file”
		mov al, 2 ; Open filename1 (read/write)
		mov ah, 3dh ; Load File Handler and store in ax
		int 21h
		mov cx, lengthof namestr ; Number of bytes to write

		dec cx
		mov bx, ax ; Move filename1 Handler to bx
		mov dx, offset namestr ; Load offset of string which is to be written to filename1
		mov al, 2
		mov ah, 40h ; Write to filename1
		int 21h

		mov cx,0
		mov ah, 42h ; Move filename1 pointer
		mov al, 02h ; End of File
		int 21h

		mov ah, 3eh
		int 21h
	
	endm

	time macro

			call clear
			mov ah, 2ch
			int 21h

			mov sec_t1, dh 
			mov al,  sec_t1
			sub al, sec_t2

			.if al >= 1

				mov al, sec_t1 
				mov sec_t2, al

				inc sec 

				.if sec == 60
					mov sec , 0
					inc min 
				.endif

				mov ah,02h  
				mov dh,1    ;row 
				mov dl,18     ;column
				int 10h

				output min 

				mov ah, 02h ;space print
				mov dl, ":"
				int 21h

				output sec

				mov ah, 02h ;space print
				mov dl, " "
				int 21h
				

			.endif

		endm

		time_start macro 
			call clear
			mov ah, 2ch
			int 21h

			mov sec_t2, dh
		endm

		output macro var

			mov ax, 0
			mov al, var
			mov bl, 10

			div bl

			mov ch, ah
			mov cl, al

			mov ax, 0
			mov ah, 02h ; num print
			mov dl, cl
			add dl, "0"
			int 21h

			mov ax, 0
			mov ah, 02h ; num print
			mov dl, ch
			add dl, "0"
			int 21h

		endm
	
	drawSquare macro a1, a2, s1, color
	    local l1, l2, l3, l4, l5, j1, j2, j3, j4, j5

	    call clear

        mov ax, a1
        mov bx, a2

        mov row, bx
        mov col, ax
        mov size_sq, s1
	
        l5:
            call clear
            
            
        l1:
            mov ah, 0cH                  ; for pixels
            mov al, color
            mov cx, row                  ; x axis
            mov dx, col                  ; y axis
            int 10h
            
            inc col                      ; print line
            inc bx
            cmp bx, size_sq
            
            je j1
            jne L1
            
        j1:
            
            call clear
            
        l2:
            mov ah, 0cH                  ; for pixels
            mov al, color
            mov cx, row                  ; x axis
            mov dx, col                  ; y axis
            int 10h
            
            inc row                      ; print line
            inc bx
            cmp bx, size_sq
            
            je j2
            jne L2
            
        j2:
            
            call clear
            
        l3:
            mov ah, 0cH                  ; for pixels
            mov al, color
            mov cx, row                  ; x axis
            mov dx, col                  ; y axis
            int 10h
            
            dec col                      ; print line
            inc bx
            cmp bx, size_sq
            
            je j3
            jne L3
            
        j3:
            
            call clear
            
        l4:
            mov ah, 0cH                  ; for pixels
            mov al, color
            mov cx, row                  ; x axis
            mov dx, col                  ; y axis
            int 10h
            
            dec row                      ; print line
            inc bx
            cmp bx, size_sq
            
            je j4
            jne L4
            
        j4:
            
            ; square
            
            call clear
            
            dec size_sq
            
            cmp size_sq, 0
            jne l5
            
	endm

	beep macro val 
			call clear
			mov cx,1
			mov al, 182
			out 43h, al
			mov ax, val
			
			out 42h, al
			mov al, ah
			out 42h, al
			in al, 61h
			
			or al, 3
			out 61h, al
			mov dx, 4240h
			mov ah, 86h
			int 15h
			in al, 61h
			
			and al, 11111100b
			out 61h, al

		endm

    check_collision macro x, y, z, p, color
        local exit
        call clear
        mov ax, x
        mov bx, y
		sub bx , 4

        mov dx, y
        add dx, brick_len
		inc dx

        .if ball_x >= ax 
            add ax, brick_width
            .if ball_x <= ax
                .if ball_y == bx

                    mov cx, z
                    inc cx
                    mov z, cx
                    mov cx, p

                    .if z == cx
                        drawRectangle_fill y ,x ,brick_width,brick_len, 00h
						call clear
						mov cx , color

						.if cx == 02h
							add_score 2
						.elseif cx == 03h
							add_score 3
						.elseif cx == 05h
							add_score 4
						.elseif cx == 06h
							add_score 5
						.endif

						.if x == 155 && y == 90 && level_bricks >= 6 && level_counter == 3
							mov level_bricks, 10

						.endif

						beep 800
						inc level_bricks

						

						print_score

                        mov x, 0
                        mov y, 0

					.elseif z == 1 
						drawRectangle_fill y ,x ,brick_width,brick_len, color+8
						beep 900
						
                    .endif

                    call clear
                    mov cl, ball_direction

                    .if  cl == 3

                        mov ball_direction, 1
                    
                    .elseif cl == 4

                       mov ball_direction, 2
                    .endif
                    jmp exit
                .elseif ball_y == dx

                    mov cx, z
                    inc cx
                    mov z, cx
                    mov cx, p

                    .if z == cx
                        drawRectangle_fill y ,x ,brick_width,brick_len, 00h
						call clear
						mov cx , color

						.if cx == 02h
							add_score 2
						.elseif cx == 03h
							add_score 3
						.elseif cx == 05h
							add_score 4
						.elseif cx == 06h
							add_score 5
						.endif

						.if x == 155 && y == 90 && level_bricks >= 6 && level_counter == 3
							mov level_bricks, 10

						.endif
					
						inc level_bricks
						beep 800
						print_score
                        mov x, 0
                        mov y, 0

					.elseif z == 1 
						drawRectangle_fill y ,x ,brick_width,brick_len, color+8
						beep 900

                    .endif

                    call clear
                    mov cl, ball_direction

                    .if  cl == 2

                        mov ball_direction, 4
                    
                    .elseif cl == 1

                       mov ball_direction, 3
                    .endif
                    jmp exit

                .endif
             .endif

        .endif
        call clear
        mov ax, y
        mov bx, x
        sub bx, 4
        mov dx, x
        add dx, brick_width
		inc dx
		inc dx

        .if ball_y >= ax
            add ax, brick_len
            .if ball_y <= ax
                .if ball_x == bx
                    mov cx, z
                    inc cx
                    mov z, cx
                    mov cx, p

                    .if z == cx
                        drawRectangle_fill y ,x ,brick_width, brick_len, 00h
						call clear
						mov cx , color

						.if cx == 02h
							add_score 2
						.elseif cx == 03h
							add_score 3
						.elseif cx == 05h
							add_score 4
						.elseif cx == 06h
							add_score 5
						.endif

						.if x == 155 && y == 90 && level_bricks >= 6 && level_counter == 3
							mov level_bricks, 10

						.endif

						inc level_bricks
						beep 800

						print_score
                        mov x, 0
                        mov y, 0

						.elseif z == 1 
							drawRectangle_fill y ,x ,brick_width,brick_len, color+8
							beep 900

                    .endif

                    call clear
                    mov cl, ball_direction

                    .if  cl == 3

                        mov ball_direction, 4
                    
                    .elseif cl == 1

                       mov ball_direction, 2
                    .endif

                .elseif ball_x == dx

                    mov cx, z
                    inc cx
                    mov z, cx
                    mov cx, p

                    .if z == cx
                        drawRectangle_fill y ,x ,brick_width, brick_len, 00h
						call clear
						mov cx , color

						.if cx == 02h
							add_score 2
						.elseif cx == 03h
							add_score 3
						.elseif cx == 05h
							add_score 4
						.elseif cx == 06h
							add_score 5
						.endif

						.if x == 155 && y == 90 && level_bricks >= 6 && level_counter == 3
							mov level_bricks, 10

						.endif

						inc level_bricks
						beep 800

						print_score
                        mov x, 0
                        mov y, 0

						.elseif z == 1 
							drawRectangle_fill y ,x ,brick_width,brick_len, color+8
							beep 900

                    .endif

                    call clear
                    mov cl, ball_direction

                    .if  cl == 2

                        mov ball_direction, 1
                    
                    .elseif cl == 4

                       mov ball_direction, 3
                    .endif
                .endif
            .endif

        .endif

        exit:

    endm

	menu_page macro color1, color2, color3, color4 

		mov ax, 0
        mov al, 13h
        int 10h

        call clear

		drawRectangle_notFill 10, 10, 298, 180, 07h
        drawRectangle_notFill 5, 5, 308, 190, 08h

		call clear

		drawRectangle_notFill 40, 90, 130, 22, 04h
		drawRectangle_notFill 35, 85, 140, 32, 0Ch
		printbrickbreaker 300
		
        call clear

        mov ah,02h  
		mov dh,22    ;row 
		mov dl,2     ;column
		int 10h

        lea dx, msg2 ;string print
        mov ah, 09h
        int 21h

        lea dx, namestr ;string print
        mov ah, 09h
        int 21h

        call clear

        mov ah,02h  
		mov dh,10    ;row 
		mov dl,16     ;column
		int 10h
		mov ah,09h
		mov bl,color1     ;colour
		mov cx,1       ;no.of times
		mov al,'N'     ;print B
		int 10h 
				
		delay 200

        call clear

        mov ah,02h  
		mov dh,10    ;row 
		mov dl,17     ;column
		int 10h
		mov ah,09h
		mov bl,color1     ;colour
		mov cx,1       ;no.of times
		mov al,'E'     ;print B
		int 10h 
				
		delay 200

        call clear

        mov ah,02h  
		mov dh,10    ;row 
		mov dl,18     ;column
		int 10h
		mov ah,09h
		mov bl,color1     ;colour
		mov cx,1       ;no.of times
		mov al,'W'     ;print B
		int 10h 
				
		delay 200

        call clear

        mov ah,02h  
		mov dh,10    ;row 
		mov dl,20     ;column
		int 10h
		mov ah,09h
		mov bl,color1     ;colour
		mov cx,1       ;no.of times
		mov al,'G'     ;print B
		int 10h 
				
		delay 200

        call clear

        mov ah,02h  
		mov dh,10    ;row 
		mov dl,21     ;column
		int 10h
		mov ah,09h
		mov bl,color1     ;colour
		mov cx,1       ;no.of times
		mov al,'A'     ;print B
		int 10h 
				
		delay 200

        call clear

        mov ah,02h  
		mov dh,10    ;row 
		mov dl,22     ;column
		int 10h
		mov ah,09h
		mov bl,color1     ;colour
		mov cx,1       ;no.of times
		mov al,'M'     ;print B
		int 10h 
				
		delay 200

        call clear

        mov ah,02h  
		mov dh,10    ;row 
		mov dl,23     ;column
		int 10h
		mov ah,09h
		mov bl,color1     ;colour
		mov cx,1       ;no.of times
		mov al,'E'     ;print B
		int 10h 
				
		delay 300

        call clear

        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        mov ah,02h  
		mov dh,13    ;row 
		mov dl,14     ;column
		int 10h
		mov ah,09h
		mov bl,color2     ;colour
		mov cx,1       ;no.of times
		mov al,'I'     ;print B
		int 10h 
				
		delay 200

        call clear

        mov ah,02h  
		mov dh,13    ;row 
		mov dl,15     ;column
		int 10h
		mov ah,09h
		mov bl,color2     ;colour
		mov cx,1       ;no.of times
		mov al,'N'     ;print B
		int 10h 
				
		delay 200

        call clear

        mov ah,02h  
		mov dh,13    ;row 
		mov dl,16     ;column
		int 10h
		mov ah,09h
		mov bl,color2     ;colour
		mov cx,1       ;no.of times
		mov al,'S'     ;print B
		int 10h 
				
		delay 200

        call clear

        mov ah,02h  
		mov dh,13    ;row 
		mov dl,17     ;column
		int 10h
		mov ah,09h
		mov bl,color2     ;colour
		mov cx,1       ;no.of times
		mov al,'T'     ;print B
		int 10h 
				
		delay 200

        call clear

        mov ah,02h  
		mov dh,13    ;row 
		mov dl,18     ;column
		int 10h
		mov ah,09h
		mov bl,color2     ;colour
		mov cx,1       ;no.of times
		mov al,'R'     ;print B
		int 10h 
				
		delay 200

        call clear

        mov ah,02h  
		mov dh,13    ;row 
		mov dl,19     ;column
		int 10h
		mov ah,09h
		mov bl,color2     ;colour
		mov cx,1       ;no.of times
		mov al,'U'     ;print B
		int 10h 
				
		delay 200

        call clear

        mov ah,02h  
		mov dh,13    ;row 
		mov dl,20     ;column
		int 10h
		mov ah,09h
		mov bl,color2     ;colour
		mov cx,1       ;no.of times
		mov al,'C'     ;print B
		int 10h 
				
		delay 200

        call clear

        mov ah,02h  
		mov dh,13    ;row 
		mov dl,21     ;column
		int 10h
		mov ah,09h
		mov bl,color2     ;colour
		mov cx,1       ;no.of times
		mov al,'T'     ;print B
		int 10h 
				
		delay 200

        call clear

        mov ah,02h  
		mov dh,13    ;row 
		mov dl,22     ;column
		int 10h
		mov ah,09h
		mov bl,color2     ;colour
		mov cx,1       ;no.of times
		mov al,'I'     ;print B
		int 10h 
				
		delay 200

        call clear

        mov ah,02h  
		mov dh,13    ;row 
		mov dl,23     ;column
		int 10h
		mov ah,09h
		mov bl,color2     ;colour
		mov cx,1       ;no.of times
		mov al,'O'     ;print B
		int 10h 
				
		delay 200

        call clear

        mov ah,02h  
		mov dh,13    ;row 
		mov dl,24     ;column
		int 10h
		mov ah,09h
		mov bl,color2     ;colour
		mov cx,1       ;no.of times
		mov al,'N'     ;print B
		int 10h 
				
		delay 200

        call clear

        mov ah,02h  
		mov dh,13    ;row 
		mov dl,25     ;column
		int 10h
		mov ah,09h
		mov bl,color2     ;colour
		mov cx,1       ;no.of times
		mov al,'S'     ;print B
		int 10h 
				
        call clear

		delay 300

        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        

        mov ah,02h  
		mov dh,16    ;row 
		mov dl,15     ;column
		int 10h
		mov ah,09h
		mov bl,color3     ;colour
		mov cx,1       ;no.of times
		mov al,'H'     ;print B
		int 10h 
				
		delay 200

        call clear

        mov ah,02h  
		mov dh,16    ;row 
		mov dl,16     ;column
		int 10h
		mov ah,09h
		mov bl,color3     ;colour
		mov cx,1       ;no.of times
		mov al,'I'     ;print B
		int 10h 
				
		delay 200

        call clear

        mov ah,02h  
		mov dh,16    ;row 
		mov dl,17     ;column
		int 10h
		mov ah,09h
		mov bl,color3     ;colour
		mov cx,1       ;no.of times
		mov al,'G'     ;print B
		int 10h 
				
		delay 200

        call clear

        mov ah,02h  
		mov dh,16    ;row 
		mov dl,18     ;column
		int 10h
		mov ah,09h
		mov bl,color3     ;colour
		mov cx,1       ;no.of times
		mov al,'H'     ;print B
		int 10h 
				
		delay 200

        call clear

        mov ah,02h  
		mov dh,16    ;row 
		mov dl,20     ;column
		int 10h
		mov ah,09h
		mov bl,color3     ;colour
		mov cx,1       ;no.of times
		mov al,'S'     ;print B
		int 10h 
				
		delay 200

        call clear

        mov ah,02h  
		mov dh,16    ;row 
		mov dl,21     ;column
		int 10h
		mov ah,09h
		mov bl,color3     ;colour
		mov cx,1       ;no.of times
		mov al,'C'     ;print B
		int 10h 
				
		delay 200

        call clear

        mov ah,02h  
		mov dh,16    ;row 
		mov dl,22     ;column
		int 10h
		mov ah,09h
		mov bl,color3     ;colour
		mov cx,1       ;no.of times
		mov al,'O'     ;print B
		int 10h 
				
		delay 200

        call clear

        mov ah,02h  
		mov dh,16    ;row 
		mov dl,23     ;column
		int 10h
		mov ah,09h
		mov bl,color3     ;colour
		mov cx,1       ;no.of times
		mov al,'R'     ;print B
		int 10h 
				
		delay 200

        call clear

        mov ah,02h  
		mov dh,16    ;row 
		mov dl,24     ;column
		int 10h
		mov ah,09h
		mov bl,color3     ;colour
		mov cx,1       ;no.of times
		mov al,'E'     ;print B
		int 10h 
				
		delay 300

        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        mov ah,02h  
		mov dh,19    ;row 
		mov dl,18     ;column
		int 10h
		mov ah,09h
		mov bl,color4     ;colour
		mov cx,1       ;no.of times
		mov al,'E'     ;print B
		int 10h 
				
		delay 200

        call clear

        mov ah,02h  
		mov dh,19    ;row 
		mov dl,19     ;column
		int 10h
		mov ah,09h
		mov bl,color4     ;colour
		mov cx,1       ;no.of times
		mov al,'X'     ;print B
		int 10h 
				
		delay 200

        call clear

        mov ah,02h  
		mov dh,19    ;row 
		mov dl,20     ;column
		int 10h
		mov ah,09h
		mov bl,color4     ;colour
		mov cx,1       ;no.of times
		mov al,'I'     ;print B
		int 10h 
				
		delay 200

        call clear

        mov ah,02h  
		mov dh,19    ;row 
		mov dl,21     ;column
		int 10h
		mov ah,09h
		mov bl,color4     ;colour
		mov cx,1       ;no.of times
		mov al,'T'     ;print B
		int 10h 
				
		;delay 200

        call clear

    endm

	menu_page_options macro color1, color2, color3, color4 

        call clear

        mov ah,02h  
		mov dh,10    ;row 
		mov dl,16     ;column
		int 10h
		mov ah,09h
		mov bl,color1     ;colour
		mov cx,1       ;no.of times
		mov al,'N'     ;print B
		int 10h 

        call clear

        mov ah,02h  
		mov dh,10    ;row 
		mov dl,17     ;column
		int 10h
		mov ah,09h
		mov bl,color1     ;colour
		mov cx,1       ;no.of times
		mov al,'E'     ;print B
		int 10h 
			

        call clear

        mov ah,02h  
		mov dh,10    ;row 
		mov dl,18     ;column
		int 10h
		mov ah,09h
		mov bl,color1     ;colour
		mov cx,1       ;no.of times
		mov al,'W'     ;print B
		int 10h 
				

        call clear

        mov ah,02h  
		mov dh,10    ;row 
		mov dl,20     ;column
		int 10h
		mov ah,09h
		mov bl,color1     ;colour
		mov cx,1       ;no.of times
		mov al,'G'     ;print B
		int 10h 
				

        call clear

        mov ah,02h  
		mov dh,10    ;row 
		mov dl,21     ;column
		int 10h
		mov ah,09h
		mov bl,color1     ;colour
		mov cx,1       ;no.of times
		mov al,'A'     ;print B
		int 10h 
				

        call clear

        mov ah,02h  
		mov dh,10    ;row 
		mov dl,22     ;column
		int 10h
		mov ah,09h
		mov bl,color1     ;colour
		mov cx,1       ;no.of times
		mov al,'M'     ;print B
		int 10h 
				

        call clear

        mov ah,02h  
		mov dh,10    ;row 
		mov dl,23     ;column
		int 10h
		mov ah,09h
		mov bl,color1     ;colour
		mov cx,1       ;no.of times
		mov al,'E'     ;print B
		int 10h 
				

        call clear

        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        mov ah,02h  
		mov dh,13    ;row 
		mov dl,14     ;column
		int 10h
		mov ah,09h
		mov bl,color2     ;colour
		mov cx,1       ;no.of times
		mov al,'I'     ;print B
		int 10h 
				

        call clear

        mov ah,02h  
		mov dh,13    ;row 
		mov dl,15     ;column
		int 10h
		mov ah,09h
		mov bl,color2     ;colour
		mov cx,1       ;no.of times
		mov al,'N'     ;print B
		int 10h 
				

        call clear

        mov ah,02h  
		mov dh,13    ;row 
		mov dl,16     ;column
		int 10h
		mov ah,09h
		mov bl,color2     ;colour
		mov cx,1       ;no.of times
		mov al,'S'     ;print B
		int 10h 
				

        call clear

        mov ah,02h  
		mov dh,13    ;row 
		mov dl,17     ;column
		int 10h
		mov ah,09h
		mov bl,color2     ;colour
		mov cx,1       ;no.of times
		mov al,'T'     ;print B
		int 10h 
				

        call clear

        mov ah,02h  
		mov dh,13    ;row 
		mov dl,18     ;column
		int 10h
		mov ah,09h
		mov bl,color2     ;colour
		mov cx,1       ;no.of times
		mov al,'R'     ;print B
		int 10h 

        call clear

        mov ah,02h  
		mov dh,13    ;row 
		mov dl,19     ;column
		int 10h
		mov ah,09h
		mov bl,color2     ;colour
		mov cx,1       ;no.of times
		mov al,'U'     ;print B
		int 10h 

        call clear

        mov ah,02h  
		mov dh,13    ;row 
		mov dl,20     ;column
		int 10h
		mov ah,09h
		mov bl,color2     ;colour
		mov cx,1       ;no.of times
		mov al,'C'     ;print B
		int 10h 

        call clear

        mov ah,02h  
		mov dh,13    ;row 
		mov dl,21     ;column
		int 10h
		mov ah,09h
		mov bl,color2     ;colour
		mov cx,1       ;no.of times
		mov al,'T'     ;print B
		int 10h 

        call clear

        mov ah,02h  
		mov dh,13    ;row 
		mov dl,22     ;column
		int 10h
		mov ah,09h
		mov bl,color2     ;colour
		mov cx,1       ;no.of times
		mov al,'I'     ;print B
		int 10h 

        call clear

        mov ah,02h  
		mov dh,13    ;row 
		mov dl,23     ;column
		int 10h
		mov ah,09h
		mov bl,color2     ;colour
		mov cx,1       ;no.of times
		mov al,'O'     ;print B
		int 10h 

        call clear

        mov ah,02h  
		mov dh,13    ;row 
		mov dl,24     ;column
		int 10h
		mov ah,09h
		mov bl,color2     ;colour
		mov cx,1       ;no.of times
		mov al,'N'     ;print B
		int 10h 

        call clear

        mov ah,02h  
		mov dh,13    ;row 
		mov dl,25     ;column
		int 10h
		mov ah,09h
		mov bl,color2     ;colour
		mov cx,1       ;no.of times
		mov al,'S'     ;print B
		int 10h 

        call clear

        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        

        mov ah,02h  
		mov dh,16    ;row 
		mov dl,15     ;column
		int 10h
		mov ah,09h
		mov bl,color3     ;colour
		mov cx,1       ;no.of times
		mov al,'H'     ;print B
		int 10h 

        call clear

        mov ah,02h  
		mov dh,16    ;row 
		mov dl,16     ;column
		int 10h
		mov ah,09h
		mov bl,color3     ;colour
		mov cx,1       ;no.of times
		mov al,'I'     ;print B
		int 10h 

        call clear

        mov ah,02h  
		mov dh,16    ;row 
		mov dl,17     ;column
		int 10h
		mov ah,09h
		mov bl,color3     ;colour
		mov cx,1       ;no.of times
		mov al,'G'     ;print B
		int 10h 

        call clear

        mov ah,02h  
		mov dh,16    ;row 
		mov dl,18     ;column
		int 10h
		mov ah,09h
		mov bl,color3     ;colour
		mov cx,1       ;no.of times
		mov al,'H'     ;print B
		int 10h 

        call clear

        mov ah,02h  
		mov dh,16    ;row 
		mov dl,20     ;column
		int 10h
		mov ah,09h
		mov bl,color3     ;colour
		mov cx,1       ;no.of times
		mov al,'S'     ;print B
		int 10h 

        call clear

        mov ah,02h  
		mov dh,16    ;row 
		mov dl,21     ;column
		int 10h
		mov ah,09h
		mov bl,color3     ;colour
		mov cx,1       ;no.of times
		mov al,'C'     ;print B
		int 10h 

        call clear

        mov ah,02h  
		mov dh,16    ;row 
		mov dl,22     ;column
		int 10h
		mov ah,09h
		mov bl,color3     ;colour
		mov cx,1       ;no.of times
		mov al,'O'     ;print B
		int 10h 

        call clear

        mov ah,02h  
		mov dh,16    ;row 
		mov dl,23     ;column
		int 10h
		mov ah,09h
		mov bl,color3     ;colour
		mov cx,1       ;no.of times
		mov al,'R'     ;print B
		int 10h 

        call clear

        mov ah,02h  
		mov dh,16    ;row 
		mov dl,24     ;column
		int 10h
		mov ah,09h
		mov bl,color3     ;colour
		mov cx,1       ;no.of times
		mov al,'E'     ;print B
		int 10h 

        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        mov ah,02h  
		mov dh,19    ;row 
		mov dl,18     ;column
		int 10h
		mov ah,09h
		mov bl,color4     ;colour
		mov cx,1       ;no.of times
		mov al,'E'     ;print B
		int 10h 

        call clear

        mov ah,02h  
		mov dh,19    ;row 
		mov dl,19     ;column
		int 10h
		mov ah,09h
		mov bl,color4     ;colour
		mov cx,1       ;no.of times
		mov al,'X'     ;print B
		int 10h 

        call clear

        mov ah,02h  
		mov dh,19    ;row 
		mov dl,20     ;column
		int 10h
		mov ah,09h
		mov bl,color4     ;colour
		mov cx,1       ;no.of times
		mov al,'I'     ;print B
		int 10h 

        call clear

        mov ah,02h  
		mov dh,19    ;row 
		mov dl,21     ;column
		int 10h
		mov ah,09h
		mov bl,color4     ;colour
		mov cx,1       ;no.of times
		mov al,'T'     ;print B
		int 10h 

        call clear

    endm

	draw_lives macro 
		call clear
	
        mov ah,02h  
		mov dh,1    ;row 
		mov dl,35     ;column
		int 10h

		mov ah,09h
		mov bl,04h     ;colour
		mov cl,lives       ;no.of times
		mov al,3     ;print B
		int 10h 
		
	endm

	level1_reset macro

		mov score1 , 0
		mov score2 , 0
		mov score3 , 0

		mov min, 0
		mov sec, 0

		mov ball_speed , 150
		mov ball_y , 186
		mov ball_x , 160
		mov bar_c1 , 190
		mov bar_c2 , 130
		mov ball_direction , 2
		mov bar_len , 70

		mov brick_x1 , 20
		mov brick_y1 , 30
		mov Brick1_times_hit , 0
		mov Brick1_hit_required , 1

		mov brick_x2 , 80
		mov brick_y2 , 30
		mov Brick2_times_hit , 0
		mov Brick2_hit_required , 1

		mov brick_x3 , 135
		mov brick_y3 , 30
		mov Brick3_times_hit , 0
		mov Brick3_hit_required , 1

		mov brick_x4 , 190
		mov brick_y4 , 30
		mov Brick4_times_hit , 0
		mov Brick4_hit_required , 1

		mov brick_x5 , 250
		mov brick_y5 , 30
		mov Brick5_times_hit , 0
		mov Brick5_hit_required , 1

		mov brick_x6 , 15
		mov brick_y6 , 50
		mov Brick6_times_hit , 0
		mov Brick6_hit_required , 1

		mov brick_x7 , 65
		mov brick_y7 , 50
		mov Brick7_times_hit , 0
		mov Brick7_hit_required , 1

		mov brick_x8 , 115
		mov brick_y8 , 50
		mov Brick8_times_hit , 0
		mov Brick8_hit_required , 1

		mov brick_x9 , 165
		mov brick_y9 , 50
		mov Brick9_times_hit , 0
		mov Brick9_hit_required , 1

		mov brick_x10 , 215
		mov brick_y10 , 50
		mov Brick10_times_hit , 0
		mov Brick10_hit_required ,1

		mov brick_x11 , 265
		mov brick_y11 , 50
		mov Brick11_times_hit , 0
		mov Brick11_hit_required , 1

		mov brick_x12 , 30
		mov brick_y12 , 70
		mov Brick12_times_hit , 0
		mov Brick12_hit_required , 1

		mov brick_x13 , 80
		mov brick_y13 , 70
		mov Brick13_times_hit , 0
		mov Brick13_hit_required , 1

		mov brick_x14 , 130
		mov brick_y14 , 70
		mov Brick14_times_hit , 0
		mov Brick14_hit_required , 1

		mov brick_x15 , 180
		mov brick_y15 , 70
		mov Brick15_times_hit , 0
		mov Brick15_hit_required , 1

		mov brick_x16 , 240
		mov brick_y16 , 70
		mov Brick16_times_hit , 0
		mov Brick16_hit_required , 1


	endm

	level2_reset macro

		mov ball_speed , 115 ; change ball speed

		mov ball_y , 186
		mov ball_x , 160
		mov bar_c1 , 190
		mov bar_c2 , 140
		mov ball_direction , 2
		mov bar_len , 55

		mov min, 0
		mov sec, 0

		mov level_bricks, 0

		mov brick_x1 , 5
		mov brick_y1 , 30
		mov Brick1_times_hit , 0
		mov Brick1_hit_required , 2

		mov brick_x2 , 105
		mov brick_y2 , 30
		mov Brick2_times_hit , 0
		mov Brick2_hit_required , 2

		mov brick_x3 , 155
		mov brick_y3 , 30
		mov Brick3_times_hit , 0
		mov Brick3_hit_required , 2

		mov brick_x4 , 255
		mov brick_y4 , 30
		mov Brick4_times_hit , 0
		mov Brick4_hit_required , 2

		mov brick_x5 , 130
		mov brick_y5 , 110
		mov Brick5_times_hit , 0
		mov Brick5_hit_required , 2

		mov brick_x6 , 55
		mov brick_y6 , 60
		mov Brick6_times_hit , 0
		mov Brick6_hit_required , 2

		mov brick_x7 , 105
		mov brick_y7 , 60
		mov Brick7_times_hit , 0
		mov Brick7_hit_required , 2

		mov brick_x8 , 155
		mov brick_y8 , 60
		mov Brick8_times_hit , 0
		mov Brick8_hit_required , 2

		mov brick_x9 , 205
		mov brick_y9 , 60
		mov Brick9_times_hit , 0
		mov Brick9_hit_required , 2

		mov brick_x10 , 35
		mov brick_y10 , 90
		mov Brick10_times_hit , 0
		mov Brick10_hit_required ,2

		mov brick_x11 , 95
		mov brick_y11 , 90
		mov Brick11_times_hit , 0
		mov Brick11_hit_required , 2

		mov brick_x12 , 165
		mov brick_y12 , 90
		mov Brick12_times_hit , 0
		mov Brick12_hit_required , 2

		mov brick_x16 , 225
		mov brick_y16 , 90
		mov Brick16_times_hit , 0
		mov Brick16_hit_required , 2


	endm

	level3_reset macro

		mov ball_speed , 95 ; change ball speed

		mov ball_y , 186
		mov ball_x , 160
		mov bar_c1 , 190
		mov bar_c2 , 140
		mov ball_direction , 2
		;mov bar_len , 55

		mov min, 0
		mov sec, 0

		mov level_bricks, 0

		mov brick_x1 , 5
		mov brick_y1 , 30
		mov Brick1_times_hit , 0
		mov Brick1_hit_required , 3

		mov brick_x2 , 105
		mov brick_y2 , 30
		mov Brick2_times_hit , 0
		mov Brick2_hit_required , 3

		mov brick_x3 , 155
		mov brick_y3 , 30
		mov Brick3_times_hit , 0
		mov Brick3_hit_required , 3

		mov brick_x4 , 275
		mov brick_y4 , 30
		mov Brick4_times_hit , 0
		mov Brick4_hit_required , 3

		mov brick_x5 , 130
		mov brick_y5 , 120
		mov Brick5_times_hit , 0
		mov Brick5_hit_required , 3

		mov brick_x6 , 20
		mov brick_y6 , 60
		mov Brick6_times_hit , 0
		mov Brick6_hit_required , 3

		mov brick_x7 , 105
		mov brick_y7 , 60
		mov Brick7_times_hit , 0
		mov Brick7_hit_required , 3

		mov brick_x8 , 155
		mov brick_y8 , 60
		mov Brick8_times_hit , 0
		mov Brick8_hit_required , 3

		mov brick_x9 , 260
		mov brick_y9 , 60
		mov Brick9_times_hit , 0
		mov Brick9_hit_required , 3

		mov brick_x10 , 40
		mov brick_y10 , 90
		mov Brick10_times_hit , 1
		mov Brick10_hit_required ,0

		mov brick_x11 , 105
		mov brick_y11 , 90
		mov Brick11_times_hit , 0
		mov Brick11_hit_required , 3

		mov brick_x12 , 155
		mov brick_y12 , 90
		mov Brick12_times_hit , 0
		mov Brick12_hit_required , 3

		mov brick_x16 , 225
		mov brick_y16 , 90
		mov Brick16_times_hit , 1
		mov Brick16_hit_required , 0


	endm

    background1 proc 

        mov ah, 06h                  ; background
        mov al, 0
        mov cx, 0                    ; x - axis
        mov dx, 100000               ; y - axis
        mov bh, 00h                  ; color
        int 10h

        ;delay 150

        ;drawRectangle_fill 0,0, 5, 200, 00h

        ;delay 150

        ;drawRectangle_fill 0, 315, 5, 200, 00h

        delay 150

        ; drawing bricks now

        drawRectangle_fill brick_y1, brick_x1, brick_width, brick_len, 05h

        drawRectangle_fill brick_y2, brick_x2, brick_width, brick_len, 02h

        drawRectangle_fill brick_y3, brick_x3, brick_width, brick_len, 03h

        drawRectangle_fill brick_y4, brick_x4, brick_width, brick_len, 06h

        drawRectangle_fill brick_y5, brick_x5, brick_width, brick_len, 03h
        
        drawRectangle_fill brick_y6, brick_x6, brick_width, brick_len, 06h
        
        drawRectangle_fill brick_y7, brick_x7, brick_width, brick_len, 06h
        
        drawRectangle_fill brick_y8, brick_x8, brick_width, brick_len, 02h
        
        drawRectangle_fill brick_y9, brick_x9, brick_width, brick_len, 03h
                
        drawRectangle_fill brick_y11, brick_x11, brick_width, brick_len, 03h
        
        drawRectangle_fill brick_y12, brick_x12, brick_width, brick_len, 02h

        ;drawRectangle_fill brick_y13, brick_x13, brick_width, brick_len, 05h

		;drawRectangle_fill brick_y14, brick_x14, brick_width, brick_len, 02h

		;drawRectangle_fill brick_y15, brick_x15, brick_width, brick_len, 06h

		.if level_counter == 3 

			drawRectangle_fill brick_y10, brick_x10, brick_width, brick_len, 08h

			drawRectangle_fill brick_y16, brick_x16, brick_width, brick_len, 08h

		.else 

			drawRectangle_fill brick_y10, brick_x10, brick_width, brick_len, 05h

			drawRectangle_fill brick_y16, brick_x16, brick_width, brick_len, 03h
		.endif
		

		drawRectangle_Fill 0,0, 55, 19, 00h

		mov ah,02h  
		mov dh,1    ;row 
		mov dl,1     ;column
		int 10h

        lea dx, score_msg ;string print
        mov ah, 09h
        int 21h

		print_score

		draw_lives

		mov ah,02h  
		mov dh,1    ;row 
		mov dl,18     ;column
		int 10h

		output min

		mov ah, 02h ;space print
		mov dl, ":"
		int 21h		

		output sec

		drawRectangle_notFill 20, 0, 319, 179, 07h
        drawRectangle_notFill 0,0, 319, 19, 01h


    ret
    background1 endp

	blackscreen macro 

		call clear

		drawRectangle_fill 0, 0, 320, 200, 00h


	endm

	main_menu_show macro 

		call clear
			menu_page 04h, 0Ch, 0Ch, 0Ch
			jmp menu_sp
				
		main_menu_2:

			call clear

			.if menu_op == 1
				menu_page_options 04h, 0Ch, 0Ch, 0Ch

			.elseif menu_op == 2
				menu_page_options 0Ch, 04h, 0Ch, 0Ch

			.elseif menu_op == 3
				menu_page_options 0Ch, 0Ch, 04h, 0Ch
			
			.elseif menu_op == 4
				menu_page_options 0Ch, 0Ch, 0Ch, 04h

			.endif

			.if pause_k == 1

				mov ah,02h  
				mov dh,22    ;row 
				mov dl,12     ;column
				int 10h

				lea dx, msg5 ;string print
				mov bl , 0ch
				mov ah, 09h
				int 21h

			.endif

		menu_sp:

			call clear

			mov ah,0
       		int 16h

        	.if al == 27
				jmp exit

			.elseif ah == 48h

				.if menu_op > 0
					dec menu_op
					beep 2000
				.endif

			.elseif ah == 50h
				.if menu_op < 4
					inc menu_op
					beep 2000
				.endif
			
			.elseif al == 13
				
				beep 3000
				.if menu_op == 1
					level1_reset
					jmp level_start

				.elseif menu_op == 2
					jmp instruct

				.elseif menu_op == 3
					menu_page_options 0Bh, 0Bh, 03h, 0Bh	; to be changed
				
				.elseif menu_op == 4
					jmp exit

				.endif
				
			
			.elseif al == 112
				mov pause_k, 0
				jmp tttt1

			.endif

			jmp main_menu_2

	endm

	loose_screen macro
	local n1, n2
		mov ax, 0
        mov al, 13h
        int 10h

		drawRectangle_notFill 10, 10, 298, 180, 07h
        drawRectangle_notFill 5, 5, 308, 190, 08h

		call clear

		mov ah,02h  
		mov dh,9      ;row 
		mov dl,14     ;column
		int 10h

		.if lives != 0 

			mov ah,02h  
			mov dh,9      ;row 
			mov dl,9     ;column
			int 10h

			lea dx, msg6 ;string print
			mov ah, 09h
			int 21h

		.else 

			mov ah,02h  
			mov dh,9      ;row 
			mov dl,14     ;column
			int 10h
		
			lea dx, msg3 ;string print
			mov ah, 09h
			int 21h

		.endif

		delay 300

		mov ah,02h  
		mov dh,12      ;row 
		mov dl,10     ;column
		int 10h

		
		lea dx, msg4 ;string print
		mov ah, 09h
		int 21h
		

		cmp score3, 0
		jz n1

		mov ah, 02h ; num print
		mov dl, score3
		add dl, "0"
		int 21h
			
		n1:

		cmp score2, 0
		jz n2
		call clear
		mov ah, 02h ; num print
		mov dl, score2
		add dl, "0"
		int 21h

		n2:
		call clear
		mov ah, 02h ; num print
		mov dl, score1
		add dl, "0"
		int 21h




	endm

    mov_ball macro c1, c2
        local dir1, dir2, dir3, dir4, sk1, sk2, sk3, sk4, sk5, sk6, sk7, sk8, exit_ball

        ;drawSquare c1, c2, 3, 00h
		draw_ball c1, c2, 00h

        dir1:
        call clear

        cmp ball_direction,1
        jne dir2

        dec c1 
        inc c2

        ; direction 1 check

        cmp c1, 21
        jne sk1

		beep 1200
        mov ball_direction, 3
        jmp dir3

        sk1:

        cmp c2, 316
        jne sk2

		beep 1200
        mov ball_direction, 2
        jmp dir2

        sk2:

        jmp exit_ball   
        
        dir2:

        cmp ball_direction,2
        jne dir3

        dec c1 
        dec c2

        ;direction 2 check

        cmp c1, 21
        jne sk3

		beep 1200
        mov ball_direction, 4
        jmp dir4

        sk3:

        cmp c2, 1
        jne sk4

		beep 1200
        mov ball_direction, 1
        jmp dir1

        sk4:
        
        jmp exit_ball

        dir3:

        cmp ball_direction,3
        jne dir4

        inc c1 
        inc c2
        
        ;direction 3 check

        call clear
        mov ax, bar_c2
        .if c2 > ax

            add ax, bar_len
            .if c2 < ax
                .if c1 == 186
					beep 1200
                    mov ball_direction, 1
                    jmp dir1

                .endif

            .endif

        .endif    

        call clear
        cmp c1, 195
        jne sk5

		dec lives

		beep 9000

		.if lives == 0
        	jmp game_lose
		.else
			mov ball_y , 186
			mov ball_x , 160
			mov bar_c1 , 190
			mov bar_c2 , 135
			mov ball_direction , 2
			jmp level_start
		.endif

        ;mov ball_direction, 1
        ;jmp dir1

        sk5:

        cmp c2, 316
        jne sk6

		beep 1200
        mov ball_direction, 4
        jmp dir4

        sk6:

        jmp exit_ball

        dir4:

        ;This is direction 4

        inc c1
        dec c2

        ;direction 4 check

        call clear
        mov ax, bar_c2
        .if c2 > ax

            add ax, bar_len
            .if c2 < ax
                .if c1 == 186
					beep 1200
                    mov ball_direction, 2
                    jmp dir2

                .endif

            .endif

        .endif   

        call clear
        cmp c1, 195
        jne sk7

        dec lives

		beep 9000

		.if lives == 0
        	jmp game_lose
		.else
			mov ball_y , 186
			mov ball_x , 160
			mov bar_c1 , 190
			mov bar_c2 , 135
			mov ball_direction , 2
			jmp level_start
		.endif

        ;mov ball_direction, 2
        ;jmp dir2

        sk7:

        cmp c2, 1
        jne sk8
		beep 1200
        mov ball_direction, 3
        jmp dir3

        sk8:

        call clear

        exit_ball:

        ;drawSquare c1, c2, 3, 04h
		draw_ball c1, c2, 04h

        mov ax, c1
        mov bx, c2
        mov ball_y, ax
        mov ball_x, bx

        check_collision brick_x1, brick_y1, Brick1_times_hit, Brick1_hit_required, 05h
        check_collision brick_x2, brick_y2, Brick2_times_hit, Brick2_hit_required, 02h
        check_collision brick_x3, brick_y3, Brick3_times_hit, Brick3_hit_required, 03h
        check_collision brick_x4, brick_y4, Brick4_times_hit, Brick4_hit_required, 06h
        check_collision brick_x5, brick_y5, Brick5_times_hit, Brick5_hit_required, 03h
        check_collision brick_x6, brick_y6, Brick6_times_hit, Brick6_hit_required, 06h
        check_collision brick_x7, brick_y7, Brick7_times_hit, Brick7_hit_required, 06h
        check_collision brick_x8, brick_y8, Brick8_times_hit, Brick8_hit_required, 02h
        check_collision brick_x9, brick_y9, Brick9_times_hit, Brick9_hit_required, 03h
        check_collision brick_x10, brick_y10, Brick10_times_hit, Brick10_hit_required, 05h
        check_collision brick_x11, brick_y11, Brick11_times_hit, Brick11_hit_required, 03h
        check_collision brick_x12, brick_y12, Brick12_times_hit, Brick12_hit_required, 02h
       ; check_collision brick_x13, brick_y13, Brick13_times_hit, Brick13_hit_required, 05h
       ; check_collision brick_x14, brick_y14, Brick14_times_hit, Brick14_hit_required, 02h
       ; check_collision brick_x15, brick_y15, Brick15_times_hit, Brick15_hit_required, 06h
       check_collision brick_x16, brick_y16, Brick16_times_hit, Brick16_hit_required, 03h
        

        ;mov ax, ball_speed
        delay ball_speed

    endm

	draw_ball macro c1, c2, color
			mov ax, c1 
			mov bx, c2 

			mov row, ax 
			mov col, bx

			mov row1 , ax
			mov col1, bx
			inc row1
			dec col1 


			drawRectangle_Fill row, col, 2, 3, color

			drawRectangle_Fill row1, col1, 4, 1, color
			
		endm

    mov_Bar macro c1, c2, c3

        drawRectangle_fill c1, c3, bar_len, 4, 00h

        drawRectangle_fill c1, c2, bar_len, 4, 0Bh

    endm
	
start:
	
	main proc

        mov ax, @DATA
        mov ds, ax
        mov ax, 0

        mov ax, 0
        mov al, 13h
        int 10h

		;level2_reset
		;mov level_counter, 2
        ;jmp tttt1 ;;;; remove later

        name_input
		;filehandling
		beep 3000
		instruct:

        mov ah,00h
        mov al,13h
        int 10h

        title_page
		print_Enter
        repeat1:
		mov ah,01h
		int 21h
		cmp al,13
		je main_menu
		jmp repeat1
		
        ;;;;;;;;;;;;;;;;;;;;;;;;  MAIN MENU  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        main_menu:
			beep 3000
			main_menu_show

        ;;;;;;;;;;;;;;;;;;;;;;;;;; end ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        level_start:

		time_start

        mov ah,00h
		mov al,13h
		int 10h

		;;;;;;;;;;;;;;;;;;;;;;;;;; LEVEL 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
		introLevel
		
		delay 1050
		beep 1500
		beep 1500
		tttt1:
        call background1         ; background

        drawRectangle_fill bar_c1, bar_c2, bar_len, 4, 0Bh ; bar drawing

        ;drawSquare ball_y, ball_x, 3, 04h
		draw_ball ball_y, ball_x, 04h
		
        key:

        mov ah,0
        int 16h

        cmp al, 27   ; enter key
        je exit

        cmp al,32   ;space bar key
        jne key

        call background1
		beep 2000
		beep 2000

        level_main

	;;;;;;;;;;;;;;;;;;;;;;;;;; end ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	jmp exit

	game_lose:

		loose_screen

    exit:
        
        
	main endp
	
	mov ah, 4ch
	int 21h
	end