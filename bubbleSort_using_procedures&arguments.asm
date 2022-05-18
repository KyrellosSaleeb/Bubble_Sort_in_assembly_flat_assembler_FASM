;20198065
;kyrellos Saleeb
;B3

 format pe
 entry start
 include 'win32ax.inc'
 section '.code' code readable executable

start:
 call greeting;optionally to write line

 push [number];taking parameter of size
 push arrayNum;taking parameter of address of the first element of array
 call bubblesort;call bubble sort with the arguments
 add esp,8;deallocate stack from parameters

 cinvoke printf,"The array printed without arguments"
 cinvoke printf, emptyLine;printf new empty Line
 call printarr

 cinvoke printf, emptyLine;printf new empty Line
 cinvoke printf, emptyLine;printf new empty Line
 cinvoke printf,"The array printed using arguments"
 cinvoke printf, emptyLine;printf new empty Line
 push [number];taking parameter of size
 push arrayNum;taking parameter of address of the first element of array
 call printarray;call array with the arguments
 add esp,8;deallocate stack from parameters


 ;Important
 ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ;uncomment to test another array  and comment the above lines

; push [size]
; push arrayelements
; call bubblesort
; add esp,8

; push [size]
; push arrayelements
; call printarray
; add esp,8
;--------------------------------------------



;greetings
;--------------------------------------------
greeting:
;--------------------------------------------
	cinvoke printf,"The sorted array as the following is: "
	cinvoke printf, emptyLine;printf new empty Line
	ret
;--------------------------------------------



;bubble sort function
;--------------------------------------------
bubblesort:;start of the bubble sort function
;--------------------------------------------

	push ebp;push the base pointer of the stack
	mov ebp,esp;take copy of the stack pointer into the base pointer

	push ebx;push the ebx register in stack to be used in the function
	push esi;push the esi register in stack to be used in the function
	push edi;push the edi register in stack to be used in the function
	push edx;push the edx register in stack to be used in the function
	mov esi,[ebp+12];size of the array from base pointer position in the stack
	mov edi,[ebp+8];address of the satrt of the array from base pointer position in the stack

	sub esi,1;decrement size by one according to the condition of the loop
	sub esp,16;allocate space in stack for the local variables will be used in the function

	startOuterLoop:
		mov eax, [i];take the value of the counter i into eax register
		cmp eax, esi;compare size to the counter
		jnl endOuterLoop;if it greater than or equal size it ends

		startInnerLoop:
			mov eax, [j];take the value of the counter j into eax register
			add eax, [i];add the value of the counter i to eax register to be equal the condition of the second loop
			cmp eax, esi;compare size to the counter
			jnl endInnerLoop;if it greater than or equal size it ends
			mov eax, [j];take the value of the counter j into eax register
			mov ebx, [j];take the value of the counter j into ebx register
			add ebx,1;increment the ebx register by one
			mov eax, [edi+eax*4];take the value of the position of the counter j into ebx register

			call compareCheckFunc;call the function to return the value 1 or 0

			cmp [rCheck],1;if returned 1 continue
			jl ifZero;else

			push eax;push the value of eax to save it
			push edx;push the value of eax to save it
			mov [tmp],eax;take the value of eax register into tmp variable
			mov eax, [edi+ebx*4];take the j+1 into j
			pop dword [edi+ebx*4];remove the j+1 from stack
			mov ecx, [j];take the position of j into ecx register
			mov edx,[tmp];take the tmp into edx register
			mov [edi+ebx*4],edx;take value of edx into j+1
			mov [edi+ecx*4],eax;take value of eax into array in the specific position
			pop edx;remove edx register from the stack

		       ifZero:
				add [j],1;j=j+1
				jmp startInnerLoop;jump to next iteration

		       endInnerLoop:
				mov [j], 0;make j = 0 for next epoch
				add [i],1;make i = i+1 for next epoch
				jmp startOuterLoop;jump to next iteration

		       endOuterLoop:
				add esi,1;make size as it is before decrement
				mov ecx,esi;make ecx register as it is before loop started
				mov eax , 0;make eax = 0

				add esp,16;deallocate space in stack for the local variables used in the function
				pop edx;remove edx register from stack
				pop edi;remove edi register from stack
				pop esi;remove esi register from stack
				pop ebx;remove ebx register from stack
				pop ebp;remove ebp register from stack
				ret;return to the main

;--------------------------------------------
;Compare Function
;--------------------------------------------
compareCheckFunc:
;--------------------------------------------
cmp eax, [edi+ebx*4];compare current element to the next element
	jng small;if smaller it becomes zero
	mov [rCheck],1;else becomes 1
	ret;return to comparison call
	small:;small check
		mov [rCheck],0; (r) = 0
		ret;return to comparison call




printarr:
mov ebx,[arrayNum]
mov ecx,[number]
mov eax , 0

startloop:
	push ecx;push the element into register ecx
	push eax;push the element into register eax
	cinvoke printf, arrVar , [arrayNum+eax*4];print every element of array
	pop eax;remove element printed from eax
	pop ecx;remove element printed from ecx
	inc eax;increment the ecx by 1
	loop startloop;if ecx = 0 endloop else dec ecx jmp startloop end print the content of array
	cinvoke printf, emptyLine;printf new empty Line
	ret



;--------------------------------------------
;print the array function
;--------------------------------------------
printarray:
;--------------------------------------------
	     push ebp;push the base pointer of the stack
	     mov ebp,esp;take copy of the stack pointer into the base pointer

	     push esi;push the esi register in stack to be used in the function
	     push ebx;push the ebx register in stack to be used in the function
	     push edi;push the edi register in stack to be used in the function

	     mov eax,[ebp+12];the size of the array
	     mov edi, eax
	     mov ebx,[ebp+8];the address of the first element of the array

	     mov esi, 0

	     printloop:
		cmp esi , eax
		jnl stopscreen

		push eax
		mov edx , [ebx+esi*4]
		cinvoke printf,arrVar,edx
		cinvoke printf, emptyLine
		pop eax

		add esi,1

		jmp printloop

	      call stopscreen

	      pop edi
	      pop ebx
	      pop esi
	      pop ebp
	      ret


;stop screen function
;---------------------------------------------------------
stopscreen:;stop screen function to see the console window
;---------------------------------------------------------
	   cinvoke printf, emptyLine;printf new empty Line
	   cinvoke printf, emptyLine;printf new empty Line
	   cinvoke printf,"The array sorted in an ascending order..."
	   cinvoke printf, emptyLine;printf new empty Line
	   cinvoke printf,"The array elements equals to >>> %d ",edi;number of the elements of array
	   cinvoke printf, emptyLine;printf new empty Line
	   cinvoke printf,"you can change 'arrayNum' and 'number' to 'arrayelements' and 'size' in the code or change the array content itself"
	   cinvoke printf, emptyLine;printf new empty Line
	   invoke Sleep,-1;stop screen function to see the console window
	   ret

;--------------------------------------------
section '.data' data readable writeable
;--------------------------------------------
arrVar db '>>>>>>> %d ',0
arrayNum dd 5,8,11,7,10,4,1,9
number dd 8
arrayelements dd 9,3,2,5,4,11,7,10,15,6
size dd 10
i dd 0
j dd 0
rCheck dd ?
vard dd ?
temp dd 0
tmp dd 0
emptyLine db '',10,0;newline string

;--------------------------------------------
section '.idata' import data readable writeable
library msvcrt, 'msvcrt.dll', kernel32, 'kernel32.dll'
import msvcrt, printf, 'printf', getchar,'getchar', scanf,'scanf'
import kernel32,Sleep,'Sleep'