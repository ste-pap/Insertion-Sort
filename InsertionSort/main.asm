title InsertionSort
include Irvine32.inc

.data
array dword 1h,8h,13h,21h,5h,17h,35h,28h ; array to sort

newLine byte 0ah, 0dh, 0

unsortedMessage byte "unsorted array : ", 0ah, 0dh, 0 ; sorted array : \n
sortedMessage byte "sorted array : ", 0ah, 0dh, 0 ; sorted array : \n

delimiter byte ", ", 0

.code

swap PROC
push ebp
mov ebp,esp
pushad

mov edi ,[ebp+8]
mov eax , [edi]  ; eax <- *a

mov esi ,[ebp+12]
mov ebx , [esi]  ; ebx <- *b

mov [esi],eax    ; *b <- *a
mov [edi],ebx    ; *a <- *b

popad
mov esp,ebp
pop ebp
ret 8
swap ENDP

printArray Proc
push ebp
mov ebp, esp
pushad

;void printArray(int arr[], int size)
;{
;    int i;
;    for (i = 0; i < size; i++)

	 ;initialization
	 mov ebx,0 ; i = 0 loop counter
	 mov edi, [ebp + 8] ; array base address
	 mov edx, [ebp +12]
	 dec edx	; edx <- size - 1
	 jmp COND
	 ;body
	 BODY:
	;cout << " " << arr[i];
	    mov eax, [edi + ebx * 4] ; eax <- array[i] 
		call WriteHex 		
		; check if it is the last element		
		cmp ebx, edx ; i == size-1
		je STEP
		push edx
		mov edx, OFFSET delimiter
		call WriteString
		pop edx
	 ;step
	 STEP:
		inc ebx
	 ;condition		
	 COND:
	    cmp ebx, [ebp + 12] ; i < size
		jl BODY
		call Crlf
	mov edx, offset newLine
	call WriteString
popad
mov esp, ebp
pop ebp
ret
printArray Endp

insertionSort proc
push ebp
mov ebp,esp
sub esp,4
pushad

;void insertionSort(int arr[], int n)
;{
	mov esi, [ebp+8] ; array base address
	mov edx, [ebp+12] ; length of array

;    int i, key, j;
;    for (i = 1; i < n; i++) {
	mov ebx, dword ptr 1h ; i <- 0
	forLoop:
		forCond:
			cmp ebx,edx ; i < n
			jge forExit

	;        key = arr[i];
		mov ecx, [esi + ebx * 4] ; key <- arr[i]
		push ebx ; save i

		dec ebx  ;        j = i - 1;
		mov edi, [esi + ebx * 4] ; arr[j]
		
;        while (j >= 0 && arr[j] > key) {
		whileCond:
			cmp ebx, dword ptr 0h ;	j >= 0
			jl whileEnd
			cmp	edi, ecx ; arr[j] > key
			jle whileEnd
		
;            &arr[j + 1]
			inc ebx
			lea eax,[esi + ebx * 4]
			dec ebx

;			 arr[j]
			mov edi, [esi + ebx * 4]
;			 arr[j+1] = arr[j]
			mov [eax],edi

			dec ebx ; j = j - 1;
			mov edi, [esi + ebx * 4]

			jmp whileCond
;        }

		whileEnd:      
			
			;arr[j + 1] = key
			inc ebx
			lea eax, [esi + ebx * 4]
			mov [eax],ecx

			pop ebx ; restore i

	forStep:
		inc ebx ; i++
		jmp forLoop




;}
forExit:
popad
mov esp,ebp
pop ebp
ret 8
insertionSort endp

main proc

;    printArray(array[], sizeOfArray);
	mov edx, offset unsortedMessage
	call WriteString

	 push LengthOf array
	 push OFFSET array
	 call printArray

;    insertionSort(array[], sizeOfArray);
	 push LengthOf array
	 push OFFSET array
	 call insertionSort
	 
;    printf("Sorted array: \n");
	 mov edx, offset sortedMessage
	call WriteString

;    printArray(array[], sizeOfArray);
	 push LengthOf array
	 push OFFSET array
	 call printArray


exit
main endp
end main