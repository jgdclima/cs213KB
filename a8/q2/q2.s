.pos 0x0
                 ld   $0x1028, r5           # initialize the stack pointer
                 ld   $0xfffffff4, r0       # r0 = -12
                 add  r0, r5                # stack pointer -= 12 (allocate caller part of frame)
                 ld   $0x200, r0            # r0 = a
                 ld   0x0(r0), r0           # r0 = a[0]
                 st   r0, 0x0(r5)           # store a[0] to the stack as arg0
                 ld   $0x204, r0            # r0 = &a[1]
                 ld   0x0(r0), r0           # r0 = a[1]
                 st   r0, 0x4(r5)           # store a[1] to the stack as arg1
                 ld   $0x208, r0            # r0 = &a[2]
                 ld   0x0(r0), r0           # r0 = a[2]
                 st   r0, 0x8(r5)           # store a[2] to the stack as arg2
                 gpc  $6, r6                # r6 = return address
                 j    0x300                 # goto q2()
                 ld   $0x20c, r1            # r1 = 0x20c = &s
                 st   r0, 0x0(r1)           # s = r0 = return value of q2()
                 halt                     
.pos 0x200
                 .long 0x0000000f         # a[0]
                 .long 0x00000000         # a[1]
                 .long 0x00000000         # a[2]
                 .long 0x00000000         # s
.pos 0x300
                 ld   0x0(r5), r0           # r0 = arg0
                 ld   0x4(r5), r1           # r1 = arg1
                 ld   0x8(r5), r2           # r2 = arg2
                 ld   $0xfffffff6, r3       # r3 = -10
                 add  r3, r0                # r0 = arg0 - 10
                 mov  r0, r3                # r3 = arg0 - 10
                 not  r3                    # r3 = !(arg0-10)
                 inc  r3                    # r3 = -(arg0-10) = 10-arg0
                 bgt  r3, L6                # if arg0 < 10 goto L6
                 mov  r0, r3                # r3 = arg0 - 10
                 ld   $0xfffffff8, r4       # r4 = -8
                 add  r4, r3                # r3 = arg0 - 18
                 bgt  r3, L6                # if arg0 > 18 goto L6
                 ld   $0x400, r3            # r3 = &jmptable
                 j    *(r3, r0, 4)          # goto jmptable[arg0-10]
.pos 0x330
                 add  r1, r2                # r2 = arg2 + arg1      // CASE 0
                 br   L7                    # goto L7
                 not  r2                    # r2 = !arg2            // CASE 2
                 inc  r2                    # r2 = - arg2
                 add  r1, r2                # r2 = arg1 - arg2
                 br   L7                    # goto L7
                 not  r2                    # r2 = !arg2            // CASE 4
                 inc  r2                    # r2 = -arg2
                 add  r1, r2                # r2 = arg1 - arg2
                 bgt  r2, L0                # if arg1 > arg2 goto L0
                 ld   $0x0, r2              # else r2 = 0
                 br   L1                    # goto L1
L0:              ld   $0x1, r2              # r2 = 1
L1:              br   L7                    # goto L7
                 not  r1                    # r1 = !arg1            // CASE 6
                 inc  r1                    # r1 = -arg1
                 add  r2, r1                # r1 = arg2 - arg1
                 bgt  r1, L2                # if arg2 > arg1 goto L2
                 ld   $0x0, r2              # else r2 = 0
                 br   L3                    # goto L3
L2:              ld   $0x1, r2              # r2 = 1
L3:              br   L7                    # goto L7
                 not  r2                    # r2 = !arg2            // CASE 8
                 inc  r2                    # r2 = - arg2
                 add  r1, r2                # r2 = arg1 - arg2
                 beq  r2, L4                # if (arg1>arg2) goto L4
                 ld   $0x0, r2              # else r2 = 0
                 br   L5                    # goto L5
L4:              ld   $0x1, r2              # r2 = 1
L5:              br   L7                    # goto L7
L6:              ld   $0x0, r2              # r2 = 0
                 br   L7                    # goto L7
L7:              mov  r2, r0                # r0 (return value) = r2
                 j    0x0(r6)               # return
.pos 0x400
                 .long 0x00000330         # jmptable[0]
                 .long 0x00000384         # jmptable[1] = L6
                 .long 0x00000334         # jmptable[2]
                 .long 0x00000384         # jmptable[3] = L6
                 .long 0x0000033c         # jmptable[4]
                 .long 0x00000384         # jmptable[5] = L6
                 .long 0x00000354         # jmptable[6]
                 .long 0x00000384         # jmptable[7] = L6
                 .long 0x0000036c         # jmptable[8]
.pos 0x1000
                 .long 0x00000000         
                 .long 0x00000000         
                 .long 0x00000000         
                 .long 0x00000000         
                 .long 0x00000000         
                 .long 0x00000000         
                 .long 0x00000000         
                 .long 0x00000000         
                 .long 0x00000000         
                 .long 0x00000000         # stackBottom
