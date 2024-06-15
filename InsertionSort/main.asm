title InsertionSort
include Irvine32.inc

.data
array dword 1h,8h,13h,21h,5h,17h,35h,28h  ; Define an array 'array' with 8 doublewords (dwords)
                                         ; Initial values: 1, 8, 13, 21, 5, 17, 35, 28

newLine byte 0ah, 0dh, 0                 ; Define newline characters: LF (Line Feed), CR (Carriage Return), and null terminator

unsortedMessage byte "unsorted array : ", 0ah, 0dh, 0  ; Define string "unsorted array : " followed by newline and null terminator

sortedMessage byte "sorted array : ", 0ah, 0dh, 0      ; Define string "sorted array : " followed by newline and null terminator

delimiter byte ", ", 0                   ; Define delimiter string ", " followed by null terminator

.code

swap PROC
    push ebp          ; Save the current base pointer
    mov ebp, esp      ; Set up a new base pointer

    pushad            ; Push all general-purpose registers (eax, ebx, ecx, edx, esi, edi) onto the stack

    mov edi, [ebp+8]  ; edi <- address of the first parameter (pointer to a)
    mov eax, [edi]    ; eax <- value at address edi (value of *a)

    mov esi, [ebp+12] ; esi <- address of the second parameter (pointer to b)
    mov ebx, [esi]    ; ebx <- value at address esi (value of *b)

    mov [esi], eax    ; *b <- value of *a (swap values)
    mov [edi], ebx    ; *a <- value of *b

    popad             ; Restore all general-purpose registers from the stack

    mov esp, ebp      ; Restore the stack pointer
    pop ebp           ; Restore the previous base pointer
    ret 8             ; Return, cleaning up 8 bytes (parameters) from the stack
swap ENDP            ; End of procedure


printArray PROC
    push ebp        ; Save the current base pointer
    mov ebp, esp    ; Set up a new base pointer
    pushad          ; Push all general-purpose registers onto the stack

    mov ebx, 0      ; Initialize loop counter ebx to 0
    mov edi, [ebp + 8]  ; edi <- array base address
    mov edx, [ebp + 12] ; edx <- size of array
    dec edx         ; edx <- size - 1
    jmp COND        ; Jump to condition check

    BODY:
        mov eax, [edi + ebx * 4]  ; eax <- array[i]
        call WriteInt   ; Print array element

        cmp ebx, edx   ; Check if it is the last element
        je STEP        ; Jump to step if last element

        push edx       ; Save edx
        mov edx, OFFSET delimiter  ; Load delimiter address into edx
        call WriteString   ; Print delimiter
        pop edx        ; Restore edx

    STEP:
        inc ebx        ; Increment loop counter
    COND:
        cmp ebx, [ebp + 12]  ; Compare loop counter with array size
        jl BODY        ; Jump to body if ebx < size

    call Crlf          ; Print newline
    mov edx, offset newLine  ; Load newline address into edx
    call WriteString   ; Print newline

    popad             ; Restore all general-purpose registers
    mov esp, ebp      ; Restore the stack pointer
    pop ebp           ; Restore the previous base pointer
    ret               ; Return
printArray ENDP       ; End of procedure


insertionSort proc
    push ebp        ; Save the current base pointer
    mov ebp, esp    ; Set up a new base pointer
    sub esp, 4      ; Reserve space on the stack for local variables
    pushad          ; Push all general-purpose registers onto the stack

    mov esi, [ebp+8] ; esi <- array base address
    mov edx, [ebp+12] ; edx <- size of array

    mov ebx, dword ptr 1h ; ebx <- 1 (start of loop counter)
forLoop:
    forCond:
        cmp ebx, edx   ; Compare loop counter with array size
        jge forExit    ; Jump to exit if ebx >= edx

    mov ecx, [esi + ebx * 4]  ; ecx <- array[i]
    push ebx         ; Save ebx (i)

    dec ebx          ; ebx <- i - 1
    mov edi, [esi + ebx * 4]  ; edi <- array[j]

whileCond:
        cmp ebx, dword ptr 0h  ; Compare ebx with 0
        jl whileEnd     ; Jump to whileEnd if ebx < 0
        cmp edi, ecx    ; Compare array[j] with key
        jle whileEnd    ; Jump to whileEnd if array[j] <= key

        inc ebx         ; ebx <- j + 1
        lea eax,[esi + ebx * 4] ; eax <- &array[j+1]
        dec ebx         ; ebx <- j

        mov edi, [esi + ebx * 4] ; edi <- array[j]
        mov [eax], edi  ; array[j+1] = array[j]

        dec ebx         ; ebx <- j - 1
        mov edi, [esi + ebx * 4] ; edi <- array[j-1]

        jmp whileCond   ; Jump to whileCond

whileEnd:
        inc ebx         ; ebx <- j + 1
        lea eax, [esi + ebx * 4] ; eax <- &array[j+1]
        mov [eax], ecx  ; array[j+1] = key

        pop ebx         ; Restore ebx (i)

forStep:
    inc ebx          ; Increment loop counter (i)
    jmp forLoop      ; Jump to forLoop

forExit:
    popad            ; Restore all general-purpose registers
    mov esp, ebp     ; Restore the stack pointer
    pop ebp          ; Restore the previous base pointer
    ret 8            ; Return, cleaning up 8 bytes (parameters) from the stack
insertionSort endp   ; End of procedure


main proc
    mov edx, offset unsortedMessage  ; Load address of unsortedMessage into edx
    call WriteString   ; Call WriteString to print unsortedMessage

    push LengthOf array  ; Push size of array as parameter
    push OFFSET array    ; Push address of array as parameter
    call printArray      ; Call printArray to print the unsorted array

    push LengthOf array  ; Push size of array as parameter
    push OFFSET array    ; Push address of array as parameter
    call insertionSort   ; Call insertionSort to sort the array

    mov edx, offset sortedMessage  ; Load address of sortedMessage into edx
    call WriteString   ; Call WriteString to print sortedMessage

    push LengthOf array  ; Push size of array as parameter
    push OFFSET array    ; Push address of array as parameter
    call printArray      ; Call printArray to print the sorted array

    ; Exit the program
exit
main endp          ; End of main procedure
end main             ; End of program
