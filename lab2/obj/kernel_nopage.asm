
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 70 11 40 	lgdtl  0x40117018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 02 00 00 00       	call   10002a <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>

0010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002a:	55                   	push   %ebp
  10002b:	89 e5                	mov    %esp,%ebp
  10002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100030:	ba 68 89 11 00       	mov    $0x118968,%edx
  100035:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100049:	00 
  10004a:	c7 04 24 36 7a 11 00 	movl   $0x117a36,(%esp)
  100051:	e8 98 5d 00 00       	call   105dee <memset>

    cons_init();                // init the console
  100056:	e8 71 15 00 00       	call   1015cc <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10005b:	c7 45 f4 80 5f 10 00 	movl   $0x105f80,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100065:	89 44 24 04          	mov    %eax,0x4(%esp)
  100069:	c7 04 24 9c 5f 10 00 	movl   $0x105f9c,(%esp)
  100070:	e8 c7 02 00 00       	call   10033c <cprintf>

    print_kerninfo();
  100075:	e8 f6 07 00 00       	call   100870 <print_kerninfo>

    grade_backtrace();
  10007a:	e8 86 00 00 00       	call   100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007f:	e8 77 42 00 00       	call   1042fb <pmm_init>

    pic_init();                 // init interrupt controller
  100084:	e8 ac 16 00 00       	call   101735 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100089:	e8 24 18 00 00       	call   1018b2 <idt_init>

    clock_init();               // init clock interrupt
  10008e:	e8 ef 0c 00 00       	call   100d82 <clock_init>
    intr_enable();              // enable irq interrupt
  100093:	e8 0b 16 00 00       	call   1016a3 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  100098:	eb fe                	jmp    100098 <kern_init+0x6e>

0010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10009a:	55                   	push   %ebp
  10009b:	89 e5                	mov    %esp,%ebp
  10009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000a7:	00 
  1000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000af:	00 
  1000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000b7:	e8 f8 0b 00 00       	call   100cb4 <mon_backtrace>
}
  1000bc:	c9                   	leave  
  1000bd:	c3                   	ret    

001000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000be:	55                   	push   %ebp
  1000bf:	89 e5                	mov    %esp,%ebp
  1000c1:	53                   	push   %ebx
  1000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000cb:	8d 55 08             	lea    0x8(%ebp),%edx
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000dd:	89 04 24             	mov    %eax,(%esp)
  1000e0:	e8 b5 ff ff ff       	call   10009a <grade_backtrace2>
}
  1000e5:	83 c4 14             	add    $0x14,%esp
  1000e8:	5b                   	pop    %ebx
  1000e9:	5d                   	pop    %ebp
  1000ea:	c3                   	ret    

001000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000eb:	55                   	push   %ebp
  1000ec:	89 e5                	mov    %esp,%ebp
  1000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1000fb:	89 04 24             	mov    %eax,(%esp)
  1000fe:	e8 bb ff ff ff       	call   1000be <grade_backtrace1>
}
  100103:	c9                   	leave  
  100104:	c3                   	ret    

00100105 <grade_backtrace>:

void
grade_backtrace(void) {
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10010b:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100117:	ff 
  100118:	89 44 24 04          	mov    %eax,0x4(%esp)
  10011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100123:	e8 c3 ff ff ff       	call   1000eb <grade_backtrace0>
}
  100128:	c9                   	leave  
  100129:	c3                   	ret    

0010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10012a:	55                   	push   %ebp
  10012b:	89 e5                	mov    %esp,%ebp
  10012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100140:	0f b7 c0             	movzwl %ax,%eax
  100143:	83 e0 03             	and    $0x3,%eax
  100146:	89 c2                	mov    %eax,%edx
  100148:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10014d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100151:	89 44 24 04          	mov    %eax,0x4(%esp)
  100155:	c7 04 24 a1 5f 10 00 	movl   $0x105fa1,(%esp)
  10015c:	e8 db 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100165:	0f b7 d0             	movzwl %ax,%edx
  100168:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10016d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100171:	89 44 24 04          	mov    %eax,0x4(%esp)
  100175:	c7 04 24 af 5f 10 00 	movl   $0x105faf,(%esp)
  10017c:	e8 bb 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100185:	0f b7 d0             	movzwl %ax,%edx
  100188:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 bd 5f 10 00 	movl   $0x105fbd,(%esp)
  10019c:	e8 9b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001a5:	0f b7 d0             	movzwl %ax,%edx
  1001a8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b5:	c7 04 24 cb 5f 10 00 	movl   $0x105fcb,(%esp)
  1001bc:	e8 7b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001c5:	0f b7 d0             	movzwl %ax,%edx
  1001c8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d5:	c7 04 24 d9 5f 10 00 	movl   $0x105fd9,(%esp)
  1001dc:	e8 5b 01 00 00       	call   10033c <cprintf>
    round ++;
  1001e1:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001e6:	83 c0 01             	add    $0x1,%eax
  1001e9:	a3 40 7a 11 00       	mov    %eax,0x117a40
}
  1001ee:	c9                   	leave  
  1001ef:	c3                   	ret    

001001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001f3:	5d                   	pop    %ebp
  1001f4:	c3                   	ret    

001001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001f5:	55                   	push   %ebp
  1001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001f8:	5d                   	pop    %ebp
  1001f9:	c3                   	ret    

001001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001fa:	55                   	push   %ebp
  1001fb:	89 e5                	mov    %esp,%ebp
  1001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100200:	e8 25 ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100205:	c7 04 24 e8 5f 10 00 	movl   $0x105fe8,(%esp)
  10020c:	e8 2b 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_user();
  100211:	e8 da ff ff ff       	call   1001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
  100216:	e8 0f ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10021b:	c7 04 24 08 60 10 00 	movl   $0x106008,(%esp)
  100222:	e8 15 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_kernel();
  100227:	e8 c9 ff ff ff       	call   1001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10022c:	e8 f9 fe ff ff       	call   10012a <lab1_print_cur_status>
}
  100231:	c9                   	leave  
  100232:	c3                   	ret    

00100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100233:	55                   	push   %ebp
  100234:	89 e5                	mov    %esp,%ebp
  100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10023d:	74 13                	je     100252 <readline+0x1f>
        cprintf("%s", prompt);
  10023f:	8b 45 08             	mov    0x8(%ebp),%eax
  100242:	89 44 24 04          	mov    %eax,0x4(%esp)
  100246:	c7 04 24 27 60 10 00 	movl   $0x106027,(%esp)
  10024d:	e8 ea 00 00 00       	call   10033c <cprintf>
    }
    int i = 0, c;
  100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100259:	e8 66 01 00 00       	call   1003c4 <getchar>
  10025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100265:	79 07                	jns    10026e <readline+0x3b>
            return NULL;
  100267:	b8 00 00 00 00       	mov    $0x0,%eax
  10026c:	eb 79                	jmp    1002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100272:	7e 28                	jle    10029c <readline+0x69>
  100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10027b:	7f 1f                	jg     10029c <readline+0x69>
            cputchar(c);
  10027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100280:	89 04 24             	mov    %eax,(%esp)
  100283:	e8 da 00 00 00       	call   100362 <cputchar>
            buf[i ++] = c;
  100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10028b:	8d 50 01             	lea    0x1(%eax),%edx
  10028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100294:	88 90 60 7a 11 00    	mov    %dl,0x117a60(%eax)
  10029a:	eb 46                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  10029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002a0:	75 17                	jne    1002b9 <readline+0x86>
  1002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002a6:	7e 11                	jle    1002b9 <readline+0x86>
            cputchar(c);
  1002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002ab:	89 04 24             	mov    %eax,(%esp)
  1002ae:	e8 af 00 00 00       	call   100362 <cputchar>
            i --;
  1002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1002b7:	eb 29                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002bd:	74 06                	je     1002c5 <readline+0x92>
  1002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002c3:	75 1d                	jne    1002e2 <readline+0xaf>
            cputchar(c);
  1002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002c8:	89 04 24             	mov    %eax,(%esp)
  1002cb:	e8 92 00 00 00       	call   100362 <cputchar>
            buf[i] = '\0';
  1002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002d3:	05 60 7a 11 00       	add    $0x117a60,%eax
  1002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002db:	b8 60 7a 11 00       	mov    $0x117a60,%eax
  1002e0:	eb 05                	jmp    1002e7 <readline+0xb4>
        }
    }
  1002e2:	e9 72 ff ff ff       	jmp    100259 <readline+0x26>
}
  1002e7:	c9                   	leave  
  1002e8:	c3                   	ret    

001002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002e9:	55                   	push   %ebp
  1002ea:	89 e5                	mov    %esp,%ebp
  1002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f2:	89 04 24             	mov    %eax,(%esp)
  1002f5:	e8 fe 12 00 00       	call   1015f8 <cons_putc>
    (*cnt) ++;
  1002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002fd:	8b 00                	mov    (%eax),%eax
  1002ff:	8d 50 01             	lea    0x1(%eax),%edx
  100302:	8b 45 0c             	mov    0xc(%ebp),%eax
  100305:	89 10                	mov    %edx,(%eax)
}
  100307:	c9                   	leave  
  100308:	c3                   	ret    

00100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100309:	55                   	push   %ebp
  10030a:	89 e5                	mov    %esp,%ebp
  10030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100316:	8b 45 0c             	mov    0xc(%ebp),%eax
  100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10031d:	8b 45 08             	mov    0x8(%ebp),%eax
  100320:	89 44 24 08          	mov    %eax,0x8(%esp)
  100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100327:	89 44 24 04          	mov    %eax,0x4(%esp)
  10032b:	c7 04 24 e9 02 10 00 	movl   $0x1002e9,(%esp)
  100332:	e8 d0 52 00 00       	call   105607 <vprintfmt>
    return cnt;
  100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10033a:	c9                   	leave  
  10033b:	c3                   	ret    

0010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10033c:	55                   	push   %ebp
  10033d:	89 e5                	mov    %esp,%ebp
  10033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100342:	8d 45 0c             	lea    0xc(%ebp),%eax
  100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10034b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10034f:	8b 45 08             	mov    0x8(%ebp),%eax
  100352:	89 04 24             	mov    %eax,(%esp)
  100355:	e8 af ff ff ff       	call   100309 <vcprintf>
  10035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100360:	c9                   	leave  
  100361:	c3                   	ret    

00100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100362:	55                   	push   %ebp
  100363:	89 e5                	mov    %esp,%ebp
  100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100368:	8b 45 08             	mov    0x8(%ebp),%eax
  10036b:	89 04 24             	mov    %eax,(%esp)
  10036e:	e8 85 12 00 00       	call   1015f8 <cons_putc>
}
  100373:	c9                   	leave  
  100374:	c3                   	ret    

00100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100375:	55                   	push   %ebp
  100376:	89 e5                	mov    %esp,%ebp
  100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100382:	eb 13                	jmp    100397 <cputs+0x22>
        cputch(c, &cnt);
  100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
  10038b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10038f:	89 04 24             	mov    %eax,(%esp)
  100392:	e8 52 ff ff ff       	call   1002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  100397:	8b 45 08             	mov    0x8(%ebp),%eax
  10039a:	8d 50 01             	lea    0x1(%eax),%edx
  10039d:	89 55 08             	mov    %edx,0x8(%ebp)
  1003a0:	0f b6 00             	movzbl (%eax),%eax
  1003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003aa:	75 d8                	jne    100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003ba:	e8 2a ff ff ff       	call   1002e9 <cputch>
    return cnt;
  1003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003c2:	c9                   	leave  
  1003c3:	c3                   	ret    

001003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003c4:	55                   	push   %ebp
  1003c5:	89 e5                	mov    %esp,%ebp
  1003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003ca:	e8 65 12 00 00       	call   101634 <cons_getc>
  1003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003d6:	74 f2                	je     1003ca <getchar+0x6>
        /* do nothing */;
    return c;
  1003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003db:	c9                   	leave  
  1003dc:	c3                   	ret    

001003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003dd:	55                   	push   %ebp
  1003de:	89 e5                	mov    %esp,%ebp
  1003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003e6:	8b 00                	mov    (%eax),%eax
  1003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1003ee:	8b 00                	mov    (%eax),%eax
  1003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003fa:	e9 d2 00 00 00       	jmp    1004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100405:	01 d0                	add    %edx,%eax
  100407:	89 c2                	mov    %eax,%edx
  100409:	c1 ea 1f             	shr    $0x1f,%edx
  10040c:	01 d0                	add    %edx,%eax
  10040e:	d1 f8                	sar    %eax
  100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100419:	eb 04                	jmp    10041f <stab_binsearch+0x42>
            m --;
  10041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100425:	7c 1f                	jl     100446 <stab_binsearch+0x69>
  100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10042a:	89 d0                	mov    %edx,%eax
  10042c:	01 c0                	add    %eax,%eax
  10042e:	01 d0                	add    %edx,%eax
  100430:	c1 e0 02             	shl    $0x2,%eax
  100433:	89 c2                	mov    %eax,%edx
  100435:	8b 45 08             	mov    0x8(%ebp),%eax
  100438:	01 d0                	add    %edx,%eax
  10043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10043e:	0f b6 c0             	movzbl %al,%eax
  100441:	3b 45 14             	cmp    0x14(%ebp),%eax
  100444:	75 d5                	jne    10041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10044c:	7d 0b                	jge    100459 <stab_binsearch+0x7c>
            l = true_m + 1;
  10044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100451:	83 c0 01             	add    $0x1,%eax
  100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100457:	eb 78                	jmp    1004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100463:	89 d0                	mov    %edx,%eax
  100465:	01 c0                	add    %eax,%eax
  100467:	01 d0                	add    %edx,%eax
  100469:	c1 e0 02             	shl    $0x2,%eax
  10046c:	89 c2                	mov    %eax,%edx
  10046e:	8b 45 08             	mov    0x8(%ebp),%eax
  100471:	01 d0                	add    %edx,%eax
  100473:	8b 40 08             	mov    0x8(%eax),%eax
  100476:	3b 45 18             	cmp    0x18(%ebp),%eax
  100479:	73 13                	jae    10048e <stab_binsearch+0xb1>
            *region_left = m;
  10047b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100486:	83 c0 01             	add    $0x1,%eax
  100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10048c:	eb 43                	jmp    1004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100491:	89 d0                	mov    %edx,%eax
  100493:	01 c0                	add    %eax,%eax
  100495:	01 d0                	add    %edx,%eax
  100497:	c1 e0 02             	shl    $0x2,%eax
  10049a:	89 c2                	mov    %eax,%edx
  10049c:	8b 45 08             	mov    0x8(%ebp),%eax
  10049f:	01 d0                	add    %edx,%eax
  1004a1:	8b 40 08             	mov    0x8(%eax),%eax
  1004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004a7:	76 16                	jbe    1004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
  1004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004af:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b7:	83 e8 01             	sub    $0x1,%eax
  1004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004bd:	eb 12                	jmp    1004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004c5:	89 10                	mov    %edx,(%eax)
            l = m;
  1004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004d7:	0f 8e 22 ff ff ff    	jle    1003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004e1:	75 0f                	jne    1004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e6:	8b 00                	mov    (%eax),%eax
  1004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1004ee:	89 10                	mov    %edx,(%eax)
  1004f0:	eb 3f                	jmp    100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004f2:	8b 45 10             	mov    0x10(%ebp),%eax
  1004f5:	8b 00                	mov    (%eax),%eax
  1004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004fa:	eb 04                	jmp    100500 <stab_binsearch+0x123>
  1004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100500:	8b 45 0c             	mov    0xc(%ebp),%eax
  100503:	8b 00                	mov    (%eax),%eax
  100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100508:	7d 1f                	jge    100529 <stab_binsearch+0x14c>
  10050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10050d:	89 d0                	mov    %edx,%eax
  10050f:	01 c0                	add    %eax,%eax
  100511:	01 d0                	add    %edx,%eax
  100513:	c1 e0 02             	shl    $0x2,%eax
  100516:	89 c2                	mov    %eax,%edx
  100518:	8b 45 08             	mov    0x8(%ebp),%eax
  10051b:	01 d0                	add    %edx,%eax
  10051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100521:	0f b6 c0             	movzbl %al,%eax
  100524:	3b 45 14             	cmp    0x14(%ebp),%eax
  100527:	75 d3                	jne    1004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  100529:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10052f:	89 10                	mov    %edx,(%eax)
    }
}
  100531:	c9                   	leave  
  100532:	c3                   	ret    

00100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100533:	55                   	push   %ebp
  100534:	89 e5                	mov    %esp,%ebp
  100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100539:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053c:	c7 00 2c 60 10 00    	movl   $0x10602c,(%eax)
    info->eip_line = 0;
  100542:	8b 45 0c             	mov    0xc(%ebp),%eax
  100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10054c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10054f:	c7 40 08 2c 60 10 00 	movl   $0x10602c,0x8(%eax)
    info->eip_fn_namelen = 9;
  100556:	8b 45 0c             	mov    0xc(%ebp),%eax
  100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100560:	8b 45 0c             	mov    0xc(%ebp),%eax
  100563:	8b 55 08             	mov    0x8(%ebp),%edx
  100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100569:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100573:	c7 45 f4 88 72 10 00 	movl   $0x107288,-0xc(%ebp)
    stab_end = __STAB_END__;
  10057a:	c7 45 f0 9c 1e 11 00 	movl   $0x111e9c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100581:	c7 45 ec 9d 1e 11 00 	movl   $0x111e9d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100588:	c7 45 e8 d5 48 11 00 	movl   $0x1148d5,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100595:	76 0d                	jbe    1005a4 <debuginfo_eip+0x71>
  100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10059a:	83 e8 01             	sub    $0x1,%eax
  10059d:	0f b6 00             	movzbl (%eax),%eax
  1005a0:	84 c0                	test   %al,%al
  1005a2:	74 0a                	je     1005ae <debuginfo_eip+0x7b>
        return -1;
  1005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005a9:	e9 c0 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005bb:	29 c2                	sub    %eax,%edx
  1005bd:	89 d0                	mov    %edx,%eax
  1005bf:	c1 f8 02             	sar    $0x2,%eax
  1005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005c8:	83 e8 01             	sub    $0x1,%eax
  1005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005dc:	00 
  1005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005ee:	89 04 24             	mov    %eax,(%esp)
  1005f1:	e8 e7 fd ff ff       	call   1003dd <stab_binsearch>
    if (lfile == 0)
  1005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005f9:	85 c0                	test   %eax,%eax
  1005fb:	75 0a                	jne    100607 <debuginfo_eip+0xd4>
        return -1;
  1005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100602:	e9 67 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100613:	8b 45 08             	mov    0x8(%ebp),%eax
  100616:	89 44 24 10          	mov    %eax,0x10(%esp)
  10061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100621:	00 
  100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100625:	89 44 24 08          	mov    %eax,0x8(%esp)
  100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10062c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100633:	89 04 24             	mov    %eax,(%esp)
  100636:	e8 a2 fd ff ff       	call   1003dd <stab_binsearch>

    if (lfun <= rfun) {
  10063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100641:	39 c2                	cmp    %eax,%edx
  100643:	7f 7c                	jg     1006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100648:	89 c2                	mov    %eax,%edx
  10064a:	89 d0                	mov    %edx,%eax
  10064c:	01 c0                	add    %eax,%eax
  10064e:	01 d0                	add    %edx,%eax
  100650:	c1 e0 02             	shl    $0x2,%eax
  100653:	89 c2                	mov    %eax,%edx
  100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100658:	01 d0                	add    %edx,%eax
  10065a:	8b 10                	mov    (%eax),%edx
  10065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100662:	29 c1                	sub    %eax,%ecx
  100664:	89 c8                	mov    %ecx,%eax
  100666:	39 c2                	cmp    %eax,%edx
  100668:	73 22                	jae    10068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10066d:	89 c2                	mov    %eax,%edx
  10066f:	89 d0                	mov    %edx,%eax
  100671:	01 c0                	add    %eax,%eax
  100673:	01 d0                	add    %edx,%eax
  100675:	c1 e0 02             	shl    $0x2,%eax
  100678:	89 c2                	mov    %eax,%edx
  10067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10067d:	01 d0                	add    %edx,%eax
  10067f:	8b 10                	mov    (%eax),%edx
  100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100684:	01 c2                	add    %eax,%edx
  100686:	8b 45 0c             	mov    0xc(%ebp),%eax
  100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068f:	89 c2                	mov    %eax,%edx
  100691:	89 d0                	mov    %edx,%eax
  100693:	01 c0                	add    %eax,%eax
  100695:	01 d0                	add    %edx,%eax
  100697:	c1 e0 02             	shl    $0x2,%eax
  10069a:	89 c2                	mov    %eax,%edx
  10069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10069f:	01 d0                	add    %edx,%eax
  1006a1:	8b 50 08             	mov    0x8(%eax),%edx
  1006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ad:	8b 40 10             	mov    0x10(%eax),%eax
  1006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006bf:	eb 15                	jmp    1006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c4:	8b 55 08             	mov    0x8(%ebp),%edx
  1006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d9:	8b 40 08             	mov    0x8(%eax),%eax
  1006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006e3:	00 
  1006e4:	89 04 24             	mov    %eax,(%esp)
  1006e7:	e8 76 55 00 00       	call   105c62 <strfind>
  1006ec:	89 c2                	mov    %eax,%edx
  1006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f1:	8b 40 08             	mov    0x8(%eax),%eax
  1006f4:	29 c2                	sub    %eax,%edx
  1006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
  100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  10070a:	00 
  10070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10070e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100715:	89 44 24 04          	mov    %eax,0x4(%esp)
  100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071c:	89 04 24             	mov    %eax,(%esp)
  10071f:	e8 b9 fc ff ff       	call   1003dd <stab_binsearch>
    if (lline <= rline) {
  100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10072a:	39 c2                	cmp    %eax,%edx
  10072c:	7f 24                	jg     100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  10072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100731:	89 c2                	mov    %eax,%edx
  100733:	89 d0                	mov    %edx,%eax
  100735:	01 c0                	add    %eax,%eax
  100737:	01 d0                	add    %edx,%eax
  100739:	c1 e0 02             	shl    $0x2,%eax
  10073c:	89 c2                	mov    %eax,%edx
  10073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100741:	01 d0                	add    %edx,%eax
  100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100747:	0f b7 d0             	movzwl %ax,%edx
  10074a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100750:	eb 13                	jmp    100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100757:	e9 12 01 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10075f:	83 e8 01             	sub    $0x1,%eax
  100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10076b:	39 c2                	cmp    %eax,%edx
  10076d:	7c 56                	jl     1007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  10076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100772:	89 c2                	mov    %eax,%edx
  100774:	89 d0                	mov    %edx,%eax
  100776:	01 c0                	add    %eax,%eax
  100778:	01 d0                	add    %edx,%eax
  10077a:	c1 e0 02             	shl    $0x2,%eax
  10077d:	89 c2                	mov    %eax,%edx
  10077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100782:	01 d0                	add    %edx,%eax
  100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100788:	3c 84                	cmp    $0x84,%al
  10078a:	74 39                	je     1007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10078f:	89 c2                	mov    %eax,%edx
  100791:	89 d0                	mov    %edx,%eax
  100793:	01 c0                	add    %eax,%eax
  100795:	01 d0                	add    %edx,%eax
  100797:	c1 e0 02             	shl    $0x2,%eax
  10079a:	89 c2                	mov    %eax,%edx
  10079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10079f:	01 d0                	add    %edx,%eax
  1007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007a5:	3c 64                	cmp    $0x64,%al
  1007a7:	75 b3                	jne    10075c <debuginfo_eip+0x229>
  1007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007ac:	89 c2                	mov    %eax,%edx
  1007ae:	89 d0                	mov    %edx,%eax
  1007b0:	01 c0                	add    %eax,%eax
  1007b2:	01 d0                	add    %edx,%eax
  1007b4:	c1 e0 02             	shl    $0x2,%eax
  1007b7:	89 c2                	mov    %eax,%edx
  1007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007bc:	01 d0                	add    %edx,%eax
  1007be:	8b 40 08             	mov    0x8(%eax),%eax
  1007c1:	85 c0                	test   %eax,%eax
  1007c3:	74 97                	je     10075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007cb:	39 c2                	cmp    %eax,%edx
  1007cd:	7c 46                	jl     100815 <debuginfo_eip+0x2e2>
  1007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007d2:	89 c2                	mov    %eax,%edx
  1007d4:	89 d0                	mov    %edx,%eax
  1007d6:	01 c0                	add    %eax,%eax
  1007d8:	01 d0                	add    %edx,%eax
  1007da:	c1 e0 02             	shl    $0x2,%eax
  1007dd:	89 c2                	mov    %eax,%edx
  1007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e2:	01 d0                	add    %edx,%eax
  1007e4:	8b 10                	mov    (%eax),%edx
  1007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007ec:	29 c1                	sub    %eax,%ecx
  1007ee:	89 c8                	mov    %ecx,%eax
  1007f0:	39 c2                	cmp    %eax,%edx
  1007f2:	73 21                	jae    100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f7:	89 c2                	mov    %eax,%edx
  1007f9:	89 d0                	mov    %edx,%eax
  1007fb:	01 c0                	add    %eax,%eax
  1007fd:	01 d0                	add    %edx,%eax
  1007ff:	c1 e0 02             	shl    $0x2,%eax
  100802:	89 c2                	mov    %eax,%edx
  100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100807:	01 d0                	add    %edx,%eax
  100809:	8b 10                	mov    (%eax),%edx
  10080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10080e:	01 c2                	add    %eax,%edx
  100810:	8b 45 0c             	mov    0xc(%ebp),%eax
  100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10081b:	39 c2                	cmp    %eax,%edx
  10081d:	7d 4a                	jge    100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  10081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100822:	83 c0 01             	add    $0x1,%eax
  100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100828:	eb 18                	jmp    100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  10082a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10082d:	8b 40 14             	mov    0x14(%eax),%eax
  100830:	8d 50 01             	lea    0x1(%eax),%edx
  100833:	8b 45 0c             	mov    0xc(%ebp),%eax
  100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10083c:	83 c0 01             	add    $0x1,%eax
  10083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100848:	39 c2                	cmp    %eax,%edx
  10084a:	7d 1d                	jge    100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10084f:	89 c2                	mov    %eax,%edx
  100851:	89 d0                	mov    %edx,%eax
  100853:	01 c0                	add    %eax,%eax
  100855:	01 d0                	add    %edx,%eax
  100857:	c1 e0 02             	shl    $0x2,%eax
  10085a:	89 c2                	mov    %eax,%edx
  10085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10085f:	01 d0                	add    %edx,%eax
  100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100865:	3c a0                	cmp    $0xa0,%al
  100867:	74 c1                	je     10082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10086e:	c9                   	leave  
  10086f:	c3                   	ret    

00100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100870:	55                   	push   %ebp
  100871:	89 e5                	mov    %esp,%ebp
  100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100876:	c7 04 24 36 60 10 00 	movl   $0x106036,(%esp)
  10087d:	e8 ba fa ff ff       	call   10033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100882:	c7 44 24 04 2a 00 10 	movl   $0x10002a,0x4(%esp)
  100889:	00 
  10088a:	c7 04 24 4f 60 10 00 	movl   $0x10604f,(%esp)
  100891:	e8 a6 fa ff ff       	call   10033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100896:	c7 44 24 04 77 5f 10 	movl   $0x105f77,0x4(%esp)
  10089d:	00 
  10089e:	c7 04 24 67 60 10 00 	movl   $0x106067,(%esp)
  1008a5:	e8 92 fa ff ff       	call   10033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008aa:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  1008b1:	00 
  1008b2:	c7 04 24 7f 60 10 00 	movl   $0x10607f,(%esp)
  1008b9:	e8 7e fa ff ff       	call   10033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008be:	c7 44 24 04 68 89 11 	movl   $0x118968,0x4(%esp)
  1008c5:	00 
  1008c6:	c7 04 24 97 60 10 00 	movl   $0x106097,(%esp)
  1008cd:	e8 6a fa ff ff       	call   10033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008d2:	b8 68 89 11 00       	mov    $0x118968,%eax
  1008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008dd:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1008e2:	29 c2                	sub    %eax,%edx
  1008e4:	89 d0                	mov    %edx,%eax
  1008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008ec:	85 c0                	test   %eax,%eax
  1008ee:	0f 48 c2             	cmovs  %edx,%eax
  1008f1:	c1 f8 0a             	sar    $0xa,%eax
  1008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008f8:	c7 04 24 b0 60 10 00 	movl   $0x1060b0,(%esp)
  1008ff:	e8 38 fa ff ff       	call   10033c <cprintf>
}
  100904:	c9                   	leave  
  100905:	c3                   	ret    

00100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100906:	55                   	push   %ebp
  100907:	89 e5                	mov    %esp,%ebp
  100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100912:	89 44 24 04          	mov    %eax,0x4(%esp)
  100916:	8b 45 08             	mov    0x8(%ebp),%eax
  100919:	89 04 24             	mov    %eax,(%esp)
  10091c:	e8 12 fc ff ff       	call   100533 <debuginfo_eip>
  100921:	85 c0                	test   %eax,%eax
  100923:	74 15                	je     10093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100925:	8b 45 08             	mov    0x8(%ebp),%eax
  100928:	89 44 24 04          	mov    %eax,0x4(%esp)
  10092c:	c7 04 24 da 60 10 00 	movl   $0x1060da,(%esp)
  100933:	e8 04 fa ff ff       	call   10033c <cprintf>
  100938:	eb 6d                	jmp    1009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100941:	eb 1c                	jmp    10095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100949:	01 d0                	add    %edx,%eax
  10094b:	0f b6 00             	movzbl (%eax),%eax
  10094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100957:	01 ca                	add    %ecx,%edx
  100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100965:	7f dc                	jg     100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100970:	01 d0                	add    %edx,%eax
  100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100978:	8b 55 08             	mov    0x8(%ebp),%edx
  10097b:	89 d1                	mov    %edx,%ecx
  10097d:	29 c1                	sub    %eax,%ecx
  10097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100993:	89 54 24 08          	mov    %edx,0x8(%esp)
  100997:	89 44 24 04          	mov    %eax,0x4(%esp)
  10099b:	c7 04 24 f6 60 10 00 	movl   $0x1060f6,(%esp)
  1009a2:	e8 95 f9 ff ff       	call   10033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  1009a7:	c9                   	leave  
  1009a8:	c3                   	ret    

001009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009a9:	55                   	push   %ebp
  1009aa:	89 e5                	mov    %esp,%ebp
  1009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009af:	8b 45 04             	mov    0x4(%ebp),%eax
  1009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009b8:	c9                   	leave  
  1009b9:	c3                   	ret    

001009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009ba:	55                   	push   %ebp
  1009bb:	89 e5                	mov    %esp,%ebp
  1009bd:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009c0:	89 e8                	mov    %ebp,%eax
  1009c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  1009c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
	uint32_t ebp = read_ebp(), eip = read_eip();
  1009c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1009cb:	e8 d9 ff ff ff       	call   1009a9 <read_eip>
  1009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i, j;
	for(i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++)
  1009d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009da:	e9 88 00 00 00       	jmp    100a67 <print_stackframe+0xad>
	{
	cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  1009df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009ed:	c7 04 24 08 61 10 00 	movl   $0x106108,(%esp)
  1009f4:	e8 43 f9 ff ff       	call   10033c <cprintf>
	uint32_t *args = (uint32_t *)ebp + 2;
  1009f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009fc:	83 c0 08             	add    $0x8,%eax
  1009ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	for (j = 0; j < 4; j++) {
  100a02:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a09:	eb 25                	jmp    100a30 <print_stackframe+0x76>
            cprintf("0x%08x ", args[j]);
  100a0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a0e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a18:	01 d0                	add    %edx,%eax
  100a1a:	8b 00                	mov    (%eax),%eax
  100a1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a20:	c7 04 24 24 61 10 00 	movl   $0x106124,(%esp)
  100a27:	e8 10 f9 ff ff       	call   10033c <cprintf>
	int i, j;
	for(i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++)
	{
	cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
	uint32_t *args = (uint32_t *)ebp + 2;
	for (j = 0; j < 4; j++) {
  100a2c:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a30:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a34:	7e d5                	jle    100a0b <print_stackframe+0x51>
            cprintf("0x%08x ", args[j]);
        }
        cprintf("\n");
  100a36:	c7 04 24 2c 61 10 00 	movl   $0x10612c,(%esp)
  100a3d:	e8 fa f8 ff ff       	call   10033c <cprintf>
        print_debuginfo(eip - 1);
  100a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a45:	83 e8 01             	sub    $0x1,%eax
  100a48:	89 04 24             	mov    %eax,(%esp)
  100a4b:	e8 b6 fe ff ff       	call   100906 <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
  100a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a53:	83 c0 04             	add    $0x4,%eax
  100a56:	8b 00                	mov    (%eax),%eax
  100a58:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a5e:	8b 00                	mov    (%eax),%eax
  100a60:	89 45 f4             	mov    %eax,-0xc(%ebp)
 * */
void
print_stackframe(void) {
	uint32_t ebp = read_ebp(), eip = read_eip();
	int i, j;
	for(i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++)
  100a63:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a6b:	74 0a                	je     100a77 <print_stackframe+0xbd>
  100a6d:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a71:	0f 8e 68 ff ff ff    	jle    1009df <print_stackframe+0x25>
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
  100a77:	c9                   	leave  
  100a78:	c3                   	ret    

00100a79 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a79:	55                   	push   %ebp
  100a7a:	89 e5                	mov    %esp,%ebp
  100a7c:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a86:	eb 0c                	jmp    100a94 <parse+0x1b>
            *buf ++ = '\0';
  100a88:	8b 45 08             	mov    0x8(%ebp),%eax
  100a8b:	8d 50 01             	lea    0x1(%eax),%edx
  100a8e:	89 55 08             	mov    %edx,0x8(%ebp)
  100a91:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a94:	8b 45 08             	mov    0x8(%ebp),%eax
  100a97:	0f b6 00             	movzbl (%eax),%eax
  100a9a:	84 c0                	test   %al,%al
  100a9c:	74 1d                	je     100abb <parse+0x42>
  100a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa1:	0f b6 00             	movzbl (%eax),%eax
  100aa4:	0f be c0             	movsbl %al,%eax
  100aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
  100aab:	c7 04 24 b0 61 10 00 	movl   $0x1061b0,(%esp)
  100ab2:	e8 78 51 00 00       	call   105c2f <strchr>
  100ab7:	85 c0                	test   %eax,%eax
  100ab9:	75 cd                	jne    100a88 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100abb:	8b 45 08             	mov    0x8(%ebp),%eax
  100abe:	0f b6 00             	movzbl (%eax),%eax
  100ac1:	84 c0                	test   %al,%al
  100ac3:	75 02                	jne    100ac7 <parse+0x4e>
            break;
  100ac5:	eb 67                	jmp    100b2e <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100ac7:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100acb:	75 14                	jne    100ae1 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100acd:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ad4:	00 
  100ad5:	c7 04 24 b5 61 10 00 	movl   $0x1061b5,(%esp)
  100adc:	e8 5b f8 ff ff       	call   10033c <cprintf>
        }
        argv[argc ++] = buf;
  100ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ae4:	8d 50 01             	lea    0x1(%eax),%edx
  100ae7:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100aea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100af1:	8b 45 0c             	mov    0xc(%ebp),%eax
  100af4:	01 c2                	add    %eax,%edx
  100af6:	8b 45 08             	mov    0x8(%ebp),%eax
  100af9:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100afb:	eb 04                	jmp    100b01 <parse+0x88>
            buf ++;
  100afd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b01:	8b 45 08             	mov    0x8(%ebp),%eax
  100b04:	0f b6 00             	movzbl (%eax),%eax
  100b07:	84 c0                	test   %al,%al
  100b09:	74 1d                	je     100b28 <parse+0xaf>
  100b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0e:	0f b6 00             	movzbl (%eax),%eax
  100b11:	0f be c0             	movsbl %al,%eax
  100b14:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b18:	c7 04 24 b0 61 10 00 	movl   $0x1061b0,(%esp)
  100b1f:	e8 0b 51 00 00       	call   105c2f <strchr>
  100b24:	85 c0                	test   %eax,%eax
  100b26:	74 d5                	je     100afd <parse+0x84>
            buf ++;
        }
    }
  100b28:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b29:	e9 66 ff ff ff       	jmp    100a94 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b31:	c9                   	leave  
  100b32:	c3                   	ret    

00100b33 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b33:	55                   	push   %ebp
  100b34:	89 e5                	mov    %esp,%ebp
  100b36:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b39:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b40:	8b 45 08             	mov    0x8(%ebp),%eax
  100b43:	89 04 24             	mov    %eax,(%esp)
  100b46:	e8 2e ff ff ff       	call   100a79 <parse>
  100b4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b52:	75 0a                	jne    100b5e <runcmd+0x2b>
        return 0;
  100b54:	b8 00 00 00 00       	mov    $0x0,%eax
  100b59:	e9 85 00 00 00       	jmp    100be3 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b65:	eb 5c                	jmp    100bc3 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b67:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b6d:	89 d0                	mov    %edx,%eax
  100b6f:	01 c0                	add    %eax,%eax
  100b71:	01 d0                	add    %edx,%eax
  100b73:	c1 e0 02             	shl    $0x2,%eax
  100b76:	05 20 70 11 00       	add    $0x117020,%eax
  100b7b:	8b 00                	mov    (%eax),%eax
  100b7d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b81:	89 04 24             	mov    %eax,(%esp)
  100b84:	e8 07 50 00 00       	call   105b90 <strcmp>
  100b89:	85 c0                	test   %eax,%eax
  100b8b:	75 32                	jne    100bbf <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b90:	89 d0                	mov    %edx,%eax
  100b92:	01 c0                	add    %eax,%eax
  100b94:	01 d0                	add    %edx,%eax
  100b96:	c1 e0 02             	shl    $0x2,%eax
  100b99:	05 20 70 11 00       	add    $0x117020,%eax
  100b9e:	8b 40 08             	mov    0x8(%eax),%eax
  100ba1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100ba4:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100ba7:	8b 55 0c             	mov    0xc(%ebp),%edx
  100baa:	89 54 24 08          	mov    %edx,0x8(%esp)
  100bae:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100bb1:	83 c2 04             	add    $0x4,%edx
  100bb4:	89 54 24 04          	mov    %edx,0x4(%esp)
  100bb8:	89 0c 24             	mov    %ecx,(%esp)
  100bbb:	ff d0                	call   *%eax
  100bbd:	eb 24                	jmp    100be3 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bbf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bc6:	83 f8 02             	cmp    $0x2,%eax
  100bc9:	76 9c                	jbe    100b67 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bcb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bce:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bd2:	c7 04 24 d3 61 10 00 	movl   $0x1061d3,(%esp)
  100bd9:	e8 5e f7 ff ff       	call   10033c <cprintf>
    return 0;
  100bde:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100be3:	c9                   	leave  
  100be4:	c3                   	ret    

00100be5 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100be5:	55                   	push   %ebp
  100be6:	89 e5                	mov    %esp,%ebp
  100be8:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100beb:	c7 04 24 ec 61 10 00 	movl   $0x1061ec,(%esp)
  100bf2:	e8 45 f7 ff ff       	call   10033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bf7:	c7 04 24 14 62 10 00 	movl   $0x106214,(%esp)
  100bfe:	e8 39 f7 ff ff       	call   10033c <cprintf>

    if (tf != NULL) {
  100c03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c07:	74 0b                	je     100c14 <kmonitor+0x2f>
        print_trapframe(tf);
  100c09:	8b 45 08             	mov    0x8(%ebp),%eax
  100c0c:	89 04 24             	mov    %eax,(%esp)
  100c0f:	e8 5c 0e 00 00       	call   101a70 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c14:	c7 04 24 39 62 10 00 	movl   $0x106239,(%esp)
  100c1b:	e8 13 f6 ff ff       	call   100233 <readline>
  100c20:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c27:	74 18                	je     100c41 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c29:	8b 45 08             	mov    0x8(%ebp),%eax
  100c2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c33:	89 04 24             	mov    %eax,(%esp)
  100c36:	e8 f8 fe ff ff       	call   100b33 <runcmd>
  100c3b:	85 c0                	test   %eax,%eax
  100c3d:	79 02                	jns    100c41 <kmonitor+0x5c>
                break;
  100c3f:	eb 02                	jmp    100c43 <kmonitor+0x5e>
            }
        }
    }
  100c41:	eb d1                	jmp    100c14 <kmonitor+0x2f>
}
  100c43:	c9                   	leave  
  100c44:	c3                   	ret    

00100c45 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c45:	55                   	push   %ebp
  100c46:	89 e5                	mov    %esp,%ebp
  100c48:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c52:	eb 3f                	jmp    100c93 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c57:	89 d0                	mov    %edx,%eax
  100c59:	01 c0                	add    %eax,%eax
  100c5b:	01 d0                	add    %edx,%eax
  100c5d:	c1 e0 02             	shl    $0x2,%eax
  100c60:	05 20 70 11 00       	add    $0x117020,%eax
  100c65:	8b 48 04             	mov    0x4(%eax),%ecx
  100c68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c6b:	89 d0                	mov    %edx,%eax
  100c6d:	01 c0                	add    %eax,%eax
  100c6f:	01 d0                	add    %edx,%eax
  100c71:	c1 e0 02             	shl    $0x2,%eax
  100c74:	05 20 70 11 00       	add    $0x117020,%eax
  100c79:	8b 00                	mov    (%eax),%eax
  100c7b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c83:	c7 04 24 3d 62 10 00 	movl   $0x10623d,(%esp)
  100c8a:	e8 ad f6 ff ff       	call   10033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c8f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c96:	83 f8 02             	cmp    $0x2,%eax
  100c99:	76 b9                	jbe    100c54 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ca0:	c9                   	leave  
  100ca1:	c3                   	ret    

00100ca2 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100ca2:	55                   	push   %ebp
  100ca3:	89 e5                	mov    %esp,%ebp
  100ca5:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100ca8:	e8 c3 fb ff ff       	call   100870 <print_kerninfo>
    return 0;
  100cad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cb2:	c9                   	leave  
  100cb3:	c3                   	ret    

00100cb4 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cb4:	55                   	push   %ebp
  100cb5:	89 e5                	mov    %esp,%ebp
  100cb7:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cba:	e8 fb fc ff ff       	call   1009ba <print_stackframe>
    return 0;
  100cbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cc4:	c9                   	leave  
  100cc5:	c3                   	ret    

00100cc6 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100cc6:	55                   	push   %ebp
  100cc7:	89 e5                	mov    %esp,%ebp
  100cc9:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100ccc:	a1 60 7e 11 00       	mov    0x117e60,%eax
  100cd1:	85 c0                	test   %eax,%eax
  100cd3:	74 02                	je     100cd7 <__panic+0x11>
        goto panic_dead;
  100cd5:	eb 48                	jmp    100d1f <__panic+0x59>
    }
    is_panic = 1;
  100cd7:	c7 05 60 7e 11 00 01 	movl   $0x1,0x117e60
  100cde:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100ce1:	8d 45 14             	lea    0x14(%ebp),%eax
  100ce4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cea:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cee:	8b 45 08             	mov    0x8(%ebp),%eax
  100cf1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cf5:	c7 04 24 46 62 10 00 	movl   $0x106246,(%esp)
  100cfc:	e8 3b f6 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d04:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d08:	8b 45 10             	mov    0x10(%ebp),%eax
  100d0b:	89 04 24             	mov    %eax,(%esp)
  100d0e:	e8 f6 f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d13:	c7 04 24 62 62 10 00 	movl   $0x106262,(%esp)
  100d1a:	e8 1d f6 ff ff       	call   10033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100d1f:	e8 85 09 00 00       	call   1016a9 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d24:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d2b:	e8 b5 fe ff ff       	call   100be5 <kmonitor>
    }
  100d30:	eb f2                	jmp    100d24 <__panic+0x5e>

00100d32 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d32:	55                   	push   %ebp
  100d33:	89 e5                	mov    %esp,%ebp
  100d35:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d38:	8d 45 14             	lea    0x14(%ebp),%eax
  100d3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d41:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d45:	8b 45 08             	mov    0x8(%ebp),%eax
  100d48:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d4c:	c7 04 24 64 62 10 00 	movl   $0x106264,(%esp)
  100d53:	e8 e4 f5 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d5f:	8b 45 10             	mov    0x10(%ebp),%eax
  100d62:	89 04 24             	mov    %eax,(%esp)
  100d65:	e8 9f f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d6a:	c7 04 24 62 62 10 00 	movl   $0x106262,(%esp)
  100d71:	e8 c6 f5 ff ff       	call   10033c <cprintf>
    va_end(ap);
}
  100d76:	c9                   	leave  
  100d77:	c3                   	ret    

00100d78 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d78:	55                   	push   %ebp
  100d79:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d7b:	a1 60 7e 11 00       	mov    0x117e60,%eax
}
  100d80:	5d                   	pop    %ebp
  100d81:	c3                   	ret    

00100d82 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d82:	55                   	push   %ebp
  100d83:	89 e5                	mov    %esp,%ebp
  100d85:	83 ec 28             	sub    $0x28,%esp
  100d88:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d8e:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d92:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d96:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d9a:	ee                   	out    %al,(%dx)
  100d9b:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100da1:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100da5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100da9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dad:	ee                   	out    %al,(%dx)
  100dae:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100db4:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100db8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dbc:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dc0:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dc1:	c7 05 4c 89 11 00 00 	movl   $0x0,0x11894c
  100dc8:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dcb:	c7 04 24 82 62 10 00 	movl   $0x106282,(%esp)
  100dd2:	e8 65 f5 ff ff       	call   10033c <cprintf>
    pic_enable(IRQ_TIMER);
  100dd7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100dde:	e8 24 09 00 00       	call   101707 <pic_enable>
}
  100de3:	c9                   	leave  
  100de4:	c3                   	ret    

00100de5 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100de5:	55                   	push   %ebp
  100de6:	89 e5                	mov    %esp,%ebp
  100de8:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100deb:	9c                   	pushf  
  100dec:	58                   	pop    %eax
  100ded:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100df3:	25 00 02 00 00       	and    $0x200,%eax
  100df8:	85 c0                	test   %eax,%eax
  100dfa:	74 0c                	je     100e08 <__intr_save+0x23>
        intr_disable();
  100dfc:	e8 a8 08 00 00       	call   1016a9 <intr_disable>
        return 1;
  100e01:	b8 01 00 00 00       	mov    $0x1,%eax
  100e06:	eb 05                	jmp    100e0d <__intr_save+0x28>
    }
    return 0;
  100e08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e0d:	c9                   	leave  
  100e0e:	c3                   	ret    

00100e0f <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e0f:	55                   	push   %ebp
  100e10:	89 e5                	mov    %esp,%ebp
  100e12:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e19:	74 05                	je     100e20 <__intr_restore+0x11>
        intr_enable();
  100e1b:	e8 83 08 00 00       	call   1016a3 <intr_enable>
    }
}
  100e20:	c9                   	leave  
  100e21:	c3                   	ret    

00100e22 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e22:	55                   	push   %ebp
  100e23:	89 e5                	mov    %esp,%ebp
  100e25:	83 ec 10             	sub    $0x10,%esp
  100e28:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e2e:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e32:	89 c2                	mov    %eax,%edx
  100e34:	ec                   	in     (%dx),%al
  100e35:	88 45 fd             	mov    %al,-0x3(%ebp)
  100e38:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e3e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e42:	89 c2                	mov    %eax,%edx
  100e44:	ec                   	in     (%dx),%al
  100e45:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e48:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e4e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e52:	89 c2                	mov    %eax,%edx
  100e54:	ec                   	in     (%dx),%al
  100e55:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e58:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e5e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e62:	89 c2                	mov    %eax,%edx
  100e64:	ec                   	in     (%dx),%al
  100e65:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e68:	c9                   	leave  
  100e69:	c3                   	ret    

00100e6a <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e6a:	55                   	push   %ebp
  100e6b:	89 e5                	mov    %esp,%ebp
  100e6d:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e70:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e7a:	0f b7 00             	movzwl (%eax),%eax
  100e7d:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e81:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e84:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e8c:	0f b7 00             	movzwl (%eax),%eax
  100e8f:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e93:	74 12                	je     100ea7 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100e95:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e9c:	66 c7 05 86 7e 11 00 	movw   $0x3b4,0x117e86
  100ea3:	b4 03 
  100ea5:	eb 13                	jmp    100eba <cga_init+0x50>
    } else {
        *cp = was;
  100ea7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eaa:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100eae:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100eb1:	66 c7 05 86 7e 11 00 	movw   $0x3d4,0x117e86
  100eb8:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100eba:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ec1:	0f b7 c0             	movzwl %ax,%eax
  100ec4:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100ec8:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ecc:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ed0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100ed4:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100ed5:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100edc:	83 c0 01             	add    $0x1,%eax
  100edf:	0f b7 c0             	movzwl %ax,%eax
  100ee2:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ee6:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100eea:	89 c2                	mov    %eax,%edx
  100eec:	ec                   	in     (%dx),%al
  100eed:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100ef0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ef4:	0f b6 c0             	movzbl %al,%eax
  100ef7:	c1 e0 08             	shl    $0x8,%eax
  100efa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100efd:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f04:	0f b7 c0             	movzwl %ax,%eax
  100f07:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100f0b:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f0f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f13:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f17:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f18:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f1f:	83 c0 01             	add    $0x1,%eax
  100f22:	0f b7 c0             	movzwl %ax,%eax
  100f25:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f29:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f2d:	89 c2                	mov    %eax,%edx
  100f2f:	ec                   	in     (%dx),%al
  100f30:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100f33:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f37:	0f b6 c0             	movzbl %al,%eax
  100f3a:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f40:	a3 80 7e 11 00       	mov    %eax,0x117e80
    crt_pos = pos;
  100f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f48:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
}
  100f4e:	c9                   	leave  
  100f4f:	c3                   	ret    

00100f50 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f50:	55                   	push   %ebp
  100f51:	89 e5                	mov    %esp,%ebp
  100f53:	83 ec 48             	sub    $0x48,%esp
  100f56:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f5c:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f60:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f64:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f68:	ee                   	out    %al,(%dx)
  100f69:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f6f:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f73:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f77:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f7b:	ee                   	out    %al,(%dx)
  100f7c:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f82:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f86:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f8a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f8e:	ee                   	out    %al,(%dx)
  100f8f:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f95:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f99:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f9d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fa1:	ee                   	out    %al,(%dx)
  100fa2:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100fa8:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100fac:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fb0:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fb4:	ee                   	out    %al,(%dx)
  100fb5:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100fbb:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100fbf:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fc3:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fc7:	ee                   	out    %al,(%dx)
  100fc8:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fce:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100fd2:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fd6:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fda:	ee                   	out    %al,(%dx)
  100fdb:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fe1:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100fe5:	89 c2                	mov    %eax,%edx
  100fe7:	ec                   	in     (%dx),%al
  100fe8:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100feb:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fef:	3c ff                	cmp    $0xff,%al
  100ff1:	0f 95 c0             	setne  %al
  100ff4:	0f b6 c0             	movzbl %al,%eax
  100ff7:	a3 88 7e 11 00       	mov    %eax,0x117e88
  100ffc:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101002:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  101006:	89 c2                	mov    %eax,%edx
  101008:	ec                   	in     (%dx),%al
  101009:	88 45 d5             	mov    %al,-0x2b(%ebp)
  10100c:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  101012:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  101016:	89 c2                	mov    %eax,%edx
  101018:	ec                   	in     (%dx),%al
  101019:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  10101c:	a1 88 7e 11 00       	mov    0x117e88,%eax
  101021:	85 c0                	test   %eax,%eax
  101023:	74 0c                	je     101031 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  101025:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10102c:	e8 d6 06 00 00       	call   101707 <pic_enable>
    }
}
  101031:	c9                   	leave  
  101032:	c3                   	ret    

00101033 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101033:	55                   	push   %ebp
  101034:	89 e5                	mov    %esp,%ebp
  101036:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101039:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101040:	eb 09                	jmp    10104b <lpt_putc_sub+0x18>
        delay();
  101042:	e8 db fd ff ff       	call   100e22 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101047:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10104b:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101051:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101055:	89 c2                	mov    %eax,%edx
  101057:	ec                   	in     (%dx),%al
  101058:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10105b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10105f:	84 c0                	test   %al,%al
  101061:	78 09                	js     10106c <lpt_putc_sub+0x39>
  101063:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10106a:	7e d6                	jle    101042 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  10106c:	8b 45 08             	mov    0x8(%ebp),%eax
  10106f:	0f b6 c0             	movzbl %al,%eax
  101072:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101078:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10107b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10107f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101083:	ee                   	out    %al,(%dx)
  101084:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10108a:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  10108e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101092:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101096:	ee                   	out    %al,(%dx)
  101097:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  10109d:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  1010a1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010a5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010a9:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010aa:	c9                   	leave  
  1010ab:	c3                   	ret    

001010ac <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010ac:	55                   	push   %ebp
  1010ad:	89 e5                	mov    %esp,%ebp
  1010af:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010b2:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010b6:	74 0d                	je     1010c5 <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1010bb:	89 04 24             	mov    %eax,(%esp)
  1010be:	e8 70 ff ff ff       	call   101033 <lpt_putc_sub>
  1010c3:	eb 24                	jmp    1010e9 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  1010c5:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010cc:	e8 62 ff ff ff       	call   101033 <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010d1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010d8:	e8 56 ff ff ff       	call   101033 <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010dd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010e4:	e8 4a ff ff ff       	call   101033 <lpt_putc_sub>
    }
}
  1010e9:	c9                   	leave  
  1010ea:	c3                   	ret    

001010eb <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010eb:	55                   	push   %ebp
  1010ec:	89 e5                	mov    %esp,%ebp
  1010ee:	53                   	push   %ebx
  1010ef:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1010f5:	b0 00                	mov    $0x0,%al
  1010f7:	85 c0                	test   %eax,%eax
  1010f9:	75 07                	jne    101102 <cga_putc+0x17>
        c |= 0x0700;
  1010fb:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101102:	8b 45 08             	mov    0x8(%ebp),%eax
  101105:	0f b6 c0             	movzbl %al,%eax
  101108:	83 f8 0a             	cmp    $0xa,%eax
  10110b:	74 4c                	je     101159 <cga_putc+0x6e>
  10110d:	83 f8 0d             	cmp    $0xd,%eax
  101110:	74 57                	je     101169 <cga_putc+0x7e>
  101112:	83 f8 08             	cmp    $0x8,%eax
  101115:	0f 85 88 00 00 00    	jne    1011a3 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  10111b:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101122:	66 85 c0             	test   %ax,%ax
  101125:	74 30                	je     101157 <cga_putc+0x6c>
            crt_pos --;
  101127:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10112e:	83 e8 01             	sub    $0x1,%eax
  101131:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101137:	a1 80 7e 11 00       	mov    0x117e80,%eax
  10113c:	0f b7 15 84 7e 11 00 	movzwl 0x117e84,%edx
  101143:	0f b7 d2             	movzwl %dx,%edx
  101146:	01 d2                	add    %edx,%edx
  101148:	01 c2                	add    %eax,%edx
  10114a:	8b 45 08             	mov    0x8(%ebp),%eax
  10114d:	b0 00                	mov    $0x0,%al
  10114f:	83 c8 20             	or     $0x20,%eax
  101152:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101155:	eb 72                	jmp    1011c9 <cga_putc+0xde>
  101157:	eb 70                	jmp    1011c9 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101159:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101160:	83 c0 50             	add    $0x50,%eax
  101163:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101169:	0f b7 1d 84 7e 11 00 	movzwl 0x117e84,%ebx
  101170:	0f b7 0d 84 7e 11 00 	movzwl 0x117e84,%ecx
  101177:	0f b7 c1             	movzwl %cx,%eax
  10117a:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101180:	c1 e8 10             	shr    $0x10,%eax
  101183:	89 c2                	mov    %eax,%edx
  101185:	66 c1 ea 06          	shr    $0x6,%dx
  101189:	89 d0                	mov    %edx,%eax
  10118b:	c1 e0 02             	shl    $0x2,%eax
  10118e:	01 d0                	add    %edx,%eax
  101190:	c1 e0 04             	shl    $0x4,%eax
  101193:	29 c1                	sub    %eax,%ecx
  101195:	89 ca                	mov    %ecx,%edx
  101197:	89 d8                	mov    %ebx,%eax
  101199:	29 d0                	sub    %edx,%eax
  10119b:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
        break;
  1011a1:	eb 26                	jmp    1011c9 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011a3:	8b 0d 80 7e 11 00    	mov    0x117e80,%ecx
  1011a9:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011b0:	8d 50 01             	lea    0x1(%eax),%edx
  1011b3:	66 89 15 84 7e 11 00 	mov    %dx,0x117e84
  1011ba:	0f b7 c0             	movzwl %ax,%eax
  1011bd:	01 c0                	add    %eax,%eax
  1011bf:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1011c5:	66 89 02             	mov    %ax,(%edx)
        break;
  1011c8:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011c9:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011d0:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011d4:	76 5b                	jbe    101231 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011d6:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011db:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011e1:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011e6:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011ed:	00 
  1011ee:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011f2:	89 04 24             	mov    %eax,(%esp)
  1011f5:	e8 33 4c 00 00       	call   105e2d <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011fa:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101201:	eb 15                	jmp    101218 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  101203:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101208:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10120b:	01 d2                	add    %edx,%edx
  10120d:	01 d0                	add    %edx,%eax
  10120f:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101214:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101218:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10121f:	7e e2                	jle    101203 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  101221:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101228:	83 e8 50             	sub    $0x50,%eax
  10122b:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101231:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101238:	0f b7 c0             	movzwl %ax,%eax
  10123b:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  10123f:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  101243:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101247:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10124b:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  10124c:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101253:	66 c1 e8 08          	shr    $0x8,%ax
  101257:	0f b6 c0             	movzbl %al,%eax
  10125a:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  101261:	83 c2 01             	add    $0x1,%edx
  101264:	0f b7 d2             	movzwl %dx,%edx
  101267:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  10126b:	88 45 ed             	mov    %al,-0x13(%ebp)
  10126e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101272:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101276:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101277:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  10127e:	0f b7 c0             	movzwl %ax,%eax
  101281:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101285:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101289:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10128d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101291:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101292:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101299:	0f b6 c0             	movzbl %al,%eax
  10129c:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  1012a3:	83 c2 01             	add    $0x1,%edx
  1012a6:	0f b7 d2             	movzwl %dx,%edx
  1012a9:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  1012ad:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1012b0:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012b4:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012b8:	ee                   	out    %al,(%dx)
}
  1012b9:	83 c4 34             	add    $0x34,%esp
  1012bc:	5b                   	pop    %ebx
  1012bd:	5d                   	pop    %ebp
  1012be:	c3                   	ret    

001012bf <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012bf:	55                   	push   %ebp
  1012c0:	89 e5                	mov    %esp,%ebp
  1012c2:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012cc:	eb 09                	jmp    1012d7 <serial_putc_sub+0x18>
        delay();
  1012ce:	e8 4f fb ff ff       	call   100e22 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012d3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012d7:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012dd:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012e1:	89 c2                	mov    %eax,%edx
  1012e3:	ec                   	in     (%dx),%al
  1012e4:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012e7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012eb:	0f b6 c0             	movzbl %al,%eax
  1012ee:	83 e0 20             	and    $0x20,%eax
  1012f1:	85 c0                	test   %eax,%eax
  1012f3:	75 09                	jne    1012fe <serial_putc_sub+0x3f>
  1012f5:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012fc:	7e d0                	jle    1012ce <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1012fe:	8b 45 08             	mov    0x8(%ebp),%eax
  101301:	0f b6 c0             	movzbl %al,%eax
  101304:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10130a:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10130d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101311:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101315:	ee                   	out    %al,(%dx)
}
  101316:	c9                   	leave  
  101317:	c3                   	ret    

00101318 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101318:	55                   	push   %ebp
  101319:	89 e5                	mov    %esp,%ebp
  10131b:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10131e:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101322:	74 0d                	je     101331 <serial_putc+0x19>
        serial_putc_sub(c);
  101324:	8b 45 08             	mov    0x8(%ebp),%eax
  101327:	89 04 24             	mov    %eax,(%esp)
  10132a:	e8 90 ff ff ff       	call   1012bf <serial_putc_sub>
  10132f:	eb 24                	jmp    101355 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  101331:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101338:	e8 82 ff ff ff       	call   1012bf <serial_putc_sub>
        serial_putc_sub(' ');
  10133d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101344:	e8 76 ff ff ff       	call   1012bf <serial_putc_sub>
        serial_putc_sub('\b');
  101349:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101350:	e8 6a ff ff ff       	call   1012bf <serial_putc_sub>
    }
}
  101355:	c9                   	leave  
  101356:	c3                   	ret    

00101357 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101357:	55                   	push   %ebp
  101358:	89 e5                	mov    %esp,%ebp
  10135a:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  10135d:	eb 33                	jmp    101392 <cons_intr+0x3b>
        if (c != 0) {
  10135f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101363:	74 2d                	je     101392 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101365:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  10136a:	8d 50 01             	lea    0x1(%eax),%edx
  10136d:	89 15 a4 80 11 00    	mov    %edx,0x1180a4
  101373:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101376:	88 90 a0 7e 11 00    	mov    %dl,0x117ea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10137c:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101381:	3d 00 02 00 00       	cmp    $0x200,%eax
  101386:	75 0a                	jne    101392 <cons_intr+0x3b>
                cons.wpos = 0;
  101388:	c7 05 a4 80 11 00 00 	movl   $0x0,0x1180a4
  10138f:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101392:	8b 45 08             	mov    0x8(%ebp),%eax
  101395:	ff d0                	call   *%eax
  101397:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10139a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10139e:	75 bf                	jne    10135f <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  1013a0:	c9                   	leave  
  1013a1:	c3                   	ret    

001013a2 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013a2:	55                   	push   %ebp
  1013a3:	89 e5                	mov    %esp,%ebp
  1013a5:	83 ec 10             	sub    $0x10,%esp
  1013a8:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013ae:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013b2:	89 c2                	mov    %eax,%edx
  1013b4:	ec                   	in     (%dx),%al
  1013b5:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013b8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013bc:	0f b6 c0             	movzbl %al,%eax
  1013bf:	83 e0 01             	and    $0x1,%eax
  1013c2:	85 c0                	test   %eax,%eax
  1013c4:	75 07                	jne    1013cd <serial_proc_data+0x2b>
        return -1;
  1013c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013cb:	eb 2a                	jmp    1013f7 <serial_proc_data+0x55>
  1013cd:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013d3:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013d7:	89 c2                	mov    %eax,%edx
  1013d9:	ec                   	in     (%dx),%al
  1013da:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013dd:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013e1:	0f b6 c0             	movzbl %al,%eax
  1013e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013e7:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013eb:	75 07                	jne    1013f4 <serial_proc_data+0x52>
        c = '\b';
  1013ed:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013f7:	c9                   	leave  
  1013f8:	c3                   	ret    

001013f9 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013f9:	55                   	push   %ebp
  1013fa:	89 e5                	mov    %esp,%ebp
  1013fc:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1013ff:	a1 88 7e 11 00       	mov    0x117e88,%eax
  101404:	85 c0                	test   %eax,%eax
  101406:	74 0c                	je     101414 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101408:	c7 04 24 a2 13 10 00 	movl   $0x1013a2,(%esp)
  10140f:	e8 43 ff ff ff       	call   101357 <cons_intr>
    }
}
  101414:	c9                   	leave  
  101415:	c3                   	ret    

00101416 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101416:	55                   	push   %ebp
  101417:	89 e5                	mov    %esp,%ebp
  101419:	83 ec 38             	sub    $0x38,%esp
  10141c:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101422:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101426:	89 c2                	mov    %eax,%edx
  101428:	ec                   	in     (%dx),%al
  101429:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  10142c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101430:	0f b6 c0             	movzbl %al,%eax
  101433:	83 e0 01             	and    $0x1,%eax
  101436:	85 c0                	test   %eax,%eax
  101438:	75 0a                	jne    101444 <kbd_proc_data+0x2e>
        return -1;
  10143a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10143f:	e9 59 01 00 00       	jmp    10159d <kbd_proc_data+0x187>
  101444:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10144a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10144e:	89 c2                	mov    %eax,%edx
  101450:	ec                   	in     (%dx),%al
  101451:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101454:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101458:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  10145b:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  10145f:	75 17                	jne    101478 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101461:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101466:	83 c8 40             	or     $0x40,%eax
  101469:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  10146e:	b8 00 00 00 00       	mov    $0x0,%eax
  101473:	e9 25 01 00 00       	jmp    10159d <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101478:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10147c:	84 c0                	test   %al,%al
  10147e:	79 47                	jns    1014c7 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101480:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101485:	83 e0 40             	and    $0x40,%eax
  101488:	85 c0                	test   %eax,%eax
  10148a:	75 09                	jne    101495 <kbd_proc_data+0x7f>
  10148c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101490:	83 e0 7f             	and    $0x7f,%eax
  101493:	eb 04                	jmp    101499 <kbd_proc_data+0x83>
  101495:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101499:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10149c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a0:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014a7:	83 c8 40             	or     $0x40,%eax
  1014aa:	0f b6 c0             	movzbl %al,%eax
  1014ad:	f7 d0                	not    %eax
  1014af:	89 c2                	mov    %eax,%edx
  1014b1:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014b6:	21 d0                	and    %edx,%eax
  1014b8:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  1014bd:	b8 00 00 00 00       	mov    $0x0,%eax
  1014c2:	e9 d6 00 00 00       	jmp    10159d <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1014c7:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014cc:	83 e0 40             	and    $0x40,%eax
  1014cf:	85 c0                	test   %eax,%eax
  1014d1:	74 11                	je     1014e4 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014d3:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014d7:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014dc:	83 e0 bf             	and    $0xffffffbf,%eax
  1014df:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    }

    shift |= shiftcode[data];
  1014e4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014e8:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014ef:	0f b6 d0             	movzbl %al,%edx
  1014f2:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014f7:	09 d0                	or     %edx,%eax
  1014f9:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    shift ^= togglecode[data];
  1014fe:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101502:	0f b6 80 60 71 11 00 	movzbl 0x117160(%eax),%eax
  101509:	0f b6 d0             	movzbl %al,%edx
  10150c:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101511:	31 d0                	xor    %edx,%eax
  101513:	a3 a8 80 11 00       	mov    %eax,0x1180a8

    c = charcode[shift & (CTL | SHIFT)][data];
  101518:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10151d:	83 e0 03             	and    $0x3,%eax
  101520:	8b 14 85 60 75 11 00 	mov    0x117560(,%eax,4),%edx
  101527:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10152b:	01 d0                	add    %edx,%eax
  10152d:	0f b6 00             	movzbl (%eax),%eax
  101530:	0f b6 c0             	movzbl %al,%eax
  101533:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101536:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10153b:	83 e0 08             	and    $0x8,%eax
  10153e:	85 c0                	test   %eax,%eax
  101540:	74 22                	je     101564 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  101542:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101546:	7e 0c                	jle    101554 <kbd_proc_data+0x13e>
  101548:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  10154c:	7f 06                	jg     101554 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  10154e:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101552:	eb 10                	jmp    101564 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101554:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101558:	7e 0a                	jle    101564 <kbd_proc_data+0x14e>
  10155a:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  10155e:	7f 04                	jg     101564 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101560:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101564:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101569:	f7 d0                	not    %eax
  10156b:	83 e0 06             	and    $0x6,%eax
  10156e:	85 c0                	test   %eax,%eax
  101570:	75 28                	jne    10159a <kbd_proc_data+0x184>
  101572:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101579:	75 1f                	jne    10159a <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  10157b:	c7 04 24 9d 62 10 00 	movl   $0x10629d,(%esp)
  101582:	e8 b5 ed ff ff       	call   10033c <cprintf>
  101587:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10158d:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101591:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101595:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101599:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10159a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10159d:	c9                   	leave  
  10159e:	c3                   	ret    

0010159f <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10159f:	55                   	push   %ebp
  1015a0:	89 e5                	mov    %esp,%ebp
  1015a2:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015a5:	c7 04 24 16 14 10 00 	movl   $0x101416,(%esp)
  1015ac:	e8 a6 fd ff ff       	call   101357 <cons_intr>
}
  1015b1:	c9                   	leave  
  1015b2:	c3                   	ret    

001015b3 <kbd_init>:

static void
kbd_init(void) {
  1015b3:	55                   	push   %ebp
  1015b4:	89 e5                	mov    %esp,%ebp
  1015b6:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015b9:	e8 e1 ff ff ff       	call   10159f <kbd_intr>
    pic_enable(IRQ_KBD);
  1015be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015c5:	e8 3d 01 00 00       	call   101707 <pic_enable>
}
  1015ca:	c9                   	leave  
  1015cb:	c3                   	ret    

001015cc <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015cc:	55                   	push   %ebp
  1015cd:	89 e5                	mov    %esp,%ebp
  1015cf:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015d2:	e8 93 f8 ff ff       	call   100e6a <cga_init>
    serial_init();
  1015d7:	e8 74 f9 ff ff       	call   100f50 <serial_init>
    kbd_init();
  1015dc:	e8 d2 ff ff ff       	call   1015b3 <kbd_init>
    if (!serial_exists) {
  1015e1:	a1 88 7e 11 00       	mov    0x117e88,%eax
  1015e6:	85 c0                	test   %eax,%eax
  1015e8:	75 0c                	jne    1015f6 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015ea:	c7 04 24 a9 62 10 00 	movl   $0x1062a9,(%esp)
  1015f1:	e8 46 ed ff ff       	call   10033c <cprintf>
    }
}
  1015f6:	c9                   	leave  
  1015f7:	c3                   	ret    

001015f8 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015f8:	55                   	push   %ebp
  1015f9:	89 e5                	mov    %esp,%ebp
  1015fb:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  1015fe:	e8 e2 f7 ff ff       	call   100de5 <__intr_save>
  101603:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  101606:	8b 45 08             	mov    0x8(%ebp),%eax
  101609:	89 04 24             	mov    %eax,(%esp)
  10160c:	e8 9b fa ff ff       	call   1010ac <lpt_putc>
        cga_putc(c);
  101611:	8b 45 08             	mov    0x8(%ebp),%eax
  101614:	89 04 24             	mov    %eax,(%esp)
  101617:	e8 cf fa ff ff       	call   1010eb <cga_putc>
        serial_putc(c);
  10161c:	8b 45 08             	mov    0x8(%ebp),%eax
  10161f:	89 04 24             	mov    %eax,(%esp)
  101622:	e8 f1 fc ff ff       	call   101318 <serial_putc>
    }
    local_intr_restore(intr_flag);
  101627:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10162a:	89 04 24             	mov    %eax,(%esp)
  10162d:	e8 dd f7 ff ff       	call   100e0f <__intr_restore>
}
  101632:	c9                   	leave  
  101633:	c3                   	ret    

00101634 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101634:	55                   	push   %ebp
  101635:	89 e5                	mov    %esp,%ebp
  101637:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  10163a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101641:	e8 9f f7 ff ff       	call   100de5 <__intr_save>
  101646:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101649:	e8 ab fd ff ff       	call   1013f9 <serial_intr>
        kbd_intr();
  10164e:	e8 4c ff ff ff       	call   10159f <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101653:	8b 15 a0 80 11 00    	mov    0x1180a0,%edx
  101659:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  10165e:	39 c2                	cmp    %eax,%edx
  101660:	74 31                	je     101693 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  101662:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101667:	8d 50 01             	lea    0x1(%eax),%edx
  10166a:	89 15 a0 80 11 00    	mov    %edx,0x1180a0
  101670:	0f b6 80 a0 7e 11 00 	movzbl 0x117ea0(%eax),%eax
  101677:	0f b6 c0             	movzbl %al,%eax
  10167a:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  10167d:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101682:	3d 00 02 00 00       	cmp    $0x200,%eax
  101687:	75 0a                	jne    101693 <cons_getc+0x5f>
                cons.rpos = 0;
  101689:	c7 05 a0 80 11 00 00 	movl   $0x0,0x1180a0
  101690:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  101693:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101696:	89 04 24             	mov    %eax,(%esp)
  101699:	e8 71 f7 ff ff       	call   100e0f <__intr_restore>
    return c;
  10169e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016a1:	c9                   	leave  
  1016a2:	c3                   	ret    

001016a3 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1016a3:	55                   	push   %ebp
  1016a4:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  1016a6:	fb                   	sti    
    sti();
}
  1016a7:	5d                   	pop    %ebp
  1016a8:	c3                   	ret    

001016a9 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1016a9:	55                   	push   %ebp
  1016aa:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  1016ac:	fa                   	cli    
    cli();
}
  1016ad:	5d                   	pop    %ebp
  1016ae:	c3                   	ret    

001016af <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016af:	55                   	push   %ebp
  1016b0:	89 e5                	mov    %esp,%ebp
  1016b2:	83 ec 14             	sub    $0x14,%esp
  1016b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1016b8:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016bc:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016c0:	66 a3 70 75 11 00    	mov    %ax,0x117570
    if (did_init) {
  1016c6:	a1 ac 80 11 00       	mov    0x1180ac,%eax
  1016cb:	85 c0                	test   %eax,%eax
  1016cd:	74 36                	je     101705 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016cf:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016d3:	0f b6 c0             	movzbl %al,%eax
  1016d6:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016dc:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1016df:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016e3:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016e7:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016e8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016ec:	66 c1 e8 08          	shr    $0x8,%ax
  1016f0:	0f b6 c0             	movzbl %al,%eax
  1016f3:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016f9:	88 45 f9             	mov    %al,-0x7(%ebp)
  1016fc:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101700:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101704:	ee                   	out    %al,(%dx)
    }
}
  101705:	c9                   	leave  
  101706:	c3                   	ret    

00101707 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101707:	55                   	push   %ebp
  101708:	89 e5                	mov    %esp,%ebp
  10170a:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10170d:	8b 45 08             	mov    0x8(%ebp),%eax
  101710:	ba 01 00 00 00       	mov    $0x1,%edx
  101715:	89 c1                	mov    %eax,%ecx
  101717:	d3 e2                	shl    %cl,%edx
  101719:	89 d0                	mov    %edx,%eax
  10171b:	f7 d0                	not    %eax
  10171d:	89 c2                	mov    %eax,%edx
  10171f:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101726:	21 d0                	and    %edx,%eax
  101728:	0f b7 c0             	movzwl %ax,%eax
  10172b:	89 04 24             	mov    %eax,(%esp)
  10172e:	e8 7c ff ff ff       	call   1016af <pic_setmask>
}
  101733:	c9                   	leave  
  101734:	c3                   	ret    

00101735 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101735:	55                   	push   %ebp
  101736:	89 e5                	mov    %esp,%ebp
  101738:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  10173b:	c7 05 ac 80 11 00 01 	movl   $0x1,0x1180ac
  101742:	00 00 00 
  101745:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  10174b:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  10174f:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101753:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101757:	ee                   	out    %al,(%dx)
  101758:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10175e:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  101762:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101766:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10176a:	ee                   	out    %al,(%dx)
  10176b:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101771:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  101775:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101779:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10177d:	ee                   	out    %al,(%dx)
  10177e:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  101784:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  101788:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10178c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101790:	ee                   	out    %al,(%dx)
  101791:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  101797:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  10179b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10179f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017a3:	ee                   	out    %al,(%dx)
  1017a4:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1017aa:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1017ae:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017b2:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017b6:	ee                   	out    %al,(%dx)
  1017b7:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1017bd:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  1017c1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017c5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017c9:	ee                   	out    %al,(%dx)
  1017ca:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  1017d0:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  1017d4:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017d8:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017dc:	ee                   	out    %al,(%dx)
  1017dd:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  1017e3:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  1017e7:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017eb:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017ef:	ee                   	out    %al,(%dx)
  1017f0:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  1017f6:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  1017fa:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1017fe:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101802:	ee                   	out    %al,(%dx)
  101803:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101809:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  10180d:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101811:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101815:	ee                   	out    %al,(%dx)
  101816:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10181c:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  101820:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101824:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101828:	ee                   	out    %al,(%dx)
  101829:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  10182f:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  101833:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101837:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  10183b:	ee                   	out    %al,(%dx)
  10183c:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  101842:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  101846:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  10184a:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  10184e:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  10184f:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101856:	66 83 f8 ff          	cmp    $0xffff,%ax
  10185a:	74 12                	je     10186e <pic_init+0x139>
        pic_setmask(irq_mask);
  10185c:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101863:	0f b7 c0             	movzwl %ax,%eax
  101866:	89 04 24             	mov    %eax,(%esp)
  101869:	e8 41 fe ff ff       	call   1016af <pic_setmask>
    }
}
  10186e:	c9                   	leave  
  10186f:	c3                   	ret    

00101870 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101870:	55                   	push   %ebp
  101871:	89 e5                	mov    %esp,%ebp
  101873:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101876:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  10187d:	00 
  10187e:	c7 04 24 e0 62 10 00 	movl   $0x1062e0,(%esp)
  101885:	e8 b2 ea ff ff       	call   10033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  10188a:	c7 04 24 ea 62 10 00 	movl   $0x1062ea,(%esp)
  101891:	e8 a6 ea ff ff       	call   10033c <cprintf>
    panic("EOT: kernel seems ok.");
  101896:	c7 44 24 08 f8 62 10 	movl   $0x1062f8,0x8(%esp)
  10189d:	00 
  10189e:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  1018a5:	00 
  1018a6:	c7 04 24 0e 63 10 00 	movl   $0x10630e,(%esp)
  1018ad:	e8 14 f4 ff ff       	call   100cc6 <__panic>

001018b2 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018b2:	55                   	push   %ebp
  1018b3:	89 e5                	mov    %esp,%ebp
  1018b5:	83 ec 10             	sub    $0x10,%esp
	extern uintptr_t __vectors[];
        int i = 0;
  1018b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        for(i = 0; i < 256; i++)
  1018bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018c6:	e9 c3 00 00 00       	jmp    10198e <idt_init+0xdc>
	{
	SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1018cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ce:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  1018d5:	89 c2                	mov    %eax,%edx
  1018d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018da:	66 89 14 c5 c0 80 11 	mov    %dx,0x1180c0(,%eax,8)
  1018e1:	00 
  1018e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e5:	66 c7 04 c5 c2 80 11 	movw   $0x8,0x1180c2(,%eax,8)
  1018ec:	00 08 00 
  1018ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f2:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018f9:	00 
  1018fa:	83 e2 e0             	and    $0xffffffe0,%edx
  1018fd:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  101904:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101907:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  10190e:	00 
  10190f:	83 e2 1f             	and    $0x1f,%edx
  101912:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  101919:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10191c:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101923:	00 
  101924:	83 e2 f0             	and    $0xfffffff0,%edx
  101927:	83 ca 0e             	or     $0xe,%edx
  10192a:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101931:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101934:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10193b:	00 
  10193c:	83 e2 ef             	and    $0xffffffef,%edx
  10193f:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101946:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101949:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101950:	00 
  101951:	83 e2 9f             	and    $0xffffff9f,%edx
  101954:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10195b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10195e:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101965:	00 
  101966:	83 ca 80             	or     $0xffffff80,%edx
  101969:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101970:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101973:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  10197a:	c1 e8 10             	shr    $0x10,%eax
  10197d:	89 c2                	mov    %eax,%edx
  10197f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101982:	66 89 14 c5 c6 80 11 	mov    %dx,0x1180c6(,%eax,8)
  101989:	00 
/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
	extern uintptr_t __vectors[];
        int i = 0;
        for(i = 0; i < 256; i++)
  10198a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10198e:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  101995:	0f 8e 30 ff ff ff    	jle    1018cb <idt_init+0x19>
	{
	SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
	}
	SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  10199b:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  1019a0:	66 a3 88 84 11 00    	mov    %ax,0x118488
  1019a6:	66 c7 05 8a 84 11 00 	movw   $0x8,0x11848a
  1019ad:	08 00 
  1019af:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  1019b6:	83 e0 e0             	and    $0xffffffe0,%eax
  1019b9:	a2 8c 84 11 00       	mov    %al,0x11848c
  1019be:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  1019c5:	83 e0 1f             	and    $0x1f,%eax
  1019c8:	a2 8c 84 11 00       	mov    %al,0x11848c
  1019cd:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019d4:	83 e0 f0             	and    $0xfffffff0,%eax
  1019d7:	83 c8 0e             	or     $0xe,%eax
  1019da:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019df:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019e6:	83 e0 ef             	and    $0xffffffef,%eax
  1019e9:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019ee:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019f5:	83 c8 60             	or     $0x60,%eax
  1019f8:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019fd:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  101a04:	83 c8 80             	or     $0xffffff80,%eax
  101a07:	a2 8d 84 11 00       	mov    %al,0x11848d
  101a0c:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  101a11:	c1 e8 10             	shr    $0x10,%eax
  101a14:	66 a3 8e 84 11 00    	mov    %ax,0x11848e
  101a1a:	c7 45 f8 80 75 11 00 	movl   $0x117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101a21:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a24:	0f 01 18             	lidtl  (%eax)
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
}
  101a27:	c9                   	leave  
  101a28:	c3                   	ret    

00101a29 <trapname>:

static const char *
trapname(int trapno) {
  101a29:	55                   	push   %ebp
  101a2a:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a2f:	83 f8 13             	cmp    $0x13,%eax
  101a32:	77 0c                	ja     101a40 <trapname+0x17>
        return excnames[trapno];
  101a34:	8b 45 08             	mov    0x8(%ebp),%eax
  101a37:	8b 04 85 60 66 10 00 	mov    0x106660(,%eax,4),%eax
  101a3e:	eb 18                	jmp    101a58 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a40:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a44:	7e 0d                	jle    101a53 <trapname+0x2a>
  101a46:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a4a:	7f 07                	jg     101a53 <trapname+0x2a>
        return "Hardware Interrupt";
  101a4c:	b8 1f 63 10 00       	mov    $0x10631f,%eax
  101a51:	eb 05                	jmp    101a58 <trapname+0x2f>
    }
    return "(unknown trap)";
  101a53:	b8 32 63 10 00       	mov    $0x106332,%eax
}
  101a58:	5d                   	pop    %ebp
  101a59:	c3                   	ret    

00101a5a <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a5a:	55                   	push   %ebp
  101a5b:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a60:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a64:	66 83 f8 08          	cmp    $0x8,%ax
  101a68:	0f 94 c0             	sete   %al
  101a6b:	0f b6 c0             	movzbl %al,%eax
}
  101a6e:	5d                   	pop    %ebp
  101a6f:	c3                   	ret    

00101a70 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a70:	55                   	push   %ebp
  101a71:	89 e5                	mov    %esp,%ebp
  101a73:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a76:	8b 45 08             	mov    0x8(%ebp),%eax
  101a79:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a7d:	c7 04 24 73 63 10 00 	movl   $0x106373,(%esp)
  101a84:	e8 b3 e8 ff ff       	call   10033c <cprintf>
    print_regs(&tf->tf_regs);
  101a89:	8b 45 08             	mov    0x8(%ebp),%eax
  101a8c:	89 04 24             	mov    %eax,(%esp)
  101a8f:	e8 a1 01 00 00       	call   101c35 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a94:	8b 45 08             	mov    0x8(%ebp),%eax
  101a97:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a9b:	0f b7 c0             	movzwl %ax,%eax
  101a9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aa2:	c7 04 24 84 63 10 00 	movl   $0x106384,(%esp)
  101aa9:	e8 8e e8 ff ff       	call   10033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101aae:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab1:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101ab5:	0f b7 c0             	movzwl %ax,%eax
  101ab8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101abc:	c7 04 24 97 63 10 00 	movl   $0x106397,(%esp)
  101ac3:	e8 74 e8 ff ff       	call   10033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  101acb:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101acf:	0f b7 c0             	movzwl %ax,%eax
  101ad2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ad6:	c7 04 24 aa 63 10 00 	movl   $0x1063aa,(%esp)
  101add:	e8 5a e8 ff ff       	call   10033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae5:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101ae9:	0f b7 c0             	movzwl %ax,%eax
  101aec:	89 44 24 04          	mov    %eax,0x4(%esp)
  101af0:	c7 04 24 bd 63 10 00 	movl   $0x1063bd,(%esp)
  101af7:	e8 40 e8 ff ff       	call   10033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101afc:	8b 45 08             	mov    0x8(%ebp),%eax
  101aff:	8b 40 30             	mov    0x30(%eax),%eax
  101b02:	89 04 24             	mov    %eax,(%esp)
  101b05:	e8 1f ff ff ff       	call   101a29 <trapname>
  101b0a:	8b 55 08             	mov    0x8(%ebp),%edx
  101b0d:	8b 52 30             	mov    0x30(%edx),%edx
  101b10:	89 44 24 08          	mov    %eax,0x8(%esp)
  101b14:	89 54 24 04          	mov    %edx,0x4(%esp)
  101b18:	c7 04 24 d0 63 10 00 	movl   $0x1063d0,(%esp)
  101b1f:	e8 18 e8 ff ff       	call   10033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b24:	8b 45 08             	mov    0x8(%ebp),%eax
  101b27:	8b 40 34             	mov    0x34(%eax),%eax
  101b2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b2e:	c7 04 24 e2 63 10 00 	movl   $0x1063e2,(%esp)
  101b35:	e8 02 e8 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b3d:	8b 40 38             	mov    0x38(%eax),%eax
  101b40:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b44:	c7 04 24 f1 63 10 00 	movl   $0x1063f1,(%esp)
  101b4b:	e8 ec e7 ff ff       	call   10033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b50:	8b 45 08             	mov    0x8(%ebp),%eax
  101b53:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b57:	0f b7 c0             	movzwl %ax,%eax
  101b5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b5e:	c7 04 24 00 64 10 00 	movl   $0x106400,(%esp)
  101b65:	e8 d2 e7 ff ff       	call   10033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b6d:	8b 40 40             	mov    0x40(%eax),%eax
  101b70:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b74:	c7 04 24 13 64 10 00 	movl   $0x106413,(%esp)
  101b7b:	e8 bc e7 ff ff       	call   10033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b80:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b87:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b8e:	eb 3e                	jmp    101bce <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b90:	8b 45 08             	mov    0x8(%ebp),%eax
  101b93:	8b 50 40             	mov    0x40(%eax),%edx
  101b96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b99:	21 d0                	and    %edx,%eax
  101b9b:	85 c0                	test   %eax,%eax
  101b9d:	74 28                	je     101bc7 <print_trapframe+0x157>
  101b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ba2:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101ba9:	85 c0                	test   %eax,%eax
  101bab:	74 1a                	je     101bc7 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bb0:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101bb7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bbb:	c7 04 24 22 64 10 00 	movl   $0x106422,(%esp)
  101bc2:	e8 75 e7 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bc7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101bcb:	d1 65 f0             	shll   -0x10(%ebp)
  101bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bd1:	83 f8 17             	cmp    $0x17,%eax
  101bd4:	76 ba                	jbe    101b90 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd9:	8b 40 40             	mov    0x40(%eax),%eax
  101bdc:	25 00 30 00 00       	and    $0x3000,%eax
  101be1:	c1 e8 0c             	shr    $0xc,%eax
  101be4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be8:	c7 04 24 26 64 10 00 	movl   $0x106426,(%esp)
  101bef:	e8 48 e7 ff ff       	call   10033c <cprintf>

    if (!trap_in_kernel(tf)) {
  101bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf7:	89 04 24             	mov    %eax,(%esp)
  101bfa:	e8 5b fe ff ff       	call   101a5a <trap_in_kernel>
  101bff:	85 c0                	test   %eax,%eax
  101c01:	75 30                	jne    101c33 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c03:	8b 45 08             	mov    0x8(%ebp),%eax
  101c06:	8b 40 44             	mov    0x44(%eax),%eax
  101c09:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c0d:	c7 04 24 2f 64 10 00 	movl   $0x10642f,(%esp)
  101c14:	e8 23 e7 ff ff       	call   10033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c19:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1c:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c20:	0f b7 c0             	movzwl %ax,%eax
  101c23:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c27:	c7 04 24 3e 64 10 00 	movl   $0x10643e,(%esp)
  101c2e:	e8 09 e7 ff ff       	call   10033c <cprintf>
    }
}
  101c33:	c9                   	leave  
  101c34:	c3                   	ret    

00101c35 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c35:	55                   	push   %ebp
  101c36:	89 e5                	mov    %esp,%ebp
  101c38:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c3e:	8b 00                	mov    (%eax),%eax
  101c40:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c44:	c7 04 24 51 64 10 00 	movl   $0x106451,(%esp)
  101c4b:	e8 ec e6 ff ff       	call   10033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c50:	8b 45 08             	mov    0x8(%ebp),%eax
  101c53:	8b 40 04             	mov    0x4(%eax),%eax
  101c56:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c5a:	c7 04 24 60 64 10 00 	movl   $0x106460,(%esp)
  101c61:	e8 d6 e6 ff ff       	call   10033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c66:	8b 45 08             	mov    0x8(%ebp),%eax
  101c69:	8b 40 08             	mov    0x8(%eax),%eax
  101c6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c70:	c7 04 24 6f 64 10 00 	movl   $0x10646f,(%esp)
  101c77:	e8 c0 e6 ff ff       	call   10033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c7f:	8b 40 0c             	mov    0xc(%eax),%eax
  101c82:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c86:	c7 04 24 7e 64 10 00 	movl   $0x10647e,(%esp)
  101c8d:	e8 aa e6 ff ff       	call   10033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c92:	8b 45 08             	mov    0x8(%ebp),%eax
  101c95:	8b 40 10             	mov    0x10(%eax),%eax
  101c98:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c9c:	c7 04 24 8d 64 10 00 	movl   $0x10648d,(%esp)
  101ca3:	e8 94 e6 ff ff       	call   10033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  101cab:	8b 40 14             	mov    0x14(%eax),%eax
  101cae:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cb2:	c7 04 24 9c 64 10 00 	movl   $0x10649c,(%esp)
  101cb9:	e8 7e e6 ff ff       	call   10033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc1:	8b 40 18             	mov    0x18(%eax),%eax
  101cc4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cc8:	c7 04 24 ab 64 10 00 	movl   $0x1064ab,(%esp)
  101ccf:	e8 68 e6 ff ff       	call   10033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd7:	8b 40 1c             	mov    0x1c(%eax),%eax
  101cda:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cde:	c7 04 24 ba 64 10 00 	movl   $0x1064ba,(%esp)
  101ce5:	e8 52 e6 ff ff       	call   10033c <cprintf>
}
  101cea:	c9                   	leave  
  101ceb:	c3                   	ret    

00101cec <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101cec:	55                   	push   %ebp
  101ced:	89 e5                	mov    %esp,%ebp
  101cef:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf5:	8b 40 30             	mov    0x30(%eax),%eax
  101cf8:	83 f8 2f             	cmp    $0x2f,%eax
  101cfb:	77 21                	ja     101d1e <trap_dispatch+0x32>
  101cfd:	83 f8 2e             	cmp    $0x2e,%eax
  101d00:	0f 83 04 01 00 00    	jae    101e0a <trap_dispatch+0x11e>
  101d06:	83 f8 21             	cmp    $0x21,%eax
  101d09:	0f 84 81 00 00 00    	je     101d90 <trap_dispatch+0xa4>
  101d0f:	83 f8 24             	cmp    $0x24,%eax
  101d12:	74 56                	je     101d6a <trap_dispatch+0x7e>
  101d14:	83 f8 20             	cmp    $0x20,%eax
  101d17:	74 16                	je     101d2f <trap_dispatch+0x43>
  101d19:	e9 b4 00 00 00       	jmp    101dd2 <trap_dispatch+0xe6>
  101d1e:	83 e8 78             	sub    $0x78,%eax
  101d21:	83 f8 01             	cmp    $0x1,%eax
  101d24:	0f 87 a8 00 00 00    	ja     101dd2 <trap_dispatch+0xe6>
  101d2a:	e9 87 00 00 00       	jmp    101db6 <trap_dispatch+0xca>
    case IRQ_OFFSET + IRQ_TIMER:
	ticks++;
  101d2f:	a1 4c 89 11 00       	mov    0x11894c,%eax
  101d34:	83 c0 01             	add    $0x1,%eax
  101d37:	a3 4c 89 11 00       	mov    %eax,0x11894c
	if(ticks%TICK_NUM == 0){
  101d3c:	8b 0d 4c 89 11 00    	mov    0x11894c,%ecx
  101d42:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d47:	89 c8                	mov    %ecx,%eax
  101d49:	f7 e2                	mul    %edx
  101d4b:	89 d0                	mov    %edx,%eax
  101d4d:	c1 e8 05             	shr    $0x5,%eax
  101d50:	6b c0 64             	imul   $0x64,%eax,%eax
  101d53:	29 c1                	sub    %eax,%ecx
  101d55:	89 c8                	mov    %ecx,%eax
  101d57:	85 c0                	test   %eax,%eax
  101d59:	75 0a                	jne    101d65 <trap_dispatch+0x79>
	print_ticks();
  101d5b:	e8 10 fb ff ff       	call   101870 <print_ticks>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
  101d60:	e9 a6 00 00 00       	jmp    101e0b <trap_dispatch+0x11f>
  101d65:	e9 a1 00 00 00       	jmp    101e0b <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d6a:	e8 c5 f8 ff ff       	call   101634 <cons_getc>
  101d6f:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d72:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d76:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d7a:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d82:	c7 04 24 c9 64 10 00 	movl   $0x1064c9,(%esp)
  101d89:	e8 ae e5 ff ff       	call   10033c <cprintf>
        break;
  101d8e:	eb 7b                	jmp    101e0b <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d90:	e8 9f f8 ff ff       	call   101634 <cons_getc>
  101d95:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d98:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d9c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101da0:	89 54 24 08          	mov    %edx,0x8(%esp)
  101da4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101da8:	c7 04 24 db 64 10 00 	movl   $0x1064db,(%esp)
  101daf:	e8 88 e5 ff ff       	call   10033c <cprintf>
        break;
  101db4:	eb 55                	jmp    101e0b <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101db6:	c7 44 24 08 ea 64 10 	movl   $0x1064ea,0x8(%esp)
  101dbd:	00 
  101dbe:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
  101dc5:	00 
  101dc6:	c7 04 24 0e 63 10 00 	movl   $0x10630e,(%esp)
  101dcd:	e8 f4 ee ff ff       	call   100cc6 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  101dd5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101dd9:	0f b7 c0             	movzwl %ax,%eax
  101ddc:	83 e0 03             	and    $0x3,%eax
  101ddf:	85 c0                	test   %eax,%eax
  101de1:	75 28                	jne    101e0b <trap_dispatch+0x11f>
            print_trapframe(tf);
  101de3:	8b 45 08             	mov    0x8(%ebp),%eax
  101de6:	89 04 24             	mov    %eax,(%esp)
  101de9:	e8 82 fc ff ff       	call   101a70 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101dee:	c7 44 24 08 fa 64 10 	movl   $0x1064fa,0x8(%esp)
  101df5:	00 
  101df6:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
  101dfd:	00 
  101dfe:	c7 04 24 0e 63 10 00 	movl   $0x10630e,(%esp)
  101e05:	e8 bc ee ff ff       	call   100cc6 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101e0a:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101e0b:	c9                   	leave  
  101e0c:	c3                   	ret    

00101e0d <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101e0d:	55                   	push   %ebp
  101e0e:	89 e5                	mov    %esp,%ebp
  101e10:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101e13:	8b 45 08             	mov    0x8(%ebp),%eax
  101e16:	89 04 24             	mov    %eax,(%esp)
  101e19:	e8 ce fe ff ff       	call   101cec <trap_dispatch>
}
  101e1e:	c9                   	leave  
  101e1f:	c3                   	ret    

00101e20 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101e20:	1e                   	push   %ds
    pushl %es
  101e21:	06                   	push   %es
    pushl %fs
  101e22:	0f a0                	push   %fs
    pushl %gs
  101e24:	0f a8                	push   %gs
    pushal
  101e26:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101e27:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101e2c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101e2e:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101e30:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101e31:	e8 d7 ff ff ff       	call   101e0d <trap>

    # pop the pushed stack pointer
    popl %esp
  101e36:	5c                   	pop    %esp

00101e37 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101e37:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101e38:	0f a9                	pop    %gs
    popl %fs
  101e3a:	0f a1                	pop    %fs
    popl %es
  101e3c:	07                   	pop    %es
    popl %ds
  101e3d:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101e3e:	83 c4 08             	add    $0x8,%esp
    iret
  101e41:	cf                   	iret   

00101e42 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101e42:	6a 00                	push   $0x0
  pushl $0
  101e44:	6a 00                	push   $0x0
  jmp __alltraps
  101e46:	e9 d5 ff ff ff       	jmp    101e20 <__alltraps>

00101e4b <vector1>:
.globl vector1
vector1:
  pushl $0
  101e4b:	6a 00                	push   $0x0
  pushl $1
  101e4d:	6a 01                	push   $0x1
  jmp __alltraps
  101e4f:	e9 cc ff ff ff       	jmp    101e20 <__alltraps>

00101e54 <vector2>:
.globl vector2
vector2:
  pushl $0
  101e54:	6a 00                	push   $0x0
  pushl $2
  101e56:	6a 02                	push   $0x2
  jmp __alltraps
  101e58:	e9 c3 ff ff ff       	jmp    101e20 <__alltraps>

00101e5d <vector3>:
.globl vector3
vector3:
  pushl $0
  101e5d:	6a 00                	push   $0x0
  pushl $3
  101e5f:	6a 03                	push   $0x3
  jmp __alltraps
  101e61:	e9 ba ff ff ff       	jmp    101e20 <__alltraps>

00101e66 <vector4>:
.globl vector4
vector4:
  pushl $0
  101e66:	6a 00                	push   $0x0
  pushl $4
  101e68:	6a 04                	push   $0x4
  jmp __alltraps
  101e6a:	e9 b1 ff ff ff       	jmp    101e20 <__alltraps>

00101e6f <vector5>:
.globl vector5
vector5:
  pushl $0
  101e6f:	6a 00                	push   $0x0
  pushl $5
  101e71:	6a 05                	push   $0x5
  jmp __alltraps
  101e73:	e9 a8 ff ff ff       	jmp    101e20 <__alltraps>

00101e78 <vector6>:
.globl vector6
vector6:
  pushl $0
  101e78:	6a 00                	push   $0x0
  pushl $6
  101e7a:	6a 06                	push   $0x6
  jmp __alltraps
  101e7c:	e9 9f ff ff ff       	jmp    101e20 <__alltraps>

00101e81 <vector7>:
.globl vector7
vector7:
  pushl $0
  101e81:	6a 00                	push   $0x0
  pushl $7
  101e83:	6a 07                	push   $0x7
  jmp __alltraps
  101e85:	e9 96 ff ff ff       	jmp    101e20 <__alltraps>

00101e8a <vector8>:
.globl vector8
vector8:
  pushl $8
  101e8a:	6a 08                	push   $0x8
  jmp __alltraps
  101e8c:	e9 8f ff ff ff       	jmp    101e20 <__alltraps>

00101e91 <vector9>:
.globl vector9
vector9:
  pushl $9
  101e91:	6a 09                	push   $0x9
  jmp __alltraps
  101e93:	e9 88 ff ff ff       	jmp    101e20 <__alltraps>

00101e98 <vector10>:
.globl vector10
vector10:
  pushl $10
  101e98:	6a 0a                	push   $0xa
  jmp __alltraps
  101e9a:	e9 81 ff ff ff       	jmp    101e20 <__alltraps>

00101e9f <vector11>:
.globl vector11
vector11:
  pushl $11
  101e9f:	6a 0b                	push   $0xb
  jmp __alltraps
  101ea1:	e9 7a ff ff ff       	jmp    101e20 <__alltraps>

00101ea6 <vector12>:
.globl vector12
vector12:
  pushl $12
  101ea6:	6a 0c                	push   $0xc
  jmp __alltraps
  101ea8:	e9 73 ff ff ff       	jmp    101e20 <__alltraps>

00101ead <vector13>:
.globl vector13
vector13:
  pushl $13
  101ead:	6a 0d                	push   $0xd
  jmp __alltraps
  101eaf:	e9 6c ff ff ff       	jmp    101e20 <__alltraps>

00101eb4 <vector14>:
.globl vector14
vector14:
  pushl $14
  101eb4:	6a 0e                	push   $0xe
  jmp __alltraps
  101eb6:	e9 65 ff ff ff       	jmp    101e20 <__alltraps>

00101ebb <vector15>:
.globl vector15
vector15:
  pushl $0
  101ebb:	6a 00                	push   $0x0
  pushl $15
  101ebd:	6a 0f                	push   $0xf
  jmp __alltraps
  101ebf:	e9 5c ff ff ff       	jmp    101e20 <__alltraps>

00101ec4 <vector16>:
.globl vector16
vector16:
  pushl $0
  101ec4:	6a 00                	push   $0x0
  pushl $16
  101ec6:	6a 10                	push   $0x10
  jmp __alltraps
  101ec8:	e9 53 ff ff ff       	jmp    101e20 <__alltraps>

00101ecd <vector17>:
.globl vector17
vector17:
  pushl $17
  101ecd:	6a 11                	push   $0x11
  jmp __alltraps
  101ecf:	e9 4c ff ff ff       	jmp    101e20 <__alltraps>

00101ed4 <vector18>:
.globl vector18
vector18:
  pushl $0
  101ed4:	6a 00                	push   $0x0
  pushl $18
  101ed6:	6a 12                	push   $0x12
  jmp __alltraps
  101ed8:	e9 43 ff ff ff       	jmp    101e20 <__alltraps>

00101edd <vector19>:
.globl vector19
vector19:
  pushl $0
  101edd:	6a 00                	push   $0x0
  pushl $19
  101edf:	6a 13                	push   $0x13
  jmp __alltraps
  101ee1:	e9 3a ff ff ff       	jmp    101e20 <__alltraps>

00101ee6 <vector20>:
.globl vector20
vector20:
  pushl $0
  101ee6:	6a 00                	push   $0x0
  pushl $20
  101ee8:	6a 14                	push   $0x14
  jmp __alltraps
  101eea:	e9 31 ff ff ff       	jmp    101e20 <__alltraps>

00101eef <vector21>:
.globl vector21
vector21:
  pushl $0
  101eef:	6a 00                	push   $0x0
  pushl $21
  101ef1:	6a 15                	push   $0x15
  jmp __alltraps
  101ef3:	e9 28 ff ff ff       	jmp    101e20 <__alltraps>

00101ef8 <vector22>:
.globl vector22
vector22:
  pushl $0
  101ef8:	6a 00                	push   $0x0
  pushl $22
  101efa:	6a 16                	push   $0x16
  jmp __alltraps
  101efc:	e9 1f ff ff ff       	jmp    101e20 <__alltraps>

00101f01 <vector23>:
.globl vector23
vector23:
  pushl $0
  101f01:	6a 00                	push   $0x0
  pushl $23
  101f03:	6a 17                	push   $0x17
  jmp __alltraps
  101f05:	e9 16 ff ff ff       	jmp    101e20 <__alltraps>

00101f0a <vector24>:
.globl vector24
vector24:
  pushl $0
  101f0a:	6a 00                	push   $0x0
  pushl $24
  101f0c:	6a 18                	push   $0x18
  jmp __alltraps
  101f0e:	e9 0d ff ff ff       	jmp    101e20 <__alltraps>

00101f13 <vector25>:
.globl vector25
vector25:
  pushl $0
  101f13:	6a 00                	push   $0x0
  pushl $25
  101f15:	6a 19                	push   $0x19
  jmp __alltraps
  101f17:	e9 04 ff ff ff       	jmp    101e20 <__alltraps>

00101f1c <vector26>:
.globl vector26
vector26:
  pushl $0
  101f1c:	6a 00                	push   $0x0
  pushl $26
  101f1e:	6a 1a                	push   $0x1a
  jmp __alltraps
  101f20:	e9 fb fe ff ff       	jmp    101e20 <__alltraps>

00101f25 <vector27>:
.globl vector27
vector27:
  pushl $0
  101f25:	6a 00                	push   $0x0
  pushl $27
  101f27:	6a 1b                	push   $0x1b
  jmp __alltraps
  101f29:	e9 f2 fe ff ff       	jmp    101e20 <__alltraps>

00101f2e <vector28>:
.globl vector28
vector28:
  pushl $0
  101f2e:	6a 00                	push   $0x0
  pushl $28
  101f30:	6a 1c                	push   $0x1c
  jmp __alltraps
  101f32:	e9 e9 fe ff ff       	jmp    101e20 <__alltraps>

00101f37 <vector29>:
.globl vector29
vector29:
  pushl $0
  101f37:	6a 00                	push   $0x0
  pushl $29
  101f39:	6a 1d                	push   $0x1d
  jmp __alltraps
  101f3b:	e9 e0 fe ff ff       	jmp    101e20 <__alltraps>

00101f40 <vector30>:
.globl vector30
vector30:
  pushl $0
  101f40:	6a 00                	push   $0x0
  pushl $30
  101f42:	6a 1e                	push   $0x1e
  jmp __alltraps
  101f44:	e9 d7 fe ff ff       	jmp    101e20 <__alltraps>

00101f49 <vector31>:
.globl vector31
vector31:
  pushl $0
  101f49:	6a 00                	push   $0x0
  pushl $31
  101f4b:	6a 1f                	push   $0x1f
  jmp __alltraps
  101f4d:	e9 ce fe ff ff       	jmp    101e20 <__alltraps>

00101f52 <vector32>:
.globl vector32
vector32:
  pushl $0
  101f52:	6a 00                	push   $0x0
  pushl $32
  101f54:	6a 20                	push   $0x20
  jmp __alltraps
  101f56:	e9 c5 fe ff ff       	jmp    101e20 <__alltraps>

00101f5b <vector33>:
.globl vector33
vector33:
  pushl $0
  101f5b:	6a 00                	push   $0x0
  pushl $33
  101f5d:	6a 21                	push   $0x21
  jmp __alltraps
  101f5f:	e9 bc fe ff ff       	jmp    101e20 <__alltraps>

00101f64 <vector34>:
.globl vector34
vector34:
  pushl $0
  101f64:	6a 00                	push   $0x0
  pushl $34
  101f66:	6a 22                	push   $0x22
  jmp __alltraps
  101f68:	e9 b3 fe ff ff       	jmp    101e20 <__alltraps>

00101f6d <vector35>:
.globl vector35
vector35:
  pushl $0
  101f6d:	6a 00                	push   $0x0
  pushl $35
  101f6f:	6a 23                	push   $0x23
  jmp __alltraps
  101f71:	e9 aa fe ff ff       	jmp    101e20 <__alltraps>

00101f76 <vector36>:
.globl vector36
vector36:
  pushl $0
  101f76:	6a 00                	push   $0x0
  pushl $36
  101f78:	6a 24                	push   $0x24
  jmp __alltraps
  101f7a:	e9 a1 fe ff ff       	jmp    101e20 <__alltraps>

00101f7f <vector37>:
.globl vector37
vector37:
  pushl $0
  101f7f:	6a 00                	push   $0x0
  pushl $37
  101f81:	6a 25                	push   $0x25
  jmp __alltraps
  101f83:	e9 98 fe ff ff       	jmp    101e20 <__alltraps>

00101f88 <vector38>:
.globl vector38
vector38:
  pushl $0
  101f88:	6a 00                	push   $0x0
  pushl $38
  101f8a:	6a 26                	push   $0x26
  jmp __alltraps
  101f8c:	e9 8f fe ff ff       	jmp    101e20 <__alltraps>

00101f91 <vector39>:
.globl vector39
vector39:
  pushl $0
  101f91:	6a 00                	push   $0x0
  pushl $39
  101f93:	6a 27                	push   $0x27
  jmp __alltraps
  101f95:	e9 86 fe ff ff       	jmp    101e20 <__alltraps>

00101f9a <vector40>:
.globl vector40
vector40:
  pushl $0
  101f9a:	6a 00                	push   $0x0
  pushl $40
  101f9c:	6a 28                	push   $0x28
  jmp __alltraps
  101f9e:	e9 7d fe ff ff       	jmp    101e20 <__alltraps>

00101fa3 <vector41>:
.globl vector41
vector41:
  pushl $0
  101fa3:	6a 00                	push   $0x0
  pushl $41
  101fa5:	6a 29                	push   $0x29
  jmp __alltraps
  101fa7:	e9 74 fe ff ff       	jmp    101e20 <__alltraps>

00101fac <vector42>:
.globl vector42
vector42:
  pushl $0
  101fac:	6a 00                	push   $0x0
  pushl $42
  101fae:	6a 2a                	push   $0x2a
  jmp __alltraps
  101fb0:	e9 6b fe ff ff       	jmp    101e20 <__alltraps>

00101fb5 <vector43>:
.globl vector43
vector43:
  pushl $0
  101fb5:	6a 00                	push   $0x0
  pushl $43
  101fb7:	6a 2b                	push   $0x2b
  jmp __alltraps
  101fb9:	e9 62 fe ff ff       	jmp    101e20 <__alltraps>

00101fbe <vector44>:
.globl vector44
vector44:
  pushl $0
  101fbe:	6a 00                	push   $0x0
  pushl $44
  101fc0:	6a 2c                	push   $0x2c
  jmp __alltraps
  101fc2:	e9 59 fe ff ff       	jmp    101e20 <__alltraps>

00101fc7 <vector45>:
.globl vector45
vector45:
  pushl $0
  101fc7:	6a 00                	push   $0x0
  pushl $45
  101fc9:	6a 2d                	push   $0x2d
  jmp __alltraps
  101fcb:	e9 50 fe ff ff       	jmp    101e20 <__alltraps>

00101fd0 <vector46>:
.globl vector46
vector46:
  pushl $0
  101fd0:	6a 00                	push   $0x0
  pushl $46
  101fd2:	6a 2e                	push   $0x2e
  jmp __alltraps
  101fd4:	e9 47 fe ff ff       	jmp    101e20 <__alltraps>

00101fd9 <vector47>:
.globl vector47
vector47:
  pushl $0
  101fd9:	6a 00                	push   $0x0
  pushl $47
  101fdb:	6a 2f                	push   $0x2f
  jmp __alltraps
  101fdd:	e9 3e fe ff ff       	jmp    101e20 <__alltraps>

00101fe2 <vector48>:
.globl vector48
vector48:
  pushl $0
  101fe2:	6a 00                	push   $0x0
  pushl $48
  101fe4:	6a 30                	push   $0x30
  jmp __alltraps
  101fe6:	e9 35 fe ff ff       	jmp    101e20 <__alltraps>

00101feb <vector49>:
.globl vector49
vector49:
  pushl $0
  101feb:	6a 00                	push   $0x0
  pushl $49
  101fed:	6a 31                	push   $0x31
  jmp __alltraps
  101fef:	e9 2c fe ff ff       	jmp    101e20 <__alltraps>

00101ff4 <vector50>:
.globl vector50
vector50:
  pushl $0
  101ff4:	6a 00                	push   $0x0
  pushl $50
  101ff6:	6a 32                	push   $0x32
  jmp __alltraps
  101ff8:	e9 23 fe ff ff       	jmp    101e20 <__alltraps>

00101ffd <vector51>:
.globl vector51
vector51:
  pushl $0
  101ffd:	6a 00                	push   $0x0
  pushl $51
  101fff:	6a 33                	push   $0x33
  jmp __alltraps
  102001:	e9 1a fe ff ff       	jmp    101e20 <__alltraps>

00102006 <vector52>:
.globl vector52
vector52:
  pushl $0
  102006:	6a 00                	push   $0x0
  pushl $52
  102008:	6a 34                	push   $0x34
  jmp __alltraps
  10200a:	e9 11 fe ff ff       	jmp    101e20 <__alltraps>

0010200f <vector53>:
.globl vector53
vector53:
  pushl $0
  10200f:	6a 00                	push   $0x0
  pushl $53
  102011:	6a 35                	push   $0x35
  jmp __alltraps
  102013:	e9 08 fe ff ff       	jmp    101e20 <__alltraps>

00102018 <vector54>:
.globl vector54
vector54:
  pushl $0
  102018:	6a 00                	push   $0x0
  pushl $54
  10201a:	6a 36                	push   $0x36
  jmp __alltraps
  10201c:	e9 ff fd ff ff       	jmp    101e20 <__alltraps>

00102021 <vector55>:
.globl vector55
vector55:
  pushl $0
  102021:	6a 00                	push   $0x0
  pushl $55
  102023:	6a 37                	push   $0x37
  jmp __alltraps
  102025:	e9 f6 fd ff ff       	jmp    101e20 <__alltraps>

0010202a <vector56>:
.globl vector56
vector56:
  pushl $0
  10202a:	6a 00                	push   $0x0
  pushl $56
  10202c:	6a 38                	push   $0x38
  jmp __alltraps
  10202e:	e9 ed fd ff ff       	jmp    101e20 <__alltraps>

00102033 <vector57>:
.globl vector57
vector57:
  pushl $0
  102033:	6a 00                	push   $0x0
  pushl $57
  102035:	6a 39                	push   $0x39
  jmp __alltraps
  102037:	e9 e4 fd ff ff       	jmp    101e20 <__alltraps>

0010203c <vector58>:
.globl vector58
vector58:
  pushl $0
  10203c:	6a 00                	push   $0x0
  pushl $58
  10203e:	6a 3a                	push   $0x3a
  jmp __alltraps
  102040:	e9 db fd ff ff       	jmp    101e20 <__alltraps>

00102045 <vector59>:
.globl vector59
vector59:
  pushl $0
  102045:	6a 00                	push   $0x0
  pushl $59
  102047:	6a 3b                	push   $0x3b
  jmp __alltraps
  102049:	e9 d2 fd ff ff       	jmp    101e20 <__alltraps>

0010204e <vector60>:
.globl vector60
vector60:
  pushl $0
  10204e:	6a 00                	push   $0x0
  pushl $60
  102050:	6a 3c                	push   $0x3c
  jmp __alltraps
  102052:	e9 c9 fd ff ff       	jmp    101e20 <__alltraps>

00102057 <vector61>:
.globl vector61
vector61:
  pushl $0
  102057:	6a 00                	push   $0x0
  pushl $61
  102059:	6a 3d                	push   $0x3d
  jmp __alltraps
  10205b:	e9 c0 fd ff ff       	jmp    101e20 <__alltraps>

00102060 <vector62>:
.globl vector62
vector62:
  pushl $0
  102060:	6a 00                	push   $0x0
  pushl $62
  102062:	6a 3e                	push   $0x3e
  jmp __alltraps
  102064:	e9 b7 fd ff ff       	jmp    101e20 <__alltraps>

00102069 <vector63>:
.globl vector63
vector63:
  pushl $0
  102069:	6a 00                	push   $0x0
  pushl $63
  10206b:	6a 3f                	push   $0x3f
  jmp __alltraps
  10206d:	e9 ae fd ff ff       	jmp    101e20 <__alltraps>

00102072 <vector64>:
.globl vector64
vector64:
  pushl $0
  102072:	6a 00                	push   $0x0
  pushl $64
  102074:	6a 40                	push   $0x40
  jmp __alltraps
  102076:	e9 a5 fd ff ff       	jmp    101e20 <__alltraps>

0010207b <vector65>:
.globl vector65
vector65:
  pushl $0
  10207b:	6a 00                	push   $0x0
  pushl $65
  10207d:	6a 41                	push   $0x41
  jmp __alltraps
  10207f:	e9 9c fd ff ff       	jmp    101e20 <__alltraps>

00102084 <vector66>:
.globl vector66
vector66:
  pushl $0
  102084:	6a 00                	push   $0x0
  pushl $66
  102086:	6a 42                	push   $0x42
  jmp __alltraps
  102088:	e9 93 fd ff ff       	jmp    101e20 <__alltraps>

0010208d <vector67>:
.globl vector67
vector67:
  pushl $0
  10208d:	6a 00                	push   $0x0
  pushl $67
  10208f:	6a 43                	push   $0x43
  jmp __alltraps
  102091:	e9 8a fd ff ff       	jmp    101e20 <__alltraps>

00102096 <vector68>:
.globl vector68
vector68:
  pushl $0
  102096:	6a 00                	push   $0x0
  pushl $68
  102098:	6a 44                	push   $0x44
  jmp __alltraps
  10209a:	e9 81 fd ff ff       	jmp    101e20 <__alltraps>

0010209f <vector69>:
.globl vector69
vector69:
  pushl $0
  10209f:	6a 00                	push   $0x0
  pushl $69
  1020a1:	6a 45                	push   $0x45
  jmp __alltraps
  1020a3:	e9 78 fd ff ff       	jmp    101e20 <__alltraps>

001020a8 <vector70>:
.globl vector70
vector70:
  pushl $0
  1020a8:	6a 00                	push   $0x0
  pushl $70
  1020aa:	6a 46                	push   $0x46
  jmp __alltraps
  1020ac:	e9 6f fd ff ff       	jmp    101e20 <__alltraps>

001020b1 <vector71>:
.globl vector71
vector71:
  pushl $0
  1020b1:	6a 00                	push   $0x0
  pushl $71
  1020b3:	6a 47                	push   $0x47
  jmp __alltraps
  1020b5:	e9 66 fd ff ff       	jmp    101e20 <__alltraps>

001020ba <vector72>:
.globl vector72
vector72:
  pushl $0
  1020ba:	6a 00                	push   $0x0
  pushl $72
  1020bc:	6a 48                	push   $0x48
  jmp __alltraps
  1020be:	e9 5d fd ff ff       	jmp    101e20 <__alltraps>

001020c3 <vector73>:
.globl vector73
vector73:
  pushl $0
  1020c3:	6a 00                	push   $0x0
  pushl $73
  1020c5:	6a 49                	push   $0x49
  jmp __alltraps
  1020c7:	e9 54 fd ff ff       	jmp    101e20 <__alltraps>

001020cc <vector74>:
.globl vector74
vector74:
  pushl $0
  1020cc:	6a 00                	push   $0x0
  pushl $74
  1020ce:	6a 4a                	push   $0x4a
  jmp __alltraps
  1020d0:	e9 4b fd ff ff       	jmp    101e20 <__alltraps>

001020d5 <vector75>:
.globl vector75
vector75:
  pushl $0
  1020d5:	6a 00                	push   $0x0
  pushl $75
  1020d7:	6a 4b                	push   $0x4b
  jmp __alltraps
  1020d9:	e9 42 fd ff ff       	jmp    101e20 <__alltraps>

001020de <vector76>:
.globl vector76
vector76:
  pushl $0
  1020de:	6a 00                	push   $0x0
  pushl $76
  1020e0:	6a 4c                	push   $0x4c
  jmp __alltraps
  1020e2:	e9 39 fd ff ff       	jmp    101e20 <__alltraps>

001020e7 <vector77>:
.globl vector77
vector77:
  pushl $0
  1020e7:	6a 00                	push   $0x0
  pushl $77
  1020e9:	6a 4d                	push   $0x4d
  jmp __alltraps
  1020eb:	e9 30 fd ff ff       	jmp    101e20 <__alltraps>

001020f0 <vector78>:
.globl vector78
vector78:
  pushl $0
  1020f0:	6a 00                	push   $0x0
  pushl $78
  1020f2:	6a 4e                	push   $0x4e
  jmp __alltraps
  1020f4:	e9 27 fd ff ff       	jmp    101e20 <__alltraps>

001020f9 <vector79>:
.globl vector79
vector79:
  pushl $0
  1020f9:	6a 00                	push   $0x0
  pushl $79
  1020fb:	6a 4f                	push   $0x4f
  jmp __alltraps
  1020fd:	e9 1e fd ff ff       	jmp    101e20 <__alltraps>

00102102 <vector80>:
.globl vector80
vector80:
  pushl $0
  102102:	6a 00                	push   $0x0
  pushl $80
  102104:	6a 50                	push   $0x50
  jmp __alltraps
  102106:	e9 15 fd ff ff       	jmp    101e20 <__alltraps>

0010210b <vector81>:
.globl vector81
vector81:
  pushl $0
  10210b:	6a 00                	push   $0x0
  pushl $81
  10210d:	6a 51                	push   $0x51
  jmp __alltraps
  10210f:	e9 0c fd ff ff       	jmp    101e20 <__alltraps>

00102114 <vector82>:
.globl vector82
vector82:
  pushl $0
  102114:	6a 00                	push   $0x0
  pushl $82
  102116:	6a 52                	push   $0x52
  jmp __alltraps
  102118:	e9 03 fd ff ff       	jmp    101e20 <__alltraps>

0010211d <vector83>:
.globl vector83
vector83:
  pushl $0
  10211d:	6a 00                	push   $0x0
  pushl $83
  10211f:	6a 53                	push   $0x53
  jmp __alltraps
  102121:	e9 fa fc ff ff       	jmp    101e20 <__alltraps>

00102126 <vector84>:
.globl vector84
vector84:
  pushl $0
  102126:	6a 00                	push   $0x0
  pushl $84
  102128:	6a 54                	push   $0x54
  jmp __alltraps
  10212a:	e9 f1 fc ff ff       	jmp    101e20 <__alltraps>

0010212f <vector85>:
.globl vector85
vector85:
  pushl $0
  10212f:	6a 00                	push   $0x0
  pushl $85
  102131:	6a 55                	push   $0x55
  jmp __alltraps
  102133:	e9 e8 fc ff ff       	jmp    101e20 <__alltraps>

00102138 <vector86>:
.globl vector86
vector86:
  pushl $0
  102138:	6a 00                	push   $0x0
  pushl $86
  10213a:	6a 56                	push   $0x56
  jmp __alltraps
  10213c:	e9 df fc ff ff       	jmp    101e20 <__alltraps>

00102141 <vector87>:
.globl vector87
vector87:
  pushl $0
  102141:	6a 00                	push   $0x0
  pushl $87
  102143:	6a 57                	push   $0x57
  jmp __alltraps
  102145:	e9 d6 fc ff ff       	jmp    101e20 <__alltraps>

0010214a <vector88>:
.globl vector88
vector88:
  pushl $0
  10214a:	6a 00                	push   $0x0
  pushl $88
  10214c:	6a 58                	push   $0x58
  jmp __alltraps
  10214e:	e9 cd fc ff ff       	jmp    101e20 <__alltraps>

00102153 <vector89>:
.globl vector89
vector89:
  pushl $0
  102153:	6a 00                	push   $0x0
  pushl $89
  102155:	6a 59                	push   $0x59
  jmp __alltraps
  102157:	e9 c4 fc ff ff       	jmp    101e20 <__alltraps>

0010215c <vector90>:
.globl vector90
vector90:
  pushl $0
  10215c:	6a 00                	push   $0x0
  pushl $90
  10215e:	6a 5a                	push   $0x5a
  jmp __alltraps
  102160:	e9 bb fc ff ff       	jmp    101e20 <__alltraps>

00102165 <vector91>:
.globl vector91
vector91:
  pushl $0
  102165:	6a 00                	push   $0x0
  pushl $91
  102167:	6a 5b                	push   $0x5b
  jmp __alltraps
  102169:	e9 b2 fc ff ff       	jmp    101e20 <__alltraps>

0010216e <vector92>:
.globl vector92
vector92:
  pushl $0
  10216e:	6a 00                	push   $0x0
  pushl $92
  102170:	6a 5c                	push   $0x5c
  jmp __alltraps
  102172:	e9 a9 fc ff ff       	jmp    101e20 <__alltraps>

00102177 <vector93>:
.globl vector93
vector93:
  pushl $0
  102177:	6a 00                	push   $0x0
  pushl $93
  102179:	6a 5d                	push   $0x5d
  jmp __alltraps
  10217b:	e9 a0 fc ff ff       	jmp    101e20 <__alltraps>

00102180 <vector94>:
.globl vector94
vector94:
  pushl $0
  102180:	6a 00                	push   $0x0
  pushl $94
  102182:	6a 5e                	push   $0x5e
  jmp __alltraps
  102184:	e9 97 fc ff ff       	jmp    101e20 <__alltraps>

00102189 <vector95>:
.globl vector95
vector95:
  pushl $0
  102189:	6a 00                	push   $0x0
  pushl $95
  10218b:	6a 5f                	push   $0x5f
  jmp __alltraps
  10218d:	e9 8e fc ff ff       	jmp    101e20 <__alltraps>

00102192 <vector96>:
.globl vector96
vector96:
  pushl $0
  102192:	6a 00                	push   $0x0
  pushl $96
  102194:	6a 60                	push   $0x60
  jmp __alltraps
  102196:	e9 85 fc ff ff       	jmp    101e20 <__alltraps>

0010219b <vector97>:
.globl vector97
vector97:
  pushl $0
  10219b:	6a 00                	push   $0x0
  pushl $97
  10219d:	6a 61                	push   $0x61
  jmp __alltraps
  10219f:	e9 7c fc ff ff       	jmp    101e20 <__alltraps>

001021a4 <vector98>:
.globl vector98
vector98:
  pushl $0
  1021a4:	6a 00                	push   $0x0
  pushl $98
  1021a6:	6a 62                	push   $0x62
  jmp __alltraps
  1021a8:	e9 73 fc ff ff       	jmp    101e20 <__alltraps>

001021ad <vector99>:
.globl vector99
vector99:
  pushl $0
  1021ad:	6a 00                	push   $0x0
  pushl $99
  1021af:	6a 63                	push   $0x63
  jmp __alltraps
  1021b1:	e9 6a fc ff ff       	jmp    101e20 <__alltraps>

001021b6 <vector100>:
.globl vector100
vector100:
  pushl $0
  1021b6:	6a 00                	push   $0x0
  pushl $100
  1021b8:	6a 64                	push   $0x64
  jmp __alltraps
  1021ba:	e9 61 fc ff ff       	jmp    101e20 <__alltraps>

001021bf <vector101>:
.globl vector101
vector101:
  pushl $0
  1021bf:	6a 00                	push   $0x0
  pushl $101
  1021c1:	6a 65                	push   $0x65
  jmp __alltraps
  1021c3:	e9 58 fc ff ff       	jmp    101e20 <__alltraps>

001021c8 <vector102>:
.globl vector102
vector102:
  pushl $0
  1021c8:	6a 00                	push   $0x0
  pushl $102
  1021ca:	6a 66                	push   $0x66
  jmp __alltraps
  1021cc:	e9 4f fc ff ff       	jmp    101e20 <__alltraps>

001021d1 <vector103>:
.globl vector103
vector103:
  pushl $0
  1021d1:	6a 00                	push   $0x0
  pushl $103
  1021d3:	6a 67                	push   $0x67
  jmp __alltraps
  1021d5:	e9 46 fc ff ff       	jmp    101e20 <__alltraps>

001021da <vector104>:
.globl vector104
vector104:
  pushl $0
  1021da:	6a 00                	push   $0x0
  pushl $104
  1021dc:	6a 68                	push   $0x68
  jmp __alltraps
  1021de:	e9 3d fc ff ff       	jmp    101e20 <__alltraps>

001021e3 <vector105>:
.globl vector105
vector105:
  pushl $0
  1021e3:	6a 00                	push   $0x0
  pushl $105
  1021e5:	6a 69                	push   $0x69
  jmp __alltraps
  1021e7:	e9 34 fc ff ff       	jmp    101e20 <__alltraps>

001021ec <vector106>:
.globl vector106
vector106:
  pushl $0
  1021ec:	6a 00                	push   $0x0
  pushl $106
  1021ee:	6a 6a                	push   $0x6a
  jmp __alltraps
  1021f0:	e9 2b fc ff ff       	jmp    101e20 <__alltraps>

001021f5 <vector107>:
.globl vector107
vector107:
  pushl $0
  1021f5:	6a 00                	push   $0x0
  pushl $107
  1021f7:	6a 6b                	push   $0x6b
  jmp __alltraps
  1021f9:	e9 22 fc ff ff       	jmp    101e20 <__alltraps>

001021fe <vector108>:
.globl vector108
vector108:
  pushl $0
  1021fe:	6a 00                	push   $0x0
  pushl $108
  102200:	6a 6c                	push   $0x6c
  jmp __alltraps
  102202:	e9 19 fc ff ff       	jmp    101e20 <__alltraps>

00102207 <vector109>:
.globl vector109
vector109:
  pushl $0
  102207:	6a 00                	push   $0x0
  pushl $109
  102209:	6a 6d                	push   $0x6d
  jmp __alltraps
  10220b:	e9 10 fc ff ff       	jmp    101e20 <__alltraps>

00102210 <vector110>:
.globl vector110
vector110:
  pushl $0
  102210:	6a 00                	push   $0x0
  pushl $110
  102212:	6a 6e                	push   $0x6e
  jmp __alltraps
  102214:	e9 07 fc ff ff       	jmp    101e20 <__alltraps>

00102219 <vector111>:
.globl vector111
vector111:
  pushl $0
  102219:	6a 00                	push   $0x0
  pushl $111
  10221b:	6a 6f                	push   $0x6f
  jmp __alltraps
  10221d:	e9 fe fb ff ff       	jmp    101e20 <__alltraps>

00102222 <vector112>:
.globl vector112
vector112:
  pushl $0
  102222:	6a 00                	push   $0x0
  pushl $112
  102224:	6a 70                	push   $0x70
  jmp __alltraps
  102226:	e9 f5 fb ff ff       	jmp    101e20 <__alltraps>

0010222b <vector113>:
.globl vector113
vector113:
  pushl $0
  10222b:	6a 00                	push   $0x0
  pushl $113
  10222d:	6a 71                	push   $0x71
  jmp __alltraps
  10222f:	e9 ec fb ff ff       	jmp    101e20 <__alltraps>

00102234 <vector114>:
.globl vector114
vector114:
  pushl $0
  102234:	6a 00                	push   $0x0
  pushl $114
  102236:	6a 72                	push   $0x72
  jmp __alltraps
  102238:	e9 e3 fb ff ff       	jmp    101e20 <__alltraps>

0010223d <vector115>:
.globl vector115
vector115:
  pushl $0
  10223d:	6a 00                	push   $0x0
  pushl $115
  10223f:	6a 73                	push   $0x73
  jmp __alltraps
  102241:	e9 da fb ff ff       	jmp    101e20 <__alltraps>

00102246 <vector116>:
.globl vector116
vector116:
  pushl $0
  102246:	6a 00                	push   $0x0
  pushl $116
  102248:	6a 74                	push   $0x74
  jmp __alltraps
  10224a:	e9 d1 fb ff ff       	jmp    101e20 <__alltraps>

0010224f <vector117>:
.globl vector117
vector117:
  pushl $0
  10224f:	6a 00                	push   $0x0
  pushl $117
  102251:	6a 75                	push   $0x75
  jmp __alltraps
  102253:	e9 c8 fb ff ff       	jmp    101e20 <__alltraps>

00102258 <vector118>:
.globl vector118
vector118:
  pushl $0
  102258:	6a 00                	push   $0x0
  pushl $118
  10225a:	6a 76                	push   $0x76
  jmp __alltraps
  10225c:	e9 bf fb ff ff       	jmp    101e20 <__alltraps>

00102261 <vector119>:
.globl vector119
vector119:
  pushl $0
  102261:	6a 00                	push   $0x0
  pushl $119
  102263:	6a 77                	push   $0x77
  jmp __alltraps
  102265:	e9 b6 fb ff ff       	jmp    101e20 <__alltraps>

0010226a <vector120>:
.globl vector120
vector120:
  pushl $0
  10226a:	6a 00                	push   $0x0
  pushl $120
  10226c:	6a 78                	push   $0x78
  jmp __alltraps
  10226e:	e9 ad fb ff ff       	jmp    101e20 <__alltraps>

00102273 <vector121>:
.globl vector121
vector121:
  pushl $0
  102273:	6a 00                	push   $0x0
  pushl $121
  102275:	6a 79                	push   $0x79
  jmp __alltraps
  102277:	e9 a4 fb ff ff       	jmp    101e20 <__alltraps>

0010227c <vector122>:
.globl vector122
vector122:
  pushl $0
  10227c:	6a 00                	push   $0x0
  pushl $122
  10227e:	6a 7a                	push   $0x7a
  jmp __alltraps
  102280:	e9 9b fb ff ff       	jmp    101e20 <__alltraps>

00102285 <vector123>:
.globl vector123
vector123:
  pushl $0
  102285:	6a 00                	push   $0x0
  pushl $123
  102287:	6a 7b                	push   $0x7b
  jmp __alltraps
  102289:	e9 92 fb ff ff       	jmp    101e20 <__alltraps>

0010228e <vector124>:
.globl vector124
vector124:
  pushl $0
  10228e:	6a 00                	push   $0x0
  pushl $124
  102290:	6a 7c                	push   $0x7c
  jmp __alltraps
  102292:	e9 89 fb ff ff       	jmp    101e20 <__alltraps>

00102297 <vector125>:
.globl vector125
vector125:
  pushl $0
  102297:	6a 00                	push   $0x0
  pushl $125
  102299:	6a 7d                	push   $0x7d
  jmp __alltraps
  10229b:	e9 80 fb ff ff       	jmp    101e20 <__alltraps>

001022a0 <vector126>:
.globl vector126
vector126:
  pushl $0
  1022a0:	6a 00                	push   $0x0
  pushl $126
  1022a2:	6a 7e                	push   $0x7e
  jmp __alltraps
  1022a4:	e9 77 fb ff ff       	jmp    101e20 <__alltraps>

001022a9 <vector127>:
.globl vector127
vector127:
  pushl $0
  1022a9:	6a 00                	push   $0x0
  pushl $127
  1022ab:	6a 7f                	push   $0x7f
  jmp __alltraps
  1022ad:	e9 6e fb ff ff       	jmp    101e20 <__alltraps>

001022b2 <vector128>:
.globl vector128
vector128:
  pushl $0
  1022b2:	6a 00                	push   $0x0
  pushl $128
  1022b4:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1022b9:	e9 62 fb ff ff       	jmp    101e20 <__alltraps>

001022be <vector129>:
.globl vector129
vector129:
  pushl $0
  1022be:	6a 00                	push   $0x0
  pushl $129
  1022c0:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1022c5:	e9 56 fb ff ff       	jmp    101e20 <__alltraps>

001022ca <vector130>:
.globl vector130
vector130:
  pushl $0
  1022ca:	6a 00                	push   $0x0
  pushl $130
  1022cc:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1022d1:	e9 4a fb ff ff       	jmp    101e20 <__alltraps>

001022d6 <vector131>:
.globl vector131
vector131:
  pushl $0
  1022d6:	6a 00                	push   $0x0
  pushl $131
  1022d8:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1022dd:	e9 3e fb ff ff       	jmp    101e20 <__alltraps>

001022e2 <vector132>:
.globl vector132
vector132:
  pushl $0
  1022e2:	6a 00                	push   $0x0
  pushl $132
  1022e4:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1022e9:	e9 32 fb ff ff       	jmp    101e20 <__alltraps>

001022ee <vector133>:
.globl vector133
vector133:
  pushl $0
  1022ee:	6a 00                	push   $0x0
  pushl $133
  1022f0:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1022f5:	e9 26 fb ff ff       	jmp    101e20 <__alltraps>

001022fa <vector134>:
.globl vector134
vector134:
  pushl $0
  1022fa:	6a 00                	push   $0x0
  pushl $134
  1022fc:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102301:	e9 1a fb ff ff       	jmp    101e20 <__alltraps>

00102306 <vector135>:
.globl vector135
vector135:
  pushl $0
  102306:	6a 00                	push   $0x0
  pushl $135
  102308:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10230d:	e9 0e fb ff ff       	jmp    101e20 <__alltraps>

00102312 <vector136>:
.globl vector136
vector136:
  pushl $0
  102312:	6a 00                	push   $0x0
  pushl $136
  102314:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102319:	e9 02 fb ff ff       	jmp    101e20 <__alltraps>

0010231e <vector137>:
.globl vector137
vector137:
  pushl $0
  10231e:	6a 00                	push   $0x0
  pushl $137
  102320:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102325:	e9 f6 fa ff ff       	jmp    101e20 <__alltraps>

0010232a <vector138>:
.globl vector138
vector138:
  pushl $0
  10232a:	6a 00                	push   $0x0
  pushl $138
  10232c:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102331:	e9 ea fa ff ff       	jmp    101e20 <__alltraps>

00102336 <vector139>:
.globl vector139
vector139:
  pushl $0
  102336:	6a 00                	push   $0x0
  pushl $139
  102338:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  10233d:	e9 de fa ff ff       	jmp    101e20 <__alltraps>

00102342 <vector140>:
.globl vector140
vector140:
  pushl $0
  102342:	6a 00                	push   $0x0
  pushl $140
  102344:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102349:	e9 d2 fa ff ff       	jmp    101e20 <__alltraps>

0010234e <vector141>:
.globl vector141
vector141:
  pushl $0
  10234e:	6a 00                	push   $0x0
  pushl $141
  102350:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102355:	e9 c6 fa ff ff       	jmp    101e20 <__alltraps>

0010235a <vector142>:
.globl vector142
vector142:
  pushl $0
  10235a:	6a 00                	push   $0x0
  pushl $142
  10235c:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102361:	e9 ba fa ff ff       	jmp    101e20 <__alltraps>

00102366 <vector143>:
.globl vector143
vector143:
  pushl $0
  102366:	6a 00                	push   $0x0
  pushl $143
  102368:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  10236d:	e9 ae fa ff ff       	jmp    101e20 <__alltraps>

00102372 <vector144>:
.globl vector144
vector144:
  pushl $0
  102372:	6a 00                	push   $0x0
  pushl $144
  102374:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102379:	e9 a2 fa ff ff       	jmp    101e20 <__alltraps>

0010237e <vector145>:
.globl vector145
vector145:
  pushl $0
  10237e:	6a 00                	push   $0x0
  pushl $145
  102380:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102385:	e9 96 fa ff ff       	jmp    101e20 <__alltraps>

0010238a <vector146>:
.globl vector146
vector146:
  pushl $0
  10238a:	6a 00                	push   $0x0
  pushl $146
  10238c:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102391:	e9 8a fa ff ff       	jmp    101e20 <__alltraps>

00102396 <vector147>:
.globl vector147
vector147:
  pushl $0
  102396:	6a 00                	push   $0x0
  pushl $147
  102398:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10239d:	e9 7e fa ff ff       	jmp    101e20 <__alltraps>

001023a2 <vector148>:
.globl vector148
vector148:
  pushl $0
  1023a2:	6a 00                	push   $0x0
  pushl $148
  1023a4:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1023a9:	e9 72 fa ff ff       	jmp    101e20 <__alltraps>

001023ae <vector149>:
.globl vector149
vector149:
  pushl $0
  1023ae:	6a 00                	push   $0x0
  pushl $149
  1023b0:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1023b5:	e9 66 fa ff ff       	jmp    101e20 <__alltraps>

001023ba <vector150>:
.globl vector150
vector150:
  pushl $0
  1023ba:	6a 00                	push   $0x0
  pushl $150
  1023bc:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1023c1:	e9 5a fa ff ff       	jmp    101e20 <__alltraps>

001023c6 <vector151>:
.globl vector151
vector151:
  pushl $0
  1023c6:	6a 00                	push   $0x0
  pushl $151
  1023c8:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1023cd:	e9 4e fa ff ff       	jmp    101e20 <__alltraps>

001023d2 <vector152>:
.globl vector152
vector152:
  pushl $0
  1023d2:	6a 00                	push   $0x0
  pushl $152
  1023d4:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1023d9:	e9 42 fa ff ff       	jmp    101e20 <__alltraps>

001023de <vector153>:
.globl vector153
vector153:
  pushl $0
  1023de:	6a 00                	push   $0x0
  pushl $153
  1023e0:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1023e5:	e9 36 fa ff ff       	jmp    101e20 <__alltraps>

001023ea <vector154>:
.globl vector154
vector154:
  pushl $0
  1023ea:	6a 00                	push   $0x0
  pushl $154
  1023ec:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1023f1:	e9 2a fa ff ff       	jmp    101e20 <__alltraps>

001023f6 <vector155>:
.globl vector155
vector155:
  pushl $0
  1023f6:	6a 00                	push   $0x0
  pushl $155
  1023f8:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1023fd:	e9 1e fa ff ff       	jmp    101e20 <__alltraps>

00102402 <vector156>:
.globl vector156
vector156:
  pushl $0
  102402:	6a 00                	push   $0x0
  pushl $156
  102404:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102409:	e9 12 fa ff ff       	jmp    101e20 <__alltraps>

0010240e <vector157>:
.globl vector157
vector157:
  pushl $0
  10240e:	6a 00                	push   $0x0
  pushl $157
  102410:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102415:	e9 06 fa ff ff       	jmp    101e20 <__alltraps>

0010241a <vector158>:
.globl vector158
vector158:
  pushl $0
  10241a:	6a 00                	push   $0x0
  pushl $158
  10241c:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102421:	e9 fa f9 ff ff       	jmp    101e20 <__alltraps>

00102426 <vector159>:
.globl vector159
vector159:
  pushl $0
  102426:	6a 00                	push   $0x0
  pushl $159
  102428:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  10242d:	e9 ee f9 ff ff       	jmp    101e20 <__alltraps>

00102432 <vector160>:
.globl vector160
vector160:
  pushl $0
  102432:	6a 00                	push   $0x0
  pushl $160
  102434:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102439:	e9 e2 f9 ff ff       	jmp    101e20 <__alltraps>

0010243e <vector161>:
.globl vector161
vector161:
  pushl $0
  10243e:	6a 00                	push   $0x0
  pushl $161
  102440:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102445:	e9 d6 f9 ff ff       	jmp    101e20 <__alltraps>

0010244a <vector162>:
.globl vector162
vector162:
  pushl $0
  10244a:	6a 00                	push   $0x0
  pushl $162
  10244c:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102451:	e9 ca f9 ff ff       	jmp    101e20 <__alltraps>

00102456 <vector163>:
.globl vector163
vector163:
  pushl $0
  102456:	6a 00                	push   $0x0
  pushl $163
  102458:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  10245d:	e9 be f9 ff ff       	jmp    101e20 <__alltraps>

00102462 <vector164>:
.globl vector164
vector164:
  pushl $0
  102462:	6a 00                	push   $0x0
  pushl $164
  102464:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102469:	e9 b2 f9 ff ff       	jmp    101e20 <__alltraps>

0010246e <vector165>:
.globl vector165
vector165:
  pushl $0
  10246e:	6a 00                	push   $0x0
  pushl $165
  102470:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102475:	e9 a6 f9 ff ff       	jmp    101e20 <__alltraps>

0010247a <vector166>:
.globl vector166
vector166:
  pushl $0
  10247a:	6a 00                	push   $0x0
  pushl $166
  10247c:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102481:	e9 9a f9 ff ff       	jmp    101e20 <__alltraps>

00102486 <vector167>:
.globl vector167
vector167:
  pushl $0
  102486:	6a 00                	push   $0x0
  pushl $167
  102488:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10248d:	e9 8e f9 ff ff       	jmp    101e20 <__alltraps>

00102492 <vector168>:
.globl vector168
vector168:
  pushl $0
  102492:	6a 00                	push   $0x0
  pushl $168
  102494:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102499:	e9 82 f9 ff ff       	jmp    101e20 <__alltraps>

0010249e <vector169>:
.globl vector169
vector169:
  pushl $0
  10249e:	6a 00                	push   $0x0
  pushl $169
  1024a0:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1024a5:	e9 76 f9 ff ff       	jmp    101e20 <__alltraps>

001024aa <vector170>:
.globl vector170
vector170:
  pushl $0
  1024aa:	6a 00                	push   $0x0
  pushl $170
  1024ac:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1024b1:	e9 6a f9 ff ff       	jmp    101e20 <__alltraps>

001024b6 <vector171>:
.globl vector171
vector171:
  pushl $0
  1024b6:	6a 00                	push   $0x0
  pushl $171
  1024b8:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1024bd:	e9 5e f9 ff ff       	jmp    101e20 <__alltraps>

001024c2 <vector172>:
.globl vector172
vector172:
  pushl $0
  1024c2:	6a 00                	push   $0x0
  pushl $172
  1024c4:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1024c9:	e9 52 f9 ff ff       	jmp    101e20 <__alltraps>

001024ce <vector173>:
.globl vector173
vector173:
  pushl $0
  1024ce:	6a 00                	push   $0x0
  pushl $173
  1024d0:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1024d5:	e9 46 f9 ff ff       	jmp    101e20 <__alltraps>

001024da <vector174>:
.globl vector174
vector174:
  pushl $0
  1024da:	6a 00                	push   $0x0
  pushl $174
  1024dc:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1024e1:	e9 3a f9 ff ff       	jmp    101e20 <__alltraps>

001024e6 <vector175>:
.globl vector175
vector175:
  pushl $0
  1024e6:	6a 00                	push   $0x0
  pushl $175
  1024e8:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1024ed:	e9 2e f9 ff ff       	jmp    101e20 <__alltraps>

001024f2 <vector176>:
.globl vector176
vector176:
  pushl $0
  1024f2:	6a 00                	push   $0x0
  pushl $176
  1024f4:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1024f9:	e9 22 f9 ff ff       	jmp    101e20 <__alltraps>

001024fe <vector177>:
.globl vector177
vector177:
  pushl $0
  1024fe:	6a 00                	push   $0x0
  pushl $177
  102500:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102505:	e9 16 f9 ff ff       	jmp    101e20 <__alltraps>

0010250a <vector178>:
.globl vector178
vector178:
  pushl $0
  10250a:	6a 00                	push   $0x0
  pushl $178
  10250c:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102511:	e9 0a f9 ff ff       	jmp    101e20 <__alltraps>

00102516 <vector179>:
.globl vector179
vector179:
  pushl $0
  102516:	6a 00                	push   $0x0
  pushl $179
  102518:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10251d:	e9 fe f8 ff ff       	jmp    101e20 <__alltraps>

00102522 <vector180>:
.globl vector180
vector180:
  pushl $0
  102522:	6a 00                	push   $0x0
  pushl $180
  102524:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102529:	e9 f2 f8 ff ff       	jmp    101e20 <__alltraps>

0010252e <vector181>:
.globl vector181
vector181:
  pushl $0
  10252e:	6a 00                	push   $0x0
  pushl $181
  102530:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102535:	e9 e6 f8 ff ff       	jmp    101e20 <__alltraps>

0010253a <vector182>:
.globl vector182
vector182:
  pushl $0
  10253a:	6a 00                	push   $0x0
  pushl $182
  10253c:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102541:	e9 da f8 ff ff       	jmp    101e20 <__alltraps>

00102546 <vector183>:
.globl vector183
vector183:
  pushl $0
  102546:	6a 00                	push   $0x0
  pushl $183
  102548:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  10254d:	e9 ce f8 ff ff       	jmp    101e20 <__alltraps>

00102552 <vector184>:
.globl vector184
vector184:
  pushl $0
  102552:	6a 00                	push   $0x0
  pushl $184
  102554:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102559:	e9 c2 f8 ff ff       	jmp    101e20 <__alltraps>

0010255e <vector185>:
.globl vector185
vector185:
  pushl $0
  10255e:	6a 00                	push   $0x0
  pushl $185
  102560:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102565:	e9 b6 f8 ff ff       	jmp    101e20 <__alltraps>

0010256a <vector186>:
.globl vector186
vector186:
  pushl $0
  10256a:	6a 00                	push   $0x0
  pushl $186
  10256c:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102571:	e9 aa f8 ff ff       	jmp    101e20 <__alltraps>

00102576 <vector187>:
.globl vector187
vector187:
  pushl $0
  102576:	6a 00                	push   $0x0
  pushl $187
  102578:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10257d:	e9 9e f8 ff ff       	jmp    101e20 <__alltraps>

00102582 <vector188>:
.globl vector188
vector188:
  pushl $0
  102582:	6a 00                	push   $0x0
  pushl $188
  102584:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102589:	e9 92 f8 ff ff       	jmp    101e20 <__alltraps>

0010258e <vector189>:
.globl vector189
vector189:
  pushl $0
  10258e:	6a 00                	push   $0x0
  pushl $189
  102590:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102595:	e9 86 f8 ff ff       	jmp    101e20 <__alltraps>

0010259a <vector190>:
.globl vector190
vector190:
  pushl $0
  10259a:	6a 00                	push   $0x0
  pushl $190
  10259c:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1025a1:	e9 7a f8 ff ff       	jmp    101e20 <__alltraps>

001025a6 <vector191>:
.globl vector191
vector191:
  pushl $0
  1025a6:	6a 00                	push   $0x0
  pushl $191
  1025a8:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1025ad:	e9 6e f8 ff ff       	jmp    101e20 <__alltraps>

001025b2 <vector192>:
.globl vector192
vector192:
  pushl $0
  1025b2:	6a 00                	push   $0x0
  pushl $192
  1025b4:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1025b9:	e9 62 f8 ff ff       	jmp    101e20 <__alltraps>

001025be <vector193>:
.globl vector193
vector193:
  pushl $0
  1025be:	6a 00                	push   $0x0
  pushl $193
  1025c0:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1025c5:	e9 56 f8 ff ff       	jmp    101e20 <__alltraps>

001025ca <vector194>:
.globl vector194
vector194:
  pushl $0
  1025ca:	6a 00                	push   $0x0
  pushl $194
  1025cc:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1025d1:	e9 4a f8 ff ff       	jmp    101e20 <__alltraps>

001025d6 <vector195>:
.globl vector195
vector195:
  pushl $0
  1025d6:	6a 00                	push   $0x0
  pushl $195
  1025d8:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1025dd:	e9 3e f8 ff ff       	jmp    101e20 <__alltraps>

001025e2 <vector196>:
.globl vector196
vector196:
  pushl $0
  1025e2:	6a 00                	push   $0x0
  pushl $196
  1025e4:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1025e9:	e9 32 f8 ff ff       	jmp    101e20 <__alltraps>

001025ee <vector197>:
.globl vector197
vector197:
  pushl $0
  1025ee:	6a 00                	push   $0x0
  pushl $197
  1025f0:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1025f5:	e9 26 f8 ff ff       	jmp    101e20 <__alltraps>

001025fa <vector198>:
.globl vector198
vector198:
  pushl $0
  1025fa:	6a 00                	push   $0x0
  pushl $198
  1025fc:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102601:	e9 1a f8 ff ff       	jmp    101e20 <__alltraps>

00102606 <vector199>:
.globl vector199
vector199:
  pushl $0
  102606:	6a 00                	push   $0x0
  pushl $199
  102608:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10260d:	e9 0e f8 ff ff       	jmp    101e20 <__alltraps>

00102612 <vector200>:
.globl vector200
vector200:
  pushl $0
  102612:	6a 00                	push   $0x0
  pushl $200
  102614:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102619:	e9 02 f8 ff ff       	jmp    101e20 <__alltraps>

0010261e <vector201>:
.globl vector201
vector201:
  pushl $0
  10261e:	6a 00                	push   $0x0
  pushl $201
  102620:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102625:	e9 f6 f7 ff ff       	jmp    101e20 <__alltraps>

0010262a <vector202>:
.globl vector202
vector202:
  pushl $0
  10262a:	6a 00                	push   $0x0
  pushl $202
  10262c:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102631:	e9 ea f7 ff ff       	jmp    101e20 <__alltraps>

00102636 <vector203>:
.globl vector203
vector203:
  pushl $0
  102636:	6a 00                	push   $0x0
  pushl $203
  102638:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  10263d:	e9 de f7 ff ff       	jmp    101e20 <__alltraps>

00102642 <vector204>:
.globl vector204
vector204:
  pushl $0
  102642:	6a 00                	push   $0x0
  pushl $204
  102644:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102649:	e9 d2 f7 ff ff       	jmp    101e20 <__alltraps>

0010264e <vector205>:
.globl vector205
vector205:
  pushl $0
  10264e:	6a 00                	push   $0x0
  pushl $205
  102650:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102655:	e9 c6 f7 ff ff       	jmp    101e20 <__alltraps>

0010265a <vector206>:
.globl vector206
vector206:
  pushl $0
  10265a:	6a 00                	push   $0x0
  pushl $206
  10265c:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102661:	e9 ba f7 ff ff       	jmp    101e20 <__alltraps>

00102666 <vector207>:
.globl vector207
vector207:
  pushl $0
  102666:	6a 00                	push   $0x0
  pushl $207
  102668:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  10266d:	e9 ae f7 ff ff       	jmp    101e20 <__alltraps>

00102672 <vector208>:
.globl vector208
vector208:
  pushl $0
  102672:	6a 00                	push   $0x0
  pushl $208
  102674:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102679:	e9 a2 f7 ff ff       	jmp    101e20 <__alltraps>

0010267e <vector209>:
.globl vector209
vector209:
  pushl $0
  10267e:	6a 00                	push   $0x0
  pushl $209
  102680:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102685:	e9 96 f7 ff ff       	jmp    101e20 <__alltraps>

0010268a <vector210>:
.globl vector210
vector210:
  pushl $0
  10268a:	6a 00                	push   $0x0
  pushl $210
  10268c:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102691:	e9 8a f7 ff ff       	jmp    101e20 <__alltraps>

00102696 <vector211>:
.globl vector211
vector211:
  pushl $0
  102696:	6a 00                	push   $0x0
  pushl $211
  102698:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10269d:	e9 7e f7 ff ff       	jmp    101e20 <__alltraps>

001026a2 <vector212>:
.globl vector212
vector212:
  pushl $0
  1026a2:	6a 00                	push   $0x0
  pushl $212
  1026a4:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1026a9:	e9 72 f7 ff ff       	jmp    101e20 <__alltraps>

001026ae <vector213>:
.globl vector213
vector213:
  pushl $0
  1026ae:	6a 00                	push   $0x0
  pushl $213
  1026b0:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1026b5:	e9 66 f7 ff ff       	jmp    101e20 <__alltraps>

001026ba <vector214>:
.globl vector214
vector214:
  pushl $0
  1026ba:	6a 00                	push   $0x0
  pushl $214
  1026bc:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1026c1:	e9 5a f7 ff ff       	jmp    101e20 <__alltraps>

001026c6 <vector215>:
.globl vector215
vector215:
  pushl $0
  1026c6:	6a 00                	push   $0x0
  pushl $215
  1026c8:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1026cd:	e9 4e f7 ff ff       	jmp    101e20 <__alltraps>

001026d2 <vector216>:
.globl vector216
vector216:
  pushl $0
  1026d2:	6a 00                	push   $0x0
  pushl $216
  1026d4:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1026d9:	e9 42 f7 ff ff       	jmp    101e20 <__alltraps>

001026de <vector217>:
.globl vector217
vector217:
  pushl $0
  1026de:	6a 00                	push   $0x0
  pushl $217
  1026e0:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1026e5:	e9 36 f7 ff ff       	jmp    101e20 <__alltraps>

001026ea <vector218>:
.globl vector218
vector218:
  pushl $0
  1026ea:	6a 00                	push   $0x0
  pushl $218
  1026ec:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1026f1:	e9 2a f7 ff ff       	jmp    101e20 <__alltraps>

001026f6 <vector219>:
.globl vector219
vector219:
  pushl $0
  1026f6:	6a 00                	push   $0x0
  pushl $219
  1026f8:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1026fd:	e9 1e f7 ff ff       	jmp    101e20 <__alltraps>

00102702 <vector220>:
.globl vector220
vector220:
  pushl $0
  102702:	6a 00                	push   $0x0
  pushl $220
  102704:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102709:	e9 12 f7 ff ff       	jmp    101e20 <__alltraps>

0010270e <vector221>:
.globl vector221
vector221:
  pushl $0
  10270e:	6a 00                	push   $0x0
  pushl $221
  102710:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102715:	e9 06 f7 ff ff       	jmp    101e20 <__alltraps>

0010271a <vector222>:
.globl vector222
vector222:
  pushl $0
  10271a:	6a 00                	push   $0x0
  pushl $222
  10271c:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102721:	e9 fa f6 ff ff       	jmp    101e20 <__alltraps>

00102726 <vector223>:
.globl vector223
vector223:
  pushl $0
  102726:	6a 00                	push   $0x0
  pushl $223
  102728:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  10272d:	e9 ee f6 ff ff       	jmp    101e20 <__alltraps>

00102732 <vector224>:
.globl vector224
vector224:
  pushl $0
  102732:	6a 00                	push   $0x0
  pushl $224
  102734:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102739:	e9 e2 f6 ff ff       	jmp    101e20 <__alltraps>

0010273e <vector225>:
.globl vector225
vector225:
  pushl $0
  10273e:	6a 00                	push   $0x0
  pushl $225
  102740:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102745:	e9 d6 f6 ff ff       	jmp    101e20 <__alltraps>

0010274a <vector226>:
.globl vector226
vector226:
  pushl $0
  10274a:	6a 00                	push   $0x0
  pushl $226
  10274c:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102751:	e9 ca f6 ff ff       	jmp    101e20 <__alltraps>

00102756 <vector227>:
.globl vector227
vector227:
  pushl $0
  102756:	6a 00                	push   $0x0
  pushl $227
  102758:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  10275d:	e9 be f6 ff ff       	jmp    101e20 <__alltraps>

00102762 <vector228>:
.globl vector228
vector228:
  pushl $0
  102762:	6a 00                	push   $0x0
  pushl $228
  102764:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102769:	e9 b2 f6 ff ff       	jmp    101e20 <__alltraps>

0010276e <vector229>:
.globl vector229
vector229:
  pushl $0
  10276e:	6a 00                	push   $0x0
  pushl $229
  102770:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102775:	e9 a6 f6 ff ff       	jmp    101e20 <__alltraps>

0010277a <vector230>:
.globl vector230
vector230:
  pushl $0
  10277a:	6a 00                	push   $0x0
  pushl $230
  10277c:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102781:	e9 9a f6 ff ff       	jmp    101e20 <__alltraps>

00102786 <vector231>:
.globl vector231
vector231:
  pushl $0
  102786:	6a 00                	push   $0x0
  pushl $231
  102788:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10278d:	e9 8e f6 ff ff       	jmp    101e20 <__alltraps>

00102792 <vector232>:
.globl vector232
vector232:
  pushl $0
  102792:	6a 00                	push   $0x0
  pushl $232
  102794:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102799:	e9 82 f6 ff ff       	jmp    101e20 <__alltraps>

0010279e <vector233>:
.globl vector233
vector233:
  pushl $0
  10279e:	6a 00                	push   $0x0
  pushl $233
  1027a0:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1027a5:	e9 76 f6 ff ff       	jmp    101e20 <__alltraps>

001027aa <vector234>:
.globl vector234
vector234:
  pushl $0
  1027aa:	6a 00                	push   $0x0
  pushl $234
  1027ac:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1027b1:	e9 6a f6 ff ff       	jmp    101e20 <__alltraps>

001027b6 <vector235>:
.globl vector235
vector235:
  pushl $0
  1027b6:	6a 00                	push   $0x0
  pushl $235
  1027b8:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1027bd:	e9 5e f6 ff ff       	jmp    101e20 <__alltraps>

001027c2 <vector236>:
.globl vector236
vector236:
  pushl $0
  1027c2:	6a 00                	push   $0x0
  pushl $236
  1027c4:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1027c9:	e9 52 f6 ff ff       	jmp    101e20 <__alltraps>

001027ce <vector237>:
.globl vector237
vector237:
  pushl $0
  1027ce:	6a 00                	push   $0x0
  pushl $237
  1027d0:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1027d5:	e9 46 f6 ff ff       	jmp    101e20 <__alltraps>

001027da <vector238>:
.globl vector238
vector238:
  pushl $0
  1027da:	6a 00                	push   $0x0
  pushl $238
  1027dc:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1027e1:	e9 3a f6 ff ff       	jmp    101e20 <__alltraps>

001027e6 <vector239>:
.globl vector239
vector239:
  pushl $0
  1027e6:	6a 00                	push   $0x0
  pushl $239
  1027e8:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1027ed:	e9 2e f6 ff ff       	jmp    101e20 <__alltraps>

001027f2 <vector240>:
.globl vector240
vector240:
  pushl $0
  1027f2:	6a 00                	push   $0x0
  pushl $240
  1027f4:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1027f9:	e9 22 f6 ff ff       	jmp    101e20 <__alltraps>

001027fe <vector241>:
.globl vector241
vector241:
  pushl $0
  1027fe:	6a 00                	push   $0x0
  pushl $241
  102800:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102805:	e9 16 f6 ff ff       	jmp    101e20 <__alltraps>

0010280a <vector242>:
.globl vector242
vector242:
  pushl $0
  10280a:	6a 00                	push   $0x0
  pushl $242
  10280c:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102811:	e9 0a f6 ff ff       	jmp    101e20 <__alltraps>

00102816 <vector243>:
.globl vector243
vector243:
  pushl $0
  102816:	6a 00                	push   $0x0
  pushl $243
  102818:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10281d:	e9 fe f5 ff ff       	jmp    101e20 <__alltraps>

00102822 <vector244>:
.globl vector244
vector244:
  pushl $0
  102822:	6a 00                	push   $0x0
  pushl $244
  102824:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102829:	e9 f2 f5 ff ff       	jmp    101e20 <__alltraps>

0010282e <vector245>:
.globl vector245
vector245:
  pushl $0
  10282e:	6a 00                	push   $0x0
  pushl $245
  102830:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102835:	e9 e6 f5 ff ff       	jmp    101e20 <__alltraps>

0010283a <vector246>:
.globl vector246
vector246:
  pushl $0
  10283a:	6a 00                	push   $0x0
  pushl $246
  10283c:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102841:	e9 da f5 ff ff       	jmp    101e20 <__alltraps>

00102846 <vector247>:
.globl vector247
vector247:
  pushl $0
  102846:	6a 00                	push   $0x0
  pushl $247
  102848:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  10284d:	e9 ce f5 ff ff       	jmp    101e20 <__alltraps>

00102852 <vector248>:
.globl vector248
vector248:
  pushl $0
  102852:	6a 00                	push   $0x0
  pushl $248
  102854:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102859:	e9 c2 f5 ff ff       	jmp    101e20 <__alltraps>

0010285e <vector249>:
.globl vector249
vector249:
  pushl $0
  10285e:	6a 00                	push   $0x0
  pushl $249
  102860:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102865:	e9 b6 f5 ff ff       	jmp    101e20 <__alltraps>

0010286a <vector250>:
.globl vector250
vector250:
  pushl $0
  10286a:	6a 00                	push   $0x0
  pushl $250
  10286c:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102871:	e9 aa f5 ff ff       	jmp    101e20 <__alltraps>

00102876 <vector251>:
.globl vector251
vector251:
  pushl $0
  102876:	6a 00                	push   $0x0
  pushl $251
  102878:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  10287d:	e9 9e f5 ff ff       	jmp    101e20 <__alltraps>

00102882 <vector252>:
.globl vector252
vector252:
  pushl $0
  102882:	6a 00                	push   $0x0
  pushl $252
  102884:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102889:	e9 92 f5 ff ff       	jmp    101e20 <__alltraps>

0010288e <vector253>:
.globl vector253
vector253:
  pushl $0
  10288e:	6a 00                	push   $0x0
  pushl $253
  102890:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102895:	e9 86 f5 ff ff       	jmp    101e20 <__alltraps>

0010289a <vector254>:
.globl vector254
vector254:
  pushl $0
  10289a:	6a 00                	push   $0x0
  pushl $254
  10289c:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1028a1:	e9 7a f5 ff ff       	jmp    101e20 <__alltraps>

001028a6 <vector255>:
.globl vector255
vector255:
  pushl $0
  1028a6:	6a 00                	push   $0x0
  pushl $255
  1028a8:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1028ad:	e9 6e f5 ff ff       	jmp    101e20 <__alltraps>

001028b2 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  1028b2:	55                   	push   %ebp
  1028b3:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1028b5:	8b 55 08             	mov    0x8(%ebp),%edx
  1028b8:	a1 64 89 11 00       	mov    0x118964,%eax
  1028bd:	29 c2                	sub    %eax,%edx
  1028bf:	89 d0                	mov    %edx,%eax
  1028c1:	c1 f8 02             	sar    $0x2,%eax
  1028c4:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1028ca:	5d                   	pop    %ebp
  1028cb:	c3                   	ret    

001028cc <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  1028cc:	55                   	push   %ebp
  1028cd:	89 e5                	mov    %esp,%ebp
  1028cf:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1028d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1028d5:	89 04 24             	mov    %eax,(%esp)
  1028d8:	e8 d5 ff ff ff       	call   1028b2 <page2ppn>
  1028dd:	c1 e0 0c             	shl    $0xc,%eax
}
  1028e0:	c9                   	leave  
  1028e1:	c3                   	ret    

001028e2 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  1028e2:	55                   	push   %ebp
  1028e3:	89 e5                	mov    %esp,%ebp
    return page->ref;
  1028e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1028e8:	8b 00                	mov    (%eax),%eax
}
  1028ea:	5d                   	pop    %ebp
  1028eb:	c3                   	ret    

001028ec <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  1028ec:	55                   	push   %ebp
  1028ed:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  1028ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1028f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  1028f5:	89 10                	mov    %edx,(%eax)
}
  1028f7:	5d                   	pop    %ebp
  1028f8:	c3                   	ret    

001028f9 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  1028f9:	55                   	push   %ebp
  1028fa:	89 e5                	mov    %esp,%ebp
  1028fc:	83 ec 10             	sub    $0x10,%esp
  1028ff:	c7 45 fc 50 89 11 00 	movl   $0x118950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  102906:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102909:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10290c:	89 50 04             	mov    %edx,0x4(%eax)
  10290f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102912:	8b 50 04             	mov    0x4(%eax),%edx
  102915:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102918:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  10291a:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  102921:	00 00 00 
}
  102924:	c9                   	leave  
  102925:	c3                   	ret    

00102926 <default_init_memmap>:

static void
default_init_memmap(struct Page* base, size_t n) {
  102926:	55                   	push   %ebp
  102927:	89 e5                	mov    %esp,%ebp
  102929:	83 ec 48             	sub    $0x48,%esp
	assert(n > 0);
  10292c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102930:	75 24                	jne    102956 <default_init_memmap+0x30>
  102932:	c7 44 24 0c b0 66 10 	movl   $0x1066b0,0xc(%esp)
  102939:	00 
  10293a:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  102941:	00 
  102942:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
  102949:	00 
  10294a:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  102951:	e8 70 e3 ff ff       	call   100cc6 <__panic>
	struct Page* p = base;
  102956:	8b 45 08             	mov    0x8(%ebp),%eax
  102959:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (; p != base + n; p++) {
  10295c:	e9 dc 00 00 00       	jmp    102a3d <default_init_memmap+0x117>
		assert(PageReserved(p));
  102961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102964:	83 c0 04             	add    $0x4,%eax
  102967:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  10296e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102971:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102974:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102977:	0f a3 10             	bt     %edx,(%eax)
  10297a:	19 c0                	sbb    %eax,%eax
  10297c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  10297f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102983:	0f 95 c0             	setne  %al
  102986:	0f b6 c0             	movzbl %al,%eax
  102989:	85 c0                	test   %eax,%eax
  10298b:	75 24                	jne    1029b1 <default_init_memmap+0x8b>
  10298d:	c7 44 24 0c e1 66 10 	movl   $0x1066e1,0xc(%esp)
  102994:	00 
  102995:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  10299c:	00 
  10299d:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
  1029a4:	00 
  1029a5:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  1029ac:	e8 15 e3 ff ff       	call   100cc6 <__panic>
		p->flags = 0;
  1029b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
		SetPageProperty(p);
  1029bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029be:	83 c0 04             	add    $0x4,%eax
  1029c1:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  1029c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1029cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1029ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1029d1:	0f ab 10             	bts    %edx,(%eax)
		p->property = 0;
  1029d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029d7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		set_page_ref(p, 0);
  1029de:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1029e5:	00 
  1029e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029e9:	89 04 24             	mov    %eax,(%esp)
  1029ec:	e8 fb fe ff ff       	call   1028ec <set_page_ref>
		list_add_before(&free_list, &(p->page_link));
  1029f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029f4:	83 c0 0c             	add    $0xc,%eax
  1029f7:	c7 45 dc 50 89 11 00 	movl   $0x118950,-0x24(%ebp)
  1029fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102a01:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102a04:	8b 00                	mov    (%eax),%eax
  102a06:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102a09:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102a0c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102a0f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102a12:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102a15:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102a18:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102a1b:	89 10                	mov    %edx,(%eax)
  102a1d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102a20:	8b 10                	mov    (%eax),%edx
  102a22:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102a25:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102a28:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102a2b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102a2e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102a31:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102a34:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102a37:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page* base, size_t n) {
	assert(n > 0);
	struct Page* p = base;
	for (; p != base + n; p++) {
  102a39:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102a3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a40:	89 d0                	mov    %edx,%eax
  102a42:	c1 e0 02             	shl    $0x2,%eax
  102a45:	01 d0                	add    %edx,%eax
  102a47:	c1 e0 02             	shl    $0x2,%eax
  102a4a:	89 c2                	mov    %eax,%edx
  102a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  102a4f:	01 d0                	add    %edx,%eax
  102a51:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102a54:	0f 85 07 ff ff ff    	jne    102961 <default_init_memmap+0x3b>
		SetPageProperty(p);
		p->property = 0;
		set_page_ref(p, 0);
		list_add_before(&free_list, &(p->page_link));
	}
	nr_free += n;
  102a5a:	8b 15 58 89 11 00    	mov    0x118958,%edx
  102a60:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a63:	01 d0                	add    %edx,%eax
  102a65:	a3 58 89 11 00       	mov    %eax,0x118958
	base->property = n;
  102a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  102a6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a70:	89 50 08             	mov    %edx,0x8(%eax)
}
  102a73:	c9                   	leave  
  102a74:	c3                   	ret    

00102a75 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  102a75:	55                   	push   %ebp
  102a76:	89 e5                	mov    %esp,%ebp
  102a78:	83 ec 68             	sub    $0x68,%esp
	assert(n > 0);//判断n是否异常
  102a7b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102a7f:	75 24                	jne    102aa5 <default_alloc_pages+0x30>
  102a81:	c7 44 24 0c b0 66 10 	movl   $0x1066b0,0xc(%esp)
  102a88:	00 
  102a89:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  102a90:	00 
  102a91:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  102a98:	00 
  102a99:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  102aa0:	e8 21 e2 ff ff       	call   100cc6 <__panic>
	if (n > nr_free) {
  102aa5:	a1 58 89 11 00       	mov    0x118958,%eax
  102aaa:	3b 45 08             	cmp    0x8(%ebp),%eax
  102aad:	73 0a                	jae    102ab9 <default_alloc_pages+0x44>
		return NULL;
  102aaf:	b8 00 00 00 00       	mov    $0x0,%eax
  102ab4:	e9 37 01 00 00       	jmp    102bf0 <default_alloc_pages+0x17b>
	}//如果n大于可分配页数直接返回null
	list_entry_t* le, * len;
	le = &free_list;
  102ab9:	c7 45 f4 50 89 11 00 	movl   $0x118950,-0xc(%ebp)

	while ((le = list_next(le)) != &free_list) {//遍历空闲页链表每一页，找到符合条件的第一个页first-fit
  102ac0:	e9 0a 01 00 00       	jmp    102bcf <default_alloc_pages+0x15a>
		struct Page* p = le2page(le, page_link);
  102ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ac8:	83 e8 0c             	sub    $0xc,%eax
  102acb:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (p->property >= n) {//找到，p->property >= n
  102ace:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ad1:	8b 40 08             	mov    0x8(%eax),%eax
  102ad4:	3b 45 08             	cmp    0x8(%ebp),%eax
  102ad7:	0f 82 f2 00 00 00    	jb     102bcf <default_alloc_pages+0x15a>
			int i;
			for (i = 0; i < n; i++) {//将即将要分配的页标志为已使用，并清零property
  102add:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102ae4:	eb 7c                	jmp    102b62 <default_alloc_pages+0xed>
  102ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ae9:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102aec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102aef:	8b 40 04             	mov    0x4(%eax),%eax
				len = list_next(le);
  102af2:	89 45 e8             	mov    %eax,-0x18(%ebp)
				struct Page* pp = le2page(le, page_link);
  102af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102af8:	83 e8 0c             	sub    $0xc,%eax
  102afb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				SetPageReserved(pp);//标记
  102afe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b01:	83 c0 04             	add    $0x4,%eax
  102b04:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102b0b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  102b0e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102b11:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102b14:	0f ab 10             	bts    %edx,(%eax)
				ClearPageProperty(pp);
  102b17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b1a:	83 c0 04             	add    $0x4,%eax
  102b1d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  102b24:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102b27:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102b2a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102b2d:	0f b3 10             	btr    %edx,(%eax)
  102b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b33:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102b36:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102b39:	8b 40 04             	mov    0x4(%eax),%eax
  102b3c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102b3f:	8b 12                	mov    (%edx),%edx
  102b41:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102b44:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102b47:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102b4a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102b4d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102b50:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102b53:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102b56:	89 10                	mov    %edx,(%eax)
				list_del(le);//将该页从链表移出去
				le = len;
  102b58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b5b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while ((le = list_next(le)) != &free_list) {//遍历空闲页链表每一页，找到符合条件的第一个页first-fit
		struct Page* p = le2page(le, page_link);
		if (p->property >= n) {//找到，p->property >= n
			int i;
			for (i = 0; i < n; i++) {//将即将要分配的页标志为已使用，并清零property
  102b5e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  102b62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b65:	3b 45 08             	cmp    0x8(%ebp),%eax
  102b68:	0f 82 78 ff ff ff    	jb     102ae6 <default_alloc_pages+0x71>
				SetPageReserved(pp);//标记
				ClearPageProperty(pp);
				list_del(le);//将该页从链表移出去
				le = len;
			}
			if (p->property > n) {//如果有外碎片
  102b6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b71:	8b 40 08             	mov    0x8(%eax),%eax
  102b74:	3b 45 08             	cmp    0x8(%ebp),%eax
  102b77:	76 12                	jbe    102b8b <default_alloc_pages+0x116>
				(le2page(le, page_link))->property = p->property - n;//置外碎片首页property为剩余数目
  102b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b7c:	8d 50 f4             	lea    -0xc(%eax),%edx
  102b7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b82:	8b 40 08             	mov    0x8(%eax),%eax
  102b85:	2b 45 08             	sub    0x8(%ebp),%eax
  102b88:	89 42 08             	mov    %eax,0x8(%edx)
			}
			ClearPageProperty(p);
  102b8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b8e:	83 c0 04             	add    $0x4,%eax
  102b91:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  102b98:	89 45 bc             	mov    %eax,-0x44(%ebp)
  102b9b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102b9e:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102ba1:	0f b3 10             	btr    %edx,(%eax)
			SetPageReserved(p);
  102ba4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ba7:	83 c0 04             	add    $0x4,%eax
  102baa:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
  102bb1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102bb4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102bb7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102bba:	0f ab 10             	bts    %edx,(%eax)
			nr_free -= n;//更新空闲页链表页数
  102bbd:	a1 58 89 11 00       	mov    0x118958,%eax
  102bc2:	2b 45 08             	sub    0x8(%ebp),%eax
  102bc5:	a3 58 89 11 00       	mov    %eax,0x118958
			return p;
  102bca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102bcd:	eb 21                	jmp    102bf0 <default_alloc_pages+0x17b>
  102bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bd2:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102bd5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102bd8:	8b 40 04             	mov    0x4(%eax),%eax
		return NULL;
	}//如果n大于可分配页数直接返回null
	list_entry_t* le, * len;
	le = &free_list;

	while ((le = list_next(le)) != &free_list) {//遍历空闲页链表每一页，找到符合条件的第一个页first-fit
  102bdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102bde:	81 7d f4 50 89 11 00 	cmpl   $0x118950,-0xc(%ebp)
  102be5:	0f 85 da fe ff ff    	jne    102ac5 <default_alloc_pages+0x50>
			SetPageReserved(p);
			nr_free -= n;//更新空闲页链表页数
			return p;
		}
	}
	return NULL;//找不到合适的返回null
  102beb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102bf0:	c9                   	leave  
  102bf1:	c3                   	ret    

00102bf2 <default_free_pages>:


static void
default_free_pages(struct Page* base, size_t n) {
  102bf2:	55                   	push   %ebp
  102bf3:	89 e5                	mov    %esp,%ebp
  102bf5:	83 ec 68             	sub    $0x68,%esp
	assert(n > 0);
  102bf8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102bfc:	75 24                	jne    102c22 <default_free_pages+0x30>
  102bfe:	c7 44 24 0c b0 66 10 	movl   $0x1066b0,0xc(%esp)
  102c05:	00 
  102c06:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  102c0d:	00 
  102c0e:	c7 44 24 04 78 00 00 	movl   $0x78,0x4(%esp)
  102c15:	00 
  102c16:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  102c1d:	e8 a4 e0 ff ff       	call   100cc6 <__panic>
	assert(PageReserved(base));//如果是保留页就报错
  102c22:	8b 45 08             	mov    0x8(%ebp),%eax
  102c25:	83 c0 04             	add    $0x4,%eax
  102c28:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  102c2f:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102c32:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c35:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102c38:	0f a3 10             	bt     %edx,(%eax)
  102c3b:	19 c0                	sbb    %eax,%eax
  102c3d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  102c40:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102c44:	0f 95 c0             	setne  %al
  102c47:	0f b6 c0             	movzbl %al,%eax
  102c4a:	85 c0                	test   %eax,%eax
  102c4c:	75 24                	jne    102c72 <default_free_pages+0x80>
  102c4e:	c7 44 24 0c f1 66 10 	movl   $0x1066f1,0xc(%esp)
  102c55:	00 
  102c56:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  102c5d:	00 
  102c5e:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
  102c65:	00 
  102c66:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  102c6d:	e8 54 e0 ff ff       	call   100cc6 <__panic>
	list_entry_t* le = &free_list;
  102c72:	c7 45 f4 50 89 11 00 	movl   $0x118950,-0xc(%ebp)
	struct Page* p;
	while ((le = list_next(le)) != &free_list) {//遍历空闲页链表，根据地址按序找到插入点
  102c79:	eb 13                	jmp    102c8e <default_free_pages+0x9c>
		p = le2page(le, page_link);
  102c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c7e:	83 e8 0c             	sub    $0xc,%eax
  102c81:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (p > base) {
  102c84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c87:	3b 45 08             	cmp    0x8(%ebp),%eax
  102c8a:	76 02                	jbe    102c8e <default_free_pages+0x9c>
			break;
  102c8c:	eb 18                	jmp    102ca6 <default_free_pages+0xb4>
  102c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c91:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102c94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102c97:	8b 40 04             	mov    0x4(%eax),%eax
default_free_pages(struct Page* base, size_t n) {
	assert(n > 0);
	assert(PageReserved(base));//如果是保留页就报错
	list_entry_t* le = &free_list;
	struct Page* p;
	while ((le = list_next(le)) != &free_list) {//遍历空闲页链表，根据地址按序找到插入点
  102c9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c9d:	81 7d f4 50 89 11 00 	cmpl   $0x118950,-0xc(%ebp)
  102ca4:	75 d5                	jne    102c7b <default_free_pages+0x89>
		p = le2page(le, page_link);
		if (p > base) {
			break;
		}
	}
	for (p = base; p < base + n; p++) {
  102ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ca9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102cac:	eb 4b                	jmp    102cf9 <default_free_pages+0x107>
		list_add_before(le, &(p->page_link));
  102cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cb1:	8d 50 0c             	lea    0xc(%eax),%edx
  102cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cb7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  102cba:	89 55 d8             	mov    %edx,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102cbd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102cc0:	8b 00                	mov    (%eax),%eax
  102cc2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102cc5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102cc8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102ccb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102cce:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102cd1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102cd4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102cd7:	89 10                	mov    %edx,(%eax)
  102cd9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102cdc:	8b 10                	mov    (%eax),%edx
  102cde:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102ce1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102ce4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102ce7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102cea:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102ced:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102cf0:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102cf3:	89 10                	mov    %edx,(%eax)
		p = le2page(le, page_link);
		if (p > base) {
			break;
		}
	}
	for (p = base; p < base + n; p++) {
  102cf5:	83 45 f0 14          	addl   $0x14,-0x10(%ebp)
  102cf9:	8b 55 0c             	mov    0xc(%ebp),%edx
  102cfc:	89 d0                	mov    %edx,%eax
  102cfe:	c1 e0 02             	shl    $0x2,%eax
  102d01:	01 d0                	add    %edx,%eax
  102d03:	c1 e0 02             	shl    $0x2,%eax
  102d06:	89 c2                	mov    %eax,%edx
  102d08:	8b 45 08             	mov    0x8(%ebp),%eax
  102d0b:	01 d0                	add    %edx,%eax
  102d0d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102d10:	77 9c                	ja     102cae <default_free_pages+0xbc>
		list_add_before(le, &(p->page_link));
	}//将base开始的n页插入
	base->flags = 0;
  102d12:	8b 45 08             	mov    0x8(%ebp),%eax
  102d15:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	set_page_ref(base, 0);
  102d1c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102d23:	00 
  102d24:	8b 45 08             	mov    0x8(%ebp),%eax
  102d27:	89 04 24             	mov    %eax,(%esp)
  102d2a:	e8 bd fb ff ff       	call   1028ec <set_page_ref>
	ClearPageProperty(base);
  102d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  102d32:	83 c0 04             	add    $0x4,%eax
  102d35:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  102d3c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102d3f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102d42:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102d45:	0f b3 10             	btr    %edx,(%eax)
	SetPageProperty(base);//初始化插入的页
  102d48:	8b 45 08             	mov    0x8(%ebp),%eax
  102d4b:	83 c0 04             	add    $0x4,%eax
  102d4e:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  102d55:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102d58:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102d5b:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102d5e:	0f ab 10             	bts    %edx,(%eax)
	base->property = n;//将base的property置n
  102d61:	8b 45 08             	mov    0x8(%ebp),%eax
  102d64:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d67:	89 50 08             	mov    %edx,0x8(%eax)

	p = le2page(le, page_link);//如果遇到连续可合并，进行合并
  102d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d6d:	83 e8 0c             	sub    $0xc,%eax
  102d70:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (base + n == p) {
  102d73:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d76:	89 d0                	mov    %edx,%eax
  102d78:	c1 e0 02             	shl    $0x2,%eax
  102d7b:	01 d0                	add    %edx,%eax
  102d7d:	c1 e0 02             	shl    $0x2,%eax
  102d80:	89 c2                	mov    %eax,%edx
  102d82:	8b 45 08             	mov    0x8(%ebp),%eax
  102d85:	01 d0                	add    %edx,%eax
  102d87:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102d8a:	75 1e                	jne    102daa <default_free_pages+0x1b8>
		base->property += p->property;
  102d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d8f:	8b 50 08             	mov    0x8(%eax),%edx
  102d92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d95:	8b 40 08             	mov    0x8(%eax),%eax
  102d98:	01 c2                	add    %eax,%edx
  102d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  102d9d:	89 50 08             	mov    %edx,0x8(%eax)
		p->property = 0;
  102da0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102da3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	}
	le = list_prev(&(base->page_link));
  102daa:	8b 45 08             	mov    0x8(%ebp),%eax
  102dad:	83 c0 0c             	add    $0xc,%eax
  102db0:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
  102db3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102db6:	8b 00                	mov    (%eax),%eax
  102db8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	p = le2page(le, page_link);
  102dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dbe:	83 e8 0c             	sub    $0xc,%eax
  102dc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (le != &free_list && p == base - 1) {
  102dc4:	81 7d f4 50 89 11 00 	cmpl   $0x118950,-0xc(%ebp)
  102dcb:	74 57                	je     102e24 <default_free_pages+0x232>
  102dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  102dd0:	83 e8 14             	sub    $0x14,%eax
  102dd3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102dd6:	75 4c                	jne    102e24 <default_free_pages+0x232>
		while (le != &free_list) {
  102dd8:	eb 41                	jmp    102e1b <default_free_pages+0x229>
			if (p->property) {
  102dda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ddd:	8b 40 08             	mov    0x8(%eax),%eax
  102de0:	85 c0                	test   %eax,%eax
  102de2:	74 20                	je     102e04 <default_free_pages+0x212>
				p->property += base->property;
  102de4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102de7:	8b 50 08             	mov    0x8(%eax),%edx
  102dea:	8b 45 08             	mov    0x8(%ebp),%eax
  102ded:	8b 40 08             	mov    0x8(%eax),%eax
  102df0:	01 c2                	add    %eax,%edx
  102df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102df5:	89 50 08             	mov    %edx,0x8(%eax)
				base->property = 0;
  102df8:	8b 45 08             	mov    0x8(%ebp),%eax
  102dfb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				break;
  102e02:	eb 20                	jmp    102e24 <default_free_pages+0x232>
  102e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e07:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  102e0a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102e0d:	8b 00                	mov    (%eax),%eax
			}
			le = list_prev(le);
  102e0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
			p = le2page(le, page_link);
  102e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e15:	83 e8 0c             	sub    $0xc,%eax
  102e18:	89 45 f0             	mov    %eax,-0x10(%ebp)
		p->property = 0;
	}
	le = list_prev(&(base->page_link));
	p = le2page(le, page_link);
	if (le != &free_list && p == base - 1) {
		while (le != &free_list) {
  102e1b:	81 7d f4 50 89 11 00 	cmpl   $0x118950,-0xc(%ebp)
  102e22:	75 b6                	jne    102dda <default_free_pages+0x1e8>
			le = list_prev(le);
			p = le2page(le, page_link);
		}
	}

	nr_free += n;
  102e24:	8b 15 58 89 11 00    	mov    0x118958,%edx
  102e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e2d:	01 d0                	add    %edx,%eax
  102e2f:	a3 58 89 11 00       	mov    %eax,0x118958
	return;
  102e34:	90                   	nop
}
  102e35:	c9                   	leave  
  102e36:	c3                   	ret    

00102e37 <default_nr_free_pages>:
static size_t
default_nr_free_pages(void) {
  102e37:	55                   	push   %ebp
  102e38:	89 e5                	mov    %esp,%ebp
    return nr_free;
  102e3a:	a1 58 89 11 00       	mov    0x118958,%eax
}
  102e3f:	5d                   	pop    %ebp
  102e40:	c3                   	ret    

00102e41 <basic_check>:

static void
basic_check(void) {
  102e41:	55                   	push   %ebp
  102e42:	89 e5                	mov    %esp,%ebp
  102e44:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  102e47:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102e4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e51:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e57:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  102e5a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102e61:	e8 85 0e 00 00       	call   103ceb <alloc_pages>
  102e66:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102e69:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  102e6d:	75 24                	jne    102e93 <basic_check+0x52>
  102e6f:	c7 44 24 0c 04 67 10 	movl   $0x106704,0xc(%esp)
  102e76:	00 
  102e77:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  102e7e:	00 
  102e7f:	c7 44 24 04 aa 00 00 	movl   $0xaa,0x4(%esp)
  102e86:	00 
  102e87:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  102e8e:	e8 33 de ff ff       	call   100cc6 <__panic>
    assert((p1 = alloc_page()) != NULL);
  102e93:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102e9a:	e8 4c 0e 00 00       	call   103ceb <alloc_pages>
  102e9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ea2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102ea6:	75 24                	jne    102ecc <basic_check+0x8b>
  102ea8:	c7 44 24 0c 20 67 10 	movl   $0x106720,0xc(%esp)
  102eaf:	00 
  102eb0:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  102eb7:	00 
  102eb8:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
  102ebf:	00 
  102ec0:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  102ec7:	e8 fa dd ff ff       	call   100cc6 <__panic>
    assert((p2 = alloc_page()) != NULL);
  102ecc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102ed3:	e8 13 0e 00 00       	call   103ceb <alloc_pages>
  102ed8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102edb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102edf:	75 24                	jne    102f05 <basic_check+0xc4>
  102ee1:	c7 44 24 0c 3c 67 10 	movl   $0x10673c,0xc(%esp)
  102ee8:	00 
  102ee9:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  102ef0:	00 
  102ef1:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  102ef8:	00 
  102ef9:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  102f00:	e8 c1 dd ff ff       	call   100cc6 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  102f05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f08:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102f0b:	74 10                	je     102f1d <basic_check+0xdc>
  102f0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f10:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102f13:	74 08                	je     102f1d <basic_check+0xdc>
  102f15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f18:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102f1b:	75 24                	jne    102f41 <basic_check+0x100>
  102f1d:	c7 44 24 0c 58 67 10 	movl   $0x106758,0xc(%esp)
  102f24:	00 
  102f25:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  102f2c:	00 
  102f2d:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
  102f34:	00 
  102f35:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  102f3c:	e8 85 dd ff ff       	call   100cc6 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  102f41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f44:	89 04 24             	mov    %eax,(%esp)
  102f47:	e8 96 f9 ff ff       	call   1028e2 <page_ref>
  102f4c:	85 c0                	test   %eax,%eax
  102f4e:	75 1e                	jne    102f6e <basic_check+0x12d>
  102f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f53:	89 04 24             	mov    %eax,(%esp)
  102f56:	e8 87 f9 ff ff       	call   1028e2 <page_ref>
  102f5b:	85 c0                	test   %eax,%eax
  102f5d:	75 0f                	jne    102f6e <basic_check+0x12d>
  102f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f62:	89 04 24             	mov    %eax,(%esp)
  102f65:	e8 78 f9 ff ff       	call   1028e2 <page_ref>
  102f6a:	85 c0                	test   %eax,%eax
  102f6c:	74 24                	je     102f92 <basic_check+0x151>
  102f6e:	c7 44 24 0c 7c 67 10 	movl   $0x10677c,0xc(%esp)
  102f75:	00 
  102f76:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  102f7d:	00 
  102f7e:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
  102f85:	00 
  102f86:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  102f8d:	e8 34 dd ff ff       	call   100cc6 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  102f92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f95:	89 04 24             	mov    %eax,(%esp)
  102f98:	e8 2f f9 ff ff       	call   1028cc <page2pa>
  102f9d:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102fa3:	c1 e2 0c             	shl    $0xc,%edx
  102fa6:	39 d0                	cmp    %edx,%eax
  102fa8:	72 24                	jb     102fce <basic_check+0x18d>
  102faa:	c7 44 24 0c b8 67 10 	movl   $0x1067b8,0xc(%esp)
  102fb1:	00 
  102fb2:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  102fb9:	00 
  102fba:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  102fc1:	00 
  102fc2:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  102fc9:	e8 f8 dc ff ff       	call   100cc6 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  102fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fd1:	89 04 24             	mov    %eax,(%esp)
  102fd4:	e8 f3 f8 ff ff       	call   1028cc <page2pa>
  102fd9:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102fdf:	c1 e2 0c             	shl    $0xc,%edx
  102fe2:	39 d0                	cmp    %edx,%eax
  102fe4:	72 24                	jb     10300a <basic_check+0x1c9>
  102fe6:	c7 44 24 0c d5 67 10 	movl   $0x1067d5,0xc(%esp)
  102fed:	00 
  102fee:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  102ff5:	00 
  102ff6:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
  102ffd:	00 
  102ffe:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  103005:	e8 bc dc ff ff       	call   100cc6 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  10300a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10300d:	89 04 24             	mov    %eax,(%esp)
  103010:	e8 b7 f8 ff ff       	call   1028cc <page2pa>
  103015:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  10301b:	c1 e2 0c             	shl    $0xc,%edx
  10301e:	39 d0                	cmp    %edx,%eax
  103020:	72 24                	jb     103046 <basic_check+0x205>
  103022:	c7 44 24 0c f2 67 10 	movl   $0x1067f2,0xc(%esp)
  103029:	00 
  10302a:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  103031:	00 
  103032:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
  103039:	00 
  10303a:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  103041:	e8 80 dc ff ff       	call   100cc6 <__panic>

    list_entry_t free_list_store = free_list;
  103046:	a1 50 89 11 00       	mov    0x118950,%eax
  10304b:	8b 15 54 89 11 00    	mov    0x118954,%edx
  103051:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103054:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103057:	c7 45 e0 50 89 11 00 	movl   $0x118950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  10305e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103061:	8b 55 e0             	mov    -0x20(%ebp),%edx
  103064:	89 50 04             	mov    %edx,0x4(%eax)
  103067:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10306a:	8b 50 04             	mov    0x4(%eax),%edx
  10306d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103070:	89 10                	mov    %edx,(%eax)
  103072:	c7 45 dc 50 89 11 00 	movl   $0x118950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  103079:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10307c:	8b 40 04             	mov    0x4(%eax),%eax
  10307f:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  103082:	0f 94 c0             	sete   %al
  103085:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  103088:	85 c0                	test   %eax,%eax
  10308a:	75 24                	jne    1030b0 <basic_check+0x26f>
  10308c:	c7 44 24 0c 0f 68 10 	movl   $0x10680f,0xc(%esp)
  103093:	00 
  103094:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  10309b:	00 
  10309c:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  1030a3:	00 
  1030a4:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  1030ab:	e8 16 dc ff ff       	call   100cc6 <__panic>

    unsigned int nr_free_store = nr_free;
  1030b0:	a1 58 89 11 00       	mov    0x118958,%eax
  1030b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  1030b8:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  1030bf:	00 00 00 

    assert(alloc_page() == NULL);
  1030c2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1030c9:	e8 1d 0c 00 00       	call   103ceb <alloc_pages>
  1030ce:	85 c0                	test   %eax,%eax
  1030d0:	74 24                	je     1030f6 <basic_check+0x2b5>
  1030d2:	c7 44 24 0c 26 68 10 	movl   $0x106826,0xc(%esp)
  1030d9:	00 
  1030da:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  1030e1:	00 
  1030e2:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
  1030e9:	00 
  1030ea:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  1030f1:	e8 d0 db ff ff       	call   100cc6 <__panic>

    free_page(p0);
  1030f6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1030fd:	00 
  1030fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103101:	89 04 24             	mov    %eax,(%esp)
  103104:	e8 1a 0c 00 00       	call   103d23 <free_pages>
    free_page(p1);
  103109:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103110:	00 
  103111:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103114:	89 04 24             	mov    %eax,(%esp)
  103117:	e8 07 0c 00 00       	call   103d23 <free_pages>
    free_page(p2);
  10311c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103123:	00 
  103124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103127:	89 04 24             	mov    %eax,(%esp)
  10312a:	e8 f4 0b 00 00       	call   103d23 <free_pages>
    assert(nr_free == 3);
  10312f:	a1 58 89 11 00       	mov    0x118958,%eax
  103134:	83 f8 03             	cmp    $0x3,%eax
  103137:	74 24                	je     10315d <basic_check+0x31c>
  103139:	c7 44 24 0c 3b 68 10 	movl   $0x10683b,0xc(%esp)
  103140:	00 
  103141:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  103148:	00 
  103149:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
  103150:	00 
  103151:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  103158:	e8 69 db ff ff       	call   100cc6 <__panic>

    assert((p0 = alloc_page()) != NULL);
  10315d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103164:	e8 82 0b 00 00       	call   103ceb <alloc_pages>
  103169:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10316c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103170:	75 24                	jne    103196 <basic_check+0x355>
  103172:	c7 44 24 0c 04 67 10 	movl   $0x106704,0xc(%esp)
  103179:	00 
  10317a:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  103181:	00 
  103182:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
  103189:	00 
  10318a:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  103191:	e8 30 db ff ff       	call   100cc6 <__panic>
    assert((p1 = alloc_page()) != NULL);
  103196:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10319d:	e8 49 0b 00 00       	call   103ceb <alloc_pages>
  1031a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1031a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1031a9:	75 24                	jne    1031cf <basic_check+0x38e>
  1031ab:	c7 44 24 0c 20 67 10 	movl   $0x106720,0xc(%esp)
  1031b2:	00 
  1031b3:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  1031ba:	00 
  1031bb:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
  1031c2:	00 
  1031c3:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  1031ca:	e8 f7 da ff ff       	call   100cc6 <__panic>
    assert((p2 = alloc_page()) != NULL);
  1031cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031d6:	e8 10 0b 00 00       	call   103ceb <alloc_pages>
  1031db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1031de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1031e2:	75 24                	jne    103208 <basic_check+0x3c7>
  1031e4:	c7 44 24 0c 3c 67 10 	movl   $0x10673c,0xc(%esp)
  1031eb:	00 
  1031ec:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  1031f3:	00 
  1031f4:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
  1031fb:	00 
  1031fc:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  103203:	e8 be da ff ff       	call   100cc6 <__panic>

    assert(alloc_page() == NULL);
  103208:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10320f:	e8 d7 0a 00 00       	call   103ceb <alloc_pages>
  103214:	85 c0                	test   %eax,%eax
  103216:	74 24                	je     10323c <basic_check+0x3fb>
  103218:	c7 44 24 0c 26 68 10 	movl   $0x106826,0xc(%esp)
  10321f:	00 
  103220:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  103227:	00 
  103228:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
  10322f:	00 
  103230:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  103237:	e8 8a da ff ff       	call   100cc6 <__panic>

    free_page(p0);
  10323c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103243:	00 
  103244:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103247:	89 04 24             	mov    %eax,(%esp)
  10324a:	e8 d4 0a 00 00       	call   103d23 <free_pages>
  10324f:	c7 45 d8 50 89 11 00 	movl   $0x118950,-0x28(%ebp)
  103256:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103259:	8b 40 04             	mov    0x4(%eax),%eax
  10325c:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  10325f:	0f 94 c0             	sete   %al
  103262:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  103265:	85 c0                	test   %eax,%eax
  103267:	74 24                	je     10328d <basic_check+0x44c>
  103269:	c7 44 24 0c 48 68 10 	movl   $0x106848,0xc(%esp)
  103270:	00 
  103271:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  103278:	00 
  103279:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
  103280:	00 
  103281:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  103288:	e8 39 da ff ff       	call   100cc6 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  10328d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103294:	e8 52 0a 00 00       	call   103ceb <alloc_pages>
  103299:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10329c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10329f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1032a2:	74 24                	je     1032c8 <basic_check+0x487>
  1032a4:	c7 44 24 0c 60 68 10 	movl   $0x106860,0xc(%esp)
  1032ab:	00 
  1032ac:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  1032b3:	00 
  1032b4:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
  1032bb:	00 
  1032bc:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  1032c3:	e8 fe d9 ff ff       	call   100cc6 <__panic>
    assert(alloc_page() == NULL);
  1032c8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032cf:	e8 17 0a 00 00       	call   103ceb <alloc_pages>
  1032d4:	85 c0                	test   %eax,%eax
  1032d6:	74 24                	je     1032fc <basic_check+0x4bb>
  1032d8:	c7 44 24 0c 26 68 10 	movl   $0x106826,0xc(%esp)
  1032df:	00 
  1032e0:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  1032e7:	00 
  1032e8:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
  1032ef:	00 
  1032f0:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  1032f7:	e8 ca d9 ff ff       	call   100cc6 <__panic>

    assert(nr_free == 0);
  1032fc:	a1 58 89 11 00       	mov    0x118958,%eax
  103301:	85 c0                	test   %eax,%eax
  103303:	74 24                	je     103329 <basic_check+0x4e8>
  103305:	c7 44 24 0c 79 68 10 	movl   $0x106879,0xc(%esp)
  10330c:	00 
  10330d:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  103314:	00 
  103315:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
  10331c:	00 
  10331d:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  103324:	e8 9d d9 ff ff       	call   100cc6 <__panic>
    free_list = free_list_store;
  103329:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10332c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10332f:	a3 50 89 11 00       	mov    %eax,0x118950
  103334:	89 15 54 89 11 00    	mov    %edx,0x118954
    nr_free = nr_free_store;
  10333a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10333d:	a3 58 89 11 00       	mov    %eax,0x118958

    free_page(p);
  103342:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103349:	00 
  10334a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10334d:	89 04 24             	mov    %eax,(%esp)
  103350:	e8 ce 09 00 00       	call   103d23 <free_pages>
    free_page(p1);
  103355:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10335c:	00 
  10335d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103360:	89 04 24             	mov    %eax,(%esp)
  103363:	e8 bb 09 00 00       	call   103d23 <free_pages>
    free_page(p2);
  103368:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10336f:	00 
  103370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103373:	89 04 24             	mov    %eax,(%esp)
  103376:	e8 a8 09 00 00       	call   103d23 <free_pages>
}
  10337b:	c9                   	leave  
  10337c:	c3                   	ret    

0010337d <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  10337d:	55                   	push   %ebp
  10337e:	89 e5                	mov    %esp,%ebp
  103380:	53                   	push   %ebx
  103381:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  103387:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10338e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  103395:	c7 45 ec 50 89 11 00 	movl   $0x118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  10339c:	eb 6b                	jmp    103409 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  10339e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033a1:	83 e8 0c             	sub    $0xc,%eax
  1033a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  1033a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033aa:	83 c0 04             	add    $0x4,%eax
  1033ad:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  1033b4:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1033b7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1033ba:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1033bd:	0f a3 10             	bt     %edx,(%eax)
  1033c0:	19 c0                	sbb    %eax,%eax
  1033c2:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  1033c5:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  1033c9:	0f 95 c0             	setne  %al
  1033cc:	0f b6 c0             	movzbl %al,%eax
  1033cf:	85 c0                	test   %eax,%eax
  1033d1:	75 24                	jne    1033f7 <default_check+0x7a>
  1033d3:	c7 44 24 0c 86 68 10 	movl   $0x106886,0xc(%esp)
  1033da:	00 
  1033db:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  1033e2:	00 
  1033e3:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
  1033ea:	00 
  1033eb:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  1033f2:	e8 cf d8 ff ff       	call   100cc6 <__panic>
        count ++, total += p->property;
  1033f7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1033fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033fe:	8b 50 08             	mov    0x8(%eax),%edx
  103401:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103404:	01 d0                	add    %edx,%eax
  103406:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103409:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10340c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  10340f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103412:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  103415:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103418:	81 7d ec 50 89 11 00 	cmpl   $0x118950,-0x14(%ebp)
  10341f:	0f 85 79 ff ff ff    	jne    10339e <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  103425:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  103428:	e8 28 09 00 00       	call   103d55 <nr_free_pages>
  10342d:	39 c3                	cmp    %eax,%ebx
  10342f:	74 24                	je     103455 <default_check+0xd8>
  103431:	c7 44 24 0c 96 68 10 	movl   $0x106896,0xc(%esp)
  103438:	00 
  103439:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  103440:	00 
  103441:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
  103448:	00 
  103449:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  103450:	e8 71 d8 ff ff       	call   100cc6 <__panic>

    basic_check();
  103455:	e8 e7 f9 ff ff       	call   102e41 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  10345a:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103461:	e8 85 08 00 00       	call   103ceb <alloc_pages>
  103466:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  103469:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10346d:	75 24                	jne    103493 <default_check+0x116>
  10346f:	c7 44 24 0c af 68 10 	movl   $0x1068af,0xc(%esp)
  103476:	00 
  103477:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  10347e:	00 
  10347f:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
  103486:	00 
  103487:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  10348e:	e8 33 d8 ff ff       	call   100cc6 <__panic>
    assert(!PageProperty(p0));
  103493:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103496:	83 c0 04             	add    $0x4,%eax
  103499:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  1034a0:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1034a3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1034a6:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1034a9:	0f a3 10             	bt     %edx,(%eax)
  1034ac:	19 c0                	sbb    %eax,%eax
  1034ae:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  1034b1:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  1034b5:	0f 95 c0             	setne  %al
  1034b8:	0f b6 c0             	movzbl %al,%eax
  1034bb:	85 c0                	test   %eax,%eax
  1034bd:	74 24                	je     1034e3 <default_check+0x166>
  1034bf:	c7 44 24 0c ba 68 10 	movl   $0x1068ba,0xc(%esp)
  1034c6:	00 
  1034c7:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  1034ce:	00 
  1034cf:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
  1034d6:	00 
  1034d7:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  1034de:	e8 e3 d7 ff ff       	call   100cc6 <__panic>

    list_entry_t free_list_store = free_list;
  1034e3:	a1 50 89 11 00       	mov    0x118950,%eax
  1034e8:	8b 15 54 89 11 00    	mov    0x118954,%edx
  1034ee:	89 45 80             	mov    %eax,-0x80(%ebp)
  1034f1:	89 55 84             	mov    %edx,-0x7c(%ebp)
  1034f4:	c7 45 b4 50 89 11 00 	movl   $0x118950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1034fb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1034fe:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103501:	89 50 04             	mov    %edx,0x4(%eax)
  103504:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103507:	8b 50 04             	mov    0x4(%eax),%edx
  10350a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10350d:	89 10                	mov    %edx,(%eax)
  10350f:	c7 45 b0 50 89 11 00 	movl   $0x118950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  103516:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103519:	8b 40 04             	mov    0x4(%eax),%eax
  10351c:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  10351f:	0f 94 c0             	sete   %al
  103522:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  103525:	85 c0                	test   %eax,%eax
  103527:	75 24                	jne    10354d <default_check+0x1d0>
  103529:	c7 44 24 0c 0f 68 10 	movl   $0x10680f,0xc(%esp)
  103530:	00 
  103531:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  103538:	00 
  103539:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
  103540:	00 
  103541:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  103548:	e8 79 d7 ff ff       	call   100cc6 <__panic>
    assert(alloc_page() == NULL);
  10354d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103554:	e8 92 07 00 00       	call   103ceb <alloc_pages>
  103559:	85 c0                	test   %eax,%eax
  10355b:	74 24                	je     103581 <default_check+0x204>
  10355d:	c7 44 24 0c 26 68 10 	movl   $0x106826,0xc(%esp)
  103564:	00 
  103565:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  10356c:	00 
  10356d:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
  103574:	00 
  103575:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  10357c:	e8 45 d7 ff ff       	call   100cc6 <__panic>

    unsigned int nr_free_store = nr_free;
  103581:	a1 58 89 11 00       	mov    0x118958,%eax
  103586:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  103589:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  103590:	00 00 00 

    free_pages(p0 + 2, 3);
  103593:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103596:	83 c0 28             	add    $0x28,%eax
  103599:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1035a0:	00 
  1035a1:	89 04 24             	mov    %eax,(%esp)
  1035a4:	e8 7a 07 00 00       	call   103d23 <free_pages>
    assert(alloc_pages(4) == NULL);
  1035a9:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1035b0:	e8 36 07 00 00       	call   103ceb <alloc_pages>
  1035b5:	85 c0                	test   %eax,%eax
  1035b7:	74 24                	je     1035dd <default_check+0x260>
  1035b9:	c7 44 24 0c cc 68 10 	movl   $0x1068cc,0xc(%esp)
  1035c0:	00 
  1035c1:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  1035c8:	00 
  1035c9:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
  1035d0:	00 
  1035d1:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  1035d8:	e8 e9 d6 ff ff       	call   100cc6 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  1035dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035e0:	83 c0 28             	add    $0x28,%eax
  1035e3:	83 c0 04             	add    $0x4,%eax
  1035e6:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  1035ed:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1035f0:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1035f3:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1035f6:	0f a3 10             	bt     %edx,(%eax)
  1035f9:	19 c0                	sbb    %eax,%eax
  1035fb:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  1035fe:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  103602:	0f 95 c0             	setne  %al
  103605:	0f b6 c0             	movzbl %al,%eax
  103608:	85 c0                	test   %eax,%eax
  10360a:	74 0e                	je     10361a <default_check+0x29d>
  10360c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10360f:	83 c0 28             	add    $0x28,%eax
  103612:	8b 40 08             	mov    0x8(%eax),%eax
  103615:	83 f8 03             	cmp    $0x3,%eax
  103618:	74 24                	je     10363e <default_check+0x2c1>
  10361a:	c7 44 24 0c e4 68 10 	movl   $0x1068e4,0xc(%esp)
  103621:	00 
  103622:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  103629:	00 
  10362a:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
  103631:	00 
  103632:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  103639:	e8 88 d6 ff ff       	call   100cc6 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  10363e:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  103645:	e8 a1 06 00 00       	call   103ceb <alloc_pages>
  10364a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10364d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103651:	75 24                	jne    103677 <default_check+0x2fa>
  103653:	c7 44 24 0c 10 69 10 	movl   $0x106910,0xc(%esp)
  10365a:	00 
  10365b:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  103662:	00 
  103663:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
  10366a:	00 
  10366b:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  103672:	e8 4f d6 ff ff       	call   100cc6 <__panic>
    assert(alloc_page() == NULL);
  103677:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10367e:	e8 68 06 00 00       	call   103ceb <alloc_pages>
  103683:	85 c0                	test   %eax,%eax
  103685:	74 24                	je     1036ab <default_check+0x32e>
  103687:	c7 44 24 0c 26 68 10 	movl   $0x106826,0xc(%esp)
  10368e:	00 
  10368f:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  103696:	00 
  103697:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
  10369e:	00 
  10369f:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  1036a6:	e8 1b d6 ff ff       	call   100cc6 <__panic>
    assert(p0 + 2 == p1);
  1036ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036ae:	83 c0 28             	add    $0x28,%eax
  1036b1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  1036b4:	74 24                	je     1036da <default_check+0x35d>
  1036b6:	c7 44 24 0c 2e 69 10 	movl   $0x10692e,0xc(%esp)
  1036bd:	00 
  1036be:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  1036c5:	00 
  1036c6:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
  1036cd:	00 
  1036ce:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  1036d5:	e8 ec d5 ff ff       	call   100cc6 <__panic>

    p2 = p0 + 1;
  1036da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036dd:	83 c0 14             	add    $0x14,%eax
  1036e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  1036e3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1036ea:	00 
  1036eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036ee:	89 04 24             	mov    %eax,(%esp)
  1036f1:	e8 2d 06 00 00       	call   103d23 <free_pages>
    free_pages(p1, 3);
  1036f6:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1036fd:	00 
  1036fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103701:	89 04 24             	mov    %eax,(%esp)
  103704:	e8 1a 06 00 00       	call   103d23 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  103709:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10370c:	83 c0 04             	add    $0x4,%eax
  10370f:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  103716:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103719:	8b 45 9c             	mov    -0x64(%ebp),%eax
  10371c:	8b 55 a0             	mov    -0x60(%ebp),%edx
  10371f:	0f a3 10             	bt     %edx,(%eax)
  103722:	19 c0                	sbb    %eax,%eax
  103724:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  103727:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  10372b:	0f 95 c0             	setne  %al
  10372e:	0f b6 c0             	movzbl %al,%eax
  103731:	85 c0                	test   %eax,%eax
  103733:	74 0b                	je     103740 <default_check+0x3c3>
  103735:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103738:	8b 40 08             	mov    0x8(%eax),%eax
  10373b:	83 f8 01             	cmp    $0x1,%eax
  10373e:	74 24                	je     103764 <default_check+0x3e7>
  103740:	c7 44 24 0c 3c 69 10 	movl   $0x10693c,0xc(%esp)
  103747:	00 
  103748:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  10374f:	00 
  103750:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
  103757:	00 
  103758:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  10375f:	e8 62 d5 ff ff       	call   100cc6 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  103764:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103767:	83 c0 04             	add    $0x4,%eax
  10376a:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  103771:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103774:	8b 45 90             	mov    -0x70(%ebp),%eax
  103777:	8b 55 94             	mov    -0x6c(%ebp),%edx
  10377a:	0f a3 10             	bt     %edx,(%eax)
  10377d:	19 c0                	sbb    %eax,%eax
  10377f:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  103782:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  103786:	0f 95 c0             	setne  %al
  103789:	0f b6 c0             	movzbl %al,%eax
  10378c:	85 c0                	test   %eax,%eax
  10378e:	74 0b                	je     10379b <default_check+0x41e>
  103790:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103793:	8b 40 08             	mov    0x8(%eax),%eax
  103796:	83 f8 03             	cmp    $0x3,%eax
  103799:	74 24                	je     1037bf <default_check+0x442>
  10379b:	c7 44 24 0c 64 69 10 	movl   $0x106964,0xc(%esp)
  1037a2:	00 
  1037a3:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  1037aa:	00 
  1037ab:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  1037b2:	00 
  1037b3:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  1037ba:	e8 07 d5 ff ff       	call   100cc6 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  1037bf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1037c6:	e8 20 05 00 00       	call   103ceb <alloc_pages>
  1037cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1037ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1037d1:	83 e8 14             	sub    $0x14,%eax
  1037d4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1037d7:	74 24                	je     1037fd <default_check+0x480>
  1037d9:	c7 44 24 0c 8a 69 10 	movl   $0x10698a,0xc(%esp)
  1037e0:	00 
  1037e1:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  1037e8:	00 
  1037e9:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
  1037f0:	00 
  1037f1:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  1037f8:	e8 c9 d4 ff ff       	call   100cc6 <__panic>
    free_page(p0);
  1037fd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103804:	00 
  103805:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103808:	89 04 24             	mov    %eax,(%esp)
  10380b:	e8 13 05 00 00       	call   103d23 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  103810:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  103817:	e8 cf 04 00 00       	call   103ceb <alloc_pages>
  10381c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10381f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103822:	83 c0 14             	add    $0x14,%eax
  103825:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103828:	74 24                	je     10384e <default_check+0x4d1>
  10382a:	c7 44 24 0c a8 69 10 	movl   $0x1069a8,0xc(%esp)
  103831:	00 
  103832:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  103839:	00 
  10383a:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  103841:	00 
  103842:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  103849:	e8 78 d4 ff ff       	call   100cc6 <__panic>

    free_pages(p0, 2);
  10384e:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  103855:	00 
  103856:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103859:	89 04 24             	mov    %eax,(%esp)
  10385c:	e8 c2 04 00 00       	call   103d23 <free_pages>
    free_page(p2);
  103861:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103868:	00 
  103869:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10386c:	89 04 24             	mov    %eax,(%esp)
  10386f:	e8 af 04 00 00       	call   103d23 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  103874:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  10387b:	e8 6b 04 00 00       	call   103ceb <alloc_pages>
  103880:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103883:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103887:	75 24                	jne    1038ad <default_check+0x530>
  103889:	c7 44 24 0c c8 69 10 	movl   $0x1069c8,0xc(%esp)
  103890:	00 
  103891:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  103898:	00 
  103899:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
  1038a0:	00 
  1038a1:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  1038a8:	e8 19 d4 ff ff       	call   100cc6 <__panic>
    assert(alloc_page() == NULL);
  1038ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1038b4:	e8 32 04 00 00       	call   103ceb <alloc_pages>
  1038b9:	85 c0                	test   %eax,%eax
  1038bb:	74 24                	je     1038e1 <default_check+0x564>
  1038bd:	c7 44 24 0c 26 68 10 	movl   $0x106826,0xc(%esp)
  1038c4:	00 
  1038c5:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  1038cc:	00 
  1038cd:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
  1038d4:	00 
  1038d5:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  1038dc:	e8 e5 d3 ff ff       	call   100cc6 <__panic>

    assert(nr_free == 0);
  1038e1:	a1 58 89 11 00       	mov    0x118958,%eax
  1038e6:	85 c0                	test   %eax,%eax
  1038e8:	74 24                	je     10390e <default_check+0x591>
  1038ea:	c7 44 24 0c 79 68 10 	movl   $0x106879,0xc(%esp)
  1038f1:	00 
  1038f2:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  1038f9:	00 
  1038fa:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
  103901:	00 
  103902:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  103909:	e8 b8 d3 ff ff       	call   100cc6 <__panic>
    nr_free = nr_free_store;
  10390e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103911:	a3 58 89 11 00       	mov    %eax,0x118958

    free_list = free_list_store;
  103916:	8b 45 80             	mov    -0x80(%ebp),%eax
  103919:	8b 55 84             	mov    -0x7c(%ebp),%edx
  10391c:	a3 50 89 11 00       	mov    %eax,0x118950
  103921:	89 15 54 89 11 00    	mov    %edx,0x118954
    free_pages(p0, 5);
  103927:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  10392e:	00 
  10392f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103932:	89 04 24             	mov    %eax,(%esp)
  103935:	e8 e9 03 00 00       	call   103d23 <free_pages>

    le = &free_list;
  10393a:	c7 45 ec 50 89 11 00 	movl   $0x118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103941:	eb 1d                	jmp    103960 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
  103943:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103946:	83 e8 0c             	sub    $0xc,%eax
  103949:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  10394c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  103950:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103953:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103956:	8b 40 08             	mov    0x8(%eax),%eax
  103959:	29 c2                	sub    %eax,%edx
  10395b:	89 d0                	mov    %edx,%eax
  10395d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103960:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103963:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103966:	8b 45 88             	mov    -0x78(%ebp),%eax
  103969:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  10396c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10396f:	81 7d ec 50 89 11 00 	cmpl   $0x118950,-0x14(%ebp)
  103976:	75 cb                	jne    103943 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  103978:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10397c:	74 24                	je     1039a2 <default_check+0x625>
  10397e:	c7 44 24 0c e6 69 10 	movl   $0x1069e6,0xc(%esp)
  103985:	00 
  103986:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  10398d:	00 
  10398e:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  103995:	00 
  103996:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  10399d:	e8 24 d3 ff ff       	call   100cc6 <__panic>
    assert(total == 0);
  1039a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1039a6:	74 24                	je     1039cc <default_check+0x64f>
  1039a8:	c7 44 24 0c f1 69 10 	movl   $0x1069f1,0xc(%esp)
  1039af:	00 
  1039b0:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  1039b7:	00 
  1039b8:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
  1039bf:	00 
  1039c0:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  1039c7:	e8 fa d2 ff ff       	call   100cc6 <__panic>
}
  1039cc:	81 c4 94 00 00 00    	add    $0x94,%esp
  1039d2:	5b                   	pop    %ebx
  1039d3:	5d                   	pop    %ebp
  1039d4:	c3                   	ret    

001039d5 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  1039d5:	55                   	push   %ebp
  1039d6:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1039d8:	8b 55 08             	mov    0x8(%ebp),%edx
  1039db:	a1 64 89 11 00       	mov    0x118964,%eax
  1039e0:	29 c2                	sub    %eax,%edx
  1039e2:	89 d0                	mov    %edx,%eax
  1039e4:	c1 f8 02             	sar    $0x2,%eax
  1039e7:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1039ed:	5d                   	pop    %ebp
  1039ee:	c3                   	ret    

001039ef <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  1039ef:	55                   	push   %ebp
  1039f0:	89 e5                	mov    %esp,%ebp
  1039f2:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1039f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1039f8:	89 04 24             	mov    %eax,(%esp)
  1039fb:	e8 d5 ff ff ff       	call   1039d5 <page2ppn>
  103a00:	c1 e0 0c             	shl    $0xc,%eax
}
  103a03:	c9                   	leave  
  103a04:	c3                   	ret    

00103a05 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  103a05:	55                   	push   %ebp
  103a06:	89 e5                	mov    %esp,%ebp
  103a08:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  103a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  103a0e:	c1 e8 0c             	shr    $0xc,%eax
  103a11:	89 c2                	mov    %eax,%edx
  103a13:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103a18:	39 c2                	cmp    %eax,%edx
  103a1a:	72 1c                	jb     103a38 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  103a1c:	c7 44 24 08 2c 6a 10 	movl   $0x106a2c,0x8(%esp)
  103a23:	00 
  103a24:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  103a2b:	00 
  103a2c:	c7 04 24 4b 6a 10 00 	movl   $0x106a4b,(%esp)
  103a33:	e8 8e d2 ff ff       	call   100cc6 <__panic>
    }
    return &pages[PPN(pa)];
  103a38:	8b 0d 64 89 11 00    	mov    0x118964,%ecx
  103a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  103a41:	c1 e8 0c             	shr    $0xc,%eax
  103a44:	89 c2                	mov    %eax,%edx
  103a46:	89 d0                	mov    %edx,%eax
  103a48:	c1 e0 02             	shl    $0x2,%eax
  103a4b:	01 d0                	add    %edx,%eax
  103a4d:	c1 e0 02             	shl    $0x2,%eax
  103a50:	01 c8                	add    %ecx,%eax
}
  103a52:	c9                   	leave  
  103a53:	c3                   	ret    

00103a54 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  103a54:	55                   	push   %ebp
  103a55:	89 e5                	mov    %esp,%ebp
  103a57:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  103a5d:	89 04 24             	mov    %eax,(%esp)
  103a60:	e8 8a ff ff ff       	call   1039ef <page2pa>
  103a65:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a6b:	c1 e8 0c             	shr    $0xc,%eax
  103a6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103a71:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103a76:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103a79:	72 23                	jb     103a9e <page2kva+0x4a>
  103a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a7e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103a82:	c7 44 24 08 5c 6a 10 	movl   $0x106a5c,0x8(%esp)
  103a89:	00 
  103a8a:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103a91:	00 
  103a92:	c7 04 24 4b 6a 10 00 	movl   $0x106a4b,(%esp)
  103a99:	e8 28 d2 ff ff       	call   100cc6 <__panic>
  103a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103aa1:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103aa6:	c9                   	leave  
  103aa7:	c3                   	ret    

00103aa8 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  103aa8:	55                   	push   %ebp
  103aa9:	89 e5                	mov    %esp,%ebp
  103aab:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103aae:	8b 45 08             	mov    0x8(%ebp),%eax
  103ab1:	83 e0 01             	and    $0x1,%eax
  103ab4:	85 c0                	test   %eax,%eax
  103ab6:	75 1c                	jne    103ad4 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103ab8:	c7 44 24 08 80 6a 10 	movl   $0x106a80,0x8(%esp)
  103abf:	00 
  103ac0:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103ac7:	00 
  103ac8:	c7 04 24 4b 6a 10 00 	movl   $0x106a4b,(%esp)
  103acf:	e8 f2 d1 ff ff       	call   100cc6 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  103ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  103ad7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103adc:	89 04 24             	mov    %eax,(%esp)
  103adf:	e8 21 ff ff ff       	call   103a05 <pa2page>
}
  103ae4:	c9                   	leave  
  103ae5:	c3                   	ret    

00103ae6 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  103ae6:	55                   	push   %ebp
  103ae7:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  103aec:	8b 00                	mov    (%eax),%eax
}
  103aee:	5d                   	pop    %ebp
  103aef:	c3                   	ret    

00103af0 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  103af0:	55                   	push   %ebp
  103af1:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  103af3:	8b 45 08             	mov    0x8(%ebp),%eax
  103af6:	8b 55 0c             	mov    0xc(%ebp),%edx
  103af9:	89 10                	mov    %edx,(%eax)
}
  103afb:	5d                   	pop    %ebp
  103afc:	c3                   	ret    

00103afd <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  103afd:	55                   	push   %ebp
  103afe:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103b00:	8b 45 08             	mov    0x8(%ebp),%eax
  103b03:	8b 00                	mov    (%eax),%eax
  103b05:	8d 50 01             	lea    0x1(%eax),%edx
  103b08:	8b 45 08             	mov    0x8(%ebp),%eax
  103b0b:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  103b10:	8b 00                	mov    (%eax),%eax
}
  103b12:	5d                   	pop    %ebp
  103b13:	c3                   	ret    

00103b14 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103b14:	55                   	push   %ebp
  103b15:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103b17:	8b 45 08             	mov    0x8(%ebp),%eax
  103b1a:	8b 00                	mov    (%eax),%eax
  103b1c:	8d 50 ff             	lea    -0x1(%eax),%edx
  103b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  103b22:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103b24:	8b 45 08             	mov    0x8(%ebp),%eax
  103b27:	8b 00                	mov    (%eax),%eax
}
  103b29:	5d                   	pop    %ebp
  103b2a:	c3                   	ret    

00103b2b <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  103b2b:	55                   	push   %ebp
  103b2c:	89 e5                	mov    %esp,%ebp
  103b2e:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103b31:	9c                   	pushf  
  103b32:	58                   	pop    %eax
  103b33:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103b39:	25 00 02 00 00       	and    $0x200,%eax
  103b3e:	85 c0                	test   %eax,%eax
  103b40:	74 0c                	je     103b4e <__intr_save+0x23>
        intr_disable();
  103b42:	e8 62 db ff ff       	call   1016a9 <intr_disable>
        return 1;
  103b47:	b8 01 00 00 00       	mov    $0x1,%eax
  103b4c:	eb 05                	jmp    103b53 <__intr_save+0x28>
    }
    return 0;
  103b4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103b53:	c9                   	leave  
  103b54:	c3                   	ret    

00103b55 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  103b55:	55                   	push   %ebp
  103b56:	89 e5                	mov    %esp,%ebp
  103b58:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103b5b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103b5f:	74 05                	je     103b66 <__intr_restore+0x11>
        intr_enable();
  103b61:	e8 3d db ff ff       	call   1016a3 <intr_enable>
    }
}
  103b66:	c9                   	leave  
  103b67:	c3                   	ret    

00103b68 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103b68:	55                   	push   %ebp
  103b69:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  103b6e:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103b71:	b8 23 00 00 00       	mov    $0x23,%eax
  103b76:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103b78:	b8 23 00 00 00       	mov    $0x23,%eax
  103b7d:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103b7f:	b8 10 00 00 00       	mov    $0x10,%eax
  103b84:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103b86:	b8 10 00 00 00       	mov    $0x10,%eax
  103b8b:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103b8d:	b8 10 00 00 00       	mov    $0x10,%eax
  103b92:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103b94:	ea 9b 3b 10 00 08 00 	ljmp   $0x8,$0x103b9b
}
  103b9b:	5d                   	pop    %ebp
  103b9c:	c3                   	ret    

00103b9d <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103b9d:	55                   	push   %ebp
  103b9e:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  103ba3:	a3 e4 88 11 00       	mov    %eax,0x1188e4
}
  103ba8:	5d                   	pop    %ebp
  103ba9:	c3                   	ret    

00103baa <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103baa:	55                   	push   %ebp
  103bab:	89 e5                	mov    %esp,%ebp
  103bad:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103bb0:	b8 00 70 11 00       	mov    $0x117000,%eax
  103bb5:	89 04 24             	mov    %eax,(%esp)
  103bb8:	e8 e0 ff ff ff       	call   103b9d <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103bbd:	66 c7 05 e8 88 11 00 	movw   $0x10,0x1188e8
  103bc4:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103bc6:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  103bcd:	68 00 
  103bcf:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103bd4:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  103bda:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103bdf:	c1 e8 10             	shr    $0x10,%eax
  103be2:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  103be7:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103bee:	83 e0 f0             	and    $0xfffffff0,%eax
  103bf1:	83 c8 09             	or     $0x9,%eax
  103bf4:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103bf9:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103c00:	83 e0 ef             	and    $0xffffffef,%eax
  103c03:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103c08:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103c0f:	83 e0 9f             	and    $0xffffff9f,%eax
  103c12:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103c17:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103c1e:	83 c8 80             	or     $0xffffff80,%eax
  103c21:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103c26:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c2d:	83 e0 f0             	and    $0xfffffff0,%eax
  103c30:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c35:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c3c:	83 e0 ef             	and    $0xffffffef,%eax
  103c3f:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c44:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c4b:	83 e0 df             	and    $0xffffffdf,%eax
  103c4e:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c53:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c5a:	83 c8 40             	or     $0x40,%eax
  103c5d:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c62:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c69:	83 e0 7f             	and    $0x7f,%eax
  103c6c:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c71:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103c76:	c1 e8 18             	shr    $0x18,%eax
  103c79:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103c7e:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  103c85:	e8 de fe ff ff       	call   103b68 <lgdt>
  103c8a:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103c90:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103c94:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  103c97:	c9                   	leave  
  103c98:	c3                   	ret    

00103c99 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103c99:	55                   	push   %ebp
  103c9a:	89 e5                	mov    %esp,%ebp
  103c9c:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103c9f:	c7 05 5c 89 11 00 10 	movl   $0x106a10,0x11895c
  103ca6:	6a 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103ca9:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103cae:	8b 00                	mov    (%eax),%eax
  103cb0:	89 44 24 04          	mov    %eax,0x4(%esp)
  103cb4:	c7 04 24 ac 6a 10 00 	movl   $0x106aac,(%esp)
  103cbb:	e8 7c c6 ff ff       	call   10033c <cprintf>
    pmm_manager->init();
  103cc0:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103cc5:	8b 40 04             	mov    0x4(%eax),%eax
  103cc8:	ff d0                	call   *%eax
}
  103cca:	c9                   	leave  
  103ccb:	c3                   	ret    

00103ccc <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103ccc:	55                   	push   %ebp
  103ccd:	89 e5                	mov    %esp,%ebp
  103ccf:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103cd2:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103cd7:	8b 40 08             	mov    0x8(%eax),%eax
  103cda:	8b 55 0c             	mov    0xc(%ebp),%edx
  103cdd:	89 54 24 04          	mov    %edx,0x4(%esp)
  103ce1:	8b 55 08             	mov    0x8(%ebp),%edx
  103ce4:	89 14 24             	mov    %edx,(%esp)
  103ce7:	ff d0                	call   *%eax
}
  103ce9:	c9                   	leave  
  103cea:	c3                   	ret    

00103ceb <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103ceb:	55                   	push   %ebp
  103cec:	89 e5                	mov    %esp,%ebp
  103cee:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103cf1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103cf8:	e8 2e fe ff ff       	call   103b2b <__intr_save>
  103cfd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103d00:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d05:	8b 40 0c             	mov    0xc(%eax),%eax
  103d08:	8b 55 08             	mov    0x8(%ebp),%edx
  103d0b:	89 14 24             	mov    %edx,(%esp)
  103d0e:	ff d0                	call   *%eax
  103d10:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103d13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103d16:	89 04 24             	mov    %eax,(%esp)
  103d19:	e8 37 fe ff ff       	call   103b55 <__intr_restore>
    return page;
  103d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103d21:	c9                   	leave  
  103d22:	c3                   	ret    

00103d23 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103d23:	55                   	push   %ebp
  103d24:	89 e5                	mov    %esp,%ebp
  103d26:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103d29:	e8 fd fd ff ff       	call   103b2b <__intr_save>
  103d2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103d31:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d36:	8b 40 10             	mov    0x10(%eax),%eax
  103d39:	8b 55 0c             	mov    0xc(%ebp),%edx
  103d3c:	89 54 24 04          	mov    %edx,0x4(%esp)
  103d40:	8b 55 08             	mov    0x8(%ebp),%edx
  103d43:	89 14 24             	mov    %edx,(%esp)
  103d46:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d4b:	89 04 24             	mov    %eax,(%esp)
  103d4e:	e8 02 fe ff ff       	call   103b55 <__intr_restore>
}
  103d53:	c9                   	leave  
  103d54:	c3                   	ret    

00103d55 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103d55:	55                   	push   %ebp
  103d56:	89 e5                	mov    %esp,%ebp
  103d58:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103d5b:	e8 cb fd ff ff       	call   103b2b <__intr_save>
  103d60:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103d63:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d68:	8b 40 14             	mov    0x14(%eax),%eax
  103d6b:	ff d0                	call   *%eax
  103d6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d73:	89 04 24             	mov    %eax,(%esp)
  103d76:	e8 da fd ff ff       	call   103b55 <__intr_restore>
    return ret;
  103d7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103d7e:	c9                   	leave  
  103d7f:	c3                   	ret    

00103d80 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103d80:	55                   	push   %ebp
  103d81:	89 e5                	mov    %esp,%ebp
  103d83:	57                   	push   %edi
  103d84:	56                   	push   %esi
  103d85:	53                   	push   %ebx
  103d86:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  103d8c:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  103d93:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103d9a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103da1:	c7 04 24 c3 6a 10 00 	movl   $0x106ac3,(%esp)
  103da8:	e8 8f c5 ff ff       	call   10033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103dad:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103db4:	e9 15 01 00 00       	jmp    103ece <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103db9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103dbc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103dbf:	89 d0                	mov    %edx,%eax
  103dc1:	c1 e0 02             	shl    $0x2,%eax
  103dc4:	01 d0                	add    %edx,%eax
  103dc6:	c1 e0 02             	shl    $0x2,%eax
  103dc9:	01 c8                	add    %ecx,%eax
  103dcb:	8b 50 08             	mov    0x8(%eax),%edx
  103dce:	8b 40 04             	mov    0x4(%eax),%eax
  103dd1:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103dd4:	89 55 bc             	mov    %edx,-0x44(%ebp)
  103dd7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103dda:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103ddd:	89 d0                	mov    %edx,%eax
  103ddf:	c1 e0 02             	shl    $0x2,%eax
  103de2:	01 d0                	add    %edx,%eax
  103de4:	c1 e0 02             	shl    $0x2,%eax
  103de7:	01 c8                	add    %ecx,%eax
  103de9:	8b 48 0c             	mov    0xc(%eax),%ecx
  103dec:	8b 58 10             	mov    0x10(%eax),%ebx
  103def:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103df2:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103df5:	01 c8                	add    %ecx,%eax
  103df7:	11 da                	adc    %ebx,%edx
  103df9:	89 45 b0             	mov    %eax,-0x50(%ebp)
  103dfc:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  103dff:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e02:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e05:	89 d0                	mov    %edx,%eax
  103e07:	c1 e0 02             	shl    $0x2,%eax
  103e0a:	01 d0                	add    %edx,%eax
  103e0c:	c1 e0 02             	shl    $0x2,%eax
  103e0f:	01 c8                	add    %ecx,%eax
  103e11:	83 c0 14             	add    $0x14,%eax
  103e14:	8b 00                	mov    (%eax),%eax
  103e16:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  103e1c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103e1f:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103e22:	83 c0 ff             	add    $0xffffffff,%eax
  103e25:	83 d2 ff             	adc    $0xffffffff,%edx
  103e28:	89 c6                	mov    %eax,%esi
  103e2a:	89 d7                	mov    %edx,%edi
  103e2c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e2f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e32:	89 d0                	mov    %edx,%eax
  103e34:	c1 e0 02             	shl    $0x2,%eax
  103e37:	01 d0                	add    %edx,%eax
  103e39:	c1 e0 02             	shl    $0x2,%eax
  103e3c:	01 c8                	add    %ecx,%eax
  103e3e:	8b 48 0c             	mov    0xc(%eax),%ecx
  103e41:	8b 58 10             	mov    0x10(%eax),%ebx
  103e44:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  103e4a:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  103e4e:	89 74 24 14          	mov    %esi,0x14(%esp)
  103e52:	89 7c 24 18          	mov    %edi,0x18(%esp)
  103e56:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103e59:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103e5c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103e60:	89 54 24 10          	mov    %edx,0x10(%esp)
  103e64:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103e68:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103e6c:	c7 04 24 d0 6a 10 00 	movl   $0x106ad0,(%esp)
  103e73:	e8 c4 c4 ff ff       	call   10033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  103e78:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e7b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e7e:	89 d0                	mov    %edx,%eax
  103e80:	c1 e0 02             	shl    $0x2,%eax
  103e83:	01 d0                	add    %edx,%eax
  103e85:	c1 e0 02             	shl    $0x2,%eax
  103e88:	01 c8                	add    %ecx,%eax
  103e8a:	83 c0 14             	add    $0x14,%eax
  103e8d:	8b 00                	mov    (%eax),%eax
  103e8f:	83 f8 01             	cmp    $0x1,%eax
  103e92:	75 36                	jne    103eca <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
  103e94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103e97:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103e9a:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103e9d:	77 2b                	ja     103eca <page_init+0x14a>
  103e9f:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103ea2:	72 05                	jb     103ea9 <page_init+0x129>
  103ea4:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  103ea7:	73 21                	jae    103eca <page_init+0x14a>
  103ea9:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103ead:	77 1b                	ja     103eca <page_init+0x14a>
  103eaf:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103eb3:	72 09                	jb     103ebe <page_init+0x13e>
  103eb5:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  103ebc:	77 0c                	ja     103eca <page_init+0x14a>
                maxpa = end;
  103ebe:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103ec1:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103ec4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103ec7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103eca:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103ece:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103ed1:	8b 00                	mov    (%eax),%eax
  103ed3:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103ed6:	0f 8f dd fe ff ff    	jg     103db9 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  103edc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103ee0:	72 1d                	jb     103eff <page_init+0x17f>
  103ee2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103ee6:	77 09                	ja     103ef1 <page_init+0x171>
  103ee8:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  103eef:	76 0e                	jbe    103eff <page_init+0x17f>
        maxpa = KMEMSIZE;
  103ef1:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  103ef8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  103eff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103f02:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103f05:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103f09:	c1 ea 0c             	shr    $0xc,%edx
  103f0c:	a3 c0 88 11 00       	mov    %eax,0x1188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  103f11:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  103f18:	b8 68 89 11 00       	mov    $0x118968,%eax
  103f1d:	8d 50 ff             	lea    -0x1(%eax),%edx
  103f20:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103f23:	01 d0                	add    %edx,%eax
  103f25:	89 45 a8             	mov    %eax,-0x58(%ebp)
  103f28:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103f2b:	ba 00 00 00 00       	mov    $0x0,%edx
  103f30:	f7 75 ac             	divl   -0x54(%ebp)
  103f33:	89 d0                	mov    %edx,%eax
  103f35:	8b 55 a8             	mov    -0x58(%ebp),%edx
  103f38:	29 c2                	sub    %eax,%edx
  103f3a:	89 d0                	mov    %edx,%eax
  103f3c:	a3 64 89 11 00       	mov    %eax,0x118964

    for (i = 0; i < npage; i ++) {
  103f41:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103f48:	eb 2f                	jmp    103f79 <page_init+0x1f9>
        SetPageReserved(pages + i);
  103f4a:	8b 0d 64 89 11 00    	mov    0x118964,%ecx
  103f50:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f53:	89 d0                	mov    %edx,%eax
  103f55:	c1 e0 02             	shl    $0x2,%eax
  103f58:	01 d0                	add    %edx,%eax
  103f5a:	c1 e0 02             	shl    $0x2,%eax
  103f5d:	01 c8                	add    %ecx,%eax
  103f5f:	83 c0 04             	add    $0x4,%eax
  103f62:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  103f69:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103f6c:	8b 45 8c             	mov    -0x74(%ebp),%eax
  103f6f:	8b 55 90             	mov    -0x70(%ebp),%edx
  103f72:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  103f75:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103f79:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f7c:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103f81:	39 c2                	cmp    %eax,%edx
  103f83:	72 c5                	jb     103f4a <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  103f85:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  103f8b:	89 d0                	mov    %edx,%eax
  103f8d:	c1 e0 02             	shl    $0x2,%eax
  103f90:	01 d0                	add    %edx,%eax
  103f92:	c1 e0 02             	shl    $0x2,%eax
  103f95:	89 c2                	mov    %eax,%edx
  103f97:	a1 64 89 11 00       	mov    0x118964,%eax
  103f9c:	01 d0                	add    %edx,%eax
  103f9e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  103fa1:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  103fa8:	77 23                	ja     103fcd <page_init+0x24d>
  103faa:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103fad:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103fb1:	c7 44 24 08 00 6b 10 	movl   $0x106b00,0x8(%esp)
  103fb8:	00 
  103fb9:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  103fc0:	00 
  103fc1:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  103fc8:	e8 f9 cc ff ff       	call   100cc6 <__panic>
  103fcd:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103fd0:	05 00 00 00 40       	add    $0x40000000,%eax
  103fd5:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  103fd8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103fdf:	e9 74 01 00 00       	jmp    104158 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103fe4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103fe7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103fea:	89 d0                	mov    %edx,%eax
  103fec:	c1 e0 02             	shl    $0x2,%eax
  103fef:	01 d0                	add    %edx,%eax
  103ff1:	c1 e0 02             	shl    $0x2,%eax
  103ff4:	01 c8                	add    %ecx,%eax
  103ff6:	8b 50 08             	mov    0x8(%eax),%edx
  103ff9:	8b 40 04             	mov    0x4(%eax),%eax
  103ffc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103fff:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104002:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104005:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104008:	89 d0                	mov    %edx,%eax
  10400a:	c1 e0 02             	shl    $0x2,%eax
  10400d:	01 d0                	add    %edx,%eax
  10400f:	c1 e0 02             	shl    $0x2,%eax
  104012:	01 c8                	add    %ecx,%eax
  104014:	8b 48 0c             	mov    0xc(%eax),%ecx
  104017:	8b 58 10             	mov    0x10(%eax),%ebx
  10401a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10401d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104020:	01 c8                	add    %ecx,%eax
  104022:	11 da                	adc    %ebx,%edx
  104024:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104027:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  10402a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10402d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104030:	89 d0                	mov    %edx,%eax
  104032:	c1 e0 02             	shl    $0x2,%eax
  104035:	01 d0                	add    %edx,%eax
  104037:	c1 e0 02             	shl    $0x2,%eax
  10403a:	01 c8                	add    %ecx,%eax
  10403c:	83 c0 14             	add    $0x14,%eax
  10403f:	8b 00                	mov    (%eax),%eax
  104041:	83 f8 01             	cmp    $0x1,%eax
  104044:	0f 85 0a 01 00 00    	jne    104154 <page_init+0x3d4>
            if (begin < freemem) {
  10404a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  10404d:	ba 00 00 00 00       	mov    $0x0,%edx
  104052:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  104055:	72 17                	jb     10406e <page_init+0x2ee>
  104057:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10405a:	77 05                	ja     104061 <page_init+0x2e1>
  10405c:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  10405f:	76 0d                	jbe    10406e <page_init+0x2ee>
                begin = freemem;
  104061:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104064:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104067:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  10406e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  104072:	72 1d                	jb     104091 <page_init+0x311>
  104074:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  104078:	77 09                	ja     104083 <page_init+0x303>
  10407a:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  104081:	76 0e                	jbe    104091 <page_init+0x311>
                end = KMEMSIZE;
  104083:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  10408a:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  104091:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104094:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104097:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10409a:	0f 87 b4 00 00 00    	ja     104154 <page_init+0x3d4>
  1040a0:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1040a3:	72 09                	jb     1040ae <page_init+0x32e>
  1040a5:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1040a8:	0f 83 a6 00 00 00    	jae    104154 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
  1040ae:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  1040b5:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1040b8:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1040bb:	01 d0                	add    %edx,%eax
  1040bd:	83 e8 01             	sub    $0x1,%eax
  1040c0:	89 45 98             	mov    %eax,-0x68(%ebp)
  1040c3:	8b 45 98             	mov    -0x68(%ebp),%eax
  1040c6:	ba 00 00 00 00       	mov    $0x0,%edx
  1040cb:	f7 75 9c             	divl   -0x64(%ebp)
  1040ce:	89 d0                	mov    %edx,%eax
  1040d0:	8b 55 98             	mov    -0x68(%ebp),%edx
  1040d3:	29 c2                	sub    %eax,%edx
  1040d5:	89 d0                	mov    %edx,%eax
  1040d7:	ba 00 00 00 00       	mov    $0x0,%edx
  1040dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1040df:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  1040e2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1040e5:	89 45 94             	mov    %eax,-0x6c(%ebp)
  1040e8:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1040eb:	ba 00 00 00 00       	mov    $0x0,%edx
  1040f0:	89 c7                	mov    %eax,%edi
  1040f2:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  1040f8:	89 7d 80             	mov    %edi,-0x80(%ebp)
  1040fb:	89 d0                	mov    %edx,%eax
  1040fd:	83 e0 00             	and    $0x0,%eax
  104100:	89 45 84             	mov    %eax,-0x7c(%ebp)
  104103:	8b 45 80             	mov    -0x80(%ebp),%eax
  104106:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104109:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10410c:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  10410f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104112:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104115:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104118:	77 3a                	ja     104154 <page_init+0x3d4>
  10411a:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10411d:	72 05                	jb     104124 <page_init+0x3a4>
  10411f:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  104122:	73 30                	jae    104154 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  104124:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  104127:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  10412a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10412d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104130:	29 c8                	sub    %ecx,%eax
  104132:	19 da                	sbb    %ebx,%edx
  104134:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  104138:	c1 ea 0c             	shr    $0xc,%edx
  10413b:	89 c3                	mov    %eax,%ebx
  10413d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104140:	89 04 24             	mov    %eax,(%esp)
  104143:	e8 bd f8 ff ff       	call   103a05 <pa2page>
  104148:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10414c:	89 04 24             	mov    %eax,(%esp)
  10414f:	e8 78 fb ff ff       	call   103ccc <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  104154:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  104158:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10415b:	8b 00                	mov    (%eax),%eax
  10415d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  104160:	0f 8f 7e fe ff ff    	jg     103fe4 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  104166:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  10416c:	5b                   	pop    %ebx
  10416d:	5e                   	pop    %esi
  10416e:	5f                   	pop    %edi
  10416f:	5d                   	pop    %ebp
  104170:	c3                   	ret    

00104171 <enable_paging>:

static void
enable_paging(void) {
  104171:	55                   	push   %ebp
  104172:	89 e5                	mov    %esp,%ebp
  104174:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  104177:	a1 60 89 11 00       	mov    0x118960,%eax
  10417c:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  10417f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104182:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  104185:	0f 20 c0             	mov    %cr0,%eax
  104188:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  10418b:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  10418e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  104191:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  104198:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
  10419c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10419f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  1041a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1041a5:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  1041a8:	c9                   	leave  
  1041a9:	c3                   	ret    

001041aa <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  1041aa:	55                   	push   %ebp
  1041ab:	89 e5                	mov    %esp,%ebp
  1041ad:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  1041b0:	8b 45 14             	mov    0x14(%ebp),%eax
  1041b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  1041b6:	31 d0                	xor    %edx,%eax
  1041b8:	25 ff 0f 00 00       	and    $0xfff,%eax
  1041bd:	85 c0                	test   %eax,%eax
  1041bf:	74 24                	je     1041e5 <boot_map_segment+0x3b>
  1041c1:	c7 44 24 0c 32 6b 10 	movl   $0x106b32,0xc(%esp)
  1041c8:	00 
  1041c9:	c7 44 24 08 49 6b 10 	movl   $0x106b49,0x8(%esp)
  1041d0:	00 
  1041d1:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  1041d8:	00 
  1041d9:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  1041e0:	e8 e1 ca ff ff       	call   100cc6 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  1041e5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  1041ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1041ef:	25 ff 0f 00 00       	and    $0xfff,%eax
  1041f4:	89 c2                	mov    %eax,%edx
  1041f6:	8b 45 10             	mov    0x10(%ebp),%eax
  1041f9:	01 c2                	add    %eax,%edx
  1041fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1041fe:	01 d0                	add    %edx,%eax
  104200:	83 e8 01             	sub    $0x1,%eax
  104203:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104206:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104209:	ba 00 00 00 00       	mov    $0x0,%edx
  10420e:	f7 75 f0             	divl   -0x10(%ebp)
  104211:	89 d0                	mov    %edx,%eax
  104213:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104216:	29 c2                	sub    %eax,%edx
  104218:	89 d0                	mov    %edx,%eax
  10421a:	c1 e8 0c             	shr    $0xc,%eax
  10421d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  104220:	8b 45 0c             	mov    0xc(%ebp),%eax
  104223:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104226:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104229:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10422e:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  104231:	8b 45 14             	mov    0x14(%ebp),%eax
  104234:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104237:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10423a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10423f:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  104242:	eb 6b                	jmp    1042af <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  104244:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10424b:	00 
  10424c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10424f:	89 44 24 04          	mov    %eax,0x4(%esp)
  104253:	8b 45 08             	mov    0x8(%ebp),%eax
  104256:	89 04 24             	mov    %eax,(%esp)
  104259:	e8 cc 01 00 00       	call   10442a <get_pte>
  10425e:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  104261:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  104265:	75 24                	jne    10428b <boot_map_segment+0xe1>
  104267:	c7 44 24 0c 5e 6b 10 	movl   $0x106b5e,0xc(%esp)
  10426e:	00 
  10426f:	c7 44 24 08 49 6b 10 	movl   $0x106b49,0x8(%esp)
  104276:	00 
  104277:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  10427e:	00 
  10427f:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  104286:	e8 3b ca ff ff       	call   100cc6 <__panic>
        *ptep = pa | PTE_P | perm;
  10428b:	8b 45 18             	mov    0x18(%ebp),%eax
  10428e:	8b 55 14             	mov    0x14(%ebp),%edx
  104291:	09 d0                	or     %edx,%eax
  104293:	83 c8 01             	or     $0x1,%eax
  104296:	89 c2                	mov    %eax,%edx
  104298:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10429b:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  10429d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1042a1:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  1042a8:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  1042af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1042b3:	75 8f                	jne    104244 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  1042b5:	c9                   	leave  
  1042b6:	c3                   	ret    

001042b7 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  1042b7:	55                   	push   %ebp
  1042b8:	89 e5                	mov    %esp,%ebp
  1042ba:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  1042bd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1042c4:	e8 22 fa ff ff       	call   103ceb <alloc_pages>
  1042c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  1042cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1042d0:	75 1c                	jne    1042ee <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  1042d2:	c7 44 24 08 6b 6b 10 	movl   $0x106b6b,0x8(%esp)
  1042d9:	00 
  1042da:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  1042e1:	00 
  1042e2:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  1042e9:	e8 d8 c9 ff ff       	call   100cc6 <__panic>
    }
    return page2kva(p);
  1042ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042f1:	89 04 24             	mov    %eax,(%esp)
  1042f4:	e8 5b f7 ff ff       	call   103a54 <page2kva>
}
  1042f9:	c9                   	leave  
  1042fa:	c3                   	ret    

001042fb <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  1042fb:	55                   	push   %ebp
  1042fc:	89 e5                	mov    %esp,%ebp
  1042fe:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  104301:	e8 93 f9 ff ff       	call   103c99 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  104306:	e8 75 fa ff ff       	call   103d80 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  10430b:	e8 75 04 00 00       	call   104785 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  104310:	e8 a2 ff ff ff       	call   1042b7 <boot_alloc_page>
  104315:	a3 c4 88 11 00       	mov    %eax,0x1188c4
    memset(boot_pgdir, 0, PGSIZE);
  10431a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10431f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104326:	00 
  104327:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10432e:	00 
  10432f:	89 04 24             	mov    %eax,(%esp)
  104332:	e8 b7 1a 00 00       	call   105dee <memset>
    boot_cr3 = PADDR(boot_pgdir);
  104337:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10433c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10433f:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104346:	77 23                	ja     10436b <pmm_init+0x70>
  104348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10434b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10434f:	c7 44 24 08 00 6b 10 	movl   $0x106b00,0x8(%esp)
  104356:	00 
  104357:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  10435e:	00 
  10435f:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  104366:	e8 5b c9 ff ff       	call   100cc6 <__panic>
  10436b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10436e:	05 00 00 00 40       	add    $0x40000000,%eax
  104373:	a3 60 89 11 00       	mov    %eax,0x118960

    check_pgdir();
  104378:	e8 26 04 00 00       	call   1047a3 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  10437d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104382:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  104388:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10438d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104390:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  104397:	77 23                	ja     1043bc <pmm_init+0xc1>
  104399:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10439c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1043a0:	c7 44 24 08 00 6b 10 	movl   $0x106b00,0x8(%esp)
  1043a7:	00 
  1043a8:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  1043af:	00 
  1043b0:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  1043b7:	e8 0a c9 ff ff       	call   100cc6 <__panic>
  1043bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1043bf:	05 00 00 00 40       	add    $0x40000000,%eax
  1043c4:	83 c8 03             	or     $0x3,%eax
  1043c7:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  1043c9:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1043ce:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  1043d5:	00 
  1043d6:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1043dd:	00 
  1043de:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  1043e5:	38 
  1043e6:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  1043ed:	c0 
  1043ee:	89 04 24             	mov    %eax,(%esp)
  1043f1:	e8 b4 fd ff ff       	call   1041aa <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  1043f6:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1043fb:	8b 15 c4 88 11 00    	mov    0x1188c4,%edx
  104401:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  104407:	89 10                	mov    %edx,(%eax)

    enable_paging();
  104409:	e8 63 fd ff ff       	call   104171 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  10440e:	e8 97 f7 ff ff       	call   103baa <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  104413:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104418:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  10441e:	e8 1b 0a 00 00       	call   104e3e <check_boot_pgdir>

    print_pgdir();
  104423:	e8 a8 0e 00 00       	call   1052d0 <print_pgdir>

}
  104428:	c9                   	leave  
  104429:	c3                   	ret    

0010442a <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  10442a:	55                   	push   %ebp
  10442b:	89 e5                	mov    %esp,%ebp
  10442d:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
pde_t* pdep = &pgdir[PDX(la)];                      // (1) find page directory entry
  104430:	8b 45 0c             	mov    0xc(%ebp),%eax
  104433:	c1 e8 16             	shr    $0x16,%eax
  104436:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10443d:	8b 45 08             	mov    0x8(%ebp),%eax
  104440:	01 d0                	add    %edx,%eax
  104442:	89 45 f4             	mov    %eax,-0xc(%ebp)
if (!(*pdep & PTE_P)) {                              // (2) check if entry is not present 
  104445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104448:	8b 00                	mov    (%eax),%eax
  10444a:	83 e0 01             	and    $0x1,%eax
  10444d:	85 c0                	test   %eax,%eax
  10444f:	0f 85 b9 00 00 00    	jne    10450e <get_pte+0xe4>
	struct Page* page;
	if (create) {                                    // (3) check if creating is needed, then alloc page for page table
  104455:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  104459:	74 1f                	je     10447a <get_pte+0x50>
		if ((page = alloc_page()) == NULL)
  10445b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104462:	e8 84 f8 ff ff       	call   103ceb <alloc_pages>
  104467:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10446a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10446e:	75 14                	jne    104484 <get_pte+0x5a>
			return NULL;
  104470:	b8 00 00 00 00       	mov    $0x0,%eax
  104475:	e9 f0 00 00 00       	jmp    10456a <get_pte+0x140>
	}
	else
		return NULL;
  10447a:	b8 00 00 00 00       	mov    $0x0,%eax
  10447f:	e9 e6 00 00 00       	jmp    10456a <get_pte+0x140>
	set_page_ref(page, 1);                          // (4) set page reference
  104484:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10448b:	00 
  10448c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10448f:	89 04 24             	mov    %eax,(%esp)
  104492:	e8 59 f6 ff ff       	call   103af0 <set_page_ref>
	uintptr_t addr = page2pa(page);                 // (5) get linear address of page
  104497:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10449a:	89 04 24             	mov    %eax,(%esp)
  10449d:	e8 4d f5 ff ff       	call   1039ef <page2pa>
  1044a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	memset(KADDR(addr), 0, PGSIZE);                  // (6) clear page content using memset
  1044a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1044a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1044ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1044ae:	c1 e8 0c             	shr    $0xc,%eax
  1044b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1044b4:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1044b9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1044bc:	72 23                	jb     1044e1 <get_pte+0xb7>
  1044be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1044c1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1044c5:	c7 44 24 08 5c 6a 10 	movl   $0x106a5c,0x8(%esp)
  1044cc:	00 
  1044cd:	c7 44 24 04 8a 01 00 	movl   $0x18a,0x4(%esp)
  1044d4:	00 
  1044d5:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  1044dc:	e8 e5 c7 ff ff       	call   100cc6 <__panic>
  1044e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1044e4:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1044e9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1044f0:	00 
  1044f1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1044f8:	00 
  1044f9:	89 04 24             	mov    %eax,(%esp)
  1044fc:	e8 ed 18 00 00       	call   105dee <memset>
	*pdep = addr | PTE_U | PTE_W | PTE_P;             // (7) set page directory entry's permission
  104501:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104504:	83 c8 07             	or     $0x7,%eax
  104507:	89 c2                	mov    %eax,%edx
  104509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10450c:	89 10                	mov    %edx,(%eax)
}
return &((pte_t*)KADDR(PDE_ADDR(*pdep)))[PTX(la)];// (8) return page table entry
  10450e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104511:	8b 00                	mov    (%eax),%eax
  104513:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104518:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10451b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10451e:	c1 e8 0c             	shr    $0xc,%eax
  104521:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104524:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104529:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  10452c:	72 23                	jb     104551 <get_pte+0x127>
  10452e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104531:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104535:	c7 44 24 08 5c 6a 10 	movl   $0x106a5c,0x8(%esp)
  10453c:	00 
  10453d:	c7 44 24 04 8d 01 00 	movl   $0x18d,0x4(%esp)
  104544:	00 
  104545:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  10454c:	e8 75 c7 ff ff       	call   100cc6 <__panic>
  104551:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104554:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104559:	8b 55 0c             	mov    0xc(%ebp),%edx
  10455c:	c1 ea 0c             	shr    $0xc,%edx
  10455f:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  104565:	c1 e2 02             	shl    $0x2,%edx
  104568:	01 d0                	add    %edx,%eax

}
  10456a:	c9                   	leave  
  10456b:	c3                   	ret    

0010456c <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  10456c:	55                   	push   %ebp
  10456d:	89 e5                	mov    %esp,%ebp
  10456f:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  104572:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104579:	00 
  10457a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10457d:	89 44 24 04          	mov    %eax,0x4(%esp)
  104581:	8b 45 08             	mov    0x8(%ebp),%eax
  104584:	89 04 24             	mov    %eax,(%esp)
  104587:	e8 9e fe ff ff       	call   10442a <get_pte>
  10458c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  10458f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  104593:	74 08                	je     10459d <get_page+0x31>
        *ptep_store = ptep;
  104595:	8b 45 10             	mov    0x10(%ebp),%eax
  104598:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10459b:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  10459d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1045a1:	74 1b                	je     1045be <get_page+0x52>
  1045a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045a6:	8b 00                	mov    (%eax),%eax
  1045a8:	83 e0 01             	and    $0x1,%eax
  1045ab:	85 c0                	test   %eax,%eax
  1045ad:	74 0f                	je     1045be <get_page+0x52>
        return pa2page(*ptep);
  1045af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045b2:	8b 00                	mov    (%eax),%eax
  1045b4:	89 04 24             	mov    %eax,(%esp)
  1045b7:	e8 49 f4 ff ff       	call   103a05 <pa2page>
  1045bc:	eb 05                	jmp    1045c3 <get_page+0x57>
    }
    return NULL;
  1045be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1045c3:	c9                   	leave  
  1045c4:	c3                   	ret    

001045c5 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1045c5:	55                   	push   %ebp
  1045c6:	89 e5                	mov    %esp,%ebp
  1045c8:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
if (*ptep & PTE_P) {                        //(1) check if this page table entry is present
  1045cb:	8b 45 10             	mov    0x10(%ebp),%eax
  1045ce:	8b 00                	mov    (%eax),%eax
  1045d0:	83 e0 01             	and    $0x1,%eax
  1045d3:	85 c0                	test   %eax,%eax
  1045d5:	74 52                	je     104629 <page_remove_pte+0x64>
	struct Page* page = pte2page(*ptep);    //(2) find corresponding page to pte
  1045d7:	8b 45 10             	mov    0x10(%ebp),%eax
  1045da:	8b 00                	mov    (%eax),%eax
  1045dc:	89 04 24             	mov    %eax,(%esp)
  1045df:	e8 c4 f4 ff ff       	call   103aa8 <pte2page>
  1045e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	page_ref_dec(page);                     //(3) decrease page reference
  1045e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045ea:	89 04 24             	mov    %eax,(%esp)
  1045ed:	e8 22 f5 ff ff       	call   103b14 <page_ref_dec>
	if (page->ref == 0) {
  1045f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045f5:	8b 00                	mov    (%eax),%eax
  1045f7:	85 c0                	test   %eax,%eax
  1045f9:	75 13                	jne    10460e <page_remove_pte+0x49>
		free_page(page);                    //(4) and free this page when page reference reachs 0
  1045fb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104602:	00 
  104603:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104606:	89 04 24             	mov    %eax,(%esp)
  104609:	e8 15 f7 ff ff       	call   103d23 <free_pages>
	}
	*ptep = 0;                              //(5) clear second page table entry
  10460e:	8b 45 10             	mov    0x10(%ebp),%eax
  104611:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	tlb_invalidate(pgdir, la);              //(6) flush tlb
  104617:	8b 45 0c             	mov    0xc(%ebp),%eax
  10461a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10461e:	8b 45 08             	mov    0x8(%ebp),%eax
  104621:	89 04 24             	mov    %eax,(%esp)
  104624:	e8 ff 00 00 00       	call   104728 <tlb_invalidate>
}

}
  104629:	c9                   	leave  
  10462a:	c3                   	ret    

0010462b <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  10462b:	55                   	push   %ebp
  10462c:	89 e5                	mov    %esp,%ebp
  10462e:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  104631:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104638:	00 
  104639:	8b 45 0c             	mov    0xc(%ebp),%eax
  10463c:	89 44 24 04          	mov    %eax,0x4(%esp)
  104640:	8b 45 08             	mov    0x8(%ebp),%eax
  104643:	89 04 24             	mov    %eax,(%esp)
  104646:	e8 df fd ff ff       	call   10442a <get_pte>
  10464b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  10464e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104652:	74 19                	je     10466d <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  104654:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104657:	89 44 24 08          	mov    %eax,0x8(%esp)
  10465b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10465e:	89 44 24 04          	mov    %eax,0x4(%esp)
  104662:	8b 45 08             	mov    0x8(%ebp),%eax
  104665:	89 04 24             	mov    %eax,(%esp)
  104668:	e8 58 ff ff ff       	call   1045c5 <page_remove_pte>
    }
}
  10466d:	c9                   	leave  
  10466e:	c3                   	ret    

0010466f <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  10466f:	55                   	push   %ebp
  104670:	89 e5                	mov    %esp,%ebp
  104672:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  104675:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10467c:	00 
  10467d:	8b 45 10             	mov    0x10(%ebp),%eax
  104680:	89 44 24 04          	mov    %eax,0x4(%esp)
  104684:	8b 45 08             	mov    0x8(%ebp),%eax
  104687:	89 04 24             	mov    %eax,(%esp)
  10468a:	e8 9b fd ff ff       	call   10442a <get_pte>
  10468f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  104692:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104696:	75 0a                	jne    1046a2 <page_insert+0x33>
        return -E_NO_MEM;
  104698:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  10469d:	e9 84 00 00 00       	jmp    104726 <page_insert+0xb7>
    }
    page_ref_inc(page);
  1046a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046a5:	89 04 24             	mov    %eax,(%esp)
  1046a8:	e8 50 f4 ff ff       	call   103afd <page_ref_inc>
    if (*ptep & PTE_P) {
  1046ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046b0:	8b 00                	mov    (%eax),%eax
  1046b2:	83 e0 01             	and    $0x1,%eax
  1046b5:	85 c0                	test   %eax,%eax
  1046b7:	74 3e                	je     1046f7 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  1046b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046bc:	8b 00                	mov    (%eax),%eax
  1046be:	89 04 24             	mov    %eax,(%esp)
  1046c1:	e8 e2 f3 ff ff       	call   103aa8 <pte2page>
  1046c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1046c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1046cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1046cf:	75 0d                	jne    1046de <page_insert+0x6f>
            page_ref_dec(page);
  1046d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046d4:	89 04 24             	mov    %eax,(%esp)
  1046d7:	e8 38 f4 ff ff       	call   103b14 <page_ref_dec>
  1046dc:	eb 19                	jmp    1046f7 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  1046de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  1046e5:	8b 45 10             	mov    0x10(%ebp),%eax
  1046e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1046ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1046ef:	89 04 24             	mov    %eax,(%esp)
  1046f2:	e8 ce fe ff ff       	call   1045c5 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  1046f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046fa:	89 04 24             	mov    %eax,(%esp)
  1046fd:	e8 ed f2 ff ff       	call   1039ef <page2pa>
  104702:	0b 45 14             	or     0x14(%ebp),%eax
  104705:	83 c8 01             	or     $0x1,%eax
  104708:	89 c2                	mov    %eax,%edx
  10470a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10470d:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  10470f:	8b 45 10             	mov    0x10(%ebp),%eax
  104712:	89 44 24 04          	mov    %eax,0x4(%esp)
  104716:	8b 45 08             	mov    0x8(%ebp),%eax
  104719:	89 04 24             	mov    %eax,(%esp)
  10471c:	e8 07 00 00 00       	call   104728 <tlb_invalidate>
    return 0;
  104721:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104726:	c9                   	leave  
  104727:	c3                   	ret    

00104728 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  104728:	55                   	push   %ebp
  104729:	89 e5                	mov    %esp,%ebp
  10472b:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  10472e:	0f 20 d8             	mov    %cr3,%eax
  104731:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  104734:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  104737:	89 c2                	mov    %eax,%edx
  104739:	8b 45 08             	mov    0x8(%ebp),%eax
  10473c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10473f:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104746:	77 23                	ja     10476b <tlb_invalidate+0x43>
  104748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10474b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10474f:	c7 44 24 08 00 6b 10 	movl   $0x106b00,0x8(%esp)
  104756:	00 
  104757:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
  10475e:	00 
  10475f:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  104766:	e8 5b c5 ff ff       	call   100cc6 <__panic>
  10476b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10476e:	05 00 00 00 40       	add    $0x40000000,%eax
  104773:	39 c2                	cmp    %eax,%edx
  104775:	75 0c                	jne    104783 <tlb_invalidate+0x5b>
        invlpg((void *)la);
  104777:	8b 45 0c             	mov    0xc(%ebp),%eax
  10477a:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  10477d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104780:	0f 01 38             	invlpg (%eax)
    }
}
  104783:	c9                   	leave  
  104784:	c3                   	ret    

00104785 <check_alloc_page>:

static void
check_alloc_page(void) {
  104785:	55                   	push   %ebp
  104786:	89 e5                	mov    %esp,%ebp
  104788:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  10478b:	a1 5c 89 11 00       	mov    0x11895c,%eax
  104790:	8b 40 18             	mov    0x18(%eax),%eax
  104793:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  104795:	c7 04 24 84 6b 10 00 	movl   $0x106b84,(%esp)
  10479c:	e8 9b bb ff ff       	call   10033c <cprintf>
}
  1047a1:	c9                   	leave  
  1047a2:	c3                   	ret    

001047a3 <check_pgdir>:

static void
check_pgdir(void) {
  1047a3:	55                   	push   %ebp
  1047a4:	89 e5                	mov    %esp,%ebp
  1047a6:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  1047a9:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1047ae:	3d 00 80 03 00       	cmp    $0x38000,%eax
  1047b3:	76 24                	jbe    1047d9 <check_pgdir+0x36>
  1047b5:	c7 44 24 0c a3 6b 10 	movl   $0x106ba3,0xc(%esp)
  1047bc:	00 
  1047bd:	c7 44 24 08 49 6b 10 	movl   $0x106b49,0x8(%esp)
  1047c4:	00 
  1047c5:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  1047cc:	00 
  1047cd:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  1047d4:	e8 ed c4 ff ff       	call   100cc6 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  1047d9:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1047de:	85 c0                	test   %eax,%eax
  1047e0:	74 0e                	je     1047f0 <check_pgdir+0x4d>
  1047e2:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1047e7:	25 ff 0f 00 00       	and    $0xfff,%eax
  1047ec:	85 c0                	test   %eax,%eax
  1047ee:	74 24                	je     104814 <check_pgdir+0x71>
  1047f0:	c7 44 24 0c c0 6b 10 	movl   $0x106bc0,0xc(%esp)
  1047f7:	00 
  1047f8:	c7 44 24 08 49 6b 10 	movl   $0x106b49,0x8(%esp)
  1047ff:	00 
  104800:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  104807:	00 
  104808:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  10480f:	e8 b2 c4 ff ff       	call   100cc6 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  104814:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104819:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104820:	00 
  104821:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104828:	00 
  104829:	89 04 24             	mov    %eax,(%esp)
  10482c:	e8 3b fd ff ff       	call   10456c <get_page>
  104831:	85 c0                	test   %eax,%eax
  104833:	74 24                	je     104859 <check_pgdir+0xb6>
  104835:	c7 44 24 0c f8 6b 10 	movl   $0x106bf8,0xc(%esp)
  10483c:	00 
  10483d:	c7 44 24 08 49 6b 10 	movl   $0x106b49,0x8(%esp)
  104844:	00 
  104845:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
  10484c:	00 
  10484d:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  104854:	e8 6d c4 ff ff       	call   100cc6 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  104859:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104860:	e8 86 f4 ff ff       	call   103ceb <alloc_pages>
  104865:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  104868:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10486d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104874:	00 
  104875:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10487c:	00 
  10487d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104880:	89 54 24 04          	mov    %edx,0x4(%esp)
  104884:	89 04 24             	mov    %eax,(%esp)
  104887:	e8 e3 fd ff ff       	call   10466f <page_insert>
  10488c:	85 c0                	test   %eax,%eax
  10488e:	74 24                	je     1048b4 <check_pgdir+0x111>
  104890:	c7 44 24 0c 20 6c 10 	movl   $0x106c20,0xc(%esp)
  104897:	00 
  104898:	c7 44 24 08 49 6b 10 	movl   $0x106b49,0x8(%esp)
  10489f:	00 
  1048a0:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  1048a7:	00 
  1048a8:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  1048af:	e8 12 c4 ff ff       	call   100cc6 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  1048b4:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1048b9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1048c0:	00 
  1048c1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1048c8:	00 
  1048c9:	89 04 24             	mov    %eax,(%esp)
  1048cc:	e8 59 fb ff ff       	call   10442a <get_pte>
  1048d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1048d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1048d8:	75 24                	jne    1048fe <check_pgdir+0x15b>
  1048da:	c7 44 24 0c 4c 6c 10 	movl   $0x106c4c,0xc(%esp)
  1048e1:	00 
  1048e2:	c7 44 24 08 49 6b 10 	movl   $0x106b49,0x8(%esp)
  1048e9:	00 
  1048ea:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
  1048f1:	00 
  1048f2:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  1048f9:	e8 c8 c3 ff ff       	call   100cc6 <__panic>
    assert(pa2page(*ptep) == p1);
  1048fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104901:	8b 00                	mov    (%eax),%eax
  104903:	89 04 24             	mov    %eax,(%esp)
  104906:	e8 fa f0 ff ff       	call   103a05 <pa2page>
  10490b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10490e:	74 24                	je     104934 <check_pgdir+0x191>
  104910:	c7 44 24 0c 79 6c 10 	movl   $0x106c79,0xc(%esp)
  104917:	00 
  104918:	c7 44 24 08 49 6b 10 	movl   $0x106b49,0x8(%esp)
  10491f:	00 
  104920:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  104927:	00 
  104928:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  10492f:	e8 92 c3 ff ff       	call   100cc6 <__panic>
    assert(page_ref(p1) == 1);
  104934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104937:	89 04 24             	mov    %eax,(%esp)
  10493a:	e8 a7 f1 ff ff       	call   103ae6 <page_ref>
  10493f:	83 f8 01             	cmp    $0x1,%eax
  104942:	74 24                	je     104968 <check_pgdir+0x1c5>
  104944:	c7 44 24 0c 8e 6c 10 	movl   $0x106c8e,0xc(%esp)
  10494b:	00 
  10494c:	c7 44 24 08 49 6b 10 	movl   $0x106b49,0x8(%esp)
  104953:	00 
  104954:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  10495b:	00 
  10495c:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  104963:	e8 5e c3 ff ff       	call   100cc6 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  104968:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10496d:	8b 00                	mov    (%eax),%eax
  10496f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104974:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104977:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10497a:	c1 e8 0c             	shr    $0xc,%eax
  10497d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104980:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104985:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104988:	72 23                	jb     1049ad <check_pgdir+0x20a>
  10498a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10498d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104991:	c7 44 24 08 5c 6a 10 	movl   $0x106a5c,0x8(%esp)
  104998:	00 
  104999:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  1049a0:	00 
  1049a1:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  1049a8:	e8 19 c3 ff ff       	call   100cc6 <__panic>
  1049ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1049b0:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1049b5:	83 c0 04             	add    $0x4,%eax
  1049b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  1049bb:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1049c0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1049c7:	00 
  1049c8:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1049cf:	00 
  1049d0:	89 04 24             	mov    %eax,(%esp)
  1049d3:	e8 52 fa ff ff       	call   10442a <get_pte>
  1049d8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  1049db:	74 24                	je     104a01 <check_pgdir+0x25e>
  1049dd:	c7 44 24 0c a0 6c 10 	movl   $0x106ca0,0xc(%esp)
  1049e4:	00 
  1049e5:	c7 44 24 08 49 6b 10 	movl   $0x106b49,0x8(%esp)
  1049ec:	00 
  1049ed:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  1049f4:	00 
  1049f5:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  1049fc:	e8 c5 c2 ff ff       	call   100cc6 <__panic>

    p2 = alloc_page();
  104a01:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104a08:	e8 de f2 ff ff       	call   103ceb <alloc_pages>
  104a0d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  104a10:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104a15:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  104a1c:	00 
  104a1d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104a24:	00 
  104a25:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104a28:	89 54 24 04          	mov    %edx,0x4(%esp)
  104a2c:	89 04 24             	mov    %eax,(%esp)
  104a2f:	e8 3b fc ff ff       	call   10466f <page_insert>
  104a34:	85 c0                	test   %eax,%eax
  104a36:	74 24                	je     104a5c <check_pgdir+0x2b9>
  104a38:	c7 44 24 0c c8 6c 10 	movl   $0x106cc8,0xc(%esp)
  104a3f:	00 
  104a40:	c7 44 24 08 49 6b 10 	movl   $0x106b49,0x8(%esp)
  104a47:	00 
  104a48:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  104a4f:	00 
  104a50:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  104a57:	e8 6a c2 ff ff       	call   100cc6 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104a5c:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104a61:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104a68:	00 
  104a69:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104a70:	00 
  104a71:	89 04 24             	mov    %eax,(%esp)
  104a74:	e8 b1 f9 ff ff       	call   10442a <get_pte>
  104a79:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104a7c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104a80:	75 24                	jne    104aa6 <check_pgdir+0x303>
  104a82:	c7 44 24 0c 00 6d 10 	movl   $0x106d00,0xc(%esp)
  104a89:	00 
  104a8a:	c7 44 24 08 49 6b 10 	movl   $0x106b49,0x8(%esp)
  104a91:	00 
  104a92:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
  104a99:	00 
  104a9a:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  104aa1:	e8 20 c2 ff ff       	call   100cc6 <__panic>
    assert(*ptep & PTE_U);
  104aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104aa9:	8b 00                	mov    (%eax),%eax
  104aab:	83 e0 04             	and    $0x4,%eax
  104aae:	85 c0                	test   %eax,%eax
  104ab0:	75 24                	jne    104ad6 <check_pgdir+0x333>
  104ab2:	c7 44 24 0c 30 6d 10 	movl   $0x106d30,0xc(%esp)
  104ab9:	00 
  104aba:	c7 44 24 08 49 6b 10 	movl   $0x106b49,0x8(%esp)
  104ac1:	00 
  104ac2:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
  104ac9:	00 
  104aca:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  104ad1:	e8 f0 c1 ff ff       	call   100cc6 <__panic>
    assert(*ptep & PTE_W);
  104ad6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ad9:	8b 00                	mov    (%eax),%eax
  104adb:	83 e0 02             	and    $0x2,%eax
  104ade:	85 c0                	test   %eax,%eax
  104ae0:	75 24                	jne    104b06 <check_pgdir+0x363>
  104ae2:	c7 44 24 0c 3e 6d 10 	movl   $0x106d3e,0xc(%esp)
  104ae9:	00 
  104aea:	c7 44 24 08 49 6b 10 	movl   $0x106b49,0x8(%esp)
  104af1:	00 
  104af2:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
  104af9:	00 
  104afa:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  104b01:	e8 c0 c1 ff ff       	call   100cc6 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104b06:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104b0b:	8b 00                	mov    (%eax),%eax
  104b0d:	83 e0 04             	and    $0x4,%eax
  104b10:	85 c0                	test   %eax,%eax
  104b12:	75 24                	jne    104b38 <check_pgdir+0x395>
  104b14:	c7 44 24 0c 4c 6d 10 	movl   $0x106d4c,0xc(%esp)
  104b1b:	00 
  104b1c:	c7 44 24 08 49 6b 10 	movl   $0x106b49,0x8(%esp)
  104b23:	00 
  104b24:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  104b2b:	00 
  104b2c:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  104b33:	e8 8e c1 ff ff       	call   100cc6 <__panic>
    assert(page_ref(p2) == 1);
  104b38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b3b:	89 04 24             	mov    %eax,(%esp)
  104b3e:	e8 a3 ef ff ff       	call   103ae6 <page_ref>
  104b43:	83 f8 01             	cmp    $0x1,%eax
  104b46:	74 24                	je     104b6c <check_pgdir+0x3c9>
  104b48:	c7 44 24 0c 62 6d 10 	movl   $0x106d62,0xc(%esp)
  104b4f:	00 
  104b50:	c7 44 24 08 49 6b 10 	movl   $0x106b49,0x8(%esp)
  104b57:	00 
  104b58:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
  104b5f:	00 
  104b60:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  104b67:	e8 5a c1 ff ff       	call   100cc6 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104b6c:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104b71:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104b78:	00 
  104b79:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104b80:	00 
  104b81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104b84:	89 54 24 04          	mov    %edx,0x4(%esp)
  104b88:	89 04 24             	mov    %eax,(%esp)
  104b8b:	e8 df fa ff ff       	call   10466f <page_insert>
  104b90:	85 c0                	test   %eax,%eax
  104b92:	74 24                	je     104bb8 <check_pgdir+0x415>
  104b94:	c7 44 24 0c 74 6d 10 	movl   $0x106d74,0xc(%esp)
  104b9b:	00 
  104b9c:	c7 44 24 08 49 6b 10 	movl   $0x106b49,0x8(%esp)
  104ba3:	00 
  104ba4:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  104bab:	00 
  104bac:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  104bb3:	e8 0e c1 ff ff       	call   100cc6 <__panic>
    assert(page_ref(p1) == 2);
  104bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104bbb:	89 04 24             	mov    %eax,(%esp)
  104bbe:	e8 23 ef ff ff       	call   103ae6 <page_ref>
  104bc3:	83 f8 02             	cmp    $0x2,%eax
  104bc6:	74 24                	je     104bec <check_pgdir+0x449>
  104bc8:	c7 44 24 0c a0 6d 10 	movl   $0x106da0,0xc(%esp)
  104bcf:	00 
  104bd0:	c7 44 24 08 49 6b 10 	movl   $0x106b49,0x8(%esp)
  104bd7:	00 
  104bd8:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  104bdf:	00 
  104be0:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  104be7:	e8 da c0 ff ff       	call   100cc6 <__panic>
    assert(page_ref(p2) == 0);
  104bec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104bef:	89 04 24             	mov    %eax,(%esp)
  104bf2:	e8 ef ee ff ff       	call   103ae6 <page_ref>
  104bf7:	85 c0                	test   %eax,%eax
  104bf9:	74 24                	je     104c1f <check_pgdir+0x47c>
  104bfb:	c7 44 24 0c b2 6d 10 	movl   $0x106db2,0xc(%esp)
  104c02:	00 
  104c03:	c7 44 24 08 49 6b 10 	movl   $0x106b49,0x8(%esp)
  104c0a:	00 
  104c0b:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
  104c12:	00 
  104c13:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  104c1a:	e8 a7 c0 ff ff       	call   100cc6 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104c1f:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104c24:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104c2b:	00 
  104c2c:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104c33:	00 
  104c34:	89 04 24             	mov    %eax,(%esp)
  104c37:	e8 ee f7 ff ff       	call   10442a <get_pte>
  104c3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104c3f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104c43:	75 24                	jne    104c69 <check_pgdir+0x4c6>
  104c45:	c7 44 24 0c 00 6d 10 	movl   $0x106d00,0xc(%esp)
  104c4c:	00 
  104c4d:	c7 44 24 08 49 6b 10 	movl   $0x106b49,0x8(%esp)
  104c54:	00 
  104c55:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
  104c5c:	00 
  104c5d:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  104c64:	e8 5d c0 ff ff       	call   100cc6 <__panic>
    assert(pa2page(*ptep) == p1);
  104c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c6c:	8b 00                	mov    (%eax),%eax
  104c6e:	89 04 24             	mov    %eax,(%esp)
  104c71:	e8 8f ed ff ff       	call   103a05 <pa2page>
  104c76:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104c79:	74 24                	je     104c9f <check_pgdir+0x4fc>
  104c7b:	c7 44 24 0c 79 6c 10 	movl   $0x106c79,0xc(%esp)
  104c82:	00 
  104c83:	c7 44 24 08 49 6b 10 	movl   $0x106b49,0x8(%esp)
  104c8a:	00 
  104c8b:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
  104c92:	00 
  104c93:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  104c9a:	e8 27 c0 ff ff       	call   100cc6 <__panic>
    assert((*ptep & PTE_U) == 0);
  104c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ca2:	8b 00                	mov    (%eax),%eax
  104ca4:	83 e0 04             	and    $0x4,%eax
  104ca7:	85 c0                	test   %eax,%eax
  104ca9:	74 24                	je     104ccf <check_pgdir+0x52c>
  104cab:	c7 44 24 0c c4 6d 10 	movl   $0x106dc4,0xc(%esp)
  104cb2:	00 
  104cb3:	c7 44 24 08 49 6b 10 	movl   $0x106b49,0x8(%esp)
  104cba:	00 
  104cbb:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
  104cc2:	00 
  104cc3:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  104cca:	e8 f7 bf ff ff       	call   100cc6 <__panic>

    page_remove(boot_pgdir, 0x0);
  104ccf:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104cd4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104cdb:	00 
  104cdc:	89 04 24             	mov    %eax,(%esp)
  104cdf:	e8 47 f9 ff ff       	call   10462b <page_remove>
    assert(page_ref(p1) == 1);
  104ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ce7:	89 04 24             	mov    %eax,(%esp)
  104cea:	e8 f7 ed ff ff       	call   103ae6 <page_ref>
  104cef:	83 f8 01             	cmp    $0x1,%eax
  104cf2:	74 24                	je     104d18 <check_pgdir+0x575>
  104cf4:	c7 44 24 0c 8e 6c 10 	movl   $0x106c8e,0xc(%esp)
  104cfb:	00 
  104cfc:	c7 44 24 08 49 6b 10 	movl   $0x106b49,0x8(%esp)
  104d03:	00 
  104d04:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
  104d0b:	00 
  104d0c:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  104d13:	e8 ae bf ff ff       	call   100cc6 <__panic>
    assert(page_ref(p2) == 0);
  104d18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d1b:	89 04 24             	mov    %eax,(%esp)
  104d1e:	e8 c3 ed ff ff       	call   103ae6 <page_ref>
  104d23:	85 c0                	test   %eax,%eax
  104d25:	74 24                	je     104d4b <check_pgdir+0x5a8>
  104d27:	c7 44 24 0c b2 6d 10 	movl   $0x106db2,0xc(%esp)
  104d2e:	00 
  104d2f:	c7 44 24 08 49 6b 10 	movl   $0x106b49,0x8(%esp)
  104d36:	00 
  104d37:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
  104d3e:	00 
  104d3f:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  104d46:	e8 7b bf ff ff       	call   100cc6 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104d4b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104d50:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104d57:	00 
  104d58:	89 04 24             	mov    %eax,(%esp)
  104d5b:	e8 cb f8 ff ff       	call   10462b <page_remove>
    assert(page_ref(p1) == 0);
  104d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d63:	89 04 24             	mov    %eax,(%esp)
  104d66:	e8 7b ed ff ff       	call   103ae6 <page_ref>
  104d6b:	85 c0                	test   %eax,%eax
  104d6d:	74 24                	je     104d93 <check_pgdir+0x5f0>
  104d6f:	c7 44 24 0c d9 6d 10 	movl   $0x106dd9,0xc(%esp)
  104d76:	00 
  104d77:	c7 44 24 08 49 6b 10 	movl   $0x106b49,0x8(%esp)
  104d7e:	00 
  104d7f:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
  104d86:	00 
  104d87:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  104d8e:	e8 33 bf ff ff       	call   100cc6 <__panic>
    assert(page_ref(p2) == 0);
  104d93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d96:	89 04 24             	mov    %eax,(%esp)
  104d99:	e8 48 ed ff ff       	call   103ae6 <page_ref>
  104d9e:	85 c0                	test   %eax,%eax
  104da0:	74 24                	je     104dc6 <check_pgdir+0x623>
  104da2:	c7 44 24 0c b2 6d 10 	movl   $0x106db2,0xc(%esp)
  104da9:	00 
  104daa:	c7 44 24 08 49 6b 10 	movl   $0x106b49,0x8(%esp)
  104db1:	00 
  104db2:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
  104db9:	00 
  104dba:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  104dc1:	e8 00 bf ff ff       	call   100cc6 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
  104dc6:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104dcb:	8b 00                	mov    (%eax),%eax
  104dcd:	89 04 24             	mov    %eax,(%esp)
  104dd0:	e8 30 ec ff ff       	call   103a05 <pa2page>
  104dd5:	89 04 24             	mov    %eax,(%esp)
  104dd8:	e8 09 ed ff ff       	call   103ae6 <page_ref>
  104ddd:	83 f8 01             	cmp    $0x1,%eax
  104de0:	74 24                	je     104e06 <check_pgdir+0x663>
  104de2:	c7 44 24 0c ec 6d 10 	movl   $0x106dec,0xc(%esp)
  104de9:	00 
  104dea:	c7 44 24 08 49 6b 10 	movl   $0x106b49,0x8(%esp)
  104df1:	00 
  104df2:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
  104df9:	00 
  104dfa:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  104e01:	e8 c0 be ff ff       	call   100cc6 <__panic>
    free_page(pa2page(boot_pgdir[0]));
  104e06:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104e0b:	8b 00                	mov    (%eax),%eax
  104e0d:	89 04 24             	mov    %eax,(%esp)
  104e10:	e8 f0 eb ff ff       	call   103a05 <pa2page>
  104e15:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104e1c:	00 
  104e1d:	89 04 24             	mov    %eax,(%esp)
  104e20:	e8 fe ee ff ff       	call   103d23 <free_pages>
    boot_pgdir[0] = 0;
  104e25:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104e2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104e30:	c7 04 24 12 6e 10 00 	movl   $0x106e12,(%esp)
  104e37:	e8 00 b5 ff ff       	call   10033c <cprintf>
}
  104e3c:	c9                   	leave  
  104e3d:	c3                   	ret    

00104e3e <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  104e3e:	55                   	push   %ebp
  104e3f:	89 e5                	mov    %esp,%ebp
  104e41:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104e44:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104e4b:	e9 ca 00 00 00       	jmp    104f1a <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e53:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104e56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e59:	c1 e8 0c             	shr    $0xc,%eax
  104e5c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104e5f:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104e64:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104e67:	72 23                	jb     104e8c <check_boot_pgdir+0x4e>
  104e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e6c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104e70:	c7 44 24 08 5c 6a 10 	movl   $0x106a5c,0x8(%esp)
  104e77:	00 
  104e78:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
  104e7f:	00 
  104e80:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  104e87:	e8 3a be ff ff       	call   100cc6 <__panic>
  104e8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e8f:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104e94:	89 c2                	mov    %eax,%edx
  104e96:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104e9b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104ea2:	00 
  104ea3:	89 54 24 04          	mov    %edx,0x4(%esp)
  104ea7:	89 04 24             	mov    %eax,(%esp)
  104eaa:	e8 7b f5 ff ff       	call   10442a <get_pte>
  104eaf:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104eb2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104eb6:	75 24                	jne    104edc <check_boot_pgdir+0x9e>
  104eb8:	c7 44 24 0c 2c 6e 10 	movl   $0x106e2c,0xc(%esp)
  104ebf:	00 
  104ec0:	c7 44 24 08 49 6b 10 	movl   $0x106b49,0x8(%esp)
  104ec7:	00 
  104ec8:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
  104ecf:	00 
  104ed0:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  104ed7:	e8 ea bd ff ff       	call   100cc6 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  104edc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104edf:	8b 00                	mov    (%eax),%eax
  104ee1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104ee6:	89 c2                	mov    %eax,%edx
  104ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104eeb:	39 c2                	cmp    %eax,%edx
  104eed:	74 24                	je     104f13 <check_boot_pgdir+0xd5>
  104eef:	c7 44 24 0c 69 6e 10 	movl   $0x106e69,0xc(%esp)
  104ef6:	00 
  104ef7:	c7 44 24 08 49 6b 10 	movl   $0x106b49,0x8(%esp)
  104efe:	00 
  104eff:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
  104f06:	00 
  104f07:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  104f0e:	e8 b3 bd ff ff       	call   100cc6 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104f13:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  104f1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104f1d:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104f22:	39 c2                	cmp    %eax,%edx
  104f24:	0f 82 26 ff ff ff    	jb     104e50 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  104f2a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104f2f:	05 ac 0f 00 00       	add    $0xfac,%eax
  104f34:	8b 00                	mov    (%eax),%eax
  104f36:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104f3b:	89 c2                	mov    %eax,%edx
  104f3d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104f42:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104f45:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  104f4c:	77 23                	ja     104f71 <check_boot_pgdir+0x133>
  104f4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f51:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104f55:	c7 44 24 08 00 6b 10 	movl   $0x106b00,0x8(%esp)
  104f5c:	00 
  104f5d:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
  104f64:	00 
  104f65:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  104f6c:	e8 55 bd ff ff       	call   100cc6 <__panic>
  104f71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f74:	05 00 00 00 40       	add    $0x40000000,%eax
  104f79:	39 c2                	cmp    %eax,%edx
  104f7b:	74 24                	je     104fa1 <check_boot_pgdir+0x163>
  104f7d:	c7 44 24 0c 80 6e 10 	movl   $0x106e80,0xc(%esp)
  104f84:	00 
  104f85:	c7 44 24 08 49 6b 10 	movl   $0x106b49,0x8(%esp)
  104f8c:	00 
  104f8d:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
  104f94:	00 
  104f95:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  104f9c:	e8 25 bd ff ff       	call   100cc6 <__panic>

    assert(boot_pgdir[0] == 0);
  104fa1:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104fa6:	8b 00                	mov    (%eax),%eax
  104fa8:	85 c0                	test   %eax,%eax
  104faa:	74 24                	je     104fd0 <check_boot_pgdir+0x192>
  104fac:	c7 44 24 0c b4 6e 10 	movl   $0x106eb4,0xc(%esp)
  104fb3:	00 
  104fb4:	c7 44 24 08 49 6b 10 	movl   $0x106b49,0x8(%esp)
  104fbb:	00 
  104fbc:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
  104fc3:	00 
  104fc4:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  104fcb:	e8 f6 bc ff ff       	call   100cc6 <__panic>

    struct Page *p;
    p = alloc_page();
  104fd0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104fd7:	e8 0f ed ff ff       	call   103ceb <alloc_pages>
  104fdc:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  104fdf:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104fe4:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104feb:	00 
  104fec:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  104ff3:	00 
  104ff4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104ff7:	89 54 24 04          	mov    %edx,0x4(%esp)
  104ffb:	89 04 24             	mov    %eax,(%esp)
  104ffe:	e8 6c f6 ff ff       	call   10466f <page_insert>
  105003:	85 c0                	test   %eax,%eax
  105005:	74 24                	je     10502b <check_boot_pgdir+0x1ed>
  105007:	c7 44 24 0c c8 6e 10 	movl   $0x106ec8,0xc(%esp)
  10500e:	00 
  10500f:	c7 44 24 08 49 6b 10 	movl   $0x106b49,0x8(%esp)
  105016:	00 
  105017:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
  10501e:	00 
  10501f:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  105026:	e8 9b bc ff ff       	call   100cc6 <__panic>
    assert(page_ref(p) == 1);
  10502b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10502e:	89 04 24             	mov    %eax,(%esp)
  105031:	e8 b0 ea ff ff       	call   103ae6 <page_ref>
  105036:	83 f8 01             	cmp    $0x1,%eax
  105039:	74 24                	je     10505f <check_boot_pgdir+0x221>
  10503b:	c7 44 24 0c f6 6e 10 	movl   $0x106ef6,0xc(%esp)
  105042:	00 
  105043:	c7 44 24 08 49 6b 10 	movl   $0x106b49,0x8(%esp)
  10504a:	00 
  10504b:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
  105052:	00 
  105053:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  10505a:	e8 67 bc ff ff       	call   100cc6 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  10505f:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105064:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  10506b:	00 
  10506c:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  105073:	00 
  105074:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105077:	89 54 24 04          	mov    %edx,0x4(%esp)
  10507b:	89 04 24             	mov    %eax,(%esp)
  10507e:	e8 ec f5 ff ff       	call   10466f <page_insert>
  105083:	85 c0                	test   %eax,%eax
  105085:	74 24                	je     1050ab <check_boot_pgdir+0x26d>
  105087:	c7 44 24 0c 08 6f 10 	movl   $0x106f08,0xc(%esp)
  10508e:	00 
  10508f:	c7 44 24 08 49 6b 10 	movl   $0x106b49,0x8(%esp)
  105096:	00 
  105097:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
  10509e:	00 
  10509f:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  1050a6:	e8 1b bc ff ff       	call   100cc6 <__panic>
    assert(page_ref(p) == 2);
  1050ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1050ae:	89 04 24             	mov    %eax,(%esp)
  1050b1:	e8 30 ea ff ff       	call   103ae6 <page_ref>
  1050b6:	83 f8 02             	cmp    $0x2,%eax
  1050b9:	74 24                	je     1050df <check_boot_pgdir+0x2a1>
  1050bb:	c7 44 24 0c 3f 6f 10 	movl   $0x106f3f,0xc(%esp)
  1050c2:	00 
  1050c3:	c7 44 24 08 49 6b 10 	movl   $0x106b49,0x8(%esp)
  1050ca:	00 
  1050cb:	c7 44 24 04 3f 02 00 	movl   $0x23f,0x4(%esp)
  1050d2:	00 
  1050d3:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  1050da:	e8 e7 bb ff ff       	call   100cc6 <__panic>

    const char *str = "ucore: Hello world!!";
  1050df:	c7 45 dc 50 6f 10 00 	movl   $0x106f50,-0x24(%ebp)
    strcpy((void *)0x100, str);
  1050e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1050e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1050ed:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1050f4:	e8 1e 0a 00 00       	call   105b17 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  1050f9:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  105100:	00 
  105101:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105108:	e8 83 0a 00 00       	call   105b90 <strcmp>
  10510d:	85 c0                	test   %eax,%eax
  10510f:	74 24                	je     105135 <check_boot_pgdir+0x2f7>
  105111:	c7 44 24 0c 68 6f 10 	movl   $0x106f68,0xc(%esp)
  105118:	00 
  105119:	c7 44 24 08 49 6b 10 	movl   $0x106b49,0x8(%esp)
  105120:	00 
  105121:	c7 44 24 04 43 02 00 	movl   $0x243,0x4(%esp)
  105128:	00 
  105129:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  105130:	e8 91 bb ff ff       	call   100cc6 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  105135:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105138:	89 04 24             	mov    %eax,(%esp)
  10513b:	e8 14 e9 ff ff       	call   103a54 <page2kva>
  105140:	05 00 01 00 00       	add    $0x100,%eax
  105145:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  105148:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10514f:	e8 6b 09 00 00       	call   105abf <strlen>
  105154:	85 c0                	test   %eax,%eax
  105156:	74 24                	je     10517c <check_boot_pgdir+0x33e>
  105158:	c7 44 24 0c a0 6f 10 	movl   $0x106fa0,0xc(%esp)
  10515f:	00 
  105160:	c7 44 24 08 49 6b 10 	movl   $0x106b49,0x8(%esp)
  105167:	00 
  105168:	c7 44 24 04 46 02 00 	movl   $0x246,0x4(%esp)
  10516f:	00 
  105170:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  105177:	e8 4a bb ff ff       	call   100cc6 <__panic>

    free_page(p);
  10517c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105183:	00 
  105184:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105187:	89 04 24             	mov    %eax,(%esp)
  10518a:	e8 94 eb ff ff       	call   103d23 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
  10518f:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105194:	8b 00                	mov    (%eax),%eax
  105196:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10519b:	89 04 24             	mov    %eax,(%esp)
  10519e:	e8 62 e8 ff ff       	call   103a05 <pa2page>
  1051a3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1051aa:	00 
  1051ab:	89 04 24             	mov    %eax,(%esp)
  1051ae:	e8 70 eb ff ff       	call   103d23 <free_pages>
    boot_pgdir[0] = 0;
  1051b3:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1051b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  1051be:	c7 04 24 c4 6f 10 00 	movl   $0x106fc4,(%esp)
  1051c5:	e8 72 b1 ff ff       	call   10033c <cprintf>
}
  1051ca:	c9                   	leave  
  1051cb:	c3                   	ret    

001051cc <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  1051cc:	55                   	push   %ebp
  1051cd:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  1051cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1051d2:	83 e0 04             	and    $0x4,%eax
  1051d5:	85 c0                	test   %eax,%eax
  1051d7:	74 07                	je     1051e0 <perm2str+0x14>
  1051d9:	b8 75 00 00 00       	mov    $0x75,%eax
  1051de:	eb 05                	jmp    1051e5 <perm2str+0x19>
  1051e0:	b8 2d 00 00 00       	mov    $0x2d,%eax
  1051e5:	a2 48 89 11 00       	mov    %al,0x118948
    str[1] = 'r';
  1051ea:	c6 05 49 89 11 00 72 	movb   $0x72,0x118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
  1051f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1051f4:	83 e0 02             	and    $0x2,%eax
  1051f7:	85 c0                	test   %eax,%eax
  1051f9:	74 07                	je     105202 <perm2str+0x36>
  1051fb:	b8 77 00 00 00       	mov    $0x77,%eax
  105200:	eb 05                	jmp    105207 <perm2str+0x3b>
  105202:	b8 2d 00 00 00       	mov    $0x2d,%eax
  105207:	a2 4a 89 11 00       	mov    %al,0x11894a
    str[3] = '\0';
  10520c:	c6 05 4b 89 11 00 00 	movb   $0x0,0x11894b
    return str;
  105213:	b8 48 89 11 00       	mov    $0x118948,%eax
}
  105218:	5d                   	pop    %ebp
  105219:	c3                   	ret    

0010521a <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  10521a:	55                   	push   %ebp
  10521b:	89 e5                	mov    %esp,%ebp
  10521d:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  105220:	8b 45 10             	mov    0x10(%ebp),%eax
  105223:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105226:	72 0a                	jb     105232 <get_pgtable_items+0x18>
        return 0;
  105228:	b8 00 00 00 00       	mov    $0x0,%eax
  10522d:	e9 9c 00 00 00       	jmp    1052ce <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  105232:	eb 04                	jmp    105238 <get_pgtable_items+0x1e>
        start ++;
  105234:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  105238:	8b 45 10             	mov    0x10(%ebp),%eax
  10523b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10523e:	73 18                	jae    105258 <get_pgtable_items+0x3e>
  105240:	8b 45 10             	mov    0x10(%ebp),%eax
  105243:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10524a:	8b 45 14             	mov    0x14(%ebp),%eax
  10524d:	01 d0                	add    %edx,%eax
  10524f:	8b 00                	mov    (%eax),%eax
  105251:	83 e0 01             	and    $0x1,%eax
  105254:	85 c0                	test   %eax,%eax
  105256:	74 dc                	je     105234 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
  105258:	8b 45 10             	mov    0x10(%ebp),%eax
  10525b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10525e:	73 69                	jae    1052c9 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  105260:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  105264:	74 08                	je     10526e <get_pgtable_items+0x54>
            *left_store = start;
  105266:	8b 45 18             	mov    0x18(%ebp),%eax
  105269:	8b 55 10             	mov    0x10(%ebp),%edx
  10526c:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  10526e:	8b 45 10             	mov    0x10(%ebp),%eax
  105271:	8d 50 01             	lea    0x1(%eax),%edx
  105274:	89 55 10             	mov    %edx,0x10(%ebp)
  105277:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10527e:	8b 45 14             	mov    0x14(%ebp),%eax
  105281:	01 d0                	add    %edx,%eax
  105283:	8b 00                	mov    (%eax),%eax
  105285:	83 e0 07             	and    $0x7,%eax
  105288:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  10528b:	eb 04                	jmp    105291 <get_pgtable_items+0x77>
            start ++;
  10528d:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  105291:	8b 45 10             	mov    0x10(%ebp),%eax
  105294:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105297:	73 1d                	jae    1052b6 <get_pgtable_items+0x9c>
  105299:	8b 45 10             	mov    0x10(%ebp),%eax
  10529c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1052a3:	8b 45 14             	mov    0x14(%ebp),%eax
  1052a6:	01 d0                	add    %edx,%eax
  1052a8:	8b 00                	mov    (%eax),%eax
  1052aa:	83 e0 07             	and    $0x7,%eax
  1052ad:	89 c2                	mov    %eax,%edx
  1052af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1052b2:	39 c2                	cmp    %eax,%edx
  1052b4:	74 d7                	je     10528d <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
  1052b6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1052ba:	74 08                	je     1052c4 <get_pgtable_items+0xaa>
            *right_store = start;
  1052bc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1052bf:	8b 55 10             	mov    0x10(%ebp),%edx
  1052c2:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  1052c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1052c7:	eb 05                	jmp    1052ce <get_pgtable_items+0xb4>
    }
    return 0;
  1052c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1052ce:	c9                   	leave  
  1052cf:	c3                   	ret    

001052d0 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  1052d0:	55                   	push   %ebp
  1052d1:	89 e5                	mov    %esp,%ebp
  1052d3:	57                   	push   %edi
  1052d4:	56                   	push   %esi
  1052d5:	53                   	push   %ebx
  1052d6:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  1052d9:	c7 04 24 e4 6f 10 00 	movl   $0x106fe4,(%esp)
  1052e0:	e8 57 b0 ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
  1052e5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1052ec:	e9 fa 00 00 00       	jmp    1053eb <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1052f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1052f4:	89 04 24             	mov    %eax,(%esp)
  1052f7:	e8 d0 fe ff ff       	call   1051cc <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  1052fc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1052ff:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105302:	29 d1                	sub    %edx,%ecx
  105304:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  105306:	89 d6                	mov    %edx,%esi
  105308:	c1 e6 16             	shl    $0x16,%esi
  10530b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10530e:	89 d3                	mov    %edx,%ebx
  105310:	c1 e3 16             	shl    $0x16,%ebx
  105313:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105316:	89 d1                	mov    %edx,%ecx
  105318:	c1 e1 16             	shl    $0x16,%ecx
  10531b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  10531e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105321:	29 d7                	sub    %edx,%edi
  105323:	89 fa                	mov    %edi,%edx
  105325:	89 44 24 14          	mov    %eax,0x14(%esp)
  105329:	89 74 24 10          	mov    %esi,0x10(%esp)
  10532d:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105331:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  105335:	89 54 24 04          	mov    %edx,0x4(%esp)
  105339:	c7 04 24 15 70 10 00 	movl   $0x107015,(%esp)
  105340:	e8 f7 af ff ff       	call   10033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  105345:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105348:	c1 e0 0a             	shl    $0xa,%eax
  10534b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  10534e:	eb 54                	jmp    1053a4 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105350:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105353:	89 04 24             	mov    %eax,(%esp)
  105356:	e8 71 fe ff ff       	call   1051cc <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  10535b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  10535e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105361:	29 d1                	sub    %edx,%ecx
  105363:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105365:	89 d6                	mov    %edx,%esi
  105367:	c1 e6 0c             	shl    $0xc,%esi
  10536a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10536d:	89 d3                	mov    %edx,%ebx
  10536f:	c1 e3 0c             	shl    $0xc,%ebx
  105372:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105375:	c1 e2 0c             	shl    $0xc,%edx
  105378:	89 d1                	mov    %edx,%ecx
  10537a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  10537d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105380:	29 d7                	sub    %edx,%edi
  105382:	89 fa                	mov    %edi,%edx
  105384:	89 44 24 14          	mov    %eax,0x14(%esp)
  105388:	89 74 24 10          	mov    %esi,0x10(%esp)
  10538c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105390:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  105394:	89 54 24 04          	mov    %edx,0x4(%esp)
  105398:	c7 04 24 34 70 10 00 	movl   $0x107034,(%esp)
  10539f:	e8 98 af ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1053a4:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  1053a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1053ac:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1053af:	89 ce                	mov    %ecx,%esi
  1053b1:	c1 e6 0a             	shl    $0xa,%esi
  1053b4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  1053b7:	89 cb                	mov    %ecx,%ebx
  1053b9:	c1 e3 0a             	shl    $0xa,%ebx
  1053bc:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  1053bf:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  1053c3:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  1053c6:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  1053ca:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1053ce:	89 44 24 08          	mov    %eax,0x8(%esp)
  1053d2:	89 74 24 04          	mov    %esi,0x4(%esp)
  1053d6:	89 1c 24             	mov    %ebx,(%esp)
  1053d9:	e8 3c fe ff ff       	call   10521a <get_pgtable_items>
  1053de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1053e1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1053e5:	0f 85 65 ff ff ff    	jne    105350 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1053eb:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  1053f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1053f3:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  1053f6:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  1053fa:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  1053fd:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  105401:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105405:	89 44 24 08          	mov    %eax,0x8(%esp)
  105409:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  105410:	00 
  105411:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105418:	e8 fd fd ff ff       	call   10521a <get_pgtable_items>
  10541d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105420:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105424:	0f 85 c7 fe ff ff    	jne    1052f1 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  10542a:	c7 04 24 58 70 10 00 	movl   $0x107058,(%esp)
  105431:	e8 06 af ff ff       	call   10033c <cprintf>
}
  105436:	83 c4 4c             	add    $0x4c,%esp
  105439:	5b                   	pop    %ebx
  10543a:	5e                   	pop    %esi
  10543b:	5f                   	pop    %edi
  10543c:	5d                   	pop    %ebp
  10543d:	c3                   	ret    

0010543e <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  10543e:	55                   	push   %ebp
  10543f:	89 e5                	mov    %esp,%ebp
  105441:	83 ec 58             	sub    $0x58,%esp
  105444:	8b 45 10             	mov    0x10(%ebp),%eax
  105447:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10544a:	8b 45 14             	mov    0x14(%ebp),%eax
  10544d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  105450:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105453:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105456:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105459:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  10545c:	8b 45 18             	mov    0x18(%ebp),%eax
  10545f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105462:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105465:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105468:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10546b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10546e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105471:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105474:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105478:	74 1c                	je     105496 <printnum+0x58>
  10547a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10547d:	ba 00 00 00 00       	mov    $0x0,%edx
  105482:	f7 75 e4             	divl   -0x1c(%ebp)
  105485:	89 55 f4             	mov    %edx,-0xc(%ebp)
  105488:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10548b:	ba 00 00 00 00       	mov    $0x0,%edx
  105490:	f7 75 e4             	divl   -0x1c(%ebp)
  105493:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105496:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105499:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10549c:	f7 75 e4             	divl   -0x1c(%ebp)
  10549f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1054a2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1054a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1054a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1054ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1054ae:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1054b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1054b4:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1054b7:	8b 45 18             	mov    0x18(%ebp),%eax
  1054ba:	ba 00 00 00 00       	mov    $0x0,%edx
  1054bf:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1054c2:	77 56                	ja     10551a <printnum+0xdc>
  1054c4:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1054c7:	72 05                	jb     1054ce <printnum+0x90>
  1054c9:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1054cc:	77 4c                	ja     10551a <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  1054ce:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1054d1:	8d 50 ff             	lea    -0x1(%eax),%edx
  1054d4:	8b 45 20             	mov    0x20(%ebp),%eax
  1054d7:	89 44 24 18          	mov    %eax,0x18(%esp)
  1054db:	89 54 24 14          	mov    %edx,0x14(%esp)
  1054df:	8b 45 18             	mov    0x18(%ebp),%eax
  1054e2:	89 44 24 10          	mov    %eax,0x10(%esp)
  1054e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1054e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1054ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  1054f0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1054f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1054f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1054fe:	89 04 24             	mov    %eax,(%esp)
  105501:	e8 38 ff ff ff       	call   10543e <printnum>
  105506:	eb 1c                	jmp    105524 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  105508:	8b 45 0c             	mov    0xc(%ebp),%eax
  10550b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10550f:	8b 45 20             	mov    0x20(%ebp),%eax
  105512:	89 04 24             	mov    %eax,(%esp)
  105515:	8b 45 08             	mov    0x8(%ebp),%eax
  105518:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  10551a:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  10551e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105522:	7f e4                	jg     105508 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  105524:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105527:	05 0c 71 10 00       	add    $0x10710c,%eax
  10552c:	0f b6 00             	movzbl (%eax),%eax
  10552f:	0f be c0             	movsbl %al,%eax
  105532:	8b 55 0c             	mov    0xc(%ebp),%edx
  105535:	89 54 24 04          	mov    %edx,0x4(%esp)
  105539:	89 04 24             	mov    %eax,(%esp)
  10553c:	8b 45 08             	mov    0x8(%ebp),%eax
  10553f:	ff d0                	call   *%eax
}
  105541:	c9                   	leave  
  105542:	c3                   	ret    

00105543 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  105543:	55                   	push   %ebp
  105544:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105546:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10554a:	7e 14                	jle    105560 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  10554c:	8b 45 08             	mov    0x8(%ebp),%eax
  10554f:	8b 00                	mov    (%eax),%eax
  105551:	8d 48 08             	lea    0x8(%eax),%ecx
  105554:	8b 55 08             	mov    0x8(%ebp),%edx
  105557:	89 0a                	mov    %ecx,(%edx)
  105559:	8b 50 04             	mov    0x4(%eax),%edx
  10555c:	8b 00                	mov    (%eax),%eax
  10555e:	eb 30                	jmp    105590 <getuint+0x4d>
    }
    else if (lflag) {
  105560:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105564:	74 16                	je     10557c <getuint+0x39>
        return va_arg(*ap, unsigned long);
  105566:	8b 45 08             	mov    0x8(%ebp),%eax
  105569:	8b 00                	mov    (%eax),%eax
  10556b:	8d 48 04             	lea    0x4(%eax),%ecx
  10556e:	8b 55 08             	mov    0x8(%ebp),%edx
  105571:	89 0a                	mov    %ecx,(%edx)
  105573:	8b 00                	mov    (%eax),%eax
  105575:	ba 00 00 00 00       	mov    $0x0,%edx
  10557a:	eb 14                	jmp    105590 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  10557c:	8b 45 08             	mov    0x8(%ebp),%eax
  10557f:	8b 00                	mov    (%eax),%eax
  105581:	8d 48 04             	lea    0x4(%eax),%ecx
  105584:	8b 55 08             	mov    0x8(%ebp),%edx
  105587:	89 0a                	mov    %ecx,(%edx)
  105589:	8b 00                	mov    (%eax),%eax
  10558b:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  105590:	5d                   	pop    %ebp
  105591:	c3                   	ret    

00105592 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  105592:	55                   	push   %ebp
  105593:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105595:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105599:	7e 14                	jle    1055af <getint+0x1d>
        return va_arg(*ap, long long);
  10559b:	8b 45 08             	mov    0x8(%ebp),%eax
  10559e:	8b 00                	mov    (%eax),%eax
  1055a0:	8d 48 08             	lea    0x8(%eax),%ecx
  1055a3:	8b 55 08             	mov    0x8(%ebp),%edx
  1055a6:	89 0a                	mov    %ecx,(%edx)
  1055a8:	8b 50 04             	mov    0x4(%eax),%edx
  1055ab:	8b 00                	mov    (%eax),%eax
  1055ad:	eb 28                	jmp    1055d7 <getint+0x45>
    }
    else if (lflag) {
  1055af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1055b3:	74 12                	je     1055c7 <getint+0x35>
        return va_arg(*ap, long);
  1055b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1055b8:	8b 00                	mov    (%eax),%eax
  1055ba:	8d 48 04             	lea    0x4(%eax),%ecx
  1055bd:	8b 55 08             	mov    0x8(%ebp),%edx
  1055c0:	89 0a                	mov    %ecx,(%edx)
  1055c2:	8b 00                	mov    (%eax),%eax
  1055c4:	99                   	cltd   
  1055c5:	eb 10                	jmp    1055d7 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  1055c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1055ca:	8b 00                	mov    (%eax),%eax
  1055cc:	8d 48 04             	lea    0x4(%eax),%ecx
  1055cf:	8b 55 08             	mov    0x8(%ebp),%edx
  1055d2:	89 0a                	mov    %ecx,(%edx)
  1055d4:	8b 00                	mov    (%eax),%eax
  1055d6:	99                   	cltd   
    }
}
  1055d7:	5d                   	pop    %ebp
  1055d8:	c3                   	ret    

001055d9 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1055d9:	55                   	push   %ebp
  1055da:	89 e5                	mov    %esp,%ebp
  1055dc:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  1055df:	8d 45 14             	lea    0x14(%ebp),%eax
  1055e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1055e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1055e8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1055ec:	8b 45 10             	mov    0x10(%ebp),%eax
  1055ef:	89 44 24 08          	mov    %eax,0x8(%esp)
  1055f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1055fd:	89 04 24             	mov    %eax,(%esp)
  105600:	e8 02 00 00 00       	call   105607 <vprintfmt>
    va_end(ap);
}
  105605:	c9                   	leave  
  105606:	c3                   	ret    

00105607 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  105607:	55                   	push   %ebp
  105608:	89 e5                	mov    %esp,%ebp
  10560a:	56                   	push   %esi
  10560b:	53                   	push   %ebx
  10560c:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10560f:	eb 18                	jmp    105629 <vprintfmt+0x22>
            if (ch == '\0') {
  105611:	85 db                	test   %ebx,%ebx
  105613:	75 05                	jne    10561a <vprintfmt+0x13>
                return;
  105615:	e9 d1 03 00 00       	jmp    1059eb <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  10561a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10561d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105621:	89 1c 24             	mov    %ebx,(%esp)
  105624:	8b 45 08             	mov    0x8(%ebp),%eax
  105627:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105629:	8b 45 10             	mov    0x10(%ebp),%eax
  10562c:	8d 50 01             	lea    0x1(%eax),%edx
  10562f:	89 55 10             	mov    %edx,0x10(%ebp)
  105632:	0f b6 00             	movzbl (%eax),%eax
  105635:	0f b6 d8             	movzbl %al,%ebx
  105638:	83 fb 25             	cmp    $0x25,%ebx
  10563b:	75 d4                	jne    105611 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  10563d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  105641:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  105648:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10564b:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  10564e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  105655:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105658:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  10565b:	8b 45 10             	mov    0x10(%ebp),%eax
  10565e:	8d 50 01             	lea    0x1(%eax),%edx
  105661:	89 55 10             	mov    %edx,0x10(%ebp)
  105664:	0f b6 00             	movzbl (%eax),%eax
  105667:	0f b6 d8             	movzbl %al,%ebx
  10566a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  10566d:	83 f8 55             	cmp    $0x55,%eax
  105670:	0f 87 44 03 00 00    	ja     1059ba <vprintfmt+0x3b3>
  105676:	8b 04 85 30 71 10 00 	mov    0x107130(,%eax,4),%eax
  10567d:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  10567f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105683:	eb d6                	jmp    10565b <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105685:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105689:	eb d0                	jmp    10565b <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10568b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  105692:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105695:	89 d0                	mov    %edx,%eax
  105697:	c1 e0 02             	shl    $0x2,%eax
  10569a:	01 d0                	add    %edx,%eax
  10569c:	01 c0                	add    %eax,%eax
  10569e:	01 d8                	add    %ebx,%eax
  1056a0:	83 e8 30             	sub    $0x30,%eax
  1056a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1056a6:	8b 45 10             	mov    0x10(%ebp),%eax
  1056a9:	0f b6 00             	movzbl (%eax),%eax
  1056ac:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1056af:	83 fb 2f             	cmp    $0x2f,%ebx
  1056b2:	7e 0b                	jle    1056bf <vprintfmt+0xb8>
  1056b4:	83 fb 39             	cmp    $0x39,%ebx
  1056b7:	7f 06                	jg     1056bf <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1056b9:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  1056bd:	eb d3                	jmp    105692 <vprintfmt+0x8b>
            goto process_precision;
  1056bf:	eb 33                	jmp    1056f4 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  1056c1:	8b 45 14             	mov    0x14(%ebp),%eax
  1056c4:	8d 50 04             	lea    0x4(%eax),%edx
  1056c7:	89 55 14             	mov    %edx,0x14(%ebp)
  1056ca:	8b 00                	mov    (%eax),%eax
  1056cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1056cf:	eb 23                	jmp    1056f4 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  1056d1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1056d5:	79 0c                	jns    1056e3 <vprintfmt+0xdc>
                width = 0;
  1056d7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1056de:	e9 78 ff ff ff       	jmp    10565b <vprintfmt+0x54>
  1056e3:	e9 73 ff ff ff       	jmp    10565b <vprintfmt+0x54>

        case '#':
            altflag = 1;
  1056e8:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1056ef:	e9 67 ff ff ff       	jmp    10565b <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  1056f4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1056f8:	79 12                	jns    10570c <vprintfmt+0x105>
                width = precision, precision = -1;
  1056fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1056fd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105700:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  105707:	e9 4f ff ff ff       	jmp    10565b <vprintfmt+0x54>
  10570c:	e9 4a ff ff ff       	jmp    10565b <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  105711:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  105715:	e9 41 ff ff ff       	jmp    10565b <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  10571a:	8b 45 14             	mov    0x14(%ebp),%eax
  10571d:	8d 50 04             	lea    0x4(%eax),%edx
  105720:	89 55 14             	mov    %edx,0x14(%ebp)
  105723:	8b 00                	mov    (%eax),%eax
  105725:	8b 55 0c             	mov    0xc(%ebp),%edx
  105728:	89 54 24 04          	mov    %edx,0x4(%esp)
  10572c:	89 04 24             	mov    %eax,(%esp)
  10572f:	8b 45 08             	mov    0x8(%ebp),%eax
  105732:	ff d0                	call   *%eax
            break;
  105734:	e9 ac 02 00 00       	jmp    1059e5 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  105739:	8b 45 14             	mov    0x14(%ebp),%eax
  10573c:	8d 50 04             	lea    0x4(%eax),%edx
  10573f:	89 55 14             	mov    %edx,0x14(%ebp)
  105742:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  105744:	85 db                	test   %ebx,%ebx
  105746:	79 02                	jns    10574a <vprintfmt+0x143>
                err = -err;
  105748:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  10574a:	83 fb 06             	cmp    $0x6,%ebx
  10574d:	7f 0b                	jg     10575a <vprintfmt+0x153>
  10574f:	8b 34 9d f0 70 10 00 	mov    0x1070f0(,%ebx,4),%esi
  105756:	85 f6                	test   %esi,%esi
  105758:	75 23                	jne    10577d <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  10575a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10575e:	c7 44 24 08 1d 71 10 	movl   $0x10711d,0x8(%esp)
  105765:	00 
  105766:	8b 45 0c             	mov    0xc(%ebp),%eax
  105769:	89 44 24 04          	mov    %eax,0x4(%esp)
  10576d:	8b 45 08             	mov    0x8(%ebp),%eax
  105770:	89 04 24             	mov    %eax,(%esp)
  105773:	e8 61 fe ff ff       	call   1055d9 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105778:	e9 68 02 00 00       	jmp    1059e5 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  10577d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105781:	c7 44 24 08 26 71 10 	movl   $0x107126,0x8(%esp)
  105788:	00 
  105789:	8b 45 0c             	mov    0xc(%ebp),%eax
  10578c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105790:	8b 45 08             	mov    0x8(%ebp),%eax
  105793:	89 04 24             	mov    %eax,(%esp)
  105796:	e8 3e fe ff ff       	call   1055d9 <printfmt>
            }
            break;
  10579b:	e9 45 02 00 00       	jmp    1059e5 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1057a0:	8b 45 14             	mov    0x14(%ebp),%eax
  1057a3:	8d 50 04             	lea    0x4(%eax),%edx
  1057a6:	89 55 14             	mov    %edx,0x14(%ebp)
  1057a9:	8b 30                	mov    (%eax),%esi
  1057ab:	85 f6                	test   %esi,%esi
  1057ad:	75 05                	jne    1057b4 <vprintfmt+0x1ad>
                p = "(null)";
  1057af:	be 29 71 10 00       	mov    $0x107129,%esi
            }
            if (width > 0 && padc != '-') {
  1057b4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1057b8:	7e 3e                	jle    1057f8 <vprintfmt+0x1f1>
  1057ba:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1057be:	74 38                	je     1057f8 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1057c0:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  1057c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1057c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057ca:	89 34 24             	mov    %esi,(%esp)
  1057cd:	e8 15 03 00 00       	call   105ae7 <strnlen>
  1057d2:	29 c3                	sub    %eax,%ebx
  1057d4:	89 d8                	mov    %ebx,%eax
  1057d6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1057d9:	eb 17                	jmp    1057f2 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  1057db:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1057df:	8b 55 0c             	mov    0xc(%ebp),%edx
  1057e2:	89 54 24 04          	mov    %edx,0x4(%esp)
  1057e6:	89 04 24             	mov    %eax,(%esp)
  1057e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1057ec:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  1057ee:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1057f2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1057f6:	7f e3                	jg     1057db <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1057f8:	eb 38                	jmp    105832 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  1057fa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1057fe:	74 1f                	je     10581f <vprintfmt+0x218>
  105800:	83 fb 1f             	cmp    $0x1f,%ebx
  105803:	7e 05                	jle    10580a <vprintfmt+0x203>
  105805:	83 fb 7e             	cmp    $0x7e,%ebx
  105808:	7e 15                	jle    10581f <vprintfmt+0x218>
                    putch('?', putdat);
  10580a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10580d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105811:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  105818:	8b 45 08             	mov    0x8(%ebp),%eax
  10581b:	ff d0                	call   *%eax
  10581d:	eb 0f                	jmp    10582e <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  10581f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105822:	89 44 24 04          	mov    %eax,0x4(%esp)
  105826:	89 1c 24             	mov    %ebx,(%esp)
  105829:	8b 45 08             	mov    0x8(%ebp),%eax
  10582c:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10582e:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105832:	89 f0                	mov    %esi,%eax
  105834:	8d 70 01             	lea    0x1(%eax),%esi
  105837:	0f b6 00             	movzbl (%eax),%eax
  10583a:	0f be d8             	movsbl %al,%ebx
  10583d:	85 db                	test   %ebx,%ebx
  10583f:	74 10                	je     105851 <vprintfmt+0x24a>
  105841:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105845:	78 b3                	js     1057fa <vprintfmt+0x1f3>
  105847:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  10584b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10584f:	79 a9                	jns    1057fa <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105851:	eb 17                	jmp    10586a <vprintfmt+0x263>
                putch(' ', putdat);
  105853:	8b 45 0c             	mov    0xc(%ebp),%eax
  105856:	89 44 24 04          	mov    %eax,0x4(%esp)
  10585a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  105861:	8b 45 08             	mov    0x8(%ebp),%eax
  105864:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105866:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10586a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10586e:	7f e3                	jg     105853 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  105870:	e9 70 01 00 00       	jmp    1059e5 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105875:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105878:	89 44 24 04          	mov    %eax,0x4(%esp)
  10587c:	8d 45 14             	lea    0x14(%ebp),%eax
  10587f:	89 04 24             	mov    %eax,(%esp)
  105882:	e8 0b fd ff ff       	call   105592 <getint>
  105887:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10588a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  10588d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105890:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105893:	85 d2                	test   %edx,%edx
  105895:	79 26                	jns    1058bd <vprintfmt+0x2b6>
                putch('-', putdat);
  105897:	8b 45 0c             	mov    0xc(%ebp),%eax
  10589a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10589e:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  1058a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1058a8:	ff d0                	call   *%eax
                num = -(long long)num;
  1058aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1058b0:	f7 d8                	neg    %eax
  1058b2:	83 d2 00             	adc    $0x0,%edx
  1058b5:	f7 da                	neg    %edx
  1058b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058ba:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1058bd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1058c4:	e9 a8 00 00 00       	jmp    105971 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1058c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1058cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058d0:	8d 45 14             	lea    0x14(%ebp),%eax
  1058d3:	89 04 24             	mov    %eax,(%esp)
  1058d6:	e8 68 fc ff ff       	call   105543 <getuint>
  1058db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058de:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1058e1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1058e8:	e9 84 00 00 00       	jmp    105971 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1058ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1058f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058f4:	8d 45 14             	lea    0x14(%ebp),%eax
  1058f7:	89 04 24             	mov    %eax,(%esp)
  1058fa:	e8 44 fc ff ff       	call   105543 <getuint>
  1058ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105902:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105905:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  10590c:	eb 63                	jmp    105971 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  10590e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105911:	89 44 24 04          	mov    %eax,0x4(%esp)
  105915:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  10591c:	8b 45 08             	mov    0x8(%ebp),%eax
  10591f:	ff d0                	call   *%eax
            putch('x', putdat);
  105921:	8b 45 0c             	mov    0xc(%ebp),%eax
  105924:	89 44 24 04          	mov    %eax,0x4(%esp)
  105928:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  10592f:	8b 45 08             	mov    0x8(%ebp),%eax
  105932:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105934:	8b 45 14             	mov    0x14(%ebp),%eax
  105937:	8d 50 04             	lea    0x4(%eax),%edx
  10593a:	89 55 14             	mov    %edx,0x14(%ebp)
  10593d:	8b 00                	mov    (%eax),%eax
  10593f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105942:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105949:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105950:	eb 1f                	jmp    105971 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105952:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105955:	89 44 24 04          	mov    %eax,0x4(%esp)
  105959:	8d 45 14             	lea    0x14(%ebp),%eax
  10595c:	89 04 24             	mov    %eax,(%esp)
  10595f:	e8 df fb ff ff       	call   105543 <getuint>
  105964:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105967:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  10596a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105971:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105975:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105978:	89 54 24 18          	mov    %edx,0x18(%esp)
  10597c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10597f:	89 54 24 14          	mov    %edx,0x14(%esp)
  105983:	89 44 24 10          	mov    %eax,0x10(%esp)
  105987:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10598a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10598d:	89 44 24 08          	mov    %eax,0x8(%esp)
  105991:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105995:	8b 45 0c             	mov    0xc(%ebp),%eax
  105998:	89 44 24 04          	mov    %eax,0x4(%esp)
  10599c:	8b 45 08             	mov    0x8(%ebp),%eax
  10599f:	89 04 24             	mov    %eax,(%esp)
  1059a2:	e8 97 fa ff ff       	call   10543e <printnum>
            break;
  1059a7:	eb 3c                	jmp    1059e5 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1059a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059b0:	89 1c 24             	mov    %ebx,(%esp)
  1059b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1059b6:	ff d0                	call   *%eax
            break;
  1059b8:	eb 2b                	jmp    1059e5 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1059ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059c1:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1059c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1059cb:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  1059cd:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1059d1:	eb 04                	jmp    1059d7 <vprintfmt+0x3d0>
  1059d3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1059d7:	8b 45 10             	mov    0x10(%ebp),%eax
  1059da:	83 e8 01             	sub    $0x1,%eax
  1059dd:	0f b6 00             	movzbl (%eax),%eax
  1059e0:	3c 25                	cmp    $0x25,%al
  1059e2:	75 ef                	jne    1059d3 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  1059e4:	90                   	nop
        }
    }
  1059e5:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1059e6:	e9 3e fc ff ff       	jmp    105629 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  1059eb:	83 c4 40             	add    $0x40,%esp
  1059ee:	5b                   	pop    %ebx
  1059ef:	5e                   	pop    %esi
  1059f0:	5d                   	pop    %ebp
  1059f1:	c3                   	ret    

001059f2 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1059f2:	55                   	push   %ebp
  1059f3:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1059f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059f8:	8b 40 08             	mov    0x8(%eax),%eax
  1059fb:	8d 50 01             	lea    0x1(%eax),%edx
  1059fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a01:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105a04:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a07:	8b 10                	mov    (%eax),%edx
  105a09:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a0c:	8b 40 04             	mov    0x4(%eax),%eax
  105a0f:	39 c2                	cmp    %eax,%edx
  105a11:	73 12                	jae    105a25 <sprintputch+0x33>
        *b->buf ++ = ch;
  105a13:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a16:	8b 00                	mov    (%eax),%eax
  105a18:	8d 48 01             	lea    0x1(%eax),%ecx
  105a1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  105a1e:	89 0a                	mov    %ecx,(%edx)
  105a20:	8b 55 08             	mov    0x8(%ebp),%edx
  105a23:	88 10                	mov    %dl,(%eax)
    }
}
  105a25:	5d                   	pop    %ebp
  105a26:	c3                   	ret    

00105a27 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105a27:	55                   	push   %ebp
  105a28:	89 e5                	mov    %esp,%ebp
  105a2a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105a2d:	8d 45 14             	lea    0x14(%ebp),%eax
  105a30:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105a33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a36:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105a3a:	8b 45 10             	mov    0x10(%ebp),%eax
  105a3d:	89 44 24 08          	mov    %eax,0x8(%esp)
  105a41:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a44:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a48:	8b 45 08             	mov    0x8(%ebp),%eax
  105a4b:	89 04 24             	mov    %eax,(%esp)
  105a4e:	e8 08 00 00 00       	call   105a5b <vsnprintf>
  105a53:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105a59:	c9                   	leave  
  105a5a:	c3                   	ret    

00105a5b <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105a5b:	55                   	push   %ebp
  105a5c:	89 e5                	mov    %esp,%ebp
  105a5e:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105a61:	8b 45 08             	mov    0x8(%ebp),%eax
  105a64:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105a67:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a6a:	8d 50 ff             	lea    -0x1(%eax),%edx
  105a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  105a70:	01 d0                	add    %edx,%eax
  105a72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105a7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105a80:	74 0a                	je     105a8c <vsnprintf+0x31>
  105a82:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105a85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a88:	39 c2                	cmp    %eax,%edx
  105a8a:	76 07                	jbe    105a93 <vsnprintf+0x38>
        return -E_INVAL;
  105a8c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105a91:	eb 2a                	jmp    105abd <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105a93:	8b 45 14             	mov    0x14(%ebp),%eax
  105a96:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105a9a:	8b 45 10             	mov    0x10(%ebp),%eax
  105a9d:	89 44 24 08          	mov    %eax,0x8(%esp)
  105aa1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105aa4:	89 44 24 04          	mov    %eax,0x4(%esp)
  105aa8:	c7 04 24 f2 59 10 00 	movl   $0x1059f2,(%esp)
  105aaf:	e8 53 fb ff ff       	call   105607 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105ab4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105ab7:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105abd:	c9                   	leave  
  105abe:	c3                   	ret    

00105abf <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105abf:	55                   	push   %ebp
  105ac0:	89 e5                	mov    %esp,%ebp
  105ac2:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105ac5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105acc:	eb 04                	jmp    105ad2 <strlen+0x13>
        cnt ++;
  105ace:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  105ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  105ad5:	8d 50 01             	lea    0x1(%eax),%edx
  105ad8:	89 55 08             	mov    %edx,0x8(%ebp)
  105adb:	0f b6 00             	movzbl (%eax),%eax
  105ade:	84 c0                	test   %al,%al
  105ae0:	75 ec                	jne    105ace <strlen+0xf>
        cnt ++;
    }
    return cnt;
  105ae2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105ae5:	c9                   	leave  
  105ae6:	c3                   	ret    

00105ae7 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105ae7:	55                   	push   %ebp
  105ae8:	89 e5                	mov    %esp,%ebp
  105aea:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105aed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105af4:	eb 04                	jmp    105afa <strnlen+0x13>
        cnt ++;
  105af6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  105afa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105afd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105b00:	73 10                	jae    105b12 <strnlen+0x2b>
  105b02:	8b 45 08             	mov    0x8(%ebp),%eax
  105b05:	8d 50 01             	lea    0x1(%eax),%edx
  105b08:	89 55 08             	mov    %edx,0x8(%ebp)
  105b0b:	0f b6 00             	movzbl (%eax),%eax
  105b0e:	84 c0                	test   %al,%al
  105b10:	75 e4                	jne    105af6 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  105b12:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105b15:	c9                   	leave  
  105b16:	c3                   	ret    

00105b17 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105b17:	55                   	push   %ebp
  105b18:	89 e5                	mov    %esp,%ebp
  105b1a:	57                   	push   %edi
  105b1b:	56                   	push   %esi
  105b1c:	83 ec 20             	sub    $0x20,%esp
  105b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  105b22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105b25:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b28:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105b2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105b31:	89 d1                	mov    %edx,%ecx
  105b33:	89 c2                	mov    %eax,%edx
  105b35:	89 ce                	mov    %ecx,%esi
  105b37:	89 d7                	mov    %edx,%edi
  105b39:	ac                   	lods   %ds:(%esi),%al
  105b3a:	aa                   	stos   %al,%es:(%edi)
  105b3b:	84 c0                	test   %al,%al
  105b3d:	75 fa                	jne    105b39 <strcpy+0x22>
  105b3f:	89 fa                	mov    %edi,%edx
  105b41:	89 f1                	mov    %esi,%ecx
  105b43:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105b46:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105b49:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105b4f:	83 c4 20             	add    $0x20,%esp
  105b52:	5e                   	pop    %esi
  105b53:	5f                   	pop    %edi
  105b54:	5d                   	pop    %ebp
  105b55:	c3                   	ret    

00105b56 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105b56:	55                   	push   %ebp
  105b57:	89 e5                	mov    %esp,%ebp
  105b59:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  105b5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105b62:	eb 21                	jmp    105b85 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  105b64:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b67:	0f b6 10             	movzbl (%eax),%edx
  105b6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b6d:	88 10                	mov    %dl,(%eax)
  105b6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b72:	0f b6 00             	movzbl (%eax),%eax
  105b75:	84 c0                	test   %al,%al
  105b77:	74 04                	je     105b7d <strncpy+0x27>
            src ++;
  105b79:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105b7d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105b81:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  105b85:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105b89:	75 d9                	jne    105b64 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  105b8b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105b8e:	c9                   	leave  
  105b8f:	c3                   	ret    

00105b90 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105b90:	55                   	push   %ebp
  105b91:	89 e5                	mov    %esp,%ebp
  105b93:	57                   	push   %edi
  105b94:	56                   	push   %esi
  105b95:	83 ec 20             	sub    $0x20,%esp
  105b98:	8b 45 08             	mov    0x8(%ebp),%eax
  105b9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105b9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ba1:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  105ba4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105baa:	89 d1                	mov    %edx,%ecx
  105bac:	89 c2                	mov    %eax,%edx
  105bae:	89 ce                	mov    %ecx,%esi
  105bb0:	89 d7                	mov    %edx,%edi
  105bb2:	ac                   	lods   %ds:(%esi),%al
  105bb3:	ae                   	scas   %es:(%edi),%al
  105bb4:	75 08                	jne    105bbe <strcmp+0x2e>
  105bb6:	84 c0                	test   %al,%al
  105bb8:	75 f8                	jne    105bb2 <strcmp+0x22>
  105bba:	31 c0                	xor    %eax,%eax
  105bbc:	eb 04                	jmp    105bc2 <strcmp+0x32>
  105bbe:	19 c0                	sbb    %eax,%eax
  105bc0:	0c 01                	or     $0x1,%al
  105bc2:	89 fa                	mov    %edi,%edx
  105bc4:	89 f1                	mov    %esi,%ecx
  105bc6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105bc9:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105bcc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  105bcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105bd2:	83 c4 20             	add    $0x20,%esp
  105bd5:	5e                   	pop    %esi
  105bd6:	5f                   	pop    %edi
  105bd7:	5d                   	pop    %ebp
  105bd8:	c3                   	ret    

00105bd9 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105bd9:	55                   	push   %ebp
  105bda:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105bdc:	eb 0c                	jmp    105bea <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105bde:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105be2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105be6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105bea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105bee:	74 1a                	je     105c0a <strncmp+0x31>
  105bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  105bf3:	0f b6 00             	movzbl (%eax),%eax
  105bf6:	84 c0                	test   %al,%al
  105bf8:	74 10                	je     105c0a <strncmp+0x31>
  105bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  105bfd:	0f b6 10             	movzbl (%eax),%edx
  105c00:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c03:	0f b6 00             	movzbl (%eax),%eax
  105c06:	38 c2                	cmp    %al,%dl
  105c08:	74 d4                	je     105bde <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105c0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105c0e:	74 18                	je     105c28 <strncmp+0x4f>
  105c10:	8b 45 08             	mov    0x8(%ebp),%eax
  105c13:	0f b6 00             	movzbl (%eax),%eax
  105c16:	0f b6 d0             	movzbl %al,%edx
  105c19:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c1c:	0f b6 00             	movzbl (%eax),%eax
  105c1f:	0f b6 c0             	movzbl %al,%eax
  105c22:	29 c2                	sub    %eax,%edx
  105c24:	89 d0                	mov    %edx,%eax
  105c26:	eb 05                	jmp    105c2d <strncmp+0x54>
  105c28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105c2d:	5d                   	pop    %ebp
  105c2e:	c3                   	ret    

00105c2f <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105c2f:	55                   	push   %ebp
  105c30:	89 e5                	mov    %esp,%ebp
  105c32:	83 ec 04             	sub    $0x4,%esp
  105c35:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c38:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105c3b:	eb 14                	jmp    105c51 <strchr+0x22>
        if (*s == c) {
  105c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  105c40:	0f b6 00             	movzbl (%eax),%eax
  105c43:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105c46:	75 05                	jne    105c4d <strchr+0x1e>
            return (char *)s;
  105c48:	8b 45 08             	mov    0x8(%ebp),%eax
  105c4b:	eb 13                	jmp    105c60 <strchr+0x31>
        }
        s ++;
  105c4d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105c51:	8b 45 08             	mov    0x8(%ebp),%eax
  105c54:	0f b6 00             	movzbl (%eax),%eax
  105c57:	84 c0                	test   %al,%al
  105c59:	75 e2                	jne    105c3d <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105c5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105c60:	c9                   	leave  
  105c61:	c3                   	ret    

00105c62 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105c62:	55                   	push   %ebp
  105c63:	89 e5                	mov    %esp,%ebp
  105c65:	83 ec 04             	sub    $0x4,%esp
  105c68:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c6b:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105c6e:	eb 11                	jmp    105c81 <strfind+0x1f>
        if (*s == c) {
  105c70:	8b 45 08             	mov    0x8(%ebp),%eax
  105c73:	0f b6 00             	movzbl (%eax),%eax
  105c76:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105c79:	75 02                	jne    105c7d <strfind+0x1b>
            break;
  105c7b:	eb 0e                	jmp    105c8b <strfind+0x29>
        }
        s ++;
  105c7d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105c81:	8b 45 08             	mov    0x8(%ebp),%eax
  105c84:	0f b6 00             	movzbl (%eax),%eax
  105c87:	84 c0                	test   %al,%al
  105c89:	75 e5                	jne    105c70 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  105c8b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105c8e:	c9                   	leave  
  105c8f:	c3                   	ret    

00105c90 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105c90:	55                   	push   %ebp
  105c91:	89 e5                	mov    %esp,%ebp
  105c93:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105c96:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105c9d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105ca4:	eb 04                	jmp    105caa <strtol+0x1a>
        s ++;
  105ca6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105caa:	8b 45 08             	mov    0x8(%ebp),%eax
  105cad:	0f b6 00             	movzbl (%eax),%eax
  105cb0:	3c 20                	cmp    $0x20,%al
  105cb2:	74 f2                	je     105ca6 <strtol+0x16>
  105cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  105cb7:	0f b6 00             	movzbl (%eax),%eax
  105cba:	3c 09                	cmp    $0x9,%al
  105cbc:	74 e8                	je     105ca6 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  105cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  105cc1:	0f b6 00             	movzbl (%eax),%eax
  105cc4:	3c 2b                	cmp    $0x2b,%al
  105cc6:	75 06                	jne    105cce <strtol+0x3e>
        s ++;
  105cc8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105ccc:	eb 15                	jmp    105ce3 <strtol+0x53>
    }
    else if (*s == '-') {
  105cce:	8b 45 08             	mov    0x8(%ebp),%eax
  105cd1:	0f b6 00             	movzbl (%eax),%eax
  105cd4:	3c 2d                	cmp    $0x2d,%al
  105cd6:	75 0b                	jne    105ce3 <strtol+0x53>
        s ++, neg = 1;
  105cd8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105cdc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105ce3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105ce7:	74 06                	je     105cef <strtol+0x5f>
  105ce9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105ced:	75 24                	jne    105d13 <strtol+0x83>
  105cef:	8b 45 08             	mov    0x8(%ebp),%eax
  105cf2:	0f b6 00             	movzbl (%eax),%eax
  105cf5:	3c 30                	cmp    $0x30,%al
  105cf7:	75 1a                	jne    105d13 <strtol+0x83>
  105cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  105cfc:	83 c0 01             	add    $0x1,%eax
  105cff:	0f b6 00             	movzbl (%eax),%eax
  105d02:	3c 78                	cmp    $0x78,%al
  105d04:	75 0d                	jne    105d13 <strtol+0x83>
        s += 2, base = 16;
  105d06:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105d0a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105d11:	eb 2a                	jmp    105d3d <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  105d13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d17:	75 17                	jne    105d30 <strtol+0xa0>
  105d19:	8b 45 08             	mov    0x8(%ebp),%eax
  105d1c:	0f b6 00             	movzbl (%eax),%eax
  105d1f:	3c 30                	cmp    $0x30,%al
  105d21:	75 0d                	jne    105d30 <strtol+0xa0>
        s ++, base = 8;
  105d23:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105d27:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105d2e:	eb 0d                	jmp    105d3d <strtol+0xad>
    }
    else if (base == 0) {
  105d30:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d34:	75 07                	jne    105d3d <strtol+0xad>
        base = 10;
  105d36:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  105d40:	0f b6 00             	movzbl (%eax),%eax
  105d43:	3c 2f                	cmp    $0x2f,%al
  105d45:	7e 1b                	jle    105d62 <strtol+0xd2>
  105d47:	8b 45 08             	mov    0x8(%ebp),%eax
  105d4a:	0f b6 00             	movzbl (%eax),%eax
  105d4d:	3c 39                	cmp    $0x39,%al
  105d4f:	7f 11                	jg     105d62 <strtol+0xd2>
            dig = *s - '0';
  105d51:	8b 45 08             	mov    0x8(%ebp),%eax
  105d54:	0f b6 00             	movzbl (%eax),%eax
  105d57:	0f be c0             	movsbl %al,%eax
  105d5a:	83 e8 30             	sub    $0x30,%eax
  105d5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105d60:	eb 48                	jmp    105daa <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105d62:	8b 45 08             	mov    0x8(%ebp),%eax
  105d65:	0f b6 00             	movzbl (%eax),%eax
  105d68:	3c 60                	cmp    $0x60,%al
  105d6a:	7e 1b                	jle    105d87 <strtol+0xf7>
  105d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  105d6f:	0f b6 00             	movzbl (%eax),%eax
  105d72:	3c 7a                	cmp    $0x7a,%al
  105d74:	7f 11                	jg     105d87 <strtol+0xf7>
            dig = *s - 'a' + 10;
  105d76:	8b 45 08             	mov    0x8(%ebp),%eax
  105d79:	0f b6 00             	movzbl (%eax),%eax
  105d7c:	0f be c0             	movsbl %al,%eax
  105d7f:	83 e8 57             	sub    $0x57,%eax
  105d82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105d85:	eb 23                	jmp    105daa <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105d87:	8b 45 08             	mov    0x8(%ebp),%eax
  105d8a:	0f b6 00             	movzbl (%eax),%eax
  105d8d:	3c 40                	cmp    $0x40,%al
  105d8f:	7e 3d                	jle    105dce <strtol+0x13e>
  105d91:	8b 45 08             	mov    0x8(%ebp),%eax
  105d94:	0f b6 00             	movzbl (%eax),%eax
  105d97:	3c 5a                	cmp    $0x5a,%al
  105d99:	7f 33                	jg     105dce <strtol+0x13e>
            dig = *s - 'A' + 10;
  105d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  105d9e:	0f b6 00             	movzbl (%eax),%eax
  105da1:	0f be c0             	movsbl %al,%eax
  105da4:	83 e8 37             	sub    $0x37,%eax
  105da7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105dad:	3b 45 10             	cmp    0x10(%ebp),%eax
  105db0:	7c 02                	jl     105db4 <strtol+0x124>
            break;
  105db2:	eb 1a                	jmp    105dce <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  105db4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105db8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105dbb:	0f af 45 10          	imul   0x10(%ebp),%eax
  105dbf:	89 c2                	mov    %eax,%edx
  105dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105dc4:	01 d0                	add    %edx,%eax
  105dc6:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  105dc9:	e9 6f ff ff ff       	jmp    105d3d <strtol+0xad>

    if (endptr) {
  105dce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105dd2:	74 08                	je     105ddc <strtol+0x14c>
        *endptr = (char *) s;
  105dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  105dd7:	8b 55 08             	mov    0x8(%ebp),%edx
  105dda:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105ddc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105de0:	74 07                	je     105de9 <strtol+0x159>
  105de2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105de5:	f7 d8                	neg    %eax
  105de7:	eb 03                	jmp    105dec <strtol+0x15c>
  105de9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105dec:	c9                   	leave  
  105ded:	c3                   	ret    

00105dee <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105dee:	55                   	push   %ebp
  105def:	89 e5                	mov    %esp,%ebp
  105df1:	57                   	push   %edi
  105df2:	83 ec 24             	sub    $0x24,%esp
  105df5:	8b 45 0c             	mov    0xc(%ebp),%eax
  105df8:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105dfb:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  105dff:	8b 55 08             	mov    0x8(%ebp),%edx
  105e02:	89 55 f8             	mov    %edx,-0x8(%ebp)
  105e05:	88 45 f7             	mov    %al,-0x9(%ebp)
  105e08:	8b 45 10             	mov    0x10(%ebp),%eax
  105e0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105e0e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105e11:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105e15:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105e18:	89 d7                	mov    %edx,%edi
  105e1a:	f3 aa                	rep stos %al,%es:(%edi)
  105e1c:	89 fa                	mov    %edi,%edx
  105e1e:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105e21:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105e24:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105e27:	83 c4 24             	add    $0x24,%esp
  105e2a:	5f                   	pop    %edi
  105e2b:	5d                   	pop    %ebp
  105e2c:	c3                   	ret    

00105e2d <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105e2d:	55                   	push   %ebp
  105e2e:	89 e5                	mov    %esp,%ebp
  105e30:	57                   	push   %edi
  105e31:	56                   	push   %esi
  105e32:	53                   	push   %ebx
  105e33:	83 ec 30             	sub    $0x30,%esp
  105e36:	8b 45 08             	mov    0x8(%ebp),%eax
  105e39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105e42:	8b 45 10             	mov    0x10(%ebp),%eax
  105e45:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105e48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e4b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105e4e:	73 42                	jae    105e92 <memmove+0x65>
  105e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e53:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105e56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105e59:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105e5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e5f:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105e62:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105e65:	c1 e8 02             	shr    $0x2,%eax
  105e68:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105e6a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105e6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105e70:	89 d7                	mov    %edx,%edi
  105e72:	89 c6                	mov    %eax,%esi
  105e74:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105e76:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105e79:	83 e1 03             	and    $0x3,%ecx
  105e7c:	74 02                	je     105e80 <memmove+0x53>
  105e7e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105e80:	89 f0                	mov    %esi,%eax
  105e82:	89 fa                	mov    %edi,%edx
  105e84:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105e87:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105e8a:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105e8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105e90:	eb 36                	jmp    105ec8 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105e92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e95:	8d 50 ff             	lea    -0x1(%eax),%edx
  105e98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105e9b:	01 c2                	add    %eax,%edx
  105e9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105ea0:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105ea3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ea6:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  105ea9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105eac:	89 c1                	mov    %eax,%ecx
  105eae:	89 d8                	mov    %ebx,%eax
  105eb0:	89 d6                	mov    %edx,%esi
  105eb2:	89 c7                	mov    %eax,%edi
  105eb4:	fd                   	std    
  105eb5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105eb7:	fc                   	cld    
  105eb8:	89 f8                	mov    %edi,%eax
  105eba:	89 f2                	mov    %esi,%edx
  105ebc:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105ebf:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105ec2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  105ec5:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105ec8:	83 c4 30             	add    $0x30,%esp
  105ecb:	5b                   	pop    %ebx
  105ecc:	5e                   	pop    %esi
  105ecd:	5f                   	pop    %edi
  105ece:	5d                   	pop    %ebp
  105ecf:	c3                   	ret    

00105ed0 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105ed0:	55                   	push   %ebp
  105ed1:	89 e5                	mov    %esp,%ebp
  105ed3:	57                   	push   %edi
  105ed4:	56                   	push   %esi
  105ed5:	83 ec 20             	sub    $0x20,%esp
  105ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  105edb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105ede:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ee1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ee4:	8b 45 10             	mov    0x10(%ebp),%eax
  105ee7:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105eea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105eed:	c1 e8 02             	shr    $0x2,%eax
  105ef0:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105ef2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105ef5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ef8:	89 d7                	mov    %edx,%edi
  105efa:	89 c6                	mov    %eax,%esi
  105efc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105efe:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105f01:	83 e1 03             	and    $0x3,%ecx
  105f04:	74 02                	je     105f08 <memcpy+0x38>
  105f06:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105f08:	89 f0                	mov    %esi,%eax
  105f0a:	89 fa                	mov    %edi,%edx
  105f0c:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105f0f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105f12:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105f18:	83 c4 20             	add    $0x20,%esp
  105f1b:	5e                   	pop    %esi
  105f1c:	5f                   	pop    %edi
  105f1d:	5d                   	pop    %ebp
  105f1e:	c3                   	ret    

00105f1f <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105f1f:	55                   	push   %ebp
  105f20:	89 e5                	mov    %esp,%ebp
  105f22:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105f25:	8b 45 08             	mov    0x8(%ebp),%eax
  105f28:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f2e:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105f31:	eb 30                	jmp    105f63 <memcmp+0x44>
        if (*s1 != *s2) {
  105f33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105f36:	0f b6 10             	movzbl (%eax),%edx
  105f39:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105f3c:	0f b6 00             	movzbl (%eax),%eax
  105f3f:	38 c2                	cmp    %al,%dl
  105f41:	74 18                	je     105f5b <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105f43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105f46:	0f b6 00             	movzbl (%eax),%eax
  105f49:	0f b6 d0             	movzbl %al,%edx
  105f4c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105f4f:	0f b6 00             	movzbl (%eax),%eax
  105f52:	0f b6 c0             	movzbl %al,%eax
  105f55:	29 c2                	sub    %eax,%edx
  105f57:	89 d0                	mov    %edx,%eax
  105f59:	eb 1a                	jmp    105f75 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  105f5b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105f5f:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  105f63:	8b 45 10             	mov    0x10(%ebp),%eax
  105f66:	8d 50 ff             	lea    -0x1(%eax),%edx
  105f69:	89 55 10             	mov    %edx,0x10(%ebp)
  105f6c:	85 c0                	test   %eax,%eax
  105f6e:	75 c3                	jne    105f33 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  105f70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105f75:	c9                   	leave  
  105f76:	c3                   	ret    
