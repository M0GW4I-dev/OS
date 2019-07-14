.code16

enable_a20:
    cli
    mov $0xad, %al
    out %al, $0x64
    call a20wait

    mov $0xd0, %al
    out %al, $0x64
    call a20wait2
    in $0x60, %al
    push %eax
    call a20wait
    mov $0xd1, %al
    out %al, $0x64
    call a20wait
    pop %eax
    or $0x02, %al
    out %al, $0x60
    call a20wait
    mov $0xae, %al
    out %al, $0x64
    call a20wait
    sti
    ret

a20wait:
    in $0x64, %al
    test $0x02, %al
    jnz a20wait
    ret

a20wait2:
    in $0x64, %al
    test $0x01, %al
    jz a20wait2
    ret
