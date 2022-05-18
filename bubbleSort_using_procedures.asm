;Kyrellos_Saleeb_20198065_B3_Bio

;-----------------------------------------------------------------------------------------------------------
;you can change the variable to test if the bubble sort work correctly or not with different sizes of array
format pe; console
entry start
include 'win32ax.inc'
;-----------------------------------------------------------------------------------------------------------

;------------------------------------------
 section '.code' code readable executable
;------------------------------------------

;start program
;------------------------------------------
start:
;------------------------------------------
	stdcall greeting;optionally to write line                                                                    ;call greeting to test

	mov [c],0
	mov ecx,0
	mov ecx,[number]


	arrg:
		cmp ecx,[c]
		je continue
		mov eax, [c];value of i stored into edx register
		mov eax,[arrayNum+eax*4]
		push eax
		add [c],1
		loop arrg

	continue:
	;push ecx
	push ebp
	mov ebp,esp
	sub esp,40



	stdcall bubblesort;calling bubble sort function                                    ;call bubble sort
       ;pop eax
	;push ebp
       ; mov ebp, esp;ebp points to next step of stack

	call printarray;calling print array function                                    ;call print the array


;greetings
;--------------------------------------------
greeting:
;--------------------------------------------
	cinvoke printf,"The sorted array as the following is: "
	cinvoke printf, emptyLine;printf new empty Line
	ret



;bubble sort function
;--------------------------------------------
bubblesort:;start of the bubble sort function
;--------------------------------------------

	sub [number],1;decrease size by 1

	outerloop:;outer loop in function
		;push ebp
		;mov ebp,esp
		;sub esp,40
		;push eax

		mov eax, [i];value of i stored into edx register
		cmp eax, [number];value of n compared to edx register
		jnl endouterloop;jump if the n becomes greater than edx

		innerloop:;inner loop in comparison
			mov eax, [j];value of j stored into edx register
			add eax, [i];value of i added to edx register
			cmp eax, [number];value of n compared to edx register

			jnl endinnerloop;jump if the n becomes greater than edx
			mov eax, [j];value of j stored into edx register
			mov ebx, [j];value of j stored into ebx register
			add ebx,1;increment ebx register by 1
			mov eax, [arrayNum+eax*4];move element into the edx register

			call comparison;calling comparison function                             ;call compare
			cmp [r],1;check the return value is 1 or not
			jne ifZero;end if not equal
			    push eax;push edx value in the stack
			    mov eax, [arrayNum+ebx*4];take the element of array into edx
			    pop [arrayNum+ebx*4];pop value from stack
			    mov ecx, [j];take the value of j to ecx
			    mov [arrayNum+ecx*4], eax;store value of the edx in the right position after checking
			ifZero:;if r == 0
				add [j],1;add 1 to the value of j
				jmp innerloop;jump to next iteration
			endinnerloop:;end the inner loop
				mov [j], 0;j becomes equal to 0
				add [i],1;i becomes equal to 1
				jmp outerloop;next iteration in the outer loop



				endouterloop:;end the outer loop
						  add [number],1;add 1 to the size
						  mov ecx,[number];take the new value into ecx
						  mov eax , 0;eax becomes 0

						  ret;return to the buuble sort call


;compare function
;--------------------------------------------
comparison:;comparsion function
;--------------------------------------------

	cmp eax, [arrayNum+ebx*4];compare current element to the next element
	jng small;if smaller it becomes zero
	mov [r],1;else becomes 1
	ret;return to comparison call
	small:;small check
		mov [r],0; (r) = 0
		ret;return to comparison call



;print function
;--------------------------------------------
printarray:
;--------------------------------------------

	printloop:
		push ecx;push the element into register ecx
		push edx;push the element into register edx
		cinvoke printf, arrVar , [arrayNum+edx*4];print every element of array
		cinvoke printf, emptyLine;printf new empty Line after accessing the array
		pop edx;remove element printed from edx
		pop ecx;remove element printed from ecx
		add edx,1;icrement the ecx by 1
		loop printloop;if ecx = 0 endloop else dec ecx jmp startloop end print the content of array
		cinvoke printf, emptyLine;printf new empty Line after accessing the array

		jmp stopscreen;stop screen function to see the console window
		ret;return to the start function

;stop screen function
;---------------------------------------------------------
stopscreen:;stop screen function to see the console window
;---------------------------------------------------------
	   cinvoke printf,"The array sorted in an ascending order..."
	   cinvoke printf, emptyLine;printf new empty Line
	   cinvoke printf,"The array elements equals to: %d ",[number];number of the elements of array
	   cinvoke printf, emptyLine;printf new empty Line
	   cinvoke printf,"you can change 'arrayNum' and 'number' to 'arrayelements' and 'size' in the code or change the array content itself"
	   cinvoke printf, emptyLine;printf new empty Line
	   invoke Sleep,-1;stop screen function to see the console window


;variables
;--------------------------------------
section '.data' data readable writeable
;--------------------------------------

 arrVar db '%d  ',0
 emptyLine db '',10,0;newline string
 arrayNum dd 30,20,10,33,60,5,2,86,64,50;example 1
 number dd 10;;you can change 'arrayNum' and 'number' to 'arrayelements' and 'size' in the code above or change the array content itself
 arrayelements dd 5,8,7,4,1,9;example 2
 size dd 6
 i dd 0
 j dd 0
 r dd ?
 c dd 0

;import data
;--------------------------------------------------------
section '.idata' import data readable writeable
library msvcrt, 'msvcrt.dll', kernel32, 'kernel32.dll'
import msvcrt, printf, 'printf'
import kernel32,Sleep,'Sleep'