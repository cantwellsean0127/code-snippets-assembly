extern print_integer

section .data
    
    ;; The integer that is to be printed
    integer_to_print dq -12

section .text

    global main

main:
    
    ;; For correct debugging when using SASM (may not work for other debuggers)
    mov rbp, rsp

    ;; To call the print_integer function, move the integer to print into the rdi register
    mov rdi, qword [integer_to_print]
    call print_integer

exit:

    ;; Function epilogue
    mov rsp, rbp
    pop rbp
    
    ;; Exit system call
    mov rax, 60
    xor rdi, rdi
    syscall