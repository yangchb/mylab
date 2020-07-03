
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 70 11 00 	lgdtl  0x117018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba 68 89 11 c0       	mov    $0xc0118968,%edx
c0100035:	b8 36 7a 11 c0       	mov    $0xc0117a36,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 36 7a 11 c0 	movl   $0xc0117a36,(%esp)
c0100051:	e8 98 5d 00 00       	call   c0105dee <memset>

    cons_init();                // init the console
c0100056:	e8 71 15 00 00       	call   c01015cc <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 80 5f 10 c0 	movl   $0xc0105f80,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 9c 5f 10 c0 	movl   $0xc0105f9c,(%esp)
c0100070:	e8 c7 02 00 00       	call   c010033c <cprintf>

    print_kerninfo();
c0100075:	e8 f6 07 00 00       	call   c0100870 <print_kerninfo>

    grade_backtrace();
c010007a:	e8 86 00 00 00       	call   c0100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 77 42 00 00       	call   c01042fb <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 ac 16 00 00       	call   c0101735 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 24 18 00 00       	call   c01018b2 <idt_init>

    clock_init();               // init clock interrupt
c010008e:	e8 ef 0c 00 00       	call   c0100d82 <clock_init>
    intr_enable();              // enable irq interrupt
c0100093:	e8 0b 16 00 00       	call   c01016a3 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c0100098:	eb fe                	jmp    c0100098 <kern_init+0x6e>

c010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c010009a:	55                   	push   %ebp
c010009b:	89 e5                	mov    %esp,%ebp
c010009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000a7:	00 
c01000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000af:	00 
c01000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000b7:	e8 f8 0b 00 00       	call   c0100cb4 <mon_backtrace>
}
c01000bc:	c9                   	leave  
c01000bd:	c3                   	ret    

c01000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000be:	55                   	push   %ebp
c01000bf:	89 e5                	mov    %esp,%ebp
c01000c1:	53                   	push   %ebx
c01000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000cb:	8d 55 08             	lea    0x8(%ebp),%edx
c01000ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000dd:	89 04 24             	mov    %eax,(%esp)
c01000e0:	e8 b5 ff ff ff       	call   c010009a <grade_backtrace2>
}
c01000e5:	83 c4 14             	add    $0x14,%esp
c01000e8:	5b                   	pop    %ebx
c01000e9:	5d                   	pop    %ebp
c01000ea:	c3                   	ret    

c01000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000eb:	55                   	push   %ebp
c01000ec:	89 e5                	mov    %esp,%ebp
c01000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01000f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01000fb:	89 04 24             	mov    %eax,(%esp)
c01000fe:	e8 bb ff ff ff       	call   c01000be <grade_backtrace1>
}
c0100103:	c9                   	leave  
c0100104:	c3                   	ret    

c0100105 <grade_backtrace>:

void
grade_backtrace(void) {
c0100105:	55                   	push   %ebp
c0100106:	89 e5                	mov    %esp,%ebp
c0100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010010b:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c0100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100117:	ff 
c0100118:	89 44 24 04          	mov    %eax,0x4(%esp)
c010011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100123:	e8 c3 ff ff ff       	call   c01000eb <grade_backtrace0>
}
c0100128:	c9                   	leave  
c0100129:	c3                   	ret    

c010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010012a:	55                   	push   %ebp
c010012b:	89 e5                	mov    %esp,%ebp
c010012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100140:	0f b7 c0             	movzwl %ax,%eax
c0100143:	83 e0 03             	and    $0x3,%eax
c0100146:	89 c2                	mov    %eax,%edx
c0100148:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010014d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100151:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100155:	c7 04 24 a1 5f 10 c0 	movl   $0xc0105fa1,(%esp)
c010015c:	e8 db 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100165:	0f b7 d0             	movzwl %ax,%edx
c0100168:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010016d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100171:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100175:	c7 04 24 af 5f 10 c0 	movl   $0xc0105faf,(%esp)
c010017c:	e8 bb 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100185:	0f b7 d0             	movzwl %ax,%edx
c0100188:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010018d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100195:	c7 04 24 bd 5f 10 c0 	movl   $0xc0105fbd,(%esp)
c010019c:	e8 9b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001a5:	0f b7 d0             	movzwl %ax,%edx
c01001a8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b5:	c7 04 24 cb 5f 10 c0 	movl   $0xc0105fcb,(%esp)
c01001bc:	e8 7b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001c5:	0f b7 d0             	movzwl %ax,%edx
c01001c8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d5:	c7 04 24 d9 5f 10 c0 	movl   $0xc0105fd9,(%esp)
c01001dc:	e8 5b 01 00 00       	call   c010033c <cprintf>
    round ++;
c01001e1:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001e6:	83 c0 01             	add    $0x1,%eax
c01001e9:	a3 40 7a 11 c0       	mov    %eax,0xc0117a40
}
c01001ee:	c9                   	leave  
c01001ef:	c3                   	ret    

c01001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001f0:	55                   	push   %ebp
c01001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001f3:	5d                   	pop    %ebp
c01001f4:	c3                   	ret    

c01001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001f5:	55                   	push   %ebp
c01001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001f8:	5d                   	pop    %ebp
c01001f9:	c3                   	ret    

c01001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001fa:	55                   	push   %ebp
c01001fb:	89 e5                	mov    %esp,%ebp
c01001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100200:	e8 25 ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100205:	c7 04 24 e8 5f 10 c0 	movl   $0xc0105fe8,(%esp)
c010020c:	e8 2b 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_user();
c0100211:	e8 da ff ff ff       	call   c01001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100216:	e8 0f ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010021b:	c7 04 24 08 60 10 c0 	movl   $0xc0106008,(%esp)
c0100222:	e8 15 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_kernel();
c0100227:	e8 c9 ff ff ff       	call   c01001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010022c:	e8 f9 fe ff ff       	call   c010012a <lab1_print_cur_status>
}
c0100231:	c9                   	leave  
c0100232:	c3                   	ret    

c0100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100233:	55                   	push   %ebp
c0100234:	89 e5                	mov    %esp,%ebp
c0100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010023d:	74 13                	je     c0100252 <readline+0x1f>
        cprintf("%s", prompt);
c010023f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100242:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100246:	c7 04 24 27 60 10 c0 	movl   $0xc0106027,(%esp)
c010024d:	e8 ea 00 00 00       	call   c010033c <cprintf>
    }
    int i = 0, c;
c0100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100259:	e8 66 01 00 00       	call   c01003c4 <getchar>
c010025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100265:	79 07                	jns    c010026e <readline+0x3b>
            return NULL;
c0100267:	b8 00 00 00 00       	mov    $0x0,%eax
c010026c:	eb 79                	jmp    c01002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100272:	7e 28                	jle    c010029c <readline+0x69>
c0100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010027b:	7f 1f                	jg     c010029c <readline+0x69>
            cputchar(c);
c010027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100280:	89 04 24             	mov    %eax,(%esp)
c0100283:	e8 da 00 00 00       	call   c0100362 <cputchar>
            buf[i ++] = c;
c0100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010028b:	8d 50 01             	lea    0x1(%eax),%edx
c010028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100294:	88 90 60 7a 11 c0    	mov    %dl,-0x3fee85a0(%eax)
c010029a:	eb 46                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c010029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002a0:	75 17                	jne    c01002b9 <readline+0x86>
c01002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002a6:	7e 11                	jle    c01002b9 <readline+0x86>
            cputchar(c);
c01002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ab:	89 04 24             	mov    %eax,(%esp)
c01002ae:	e8 af 00 00 00       	call   c0100362 <cputchar>
            i --;
c01002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002b7:	eb 29                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002bd:	74 06                	je     c01002c5 <readline+0x92>
c01002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002c3:	75 1d                	jne    c01002e2 <readline+0xaf>
            cputchar(c);
c01002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002c8:	89 04 24             	mov    %eax,(%esp)
c01002cb:	e8 92 00 00 00       	call   c0100362 <cputchar>
            buf[i] = '\0';
c01002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002d3:	05 60 7a 11 c0       	add    $0xc0117a60,%eax
c01002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002db:	b8 60 7a 11 c0       	mov    $0xc0117a60,%eax
c01002e0:	eb 05                	jmp    c01002e7 <readline+0xb4>
        }
    }
c01002e2:	e9 72 ff ff ff       	jmp    c0100259 <readline+0x26>
}
c01002e7:	c9                   	leave  
c01002e8:	c3                   	ret    

c01002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002e9:	55                   	push   %ebp
c01002ea:	89 e5                	mov    %esp,%ebp
c01002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01002f2:	89 04 24             	mov    %eax,(%esp)
c01002f5:	e8 fe 12 00 00       	call   c01015f8 <cons_putc>
    (*cnt) ++;
c01002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01002fd:	8b 00                	mov    (%eax),%eax
c01002ff:	8d 50 01             	lea    0x1(%eax),%edx
c0100302:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100305:	89 10                	mov    %edx,(%eax)
}
c0100307:	c9                   	leave  
c0100308:	c3                   	ret    

c0100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100309:	55                   	push   %ebp
c010030a:	89 e5                	mov    %esp,%ebp
c010030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100316:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010031d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100320:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100327:	89 44 24 04          	mov    %eax,0x4(%esp)
c010032b:	c7 04 24 e9 02 10 c0 	movl   $0xc01002e9,(%esp)
c0100332:	e8 d0 52 00 00       	call   c0105607 <vprintfmt>
    return cnt;
c0100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010033a:	c9                   	leave  
c010033b:	c3                   	ret    

c010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010033c:	55                   	push   %ebp
c010033d:	89 e5                	mov    %esp,%ebp
c010033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100342:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010034b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010034f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100352:	89 04 24             	mov    %eax,(%esp)
c0100355:	e8 af ff ff ff       	call   c0100309 <vcprintf>
c010035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100360:	c9                   	leave  
c0100361:	c3                   	ret    

c0100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100362:	55                   	push   %ebp
c0100363:	89 e5                	mov    %esp,%ebp
c0100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100368:	8b 45 08             	mov    0x8(%ebp),%eax
c010036b:	89 04 24             	mov    %eax,(%esp)
c010036e:	e8 85 12 00 00       	call   c01015f8 <cons_putc>
}
c0100373:	c9                   	leave  
c0100374:	c3                   	ret    

c0100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100375:	55                   	push   %ebp
c0100376:	89 e5                	mov    %esp,%ebp
c0100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100382:	eb 13                	jmp    c0100397 <cputs+0x22>
        cputch(c, &cnt);
c0100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
c010038b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010038f:	89 04 24             	mov    %eax,(%esp)
c0100392:	e8 52 ff ff ff       	call   c01002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c0100397:	8b 45 08             	mov    0x8(%ebp),%eax
c010039a:	8d 50 01             	lea    0x1(%eax),%edx
c010039d:	89 55 08             	mov    %edx,0x8(%ebp)
c01003a0:	0f b6 00             	movzbl (%eax),%eax
c01003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003aa:	75 d8                	jne    c0100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003ba:	e8 2a ff ff ff       	call   c01002e9 <cputch>
    return cnt;
c01003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003c2:	c9                   	leave  
c01003c3:	c3                   	ret    

c01003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003c4:	55                   	push   %ebp
c01003c5:	89 e5                	mov    %esp,%ebp
c01003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003ca:	e8 65 12 00 00       	call   c0101634 <cons_getc>
c01003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003d6:	74 f2                	je     c01003ca <getchar+0x6>
        /* do nothing */;
    return c;
c01003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003db:	c9                   	leave  
c01003dc:	c3                   	ret    

c01003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003dd:	55                   	push   %ebp
c01003de:	89 e5                	mov    %esp,%ebp
c01003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003e6:	8b 00                	mov    (%eax),%eax
c01003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01003ee:	8b 00                	mov    (%eax),%eax
c01003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01003fa:	e9 d2 00 00 00       	jmp    c01004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100405:	01 d0                	add    %edx,%eax
c0100407:	89 c2                	mov    %eax,%edx
c0100409:	c1 ea 1f             	shr    $0x1f,%edx
c010040c:	01 d0                	add    %edx,%eax
c010040e:	d1 f8                	sar    %eax
c0100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100419:	eb 04                	jmp    c010041f <stab_binsearch+0x42>
            m --;
c010041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100425:	7c 1f                	jl     c0100446 <stab_binsearch+0x69>
c0100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010042a:	89 d0                	mov    %edx,%eax
c010042c:	01 c0                	add    %eax,%eax
c010042e:	01 d0                	add    %edx,%eax
c0100430:	c1 e0 02             	shl    $0x2,%eax
c0100433:	89 c2                	mov    %eax,%edx
c0100435:	8b 45 08             	mov    0x8(%ebp),%eax
c0100438:	01 d0                	add    %edx,%eax
c010043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010043e:	0f b6 c0             	movzbl %al,%eax
c0100441:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100444:	75 d5                	jne    c010041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010044c:	7d 0b                	jge    c0100459 <stab_binsearch+0x7c>
            l = true_m + 1;
c010044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100451:	83 c0 01             	add    $0x1,%eax
c0100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100457:	eb 78                	jmp    c01004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100463:	89 d0                	mov    %edx,%eax
c0100465:	01 c0                	add    %eax,%eax
c0100467:	01 d0                	add    %edx,%eax
c0100469:	c1 e0 02             	shl    $0x2,%eax
c010046c:	89 c2                	mov    %eax,%edx
c010046e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100471:	01 d0                	add    %edx,%eax
c0100473:	8b 40 08             	mov    0x8(%eax),%eax
c0100476:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100479:	73 13                	jae    c010048e <stab_binsearch+0xb1>
            *region_left = m;
c010047b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100486:	83 c0 01             	add    $0x1,%eax
c0100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010048c:	eb 43                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100491:	89 d0                	mov    %edx,%eax
c0100493:	01 c0                	add    %eax,%eax
c0100495:	01 d0                	add    %edx,%eax
c0100497:	c1 e0 02             	shl    $0x2,%eax
c010049a:	89 c2                	mov    %eax,%edx
c010049c:	8b 45 08             	mov    0x8(%ebp),%eax
c010049f:	01 d0                	add    %edx,%eax
c01004a1:	8b 40 08             	mov    0x8(%eax),%eax
c01004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004a7:	76 16                	jbe    c01004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004af:	8b 45 10             	mov    0x10(%ebp),%eax
c01004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004b7:	83 e8 01             	sub    $0x1,%eax
c01004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004bd:	eb 12                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004c5:	89 10                	mov    %edx,(%eax)
            l = m;
c01004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004d7:	0f 8e 22 ff ff ff    	jle    c01003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004e1:	75 0f                	jne    c01004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004e6:	8b 00                	mov    (%eax),%eax
c01004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01004ee:	89 10                	mov    %edx,(%eax)
c01004f0:	eb 3f                	jmp    c0100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01004f2:	8b 45 10             	mov    0x10(%ebp),%eax
c01004f5:	8b 00                	mov    (%eax),%eax
c01004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01004fa:	eb 04                	jmp    c0100500 <stab_binsearch+0x123>
c01004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c0100500:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100503:	8b 00                	mov    (%eax),%eax
c0100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100508:	7d 1f                	jge    c0100529 <stab_binsearch+0x14c>
c010050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010050d:	89 d0                	mov    %edx,%eax
c010050f:	01 c0                	add    %eax,%eax
c0100511:	01 d0                	add    %edx,%eax
c0100513:	c1 e0 02             	shl    $0x2,%eax
c0100516:	89 c2                	mov    %eax,%edx
c0100518:	8b 45 08             	mov    0x8(%ebp),%eax
c010051b:	01 d0                	add    %edx,%eax
c010051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100521:	0f b6 c0             	movzbl %al,%eax
c0100524:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100527:	75 d3                	jne    c01004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100529:	8b 45 0c             	mov    0xc(%ebp),%eax
c010052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010052f:	89 10                	mov    %edx,(%eax)
    }
}
c0100531:	c9                   	leave  
c0100532:	c3                   	ret    

c0100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100533:	55                   	push   %ebp
c0100534:	89 e5                	mov    %esp,%ebp
c0100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100539:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053c:	c7 00 2c 60 10 c0    	movl   $0xc010602c,(%eax)
    info->eip_line = 0;
c0100542:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010054c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054f:	c7 40 08 2c 60 10 c0 	movl   $0xc010602c,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100556:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100560:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100563:	8b 55 08             	mov    0x8(%ebp),%edx
c0100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100569:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100573:	c7 45 f4 88 72 10 c0 	movl   $0xc0107288,-0xc(%ebp)
    stab_end = __STAB_END__;
c010057a:	c7 45 f0 9c 1e 11 c0 	movl   $0xc0111e9c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100581:	c7 45 ec 9d 1e 11 c0 	movl   $0xc0111e9d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100588:	c7 45 e8 d5 48 11 c0 	movl   $0xc01148d5,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100595:	76 0d                	jbe    c01005a4 <debuginfo_eip+0x71>
c0100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010059a:	83 e8 01             	sub    $0x1,%eax
c010059d:	0f b6 00             	movzbl (%eax),%eax
c01005a0:	84 c0                	test   %al,%al
c01005a2:	74 0a                	je     c01005ae <debuginfo_eip+0x7b>
        return -1;
c01005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005a9:	e9 c0 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005bb:	29 c2                	sub    %eax,%edx
c01005bd:	89 d0                	mov    %edx,%eax
c01005bf:	c1 f8 02             	sar    $0x2,%eax
c01005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005c8:	83 e8 01             	sub    $0x1,%eax
c01005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005dc:	00 
c01005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005ee:	89 04 24             	mov    %eax,(%esp)
c01005f1:	e8 e7 fd ff ff       	call   c01003dd <stab_binsearch>
    if (lfile == 0)
c01005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005f9:	85 c0                	test   %eax,%eax
c01005fb:	75 0a                	jne    c0100607 <debuginfo_eip+0xd4>
        return -1;
c01005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100602:	e9 67 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100613:	8b 45 08             	mov    0x8(%ebp),%eax
c0100616:	89 44 24 10          	mov    %eax,0x10(%esp)
c010061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100621:	00 
c0100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100625:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010062c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100633:	89 04 24             	mov    %eax,(%esp)
c0100636:	e8 a2 fd ff ff       	call   c01003dd <stab_binsearch>

    if (lfun <= rfun) {
c010063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100641:	39 c2                	cmp    %eax,%edx
c0100643:	7f 7c                	jg     c01006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100648:	89 c2                	mov    %eax,%edx
c010064a:	89 d0                	mov    %edx,%eax
c010064c:	01 c0                	add    %eax,%eax
c010064e:	01 d0                	add    %edx,%eax
c0100650:	c1 e0 02             	shl    $0x2,%eax
c0100653:	89 c2                	mov    %eax,%edx
c0100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100658:	01 d0                	add    %edx,%eax
c010065a:	8b 10                	mov    (%eax),%edx
c010065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100662:	29 c1                	sub    %eax,%ecx
c0100664:	89 c8                	mov    %ecx,%eax
c0100666:	39 c2                	cmp    %eax,%edx
c0100668:	73 22                	jae    c010068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010066d:	89 c2                	mov    %eax,%edx
c010066f:	89 d0                	mov    %edx,%eax
c0100671:	01 c0                	add    %eax,%eax
c0100673:	01 d0                	add    %edx,%eax
c0100675:	c1 e0 02             	shl    $0x2,%eax
c0100678:	89 c2                	mov    %eax,%edx
c010067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010067d:	01 d0                	add    %edx,%eax
c010067f:	8b 10                	mov    (%eax),%edx
c0100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100684:	01 c2                	add    %eax,%edx
c0100686:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010068f:	89 c2                	mov    %eax,%edx
c0100691:	89 d0                	mov    %edx,%eax
c0100693:	01 c0                	add    %eax,%eax
c0100695:	01 d0                	add    %edx,%eax
c0100697:	c1 e0 02             	shl    $0x2,%eax
c010069a:	89 c2                	mov    %eax,%edx
c010069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010069f:	01 d0                	add    %edx,%eax
c01006a1:	8b 50 08             	mov    0x8(%eax),%edx
c01006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006ad:	8b 40 10             	mov    0x10(%eax),%eax
c01006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006bf:	eb 15                	jmp    c01006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c4:	8b 55 08             	mov    0x8(%ebp),%edx
c01006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d9:	8b 40 08             	mov    0x8(%eax),%eax
c01006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006e3:	00 
c01006e4:	89 04 24             	mov    %eax,(%esp)
c01006e7:	e8 76 55 00 00       	call   c0105c62 <strfind>
c01006ec:	89 c2                	mov    %eax,%edx
c01006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f1:	8b 40 08             	mov    0x8(%eax),%eax
c01006f4:	29 c2                	sub    %eax,%edx
c01006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01006fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c010070a:	00 
c010070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010070e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100715:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010071c:	89 04 24             	mov    %eax,(%esp)
c010071f:	e8 b9 fc ff ff       	call   c01003dd <stab_binsearch>
    if (lline <= rline) {
c0100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010072a:	39 c2                	cmp    %eax,%edx
c010072c:	7f 24                	jg     c0100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100731:	89 c2                	mov    %eax,%edx
c0100733:	89 d0                	mov    %edx,%eax
c0100735:	01 c0                	add    %eax,%eax
c0100737:	01 d0                	add    %edx,%eax
c0100739:	c1 e0 02             	shl    $0x2,%eax
c010073c:	89 c2                	mov    %eax,%edx
c010073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100741:	01 d0                	add    %edx,%eax
c0100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100747:	0f b7 d0             	movzwl %ax,%edx
c010074a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100750:	eb 13                	jmp    c0100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100757:	e9 12 01 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010075f:	83 e8 01             	sub    $0x1,%eax
c0100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010076b:	39 c2                	cmp    %eax,%edx
c010076d:	7c 56                	jl     c01007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100772:	89 c2                	mov    %eax,%edx
c0100774:	89 d0                	mov    %edx,%eax
c0100776:	01 c0                	add    %eax,%eax
c0100778:	01 d0                	add    %edx,%eax
c010077a:	c1 e0 02             	shl    $0x2,%eax
c010077d:	89 c2                	mov    %eax,%edx
c010077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100782:	01 d0                	add    %edx,%eax
c0100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100788:	3c 84                	cmp    $0x84,%al
c010078a:	74 39                	je     c01007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010078f:	89 c2                	mov    %eax,%edx
c0100791:	89 d0                	mov    %edx,%eax
c0100793:	01 c0                	add    %eax,%eax
c0100795:	01 d0                	add    %edx,%eax
c0100797:	c1 e0 02             	shl    $0x2,%eax
c010079a:	89 c2                	mov    %eax,%edx
c010079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010079f:	01 d0                	add    %edx,%eax
c01007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007a5:	3c 64                	cmp    $0x64,%al
c01007a7:	75 b3                	jne    c010075c <debuginfo_eip+0x229>
c01007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007ac:	89 c2                	mov    %eax,%edx
c01007ae:	89 d0                	mov    %edx,%eax
c01007b0:	01 c0                	add    %eax,%eax
c01007b2:	01 d0                	add    %edx,%eax
c01007b4:	c1 e0 02             	shl    $0x2,%eax
c01007b7:	89 c2                	mov    %eax,%edx
c01007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007bc:	01 d0                	add    %edx,%eax
c01007be:	8b 40 08             	mov    0x8(%eax),%eax
c01007c1:	85 c0                	test   %eax,%eax
c01007c3:	74 97                	je     c010075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007cb:	39 c2                	cmp    %eax,%edx
c01007cd:	7c 46                	jl     c0100815 <debuginfo_eip+0x2e2>
c01007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007d2:	89 c2                	mov    %eax,%edx
c01007d4:	89 d0                	mov    %edx,%eax
c01007d6:	01 c0                	add    %eax,%eax
c01007d8:	01 d0                	add    %edx,%eax
c01007da:	c1 e0 02             	shl    $0x2,%eax
c01007dd:	89 c2                	mov    %eax,%edx
c01007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007e2:	01 d0                	add    %edx,%eax
c01007e4:	8b 10                	mov    (%eax),%edx
c01007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007ec:	29 c1                	sub    %eax,%ecx
c01007ee:	89 c8                	mov    %ecx,%eax
c01007f0:	39 c2                	cmp    %eax,%edx
c01007f2:	73 21                	jae    c0100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007f7:	89 c2                	mov    %eax,%edx
c01007f9:	89 d0                	mov    %edx,%eax
c01007fb:	01 c0                	add    %eax,%eax
c01007fd:	01 d0                	add    %edx,%eax
c01007ff:	c1 e0 02             	shl    $0x2,%eax
c0100802:	89 c2                	mov    %eax,%edx
c0100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100807:	01 d0                	add    %edx,%eax
c0100809:	8b 10                	mov    (%eax),%edx
c010080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010080e:	01 c2                	add    %eax,%edx
c0100810:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010081b:	39 c2                	cmp    %eax,%edx
c010081d:	7d 4a                	jge    c0100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100822:	83 c0 01             	add    $0x1,%eax
c0100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100828:	eb 18                	jmp    c0100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c010082a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010082d:	8b 40 14             	mov    0x14(%eax),%eax
c0100830:	8d 50 01             	lea    0x1(%eax),%edx
c0100833:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010083c:	83 c0 01             	add    $0x1,%eax
c010083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100848:	39 c2                	cmp    %eax,%edx
c010084a:	7d 1d                	jge    c0100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084f:	89 c2                	mov    %eax,%edx
c0100851:	89 d0                	mov    %edx,%eax
c0100853:	01 c0                	add    %eax,%eax
c0100855:	01 d0                	add    %edx,%eax
c0100857:	c1 e0 02             	shl    $0x2,%eax
c010085a:	89 c2                	mov    %eax,%edx
c010085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010085f:	01 d0                	add    %edx,%eax
c0100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100865:	3c a0                	cmp    $0xa0,%al
c0100867:	74 c1                	je     c010082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010086e:	c9                   	leave  
c010086f:	c3                   	ret    

c0100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100870:	55                   	push   %ebp
c0100871:	89 e5                	mov    %esp,%ebp
c0100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100876:	c7 04 24 36 60 10 c0 	movl   $0xc0106036,(%esp)
c010087d:	e8 ba fa ff ff       	call   c010033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100882:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100889:	c0 
c010088a:	c7 04 24 4f 60 10 c0 	movl   $0xc010604f,(%esp)
c0100891:	e8 a6 fa ff ff       	call   c010033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100896:	c7 44 24 04 77 5f 10 	movl   $0xc0105f77,0x4(%esp)
c010089d:	c0 
c010089e:	c7 04 24 67 60 10 c0 	movl   $0xc0106067,(%esp)
c01008a5:	e8 92 fa ff ff       	call   c010033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008aa:	c7 44 24 04 36 7a 11 	movl   $0xc0117a36,0x4(%esp)
c01008b1:	c0 
c01008b2:	c7 04 24 7f 60 10 c0 	movl   $0xc010607f,(%esp)
c01008b9:	e8 7e fa ff ff       	call   c010033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008be:	c7 44 24 04 68 89 11 	movl   $0xc0118968,0x4(%esp)
c01008c5:	c0 
c01008c6:	c7 04 24 97 60 10 c0 	movl   $0xc0106097,(%esp)
c01008cd:	e8 6a fa ff ff       	call   c010033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008d2:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c01008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008dd:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008e2:	29 c2                	sub    %eax,%edx
c01008e4:	89 d0                	mov    %edx,%eax
c01008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ec:	85 c0                	test   %eax,%eax
c01008ee:	0f 48 c2             	cmovs  %edx,%eax
c01008f1:	c1 f8 0a             	sar    $0xa,%eax
c01008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01008f8:	c7 04 24 b0 60 10 c0 	movl   $0xc01060b0,(%esp)
c01008ff:	e8 38 fa ff ff       	call   c010033c <cprintf>
}
c0100904:	c9                   	leave  
c0100905:	c3                   	ret    

c0100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100906:	55                   	push   %ebp
c0100907:	89 e5                	mov    %esp,%ebp
c0100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100912:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100916:	8b 45 08             	mov    0x8(%ebp),%eax
c0100919:	89 04 24             	mov    %eax,(%esp)
c010091c:	e8 12 fc ff ff       	call   c0100533 <debuginfo_eip>
c0100921:	85 c0                	test   %eax,%eax
c0100923:	74 15                	je     c010093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100925:	8b 45 08             	mov    0x8(%ebp),%eax
c0100928:	89 44 24 04          	mov    %eax,0x4(%esp)
c010092c:	c7 04 24 da 60 10 c0 	movl   $0xc01060da,(%esp)
c0100933:	e8 04 fa ff ff       	call   c010033c <cprintf>
c0100938:	eb 6d                	jmp    c01009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100941:	eb 1c                	jmp    c010095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100949:	01 d0                	add    %edx,%eax
c010094b:	0f b6 00             	movzbl (%eax),%eax
c010094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100957:	01 ca                	add    %ecx,%edx
c0100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100965:	7f dc                	jg     c0100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c010096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100970:	01 d0                	add    %edx,%eax
c0100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100978:	8b 55 08             	mov    0x8(%ebp),%edx
c010097b:	89 d1                	mov    %edx,%ecx
c010097d:	29 c1                	sub    %eax,%ecx
c010097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100993:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100997:	89 44 24 04          	mov    %eax,0x4(%esp)
c010099b:	c7 04 24 f6 60 10 c0 	movl   $0xc01060f6,(%esp)
c01009a2:	e8 95 f9 ff ff       	call   c010033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009a7:	c9                   	leave  
c01009a8:	c3                   	ret    

c01009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009a9:	55                   	push   %ebp
c01009aa:	89 e5                	mov    %esp,%ebp
c01009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009af:	8b 45 04             	mov    0x4(%ebp),%eax
c01009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009b8:	c9                   	leave  
c01009b9:	c3                   	ret    

c01009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009ba:	55                   	push   %ebp
c01009bb:	89 e5                	mov    %esp,%ebp
c01009bd:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009c0:	89 e8                	mov    %ebp,%eax
c01009c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c01009c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
	uint32_t ebp = read_ebp(), eip = read_eip();
c01009c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01009cb:	e8 d9 ff ff ff       	call   c01009a9 <read_eip>
c01009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i, j;
	for(i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++)
c01009d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009da:	e9 88 00 00 00       	jmp    c0100a67 <print_stackframe+0xad>
	{
	cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c01009df:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009e2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009e9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009ed:	c7 04 24 08 61 10 c0 	movl   $0xc0106108,(%esp)
c01009f4:	e8 43 f9 ff ff       	call   c010033c <cprintf>
	uint32_t *args = (uint32_t *)ebp + 2;
c01009f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009fc:	83 c0 08             	add    $0x8,%eax
c01009ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	for (j = 0; j < 4; j++) {
c0100a02:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a09:	eb 25                	jmp    c0100a30 <print_stackframe+0x76>
            cprintf("0x%08x ", args[j]);
c0100a0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a0e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a18:	01 d0                	add    %edx,%eax
c0100a1a:	8b 00                	mov    (%eax),%eax
c0100a1c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a20:	c7 04 24 24 61 10 c0 	movl   $0xc0106124,(%esp)
c0100a27:	e8 10 f9 ff ff       	call   c010033c <cprintf>
	int i, j;
	for(i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++)
	{
	cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
	uint32_t *args = (uint32_t *)ebp + 2;
	for (j = 0; j < 4; j++) {
c0100a2c:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a30:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a34:	7e d5                	jle    c0100a0b <print_stackframe+0x51>
            cprintf("0x%08x ", args[j]);
        }
        cprintf("\n");
c0100a36:	c7 04 24 2c 61 10 c0 	movl   $0xc010612c,(%esp)
c0100a3d:	e8 fa f8 ff ff       	call   c010033c <cprintf>
        print_debuginfo(eip - 1);
c0100a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a45:	83 e8 01             	sub    $0x1,%eax
c0100a48:	89 04 24             	mov    %eax,(%esp)
c0100a4b:	e8 b6 fe ff ff       	call   c0100906 <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
c0100a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a53:	83 c0 04             	add    $0x4,%eax
c0100a56:	8b 00                	mov    (%eax),%eax
c0100a58:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a5e:	8b 00                	mov    (%eax),%eax
c0100a60:	89 45 f4             	mov    %eax,-0xc(%ebp)
 * */
void
print_stackframe(void) {
	uint32_t ebp = read_ebp(), eip = read_eip();
	int i, j;
	for(i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++)
c0100a63:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a6b:	74 0a                	je     c0100a77 <print_stackframe+0xbd>
c0100a6d:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a71:	0f 8e 68 ff ff ff    	jle    c01009df <print_stackframe+0x25>
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
c0100a77:	c9                   	leave  
c0100a78:	c3                   	ret    

c0100a79 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a79:	55                   	push   %ebp
c0100a7a:	89 e5                	mov    %esp,%ebp
c0100a7c:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a86:	eb 0c                	jmp    c0100a94 <parse+0x1b>
            *buf ++ = '\0';
c0100a88:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a8b:	8d 50 01             	lea    0x1(%eax),%edx
c0100a8e:	89 55 08             	mov    %edx,0x8(%ebp)
c0100a91:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a94:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a97:	0f b6 00             	movzbl (%eax),%eax
c0100a9a:	84 c0                	test   %al,%al
c0100a9c:	74 1d                	je     c0100abb <parse+0x42>
c0100a9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa1:	0f b6 00             	movzbl (%eax),%eax
c0100aa4:	0f be c0             	movsbl %al,%eax
c0100aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100aab:	c7 04 24 b0 61 10 c0 	movl   $0xc01061b0,(%esp)
c0100ab2:	e8 78 51 00 00       	call   c0105c2f <strchr>
c0100ab7:	85 c0                	test   %eax,%eax
c0100ab9:	75 cd                	jne    c0100a88 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100abb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100abe:	0f b6 00             	movzbl (%eax),%eax
c0100ac1:	84 c0                	test   %al,%al
c0100ac3:	75 02                	jne    c0100ac7 <parse+0x4e>
            break;
c0100ac5:	eb 67                	jmp    c0100b2e <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ac7:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100acb:	75 14                	jne    c0100ae1 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100acd:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100ad4:	00 
c0100ad5:	c7 04 24 b5 61 10 c0 	movl   $0xc01061b5,(%esp)
c0100adc:	e8 5b f8 ff ff       	call   c010033c <cprintf>
        }
        argv[argc ++] = buf;
c0100ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ae4:	8d 50 01             	lea    0x1(%eax),%edx
c0100ae7:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100aea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100af1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100af4:	01 c2                	add    %eax,%edx
c0100af6:	8b 45 08             	mov    0x8(%ebp),%eax
c0100af9:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100afb:	eb 04                	jmp    c0100b01 <parse+0x88>
            buf ++;
c0100afd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b01:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b04:	0f b6 00             	movzbl (%eax),%eax
c0100b07:	84 c0                	test   %al,%al
c0100b09:	74 1d                	je     c0100b28 <parse+0xaf>
c0100b0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b0e:	0f b6 00             	movzbl (%eax),%eax
c0100b11:	0f be c0             	movsbl %al,%eax
c0100b14:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b18:	c7 04 24 b0 61 10 c0 	movl   $0xc01061b0,(%esp)
c0100b1f:	e8 0b 51 00 00       	call   c0105c2f <strchr>
c0100b24:	85 c0                	test   %eax,%eax
c0100b26:	74 d5                	je     c0100afd <parse+0x84>
            buf ++;
        }
    }
c0100b28:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b29:	e9 66 ff ff ff       	jmp    c0100a94 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b31:	c9                   	leave  
c0100b32:	c3                   	ret    

c0100b33 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b33:	55                   	push   %ebp
c0100b34:	89 e5                	mov    %esp,%ebp
c0100b36:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b39:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b3c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b40:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b43:	89 04 24             	mov    %eax,(%esp)
c0100b46:	e8 2e ff ff ff       	call   c0100a79 <parse>
c0100b4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b52:	75 0a                	jne    c0100b5e <runcmd+0x2b>
        return 0;
c0100b54:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b59:	e9 85 00 00 00       	jmp    c0100be3 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b65:	eb 5c                	jmp    c0100bc3 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b67:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b6d:	89 d0                	mov    %edx,%eax
c0100b6f:	01 c0                	add    %eax,%eax
c0100b71:	01 d0                	add    %edx,%eax
c0100b73:	c1 e0 02             	shl    $0x2,%eax
c0100b76:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100b7b:	8b 00                	mov    (%eax),%eax
c0100b7d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b81:	89 04 24             	mov    %eax,(%esp)
c0100b84:	e8 07 50 00 00       	call   c0105b90 <strcmp>
c0100b89:	85 c0                	test   %eax,%eax
c0100b8b:	75 32                	jne    c0100bbf <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b90:	89 d0                	mov    %edx,%eax
c0100b92:	01 c0                	add    %eax,%eax
c0100b94:	01 d0                	add    %edx,%eax
c0100b96:	c1 e0 02             	shl    $0x2,%eax
c0100b99:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100b9e:	8b 40 08             	mov    0x8(%eax),%eax
c0100ba1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100ba4:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100ba7:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100baa:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bae:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bb1:	83 c2 04             	add    $0x4,%edx
c0100bb4:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bb8:	89 0c 24             	mov    %ecx,(%esp)
c0100bbb:	ff d0                	call   *%eax
c0100bbd:	eb 24                	jmp    c0100be3 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bbf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bc6:	83 f8 02             	cmp    $0x2,%eax
c0100bc9:	76 9c                	jbe    c0100b67 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bcb:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bce:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bd2:	c7 04 24 d3 61 10 c0 	movl   $0xc01061d3,(%esp)
c0100bd9:	e8 5e f7 ff ff       	call   c010033c <cprintf>
    return 0;
c0100bde:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100be3:	c9                   	leave  
c0100be4:	c3                   	ret    

c0100be5 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100be5:	55                   	push   %ebp
c0100be6:	89 e5                	mov    %esp,%ebp
c0100be8:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100beb:	c7 04 24 ec 61 10 c0 	movl   $0xc01061ec,(%esp)
c0100bf2:	e8 45 f7 ff ff       	call   c010033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100bf7:	c7 04 24 14 62 10 c0 	movl   $0xc0106214,(%esp)
c0100bfe:	e8 39 f7 ff ff       	call   c010033c <cprintf>

    if (tf != NULL) {
c0100c03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c07:	74 0b                	je     c0100c14 <kmonitor+0x2f>
        print_trapframe(tf);
c0100c09:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c0c:	89 04 24             	mov    %eax,(%esp)
c0100c0f:	e8 5c 0e 00 00       	call   c0101a70 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c14:	c7 04 24 39 62 10 c0 	movl   $0xc0106239,(%esp)
c0100c1b:	e8 13 f6 ff ff       	call   c0100233 <readline>
c0100c20:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c27:	74 18                	je     c0100c41 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c29:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c2c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c33:	89 04 24             	mov    %eax,(%esp)
c0100c36:	e8 f8 fe ff ff       	call   c0100b33 <runcmd>
c0100c3b:	85 c0                	test   %eax,%eax
c0100c3d:	79 02                	jns    c0100c41 <kmonitor+0x5c>
                break;
c0100c3f:	eb 02                	jmp    c0100c43 <kmonitor+0x5e>
            }
        }
    }
c0100c41:	eb d1                	jmp    c0100c14 <kmonitor+0x2f>
}
c0100c43:	c9                   	leave  
c0100c44:	c3                   	ret    

c0100c45 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c45:	55                   	push   %ebp
c0100c46:	89 e5                	mov    %esp,%ebp
c0100c48:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c52:	eb 3f                	jmp    c0100c93 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c54:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c57:	89 d0                	mov    %edx,%eax
c0100c59:	01 c0                	add    %eax,%eax
c0100c5b:	01 d0                	add    %edx,%eax
c0100c5d:	c1 e0 02             	shl    $0x2,%eax
c0100c60:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c65:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c68:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c6b:	89 d0                	mov    %edx,%eax
c0100c6d:	01 c0                	add    %eax,%eax
c0100c6f:	01 d0                	add    %edx,%eax
c0100c71:	c1 e0 02             	shl    $0x2,%eax
c0100c74:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c79:	8b 00                	mov    (%eax),%eax
c0100c7b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c7f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c83:	c7 04 24 3d 62 10 c0 	movl   $0xc010623d,(%esp)
c0100c8a:	e8 ad f6 ff ff       	call   c010033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c8f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c96:	83 f8 02             	cmp    $0x2,%eax
c0100c99:	76 b9                	jbe    c0100c54 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100c9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ca0:	c9                   	leave  
c0100ca1:	c3                   	ret    

c0100ca2 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100ca2:	55                   	push   %ebp
c0100ca3:	89 e5                	mov    %esp,%ebp
c0100ca5:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100ca8:	e8 c3 fb ff ff       	call   c0100870 <print_kerninfo>
    return 0;
c0100cad:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cb2:	c9                   	leave  
c0100cb3:	c3                   	ret    

c0100cb4 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cb4:	55                   	push   %ebp
c0100cb5:	89 e5                	mov    %esp,%ebp
c0100cb7:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cba:	e8 fb fc ff ff       	call   c01009ba <print_stackframe>
    return 0;
c0100cbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cc4:	c9                   	leave  
c0100cc5:	c3                   	ret    

c0100cc6 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cc6:	55                   	push   %ebp
c0100cc7:	89 e5                	mov    %esp,%ebp
c0100cc9:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100ccc:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
c0100cd1:	85 c0                	test   %eax,%eax
c0100cd3:	74 02                	je     c0100cd7 <__panic+0x11>
        goto panic_dead;
c0100cd5:	eb 48                	jmp    c0100d1f <__panic+0x59>
    }
    is_panic = 1;
c0100cd7:	c7 05 60 7e 11 c0 01 	movl   $0x1,0xc0117e60
c0100cde:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100ce1:	8d 45 14             	lea    0x14(%ebp),%eax
c0100ce4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100cea:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100cee:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cf1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cf5:	c7 04 24 46 62 10 c0 	movl   $0xc0106246,(%esp)
c0100cfc:	e8 3b f6 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d04:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d08:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d0b:	89 04 24             	mov    %eax,(%esp)
c0100d0e:	e8 f6 f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d13:	c7 04 24 62 62 10 c0 	movl   $0xc0106262,(%esp)
c0100d1a:	e8 1d f6 ff ff       	call   c010033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d1f:	e8 85 09 00 00       	call   c01016a9 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d24:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d2b:	e8 b5 fe ff ff       	call   c0100be5 <kmonitor>
    }
c0100d30:	eb f2                	jmp    c0100d24 <__panic+0x5e>

c0100d32 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d32:	55                   	push   %ebp
c0100d33:	89 e5                	mov    %esp,%ebp
c0100d35:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d38:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d3e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d41:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d45:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d48:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d4c:	c7 04 24 64 62 10 c0 	movl   $0xc0106264,(%esp)
c0100d53:	e8 e4 f5 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d5b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d5f:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d62:	89 04 24             	mov    %eax,(%esp)
c0100d65:	e8 9f f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d6a:	c7 04 24 62 62 10 c0 	movl   $0xc0106262,(%esp)
c0100d71:	e8 c6 f5 ff ff       	call   c010033c <cprintf>
    va_end(ap);
}
c0100d76:	c9                   	leave  
c0100d77:	c3                   	ret    

c0100d78 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d78:	55                   	push   %ebp
c0100d79:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d7b:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
}
c0100d80:	5d                   	pop    %ebp
c0100d81:	c3                   	ret    

c0100d82 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d82:	55                   	push   %ebp
c0100d83:	89 e5                	mov    %esp,%ebp
c0100d85:	83 ec 28             	sub    $0x28,%esp
c0100d88:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d8e:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d92:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100d96:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100d9a:	ee                   	out    %al,(%dx)
c0100d9b:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100da1:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100da5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100da9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dad:	ee                   	out    %al,(%dx)
c0100dae:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100db4:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100db8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dbc:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dc0:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dc1:	c7 05 4c 89 11 c0 00 	movl   $0x0,0xc011894c
c0100dc8:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100dcb:	c7 04 24 82 62 10 c0 	movl   $0xc0106282,(%esp)
c0100dd2:	e8 65 f5 ff ff       	call   c010033c <cprintf>
    pic_enable(IRQ_TIMER);
c0100dd7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100dde:	e8 24 09 00 00       	call   c0101707 <pic_enable>
}
c0100de3:	c9                   	leave  
c0100de4:	c3                   	ret    

c0100de5 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100de5:	55                   	push   %ebp
c0100de6:	89 e5                	mov    %esp,%ebp
c0100de8:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100deb:	9c                   	pushf  
c0100dec:	58                   	pop    %eax
c0100ded:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100df3:	25 00 02 00 00       	and    $0x200,%eax
c0100df8:	85 c0                	test   %eax,%eax
c0100dfa:	74 0c                	je     c0100e08 <__intr_save+0x23>
        intr_disable();
c0100dfc:	e8 a8 08 00 00       	call   c01016a9 <intr_disable>
        return 1;
c0100e01:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e06:	eb 05                	jmp    c0100e0d <__intr_save+0x28>
    }
    return 0;
c0100e08:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e0d:	c9                   	leave  
c0100e0e:	c3                   	ret    

c0100e0f <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e0f:	55                   	push   %ebp
c0100e10:	89 e5                	mov    %esp,%ebp
c0100e12:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e19:	74 05                	je     c0100e20 <__intr_restore+0x11>
        intr_enable();
c0100e1b:	e8 83 08 00 00       	call   c01016a3 <intr_enable>
    }
}
c0100e20:	c9                   	leave  
c0100e21:	c3                   	ret    

c0100e22 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e22:	55                   	push   %ebp
c0100e23:	89 e5                	mov    %esp,%ebp
c0100e25:	83 ec 10             	sub    $0x10,%esp
c0100e28:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e2e:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e32:	89 c2                	mov    %eax,%edx
c0100e34:	ec                   	in     (%dx),%al
c0100e35:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e38:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e3e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e42:	89 c2                	mov    %eax,%edx
c0100e44:	ec                   	in     (%dx),%al
c0100e45:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e48:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e4e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e52:	89 c2                	mov    %eax,%edx
c0100e54:	ec                   	in     (%dx),%al
c0100e55:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e58:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e5e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e62:	89 c2                	mov    %eax,%edx
c0100e64:	ec                   	in     (%dx),%al
c0100e65:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e68:	c9                   	leave  
c0100e69:	c3                   	ret    

c0100e6a <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e6a:	55                   	push   %ebp
c0100e6b:	89 e5                	mov    %esp,%ebp
c0100e6d:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e70:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e77:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e7a:	0f b7 00             	movzwl (%eax),%eax
c0100e7d:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e81:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e84:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e89:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e8c:	0f b7 00             	movzwl (%eax),%eax
c0100e8f:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e93:	74 12                	je     c0100ea7 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e95:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100e9c:	66 c7 05 86 7e 11 c0 	movw   $0x3b4,0xc0117e86
c0100ea3:	b4 03 
c0100ea5:	eb 13                	jmp    c0100eba <cga_init+0x50>
    } else {
        *cp = was;
c0100ea7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eaa:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100eae:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100eb1:	66 c7 05 86 7e 11 c0 	movw   $0x3d4,0xc0117e86
c0100eb8:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100eba:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ec1:	0f b7 c0             	movzwl %ax,%eax
c0100ec4:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ec8:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ecc:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ed0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100ed4:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ed5:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100edc:	83 c0 01             	add    $0x1,%eax
c0100edf:	0f b7 c0             	movzwl %ax,%eax
c0100ee2:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ee6:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100eea:	89 c2                	mov    %eax,%edx
c0100eec:	ec                   	in     (%dx),%al
c0100eed:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100ef0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100ef4:	0f b6 c0             	movzbl %al,%eax
c0100ef7:	c1 e0 08             	shl    $0x8,%eax
c0100efa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100efd:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f04:	0f b7 c0             	movzwl %ax,%eax
c0100f07:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f0b:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f0f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f13:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f17:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f18:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f1f:	83 c0 01             	add    $0x1,%eax
c0100f22:	0f b7 c0             	movzwl %ax,%eax
c0100f25:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f29:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f2d:	89 c2                	mov    %eax,%edx
c0100f2f:	ec                   	in     (%dx),%al
c0100f30:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f33:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f37:	0f b6 c0             	movzbl %al,%eax
c0100f3a:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f40:	a3 80 7e 11 c0       	mov    %eax,0xc0117e80
    crt_pos = pos;
c0100f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f48:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
}
c0100f4e:	c9                   	leave  
c0100f4f:	c3                   	ret    

c0100f50 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f50:	55                   	push   %ebp
c0100f51:	89 e5                	mov    %esp,%ebp
c0100f53:	83 ec 48             	sub    $0x48,%esp
c0100f56:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f5c:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f60:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f64:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f68:	ee                   	out    %al,(%dx)
c0100f69:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f6f:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f73:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f77:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f7b:	ee                   	out    %al,(%dx)
c0100f7c:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f82:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f86:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f8a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f8e:	ee                   	out    %al,(%dx)
c0100f8f:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100f95:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100f99:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f9d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fa1:	ee                   	out    %al,(%dx)
c0100fa2:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fa8:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fac:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fb0:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fb4:	ee                   	out    %al,(%dx)
c0100fb5:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fbb:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fbf:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fc3:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fc7:	ee                   	out    %al,(%dx)
c0100fc8:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fce:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fd2:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fd6:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fda:	ee                   	out    %al,(%dx)
c0100fdb:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fe1:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100fe5:	89 c2                	mov    %eax,%edx
c0100fe7:	ec                   	in     (%dx),%al
c0100fe8:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0100feb:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100fef:	3c ff                	cmp    $0xff,%al
c0100ff1:	0f 95 c0             	setne  %al
c0100ff4:	0f b6 c0             	movzbl %al,%eax
c0100ff7:	a3 88 7e 11 c0       	mov    %eax,0xc0117e88
c0100ffc:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101002:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0101006:	89 c2                	mov    %eax,%edx
c0101008:	ec                   	in     (%dx),%al
c0101009:	88 45 d5             	mov    %al,-0x2b(%ebp)
c010100c:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101012:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0101016:	89 c2                	mov    %eax,%edx
c0101018:	ec                   	in     (%dx),%al
c0101019:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010101c:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0101021:	85 c0                	test   %eax,%eax
c0101023:	74 0c                	je     c0101031 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0101025:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010102c:	e8 d6 06 00 00       	call   c0101707 <pic_enable>
    }
}
c0101031:	c9                   	leave  
c0101032:	c3                   	ret    

c0101033 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101033:	55                   	push   %ebp
c0101034:	89 e5                	mov    %esp,%ebp
c0101036:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101039:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101040:	eb 09                	jmp    c010104b <lpt_putc_sub+0x18>
        delay();
c0101042:	e8 db fd ff ff       	call   c0100e22 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101047:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010104b:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101051:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101055:	89 c2                	mov    %eax,%edx
c0101057:	ec                   	in     (%dx),%al
c0101058:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010105b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010105f:	84 c0                	test   %al,%al
c0101061:	78 09                	js     c010106c <lpt_putc_sub+0x39>
c0101063:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010106a:	7e d6                	jle    c0101042 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c010106c:	8b 45 08             	mov    0x8(%ebp),%eax
c010106f:	0f b6 c0             	movzbl %al,%eax
c0101072:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c0101078:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010107b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010107f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101083:	ee                   	out    %al,(%dx)
c0101084:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c010108a:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c010108e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101092:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101096:	ee                   	out    %al,(%dx)
c0101097:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c010109d:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010a1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010a5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010a9:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010aa:	c9                   	leave  
c01010ab:	c3                   	ret    

c01010ac <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010ac:	55                   	push   %ebp
c01010ad:	89 e5                	mov    %esp,%ebp
c01010af:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010b2:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010b6:	74 0d                	je     c01010c5 <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01010bb:	89 04 24             	mov    %eax,(%esp)
c01010be:	e8 70 ff ff ff       	call   c0101033 <lpt_putc_sub>
c01010c3:	eb 24                	jmp    c01010e9 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010c5:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010cc:	e8 62 ff ff ff       	call   c0101033 <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010d1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010d8:	e8 56 ff ff ff       	call   c0101033 <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010dd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010e4:	e8 4a ff ff ff       	call   c0101033 <lpt_putc_sub>
    }
}
c01010e9:	c9                   	leave  
c01010ea:	c3                   	ret    

c01010eb <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010eb:	55                   	push   %ebp
c01010ec:	89 e5                	mov    %esp,%ebp
c01010ee:	53                   	push   %ebx
c01010ef:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01010f5:	b0 00                	mov    $0x0,%al
c01010f7:	85 c0                	test   %eax,%eax
c01010f9:	75 07                	jne    c0101102 <cga_putc+0x17>
        c |= 0x0700;
c01010fb:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101102:	8b 45 08             	mov    0x8(%ebp),%eax
c0101105:	0f b6 c0             	movzbl %al,%eax
c0101108:	83 f8 0a             	cmp    $0xa,%eax
c010110b:	74 4c                	je     c0101159 <cga_putc+0x6e>
c010110d:	83 f8 0d             	cmp    $0xd,%eax
c0101110:	74 57                	je     c0101169 <cga_putc+0x7e>
c0101112:	83 f8 08             	cmp    $0x8,%eax
c0101115:	0f 85 88 00 00 00    	jne    c01011a3 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c010111b:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101122:	66 85 c0             	test   %ax,%ax
c0101125:	74 30                	je     c0101157 <cga_putc+0x6c>
            crt_pos --;
c0101127:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010112e:	83 e8 01             	sub    $0x1,%eax
c0101131:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101137:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c010113c:	0f b7 15 84 7e 11 c0 	movzwl 0xc0117e84,%edx
c0101143:	0f b7 d2             	movzwl %dx,%edx
c0101146:	01 d2                	add    %edx,%edx
c0101148:	01 c2                	add    %eax,%edx
c010114a:	8b 45 08             	mov    0x8(%ebp),%eax
c010114d:	b0 00                	mov    $0x0,%al
c010114f:	83 c8 20             	or     $0x20,%eax
c0101152:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101155:	eb 72                	jmp    c01011c9 <cga_putc+0xde>
c0101157:	eb 70                	jmp    c01011c9 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101159:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101160:	83 c0 50             	add    $0x50,%eax
c0101163:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101169:	0f b7 1d 84 7e 11 c0 	movzwl 0xc0117e84,%ebx
c0101170:	0f b7 0d 84 7e 11 c0 	movzwl 0xc0117e84,%ecx
c0101177:	0f b7 c1             	movzwl %cx,%eax
c010117a:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101180:	c1 e8 10             	shr    $0x10,%eax
c0101183:	89 c2                	mov    %eax,%edx
c0101185:	66 c1 ea 06          	shr    $0x6,%dx
c0101189:	89 d0                	mov    %edx,%eax
c010118b:	c1 e0 02             	shl    $0x2,%eax
c010118e:	01 d0                	add    %edx,%eax
c0101190:	c1 e0 04             	shl    $0x4,%eax
c0101193:	29 c1                	sub    %eax,%ecx
c0101195:	89 ca                	mov    %ecx,%edx
c0101197:	89 d8                	mov    %ebx,%eax
c0101199:	29 d0                	sub    %edx,%eax
c010119b:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
        break;
c01011a1:	eb 26                	jmp    c01011c9 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011a3:	8b 0d 80 7e 11 c0    	mov    0xc0117e80,%ecx
c01011a9:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011b0:	8d 50 01             	lea    0x1(%eax),%edx
c01011b3:	66 89 15 84 7e 11 c0 	mov    %dx,0xc0117e84
c01011ba:	0f b7 c0             	movzwl %ax,%eax
c01011bd:	01 c0                	add    %eax,%eax
c01011bf:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01011c5:	66 89 02             	mov    %ax,(%edx)
        break;
c01011c8:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011c9:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011d0:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011d4:	76 5b                	jbe    c0101231 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011d6:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011db:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011e1:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011e6:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01011ed:	00 
c01011ee:	89 54 24 04          	mov    %edx,0x4(%esp)
c01011f2:	89 04 24             	mov    %eax,(%esp)
c01011f5:	e8 33 4c 00 00       	call   c0105e2d <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011fa:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101201:	eb 15                	jmp    c0101218 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101203:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101208:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010120b:	01 d2                	add    %edx,%edx
c010120d:	01 d0                	add    %edx,%eax
c010120f:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101214:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101218:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010121f:	7e e2                	jle    c0101203 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101221:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101228:	83 e8 50             	sub    $0x50,%eax
c010122b:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101231:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0101238:	0f b7 c0             	movzwl %ax,%eax
c010123b:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c010123f:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101243:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101247:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010124b:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c010124c:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101253:	66 c1 e8 08          	shr    $0x8,%ax
c0101257:	0f b6 c0             	movzbl %al,%eax
c010125a:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c0101261:	83 c2 01             	add    $0x1,%edx
c0101264:	0f b7 d2             	movzwl %dx,%edx
c0101267:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c010126b:	88 45 ed             	mov    %al,-0x13(%ebp)
c010126e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101272:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101276:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101277:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c010127e:	0f b7 c0             	movzwl %ax,%eax
c0101281:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0101285:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c0101289:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010128d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101291:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c0101292:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101299:	0f b6 c0             	movzbl %al,%eax
c010129c:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c01012a3:	83 c2 01             	add    $0x1,%edx
c01012a6:	0f b7 d2             	movzwl %dx,%edx
c01012a9:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012ad:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012b0:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012b4:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012b8:	ee                   	out    %al,(%dx)
}
c01012b9:	83 c4 34             	add    $0x34,%esp
c01012bc:	5b                   	pop    %ebx
c01012bd:	5d                   	pop    %ebp
c01012be:	c3                   	ret    

c01012bf <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012bf:	55                   	push   %ebp
c01012c0:	89 e5                	mov    %esp,%ebp
c01012c2:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012cc:	eb 09                	jmp    c01012d7 <serial_putc_sub+0x18>
        delay();
c01012ce:	e8 4f fb ff ff       	call   c0100e22 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012d3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012d7:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012dd:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012e1:	89 c2                	mov    %eax,%edx
c01012e3:	ec                   	in     (%dx),%al
c01012e4:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012e7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012eb:	0f b6 c0             	movzbl %al,%eax
c01012ee:	83 e0 20             	and    $0x20,%eax
c01012f1:	85 c0                	test   %eax,%eax
c01012f3:	75 09                	jne    c01012fe <serial_putc_sub+0x3f>
c01012f5:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01012fc:	7e d0                	jle    c01012ce <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c01012fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0101301:	0f b6 c0             	movzbl %al,%eax
c0101304:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c010130a:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010130d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101311:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101315:	ee                   	out    %al,(%dx)
}
c0101316:	c9                   	leave  
c0101317:	c3                   	ret    

c0101318 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101318:	55                   	push   %ebp
c0101319:	89 e5                	mov    %esp,%ebp
c010131b:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010131e:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101322:	74 0d                	je     c0101331 <serial_putc+0x19>
        serial_putc_sub(c);
c0101324:	8b 45 08             	mov    0x8(%ebp),%eax
c0101327:	89 04 24             	mov    %eax,(%esp)
c010132a:	e8 90 ff ff ff       	call   c01012bf <serial_putc_sub>
c010132f:	eb 24                	jmp    c0101355 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101331:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101338:	e8 82 ff ff ff       	call   c01012bf <serial_putc_sub>
        serial_putc_sub(' ');
c010133d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101344:	e8 76 ff ff ff       	call   c01012bf <serial_putc_sub>
        serial_putc_sub('\b');
c0101349:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101350:	e8 6a ff ff ff       	call   c01012bf <serial_putc_sub>
    }
}
c0101355:	c9                   	leave  
c0101356:	c3                   	ret    

c0101357 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101357:	55                   	push   %ebp
c0101358:	89 e5                	mov    %esp,%ebp
c010135a:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c010135d:	eb 33                	jmp    c0101392 <cons_intr+0x3b>
        if (c != 0) {
c010135f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101363:	74 2d                	je     c0101392 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101365:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c010136a:	8d 50 01             	lea    0x1(%eax),%edx
c010136d:	89 15 a4 80 11 c0    	mov    %edx,0xc01180a4
c0101373:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101376:	88 90 a0 7e 11 c0    	mov    %dl,-0x3fee8160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c010137c:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101381:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101386:	75 0a                	jne    c0101392 <cons_intr+0x3b>
                cons.wpos = 0;
c0101388:	c7 05 a4 80 11 c0 00 	movl   $0x0,0xc01180a4
c010138f:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c0101392:	8b 45 08             	mov    0x8(%ebp),%eax
c0101395:	ff d0                	call   *%eax
c0101397:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010139a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c010139e:	75 bf                	jne    c010135f <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013a0:	c9                   	leave  
c01013a1:	c3                   	ret    

c01013a2 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013a2:	55                   	push   %ebp
c01013a3:	89 e5                	mov    %esp,%ebp
c01013a5:	83 ec 10             	sub    $0x10,%esp
c01013a8:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013ae:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013b2:	89 c2                	mov    %eax,%edx
c01013b4:	ec                   	in     (%dx),%al
c01013b5:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013b8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013bc:	0f b6 c0             	movzbl %al,%eax
c01013bf:	83 e0 01             	and    $0x1,%eax
c01013c2:	85 c0                	test   %eax,%eax
c01013c4:	75 07                	jne    c01013cd <serial_proc_data+0x2b>
        return -1;
c01013c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013cb:	eb 2a                	jmp    c01013f7 <serial_proc_data+0x55>
c01013cd:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013d3:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013d7:	89 c2                	mov    %eax,%edx
c01013d9:	ec                   	in     (%dx),%al
c01013da:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013dd:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013e1:	0f b6 c0             	movzbl %al,%eax
c01013e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013e7:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013eb:	75 07                	jne    c01013f4 <serial_proc_data+0x52>
        c = '\b';
c01013ed:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01013f7:	c9                   	leave  
c01013f8:	c3                   	ret    

c01013f9 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01013f9:	55                   	push   %ebp
c01013fa:	89 e5                	mov    %esp,%ebp
c01013fc:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c01013ff:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0101404:	85 c0                	test   %eax,%eax
c0101406:	74 0c                	je     c0101414 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101408:	c7 04 24 a2 13 10 c0 	movl   $0xc01013a2,(%esp)
c010140f:	e8 43 ff ff ff       	call   c0101357 <cons_intr>
    }
}
c0101414:	c9                   	leave  
c0101415:	c3                   	ret    

c0101416 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101416:	55                   	push   %ebp
c0101417:	89 e5                	mov    %esp,%ebp
c0101419:	83 ec 38             	sub    $0x38,%esp
c010141c:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101422:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101426:	89 c2                	mov    %eax,%edx
c0101428:	ec                   	in     (%dx),%al
c0101429:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c010142c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101430:	0f b6 c0             	movzbl %al,%eax
c0101433:	83 e0 01             	and    $0x1,%eax
c0101436:	85 c0                	test   %eax,%eax
c0101438:	75 0a                	jne    c0101444 <kbd_proc_data+0x2e>
        return -1;
c010143a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010143f:	e9 59 01 00 00       	jmp    c010159d <kbd_proc_data+0x187>
c0101444:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010144a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010144e:	89 c2                	mov    %eax,%edx
c0101450:	ec                   	in     (%dx),%al
c0101451:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101454:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101458:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c010145b:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c010145f:	75 17                	jne    c0101478 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101461:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101466:	83 c8 40             	or     $0x40,%eax
c0101469:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c010146e:	b8 00 00 00 00       	mov    $0x0,%eax
c0101473:	e9 25 01 00 00       	jmp    c010159d <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c0101478:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010147c:	84 c0                	test   %al,%al
c010147e:	79 47                	jns    c01014c7 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101480:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101485:	83 e0 40             	and    $0x40,%eax
c0101488:	85 c0                	test   %eax,%eax
c010148a:	75 09                	jne    c0101495 <kbd_proc_data+0x7f>
c010148c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101490:	83 e0 7f             	and    $0x7f,%eax
c0101493:	eb 04                	jmp    c0101499 <kbd_proc_data+0x83>
c0101495:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101499:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c010149c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a0:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014a7:	83 c8 40             	or     $0x40,%eax
c01014aa:	0f b6 c0             	movzbl %al,%eax
c01014ad:	f7 d0                	not    %eax
c01014af:	89 c2                	mov    %eax,%edx
c01014b1:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014b6:	21 d0                	and    %edx,%eax
c01014b8:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c01014bd:	b8 00 00 00 00       	mov    $0x0,%eax
c01014c2:	e9 d6 00 00 00       	jmp    c010159d <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014c7:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014cc:	83 e0 40             	and    $0x40,%eax
c01014cf:	85 c0                	test   %eax,%eax
c01014d1:	74 11                	je     c01014e4 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014d3:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014d7:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014dc:	83 e0 bf             	and    $0xffffffbf,%eax
c01014df:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    }

    shift |= shiftcode[data];
c01014e4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014e8:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014ef:	0f b6 d0             	movzbl %al,%edx
c01014f2:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014f7:	09 d0                	or     %edx,%eax
c01014f9:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    shift ^= togglecode[data];
c01014fe:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101502:	0f b6 80 60 71 11 c0 	movzbl -0x3fee8ea0(%eax),%eax
c0101509:	0f b6 d0             	movzbl %al,%edx
c010150c:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101511:	31 d0                	xor    %edx,%eax
c0101513:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8

    c = charcode[shift & (CTL | SHIFT)][data];
c0101518:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010151d:	83 e0 03             	and    $0x3,%eax
c0101520:	8b 14 85 60 75 11 c0 	mov    -0x3fee8aa0(,%eax,4),%edx
c0101527:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010152b:	01 d0                	add    %edx,%eax
c010152d:	0f b6 00             	movzbl (%eax),%eax
c0101530:	0f b6 c0             	movzbl %al,%eax
c0101533:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101536:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010153b:	83 e0 08             	and    $0x8,%eax
c010153e:	85 c0                	test   %eax,%eax
c0101540:	74 22                	je     c0101564 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101542:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101546:	7e 0c                	jle    c0101554 <kbd_proc_data+0x13e>
c0101548:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c010154c:	7f 06                	jg     c0101554 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c010154e:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101552:	eb 10                	jmp    c0101564 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101554:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101558:	7e 0a                	jle    c0101564 <kbd_proc_data+0x14e>
c010155a:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c010155e:	7f 04                	jg     c0101564 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101560:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101564:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101569:	f7 d0                	not    %eax
c010156b:	83 e0 06             	and    $0x6,%eax
c010156e:	85 c0                	test   %eax,%eax
c0101570:	75 28                	jne    c010159a <kbd_proc_data+0x184>
c0101572:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101579:	75 1f                	jne    c010159a <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c010157b:	c7 04 24 9d 62 10 c0 	movl   $0xc010629d,(%esp)
c0101582:	e8 b5 ed ff ff       	call   c010033c <cprintf>
c0101587:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c010158d:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101591:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101595:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c0101599:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c010159a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010159d:	c9                   	leave  
c010159e:	c3                   	ret    

c010159f <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c010159f:	55                   	push   %ebp
c01015a0:	89 e5                	mov    %esp,%ebp
c01015a2:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015a5:	c7 04 24 16 14 10 c0 	movl   $0xc0101416,(%esp)
c01015ac:	e8 a6 fd ff ff       	call   c0101357 <cons_intr>
}
c01015b1:	c9                   	leave  
c01015b2:	c3                   	ret    

c01015b3 <kbd_init>:

static void
kbd_init(void) {
c01015b3:	55                   	push   %ebp
c01015b4:	89 e5                	mov    %esp,%ebp
c01015b6:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015b9:	e8 e1 ff ff ff       	call   c010159f <kbd_intr>
    pic_enable(IRQ_KBD);
c01015be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015c5:	e8 3d 01 00 00       	call   c0101707 <pic_enable>
}
c01015ca:	c9                   	leave  
c01015cb:	c3                   	ret    

c01015cc <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015cc:	55                   	push   %ebp
c01015cd:	89 e5                	mov    %esp,%ebp
c01015cf:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015d2:	e8 93 f8 ff ff       	call   c0100e6a <cga_init>
    serial_init();
c01015d7:	e8 74 f9 ff ff       	call   c0100f50 <serial_init>
    kbd_init();
c01015dc:	e8 d2 ff ff ff       	call   c01015b3 <kbd_init>
    if (!serial_exists) {
c01015e1:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c01015e6:	85 c0                	test   %eax,%eax
c01015e8:	75 0c                	jne    c01015f6 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01015ea:	c7 04 24 a9 62 10 c0 	movl   $0xc01062a9,(%esp)
c01015f1:	e8 46 ed ff ff       	call   c010033c <cprintf>
    }
}
c01015f6:	c9                   	leave  
c01015f7:	c3                   	ret    

c01015f8 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01015f8:	55                   	push   %ebp
c01015f9:	89 e5                	mov    %esp,%ebp
c01015fb:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01015fe:	e8 e2 f7 ff ff       	call   c0100de5 <__intr_save>
c0101603:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101606:	8b 45 08             	mov    0x8(%ebp),%eax
c0101609:	89 04 24             	mov    %eax,(%esp)
c010160c:	e8 9b fa ff ff       	call   c01010ac <lpt_putc>
        cga_putc(c);
c0101611:	8b 45 08             	mov    0x8(%ebp),%eax
c0101614:	89 04 24             	mov    %eax,(%esp)
c0101617:	e8 cf fa ff ff       	call   c01010eb <cga_putc>
        serial_putc(c);
c010161c:	8b 45 08             	mov    0x8(%ebp),%eax
c010161f:	89 04 24             	mov    %eax,(%esp)
c0101622:	e8 f1 fc ff ff       	call   c0101318 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101627:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010162a:	89 04 24             	mov    %eax,(%esp)
c010162d:	e8 dd f7 ff ff       	call   c0100e0f <__intr_restore>
}
c0101632:	c9                   	leave  
c0101633:	c3                   	ret    

c0101634 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101634:	55                   	push   %ebp
c0101635:	89 e5                	mov    %esp,%ebp
c0101637:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c010163a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101641:	e8 9f f7 ff ff       	call   c0100de5 <__intr_save>
c0101646:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101649:	e8 ab fd ff ff       	call   c01013f9 <serial_intr>
        kbd_intr();
c010164e:	e8 4c ff ff ff       	call   c010159f <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101653:	8b 15 a0 80 11 c0    	mov    0xc01180a0,%edx
c0101659:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c010165e:	39 c2                	cmp    %eax,%edx
c0101660:	74 31                	je     c0101693 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101662:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101667:	8d 50 01             	lea    0x1(%eax),%edx
c010166a:	89 15 a0 80 11 c0    	mov    %edx,0xc01180a0
c0101670:	0f b6 80 a0 7e 11 c0 	movzbl -0x3fee8160(%eax),%eax
c0101677:	0f b6 c0             	movzbl %al,%eax
c010167a:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c010167d:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101682:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101687:	75 0a                	jne    c0101693 <cons_getc+0x5f>
                cons.rpos = 0;
c0101689:	c7 05 a0 80 11 c0 00 	movl   $0x0,0xc01180a0
c0101690:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101693:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101696:	89 04 24             	mov    %eax,(%esp)
c0101699:	e8 71 f7 ff ff       	call   c0100e0f <__intr_restore>
    return c;
c010169e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016a1:	c9                   	leave  
c01016a2:	c3                   	ret    

c01016a3 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01016a3:	55                   	push   %ebp
c01016a4:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c01016a6:	fb                   	sti    
    sti();
}
c01016a7:	5d                   	pop    %ebp
c01016a8:	c3                   	ret    

c01016a9 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01016a9:	55                   	push   %ebp
c01016aa:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c01016ac:	fa                   	cli    
    cli();
}
c01016ad:	5d                   	pop    %ebp
c01016ae:	c3                   	ret    

c01016af <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016af:	55                   	push   %ebp
c01016b0:	89 e5                	mov    %esp,%ebp
c01016b2:	83 ec 14             	sub    $0x14,%esp
c01016b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01016b8:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016bc:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016c0:	66 a3 70 75 11 c0    	mov    %ax,0xc0117570
    if (did_init) {
c01016c6:	a1 ac 80 11 c0       	mov    0xc01180ac,%eax
c01016cb:	85 c0                	test   %eax,%eax
c01016cd:	74 36                	je     c0101705 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016cf:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016d3:	0f b6 c0             	movzbl %al,%eax
c01016d6:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016dc:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016df:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01016e3:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016e7:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016e8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016ec:	66 c1 e8 08          	shr    $0x8,%ax
c01016f0:	0f b6 c0             	movzbl %al,%eax
c01016f3:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c01016f9:	88 45 f9             	mov    %al,-0x7(%ebp)
c01016fc:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101700:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101704:	ee                   	out    %al,(%dx)
    }
}
c0101705:	c9                   	leave  
c0101706:	c3                   	ret    

c0101707 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101707:	55                   	push   %ebp
c0101708:	89 e5                	mov    %esp,%ebp
c010170a:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c010170d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101710:	ba 01 00 00 00       	mov    $0x1,%edx
c0101715:	89 c1                	mov    %eax,%ecx
c0101717:	d3 e2                	shl    %cl,%edx
c0101719:	89 d0                	mov    %edx,%eax
c010171b:	f7 d0                	not    %eax
c010171d:	89 c2                	mov    %eax,%edx
c010171f:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101726:	21 d0                	and    %edx,%eax
c0101728:	0f b7 c0             	movzwl %ax,%eax
c010172b:	89 04 24             	mov    %eax,(%esp)
c010172e:	e8 7c ff ff ff       	call   c01016af <pic_setmask>
}
c0101733:	c9                   	leave  
c0101734:	c3                   	ret    

c0101735 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101735:	55                   	push   %ebp
c0101736:	89 e5                	mov    %esp,%ebp
c0101738:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c010173b:	c7 05 ac 80 11 c0 01 	movl   $0x1,0xc01180ac
c0101742:	00 00 00 
c0101745:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c010174b:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c010174f:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101753:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101757:	ee                   	out    %al,(%dx)
c0101758:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c010175e:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101762:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101766:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010176a:	ee                   	out    %al,(%dx)
c010176b:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101771:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0101775:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101779:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010177d:	ee                   	out    %al,(%dx)
c010177e:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c0101784:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c0101788:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010178c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101790:	ee                   	out    %al,(%dx)
c0101791:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c0101797:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c010179b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010179f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017a3:	ee                   	out    %al,(%dx)
c01017a4:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c01017aa:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01017ae:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017b2:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017b6:	ee                   	out    %al,(%dx)
c01017b7:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c01017bd:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c01017c1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017c5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017c9:	ee                   	out    %al,(%dx)
c01017ca:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c01017d0:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c01017d4:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017d8:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017dc:	ee                   	out    %al,(%dx)
c01017dd:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c01017e3:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c01017e7:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017eb:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01017ef:	ee                   	out    %al,(%dx)
c01017f0:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c01017f6:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c01017fa:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c01017fe:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101802:	ee                   	out    %al,(%dx)
c0101803:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c0101809:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c010180d:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101811:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101815:	ee                   	out    %al,(%dx)
c0101816:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c010181c:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c0101820:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101824:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101828:	ee                   	out    %al,(%dx)
c0101829:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c010182f:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c0101833:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101837:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c010183b:	ee                   	out    %al,(%dx)
c010183c:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c0101842:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c0101846:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c010184a:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c010184e:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c010184f:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101856:	66 83 f8 ff          	cmp    $0xffff,%ax
c010185a:	74 12                	je     c010186e <pic_init+0x139>
        pic_setmask(irq_mask);
c010185c:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101863:	0f b7 c0             	movzwl %ax,%eax
c0101866:	89 04 24             	mov    %eax,(%esp)
c0101869:	e8 41 fe ff ff       	call   c01016af <pic_setmask>
    }
}
c010186e:	c9                   	leave  
c010186f:	c3                   	ret    

c0101870 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101870:	55                   	push   %ebp
c0101871:	89 e5                	mov    %esp,%ebp
c0101873:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101876:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c010187d:	00 
c010187e:	c7 04 24 e0 62 10 c0 	movl   $0xc01062e0,(%esp)
c0101885:	e8 b2 ea ff ff       	call   c010033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c010188a:	c7 04 24 ea 62 10 c0 	movl   $0xc01062ea,(%esp)
c0101891:	e8 a6 ea ff ff       	call   c010033c <cprintf>
    panic("EOT: kernel seems ok.");
c0101896:	c7 44 24 08 f8 62 10 	movl   $0xc01062f8,0x8(%esp)
c010189d:	c0 
c010189e:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c01018a5:	00 
c01018a6:	c7 04 24 0e 63 10 c0 	movl   $0xc010630e,(%esp)
c01018ad:	e8 14 f4 ff ff       	call   c0100cc6 <__panic>

c01018b2 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01018b2:	55                   	push   %ebp
c01018b3:	89 e5                	mov    %esp,%ebp
c01018b5:	83 ec 10             	sub    $0x10,%esp
	extern uintptr_t __vectors[];
        int i = 0;
c01018b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
        for(i = 0; i < 256; i++)
c01018bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018c6:	e9 c3 00 00 00       	jmp    c010198e <idt_init+0xdc>
	{
	SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01018cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ce:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c01018d5:	89 c2                	mov    %eax,%edx
c01018d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018da:	66 89 14 c5 c0 80 11 	mov    %dx,-0x3fee7f40(,%eax,8)
c01018e1:	c0 
c01018e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018e5:	66 c7 04 c5 c2 80 11 	movw   $0x8,-0x3fee7f3e(,%eax,8)
c01018ec:	c0 08 00 
c01018ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018f2:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018f9:	c0 
c01018fa:	83 e2 e0             	and    $0xffffffe0,%edx
c01018fd:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c0101904:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101907:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c010190e:	c0 
c010190f:	83 e2 1f             	and    $0x1f,%edx
c0101912:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c0101919:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010191c:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101923:	c0 
c0101924:	83 e2 f0             	and    $0xfffffff0,%edx
c0101927:	83 ca 0e             	or     $0xe,%edx
c010192a:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101931:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101934:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010193b:	c0 
c010193c:	83 e2 ef             	and    $0xffffffef,%edx
c010193f:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101946:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101949:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101950:	c0 
c0101951:	83 e2 9f             	and    $0xffffff9f,%edx
c0101954:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010195b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010195e:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101965:	c0 
c0101966:	83 ca 80             	or     $0xffffff80,%edx
c0101969:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101970:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101973:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c010197a:	c1 e8 10             	shr    $0x10,%eax
c010197d:	89 c2                	mov    %eax,%edx
c010197f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101982:	66 89 14 c5 c6 80 11 	mov    %dx,-0x3fee7f3a(,%eax,8)
c0101989:	c0 
/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
	extern uintptr_t __vectors[];
        int i = 0;
        for(i = 0; i < 256; i++)
c010198a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010198e:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0101995:	0f 8e 30 ff ff ff    	jle    c01018cb <idt_init+0x19>
	{
	SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
	}
	SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c010199b:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c01019a0:	66 a3 88 84 11 c0    	mov    %ax,0xc0118488
c01019a6:	66 c7 05 8a 84 11 c0 	movw   $0x8,0xc011848a
c01019ad:	08 00 
c01019af:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c01019b6:	83 e0 e0             	and    $0xffffffe0,%eax
c01019b9:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c01019be:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c01019c5:	83 e0 1f             	and    $0x1f,%eax
c01019c8:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c01019cd:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019d4:	83 e0 f0             	and    $0xfffffff0,%eax
c01019d7:	83 c8 0e             	or     $0xe,%eax
c01019da:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019df:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019e6:	83 e0 ef             	and    $0xffffffef,%eax
c01019e9:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019ee:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019f5:	83 c8 60             	or     $0x60,%eax
c01019f8:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019fd:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c0101a04:	83 c8 80             	or     $0xffffff80,%eax
c0101a07:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c0101a0c:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c0101a11:	c1 e8 10             	shr    $0x10,%eax
c0101a14:	66 a3 8e 84 11 c0    	mov    %ax,0xc011848e
c0101a1a:	c7 45 f8 80 75 11 c0 	movl   $0xc0117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101a21:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101a24:	0f 01 18             	lidtl  (%eax)
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
}
c0101a27:	c9                   	leave  
c0101a28:	c3                   	ret    

c0101a29 <trapname>:

static const char *
trapname(int trapno) {
c0101a29:	55                   	push   %ebp
c0101a2a:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101a2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a2f:	83 f8 13             	cmp    $0x13,%eax
c0101a32:	77 0c                	ja     c0101a40 <trapname+0x17>
        return excnames[trapno];
c0101a34:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a37:	8b 04 85 60 66 10 c0 	mov    -0x3fef99a0(,%eax,4),%eax
c0101a3e:	eb 18                	jmp    c0101a58 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a40:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a44:	7e 0d                	jle    c0101a53 <trapname+0x2a>
c0101a46:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a4a:	7f 07                	jg     c0101a53 <trapname+0x2a>
        return "Hardware Interrupt";
c0101a4c:	b8 1f 63 10 c0       	mov    $0xc010631f,%eax
c0101a51:	eb 05                	jmp    c0101a58 <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a53:	b8 32 63 10 c0       	mov    $0xc0106332,%eax
}
c0101a58:	5d                   	pop    %ebp
c0101a59:	c3                   	ret    

c0101a5a <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101a5a:	55                   	push   %ebp
c0101a5b:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101a5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a60:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101a64:	66 83 f8 08          	cmp    $0x8,%ax
c0101a68:	0f 94 c0             	sete   %al
c0101a6b:	0f b6 c0             	movzbl %al,%eax
}
c0101a6e:	5d                   	pop    %ebp
c0101a6f:	c3                   	ret    

c0101a70 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101a70:	55                   	push   %ebp
c0101a71:	89 e5                	mov    %esp,%ebp
c0101a73:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101a76:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a79:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a7d:	c7 04 24 73 63 10 c0 	movl   $0xc0106373,(%esp)
c0101a84:	e8 b3 e8 ff ff       	call   c010033c <cprintf>
    print_regs(&tf->tf_regs);
c0101a89:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a8c:	89 04 24             	mov    %eax,(%esp)
c0101a8f:	e8 a1 01 00 00       	call   c0101c35 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101a94:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a97:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101a9b:	0f b7 c0             	movzwl %ax,%eax
c0101a9e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101aa2:	c7 04 24 84 63 10 c0 	movl   $0xc0106384,(%esp)
c0101aa9:	e8 8e e8 ff ff       	call   c010033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101aae:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab1:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101ab5:	0f b7 c0             	movzwl %ax,%eax
c0101ab8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101abc:	c7 04 24 97 63 10 c0 	movl   $0xc0106397,(%esp)
c0101ac3:	e8 74 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101ac8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101acb:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101acf:	0f b7 c0             	movzwl %ax,%eax
c0101ad2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ad6:	c7 04 24 aa 63 10 c0 	movl   $0xc01063aa,(%esp)
c0101add:	e8 5a e8 ff ff       	call   c010033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101ae2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ae5:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101ae9:	0f b7 c0             	movzwl %ax,%eax
c0101aec:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101af0:	c7 04 24 bd 63 10 c0 	movl   $0xc01063bd,(%esp)
c0101af7:	e8 40 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101afc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aff:	8b 40 30             	mov    0x30(%eax),%eax
c0101b02:	89 04 24             	mov    %eax,(%esp)
c0101b05:	e8 1f ff ff ff       	call   c0101a29 <trapname>
c0101b0a:	8b 55 08             	mov    0x8(%ebp),%edx
c0101b0d:	8b 52 30             	mov    0x30(%edx),%edx
c0101b10:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101b14:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101b18:	c7 04 24 d0 63 10 c0 	movl   $0xc01063d0,(%esp)
c0101b1f:	e8 18 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101b24:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b27:	8b 40 34             	mov    0x34(%eax),%eax
c0101b2a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b2e:	c7 04 24 e2 63 10 c0 	movl   $0xc01063e2,(%esp)
c0101b35:	e8 02 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b3d:	8b 40 38             	mov    0x38(%eax),%eax
c0101b40:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b44:	c7 04 24 f1 63 10 c0 	movl   $0xc01063f1,(%esp)
c0101b4b:	e8 ec e7 ff ff       	call   c010033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b50:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b53:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b57:	0f b7 c0             	movzwl %ax,%eax
c0101b5a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b5e:	c7 04 24 00 64 10 c0 	movl   $0xc0106400,(%esp)
c0101b65:	e8 d2 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b6d:	8b 40 40             	mov    0x40(%eax),%eax
c0101b70:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b74:	c7 04 24 13 64 10 c0 	movl   $0xc0106413,(%esp)
c0101b7b:	e8 bc e7 ff ff       	call   c010033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b80:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b87:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101b8e:	eb 3e                	jmp    c0101bce <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101b90:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b93:	8b 50 40             	mov    0x40(%eax),%edx
c0101b96:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101b99:	21 d0                	and    %edx,%eax
c0101b9b:	85 c0                	test   %eax,%eax
c0101b9d:	74 28                	je     c0101bc7 <print_trapframe+0x157>
c0101b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ba2:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101ba9:	85 c0                	test   %eax,%eax
c0101bab:	74 1a                	je     c0101bc7 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bb0:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101bb7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bbb:	c7 04 24 22 64 10 c0 	movl   $0xc0106422,(%esp)
c0101bc2:	e8 75 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101bc7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101bcb:	d1 65 f0             	shll   -0x10(%ebp)
c0101bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bd1:	83 f8 17             	cmp    $0x17,%eax
c0101bd4:	76 ba                	jbe    c0101b90 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101bd6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bd9:	8b 40 40             	mov    0x40(%eax),%eax
c0101bdc:	25 00 30 00 00       	and    $0x3000,%eax
c0101be1:	c1 e8 0c             	shr    $0xc,%eax
c0101be4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101be8:	c7 04 24 26 64 10 c0 	movl   $0xc0106426,(%esp)
c0101bef:	e8 48 e7 ff ff       	call   c010033c <cprintf>

    if (!trap_in_kernel(tf)) {
c0101bf4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bf7:	89 04 24             	mov    %eax,(%esp)
c0101bfa:	e8 5b fe ff ff       	call   c0101a5a <trap_in_kernel>
c0101bff:	85 c0                	test   %eax,%eax
c0101c01:	75 30                	jne    c0101c33 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101c03:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c06:	8b 40 44             	mov    0x44(%eax),%eax
c0101c09:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c0d:	c7 04 24 2f 64 10 c0 	movl   $0xc010642f,(%esp)
c0101c14:	e8 23 e7 ff ff       	call   c010033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101c19:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c1c:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101c20:	0f b7 c0             	movzwl %ax,%eax
c0101c23:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c27:	c7 04 24 3e 64 10 c0 	movl   $0xc010643e,(%esp)
c0101c2e:	e8 09 e7 ff ff       	call   c010033c <cprintf>
    }
}
c0101c33:	c9                   	leave  
c0101c34:	c3                   	ret    

c0101c35 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101c35:	55                   	push   %ebp
c0101c36:	89 e5                	mov    %esp,%ebp
c0101c38:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101c3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c3e:	8b 00                	mov    (%eax),%eax
c0101c40:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c44:	c7 04 24 51 64 10 c0 	movl   $0xc0106451,(%esp)
c0101c4b:	e8 ec e6 ff ff       	call   c010033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c50:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c53:	8b 40 04             	mov    0x4(%eax),%eax
c0101c56:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c5a:	c7 04 24 60 64 10 c0 	movl   $0xc0106460,(%esp)
c0101c61:	e8 d6 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c66:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c69:	8b 40 08             	mov    0x8(%eax),%eax
c0101c6c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c70:	c7 04 24 6f 64 10 c0 	movl   $0xc010646f,(%esp)
c0101c77:	e8 c0 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c7f:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c82:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c86:	c7 04 24 7e 64 10 c0 	movl   $0xc010647e,(%esp)
c0101c8d:	e8 aa e6 ff ff       	call   c010033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101c92:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c95:	8b 40 10             	mov    0x10(%eax),%eax
c0101c98:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c9c:	c7 04 24 8d 64 10 c0 	movl   $0xc010648d,(%esp)
c0101ca3:	e8 94 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101ca8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cab:	8b 40 14             	mov    0x14(%eax),%eax
c0101cae:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cb2:	c7 04 24 9c 64 10 c0 	movl   $0xc010649c,(%esp)
c0101cb9:	e8 7e e6 ff ff       	call   c010033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101cbe:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cc1:	8b 40 18             	mov    0x18(%eax),%eax
c0101cc4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cc8:	c7 04 24 ab 64 10 c0 	movl   $0xc01064ab,(%esp)
c0101ccf:	e8 68 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101cd4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cd7:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101cda:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cde:	c7 04 24 ba 64 10 c0 	movl   $0xc01064ba,(%esp)
c0101ce5:	e8 52 e6 ff ff       	call   c010033c <cprintf>
}
c0101cea:	c9                   	leave  
c0101ceb:	c3                   	ret    

c0101cec <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101cec:	55                   	push   %ebp
c0101ced:	89 e5                	mov    %esp,%ebp
c0101cef:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101cf2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cf5:	8b 40 30             	mov    0x30(%eax),%eax
c0101cf8:	83 f8 2f             	cmp    $0x2f,%eax
c0101cfb:	77 21                	ja     c0101d1e <trap_dispatch+0x32>
c0101cfd:	83 f8 2e             	cmp    $0x2e,%eax
c0101d00:	0f 83 04 01 00 00    	jae    c0101e0a <trap_dispatch+0x11e>
c0101d06:	83 f8 21             	cmp    $0x21,%eax
c0101d09:	0f 84 81 00 00 00    	je     c0101d90 <trap_dispatch+0xa4>
c0101d0f:	83 f8 24             	cmp    $0x24,%eax
c0101d12:	74 56                	je     c0101d6a <trap_dispatch+0x7e>
c0101d14:	83 f8 20             	cmp    $0x20,%eax
c0101d17:	74 16                	je     c0101d2f <trap_dispatch+0x43>
c0101d19:	e9 b4 00 00 00       	jmp    c0101dd2 <trap_dispatch+0xe6>
c0101d1e:	83 e8 78             	sub    $0x78,%eax
c0101d21:	83 f8 01             	cmp    $0x1,%eax
c0101d24:	0f 87 a8 00 00 00    	ja     c0101dd2 <trap_dispatch+0xe6>
c0101d2a:	e9 87 00 00 00       	jmp    c0101db6 <trap_dispatch+0xca>
    case IRQ_OFFSET + IRQ_TIMER:
	ticks++;
c0101d2f:	a1 4c 89 11 c0       	mov    0xc011894c,%eax
c0101d34:	83 c0 01             	add    $0x1,%eax
c0101d37:	a3 4c 89 11 c0       	mov    %eax,0xc011894c
	if(ticks%TICK_NUM == 0){
c0101d3c:	8b 0d 4c 89 11 c0    	mov    0xc011894c,%ecx
c0101d42:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101d47:	89 c8                	mov    %ecx,%eax
c0101d49:	f7 e2                	mul    %edx
c0101d4b:	89 d0                	mov    %edx,%eax
c0101d4d:	c1 e8 05             	shr    $0x5,%eax
c0101d50:	6b c0 64             	imul   $0x64,%eax,%eax
c0101d53:	29 c1                	sub    %eax,%ecx
c0101d55:	89 c8                	mov    %ecx,%eax
c0101d57:	85 c0                	test   %eax,%eax
c0101d59:	75 0a                	jne    c0101d65 <trap_dispatch+0x79>
	print_ticks();
c0101d5b:	e8 10 fb ff ff       	call   c0101870 <print_ticks>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
c0101d60:	e9 a6 00 00 00       	jmp    c0101e0b <trap_dispatch+0x11f>
c0101d65:	e9 a1 00 00 00       	jmp    c0101e0b <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101d6a:	e8 c5 f8 ff ff       	call   c0101634 <cons_getc>
c0101d6f:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101d72:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d76:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d7a:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101d7e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d82:	c7 04 24 c9 64 10 c0 	movl   $0xc01064c9,(%esp)
c0101d89:	e8 ae e5 ff ff       	call   c010033c <cprintf>
        break;
c0101d8e:	eb 7b                	jmp    c0101e0b <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101d90:	e8 9f f8 ff ff       	call   c0101634 <cons_getc>
c0101d95:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101d98:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d9c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101da0:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101da4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101da8:	c7 04 24 db 64 10 c0 	movl   $0xc01064db,(%esp)
c0101daf:	e8 88 e5 ff ff       	call   c010033c <cprintf>
        break;
c0101db4:	eb 55                	jmp    c0101e0b <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101db6:	c7 44 24 08 ea 64 10 	movl   $0xc01064ea,0x8(%esp)
c0101dbd:	c0 
c0101dbe:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
c0101dc5:	00 
c0101dc6:	c7 04 24 0e 63 10 c0 	movl   $0xc010630e,(%esp)
c0101dcd:	e8 f4 ee ff ff       	call   c0100cc6 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101dd2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dd5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101dd9:	0f b7 c0             	movzwl %ax,%eax
c0101ddc:	83 e0 03             	and    $0x3,%eax
c0101ddf:	85 c0                	test   %eax,%eax
c0101de1:	75 28                	jne    c0101e0b <trap_dispatch+0x11f>
            print_trapframe(tf);
c0101de3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101de6:	89 04 24             	mov    %eax,(%esp)
c0101de9:	e8 82 fc ff ff       	call   c0101a70 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101dee:	c7 44 24 08 fa 64 10 	movl   $0xc01064fa,0x8(%esp)
c0101df5:	c0 
c0101df6:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
c0101dfd:	00 
c0101dfe:	c7 04 24 0e 63 10 c0 	movl   $0xc010630e,(%esp)
c0101e05:	e8 bc ee ff ff       	call   c0100cc6 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101e0a:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101e0b:	c9                   	leave  
c0101e0c:	c3                   	ret    

c0101e0d <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101e0d:	55                   	push   %ebp
c0101e0e:	89 e5                	mov    %esp,%ebp
c0101e10:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101e13:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e16:	89 04 24             	mov    %eax,(%esp)
c0101e19:	e8 ce fe ff ff       	call   c0101cec <trap_dispatch>
}
c0101e1e:	c9                   	leave  
c0101e1f:	c3                   	ret    

c0101e20 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101e20:	1e                   	push   %ds
    pushl %es
c0101e21:	06                   	push   %es
    pushl %fs
c0101e22:	0f a0                	push   %fs
    pushl %gs
c0101e24:	0f a8                	push   %gs
    pushal
c0101e26:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101e27:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101e2c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101e2e:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101e30:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101e31:	e8 d7 ff ff ff       	call   c0101e0d <trap>

    # pop the pushed stack pointer
    popl %esp
c0101e36:	5c                   	pop    %esp

c0101e37 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101e37:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101e38:	0f a9                	pop    %gs
    popl %fs
c0101e3a:	0f a1                	pop    %fs
    popl %es
c0101e3c:	07                   	pop    %es
    popl %ds
c0101e3d:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101e3e:	83 c4 08             	add    $0x8,%esp
    iret
c0101e41:	cf                   	iret   

c0101e42 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101e42:	6a 00                	push   $0x0
  pushl $0
c0101e44:	6a 00                	push   $0x0
  jmp __alltraps
c0101e46:	e9 d5 ff ff ff       	jmp    c0101e20 <__alltraps>

c0101e4b <vector1>:
.globl vector1
vector1:
  pushl $0
c0101e4b:	6a 00                	push   $0x0
  pushl $1
c0101e4d:	6a 01                	push   $0x1
  jmp __alltraps
c0101e4f:	e9 cc ff ff ff       	jmp    c0101e20 <__alltraps>

c0101e54 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101e54:	6a 00                	push   $0x0
  pushl $2
c0101e56:	6a 02                	push   $0x2
  jmp __alltraps
c0101e58:	e9 c3 ff ff ff       	jmp    c0101e20 <__alltraps>

c0101e5d <vector3>:
.globl vector3
vector3:
  pushl $0
c0101e5d:	6a 00                	push   $0x0
  pushl $3
c0101e5f:	6a 03                	push   $0x3
  jmp __alltraps
c0101e61:	e9 ba ff ff ff       	jmp    c0101e20 <__alltraps>

c0101e66 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101e66:	6a 00                	push   $0x0
  pushl $4
c0101e68:	6a 04                	push   $0x4
  jmp __alltraps
c0101e6a:	e9 b1 ff ff ff       	jmp    c0101e20 <__alltraps>

c0101e6f <vector5>:
.globl vector5
vector5:
  pushl $0
c0101e6f:	6a 00                	push   $0x0
  pushl $5
c0101e71:	6a 05                	push   $0x5
  jmp __alltraps
c0101e73:	e9 a8 ff ff ff       	jmp    c0101e20 <__alltraps>

c0101e78 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101e78:	6a 00                	push   $0x0
  pushl $6
c0101e7a:	6a 06                	push   $0x6
  jmp __alltraps
c0101e7c:	e9 9f ff ff ff       	jmp    c0101e20 <__alltraps>

c0101e81 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101e81:	6a 00                	push   $0x0
  pushl $7
c0101e83:	6a 07                	push   $0x7
  jmp __alltraps
c0101e85:	e9 96 ff ff ff       	jmp    c0101e20 <__alltraps>

c0101e8a <vector8>:
.globl vector8
vector8:
  pushl $8
c0101e8a:	6a 08                	push   $0x8
  jmp __alltraps
c0101e8c:	e9 8f ff ff ff       	jmp    c0101e20 <__alltraps>

c0101e91 <vector9>:
.globl vector9
vector9:
  pushl $9
c0101e91:	6a 09                	push   $0x9
  jmp __alltraps
c0101e93:	e9 88 ff ff ff       	jmp    c0101e20 <__alltraps>

c0101e98 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101e98:	6a 0a                	push   $0xa
  jmp __alltraps
c0101e9a:	e9 81 ff ff ff       	jmp    c0101e20 <__alltraps>

c0101e9f <vector11>:
.globl vector11
vector11:
  pushl $11
c0101e9f:	6a 0b                	push   $0xb
  jmp __alltraps
c0101ea1:	e9 7a ff ff ff       	jmp    c0101e20 <__alltraps>

c0101ea6 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101ea6:	6a 0c                	push   $0xc
  jmp __alltraps
c0101ea8:	e9 73 ff ff ff       	jmp    c0101e20 <__alltraps>

c0101ead <vector13>:
.globl vector13
vector13:
  pushl $13
c0101ead:	6a 0d                	push   $0xd
  jmp __alltraps
c0101eaf:	e9 6c ff ff ff       	jmp    c0101e20 <__alltraps>

c0101eb4 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101eb4:	6a 0e                	push   $0xe
  jmp __alltraps
c0101eb6:	e9 65 ff ff ff       	jmp    c0101e20 <__alltraps>

c0101ebb <vector15>:
.globl vector15
vector15:
  pushl $0
c0101ebb:	6a 00                	push   $0x0
  pushl $15
c0101ebd:	6a 0f                	push   $0xf
  jmp __alltraps
c0101ebf:	e9 5c ff ff ff       	jmp    c0101e20 <__alltraps>

c0101ec4 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101ec4:	6a 00                	push   $0x0
  pushl $16
c0101ec6:	6a 10                	push   $0x10
  jmp __alltraps
c0101ec8:	e9 53 ff ff ff       	jmp    c0101e20 <__alltraps>

c0101ecd <vector17>:
.globl vector17
vector17:
  pushl $17
c0101ecd:	6a 11                	push   $0x11
  jmp __alltraps
c0101ecf:	e9 4c ff ff ff       	jmp    c0101e20 <__alltraps>

c0101ed4 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101ed4:	6a 00                	push   $0x0
  pushl $18
c0101ed6:	6a 12                	push   $0x12
  jmp __alltraps
c0101ed8:	e9 43 ff ff ff       	jmp    c0101e20 <__alltraps>

c0101edd <vector19>:
.globl vector19
vector19:
  pushl $0
c0101edd:	6a 00                	push   $0x0
  pushl $19
c0101edf:	6a 13                	push   $0x13
  jmp __alltraps
c0101ee1:	e9 3a ff ff ff       	jmp    c0101e20 <__alltraps>

c0101ee6 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101ee6:	6a 00                	push   $0x0
  pushl $20
c0101ee8:	6a 14                	push   $0x14
  jmp __alltraps
c0101eea:	e9 31 ff ff ff       	jmp    c0101e20 <__alltraps>

c0101eef <vector21>:
.globl vector21
vector21:
  pushl $0
c0101eef:	6a 00                	push   $0x0
  pushl $21
c0101ef1:	6a 15                	push   $0x15
  jmp __alltraps
c0101ef3:	e9 28 ff ff ff       	jmp    c0101e20 <__alltraps>

c0101ef8 <vector22>:
.globl vector22
vector22:
  pushl $0
c0101ef8:	6a 00                	push   $0x0
  pushl $22
c0101efa:	6a 16                	push   $0x16
  jmp __alltraps
c0101efc:	e9 1f ff ff ff       	jmp    c0101e20 <__alltraps>

c0101f01 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101f01:	6a 00                	push   $0x0
  pushl $23
c0101f03:	6a 17                	push   $0x17
  jmp __alltraps
c0101f05:	e9 16 ff ff ff       	jmp    c0101e20 <__alltraps>

c0101f0a <vector24>:
.globl vector24
vector24:
  pushl $0
c0101f0a:	6a 00                	push   $0x0
  pushl $24
c0101f0c:	6a 18                	push   $0x18
  jmp __alltraps
c0101f0e:	e9 0d ff ff ff       	jmp    c0101e20 <__alltraps>

c0101f13 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101f13:	6a 00                	push   $0x0
  pushl $25
c0101f15:	6a 19                	push   $0x19
  jmp __alltraps
c0101f17:	e9 04 ff ff ff       	jmp    c0101e20 <__alltraps>

c0101f1c <vector26>:
.globl vector26
vector26:
  pushl $0
c0101f1c:	6a 00                	push   $0x0
  pushl $26
c0101f1e:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101f20:	e9 fb fe ff ff       	jmp    c0101e20 <__alltraps>

c0101f25 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101f25:	6a 00                	push   $0x0
  pushl $27
c0101f27:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101f29:	e9 f2 fe ff ff       	jmp    c0101e20 <__alltraps>

c0101f2e <vector28>:
.globl vector28
vector28:
  pushl $0
c0101f2e:	6a 00                	push   $0x0
  pushl $28
c0101f30:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101f32:	e9 e9 fe ff ff       	jmp    c0101e20 <__alltraps>

c0101f37 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101f37:	6a 00                	push   $0x0
  pushl $29
c0101f39:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101f3b:	e9 e0 fe ff ff       	jmp    c0101e20 <__alltraps>

c0101f40 <vector30>:
.globl vector30
vector30:
  pushl $0
c0101f40:	6a 00                	push   $0x0
  pushl $30
c0101f42:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101f44:	e9 d7 fe ff ff       	jmp    c0101e20 <__alltraps>

c0101f49 <vector31>:
.globl vector31
vector31:
  pushl $0
c0101f49:	6a 00                	push   $0x0
  pushl $31
c0101f4b:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101f4d:	e9 ce fe ff ff       	jmp    c0101e20 <__alltraps>

c0101f52 <vector32>:
.globl vector32
vector32:
  pushl $0
c0101f52:	6a 00                	push   $0x0
  pushl $32
c0101f54:	6a 20                	push   $0x20
  jmp __alltraps
c0101f56:	e9 c5 fe ff ff       	jmp    c0101e20 <__alltraps>

c0101f5b <vector33>:
.globl vector33
vector33:
  pushl $0
c0101f5b:	6a 00                	push   $0x0
  pushl $33
c0101f5d:	6a 21                	push   $0x21
  jmp __alltraps
c0101f5f:	e9 bc fe ff ff       	jmp    c0101e20 <__alltraps>

c0101f64 <vector34>:
.globl vector34
vector34:
  pushl $0
c0101f64:	6a 00                	push   $0x0
  pushl $34
c0101f66:	6a 22                	push   $0x22
  jmp __alltraps
c0101f68:	e9 b3 fe ff ff       	jmp    c0101e20 <__alltraps>

c0101f6d <vector35>:
.globl vector35
vector35:
  pushl $0
c0101f6d:	6a 00                	push   $0x0
  pushl $35
c0101f6f:	6a 23                	push   $0x23
  jmp __alltraps
c0101f71:	e9 aa fe ff ff       	jmp    c0101e20 <__alltraps>

c0101f76 <vector36>:
.globl vector36
vector36:
  pushl $0
c0101f76:	6a 00                	push   $0x0
  pushl $36
c0101f78:	6a 24                	push   $0x24
  jmp __alltraps
c0101f7a:	e9 a1 fe ff ff       	jmp    c0101e20 <__alltraps>

c0101f7f <vector37>:
.globl vector37
vector37:
  pushl $0
c0101f7f:	6a 00                	push   $0x0
  pushl $37
c0101f81:	6a 25                	push   $0x25
  jmp __alltraps
c0101f83:	e9 98 fe ff ff       	jmp    c0101e20 <__alltraps>

c0101f88 <vector38>:
.globl vector38
vector38:
  pushl $0
c0101f88:	6a 00                	push   $0x0
  pushl $38
c0101f8a:	6a 26                	push   $0x26
  jmp __alltraps
c0101f8c:	e9 8f fe ff ff       	jmp    c0101e20 <__alltraps>

c0101f91 <vector39>:
.globl vector39
vector39:
  pushl $0
c0101f91:	6a 00                	push   $0x0
  pushl $39
c0101f93:	6a 27                	push   $0x27
  jmp __alltraps
c0101f95:	e9 86 fe ff ff       	jmp    c0101e20 <__alltraps>

c0101f9a <vector40>:
.globl vector40
vector40:
  pushl $0
c0101f9a:	6a 00                	push   $0x0
  pushl $40
c0101f9c:	6a 28                	push   $0x28
  jmp __alltraps
c0101f9e:	e9 7d fe ff ff       	jmp    c0101e20 <__alltraps>

c0101fa3 <vector41>:
.globl vector41
vector41:
  pushl $0
c0101fa3:	6a 00                	push   $0x0
  pushl $41
c0101fa5:	6a 29                	push   $0x29
  jmp __alltraps
c0101fa7:	e9 74 fe ff ff       	jmp    c0101e20 <__alltraps>

c0101fac <vector42>:
.globl vector42
vector42:
  pushl $0
c0101fac:	6a 00                	push   $0x0
  pushl $42
c0101fae:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101fb0:	e9 6b fe ff ff       	jmp    c0101e20 <__alltraps>

c0101fb5 <vector43>:
.globl vector43
vector43:
  pushl $0
c0101fb5:	6a 00                	push   $0x0
  pushl $43
c0101fb7:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101fb9:	e9 62 fe ff ff       	jmp    c0101e20 <__alltraps>

c0101fbe <vector44>:
.globl vector44
vector44:
  pushl $0
c0101fbe:	6a 00                	push   $0x0
  pushl $44
c0101fc0:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101fc2:	e9 59 fe ff ff       	jmp    c0101e20 <__alltraps>

c0101fc7 <vector45>:
.globl vector45
vector45:
  pushl $0
c0101fc7:	6a 00                	push   $0x0
  pushl $45
c0101fc9:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101fcb:	e9 50 fe ff ff       	jmp    c0101e20 <__alltraps>

c0101fd0 <vector46>:
.globl vector46
vector46:
  pushl $0
c0101fd0:	6a 00                	push   $0x0
  pushl $46
c0101fd2:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101fd4:	e9 47 fe ff ff       	jmp    c0101e20 <__alltraps>

c0101fd9 <vector47>:
.globl vector47
vector47:
  pushl $0
c0101fd9:	6a 00                	push   $0x0
  pushl $47
c0101fdb:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101fdd:	e9 3e fe ff ff       	jmp    c0101e20 <__alltraps>

c0101fe2 <vector48>:
.globl vector48
vector48:
  pushl $0
c0101fe2:	6a 00                	push   $0x0
  pushl $48
c0101fe4:	6a 30                	push   $0x30
  jmp __alltraps
c0101fe6:	e9 35 fe ff ff       	jmp    c0101e20 <__alltraps>

c0101feb <vector49>:
.globl vector49
vector49:
  pushl $0
c0101feb:	6a 00                	push   $0x0
  pushl $49
c0101fed:	6a 31                	push   $0x31
  jmp __alltraps
c0101fef:	e9 2c fe ff ff       	jmp    c0101e20 <__alltraps>

c0101ff4 <vector50>:
.globl vector50
vector50:
  pushl $0
c0101ff4:	6a 00                	push   $0x0
  pushl $50
c0101ff6:	6a 32                	push   $0x32
  jmp __alltraps
c0101ff8:	e9 23 fe ff ff       	jmp    c0101e20 <__alltraps>

c0101ffd <vector51>:
.globl vector51
vector51:
  pushl $0
c0101ffd:	6a 00                	push   $0x0
  pushl $51
c0101fff:	6a 33                	push   $0x33
  jmp __alltraps
c0102001:	e9 1a fe ff ff       	jmp    c0101e20 <__alltraps>

c0102006 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102006:	6a 00                	push   $0x0
  pushl $52
c0102008:	6a 34                	push   $0x34
  jmp __alltraps
c010200a:	e9 11 fe ff ff       	jmp    c0101e20 <__alltraps>

c010200f <vector53>:
.globl vector53
vector53:
  pushl $0
c010200f:	6a 00                	push   $0x0
  pushl $53
c0102011:	6a 35                	push   $0x35
  jmp __alltraps
c0102013:	e9 08 fe ff ff       	jmp    c0101e20 <__alltraps>

c0102018 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102018:	6a 00                	push   $0x0
  pushl $54
c010201a:	6a 36                	push   $0x36
  jmp __alltraps
c010201c:	e9 ff fd ff ff       	jmp    c0101e20 <__alltraps>

c0102021 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102021:	6a 00                	push   $0x0
  pushl $55
c0102023:	6a 37                	push   $0x37
  jmp __alltraps
c0102025:	e9 f6 fd ff ff       	jmp    c0101e20 <__alltraps>

c010202a <vector56>:
.globl vector56
vector56:
  pushl $0
c010202a:	6a 00                	push   $0x0
  pushl $56
c010202c:	6a 38                	push   $0x38
  jmp __alltraps
c010202e:	e9 ed fd ff ff       	jmp    c0101e20 <__alltraps>

c0102033 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102033:	6a 00                	push   $0x0
  pushl $57
c0102035:	6a 39                	push   $0x39
  jmp __alltraps
c0102037:	e9 e4 fd ff ff       	jmp    c0101e20 <__alltraps>

c010203c <vector58>:
.globl vector58
vector58:
  pushl $0
c010203c:	6a 00                	push   $0x0
  pushl $58
c010203e:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102040:	e9 db fd ff ff       	jmp    c0101e20 <__alltraps>

c0102045 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102045:	6a 00                	push   $0x0
  pushl $59
c0102047:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102049:	e9 d2 fd ff ff       	jmp    c0101e20 <__alltraps>

c010204e <vector60>:
.globl vector60
vector60:
  pushl $0
c010204e:	6a 00                	push   $0x0
  pushl $60
c0102050:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102052:	e9 c9 fd ff ff       	jmp    c0101e20 <__alltraps>

c0102057 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102057:	6a 00                	push   $0x0
  pushl $61
c0102059:	6a 3d                	push   $0x3d
  jmp __alltraps
c010205b:	e9 c0 fd ff ff       	jmp    c0101e20 <__alltraps>

c0102060 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102060:	6a 00                	push   $0x0
  pushl $62
c0102062:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102064:	e9 b7 fd ff ff       	jmp    c0101e20 <__alltraps>

c0102069 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102069:	6a 00                	push   $0x0
  pushl $63
c010206b:	6a 3f                	push   $0x3f
  jmp __alltraps
c010206d:	e9 ae fd ff ff       	jmp    c0101e20 <__alltraps>

c0102072 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102072:	6a 00                	push   $0x0
  pushl $64
c0102074:	6a 40                	push   $0x40
  jmp __alltraps
c0102076:	e9 a5 fd ff ff       	jmp    c0101e20 <__alltraps>

c010207b <vector65>:
.globl vector65
vector65:
  pushl $0
c010207b:	6a 00                	push   $0x0
  pushl $65
c010207d:	6a 41                	push   $0x41
  jmp __alltraps
c010207f:	e9 9c fd ff ff       	jmp    c0101e20 <__alltraps>

c0102084 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102084:	6a 00                	push   $0x0
  pushl $66
c0102086:	6a 42                	push   $0x42
  jmp __alltraps
c0102088:	e9 93 fd ff ff       	jmp    c0101e20 <__alltraps>

c010208d <vector67>:
.globl vector67
vector67:
  pushl $0
c010208d:	6a 00                	push   $0x0
  pushl $67
c010208f:	6a 43                	push   $0x43
  jmp __alltraps
c0102091:	e9 8a fd ff ff       	jmp    c0101e20 <__alltraps>

c0102096 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102096:	6a 00                	push   $0x0
  pushl $68
c0102098:	6a 44                	push   $0x44
  jmp __alltraps
c010209a:	e9 81 fd ff ff       	jmp    c0101e20 <__alltraps>

c010209f <vector69>:
.globl vector69
vector69:
  pushl $0
c010209f:	6a 00                	push   $0x0
  pushl $69
c01020a1:	6a 45                	push   $0x45
  jmp __alltraps
c01020a3:	e9 78 fd ff ff       	jmp    c0101e20 <__alltraps>

c01020a8 <vector70>:
.globl vector70
vector70:
  pushl $0
c01020a8:	6a 00                	push   $0x0
  pushl $70
c01020aa:	6a 46                	push   $0x46
  jmp __alltraps
c01020ac:	e9 6f fd ff ff       	jmp    c0101e20 <__alltraps>

c01020b1 <vector71>:
.globl vector71
vector71:
  pushl $0
c01020b1:	6a 00                	push   $0x0
  pushl $71
c01020b3:	6a 47                	push   $0x47
  jmp __alltraps
c01020b5:	e9 66 fd ff ff       	jmp    c0101e20 <__alltraps>

c01020ba <vector72>:
.globl vector72
vector72:
  pushl $0
c01020ba:	6a 00                	push   $0x0
  pushl $72
c01020bc:	6a 48                	push   $0x48
  jmp __alltraps
c01020be:	e9 5d fd ff ff       	jmp    c0101e20 <__alltraps>

c01020c3 <vector73>:
.globl vector73
vector73:
  pushl $0
c01020c3:	6a 00                	push   $0x0
  pushl $73
c01020c5:	6a 49                	push   $0x49
  jmp __alltraps
c01020c7:	e9 54 fd ff ff       	jmp    c0101e20 <__alltraps>

c01020cc <vector74>:
.globl vector74
vector74:
  pushl $0
c01020cc:	6a 00                	push   $0x0
  pushl $74
c01020ce:	6a 4a                	push   $0x4a
  jmp __alltraps
c01020d0:	e9 4b fd ff ff       	jmp    c0101e20 <__alltraps>

c01020d5 <vector75>:
.globl vector75
vector75:
  pushl $0
c01020d5:	6a 00                	push   $0x0
  pushl $75
c01020d7:	6a 4b                	push   $0x4b
  jmp __alltraps
c01020d9:	e9 42 fd ff ff       	jmp    c0101e20 <__alltraps>

c01020de <vector76>:
.globl vector76
vector76:
  pushl $0
c01020de:	6a 00                	push   $0x0
  pushl $76
c01020e0:	6a 4c                	push   $0x4c
  jmp __alltraps
c01020e2:	e9 39 fd ff ff       	jmp    c0101e20 <__alltraps>

c01020e7 <vector77>:
.globl vector77
vector77:
  pushl $0
c01020e7:	6a 00                	push   $0x0
  pushl $77
c01020e9:	6a 4d                	push   $0x4d
  jmp __alltraps
c01020eb:	e9 30 fd ff ff       	jmp    c0101e20 <__alltraps>

c01020f0 <vector78>:
.globl vector78
vector78:
  pushl $0
c01020f0:	6a 00                	push   $0x0
  pushl $78
c01020f2:	6a 4e                	push   $0x4e
  jmp __alltraps
c01020f4:	e9 27 fd ff ff       	jmp    c0101e20 <__alltraps>

c01020f9 <vector79>:
.globl vector79
vector79:
  pushl $0
c01020f9:	6a 00                	push   $0x0
  pushl $79
c01020fb:	6a 4f                	push   $0x4f
  jmp __alltraps
c01020fd:	e9 1e fd ff ff       	jmp    c0101e20 <__alltraps>

c0102102 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102102:	6a 00                	push   $0x0
  pushl $80
c0102104:	6a 50                	push   $0x50
  jmp __alltraps
c0102106:	e9 15 fd ff ff       	jmp    c0101e20 <__alltraps>

c010210b <vector81>:
.globl vector81
vector81:
  pushl $0
c010210b:	6a 00                	push   $0x0
  pushl $81
c010210d:	6a 51                	push   $0x51
  jmp __alltraps
c010210f:	e9 0c fd ff ff       	jmp    c0101e20 <__alltraps>

c0102114 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102114:	6a 00                	push   $0x0
  pushl $82
c0102116:	6a 52                	push   $0x52
  jmp __alltraps
c0102118:	e9 03 fd ff ff       	jmp    c0101e20 <__alltraps>

c010211d <vector83>:
.globl vector83
vector83:
  pushl $0
c010211d:	6a 00                	push   $0x0
  pushl $83
c010211f:	6a 53                	push   $0x53
  jmp __alltraps
c0102121:	e9 fa fc ff ff       	jmp    c0101e20 <__alltraps>

c0102126 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102126:	6a 00                	push   $0x0
  pushl $84
c0102128:	6a 54                	push   $0x54
  jmp __alltraps
c010212a:	e9 f1 fc ff ff       	jmp    c0101e20 <__alltraps>

c010212f <vector85>:
.globl vector85
vector85:
  pushl $0
c010212f:	6a 00                	push   $0x0
  pushl $85
c0102131:	6a 55                	push   $0x55
  jmp __alltraps
c0102133:	e9 e8 fc ff ff       	jmp    c0101e20 <__alltraps>

c0102138 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102138:	6a 00                	push   $0x0
  pushl $86
c010213a:	6a 56                	push   $0x56
  jmp __alltraps
c010213c:	e9 df fc ff ff       	jmp    c0101e20 <__alltraps>

c0102141 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102141:	6a 00                	push   $0x0
  pushl $87
c0102143:	6a 57                	push   $0x57
  jmp __alltraps
c0102145:	e9 d6 fc ff ff       	jmp    c0101e20 <__alltraps>

c010214a <vector88>:
.globl vector88
vector88:
  pushl $0
c010214a:	6a 00                	push   $0x0
  pushl $88
c010214c:	6a 58                	push   $0x58
  jmp __alltraps
c010214e:	e9 cd fc ff ff       	jmp    c0101e20 <__alltraps>

c0102153 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102153:	6a 00                	push   $0x0
  pushl $89
c0102155:	6a 59                	push   $0x59
  jmp __alltraps
c0102157:	e9 c4 fc ff ff       	jmp    c0101e20 <__alltraps>

c010215c <vector90>:
.globl vector90
vector90:
  pushl $0
c010215c:	6a 00                	push   $0x0
  pushl $90
c010215e:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102160:	e9 bb fc ff ff       	jmp    c0101e20 <__alltraps>

c0102165 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102165:	6a 00                	push   $0x0
  pushl $91
c0102167:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102169:	e9 b2 fc ff ff       	jmp    c0101e20 <__alltraps>

c010216e <vector92>:
.globl vector92
vector92:
  pushl $0
c010216e:	6a 00                	push   $0x0
  pushl $92
c0102170:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102172:	e9 a9 fc ff ff       	jmp    c0101e20 <__alltraps>

c0102177 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102177:	6a 00                	push   $0x0
  pushl $93
c0102179:	6a 5d                	push   $0x5d
  jmp __alltraps
c010217b:	e9 a0 fc ff ff       	jmp    c0101e20 <__alltraps>

c0102180 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102180:	6a 00                	push   $0x0
  pushl $94
c0102182:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102184:	e9 97 fc ff ff       	jmp    c0101e20 <__alltraps>

c0102189 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102189:	6a 00                	push   $0x0
  pushl $95
c010218b:	6a 5f                	push   $0x5f
  jmp __alltraps
c010218d:	e9 8e fc ff ff       	jmp    c0101e20 <__alltraps>

c0102192 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102192:	6a 00                	push   $0x0
  pushl $96
c0102194:	6a 60                	push   $0x60
  jmp __alltraps
c0102196:	e9 85 fc ff ff       	jmp    c0101e20 <__alltraps>

c010219b <vector97>:
.globl vector97
vector97:
  pushl $0
c010219b:	6a 00                	push   $0x0
  pushl $97
c010219d:	6a 61                	push   $0x61
  jmp __alltraps
c010219f:	e9 7c fc ff ff       	jmp    c0101e20 <__alltraps>

c01021a4 <vector98>:
.globl vector98
vector98:
  pushl $0
c01021a4:	6a 00                	push   $0x0
  pushl $98
c01021a6:	6a 62                	push   $0x62
  jmp __alltraps
c01021a8:	e9 73 fc ff ff       	jmp    c0101e20 <__alltraps>

c01021ad <vector99>:
.globl vector99
vector99:
  pushl $0
c01021ad:	6a 00                	push   $0x0
  pushl $99
c01021af:	6a 63                	push   $0x63
  jmp __alltraps
c01021b1:	e9 6a fc ff ff       	jmp    c0101e20 <__alltraps>

c01021b6 <vector100>:
.globl vector100
vector100:
  pushl $0
c01021b6:	6a 00                	push   $0x0
  pushl $100
c01021b8:	6a 64                	push   $0x64
  jmp __alltraps
c01021ba:	e9 61 fc ff ff       	jmp    c0101e20 <__alltraps>

c01021bf <vector101>:
.globl vector101
vector101:
  pushl $0
c01021bf:	6a 00                	push   $0x0
  pushl $101
c01021c1:	6a 65                	push   $0x65
  jmp __alltraps
c01021c3:	e9 58 fc ff ff       	jmp    c0101e20 <__alltraps>

c01021c8 <vector102>:
.globl vector102
vector102:
  pushl $0
c01021c8:	6a 00                	push   $0x0
  pushl $102
c01021ca:	6a 66                	push   $0x66
  jmp __alltraps
c01021cc:	e9 4f fc ff ff       	jmp    c0101e20 <__alltraps>

c01021d1 <vector103>:
.globl vector103
vector103:
  pushl $0
c01021d1:	6a 00                	push   $0x0
  pushl $103
c01021d3:	6a 67                	push   $0x67
  jmp __alltraps
c01021d5:	e9 46 fc ff ff       	jmp    c0101e20 <__alltraps>

c01021da <vector104>:
.globl vector104
vector104:
  pushl $0
c01021da:	6a 00                	push   $0x0
  pushl $104
c01021dc:	6a 68                	push   $0x68
  jmp __alltraps
c01021de:	e9 3d fc ff ff       	jmp    c0101e20 <__alltraps>

c01021e3 <vector105>:
.globl vector105
vector105:
  pushl $0
c01021e3:	6a 00                	push   $0x0
  pushl $105
c01021e5:	6a 69                	push   $0x69
  jmp __alltraps
c01021e7:	e9 34 fc ff ff       	jmp    c0101e20 <__alltraps>

c01021ec <vector106>:
.globl vector106
vector106:
  pushl $0
c01021ec:	6a 00                	push   $0x0
  pushl $106
c01021ee:	6a 6a                	push   $0x6a
  jmp __alltraps
c01021f0:	e9 2b fc ff ff       	jmp    c0101e20 <__alltraps>

c01021f5 <vector107>:
.globl vector107
vector107:
  pushl $0
c01021f5:	6a 00                	push   $0x0
  pushl $107
c01021f7:	6a 6b                	push   $0x6b
  jmp __alltraps
c01021f9:	e9 22 fc ff ff       	jmp    c0101e20 <__alltraps>

c01021fe <vector108>:
.globl vector108
vector108:
  pushl $0
c01021fe:	6a 00                	push   $0x0
  pushl $108
c0102200:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102202:	e9 19 fc ff ff       	jmp    c0101e20 <__alltraps>

c0102207 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102207:	6a 00                	push   $0x0
  pushl $109
c0102209:	6a 6d                	push   $0x6d
  jmp __alltraps
c010220b:	e9 10 fc ff ff       	jmp    c0101e20 <__alltraps>

c0102210 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102210:	6a 00                	push   $0x0
  pushl $110
c0102212:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102214:	e9 07 fc ff ff       	jmp    c0101e20 <__alltraps>

c0102219 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102219:	6a 00                	push   $0x0
  pushl $111
c010221b:	6a 6f                	push   $0x6f
  jmp __alltraps
c010221d:	e9 fe fb ff ff       	jmp    c0101e20 <__alltraps>

c0102222 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102222:	6a 00                	push   $0x0
  pushl $112
c0102224:	6a 70                	push   $0x70
  jmp __alltraps
c0102226:	e9 f5 fb ff ff       	jmp    c0101e20 <__alltraps>

c010222b <vector113>:
.globl vector113
vector113:
  pushl $0
c010222b:	6a 00                	push   $0x0
  pushl $113
c010222d:	6a 71                	push   $0x71
  jmp __alltraps
c010222f:	e9 ec fb ff ff       	jmp    c0101e20 <__alltraps>

c0102234 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102234:	6a 00                	push   $0x0
  pushl $114
c0102236:	6a 72                	push   $0x72
  jmp __alltraps
c0102238:	e9 e3 fb ff ff       	jmp    c0101e20 <__alltraps>

c010223d <vector115>:
.globl vector115
vector115:
  pushl $0
c010223d:	6a 00                	push   $0x0
  pushl $115
c010223f:	6a 73                	push   $0x73
  jmp __alltraps
c0102241:	e9 da fb ff ff       	jmp    c0101e20 <__alltraps>

c0102246 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102246:	6a 00                	push   $0x0
  pushl $116
c0102248:	6a 74                	push   $0x74
  jmp __alltraps
c010224a:	e9 d1 fb ff ff       	jmp    c0101e20 <__alltraps>

c010224f <vector117>:
.globl vector117
vector117:
  pushl $0
c010224f:	6a 00                	push   $0x0
  pushl $117
c0102251:	6a 75                	push   $0x75
  jmp __alltraps
c0102253:	e9 c8 fb ff ff       	jmp    c0101e20 <__alltraps>

c0102258 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102258:	6a 00                	push   $0x0
  pushl $118
c010225a:	6a 76                	push   $0x76
  jmp __alltraps
c010225c:	e9 bf fb ff ff       	jmp    c0101e20 <__alltraps>

c0102261 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102261:	6a 00                	push   $0x0
  pushl $119
c0102263:	6a 77                	push   $0x77
  jmp __alltraps
c0102265:	e9 b6 fb ff ff       	jmp    c0101e20 <__alltraps>

c010226a <vector120>:
.globl vector120
vector120:
  pushl $0
c010226a:	6a 00                	push   $0x0
  pushl $120
c010226c:	6a 78                	push   $0x78
  jmp __alltraps
c010226e:	e9 ad fb ff ff       	jmp    c0101e20 <__alltraps>

c0102273 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102273:	6a 00                	push   $0x0
  pushl $121
c0102275:	6a 79                	push   $0x79
  jmp __alltraps
c0102277:	e9 a4 fb ff ff       	jmp    c0101e20 <__alltraps>

c010227c <vector122>:
.globl vector122
vector122:
  pushl $0
c010227c:	6a 00                	push   $0x0
  pushl $122
c010227e:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102280:	e9 9b fb ff ff       	jmp    c0101e20 <__alltraps>

c0102285 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102285:	6a 00                	push   $0x0
  pushl $123
c0102287:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102289:	e9 92 fb ff ff       	jmp    c0101e20 <__alltraps>

c010228e <vector124>:
.globl vector124
vector124:
  pushl $0
c010228e:	6a 00                	push   $0x0
  pushl $124
c0102290:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102292:	e9 89 fb ff ff       	jmp    c0101e20 <__alltraps>

c0102297 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102297:	6a 00                	push   $0x0
  pushl $125
c0102299:	6a 7d                	push   $0x7d
  jmp __alltraps
c010229b:	e9 80 fb ff ff       	jmp    c0101e20 <__alltraps>

c01022a0 <vector126>:
.globl vector126
vector126:
  pushl $0
c01022a0:	6a 00                	push   $0x0
  pushl $126
c01022a2:	6a 7e                	push   $0x7e
  jmp __alltraps
c01022a4:	e9 77 fb ff ff       	jmp    c0101e20 <__alltraps>

c01022a9 <vector127>:
.globl vector127
vector127:
  pushl $0
c01022a9:	6a 00                	push   $0x0
  pushl $127
c01022ab:	6a 7f                	push   $0x7f
  jmp __alltraps
c01022ad:	e9 6e fb ff ff       	jmp    c0101e20 <__alltraps>

c01022b2 <vector128>:
.globl vector128
vector128:
  pushl $0
c01022b2:	6a 00                	push   $0x0
  pushl $128
c01022b4:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c01022b9:	e9 62 fb ff ff       	jmp    c0101e20 <__alltraps>

c01022be <vector129>:
.globl vector129
vector129:
  pushl $0
c01022be:	6a 00                	push   $0x0
  pushl $129
c01022c0:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c01022c5:	e9 56 fb ff ff       	jmp    c0101e20 <__alltraps>

c01022ca <vector130>:
.globl vector130
vector130:
  pushl $0
c01022ca:	6a 00                	push   $0x0
  pushl $130
c01022cc:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c01022d1:	e9 4a fb ff ff       	jmp    c0101e20 <__alltraps>

c01022d6 <vector131>:
.globl vector131
vector131:
  pushl $0
c01022d6:	6a 00                	push   $0x0
  pushl $131
c01022d8:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c01022dd:	e9 3e fb ff ff       	jmp    c0101e20 <__alltraps>

c01022e2 <vector132>:
.globl vector132
vector132:
  pushl $0
c01022e2:	6a 00                	push   $0x0
  pushl $132
c01022e4:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c01022e9:	e9 32 fb ff ff       	jmp    c0101e20 <__alltraps>

c01022ee <vector133>:
.globl vector133
vector133:
  pushl $0
c01022ee:	6a 00                	push   $0x0
  pushl $133
c01022f0:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c01022f5:	e9 26 fb ff ff       	jmp    c0101e20 <__alltraps>

c01022fa <vector134>:
.globl vector134
vector134:
  pushl $0
c01022fa:	6a 00                	push   $0x0
  pushl $134
c01022fc:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102301:	e9 1a fb ff ff       	jmp    c0101e20 <__alltraps>

c0102306 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102306:	6a 00                	push   $0x0
  pushl $135
c0102308:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c010230d:	e9 0e fb ff ff       	jmp    c0101e20 <__alltraps>

c0102312 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102312:	6a 00                	push   $0x0
  pushl $136
c0102314:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102319:	e9 02 fb ff ff       	jmp    c0101e20 <__alltraps>

c010231e <vector137>:
.globl vector137
vector137:
  pushl $0
c010231e:	6a 00                	push   $0x0
  pushl $137
c0102320:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102325:	e9 f6 fa ff ff       	jmp    c0101e20 <__alltraps>

c010232a <vector138>:
.globl vector138
vector138:
  pushl $0
c010232a:	6a 00                	push   $0x0
  pushl $138
c010232c:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102331:	e9 ea fa ff ff       	jmp    c0101e20 <__alltraps>

c0102336 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102336:	6a 00                	push   $0x0
  pushl $139
c0102338:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c010233d:	e9 de fa ff ff       	jmp    c0101e20 <__alltraps>

c0102342 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102342:	6a 00                	push   $0x0
  pushl $140
c0102344:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102349:	e9 d2 fa ff ff       	jmp    c0101e20 <__alltraps>

c010234e <vector141>:
.globl vector141
vector141:
  pushl $0
c010234e:	6a 00                	push   $0x0
  pushl $141
c0102350:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102355:	e9 c6 fa ff ff       	jmp    c0101e20 <__alltraps>

c010235a <vector142>:
.globl vector142
vector142:
  pushl $0
c010235a:	6a 00                	push   $0x0
  pushl $142
c010235c:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102361:	e9 ba fa ff ff       	jmp    c0101e20 <__alltraps>

c0102366 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102366:	6a 00                	push   $0x0
  pushl $143
c0102368:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c010236d:	e9 ae fa ff ff       	jmp    c0101e20 <__alltraps>

c0102372 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102372:	6a 00                	push   $0x0
  pushl $144
c0102374:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102379:	e9 a2 fa ff ff       	jmp    c0101e20 <__alltraps>

c010237e <vector145>:
.globl vector145
vector145:
  pushl $0
c010237e:	6a 00                	push   $0x0
  pushl $145
c0102380:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102385:	e9 96 fa ff ff       	jmp    c0101e20 <__alltraps>

c010238a <vector146>:
.globl vector146
vector146:
  pushl $0
c010238a:	6a 00                	push   $0x0
  pushl $146
c010238c:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102391:	e9 8a fa ff ff       	jmp    c0101e20 <__alltraps>

c0102396 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102396:	6a 00                	push   $0x0
  pushl $147
c0102398:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c010239d:	e9 7e fa ff ff       	jmp    c0101e20 <__alltraps>

c01023a2 <vector148>:
.globl vector148
vector148:
  pushl $0
c01023a2:	6a 00                	push   $0x0
  pushl $148
c01023a4:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c01023a9:	e9 72 fa ff ff       	jmp    c0101e20 <__alltraps>

c01023ae <vector149>:
.globl vector149
vector149:
  pushl $0
c01023ae:	6a 00                	push   $0x0
  pushl $149
c01023b0:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c01023b5:	e9 66 fa ff ff       	jmp    c0101e20 <__alltraps>

c01023ba <vector150>:
.globl vector150
vector150:
  pushl $0
c01023ba:	6a 00                	push   $0x0
  pushl $150
c01023bc:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c01023c1:	e9 5a fa ff ff       	jmp    c0101e20 <__alltraps>

c01023c6 <vector151>:
.globl vector151
vector151:
  pushl $0
c01023c6:	6a 00                	push   $0x0
  pushl $151
c01023c8:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c01023cd:	e9 4e fa ff ff       	jmp    c0101e20 <__alltraps>

c01023d2 <vector152>:
.globl vector152
vector152:
  pushl $0
c01023d2:	6a 00                	push   $0x0
  pushl $152
c01023d4:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c01023d9:	e9 42 fa ff ff       	jmp    c0101e20 <__alltraps>

c01023de <vector153>:
.globl vector153
vector153:
  pushl $0
c01023de:	6a 00                	push   $0x0
  pushl $153
c01023e0:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c01023e5:	e9 36 fa ff ff       	jmp    c0101e20 <__alltraps>

c01023ea <vector154>:
.globl vector154
vector154:
  pushl $0
c01023ea:	6a 00                	push   $0x0
  pushl $154
c01023ec:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c01023f1:	e9 2a fa ff ff       	jmp    c0101e20 <__alltraps>

c01023f6 <vector155>:
.globl vector155
vector155:
  pushl $0
c01023f6:	6a 00                	push   $0x0
  pushl $155
c01023f8:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c01023fd:	e9 1e fa ff ff       	jmp    c0101e20 <__alltraps>

c0102402 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102402:	6a 00                	push   $0x0
  pushl $156
c0102404:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102409:	e9 12 fa ff ff       	jmp    c0101e20 <__alltraps>

c010240e <vector157>:
.globl vector157
vector157:
  pushl $0
c010240e:	6a 00                	push   $0x0
  pushl $157
c0102410:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102415:	e9 06 fa ff ff       	jmp    c0101e20 <__alltraps>

c010241a <vector158>:
.globl vector158
vector158:
  pushl $0
c010241a:	6a 00                	push   $0x0
  pushl $158
c010241c:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102421:	e9 fa f9 ff ff       	jmp    c0101e20 <__alltraps>

c0102426 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102426:	6a 00                	push   $0x0
  pushl $159
c0102428:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c010242d:	e9 ee f9 ff ff       	jmp    c0101e20 <__alltraps>

c0102432 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102432:	6a 00                	push   $0x0
  pushl $160
c0102434:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102439:	e9 e2 f9 ff ff       	jmp    c0101e20 <__alltraps>

c010243e <vector161>:
.globl vector161
vector161:
  pushl $0
c010243e:	6a 00                	push   $0x0
  pushl $161
c0102440:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102445:	e9 d6 f9 ff ff       	jmp    c0101e20 <__alltraps>

c010244a <vector162>:
.globl vector162
vector162:
  pushl $0
c010244a:	6a 00                	push   $0x0
  pushl $162
c010244c:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102451:	e9 ca f9 ff ff       	jmp    c0101e20 <__alltraps>

c0102456 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102456:	6a 00                	push   $0x0
  pushl $163
c0102458:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c010245d:	e9 be f9 ff ff       	jmp    c0101e20 <__alltraps>

c0102462 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102462:	6a 00                	push   $0x0
  pushl $164
c0102464:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102469:	e9 b2 f9 ff ff       	jmp    c0101e20 <__alltraps>

c010246e <vector165>:
.globl vector165
vector165:
  pushl $0
c010246e:	6a 00                	push   $0x0
  pushl $165
c0102470:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102475:	e9 a6 f9 ff ff       	jmp    c0101e20 <__alltraps>

c010247a <vector166>:
.globl vector166
vector166:
  pushl $0
c010247a:	6a 00                	push   $0x0
  pushl $166
c010247c:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102481:	e9 9a f9 ff ff       	jmp    c0101e20 <__alltraps>

c0102486 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102486:	6a 00                	push   $0x0
  pushl $167
c0102488:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c010248d:	e9 8e f9 ff ff       	jmp    c0101e20 <__alltraps>

c0102492 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102492:	6a 00                	push   $0x0
  pushl $168
c0102494:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102499:	e9 82 f9 ff ff       	jmp    c0101e20 <__alltraps>

c010249e <vector169>:
.globl vector169
vector169:
  pushl $0
c010249e:	6a 00                	push   $0x0
  pushl $169
c01024a0:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c01024a5:	e9 76 f9 ff ff       	jmp    c0101e20 <__alltraps>

c01024aa <vector170>:
.globl vector170
vector170:
  pushl $0
c01024aa:	6a 00                	push   $0x0
  pushl $170
c01024ac:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c01024b1:	e9 6a f9 ff ff       	jmp    c0101e20 <__alltraps>

c01024b6 <vector171>:
.globl vector171
vector171:
  pushl $0
c01024b6:	6a 00                	push   $0x0
  pushl $171
c01024b8:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c01024bd:	e9 5e f9 ff ff       	jmp    c0101e20 <__alltraps>

c01024c2 <vector172>:
.globl vector172
vector172:
  pushl $0
c01024c2:	6a 00                	push   $0x0
  pushl $172
c01024c4:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c01024c9:	e9 52 f9 ff ff       	jmp    c0101e20 <__alltraps>

c01024ce <vector173>:
.globl vector173
vector173:
  pushl $0
c01024ce:	6a 00                	push   $0x0
  pushl $173
c01024d0:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c01024d5:	e9 46 f9 ff ff       	jmp    c0101e20 <__alltraps>

c01024da <vector174>:
.globl vector174
vector174:
  pushl $0
c01024da:	6a 00                	push   $0x0
  pushl $174
c01024dc:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c01024e1:	e9 3a f9 ff ff       	jmp    c0101e20 <__alltraps>

c01024e6 <vector175>:
.globl vector175
vector175:
  pushl $0
c01024e6:	6a 00                	push   $0x0
  pushl $175
c01024e8:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c01024ed:	e9 2e f9 ff ff       	jmp    c0101e20 <__alltraps>

c01024f2 <vector176>:
.globl vector176
vector176:
  pushl $0
c01024f2:	6a 00                	push   $0x0
  pushl $176
c01024f4:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c01024f9:	e9 22 f9 ff ff       	jmp    c0101e20 <__alltraps>

c01024fe <vector177>:
.globl vector177
vector177:
  pushl $0
c01024fe:	6a 00                	push   $0x0
  pushl $177
c0102500:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102505:	e9 16 f9 ff ff       	jmp    c0101e20 <__alltraps>

c010250a <vector178>:
.globl vector178
vector178:
  pushl $0
c010250a:	6a 00                	push   $0x0
  pushl $178
c010250c:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102511:	e9 0a f9 ff ff       	jmp    c0101e20 <__alltraps>

c0102516 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102516:	6a 00                	push   $0x0
  pushl $179
c0102518:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c010251d:	e9 fe f8 ff ff       	jmp    c0101e20 <__alltraps>

c0102522 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102522:	6a 00                	push   $0x0
  pushl $180
c0102524:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102529:	e9 f2 f8 ff ff       	jmp    c0101e20 <__alltraps>

c010252e <vector181>:
.globl vector181
vector181:
  pushl $0
c010252e:	6a 00                	push   $0x0
  pushl $181
c0102530:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102535:	e9 e6 f8 ff ff       	jmp    c0101e20 <__alltraps>

c010253a <vector182>:
.globl vector182
vector182:
  pushl $0
c010253a:	6a 00                	push   $0x0
  pushl $182
c010253c:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102541:	e9 da f8 ff ff       	jmp    c0101e20 <__alltraps>

c0102546 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102546:	6a 00                	push   $0x0
  pushl $183
c0102548:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c010254d:	e9 ce f8 ff ff       	jmp    c0101e20 <__alltraps>

c0102552 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102552:	6a 00                	push   $0x0
  pushl $184
c0102554:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102559:	e9 c2 f8 ff ff       	jmp    c0101e20 <__alltraps>

c010255e <vector185>:
.globl vector185
vector185:
  pushl $0
c010255e:	6a 00                	push   $0x0
  pushl $185
c0102560:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102565:	e9 b6 f8 ff ff       	jmp    c0101e20 <__alltraps>

c010256a <vector186>:
.globl vector186
vector186:
  pushl $0
c010256a:	6a 00                	push   $0x0
  pushl $186
c010256c:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102571:	e9 aa f8 ff ff       	jmp    c0101e20 <__alltraps>

c0102576 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102576:	6a 00                	push   $0x0
  pushl $187
c0102578:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c010257d:	e9 9e f8 ff ff       	jmp    c0101e20 <__alltraps>

c0102582 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102582:	6a 00                	push   $0x0
  pushl $188
c0102584:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102589:	e9 92 f8 ff ff       	jmp    c0101e20 <__alltraps>

c010258e <vector189>:
.globl vector189
vector189:
  pushl $0
c010258e:	6a 00                	push   $0x0
  pushl $189
c0102590:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102595:	e9 86 f8 ff ff       	jmp    c0101e20 <__alltraps>

c010259a <vector190>:
.globl vector190
vector190:
  pushl $0
c010259a:	6a 00                	push   $0x0
  pushl $190
c010259c:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01025a1:	e9 7a f8 ff ff       	jmp    c0101e20 <__alltraps>

c01025a6 <vector191>:
.globl vector191
vector191:
  pushl $0
c01025a6:	6a 00                	push   $0x0
  pushl $191
c01025a8:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c01025ad:	e9 6e f8 ff ff       	jmp    c0101e20 <__alltraps>

c01025b2 <vector192>:
.globl vector192
vector192:
  pushl $0
c01025b2:	6a 00                	push   $0x0
  pushl $192
c01025b4:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c01025b9:	e9 62 f8 ff ff       	jmp    c0101e20 <__alltraps>

c01025be <vector193>:
.globl vector193
vector193:
  pushl $0
c01025be:	6a 00                	push   $0x0
  pushl $193
c01025c0:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c01025c5:	e9 56 f8 ff ff       	jmp    c0101e20 <__alltraps>

c01025ca <vector194>:
.globl vector194
vector194:
  pushl $0
c01025ca:	6a 00                	push   $0x0
  pushl $194
c01025cc:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c01025d1:	e9 4a f8 ff ff       	jmp    c0101e20 <__alltraps>

c01025d6 <vector195>:
.globl vector195
vector195:
  pushl $0
c01025d6:	6a 00                	push   $0x0
  pushl $195
c01025d8:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c01025dd:	e9 3e f8 ff ff       	jmp    c0101e20 <__alltraps>

c01025e2 <vector196>:
.globl vector196
vector196:
  pushl $0
c01025e2:	6a 00                	push   $0x0
  pushl $196
c01025e4:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c01025e9:	e9 32 f8 ff ff       	jmp    c0101e20 <__alltraps>

c01025ee <vector197>:
.globl vector197
vector197:
  pushl $0
c01025ee:	6a 00                	push   $0x0
  pushl $197
c01025f0:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c01025f5:	e9 26 f8 ff ff       	jmp    c0101e20 <__alltraps>

c01025fa <vector198>:
.globl vector198
vector198:
  pushl $0
c01025fa:	6a 00                	push   $0x0
  pushl $198
c01025fc:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102601:	e9 1a f8 ff ff       	jmp    c0101e20 <__alltraps>

c0102606 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102606:	6a 00                	push   $0x0
  pushl $199
c0102608:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c010260d:	e9 0e f8 ff ff       	jmp    c0101e20 <__alltraps>

c0102612 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102612:	6a 00                	push   $0x0
  pushl $200
c0102614:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102619:	e9 02 f8 ff ff       	jmp    c0101e20 <__alltraps>

c010261e <vector201>:
.globl vector201
vector201:
  pushl $0
c010261e:	6a 00                	push   $0x0
  pushl $201
c0102620:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102625:	e9 f6 f7 ff ff       	jmp    c0101e20 <__alltraps>

c010262a <vector202>:
.globl vector202
vector202:
  pushl $0
c010262a:	6a 00                	push   $0x0
  pushl $202
c010262c:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102631:	e9 ea f7 ff ff       	jmp    c0101e20 <__alltraps>

c0102636 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102636:	6a 00                	push   $0x0
  pushl $203
c0102638:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c010263d:	e9 de f7 ff ff       	jmp    c0101e20 <__alltraps>

c0102642 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102642:	6a 00                	push   $0x0
  pushl $204
c0102644:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102649:	e9 d2 f7 ff ff       	jmp    c0101e20 <__alltraps>

c010264e <vector205>:
.globl vector205
vector205:
  pushl $0
c010264e:	6a 00                	push   $0x0
  pushl $205
c0102650:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102655:	e9 c6 f7 ff ff       	jmp    c0101e20 <__alltraps>

c010265a <vector206>:
.globl vector206
vector206:
  pushl $0
c010265a:	6a 00                	push   $0x0
  pushl $206
c010265c:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102661:	e9 ba f7 ff ff       	jmp    c0101e20 <__alltraps>

c0102666 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102666:	6a 00                	push   $0x0
  pushl $207
c0102668:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c010266d:	e9 ae f7 ff ff       	jmp    c0101e20 <__alltraps>

c0102672 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102672:	6a 00                	push   $0x0
  pushl $208
c0102674:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102679:	e9 a2 f7 ff ff       	jmp    c0101e20 <__alltraps>

c010267e <vector209>:
.globl vector209
vector209:
  pushl $0
c010267e:	6a 00                	push   $0x0
  pushl $209
c0102680:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102685:	e9 96 f7 ff ff       	jmp    c0101e20 <__alltraps>

c010268a <vector210>:
.globl vector210
vector210:
  pushl $0
c010268a:	6a 00                	push   $0x0
  pushl $210
c010268c:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102691:	e9 8a f7 ff ff       	jmp    c0101e20 <__alltraps>

c0102696 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102696:	6a 00                	push   $0x0
  pushl $211
c0102698:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c010269d:	e9 7e f7 ff ff       	jmp    c0101e20 <__alltraps>

c01026a2 <vector212>:
.globl vector212
vector212:
  pushl $0
c01026a2:	6a 00                	push   $0x0
  pushl $212
c01026a4:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01026a9:	e9 72 f7 ff ff       	jmp    c0101e20 <__alltraps>

c01026ae <vector213>:
.globl vector213
vector213:
  pushl $0
c01026ae:	6a 00                	push   $0x0
  pushl $213
c01026b0:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01026b5:	e9 66 f7 ff ff       	jmp    c0101e20 <__alltraps>

c01026ba <vector214>:
.globl vector214
vector214:
  pushl $0
c01026ba:	6a 00                	push   $0x0
  pushl $214
c01026bc:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c01026c1:	e9 5a f7 ff ff       	jmp    c0101e20 <__alltraps>

c01026c6 <vector215>:
.globl vector215
vector215:
  pushl $0
c01026c6:	6a 00                	push   $0x0
  pushl $215
c01026c8:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01026cd:	e9 4e f7 ff ff       	jmp    c0101e20 <__alltraps>

c01026d2 <vector216>:
.globl vector216
vector216:
  pushl $0
c01026d2:	6a 00                	push   $0x0
  pushl $216
c01026d4:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01026d9:	e9 42 f7 ff ff       	jmp    c0101e20 <__alltraps>

c01026de <vector217>:
.globl vector217
vector217:
  pushl $0
c01026de:	6a 00                	push   $0x0
  pushl $217
c01026e0:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01026e5:	e9 36 f7 ff ff       	jmp    c0101e20 <__alltraps>

c01026ea <vector218>:
.globl vector218
vector218:
  pushl $0
c01026ea:	6a 00                	push   $0x0
  pushl $218
c01026ec:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c01026f1:	e9 2a f7 ff ff       	jmp    c0101e20 <__alltraps>

c01026f6 <vector219>:
.globl vector219
vector219:
  pushl $0
c01026f6:	6a 00                	push   $0x0
  pushl $219
c01026f8:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c01026fd:	e9 1e f7 ff ff       	jmp    c0101e20 <__alltraps>

c0102702 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102702:	6a 00                	push   $0x0
  pushl $220
c0102704:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102709:	e9 12 f7 ff ff       	jmp    c0101e20 <__alltraps>

c010270e <vector221>:
.globl vector221
vector221:
  pushl $0
c010270e:	6a 00                	push   $0x0
  pushl $221
c0102710:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102715:	e9 06 f7 ff ff       	jmp    c0101e20 <__alltraps>

c010271a <vector222>:
.globl vector222
vector222:
  pushl $0
c010271a:	6a 00                	push   $0x0
  pushl $222
c010271c:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102721:	e9 fa f6 ff ff       	jmp    c0101e20 <__alltraps>

c0102726 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102726:	6a 00                	push   $0x0
  pushl $223
c0102728:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c010272d:	e9 ee f6 ff ff       	jmp    c0101e20 <__alltraps>

c0102732 <vector224>:
.globl vector224
vector224:
  pushl $0
c0102732:	6a 00                	push   $0x0
  pushl $224
c0102734:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102739:	e9 e2 f6 ff ff       	jmp    c0101e20 <__alltraps>

c010273e <vector225>:
.globl vector225
vector225:
  pushl $0
c010273e:	6a 00                	push   $0x0
  pushl $225
c0102740:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0102745:	e9 d6 f6 ff ff       	jmp    c0101e20 <__alltraps>

c010274a <vector226>:
.globl vector226
vector226:
  pushl $0
c010274a:	6a 00                	push   $0x0
  pushl $226
c010274c:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102751:	e9 ca f6 ff ff       	jmp    c0101e20 <__alltraps>

c0102756 <vector227>:
.globl vector227
vector227:
  pushl $0
c0102756:	6a 00                	push   $0x0
  pushl $227
c0102758:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c010275d:	e9 be f6 ff ff       	jmp    c0101e20 <__alltraps>

c0102762 <vector228>:
.globl vector228
vector228:
  pushl $0
c0102762:	6a 00                	push   $0x0
  pushl $228
c0102764:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102769:	e9 b2 f6 ff ff       	jmp    c0101e20 <__alltraps>

c010276e <vector229>:
.globl vector229
vector229:
  pushl $0
c010276e:	6a 00                	push   $0x0
  pushl $229
c0102770:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0102775:	e9 a6 f6 ff ff       	jmp    c0101e20 <__alltraps>

c010277a <vector230>:
.globl vector230
vector230:
  pushl $0
c010277a:	6a 00                	push   $0x0
  pushl $230
c010277c:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102781:	e9 9a f6 ff ff       	jmp    c0101e20 <__alltraps>

c0102786 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102786:	6a 00                	push   $0x0
  pushl $231
c0102788:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c010278d:	e9 8e f6 ff ff       	jmp    c0101e20 <__alltraps>

c0102792 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102792:	6a 00                	push   $0x0
  pushl $232
c0102794:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102799:	e9 82 f6 ff ff       	jmp    c0101e20 <__alltraps>

c010279e <vector233>:
.globl vector233
vector233:
  pushl $0
c010279e:	6a 00                	push   $0x0
  pushl $233
c01027a0:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01027a5:	e9 76 f6 ff ff       	jmp    c0101e20 <__alltraps>

c01027aa <vector234>:
.globl vector234
vector234:
  pushl $0
c01027aa:	6a 00                	push   $0x0
  pushl $234
c01027ac:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01027b1:	e9 6a f6 ff ff       	jmp    c0101e20 <__alltraps>

c01027b6 <vector235>:
.globl vector235
vector235:
  pushl $0
c01027b6:	6a 00                	push   $0x0
  pushl $235
c01027b8:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01027bd:	e9 5e f6 ff ff       	jmp    c0101e20 <__alltraps>

c01027c2 <vector236>:
.globl vector236
vector236:
  pushl $0
c01027c2:	6a 00                	push   $0x0
  pushl $236
c01027c4:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01027c9:	e9 52 f6 ff ff       	jmp    c0101e20 <__alltraps>

c01027ce <vector237>:
.globl vector237
vector237:
  pushl $0
c01027ce:	6a 00                	push   $0x0
  pushl $237
c01027d0:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01027d5:	e9 46 f6 ff ff       	jmp    c0101e20 <__alltraps>

c01027da <vector238>:
.globl vector238
vector238:
  pushl $0
c01027da:	6a 00                	push   $0x0
  pushl $238
c01027dc:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01027e1:	e9 3a f6 ff ff       	jmp    c0101e20 <__alltraps>

c01027e6 <vector239>:
.globl vector239
vector239:
  pushl $0
c01027e6:	6a 00                	push   $0x0
  pushl $239
c01027e8:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01027ed:	e9 2e f6 ff ff       	jmp    c0101e20 <__alltraps>

c01027f2 <vector240>:
.globl vector240
vector240:
  pushl $0
c01027f2:	6a 00                	push   $0x0
  pushl $240
c01027f4:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c01027f9:	e9 22 f6 ff ff       	jmp    c0101e20 <__alltraps>

c01027fe <vector241>:
.globl vector241
vector241:
  pushl $0
c01027fe:	6a 00                	push   $0x0
  pushl $241
c0102800:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102805:	e9 16 f6 ff ff       	jmp    c0101e20 <__alltraps>

c010280a <vector242>:
.globl vector242
vector242:
  pushl $0
c010280a:	6a 00                	push   $0x0
  pushl $242
c010280c:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102811:	e9 0a f6 ff ff       	jmp    c0101e20 <__alltraps>

c0102816 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102816:	6a 00                	push   $0x0
  pushl $243
c0102818:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010281d:	e9 fe f5 ff ff       	jmp    c0101e20 <__alltraps>

c0102822 <vector244>:
.globl vector244
vector244:
  pushl $0
c0102822:	6a 00                	push   $0x0
  pushl $244
c0102824:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102829:	e9 f2 f5 ff ff       	jmp    c0101e20 <__alltraps>

c010282e <vector245>:
.globl vector245
vector245:
  pushl $0
c010282e:	6a 00                	push   $0x0
  pushl $245
c0102830:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102835:	e9 e6 f5 ff ff       	jmp    c0101e20 <__alltraps>

c010283a <vector246>:
.globl vector246
vector246:
  pushl $0
c010283a:	6a 00                	push   $0x0
  pushl $246
c010283c:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102841:	e9 da f5 ff ff       	jmp    c0101e20 <__alltraps>

c0102846 <vector247>:
.globl vector247
vector247:
  pushl $0
c0102846:	6a 00                	push   $0x0
  pushl $247
c0102848:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c010284d:	e9 ce f5 ff ff       	jmp    c0101e20 <__alltraps>

c0102852 <vector248>:
.globl vector248
vector248:
  pushl $0
c0102852:	6a 00                	push   $0x0
  pushl $248
c0102854:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0102859:	e9 c2 f5 ff ff       	jmp    c0101e20 <__alltraps>

c010285e <vector249>:
.globl vector249
vector249:
  pushl $0
c010285e:	6a 00                	push   $0x0
  pushl $249
c0102860:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102865:	e9 b6 f5 ff ff       	jmp    c0101e20 <__alltraps>

c010286a <vector250>:
.globl vector250
vector250:
  pushl $0
c010286a:	6a 00                	push   $0x0
  pushl $250
c010286c:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102871:	e9 aa f5 ff ff       	jmp    c0101e20 <__alltraps>

c0102876 <vector251>:
.globl vector251
vector251:
  pushl $0
c0102876:	6a 00                	push   $0x0
  pushl $251
c0102878:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c010287d:	e9 9e f5 ff ff       	jmp    c0101e20 <__alltraps>

c0102882 <vector252>:
.globl vector252
vector252:
  pushl $0
c0102882:	6a 00                	push   $0x0
  pushl $252
c0102884:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102889:	e9 92 f5 ff ff       	jmp    c0101e20 <__alltraps>

c010288e <vector253>:
.globl vector253
vector253:
  pushl $0
c010288e:	6a 00                	push   $0x0
  pushl $253
c0102890:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102895:	e9 86 f5 ff ff       	jmp    c0101e20 <__alltraps>

c010289a <vector254>:
.globl vector254
vector254:
  pushl $0
c010289a:	6a 00                	push   $0x0
  pushl $254
c010289c:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01028a1:	e9 7a f5 ff ff       	jmp    c0101e20 <__alltraps>

c01028a6 <vector255>:
.globl vector255
vector255:
  pushl $0
c01028a6:	6a 00                	push   $0x0
  pushl $255
c01028a8:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01028ad:	e9 6e f5 ff ff       	jmp    c0101e20 <__alltraps>

c01028b2 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01028b2:	55                   	push   %ebp
c01028b3:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01028b5:	8b 55 08             	mov    0x8(%ebp),%edx
c01028b8:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c01028bd:	29 c2                	sub    %eax,%edx
c01028bf:	89 d0                	mov    %edx,%eax
c01028c1:	c1 f8 02             	sar    $0x2,%eax
c01028c4:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01028ca:	5d                   	pop    %ebp
c01028cb:	c3                   	ret    

c01028cc <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01028cc:	55                   	push   %ebp
c01028cd:	89 e5                	mov    %esp,%ebp
c01028cf:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01028d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01028d5:	89 04 24             	mov    %eax,(%esp)
c01028d8:	e8 d5 ff ff ff       	call   c01028b2 <page2ppn>
c01028dd:	c1 e0 0c             	shl    $0xc,%eax
}
c01028e0:	c9                   	leave  
c01028e1:	c3                   	ret    

c01028e2 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c01028e2:	55                   	push   %ebp
c01028e3:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01028e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01028e8:	8b 00                	mov    (%eax),%eax
}
c01028ea:	5d                   	pop    %ebp
c01028eb:	c3                   	ret    

c01028ec <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01028ec:	55                   	push   %ebp
c01028ed:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01028ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01028f2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01028f5:	89 10                	mov    %edx,(%eax)
}
c01028f7:	5d                   	pop    %ebp
c01028f8:	c3                   	ret    

c01028f9 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c01028f9:	55                   	push   %ebp
c01028fa:	89 e5                	mov    %esp,%ebp
c01028fc:	83 ec 10             	sub    $0x10,%esp
c01028ff:	c7 45 fc 50 89 11 c0 	movl   $0xc0118950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0102906:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102909:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010290c:	89 50 04             	mov    %edx,0x4(%eax)
c010290f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102912:	8b 50 04             	mov    0x4(%eax),%edx
c0102915:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102918:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c010291a:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c0102921:	00 00 00 
}
c0102924:	c9                   	leave  
c0102925:	c3                   	ret    

c0102926 <default_init_memmap>:

static void
default_init_memmap(struct Page* base, size_t n) {
c0102926:	55                   	push   %ebp
c0102927:	89 e5                	mov    %esp,%ebp
c0102929:	83 ec 48             	sub    $0x48,%esp
	assert(n > 0);
c010292c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102930:	75 24                	jne    c0102956 <default_init_memmap+0x30>
c0102932:	c7 44 24 0c b0 66 10 	movl   $0xc01066b0,0xc(%esp)
c0102939:	c0 
c010293a:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0102941:	c0 
c0102942:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c0102949:	00 
c010294a:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0102951:	e8 70 e3 ff ff       	call   c0100cc6 <__panic>
	struct Page* p = base;
c0102956:	8b 45 08             	mov    0x8(%ebp),%eax
c0102959:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (; p != base + n; p++) {
c010295c:	e9 dc 00 00 00       	jmp    c0102a3d <default_init_memmap+0x117>
		assert(PageReserved(p));
c0102961:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102964:	83 c0 04             	add    $0x4,%eax
c0102967:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c010296e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102971:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102974:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102977:	0f a3 10             	bt     %edx,(%eax)
c010297a:	19 c0                	sbb    %eax,%eax
c010297c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c010297f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0102983:	0f 95 c0             	setne  %al
c0102986:	0f b6 c0             	movzbl %al,%eax
c0102989:	85 c0                	test   %eax,%eax
c010298b:	75 24                	jne    c01029b1 <default_init_memmap+0x8b>
c010298d:	c7 44 24 0c e1 66 10 	movl   $0xc01066e1,0xc(%esp)
c0102994:	c0 
c0102995:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c010299c:	c0 
c010299d:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c01029a4:	00 
c01029a5:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01029ac:	e8 15 e3 ff ff       	call   c0100cc6 <__panic>
		p->flags = 0;
c01029b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
		SetPageProperty(p);
c01029bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029be:	83 c0 04             	add    $0x4,%eax
c01029c1:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c01029c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01029cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01029ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01029d1:	0f ab 10             	bts    %edx,(%eax)
		p->property = 0;
c01029d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029d7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		set_page_ref(p, 0);
c01029de:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01029e5:	00 
c01029e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029e9:	89 04 24             	mov    %eax,(%esp)
c01029ec:	e8 fb fe ff ff       	call   c01028ec <set_page_ref>
		list_add_before(&free_list, &(p->page_link));
c01029f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029f4:	83 c0 0c             	add    $0xc,%eax
c01029f7:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
c01029fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102a01:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102a04:	8b 00                	mov    (%eax),%eax
c0102a06:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102a09:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102a0c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102a0f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102a12:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102a15:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a18:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102a1b:	89 10                	mov    %edx,(%eax)
c0102a1d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a20:	8b 10                	mov    (%eax),%edx
c0102a22:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102a25:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102a28:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102a2b:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102a2e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102a31:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102a34:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102a37:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page* base, size_t n) {
	assert(n > 0);
	struct Page* p = base;
	for (; p != base + n; p++) {
c0102a39:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102a3d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a40:	89 d0                	mov    %edx,%eax
c0102a42:	c1 e0 02             	shl    $0x2,%eax
c0102a45:	01 d0                	add    %edx,%eax
c0102a47:	c1 e0 02             	shl    $0x2,%eax
c0102a4a:	89 c2                	mov    %eax,%edx
c0102a4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a4f:	01 d0                	add    %edx,%eax
c0102a51:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102a54:	0f 85 07 ff ff ff    	jne    c0102961 <default_init_memmap+0x3b>
		SetPageProperty(p);
		p->property = 0;
		set_page_ref(p, 0);
		list_add_before(&free_list, &(p->page_link));
	}
	nr_free += n;
c0102a5a:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c0102a60:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102a63:	01 d0                	add    %edx,%eax
c0102a65:	a3 58 89 11 c0       	mov    %eax,0xc0118958
	base->property = n;
c0102a6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a6d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a70:	89 50 08             	mov    %edx,0x8(%eax)
}
c0102a73:	c9                   	leave  
c0102a74:	c3                   	ret    

c0102a75 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0102a75:	55                   	push   %ebp
c0102a76:	89 e5                	mov    %esp,%ebp
c0102a78:	83 ec 68             	sub    $0x68,%esp
	assert(n > 0);//判断n是否异常
c0102a7b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102a7f:	75 24                	jne    c0102aa5 <default_alloc_pages+0x30>
c0102a81:	c7 44 24 0c b0 66 10 	movl   $0xc01066b0,0xc(%esp)
c0102a88:	c0 
c0102a89:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0102a90:	c0 
c0102a91:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
c0102a98:	00 
c0102a99:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0102aa0:	e8 21 e2 ff ff       	call   c0100cc6 <__panic>
	if (n > nr_free) {
c0102aa5:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102aaa:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102aad:	73 0a                	jae    c0102ab9 <default_alloc_pages+0x44>
		return NULL;
c0102aaf:	b8 00 00 00 00       	mov    $0x0,%eax
c0102ab4:	e9 37 01 00 00       	jmp    c0102bf0 <default_alloc_pages+0x17b>
	}//如果n大于可分配页数直接返回null
	list_entry_t* le, * len;
	le = &free_list;
c0102ab9:	c7 45 f4 50 89 11 c0 	movl   $0xc0118950,-0xc(%ebp)

	while ((le = list_next(le)) != &free_list) {//遍历空闲页链表每一页，找到符合条件的第一个页first-fit
c0102ac0:	e9 0a 01 00 00       	jmp    c0102bcf <default_alloc_pages+0x15a>
		struct Page* p = le2page(le, page_link);
c0102ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ac8:	83 e8 0c             	sub    $0xc,%eax
c0102acb:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (p->property >= n) {//找到，p->property >= n
c0102ace:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ad1:	8b 40 08             	mov    0x8(%eax),%eax
c0102ad4:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102ad7:	0f 82 f2 00 00 00    	jb     c0102bcf <default_alloc_pages+0x15a>
			int i;
			for (i = 0; i < n; i++) {//将即将要分配的页标志为已使用，并清零property
c0102add:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102ae4:	eb 7c                	jmp    c0102b62 <default_alloc_pages+0xed>
c0102ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ae9:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102aec:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102aef:	8b 40 04             	mov    0x4(%eax),%eax
				len = list_next(le);
c0102af2:	89 45 e8             	mov    %eax,-0x18(%ebp)
				struct Page* pp = le2page(le, page_link);
c0102af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102af8:	83 e8 0c             	sub    $0xc,%eax
c0102afb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				SetPageReserved(pp);//标记
c0102afe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102b01:	83 c0 04             	add    $0x4,%eax
c0102b04:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102b0b:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0102b0e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102b11:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102b14:	0f ab 10             	bts    %edx,(%eax)
				ClearPageProperty(pp);
c0102b17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102b1a:	83 c0 04             	add    $0x4,%eax
c0102b1d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0102b24:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102b27:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102b2a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102b2d:	0f b3 10             	btr    %edx,(%eax)
c0102b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b33:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102b36:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102b39:	8b 40 04             	mov    0x4(%eax),%eax
c0102b3c:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102b3f:	8b 12                	mov    (%edx),%edx
c0102b41:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0102b44:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102b47:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102b4a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102b4d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102b50:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102b53:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102b56:	89 10                	mov    %edx,(%eax)
				list_del(le);//将该页从链表移出去
				le = len;
c0102b58:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102b5b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while ((le = list_next(le)) != &free_list) {//遍历空闲页链表每一页，找到符合条件的第一个页first-fit
		struct Page* p = le2page(le, page_link);
		if (p->property >= n) {//找到，p->property >= n
			int i;
			for (i = 0; i < n; i++) {//将即将要分配的页标志为已使用，并清零property
c0102b5e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c0102b62:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b65:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102b68:	0f 82 78 ff ff ff    	jb     c0102ae6 <default_alloc_pages+0x71>
				SetPageReserved(pp);//标记
				ClearPageProperty(pp);
				list_del(le);//将该页从链表移出去
				le = len;
			}
			if (p->property > n) {//如果有外碎片
c0102b6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b71:	8b 40 08             	mov    0x8(%eax),%eax
c0102b74:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102b77:	76 12                	jbe    c0102b8b <default_alloc_pages+0x116>
				(le2page(le, page_link))->property = p->property - n;//置外碎片首页property为剩余数目
c0102b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b7c:	8d 50 f4             	lea    -0xc(%eax),%edx
c0102b7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b82:	8b 40 08             	mov    0x8(%eax),%eax
c0102b85:	2b 45 08             	sub    0x8(%ebp),%eax
c0102b88:	89 42 08             	mov    %eax,0x8(%edx)
			}
			ClearPageProperty(p);
c0102b8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b8e:	83 c0 04             	add    $0x4,%eax
c0102b91:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0102b98:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0102b9b:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102b9e:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102ba1:	0f b3 10             	btr    %edx,(%eax)
			SetPageReserved(p);
c0102ba4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ba7:	83 c0 04             	add    $0x4,%eax
c0102baa:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
c0102bb1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102bb4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102bb7:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102bba:	0f ab 10             	bts    %edx,(%eax)
			nr_free -= n;//更新空闲页链表页数
c0102bbd:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102bc2:	2b 45 08             	sub    0x8(%ebp),%eax
c0102bc5:	a3 58 89 11 c0       	mov    %eax,0xc0118958
			return p;
c0102bca:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102bcd:	eb 21                	jmp    c0102bf0 <default_alloc_pages+0x17b>
c0102bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bd2:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102bd5:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102bd8:	8b 40 04             	mov    0x4(%eax),%eax
		return NULL;
	}//如果n大于可分配页数直接返回null
	list_entry_t* le, * len;
	le = &free_list;

	while ((le = list_next(le)) != &free_list) {//遍历空闲页链表每一页，找到符合条件的第一个页first-fit
c0102bdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102bde:	81 7d f4 50 89 11 c0 	cmpl   $0xc0118950,-0xc(%ebp)
c0102be5:	0f 85 da fe ff ff    	jne    c0102ac5 <default_alloc_pages+0x50>
			SetPageReserved(p);
			nr_free -= n;//更新空闲页链表页数
			return p;
		}
	}
	return NULL;//找不到合适的返回null
c0102beb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102bf0:	c9                   	leave  
c0102bf1:	c3                   	ret    

c0102bf2 <default_free_pages>:


static void
default_free_pages(struct Page* base, size_t n) {
c0102bf2:	55                   	push   %ebp
c0102bf3:	89 e5                	mov    %esp,%ebp
c0102bf5:	83 ec 68             	sub    $0x68,%esp
	assert(n > 0);
c0102bf8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102bfc:	75 24                	jne    c0102c22 <default_free_pages+0x30>
c0102bfe:	c7 44 24 0c b0 66 10 	movl   $0xc01066b0,0xc(%esp)
c0102c05:	c0 
c0102c06:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0102c0d:	c0 
c0102c0e:	c7 44 24 04 78 00 00 	movl   $0x78,0x4(%esp)
c0102c15:	00 
c0102c16:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0102c1d:	e8 a4 e0 ff ff       	call   c0100cc6 <__panic>
	assert(PageReserved(base));//如果是保留页就报错
c0102c22:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c25:	83 c0 04             	add    $0x4,%eax
c0102c28:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102c2f:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102c32:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102c35:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102c38:	0f a3 10             	bt     %edx,(%eax)
c0102c3b:	19 c0                	sbb    %eax,%eax
c0102c3d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0102c40:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102c44:	0f 95 c0             	setne  %al
c0102c47:	0f b6 c0             	movzbl %al,%eax
c0102c4a:	85 c0                	test   %eax,%eax
c0102c4c:	75 24                	jne    c0102c72 <default_free_pages+0x80>
c0102c4e:	c7 44 24 0c f1 66 10 	movl   $0xc01066f1,0xc(%esp)
c0102c55:	c0 
c0102c56:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0102c5d:	c0 
c0102c5e:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
c0102c65:	00 
c0102c66:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0102c6d:	e8 54 e0 ff ff       	call   c0100cc6 <__panic>
	list_entry_t* le = &free_list;
c0102c72:	c7 45 f4 50 89 11 c0 	movl   $0xc0118950,-0xc(%ebp)
	struct Page* p;
	while ((le = list_next(le)) != &free_list) {//遍历空闲页链表，根据地址按序找到插入点
c0102c79:	eb 13                	jmp    c0102c8e <default_free_pages+0x9c>
		p = le2page(le, page_link);
c0102c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c7e:	83 e8 0c             	sub    $0xc,%eax
c0102c81:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (p > base) {
c0102c84:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102c87:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102c8a:	76 02                	jbe    c0102c8e <default_free_pages+0x9c>
			break;
c0102c8c:	eb 18                	jmp    c0102ca6 <default_free_pages+0xb4>
c0102c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c91:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102c94:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102c97:	8b 40 04             	mov    0x4(%eax),%eax
default_free_pages(struct Page* base, size_t n) {
	assert(n > 0);
	assert(PageReserved(base));//如果是保留页就报错
	list_entry_t* le = &free_list;
	struct Page* p;
	while ((le = list_next(le)) != &free_list) {//遍历空闲页链表，根据地址按序找到插入点
c0102c9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102c9d:	81 7d f4 50 89 11 c0 	cmpl   $0xc0118950,-0xc(%ebp)
c0102ca4:	75 d5                	jne    c0102c7b <default_free_pages+0x89>
		p = le2page(le, page_link);
		if (p > base) {
			break;
		}
	}
	for (p = base; p < base + n; p++) {
c0102ca6:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ca9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102cac:	eb 4b                	jmp    c0102cf9 <default_free_pages+0x107>
		list_add_before(le, &(p->page_link));
c0102cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102cb1:	8d 50 0c             	lea    0xc(%eax),%edx
c0102cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cb7:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0102cba:	89 55 d8             	mov    %edx,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102cbd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102cc0:	8b 00                	mov    (%eax),%eax
c0102cc2:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102cc5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102cc8:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102ccb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102cce:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102cd1:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102cd4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102cd7:	89 10                	mov    %edx,(%eax)
c0102cd9:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102cdc:	8b 10                	mov    (%eax),%edx
c0102cde:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102ce1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102ce4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102ce7:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102cea:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102ced:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102cf0:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102cf3:	89 10                	mov    %edx,(%eax)
		p = le2page(le, page_link);
		if (p > base) {
			break;
		}
	}
	for (p = base; p < base + n; p++) {
c0102cf5:	83 45 f0 14          	addl   $0x14,-0x10(%ebp)
c0102cf9:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102cfc:	89 d0                	mov    %edx,%eax
c0102cfe:	c1 e0 02             	shl    $0x2,%eax
c0102d01:	01 d0                	add    %edx,%eax
c0102d03:	c1 e0 02             	shl    $0x2,%eax
c0102d06:	89 c2                	mov    %eax,%edx
c0102d08:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d0b:	01 d0                	add    %edx,%eax
c0102d0d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102d10:	77 9c                	ja     c0102cae <default_free_pages+0xbc>
		list_add_before(le, &(p->page_link));
	}//将base开始的n页插入
	base->flags = 0;
c0102d12:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d15:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	set_page_ref(base, 0);
c0102d1c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102d23:	00 
c0102d24:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d27:	89 04 24             	mov    %eax,(%esp)
c0102d2a:	e8 bd fb ff ff       	call   c01028ec <set_page_ref>
	ClearPageProperty(base);
c0102d2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d32:	83 c0 04             	add    $0x4,%eax
c0102d35:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0102d3c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102d3f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102d42:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102d45:	0f b3 10             	btr    %edx,(%eax)
	SetPageProperty(base);//初始化插入的页
c0102d48:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d4b:	83 c0 04             	add    $0x4,%eax
c0102d4e:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0102d55:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102d58:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102d5b:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102d5e:	0f ab 10             	bts    %edx,(%eax)
	base->property = n;//将base的property置n
c0102d61:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d64:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d67:	89 50 08             	mov    %edx,0x8(%eax)

	p = le2page(le, page_link);//如果遇到连续可合并，进行合并
c0102d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d6d:	83 e8 0c             	sub    $0xc,%eax
c0102d70:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (base + n == p) {
c0102d73:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d76:	89 d0                	mov    %edx,%eax
c0102d78:	c1 e0 02             	shl    $0x2,%eax
c0102d7b:	01 d0                	add    %edx,%eax
c0102d7d:	c1 e0 02             	shl    $0x2,%eax
c0102d80:	89 c2                	mov    %eax,%edx
c0102d82:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d85:	01 d0                	add    %edx,%eax
c0102d87:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102d8a:	75 1e                	jne    c0102daa <default_free_pages+0x1b8>
		base->property += p->property;
c0102d8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d8f:	8b 50 08             	mov    0x8(%eax),%edx
c0102d92:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d95:	8b 40 08             	mov    0x8(%eax),%eax
c0102d98:	01 c2                	add    %eax,%edx
c0102d9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d9d:	89 50 08             	mov    %edx,0x8(%eax)
		p->property = 0;
c0102da0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102da3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	}
	le = list_prev(&(base->page_link));
c0102daa:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dad:	83 c0 0c             	add    $0xc,%eax
c0102db0:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0102db3:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102db6:	8b 00                	mov    (%eax),%eax
c0102db8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	p = le2page(le, page_link);
c0102dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dbe:	83 e8 0c             	sub    $0xc,%eax
c0102dc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (le != &free_list && p == base - 1) {
c0102dc4:	81 7d f4 50 89 11 c0 	cmpl   $0xc0118950,-0xc(%ebp)
c0102dcb:	74 57                	je     c0102e24 <default_free_pages+0x232>
c0102dcd:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dd0:	83 e8 14             	sub    $0x14,%eax
c0102dd3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102dd6:	75 4c                	jne    c0102e24 <default_free_pages+0x232>
		while (le != &free_list) {
c0102dd8:	eb 41                	jmp    c0102e1b <default_free_pages+0x229>
			if (p->property) {
c0102dda:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ddd:	8b 40 08             	mov    0x8(%eax),%eax
c0102de0:	85 c0                	test   %eax,%eax
c0102de2:	74 20                	je     c0102e04 <default_free_pages+0x212>
				p->property += base->property;
c0102de4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102de7:	8b 50 08             	mov    0x8(%eax),%edx
c0102dea:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ded:	8b 40 08             	mov    0x8(%eax),%eax
c0102df0:	01 c2                	add    %eax,%edx
c0102df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102df5:	89 50 08             	mov    %edx,0x8(%eax)
				base->property = 0;
c0102df8:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dfb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				break;
c0102e02:	eb 20                	jmp    c0102e24 <default_free_pages+0x232>
c0102e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e07:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0102e0a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102e0d:	8b 00                	mov    (%eax),%eax
			}
			le = list_prev(le);
c0102e0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
			p = le2page(le, page_link);
c0102e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e15:	83 e8 0c             	sub    $0xc,%eax
c0102e18:	89 45 f0             	mov    %eax,-0x10(%ebp)
		p->property = 0;
	}
	le = list_prev(&(base->page_link));
	p = le2page(le, page_link);
	if (le != &free_list && p == base - 1) {
		while (le != &free_list) {
c0102e1b:	81 7d f4 50 89 11 c0 	cmpl   $0xc0118950,-0xc(%ebp)
c0102e22:	75 b6                	jne    c0102dda <default_free_pages+0x1e8>
			le = list_prev(le);
			p = le2page(le, page_link);
		}
	}

	nr_free += n;
c0102e24:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c0102e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102e2d:	01 d0                	add    %edx,%eax
c0102e2f:	a3 58 89 11 c0       	mov    %eax,0xc0118958
	return;
c0102e34:	90                   	nop
}
c0102e35:	c9                   	leave  
c0102e36:	c3                   	ret    

c0102e37 <default_nr_free_pages>:
static size_t
default_nr_free_pages(void) {
c0102e37:	55                   	push   %ebp
c0102e38:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102e3a:	a1 58 89 11 c0       	mov    0xc0118958,%eax
}
c0102e3f:	5d                   	pop    %ebp
c0102e40:	c3                   	ret    

c0102e41 <basic_check>:

static void
basic_check(void) {
c0102e41:	55                   	push   %ebp
c0102e42:	89 e5                	mov    %esp,%ebp
c0102e44:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102e47:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102e4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e51:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102e54:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e57:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102e5a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102e61:	e8 85 0e 00 00       	call   c0103ceb <alloc_pages>
c0102e66:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102e69:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102e6d:	75 24                	jne    c0102e93 <basic_check+0x52>
c0102e6f:	c7 44 24 0c 04 67 10 	movl   $0xc0106704,0xc(%esp)
c0102e76:	c0 
c0102e77:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0102e7e:	c0 
c0102e7f:	c7 44 24 04 aa 00 00 	movl   $0xaa,0x4(%esp)
c0102e86:	00 
c0102e87:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0102e8e:	e8 33 de ff ff       	call   c0100cc6 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102e93:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102e9a:	e8 4c 0e 00 00       	call   c0103ceb <alloc_pages>
c0102e9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102ea2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102ea6:	75 24                	jne    c0102ecc <basic_check+0x8b>
c0102ea8:	c7 44 24 0c 20 67 10 	movl   $0xc0106720,0xc(%esp)
c0102eaf:	c0 
c0102eb0:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0102eb7:	c0 
c0102eb8:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
c0102ebf:	00 
c0102ec0:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0102ec7:	e8 fa dd ff ff       	call   c0100cc6 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102ecc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102ed3:	e8 13 0e 00 00       	call   c0103ceb <alloc_pages>
c0102ed8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102edb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102edf:	75 24                	jne    c0102f05 <basic_check+0xc4>
c0102ee1:	c7 44 24 0c 3c 67 10 	movl   $0xc010673c,0xc(%esp)
c0102ee8:	c0 
c0102ee9:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0102ef0:	c0 
c0102ef1:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
c0102ef8:	00 
c0102ef9:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0102f00:	e8 c1 dd ff ff       	call   c0100cc6 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0102f05:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f08:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102f0b:	74 10                	je     c0102f1d <basic_check+0xdc>
c0102f0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f10:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102f13:	74 08                	je     c0102f1d <basic_check+0xdc>
c0102f15:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f18:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102f1b:	75 24                	jne    c0102f41 <basic_check+0x100>
c0102f1d:	c7 44 24 0c 58 67 10 	movl   $0xc0106758,0xc(%esp)
c0102f24:	c0 
c0102f25:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0102f2c:	c0 
c0102f2d:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
c0102f34:	00 
c0102f35:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0102f3c:	e8 85 dd ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0102f41:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f44:	89 04 24             	mov    %eax,(%esp)
c0102f47:	e8 96 f9 ff ff       	call   c01028e2 <page_ref>
c0102f4c:	85 c0                	test   %eax,%eax
c0102f4e:	75 1e                	jne    c0102f6e <basic_check+0x12d>
c0102f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f53:	89 04 24             	mov    %eax,(%esp)
c0102f56:	e8 87 f9 ff ff       	call   c01028e2 <page_ref>
c0102f5b:	85 c0                	test   %eax,%eax
c0102f5d:	75 0f                	jne    c0102f6e <basic_check+0x12d>
c0102f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f62:	89 04 24             	mov    %eax,(%esp)
c0102f65:	e8 78 f9 ff ff       	call   c01028e2 <page_ref>
c0102f6a:	85 c0                	test   %eax,%eax
c0102f6c:	74 24                	je     c0102f92 <basic_check+0x151>
c0102f6e:	c7 44 24 0c 7c 67 10 	movl   $0xc010677c,0xc(%esp)
c0102f75:	c0 
c0102f76:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0102f7d:	c0 
c0102f7e:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
c0102f85:	00 
c0102f86:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0102f8d:	e8 34 dd ff ff       	call   c0100cc6 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0102f92:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f95:	89 04 24             	mov    %eax,(%esp)
c0102f98:	e8 2f f9 ff ff       	call   c01028cc <page2pa>
c0102f9d:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102fa3:	c1 e2 0c             	shl    $0xc,%edx
c0102fa6:	39 d0                	cmp    %edx,%eax
c0102fa8:	72 24                	jb     c0102fce <basic_check+0x18d>
c0102faa:	c7 44 24 0c b8 67 10 	movl   $0xc01067b8,0xc(%esp)
c0102fb1:	c0 
c0102fb2:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0102fb9:	c0 
c0102fba:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
c0102fc1:	00 
c0102fc2:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0102fc9:	e8 f8 dc ff ff       	call   c0100cc6 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0102fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102fd1:	89 04 24             	mov    %eax,(%esp)
c0102fd4:	e8 f3 f8 ff ff       	call   c01028cc <page2pa>
c0102fd9:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102fdf:	c1 e2 0c             	shl    $0xc,%edx
c0102fe2:	39 d0                	cmp    %edx,%eax
c0102fe4:	72 24                	jb     c010300a <basic_check+0x1c9>
c0102fe6:	c7 44 24 0c d5 67 10 	movl   $0xc01067d5,0xc(%esp)
c0102fed:	c0 
c0102fee:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0102ff5:	c0 
c0102ff6:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c0102ffd:	00 
c0102ffe:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103005:	e8 bc dc ff ff       	call   c0100cc6 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c010300a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010300d:	89 04 24             	mov    %eax,(%esp)
c0103010:	e8 b7 f8 ff ff       	call   c01028cc <page2pa>
c0103015:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c010301b:	c1 e2 0c             	shl    $0xc,%edx
c010301e:	39 d0                	cmp    %edx,%eax
c0103020:	72 24                	jb     c0103046 <basic_check+0x205>
c0103022:	c7 44 24 0c f2 67 10 	movl   $0xc01067f2,0xc(%esp)
c0103029:	c0 
c010302a:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103031:	c0 
c0103032:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
c0103039:	00 
c010303a:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103041:	e8 80 dc ff ff       	call   c0100cc6 <__panic>

    list_entry_t free_list_store = free_list;
c0103046:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c010304b:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c0103051:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103054:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103057:	c7 45 e0 50 89 11 c0 	movl   $0xc0118950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010305e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103061:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103064:	89 50 04             	mov    %edx,0x4(%eax)
c0103067:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010306a:	8b 50 04             	mov    0x4(%eax),%edx
c010306d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103070:	89 10                	mov    %edx,(%eax)
c0103072:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103079:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010307c:	8b 40 04             	mov    0x4(%eax),%eax
c010307f:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103082:	0f 94 c0             	sete   %al
c0103085:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103088:	85 c0                	test   %eax,%eax
c010308a:	75 24                	jne    c01030b0 <basic_check+0x26f>
c010308c:	c7 44 24 0c 0f 68 10 	movl   $0xc010680f,0xc(%esp)
c0103093:	c0 
c0103094:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c010309b:	c0 
c010309c:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
c01030a3:	00 
c01030a4:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01030ab:	e8 16 dc ff ff       	call   c0100cc6 <__panic>

    unsigned int nr_free_store = nr_free;
c01030b0:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c01030b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c01030b8:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c01030bf:	00 00 00 

    assert(alloc_page() == NULL);
c01030c2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01030c9:	e8 1d 0c 00 00       	call   c0103ceb <alloc_pages>
c01030ce:	85 c0                	test   %eax,%eax
c01030d0:	74 24                	je     c01030f6 <basic_check+0x2b5>
c01030d2:	c7 44 24 0c 26 68 10 	movl   $0xc0106826,0xc(%esp)
c01030d9:	c0 
c01030da:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01030e1:	c0 
c01030e2:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c01030e9:	00 
c01030ea:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01030f1:	e8 d0 db ff ff       	call   c0100cc6 <__panic>

    free_page(p0);
c01030f6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01030fd:	00 
c01030fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103101:	89 04 24             	mov    %eax,(%esp)
c0103104:	e8 1a 0c 00 00       	call   c0103d23 <free_pages>
    free_page(p1);
c0103109:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103110:	00 
c0103111:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103114:	89 04 24             	mov    %eax,(%esp)
c0103117:	e8 07 0c 00 00       	call   c0103d23 <free_pages>
    free_page(p2);
c010311c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103123:	00 
c0103124:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103127:	89 04 24             	mov    %eax,(%esp)
c010312a:	e8 f4 0b 00 00       	call   c0103d23 <free_pages>
    assert(nr_free == 3);
c010312f:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103134:	83 f8 03             	cmp    $0x3,%eax
c0103137:	74 24                	je     c010315d <basic_check+0x31c>
c0103139:	c7 44 24 0c 3b 68 10 	movl   $0xc010683b,0xc(%esp)
c0103140:	c0 
c0103141:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103148:	c0 
c0103149:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
c0103150:	00 
c0103151:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103158:	e8 69 db ff ff       	call   c0100cc6 <__panic>

    assert((p0 = alloc_page()) != NULL);
c010315d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103164:	e8 82 0b 00 00       	call   c0103ceb <alloc_pages>
c0103169:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010316c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103170:	75 24                	jne    c0103196 <basic_check+0x355>
c0103172:	c7 44 24 0c 04 67 10 	movl   $0xc0106704,0xc(%esp)
c0103179:	c0 
c010317a:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103181:	c0 
c0103182:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
c0103189:	00 
c010318a:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103191:	e8 30 db ff ff       	call   c0100cc6 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103196:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010319d:	e8 49 0b 00 00       	call   c0103ceb <alloc_pages>
c01031a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01031a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01031a9:	75 24                	jne    c01031cf <basic_check+0x38e>
c01031ab:	c7 44 24 0c 20 67 10 	movl   $0xc0106720,0xc(%esp)
c01031b2:	c0 
c01031b3:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01031ba:	c0 
c01031bb:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c01031c2:	00 
c01031c3:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01031ca:	e8 f7 da ff ff       	call   c0100cc6 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01031cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031d6:	e8 10 0b 00 00       	call   c0103ceb <alloc_pages>
c01031db:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01031de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01031e2:	75 24                	jne    c0103208 <basic_check+0x3c7>
c01031e4:	c7 44 24 0c 3c 67 10 	movl   $0xc010673c,0xc(%esp)
c01031eb:	c0 
c01031ec:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01031f3:	c0 
c01031f4:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
c01031fb:	00 
c01031fc:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103203:	e8 be da ff ff       	call   c0100cc6 <__panic>

    assert(alloc_page() == NULL);
c0103208:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010320f:	e8 d7 0a 00 00       	call   c0103ceb <alloc_pages>
c0103214:	85 c0                	test   %eax,%eax
c0103216:	74 24                	je     c010323c <basic_check+0x3fb>
c0103218:	c7 44 24 0c 26 68 10 	movl   $0xc0106826,0xc(%esp)
c010321f:	c0 
c0103220:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103227:	c0 
c0103228:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c010322f:	00 
c0103230:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103237:	e8 8a da ff ff       	call   c0100cc6 <__panic>

    free_page(p0);
c010323c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103243:	00 
c0103244:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103247:	89 04 24             	mov    %eax,(%esp)
c010324a:	e8 d4 0a 00 00       	call   c0103d23 <free_pages>
c010324f:	c7 45 d8 50 89 11 c0 	movl   $0xc0118950,-0x28(%ebp)
c0103256:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103259:	8b 40 04             	mov    0x4(%eax),%eax
c010325c:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c010325f:	0f 94 c0             	sete   %al
c0103262:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103265:	85 c0                	test   %eax,%eax
c0103267:	74 24                	je     c010328d <basic_check+0x44c>
c0103269:	c7 44 24 0c 48 68 10 	movl   $0xc0106848,0xc(%esp)
c0103270:	c0 
c0103271:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103278:	c0 
c0103279:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c0103280:	00 
c0103281:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103288:	e8 39 da ff ff       	call   c0100cc6 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c010328d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103294:	e8 52 0a 00 00       	call   c0103ceb <alloc_pages>
c0103299:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010329c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010329f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01032a2:	74 24                	je     c01032c8 <basic_check+0x487>
c01032a4:	c7 44 24 0c 60 68 10 	movl   $0xc0106860,0xc(%esp)
c01032ab:	c0 
c01032ac:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01032b3:	c0 
c01032b4:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
c01032bb:	00 
c01032bc:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01032c3:	e8 fe d9 ff ff       	call   c0100cc6 <__panic>
    assert(alloc_page() == NULL);
c01032c8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032cf:	e8 17 0a 00 00       	call   c0103ceb <alloc_pages>
c01032d4:	85 c0                	test   %eax,%eax
c01032d6:	74 24                	je     c01032fc <basic_check+0x4bb>
c01032d8:	c7 44 24 0c 26 68 10 	movl   $0xc0106826,0xc(%esp)
c01032df:	c0 
c01032e0:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01032e7:	c0 
c01032e8:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c01032ef:	00 
c01032f0:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01032f7:	e8 ca d9 ff ff       	call   c0100cc6 <__panic>

    assert(nr_free == 0);
c01032fc:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103301:	85 c0                	test   %eax,%eax
c0103303:	74 24                	je     c0103329 <basic_check+0x4e8>
c0103305:	c7 44 24 0c 79 68 10 	movl   $0xc0106879,0xc(%esp)
c010330c:	c0 
c010330d:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103314:	c0 
c0103315:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c010331c:	00 
c010331d:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103324:	e8 9d d9 ff ff       	call   c0100cc6 <__panic>
    free_list = free_list_store;
c0103329:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010332c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010332f:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c0103334:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    nr_free = nr_free_store;
c010333a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010333d:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_page(p);
c0103342:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103349:	00 
c010334a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010334d:	89 04 24             	mov    %eax,(%esp)
c0103350:	e8 ce 09 00 00       	call   c0103d23 <free_pages>
    free_page(p1);
c0103355:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010335c:	00 
c010335d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103360:	89 04 24             	mov    %eax,(%esp)
c0103363:	e8 bb 09 00 00       	call   c0103d23 <free_pages>
    free_page(p2);
c0103368:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010336f:	00 
c0103370:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103373:	89 04 24             	mov    %eax,(%esp)
c0103376:	e8 a8 09 00 00       	call   c0103d23 <free_pages>
}
c010337b:	c9                   	leave  
c010337c:	c3                   	ret    

c010337d <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c010337d:	55                   	push   %ebp
c010337e:	89 e5                	mov    %esp,%ebp
c0103380:	53                   	push   %ebx
c0103381:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0103387:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010338e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103395:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010339c:	eb 6b                	jmp    c0103409 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c010339e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033a1:	83 e8 0c             	sub    $0xc,%eax
c01033a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c01033a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033aa:	83 c0 04             	add    $0x4,%eax
c01033ad:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01033b4:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01033b7:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01033ba:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01033bd:	0f a3 10             	bt     %edx,(%eax)
c01033c0:	19 c0                	sbb    %eax,%eax
c01033c2:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c01033c5:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c01033c9:	0f 95 c0             	setne  %al
c01033cc:	0f b6 c0             	movzbl %al,%eax
c01033cf:	85 c0                	test   %eax,%eax
c01033d1:	75 24                	jne    c01033f7 <default_check+0x7a>
c01033d3:	c7 44 24 0c 86 68 10 	movl   $0xc0106886,0xc(%esp)
c01033da:	c0 
c01033db:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01033e2:	c0 
c01033e3:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c01033ea:	00 
c01033eb:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01033f2:	e8 cf d8 ff ff       	call   c0100cc6 <__panic>
        count ++, total += p->property;
c01033f7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01033fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033fe:	8b 50 08             	mov    0x8(%eax),%edx
c0103401:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103404:	01 d0                	add    %edx,%eax
c0103406:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103409:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010340c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010340f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103412:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103415:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103418:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c010341f:	0f 85 79 ff ff ff    	jne    c010339e <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0103425:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0103428:	e8 28 09 00 00       	call   c0103d55 <nr_free_pages>
c010342d:	39 c3                	cmp    %eax,%ebx
c010342f:	74 24                	je     c0103455 <default_check+0xd8>
c0103431:	c7 44 24 0c 96 68 10 	movl   $0xc0106896,0xc(%esp)
c0103438:	c0 
c0103439:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103440:	c0 
c0103441:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c0103448:	00 
c0103449:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103450:	e8 71 d8 ff ff       	call   c0100cc6 <__panic>

    basic_check();
c0103455:	e8 e7 f9 ff ff       	call   c0102e41 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c010345a:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103461:	e8 85 08 00 00       	call   c0103ceb <alloc_pages>
c0103466:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0103469:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010346d:	75 24                	jne    c0103493 <default_check+0x116>
c010346f:	c7 44 24 0c af 68 10 	movl   $0xc01068af,0xc(%esp)
c0103476:	c0 
c0103477:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c010347e:	c0 
c010347f:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c0103486:	00 
c0103487:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c010348e:	e8 33 d8 ff ff       	call   c0100cc6 <__panic>
    assert(!PageProperty(p0));
c0103493:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103496:	83 c0 04             	add    $0x4,%eax
c0103499:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01034a0:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01034a3:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01034a6:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01034a9:	0f a3 10             	bt     %edx,(%eax)
c01034ac:	19 c0                	sbb    %eax,%eax
c01034ae:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01034b1:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01034b5:	0f 95 c0             	setne  %al
c01034b8:	0f b6 c0             	movzbl %al,%eax
c01034bb:	85 c0                	test   %eax,%eax
c01034bd:	74 24                	je     c01034e3 <default_check+0x166>
c01034bf:	c7 44 24 0c ba 68 10 	movl   $0xc01068ba,0xc(%esp)
c01034c6:	c0 
c01034c7:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01034ce:	c0 
c01034cf:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c01034d6:	00 
c01034d7:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01034de:	e8 e3 d7 ff ff       	call   c0100cc6 <__panic>

    list_entry_t free_list_store = free_list;
c01034e3:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c01034e8:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c01034ee:	89 45 80             	mov    %eax,-0x80(%ebp)
c01034f1:	89 55 84             	mov    %edx,-0x7c(%ebp)
c01034f4:	c7 45 b4 50 89 11 c0 	movl   $0xc0118950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01034fb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01034fe:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103501:	89 50 04             	mov    %edx,0x4(%eax)
c0103504:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103507:	8b 50 04             	mov    0x4(%eax),%edx
c010350a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010350d:	89 10                	mov    %edx,(%eax)
c010350f:	c7 45 b0 50 89 11 c0 	movl   $0xc0118950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103516:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103519:	8b 40 04             	mov    0x4(%eax),%eax
c010351c:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c010351f:	0f 94 c0             	sete   %al
c0103522:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103525:	85 c0                	test   %eax,%eax
c0103527:	75 24                	jne    c010354d <default_check+0x1d0>
c0103529:	c7 44 24 0c 0f 68 10 	movl   $0xc010680f,0xc(%esp)
c0103530:	c0 
c0103531:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103538:	c0 
c0103539:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c0103540:	00 
c0103541:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103548:	e8 79 d7 ff ff       	call   c0100cc6 <__panic>
    assert(alloc_page() == NULL);
c010354d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103554:	e8 92 07 00 00       	call   c0103ceb <alloc_pages>
c0103559:	85 c0                	test   %eax,%eax
c010355b:	74 24                	je     c0103581 <default_check+0x204>
c010355d:	c7 44 24 0c 26 68 10 	movl   $0xc0106826,0xc(%esp)
c0103564:	c0 
c0103565:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c010356c:	c0 
c010356d:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
c0103574:	00 
c0103575:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c010357c:	e8 45 d7 ff ff       	call   c0100cc6 <__panic>

    unsigned int nr_free_store = nr_free;
c0103581:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103586:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0103589:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c0103590:	00 00 00 

    free_pages(p0 + 2, 3);
c0103593:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103596:	83 c0 28             	add    $0x28,%eax
c0103599:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01035a0:	00 
c01035a1:	89 04 24             	mov    %eax,(%esp)
c01035a4:	e8 7a 07 00 00       	call   c0103d23 <free_pages>
    assert(alloc_pages(4) == NULL);
c01035a9:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01035b0:	e8 36 07 00 00       	call   c0103ceb <alloc_pages>
c01035b5:	85 c0                	test   %eax,%eax
c01035b7:	74 24                	je     c01035dd <default_check+0x260>
c01035b9:	c7 44 24 0c cc 68 10 	movl   $0xc01068cc,0xc(%esp)
c01035c0:	c0 
c01035c1:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01035c8:	c0 
c01035c9:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c01035d0:	00 
c01035d1:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01035d8:	e8 e9 d6 ff ff       	call   c0100cc6 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c01035dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035e0:	83 c0 28             	add    $0x28,%eax
c01035e3:	83 c0 04             	add    $0x4,%eax
c01035e6:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c01035ed:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01035f0:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01035f3:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01035f6:	0f a3 10             	bt     %edx,(%eax)
c01035f9:	19 c0                	sbb    %eax,%eax
c01035fb:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c01035fe:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103602:	0f 95 c0             	setne  %al
c0103605:	0f b6 c0             	movzbl %al,%eax
c0103608:	85 c0                	test   %eax,%eax
c010360a:	74 0e                	je     c010361a <default_check+0x29d>
c010360c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010360f:	83 c0 28             	add    $0x28,%eax
c0103612:	8b 40 08             	mov    0x8(%eax),%eax
c0103615:	83 f8 03             	cmp    $0x3,%eax
c0103618:	74 24                	je     c010363e <default_check+0x2c1>
c010361a:	c7 44 24 0c e4 68 10 	movl   $0xc01068e4,0xc(%esp)
c0103621:	c0 
c0103622:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103629:	c0 
c010362a:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
c0103631:	00 
c0103632:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103639:	e8 88 d6 ff ff       	call   c0100cc6 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c010363e:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0103645:	e8 a1 06 00 00       	call   c0103ceb <alloc_pages>
c010364a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010364d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103651:	75 24                	jne    c0103677 <default_check+0x2fa>
c0103653:	c7 44 24 0c 10 69 10 	movl   $0xc0106910,0xc(%esp)
c010365a:	c0 
c010365b:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103662:	c0 
c0103663:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
c010366a:	00 
c010366b:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103672:	e8 4f d6 ff ff       	call   c0100cc6 <__panic>
    assert(alloc_page() == NULL);
c0103677:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010367e:	e8 68 06 00 00       	call   c0103ceb <alloc_pages>
c0103683:	85 c0                	test   %eax,%eax
c0103685:	74 24                	je     c01036ab <default_check+0x32e>
c0103687:	c7 44 24 0c 26 68 10 	movl   $0xc0106826,0xc(%esp)
c010368e:	c0 
c010368f:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103696:	c0 
c0103697:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c010369e:	00 
c010369f:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01036a6:	e8 1b d6 ff ff       	call   c0100cc6 <__panic>
    assert(p0 + 2 == p1);
c01036ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036ae:	83 c0 28             	add    $0x28,%eax
c01036b1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01036b4:	74 24                	je     c01036da <default_check+0x35d>
c01036b6:	c7 44 24 0c 2e 69 10 	movl   $0xc010692e,0xc(%esp)
c01036bd:	c0 
c01036be:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01036c5:	c0 
c01036c6:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c01036cd:	00 
c01036ce:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01036d5:	e8 ec d5 ff ff       	call   c0100cc6 <__panic>

    p2 = p0 + 1;
c01036da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036dd:	83 c0 14             	add    $0x14,%eax
c01036e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c01036e3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01036ea:	00 
c01036eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036ee:	89 04 24             	mov    %eax,(%esp)
c01036f1:	e8 2d 06 00 00       	call   c0103d23 <free_pages>
    free_pages(p1, 3);
c01036f6:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01036fd:	00 
c01036fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103701:	89 04 24             	mov    %eax,(%esp)
c0103704:	e8 1a 06 00 00       	call   c0103d23 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0103709:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010370c:	83 c0 04             	add    $0x4,%eax
c010370f:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0103716:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103719:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010371c:	8b 55 a0             	mov    -0x60(%ebp),%edx
c010371f:	0f a3 10             	bt     %edx,(%eax)
c0103722:	19 c0                	sbb    %eax,%eax
c0103724:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0103727:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c010372b:	0f 95 c0             	setne  %al
c010372e:	0f b6 c0             	movzbl %al,%eax
c0103731:	85 c0                	test   %eax,%eax
c0103733:	74 0b                	je     c0103740 <default_check+0x3c3>
c0103735:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103738:	8b 40 08             	mov    0x8(%eax),%eax
c010373b:	83 f8 01             	cmp    $0x1,%eax
c010373e:	74 24                	je     c0103764 <default_check+0x3e7>
c0103740:	c7 44 24 0c 3c 69 10 	movl   $0xc010693c,0xc(%esp)
c0103747:	c0 
c0103748:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c010374f:	c0 
c0103750:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c0103757:	00 
c0103758:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c010375f:	e8 62 d5 ff ff       	call   c0100cc6 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0103764:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103767:	83 c0 04             	add    $0x4,%eax
c010376a:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0103771:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103774:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103777:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010377a:	0f a3 10             	bt     %edx,(%eax)
c010377d:	19 c0                	sbb    %eax,%eax
c010377f:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0103782:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0103786:	0f 95 c0             	setne  %al
c0103789:	0f b6 c0             	movzbl %al,%eax
c010378c:	85 c0                	test   %eax,%eax
c010378e:	74 0b                	je     c010379b <default_check+0x41e>
c0103790:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103793:	8b 40 08             	mov    0x8(%eax),%eax
c0103796:	83 f8 03             	cmp    $0x3,%eax
c0103799:	74 24                	je     c01037bf <default_check+0x442>
c010379b:	c7 44 24 0c 64 69 10 	movl   $0xc0106964,0xc(%esp)
c01037a2:	c0 
c01037a3:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01037aa:	c0 
c01037ab:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c01037b2:	00 
c01037b3:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01037ba:	e8 07 d5 ff ff       	call   c0100cc6 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01037bf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01037c6:	e8 20 05 00 00       	call   c0103ceb <alloc_pages>
c01037cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01037ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01037d1:	83 e8 14             	sub    $0x14,%eax
c01037d4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01037d7:	74 24                	je     c01037fd <default_check+0x480>
c01037d9:	c7 44 24 0c 8a 69 10 	movl   $0xc010698a,0xc(%esp)
c01037e0:	c0 
c01037e1:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01037e8:	c0 
c01037e9:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c01037f0:	00 
c01037f1:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01037f8:	e8 c9 d4 ff ff       	call   c0100cc6 <__panic>
    free_page(p0);
c01037fd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103804:	00 
c0103805:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103808:	89 04 24             	mov    %eax,(%esp)
c010380b:	e8 13 05 00 00       	call   c0103d23 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0103810:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0103817:	e8 cf 04 00 00       	call   c0103ceb <alloc_pages>
c010381c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010381f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103822:	83 c0 14             	add    $0x14,%eax
c0103825:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103828:	74 24                	je     c010384e <default_check+0x4d1>
c010382a:	c7 44 24 0c a8 69 10 	movl   $0xc01069a8,0xc(%esp)
c0103831:	c0 
c0103832:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103839:	c0 
c010383a:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c0103841:	00 
c0103842:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103849:	e8 78 d4 ff ff       	call   c0100cc6 <__panic>

    free_pages(p0, 2);
c010384e:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0103855:	00 
c0103856:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103859:	89 04 24             	mov    %eax,(%esp)
c010385c:	e8 c2 04 00 00       	call   c0103d23 <free_pages>
    free_page(p2);
c0103861:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103868:	00 
c0103869:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010386c:	89 04 24             	mov    %eax,(%esp)
c010386f:	e8 af 04 00 00       	call   c0103d23 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0103874:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010387b:	e8 6b 04 00 00       	call   c0103ceb <alloc_pages>
c0103880:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103883:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103887:	75 24                	jne    c01038ad <default_check+0x530>
c0103889:	c7 44 24 0c c8 69 10 	movl   $0xc01069c8,0xc(%esp)
c0103890:	c0 
c0103891:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103898:	c0 
c0103899:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
c01038a0:	00 
c01038a1:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01038a8:	e8 19 d4 ff ff       	call   c0100cc6 <__panic>
    assert(alloc_page() == NULL);
c01038ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01038b4:	e8 32 04 00 00       	call   c0103ceb <alloc_pages>
c01038b9:	85 c0                	test   %eax,%eax
c01038bb:	74 24                	je     c01038e1 <default_check+0x564>
c01038bd:	c7 44 24 0c 26 68 10 	movl   $0xc0106826,0xc(%esp)
c01038c4:	c0 
c01038c5:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01038cc:	c0 
c01038cd:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
c01038d4:	00 
c01038d5:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01038dc:	e8 e5 d3 ff ff       	call   c0100cc6 <__panic>

    assert(nr_free == 0);
c01038e1:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c01038e6:	85 c0                	test   %eax,%eax
c01038e8:	74 24                	je     c010390e <default_check+0x591>
c01038ea:	c7 44 24 0c 79 68 10 	movl   $0xc0106879,0xc(%esp)
c01038f1:	c0 
c01038f2:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01038f9:	c0 
c01038fa:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c0103901:	00 
c0103902:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103909:	e8 b8 d3 ff ff       	call   c0100cc6 <__panic>
    nr_free = nr_free_store;
c010390e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103911:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_list = free_list_store;
c0103916:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103919:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010391c:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c0103921:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    free_pages(p0, 5);
c0103927:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c010392e:	00 
c010392f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103932:	89 04 24             	mov    %eax,(%esp)
c0103935:	e8 e9 03 00 00       	call   c0103d23 <free_pages>

    le = &free_list;
c010393a:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103941:	eb 1d                	jmp    c0103960 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c0103943:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103946:	83 e8 0c             	sub    $0xc,%eax
c0103949:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c010394c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103950:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103953:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103956:	8b 40 08             	mov    0x8(%eax),%eax
c0103959:	29 c2                	sub    %eax,%edx
c010395b:	89 d0                	mov    %edx,%eax
c010395d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103960:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103963:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103966:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103969:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c010396c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010396f:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c0103976:	75 cb                	jne    c0103943 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0103978:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010397c:	74 24                	je     c01039a2 <default_check+0x625>
c010397e:	c7 44 24 0c e6 69 10 	movl   $0xc01069e6,0xc(%esp)
c0103985:	c0 
c0103986:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c010398d:	c0 
c010398e:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0103995:	00 
c0103996:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c010399d:	e8 24 d3 ff ff       	call   c0100cc6 <__panic>
    assert(total == 0);
c01039a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01039a6:	74 24                	je     c01039cc <default_check+0x64f>
c01039a8:	c7 44 24 0c f1 69 10 	movl   $0xc01069f1,0xc(%esp)
c01039af:	c0 
c01039b0:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01039b7:	c0 
c01039b8:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c01039bf:	00 
c01039c0:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01039c7:	e8 fa d2 ff ff       	call   c0100cc6 <__panic>
}
c01039cc:	81 c4 94 00 00 00    	add    $0x94,%esp
c01039d2:	5b                   	pop    %ebx
c01039d3:	5d                   	pop    %ebp
c01039d4:	c3                   	ret    

c01039d5 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01039d5:	55                   	push   %ebp
c01039d6:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01039d8:	8b 55 08             	mov    0x8(%ebp),%edx
c01039db:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c01039e0:	29 c2                	sub    %eax,%edx
c01039e2:	89 d0                	mov    %edx,%eax
c01039e4:	c1 f8 02             	sar    $0x2,%eax
c01039e7:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01039ed:	5d                   	pop    %ebp
c01039ee:	c3                   	ret    

c01039ef <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01039ef:	55                   	push   %ebp
c01039f0:	89 e5                	mov    %esp,%ebp
c01039f2:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01039f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01039f8:	89 04 24             	mov    %eax,(%esp)
c01039fb:	e8 d5 ff ff ff       	call   c01039d5 <page2ppn>
c0103a00:	c1 e0 0c             	shl    $0xc,%eax
}
c0103a03:	c9                   	leave  
c0103a04:	c3                   	ret    

c0103a05 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0103a05:	55                   	push   %ebp
c0103a06:	89 e5                	mov    %esp,%ebp
c0103a08:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103a0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a0e:	c1 e8 0c             	shr    $0xc,%eax
c0103a11:	89 c2                	mov    %eax,%edx
c0103a13:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103a18:	39 c2                	cmp    %eax,%edx
c0103a1a:	72 1c                	jb     c0103a38 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103a1c:	c7 44 24 08 2c 6a 10 	movl   $0xc0106a2c,0x8(%esp)
c0103a23:	c0 
c0103a24:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103a2b:	00 
c0103a2c:	c7 04 24 4b 6a 10 c0 	movl   $0xc0106a4b,(%esp)
c0103a33:	e8 8e d2 ff ff       	call   c0100cc6 <__panic>
    }
    return &pages[PPN(pa)];
c0103a38:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c0103a3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a41:	c1 e8 0c             	shr    $0xc,%eax
c0103a44:	89 c2                	mov    %eax,%edx
c0103a46:	89 d0                	mov    %edx,%eax
c0103a48:	c1 e0 02             	shl    $0x2,%eax
c0103a4b:	01 d0                	add    %edx,%eax
c0103a4d:	c1 e0 02             	shl    $0x2,%eax
c0103a50:	01 c8                	add    %ecx,%eax
}
c0103a52:	c9                   	leave  
c0103a53:	c3                   	ret    

c0103a54 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0103a54:	55                   	push   %ebp
c0103a55:	89 e5                	mov    %esp,%ebp
c0103a57:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103a5a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a5d:	89 04 24             	mov    %eax,(%esp)
c0103a60:	e8 8a ff ff ff       	call   c01039ef <page2pa>
c0103a65:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a6b:	c1 e8 0c             	shr    $0xc,%eax
c0103a6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a71:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103a76:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103a79:	72 23                	jb     c0103a9e <page2kva+0x4a>
c0103a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a7e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103a82:	c7 44 24 08 5c 6a 10 	movl   $0xc0106a5c,0x8(%esp)
c0103a89:	c0 
c0103a8a:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103a91:	00 
c0103a92:	c7 04 24 4b 6a 10 c0 	movl   $0xc0106a4b,(%esp)
c0103a99:	e8 28 d2 ff ff       	call   c0100cc6 <__panic>
c0103a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103aa1:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103aa6:	c9                   	leave  
c0103aa7:	c3                   	ret    

c0103aa8 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0103aa8:	55                   	push   %ebp
c0103aa9:	89 e5                	mov    %esp,%ebp
c0103aab:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103aae:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ab1:	83 e0 01             	and    $0x1,%eax
c0103ab4:	85 c0                	test   %eax,%eax
c0103ab6:	75 1c                	jne    c0103ad4 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103ab8:	c7 44 24 08 80 6a 10 	movl   $0xc0106a80,0x8(%esp)
c0103abf:	c0 
c0103ac0:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103ac7:	00 
c0103ac8:	c7 04 24 4b 6a 10 c0 	movl   $0xc0106a4b,(%esp)
c0103acf:	e8 f2 d1 ff ff       	call   c0100cc6 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0103ad4:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ad7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103adc:	89 04 24             	mov    %eax,(%esp)
c0103adf:	e8 21 ff ff ff       	call   c0103a05 <pa2page>
}
c0103ae4:	c9                   	leave  
c0103ae5:	c3                   	ret    

c0103ae6 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0103ae6:	55                   	push   %ebp
c0103ae7:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103ae9:	8b 45 08             	mov    0x8(%ebp),%eax
c0103aec:	8b 00                	mov    (%eax),%eax
}
c0103aee:	5d                   	pop    %ebp
c0103aef:	c3                   	ret    

c0103af0 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103af0:	55                   	push   %ebp
c0103af1:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103af3:	8b 45 08             	mov    0x8(%ebp),%eax
c0103af6:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103af9:	89 10                	mov    %edx,(%eax)
}
c0103afb:	5d                   	pop    %ebp
c0103afc:	c3                   	ret    

c0103afd <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0103afd:	55                   	push   %ebp
c0103afe:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103b00:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b03:	8b 00                	mov    (%eax),%eax
c0103b05:	8d 50 01             	lea    0x1(%eax),%edx
c0103b08:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b0b:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103b0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b10:	8b 00                	mov    (%eax),%eax
}
c0103b12:	5d                   	pop    %ebp
c0103b13:	c3                   	ret    

c0103b14 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103b14:	55                   	push   %ebp
c0103b15:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103b17:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b1a:	8b 00                	mov    (%eax),%eax
c0103b1c:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103b1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b22:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103b24:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b27:	8b 00                	mov    (%eax),%eax
}
c0103b29:	5d                   	pop    %ebp
c0103b2a:	c3                   	ret    

c0103b2b <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0103b2b:	55                   	push   %ebp
c0103b2c:	89 e5                	mov    %esp,%ebp
c0103b2e:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103b31:	9c                   	pushf  
c0103b32:	58                   	pop    %eax
c0103b33:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103b39:	25 00 02 00 00       	and    $0x200,%eax
c0103b3e:	85 c0                	test   %eax,%eax
c0103b40:	74 0c                	je     c0103b4e <__intr_save+0x23>
        intr_disable();
c0103b42:	e8 62 db ff ff       	call   c01016a9 <intr_disable>
        return 1;
c0103b47:	b8 01 00 00 00       	mov    $0x1,%eax
c0103b4c:	eb 05                	jmp    c0103b53 <__intr_save+0x28>
    }
    return 0;
c0103b4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103b53:	c9                   	leave  
c0103b54:	c3                   	ret    

c0103b55 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0103b55:	55                   	push   %ebp
c0103b56:	89 e5                	mov    %esp,%ebp
c0103b58:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103b5b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103b5f:	74 05                	je     c0103b66 <__intr_restore+0x11>
        intr_enable();
c0103b61:	e8 3d db ff ff       	call   c01016a3 <intr_enable>
    }
}
c0103b66:	c9                   	leave  
c0103b67:	c3                   	ret    

c0103b68 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103b68:	55                   	push   %ebp
c0103b69:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103b6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b6e:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103b71:	b8 23 00 00 00       	mov    $0x23,%eax
c0103b76:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103b78:	b8 23 00 00 00       	mov    $0x23,%eax
c0103b7d:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103b7f:	b8 10 00 00 00       	mov    $0x10,%eax
c0103b84:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103b86:	b8 10 00 00 00       	mov    $0x10,%eax
c0103b8b:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103b8d:	b8 10 00 00 00       	mov    $0x10,%eax
c0103b92:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103b94:	ea 9b 3b 10 c0 08 00 	ljmp   $0x8,$0xc0103b9b
}
c0103b9b:	5d                   	pop    %ebp
c0103b9c:	c3                   	ret    

c0103b9d <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103b9d:	55                   	push   %ebp
c0103b9e:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103ba0:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ba3:	a3 e4 88 11 c0       	mov    %eax,0xc01188e4
}
c0103ba8:	5d                   	pop    %ebp
c0103ba9:	c3                   	ret    

c0103baa <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103baa:	55                   	push   %ebp
c0103bab:	89 e5                	mov    %esp,%ebp
c0103bad:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103bb0:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0103bb5:	89 04 24             	mov    %eax,(%esp)
c0103bb8:	e8 e0 ff ff ff       	call   c0103b9d <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103bbd:	66 c7 05 e8 88 11 c0 	movw   $0x10,0xc01188e8
c0103bc4:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103bc6:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0103bcd:	68 00 
c0103bcf:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103bd4:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0103bda:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103bdf:	c1 e8 10             	shr    $0x10,%eax
c0103be2:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0103be7:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103bee:	83 e0 f0             	and    $0xfffffff0,%eax
c0103bf1:	83 c8 09             	or     $0x9,%eax
c0103bf4:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103bf9:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c00:	83 e0 ef             	and    $0xffffffef,%eax
c0103c03:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c08:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c0f:	83 e0 9f             	and    $0xffffff9f,%eax
c0103c12:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c17:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c1e:	83 c8 80             	or     $0xffffff80,%eax
c0103c21:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c26:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c2d:	83 e0 f0             	and    $0xfffffff0,%eax
c0103c30:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c35:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c3c:	83 e0 ef             	and    $0xffffffef,%eax
c0103c3f:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c44:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c4b:	83 e0 df             	and    $0xffffffdf,%eax
c0103c4e:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c53:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c5a:	83 c8 40             	or     $0x40,%eax
c0103c5d:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c62:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c69:	83 e0 7f             	and    $0x7f,%eax
c0103c6c:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c71:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103c76:	c1 e8 18             	shr    $0x18,%eax
c0103c79:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103c7e:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0103c85:	e8 de fe ff ff       	call   c0103b68 <lgdt>
c0103c8a:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103c90:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103c94:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103c97:	c9                   	leave  
c0103c98:	c3                   	ret    

c0103c99 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103c99:	55                   	push   %ebp
c0103c9a:	89 e5                	mov    %esp,%ebp
c0103c9c:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103c9f:	c7 05 5c 89 11 c0 10 	movl   $0xc0106a10,0xc011895c
c0103ca6:	6a 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103ca9:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103cae:	8b 00                	mov    (%eax),%eax
c0103cb0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103cb4:	c7 04 24 ac 6a 10 c0 	movl   $0xc0106aac,(%esp)
c0103cbb:	e8 7c c6 ff ff       	call   c010033c <cprintf>
    pmm_manager->init();
c0103cc0:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103cc5:	8b 40 04             	mov    0x4(%eax),%eax
c0103cc8:	ff d0                	call   *%eax
}
c0103cca:	c9                   	leave  
c0103ccb:	c3                   	ret    

c0103ccc <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103ccc:	55                   	push   %ebp
c0103ccd:	89 e5                	mov    %esp,%ebp
c0103ccf:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103cd2:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103cd7:	8b 40 08             	mov    0x8(%eax),%eax
c0103cda:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103cdd:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103ce1:	8b 55 08             	mov    0x8(%ebp),%edx
c0103ce4:	89 14 24             	mov    %edx,(%esp)
c0103ce7:	ff d0                	call   *%eax
}
c0103ce9:	c9                   	leave  
c0103cea:	c3                   	ret    

c0103ceb <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103ceb:	55                   	push   %ebp
c0103cec:	89 e5                	mov    %esp,%ebp
c0103cee:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103cf1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103cf8:	e8 2e fe ff ff       	call   c0103b2b <__intr_save>
c0103cfd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103d00:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d05:	8b 40 0c             	mov    0xc(%eax),%eax
c0103d08:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d0b:	89 14 24             	mov    %edx,(%esp)
c0103d0e:	ff d0                	call   *%eax
c0103d10:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103d13:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d16:	89 04 24             	mov    %eax,(%esp)
c0103d19:	e8 37 fe ff ff       	call   c0103b55 <__intr_restore>
    return page;
c0103d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103d21:	c9                   	leave  
c0103d22:	c3                   	ret    

c0103d23 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103d23:	55                   	push   %ebp
c0103d24:	89 e5                	mov    %esp,%ebp
c0103d26:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103d29:	e8 fd fd ff ff       	call   c0103b2b <__intr_save>
c0103d2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103d31:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d36:	8b 40 10             	mov    0x10(%eax),%eax
c0103d39:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d3c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103d40:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d43:	89 14 24             	mov    %edx,(%esp)
c0103d46:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d4b:	89 04 24             	mov    %eax,(%esp)
c0103d4e:	e8 02 fe ff ff       	call   c0103b55 <__intr_restore>
}
c0103d53:	c9                   	leave  
c0103d54:	c3                   	ret    

c0103d55 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103d55:	55                   	push   %ebp
c0103d56:	89 e5                	mov    %esp,%ebp
c0103d58:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103d5b:	e8 cb fd ff ff       	call   c0103b2b <__intr_save>
c0103d60:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103d63:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d68:	8b 40 14             	mov    0x14(%eax),%eax
c0103d6b:	ff d0                	call   *%eax
c0103d6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d73:	89 04 24             	mov    %eax,(%esp)
c0103d76:	e8 da fd ff ff       	call   c0103b55 <__intr_restore>
    return ret;
c0103d7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103d7e:	c9                   	leave  
c0103d7f:	c3                   	ret    

c0103d80 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103d80:	55                   	push   %ebp
c0103d81:	89 e5                	mov    %esp,%ebp
c0103d83:	57                   	push   %edi
c0103d84:	56                   	push   %esi
c0103d85:	53                   	push   %ebx
c0103d86:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103d8c:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103d93:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103d9a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103da1:	c7 04 24 c3 6a 10 c0 	movl   $0xc0106ac3,(%esp)
c0103da8:	e8 8f c5 ff ff       	call   c010033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103dad:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103db4:	e9 15 01 00 00       	jmp    c0103ece <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103db9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103dbc:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103dbf:	89 d0                	mov    %edx,%eax
c0103dc1:	c1 e0 02             	shl    $0x2,%eax
c0103dc4:	01 d0                	add    %edx,%eax
c0103dc6:	c1 e0 02             	shl    $0x2,%eax
c0103dc9:	01 c8                	add    %ecx,%eax
c0103dcb:	8b 50 08             	mov    0x8(%eax),%edx
c0103dce:	8b 40 04             	mov    0x4(%eax),%eax
c0103dd1:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103dd4:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103dd7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103dda:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ddd:	89 d0                	mov    %edx,%eax
c0103ddf:	c1 e0 02             	shl    $0x2,%eax
c0103de2:	01 d0                	add    %edx,%eax
c0103de4:	c1 e0 02             	shl    $0x2,%eax
c0103de7:	01 c8                	add    %ecx,%eax
c0103de9:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103dec:	8b 58 10             	mov    0x10(%eax),%ebx
c0103def:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103df2:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103df5:	01 c8                	add    %ecx,%eax
c0103df7:	11 da                	adc    %ebx,%edx
c0103df9:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103dfc:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103dff:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e02:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e05:	89 d0                	mov    %edx,%eax
c0103e07:	c1 e0 02             	shl    $0x2,%eax
c0103e0a:	01 d0                	add    %edx,%eax
c0103e0c:	c1 e0 02             	shl    $0x2,%eax
c0103e0f:	01 c8                	add    %ecx,%eax
c0103e11:	83 c0 14             	add    $0x14,%eax
c0103e14:	8b 00                	mov    (%eax),%eax
c0103e16:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0103e1c:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103e1f:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103e22:	83 c0 ff             	add    $0xffffffff,%eax
c0103e25:	83 d2 ff             	adc    $0xffffffff,%edx
c0103e28:	89 c6                	mov    %eax,%esi
c0103e2a:	89 d7                	mov    %edx,%edi
c0103e2c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e2f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e32:	89 d0                	mov    %edx,%eax
c0103e34:	c1 e0 02             	shl    $0x2,%eax
c0103e37:	01 d0                	add    %edx,%eax
c0103e39:	c1 e0 02             	shl    $0x2,%eax
c0103e3c:	01 c8                	add    %ecx,%eax
c0103e3e:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103e41:	8b 58 10             	mov    0x10(%eax),%ebx
c0103e44:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0103e4a:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0103e4e:	89 74 24 14          	mov    %esi,0x14(%esp)
c0103e52:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0103e56:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103e59:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103e5c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103e60:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103e64:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103e68:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0103e6c:	c7 04 24 d0 6a 10 c0 	movl   $0xc0106ad0,(%esp)
c0103e73:	e8 c4 c4 ff ff       	call   c010033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103e78:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e7b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e7e:	89 d0                	mov    %edx,%eax
c0103e80:	c1 e0 02             	shl    $0x2,%eax
c0103e83:	01 d0                	add    %edx,%eax
c0103e85:	c1 e0 02             	shl    $0x2,%eax
c0103e88:	01 c8                	add    %ecx,%eax
c0103e8a:	83 c0 14             	add    $0x14,%eax
c0103e8d:	8b 00                	mov    (%eax),%eax
c0103e8f:	83 f8 01             	cmp    $0x1,%eax
c0103e92:	75 36                	jne    c0103eca <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0103e94:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103e97:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103e9a:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103e9d:	77 2b                	ja     c0103eca <page_init+0x14a>
c0103e9f:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103ea2:	72 05                	jb     c0103ea9 <page_init+0x129>
c0103ea4:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0103ea7:	73 21                	jae    c0103eca <page_init+0x14a>
c0103ea9:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103ead:	77 1b                	ja     c0103eca <page_init+0x14a>
c0103eaf:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103eb3:	72 09                	jb     c0103ebe <page_init+0x13e>
c0103eb5:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0103ebc:	77 0c                	ja     c0103eca <page_init+0x14a>
                maxpa = end;
c0103ebe:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103ec1:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103ec4:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103ec7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103eca:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103ece:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103ed1:	8b 00                	mov    (%eax),%eax
c0103ed3:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103ed6:	0f 8f dd fe ff ff    	jg     c0103db9 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0103edc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103ee0:	72 1d                	jb     c0103eff <page_init+0x17f>
c0103ee2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103ee6:	77 09                	ja     c0103ef1 <page_init+0x171>
c0103ee8:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0103eef:	76 0e                	jbe    c0103eff <page_init+0x17f>
        maxpa = KMEMSIZE;
c0103ef1:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0103ef8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0103eff:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103f02:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103f05:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103f09:	c1 ea 0c             	shr    $0xc,%edx
c0103f0c:	a3 c0 88 11 c0       	mov    %eax,0xc01188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0103f11:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0103f18:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c0103f1d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103f20:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103f23:	01 d0                	add    %edx,%eax
c0103f25:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103f28:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103f2b:	ba 00 00 00 00       	mov    $0x0,%edx
c0103f30:	f7 75 ac             	divl   -0x54(%ebp)
c0103f33:	89 d0                	mov    %edx,%eax
c0103f35:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0103f38:	29 c2                	sub    %eax,%edx
c0103f3a:	89 d0                	mov    %edx,%eax
c0103f3c:	a3 64 89 11 c0       	mov    %eax,0xc0118964

    for (i = 0; i < npage; i ++) {
c0103f41:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103f48:	eb 2f                	jmp    c0103f79 <page_init+0x1f9>
        SetPageReserved(pages + i);
c0103f4a:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c0103f50:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f53:	89 d0                	mov    %edx,%eax
c0103f55:	c1 e0 02             	shl    $0x2,%eax
c0103f58:	01 d0                	add    %edx,%eax
c0103f5a:	c1 e0 02             	shl    $0x2,%eax
c0103f5d:	01 c8                	add    %ecx,%eax
c0103f5f:	83 c0 04             	add    $0x4,%eax
c0103f62:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0103f69:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103f6c:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103f6f:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103f72:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0103f75:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103f79:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f7c:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103f81:	39 c2                	cmp    %eax,%edx
c0103f83:	72 c5                	jb     c0103f4a <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0103f85:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0103f8b:	89 d0                	mov    %edx,%eax
c0103f8d:	c1 e0 02             	shl    $0x2,%eax
c0103f90:	01 d0                	add    %edx,%eax
c0103f92:	c1 e0 02             	shl    $0x2,%eax
c0103f95:	89 c2                	mov    %eax,%edx
c0103f97:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0103f9c:	01 d0                	add    %edx,%eax
c0103f9e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0103fa1:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0103fa8:	77 23                	ja     c0103fcd <page_init+0x24d>
c0103faa:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103fad:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103fb1:	c7 44 24 08 00 6b 10 	movl   $0xc0106b00,0x8(%esp)
c0103fb8:	c0 
c0103fb9:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0103fc0:	00 
c0103fc1:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c0103fc8:	e8 f9 cc ff ff       	call   c0100cc6 <__panic>
c0103fcd:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103fd0:	05 00 00 00 40       	add    $0x40000000,%eax
c0103fd5:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0103fd8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103fdf:	e9 74 01 00 00       	jmp    c0104158 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103fe4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103fe7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fea:	89 d0                	mov    %edx,%eax
c0103fec:	c1 e0 02             	shl    $0x2,%eax
c0103fef:	01 d0                	add    %edx,%eax
c0103ff1:	c1 e0 02             	shl    $0x2,%eax
c0103ff4:	01 c8                	add    %ecx,%eax
c0103ff6:	8b 50 08             	mov    0x8(%eax),%edx
c0103ff9:	8b 40 04             	mov    0x4(%eax),%eax
c0103ffc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103fff:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104002:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104005:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104008:	89 d0                	mov    %edx,%eax
c010400a:	c1 e0 02             	shl    $0x2,%eax
c010400d:	01 d0                	add    %edx,%eax
c010400f:	c1 e0 02             	shl    $0x2,%eax
c0104012:	01 c8                	add    %ecx,%eax
c0104014:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104017:	8b 58 10             	mov    0x10(%eax),%ebx
c010401a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010401d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104020:	01 c8                	add    %ecx,%eax
c0104022:	11 da                	adc    %ebx,%edx
c0104024:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104027:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c010402a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010402d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104030:	89 d0                	mov    %edx,%eax
c0104032:	c1 e0 02             	shl    $0x2,%eax
c0104035:	01 d0                	add    %edx,%eax
c0104037:	c1 e0 02             	shl    $0x2,%eax
c010403a:	01 c8                	add    %ecx,%eax
c010403c:	83 c0 14             	add    $0x14,%eax
c010403f:	8b 00                	mov    (%eax),%eax
c0104041:	83 f8 01             	cmp    $0x1,%eax
c0104044:	0f 85 0a 01 00 00    	jne    c0104154 <page_init+0x3d4>
            if (begin < freemem) {
c010404a:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010404d:	ba 00 00 00 00       	mov    $0x0,%edx
c0104052:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104055:	72 17                	jb     c010406e <page_init+0x2ee>
c0104057:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010405a:	77 05                	ja     c0104061 <page_init+0x2e1>
c010405c:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c010405f:	76 0d                	jbe    c010406e <page_init+0x2ee>
                begin = freemem;
c0104061:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104064:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104067:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c010406e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104072:	72 1d                	jb     c0104091 <page_init+0x311>
c0104074:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104078:	77 09                	ja     c0104083 <page_init+0x303>
c010407a:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0104081:	76 0e                	jbe    c0104091 <page_init+0x311>
                end = KMEMSIZE;
c0104083:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c010408a:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0104091:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104094:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104097:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010409a:	0f 87 b4 00 00 00    	ja     c0104154 <page_init+0x3d4>
c01040a0:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01040a3:	72 09                	jb     c01040ae <page_init+0x32e>
c01040a5:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01040a8:	0f 83 a6 00 00 00    	jae    c0104154 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c01040ae:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c01040b5:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01040b8:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01040bb:	01 d0                	add    %edx,%eax
c01040bd:	83 e8 01             	sub    $0x1,%eax
c01040c0:	89 45 98             	mov    %eax,-0x68(%ebp)
c01040c3:	8b 45 98             	mov    -0x68(%ebp),%eax
c01040c6:	ba 00 00 00 00       	mov    $0x0,%edx
c01040cb:	f7 75 9c             	divl   -0x64(%ebp)
c01040ce:	89 d0                	mov    %edx,%eax
c01040d0:	8b 55 98             	mov    -0x68(%ebp),%edx
c01040d3:	29 c2                	sub    %eax,%edx
c01040d5:	89 d0                	mov    %edx,%eax
c01040d7:	ba 00 00 00 00       	mov    $0x0,%edx
c01040dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01040df:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c01040e2:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01040e5:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01040e8:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01040eb:	ba 00 00 00 00       	mov    $0x0,%edx
c01040f0:	89 c7                	mov    %eax,%edi
c01040f2:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c01040f8:	89 7d 80             	mov    %edi,-0x80(%ebp)
c01040fb:	89 d0                	mov    %edx,%eax
c01040fd:	83 e0 00             	and    $0x0,%eax
c0104100:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104103:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104106:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104109:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010410c:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c010410f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104112:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104115:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104118:	77 3a                	ja     c0104154 <page_init+0x3d4>
c010411a:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010411d:	72 05                	jb     c0104124 <page_init+0x3a4>
c010411f:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104122:	73 30                	jae    c0104154 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0104124:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0104127:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c010412a:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010412d:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104130:	29 c8                	sub    %ecx,%eax
c0104132:	19 da                	sbb    %ebx,%edx
c0104134:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104138:	c1 ea 0c             	shr    $0xc,%edx
c010413b:	89 c3                	mov    %eax,%ebx
c010413d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104140:	89 04 24             	mov    %eax,(%esp)
c0104143:	e8 bd f8 ff ff       	call   c0103a05 <pa2page>
c0104148:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c010414c:	89 04 24             	mov    %eax,(%esp)
c010414f:	e8 78 fb ff ff       	call   c0103ccc <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0104154:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104158:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010415b:	8b 00                	mov    (%eax),%eax
c010415d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104160:	0f 8f 7e fe ff ff    	jg     c0103fe4 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0104166:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c010416c:	5b                   	pop    %ebx
c010416d:	5e                   	pop    %esi
c010416e:	5f                   	pop    %edi
c010416f:	5d                   	pop    %ebp
c0104170:	c3                   	ret    

c0104171 <enable_paging>:

static void
enable_paging(void) {
c0104171:	55                   	push   %ebp
c0104172:	89 e5                	mov    %esp,%ebp
c0104174:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c0104177:	a1 60 89 11 c0       	mov    0xc0118960,%eax
c010417c:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c010417f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0104182:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c0104185:	0f 20 c0             	mov    %cr0,%eax
c0104188:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c010418b:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c010418e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c0104191:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0104198:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c010419c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010419f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c01041a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01041a5:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c01041a8:	c9                   	leave  
c01041a9:	c3                   	ret    

c01041aa <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c01041aa:	55                   	push   %ebp
c01041ab:	89 e5                	mov    %esp,%ebp
c01041ad:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01041b0:	8b 45 14             	mov    0x14(%ebp),%eax
c01041b3:	8b 55 0c             	mov    0xc(%ebp),%edx
c01041b6:	31 d0                	xor    %edx,%eax
c01041b8:	25 ff 0f 00 00       	and    $0xfff,%eax
c01041bd:	85 c0                	test   %eax,%eax
c01041bf:	74 24                	je     c01041e5 <boot_map_segment+0x3b>
c01041c1:	c7 44 24 0c 32 6b 10 	movl   $0xc0106b32,0xc(%esp)
c01041c8:	c0 
c01041c9:	c7 44 24 08 49 6b 10 	movl   $0xc0106b49,0x8(%esp)
c01041d0:	c0 
c01041d1:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c01041d8:	00 
c01041d9:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c01041e0:	e8 e1 ca ff ff       	call   c0100cc6 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01041e5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01041ec:	8b 45 0c             	mov    0xc(%ebp),%eax
c01041ef:	25 ff 0f 00 00       	and    $0xfff,%eax
c01041f4:	89 c2                	mov    %eax,%edx
c01041f6:	8b 45 10             	mov    0x10(%ebp),%eax
c01041f9:	01 c2                	add    %eax,%edx
c01041fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01041fe:	01 d0                	add    %edx,%eax
c0104200:	83 e8 01             	sub    $0x1,%eax
c0104203:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104206:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104209:	ba 00 00 00 00       	mov    $0x0,%edx
c010420e:	f7 75 f0             	divl   -0x10(%ebp)
c0104211:	89 d0                	mov    %edx,%eax
c0104213:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104216:	29 c2                	sub    %eax,%edx
c0104218:	89 d0                	mov    %edx,%eax
c010421a:	c1 e8 0c             	shr    $0xc,%eax
c010421d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104220:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104223:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104226:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104229:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010422e:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104231:	8b 45 14             	mov    0x14(%ebp),%eax
c0104234:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104237:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010423a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010423f:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104242:	eb 6b                	jmp    c01042af <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0104244:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010424b:	00 
c010424c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010424f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104253:	8b 45 08             	mov    0x8(%ebp),%eax
c0104256:	89 04 24             	mov    %eax,(%esp)
c0104259:	e8 cc 01 00 00       	call   c010442a <get_pte>
c010425e:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104261:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104265:	75 24                	jne    c010428b <boot_map_segment+0xe1>
c0104267:	c7 44 24 0c 5e 6b 10 	movl   $0xc0106b5e,0xc(%esp)
c010426e:	c0 
c010426f:	c7 44 24 08 49 6b 10 	movl   $0xc0106b49,0x8(%esp)
c0104276:	c0 
c0104277:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c010427e:	00 
c010427f:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c0104286:	e8 3b ca ff ff       	call   c0100cc6 <__panic>
        *ptep = pa | PTE_P | perm;
c010428b:	8b 45 18             	mov    0x18(%ebp),%eax
c010428e:	8b 55 14             	mov    0x14(%ebp),%edx
c0104291:	09 d0                	or     %edx,%eax
c0104293:	83 c8 01             	or     $0x1,%eax
c0104296:	89 c2                	mov    %eax,%edx
c0104298:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010429b:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c010429d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01042a1:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01042a8:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01042af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01042b3:	75 8f                	jne    c0104244 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c01042b5:	c9                   	leave  
c01042b6:	c3                   	ret    

c01042b7 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01042b7:	55                   	push   %ebp
c01042b8:	89 e5                	mov    %esp,%ebp
c01042ba:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c01042bd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01042c4:	e8 22 fa ff ff       	call   c0103ceb <alloc_pages>
c01042c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01042cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01042d0:	75 1c                	jne    c01042ee <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c01042d2:	c7 44 24 08 6b 6b 10 	movl   $0xc0106b6b,0x8(%esp)
c01042d9:	c0 
c01042da:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c01042e1:	00 
c01042e2:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c01042e9:	e8 d8 c9 ff ff       	call   c0100cc6 <__panic>
    }
    return page2kva(p);
c01042ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042f1:	89 04 24             	mov    %eax,(%esp)
c01042f4:	e8 5b f7 ff ff       	call   c0103a54 <page2kva>
}
c01042f9:	c9                   	leave  
c01042fa:	c3                   	ret    

c01042fb <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01042fb:	55                   	push   %ebp
c01042fc:	89 e5                	mov    %esp,%ebp
c01042fe:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104301:	e8 93 f9 ff ff       	call   c0103c99 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0104306:	e8 75 fa ff ff       	call   c0103d80 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c010430b:	e8 75 04 00 00       	call   c0104785 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0104310:	e8 a2 ff ff ff       	call   c01042b7 <boot_alloc_page>
c0104315:	a3 c4 88 11 c0       	mov    %eax,0xc01188c4
    memset(boot_pgdir, 0, PGSIZE);
c010431a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010431f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104326:	00 
c0104327:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010432e:	00 
c010432f:	89 04 24             	mov    %eax,(%esp)
c0104332:	e8 b7 1a 00 00       	call   c0105dee <memset>
    boot_cr3 = PADDR(boot_pgdir);
c0104337:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010433c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010433f:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104346:	77 23                	ja     c010436b <pmm_init+0x70>
c0104348:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010434b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010434f:	c7 44 24 08 00 6b 10 	movl   $0xc0106b00,0x8(%esp)
c0104356:	c0 
c0104357:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c010435e:	00 
c010435f:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c0104366:	e8 5b c9 ff ff       	call   c0100cc6 <__panic>
c010436b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010436e:	05 00 00 00 40       	add    $0x40000000,%eax
c0104373:	a3 60 89 11 c0       	mov    %eax,0xc0118960

    check_pgdir();
c0104378:	e8 26 04 00 00       	call   c01047a3 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c010437d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104382:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0104388:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010438d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104390:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104397:	77 23                	ja     c01043bc <pmm_init+0xc1>
c0104399:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010439c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01043a0:	c7 44 24 08 00 6b 10 	movl   $0xc0106b00,0x8(%esp)
c01043a7:	c0 
c01043a8:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c01043af:	00 
c01043b0:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c01043b7:	e8 0a c9 ff ff       	call   c0100cc6 <__panic>
c01043bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043bf:	05 00 00 00 40       	add    $0x40000000,%eax
c01043c4:	83 c8 03             	or     $0x3,%eax
c01043c7:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01043c9:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01043ce:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c01043d5:	00 
c01043d6:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01043dd:	00 
c01043de:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c01043e5:	38 
c01043e6:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c01043ed:	c0 
c01043ee:	89 04 24             	mov    %eax,(%esp)
c01043f1:	e8 b4 fd ff ff       	call   c01041aa <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c01043f6:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01043fb:	8b 15 c4 88 11 c0    	mov    0xc01188c4,%edx
c0104401:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c0104407:	89 10                	mov    %edx,(%eax)

    enable_paging();
c0104409:	e8 63 fd ff ff       	call   c0104171 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c010440e:	e8 97 f7 ff ff       	call   c0103baa <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0104413:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104418:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c010441e:	e8 1b 0a 00 00       	call   c0104e3e <check_boot_pgdir>

    print_pgdir();
c0104423:	e8 a8 0e 00 00       	call   c01052d0 <print_pgdir>

}
c0104428:	c9                   	leave  
c0104429:	c3                   	ret    

c010442a <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c010442a:	55                   	push   %ebp
c010442b:	89 e5                	mov    %esp,%ebp
c010442d:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
pde_t* pdep = &pgdir[PDX(la)];                      // (1) find page directory entry
c0104430:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104433:	c1 e8 16             	shr    $0x16,%eax
c0104436:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010443d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104440:	01 d0                	add    %edx,%eax
c0104442:	89 45 f4             	mov    %eax,-0xc(%ebp)
if (!(*pdep & PTE_P)) {                              // (2) check if entry is not present 
c0104445:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104448:	8b 00                	mov    (%eax),%eax
c010444a:	83 e0 01             	and    $0x1,%eax
c010444d:	85 c0                	test   %eax,%eax
c010444f:	0f 85 b9 00 00 00    	jne    c010450e <get_pte+0xe4>
	struct Page* page;
	if (create) {                                    // (3) check if creating is needed, then alloc page for page table
c0104455:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104459:	74 1f                	je     c010447a <get_pte+0x50>
		if ((page = alloc_page()) == NULL)
c010445b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104462:	e8 84 f8 ff ff       	call   c0103ceb <alloc_pages>
c0104467:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010446a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010446e:	75 14                	jne    c0104484 <get_pte+0x5a>
			return NULL;
c0104470:	b8 00 00 00 00       	mov    $0x0,%eax
c0104475:	e9 f0 00 00 00       	jmp    c010456a <get_pte+0x140>
	}
	else
		return NULL;
c010447a:	b8 00 00 00 00       	mov    $0x0,%eax
c010447f:	e9 e6 00 00 00       	jmp    c010456a <get_pte+0x140>
	set_page_ref(page, 1);                          // (4) set page reference
c0104484:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010448b:	00 
c010448c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010448f:	89 04 24             	mov    %eax,(%esp)
c0104492:	e8 59 f6 ff ff       	call   c0103af0 <set_page_ref>
	uintptr_t addr = page2pa(page);                 // (5) get linear address of page
c0104497:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010449a:	89 04 24             	mov    %eax,(%esp)
c010449d:	e8 4d f5 ff ff       	call   c01039ef <page2pa>
c01044a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	memset(KADDR(addr), 0, PGSIZE);                  // (6) clear page content using memset
c01044a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01044a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01044ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01044ae:	c1 e8 0c             	shr    $0xc,%eax
c01044b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01044b4:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01044b9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01044bc:	72 23                	jb     c01044e1 <get_pte+0xb7>
c01044be:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01044c1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01044c5:	c7 44 24 08 5c 6a 10 	movl   $0xc0106a5c,0x8(%esp)
c01044cc:	c0 
c01044cd:	c7 44 24 04 8a 01 00 	movl   $0x18a,0x4(%esp)
c01044d4:	00 
c01044d5:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c01044dc:	e8 e5 c7 ff ff       	call   c0100cc6 <__panic>
c01044e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01044e4:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01044e9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01044f0:	00 
c01044f1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01044f8:	00 
c01044f9:	89 04 24             	mov    %eax,(%esp)
c01044fc:	e8 ed 18 00 00       	call   c0105dee <memset>
	*pdep = addr | PTE_U | PTE_W | PTE_P;             // (7) set page directory entry's permission
c0104501:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104504:	83 c8 07             	or     $0x7,%eax
c0104507:	89 c2                	mov    %eax,%edx
c0104509:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010450c:	89 10                	mov    %edx,(%eax)
}
return &((pte_t*)KADDR(PDE_ADDR(*pdep)))[PTX(la)];// (8) return page table entry
c010450e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104511:	8b 00                	mov    (%eax),%eax
c0104513:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104518:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010451b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010451e:	c1 e8 0c             	shr    $0xc,%eax
c0104521:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104524:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104529:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010452c:	72 23                	jb     c0104551 <get_pte+0x127>
c010452e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104531:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104535:	c7 44 24 08 5c 6a 10 	movl   $0xc0106a5c,0x8(%esp)
c010453c:	c0 
c010453d:	c7 44 24 04 8d 01 00 	movl   $0x18d,0x4(%esp)
c0104544:	00 
c0104545:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c010454c:	e8 75 c7 ff ff       	call   c0100cc6 <__panic>
c0104551:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104554:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104559:	8b 55 0c             	mov    0xc(%ebp),%edx
c010455c:	c1 ea 0c             	shr    $0xc,%edx
c010455f:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c0104565:	c1 e2 02             	shl    $0x2,%edx
c0104568:	01 d0                	add    %edx,%eax

}
c010456a:	c9                   	leave  
c010456b:	c3                   	ret    

c010456c <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c010456c:	55                   	push   %ebp
c010456d:	89 e5                	mov    %esp,%ebp
c010456f:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104572:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104579:	00 
c010457a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010457d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104581:	8b 45 08             	mov    0x8(%ebp),%eax
c0104584:	89 04 24             	mov    %eax,(%esp)
c0104587:	e8 9e fe ff ff       	call   c010442a <get_pte>
c010458c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c010458f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104593:	74 08                	je     c010459d <get_page+0x31>
        *ptep_store = ptep;
c0104595:	8b 45 10             	mov    0x10(%ebp),%eax
c0104598:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010459b:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c010459d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01045a1:	74 1b                	je     c01045be <get_page+0x52>
c01045a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045a6:	8b 00                	mov    (%eax),%eax
c01045a8:	83 e0 01             	and    $0x1,%eax
c01045ab:	85 c0                	test   %eax,%eax
c01045ad:	74 0f                	je     c01045be <get_page+0x52>
        return pa2page(*ptep);
c01045af:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045b2:	8b 00                	mov    (%eax),%eax
c01045b4:	89 04 24             	mov    %eax,(%esp)
c01045b7:	e8 49 f4 ff ff       	call   c0103a05 <pa2page>
c01045bc:	eb 05                	jmp    c01045c3 <get_page+0x57>
    }
    return NULL;
c01045be:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01045c3:	c9                   	leave  
c01045c4:	c3                   	ret    

c01045c5 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01045c5:	55                   	push   %ebp
c01045c6:	89 e5                	mov    %esp,%ebp
c01045c8:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
if (*ptep & PTE_P) {                        //(1) check if this page table entry is present
c01045cb:	8b 45 10             	mov    0x10(%ebp),%eax
c01045ce:	8b 00                	mov    (%eax),%eax
c01045d0:	83 e0 01             	and    $0x1,%eax
c01045d3:	85 c0                	test   %eax,%eax
c01045d5:	74 52                	je     c0104629 <page_remove_pte+0x64>
	struct Page* page = pte2page(*ptep);    //(2) find corresponding page to pte
c01045d7:	8b 45 10             	mov    0x10(%ebp),%eax
c01045da:	8b 00                	mov    (%eax),%eax
c01045dc:	89 04 24             	mov    %eax,(%esp)
c01045df:	e8 c4 f4 ff ff       	call   c0103aa8 <pte2page>
c01045e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	page_ref_dec(page);                     //(3) decrease page reference
c01045e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045ea:	89 04 24             	mov    %eax,(%esp)
c01045ed:	e8 22 f5 ff ff       	call   c0103b14 <page_ref_dec>
	if (page->ref == 0) {
c01045f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045f5:	8b 00                	mov    (%eax),%eax
c01045f7:	85 c0                	test   %eax,%eax
c01045f9:	75 13                	jne    c010460e <page_remove_pte+0x49>
		free_page(page);                    //(4) and free this page when page reference reachs 0
c01045fb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104602:	00 
c0104603:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104606:	89 04 24             	mov    %eax,(%esp)
c0104609:	e8 15 f7 ff ff       	call   c0103d23 <free_pages>
	}
	*ptep = 0;                              //(5) clear second page table entry
c010460e:	8b 45 10             	mov    0x10(%ebp),%eax
c0104611:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	tlb_invalidate(pgdir, la);              //(6) flush tlb
c0104617:	8b 45 0c             	mov    0xc(%ebp),%eax
c010461a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010461e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104621:	89 04 24             	mov    %eax,(%esp)
c0104624:	e8 ff 00 00 00       	call   c0104728 <tlb_invalidate>
}

}
c0104629:	c9                   	leave  
c010462a:	c3                   	ret    

c010462b <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c010462b:	55                   	push   %ebp
c010462c:	89 e5                	mov    %esp,%ebp
c010462e:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104631:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104638:	00 
c0104639:	8b 45 0c             	mov    0xc(%ebp),%eax
c010463c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104640:	8b 45 08             	mov    0x8(%ebp),%eax
c0104643:	89 04 24             	mov    %eax,(%esp)
c0104646:	e8 df fd ff ff       	call   c010442a <get_pte>
c010464b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c010464e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104652:	74 19                	je     c010466d <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0104654:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104657:	89 44 24 08          	mov    %eax,0x8(%esp)
c010465b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010465e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104662:	8b 45 08             	mov    0x8(%ebp),%eax
c0104665:	89 04 24             	mov    %eax,(%esp)
c0104668:	e8 58 ff ff ff       	call   c01045c5 <page_remove_pte>
    }
}
c010466d:	c9                   	leave  
c010466e:	c3                   	ret    

c010466f <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c010466f:	55                   	push   %ebp
c0104670:	89 e5                	mov    %esp,%ebp
c0104672:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0104675:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010467c:	00 
c010467d:	8b 45 10             	mov    0x10(%ebp),%eax
c0104680:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104684:	8b 45 08             	mov    0x8(%ebp),%eax
c0104687:	89 04 24             	mov    %eax,(%esp)
c010468a:	e8 9b fd ff ff       	call   c010442a <get_pte>
c010468f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0104692:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104696:	75 0a                	jne    c01046a2 <page_insert+0x33>
        return -E_NO_MEM;
c0104698:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c010469d:	e9 84 00 00 00       	jmp    c0104726 <page_insert+0xb7>
    }
    page_ref_inc(page);
c01046a2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046a5:	89 04 24             	mov    %eax,(%esp)
c01046a8:	e8 50 f4 ff ff       	call   c0103afd <page_ref_inc>
    if (*ptep & PTE_P) {
c01046ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046b0:	8b 00                	mov    (%eax),%eax
c01046b2:	83 e0 01             	and    $0x1,%eax
c01046b5:	85 c0                	test   %eax,%eax
c01046b7:	74 3e                	je     c01046f7 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c01046b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046bc:	8b 00                	mov    (%eax),%eax
c01046be:	89 04 24             	mov    %eax,(%esp)
c01046c1:	e8 e2 f3 ff ff       	call   c0103aa8 <pte2page>
c01046c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01046c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01046cf:	75 0d                	jne    c01046de <page_insert+0x6f>
            page_ref_dec(page);
c01046d1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046d4:	89 04 24             	mov    %eax,(%esp)
c01046d7:	e8 38 f4 ff ff       	call   c0103b14 <page_ref_dec>
c01046dc:	eb 19                	jmp    c01046f7 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01046de:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046e1:	89 44 24 08          	mov    %eax,0x8(%esp)
c01046e5:	8b 45 10             	mov    0x10(%ebp),%eax
c01046e8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01046ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01046ef:	89 04 24             	mov    %eax,(%esp)
c01046f2:	e8 ce fe ff ff       	call   c01045c5 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c01046f7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046fa:	89 04 24             	mov    %eax,(%esp)
c01046fd:	e8 ed f2 ff ff       	call   c01039ef <page2pa>
c0104702:	0b 45 14             	or     0x14(%ebp),%eax
c0104705:	83 c8 01             	or     $0x1,%eax
c0104708:	89 c2                	mov    %eax,%edx
c010470a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010470d:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c010470f:	8b 45 10             	mov    0x10(%ebp),%eax
c0104712:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104716:	8b 45 08             	mov    0x8(%ebp),%eax
c0104719:	89 04 24             	mov    %eax,(%esp)
c010471c:	e8 07 00 00 00       	call   c0104728 <tlb_invalidate>
    return 0;
c0104721:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104726:	c9                   	leave  
c0104727:	c3                   	ret    

c0104728 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0104728:	55                   	push   %ebp
c0104729:	89 e5                	mov    %esp,%ebp
c010472b:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c010472e:	0f 20 d8             	mov    %cr3,%eax
c0104731:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0104734:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c0104737:	89 c2                	mov    %eax,%edx
c0104739:	8b 45 08             	mov    0x8(%ebp),%eax
c010473c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010473f:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104746:	77 23                	ja     c010476b <tlb_invalidate+0x43>
c0104748:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010474b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010474f:	c7 44 24 08 00 6b 10 	movl   $0xc0106b00,0x8(%esp)
c0104756:	c0 
c0104757:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
c010475e:	00 
c010475f:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c0104766:	e8 5b c5 ff ff       	call   c0100cc6 <__panic>
c010476b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010476e:	05 00 00 00 40       	add    $0x40000000,%eax
c0104773:	39 c2                	cmp    %eax,%edx
c0104775:	75 0c                	jne    c0104783 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c0104777:	8b 45 0c             	mov    0xc(%ebp),%eax
c010477a:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c010477d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104780:	0f 01 38             	invlpg (%eax)
    }
}
c0104783:	c9                   	leave  
c0104784:	c3                   	ret    

c0104785 <check_alloc_page>:

static void
check_alloc_page(void) {
c0104785:	55                   	push   %ebp
c0104786:	89 e5                	mov    %esp,%ebp
c0104788:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c010478b:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0104790:	8b 40 18             	mov    0x18(%eax),%eax
c0104793:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0104795:	c7 04 24 84 6b 10 c0 	movl   $0xc0106b84,(%esp)
c010479c:	e8 9b bb ff ff       	call   c010033c <cprintf>
}
c01047a1:	c9                   	leave  
c01047a2:	c3                   	ret    

c01047a3 <check_pgdir>:

static void
check_pgdir(void) {
c01047a3:	55                   	push   %ebp
c01047a4:	89 e5                	mov    %esp,%ebp
c01047a6:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01047a9:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01047ae:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01047b3:	76 24                	jbe    c01047d9 <check_pgdir+0x36>
c01047b5:	c7 44 24 0c a3 6b 10 	movl   $0xc0106ba3,0xc(%esp)
c01047bc:	c0 
c01047bd:	c7 44 24 08 49 6b 10 	movl   $0xc0106b49,0x8(%esp)
c01047c4:	c0 
c01047c5:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c01047cc:	00 
c01047cd:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c01047d4:	e8 ed c4 ff ff       	call   c0100cc6 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01047d9:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01047de:	85 c0                	test   %eax,%eax
c01047e0:	74 0e                	je     c01047f0 <check_pgdir+0x4d>
c01047e2:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01047e7:	25 ff 0f 00 00       	and    $0xfff,%eax
c01047ec:	85 c0                	test   %eax,%eax
c01047ee:	74 24                	je     c0104814 <check_pgdir+0x71>
c01047f0:	c7 44 24 0c c0 6b 10 	movl   $0xc0106bc0,0xc(%esp)
c01047f7:	c0 
c01047f8:	c7 44 24 08 49 6b 10 	movl   $0xc0106b49,0x8(%esp)
c01047ff:	c0 
c0104800:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c0104807:	00 
c0104808:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c010480f:	e8 b2 c4 ff ff       	call   c0100cc6 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0104814:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104819:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104820:	00 
c0104821:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104828:	00 
c0104829:	89 04 24             	mov    %eax,(%esp)
c010482c:	e8 3b fd ff ff       	call   c010456c <get_page>
c0104831:	85 c0                	test   %eax,%eax
c0104833:	74 24                	je     c0104859 <check_pgdir+0xb6>
c0104835:	c7 44 24 0c f8 6b 10 	movl   $0xc0106bf8,0xc(%esp)
c010483c:	c0 
c010483d:	c7 44 24 08 49 6b 10 	movl   $0xc0106b49,0x8(%esp)
c0104844:	c0 
c0104845:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
c010484c:	00 
c010484d:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c0104854:	e8 6d c4 ff ff       	call   c0100cc6 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0104859:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104860:	e8 86 f4 ff ff       	call   c0103ceb <alloc_pages>
c0104865:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0104868:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010486d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104874:	00 
c0104875:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010487c:	00 
c010487d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104880:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104884:	89 04 24             	mov    %eax,(%esp)
c0104887:	e8 e3 fd ff ff       	call   c010466f <page_insert>
c010488c:	85 c0                	test   %eax,%eax
c010488e:	74 24                	je     c01048b4 <check_pgdir+0x111>
c0104890:	c7 44 24 0c 20 6c 10 	movl   $0xc0106c20,0xc(%esp)
c0104897:	c0 
c0104898:	c7 44 24 08 49 6b 10 	movl   $0xc0106b49,0x8(%esp)
c010489f:	c0 
c01048a0:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c01048a7:	00 
c01048a8:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c01048af:	e8 12 c4 ff ff       	call   c0100cc6 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01048b4:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01048b9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01048c0:	00 
c01048c1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01048c8:	00 
c01048c9:	89 04 24             	mov    %eax,(%esp)
c01048cc:	e8 59 fb ff ff       	call   c010442a <get_pte>
c01048d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01048d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01048d8:	75 24                	jne    c01048fe <check_pgdir+0x15b>
c01048da:	c7 44 24 0c 4c 6c 10 	movl   $0xc0106c4c,0xc(%esp)
c01048e1:	c0 
c01048e2:	c7 44 24 08 49 6b 10 	movl   $0xc0106b49,0x8(%esp)
c01048e9:	c0 
c01048ea:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
c01048f1:	00 
c01048f2:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c01048f9:	e8 c8 c3 ff ff       	call   c0100cc6 <__panic>
    assert(pa2page(*ptep) == p1);
c01048fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104901:	8b 00                	mov    (%eax),%eax
c0104903:	89 04 24             	mov    %eax,(%esp)
c0104906:	e8 fa f0 ff ff       	call   c0103a05 <pa2page>
c010490b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010490e:	74 24                	je     c0104934 <check_pgdir+0x191>
c0104910:	c7 44 24 0c 79 6c 10 	movl   $0xc0106c79,0xc(%esp)
c0104917:	c0 
c0104918:	c7 44 24 08 49 6b 10 	movl   $0xc0106b49,0x8(%esp)
c010491f:	c0 
c0104920:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0104927:	00 
c0104928:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c010492f:	e8 92 c3 ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p1) == 1);
c0104934:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104937:	89 04 24             	mov    %eax,(%esp)
c010493a:	e8 a7 f1 ff ff       	call   c0103ae6 <page_ref>
c010493f:	83 f8 01             	cmp    $0x1,%eax
c0104942:	74 24                	je     c0104968 <check_pgdir+0x1c5>
c0104944:	c7 44 24 0c 8e 6c 10 	movl   $0xc0106c8e,0xc(%esp)
c010494b:	c0 
c010494c:	c7 44 24 08 49 6b 10 	movl   $0xc0106b49,0x8(%esp)
c0104953:	c0 
c0104954:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c010495b:	00 
c010495c:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c0104963:	e8 5e c3 ff ff       	call   c0100cc6 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0104968:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010496d:	8b 00                	mov    (%eax),%eax
c010496f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104974:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104977:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010497a:	c1 e8 0c             	shr    $0xc,%eax
c010497d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104980:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104985:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104988:	72 23                	jb     c01049ad <check_pgdir+0x20a>
c010498a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010498d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104991:	c7 44 24 08 5c 6a 10 	movl   $0xc0106a5c,0x8(%esp)
c0104998:	c0 
c0104999:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c01049a0:	00 
c01049a1:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c01049a8:	e8 19 c3 ff ff       	call   c0100cc6 <__panic>
c01049ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049b0:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01049b5:	83 c0 04             	add    $0x4,%eax
c01049b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01049bb:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01049c0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01049c7:	00 
c01049c8:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01049cf:	00 
c01049d0:	89 04 24             	mov    %eax,(%esp)
c01049d3:	e8 52 fa ff ff       	call   c010442a <get_pte>
c01049d8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01049db:	74 24                	je     c0104a01 <check_pgdir+0x25e>
c01049dd:	c7 44 24 0c a0 6c 10 	movl   $0xc0106ca0,0xc(%esp)
c01049e4:	c0 
c01049e5:	c7 44 24 08 49 6b 10 	movl   $0xc0106b49,0x8(%esp)
c01049ec:	c0 
c01049ed:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c01049f4:	00 
c01049f5:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c01049fc:	e8 c5 c2 ff ff       	call   c0100cc6 <__panic>

    p2 = alloc_page();
c0104a01:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104a08:	e8 de f2 ff ff       	call   c0103ceb <alloc_pages>
c0104a0d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0104a10:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104a15:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0104a1c:	00 
c0104a1d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104a24:	00 
c0104a25:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104a28:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104a2c:	89 04 24             	mov    %eax,(%esp)
c0104a2f:	e8 3b fc ff ff       	call   c010466f <page_insert>
c0104a34:	85 c0                	test   %eax,%eax
c0104a36:	74 24                	je     c0104a5c <check_pgdir+0x2b9>
c0104a38:	c7 44 24 0c c8 6c 10 	movl   $0xc0106cc8,0xc(%esp)
c0104a3f:	c0 
c0104a40:	c7 44 24 08 49 6b 10 	movl   $0xc0106b49,0x8(%esp)
c0104a47:	c0 
c0104a48:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0104a4f:	00 
c0104a50:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c0104a57:	e8 6a c2 ff ff       	call   c0100cc6 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104a5c:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104a61:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a68:	00 
c0104a69:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104a70:	00 
c0104a71:	89 04 24             	mov    %eax,(%esp)
c0104a74:	e8 b1 f9 ff ff       	call   c010442a <get_pte>
c0104a79:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a7c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104a80:	75 24                	jne    c0104aa6 <check_pgdir+0x303>
c0104a82:	c7 44 24 0c 00 6d 10 	movl   $0xc0106d00,0xc(%esp)
c0104a89:	c0 
c0104a8a:	c7 44 24 08 49 6b 10 	movl   $0xc0106b49,0x8(%esp)
c0104a91:	c0 
c0104a92:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c0104a99:	00 
c0104a9a:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c0104aa1:	e8 20 c2 ff ff       	call   c0100cc6 <__panic>
    assert(*ptep & PTE_U);
c0104aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104aa9:	8b 00                	mov    (%eax),%eax
c0104aab:	83 e0 04             	and    $0x4,%eax
c0104aae:	85 c0                	test   %eax,%eax
c0104ab0:	75 24                	jne    c0104ad6 <check_pgdir+0x333>
c0104ab2:	c7 44 24 0c 30 6d 10 	movl   $0xc0106d30,0xc(%esp)
c0104ab9:	c0 
c0104aba:	c7 44 24 08 49 6b 10 	movl   $0xc0106b49,0x8(%esp)
c0104ac1:	c0 
c0104ac2:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c0104ac9:	00 
c0104aca:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c0104ad1:	e8 f0 c1 ff ff       	call   c0100cc6 <__panic>
    assert(*ptep & PTE_W);
c0104ad6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ad9:	8b 00                	mov    (%eax),%eax
c0104adb:	83 e0 02             	and    $0x2,%eax
c0104ade:	85 c0                	test   %eax,%eax
c0104ae0:	75 24                	jne    c0104b06 <check_pgdir+0x363>
c0104ae2:	c7 44 24 0c 3e 6d 10 	movl   $0xc0106d3e,0xc(%esp)
c0104ae9:	c0 
c0104aea:	c7 44 24 08 49 6b 10 	movl   $0xc0106b49,0x8(%esp)
c0104af1:	c0 
c0104af2:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c0104af9:	00 
c0104afa:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c0104b01:	e8 c0 c1 ff ff       	call   c0100cc6 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104b06:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104b0b:	8b 00                	mov    (%eax),%eax
c0104b0d:	83 e0 04             	and    $0x4,%eax
c0104b10:	85 c0                	test   %eax,%eax
c0104b12:	75 24                	jne    c0104b38 <check_pgdir+0x395>
c0104b14:	c7 44 24 0c 4c 6d 10 	movl   $0xc0106d4c,0xc(%esp)
c0104b1b:	c0 
c0104b1c:	c7 44 24 08 49 6b 10 	movl   $0xc0106b49,0x8(%esp)
c0104b23:	c0 
c0104b24:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0104b2b:	00 
c0104b2c:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c0104b33:	e8 8e c1 ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p2) == 1);
c0104b38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b3b:	89 04 24             	mov    %eax,(%esp)
c0104b3e:	e8 a3 ef ff ff       	call   c0103ae6 <page_ref>
c0104b43:	83 f8 01             	cmp    $0x1,%eax
c0104b46:	74 24                	je     c0104b6c <check_pgdir+0x3c9>
c0104b48:	c7 44 24 0c 62 6d 10 	movl   $0xc0106d62,0xc(%esp)
c0104b4f:	c0 
c0104b50:	c7 44 24 08 49 6b 10 	movl   $0xc0106b49,0x8(%esp)
c0104b57:	c0 
c0104b58:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
c0104b5f:	00 
c0104b60:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c0104b67:	e8 5a c1 ff ff       	call   c0100cc6 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104b6c:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104b71:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104b78:	00 
c0104b79:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104b80:	00 
c0104b81:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104b84:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104b88:	89 04 24             	mov    %eax,(%esp)
c0104b8b:	e8 df fa ff ff       	call   c010466f <page_insert>
c0104b90:	85 c0                	test   %eax,%eax
c0104b92:	74 24                	je     c0104bb8 <check_pgdir+0x415>
c0104b94:	c7 44 24 0c 74 6d 10 	movl   $0xc0106d74,0xc(%esp)
c0104b9b:	c0 
c0104b9c:	c7 44 24 08 49 6b 10 	movl   $0xc0106b49,0x8(%esp)
c0104ba3:	c0 
c0104ba4:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0104bab:	00 
c0104bac:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c0104bb3:	e8 0e c1 ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p1) == 2);
c0104bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bbb:	89 04 24             	mov    %eax,(%esp)
c0104bbe:	e8 23 ef ff ff       	call   c0103ae6 <page_ref>
c0104bc3:	83 f8 02             	cmp    $0x2,%eax
c0104bc6:	74 24                	je     c0104bec <check_pgdir+0x449>
c0104bc8:	c7 44 24 0c a0 6d 10 	movl   $0xc0106da0,0xc(%esp)
c0104bcf:	c0 
c0104bd0:	c7 44 24 08 49 6b 10 	movl   $0xc0106b49,0x8(%esp)
c0104bd7:	c0 
c0104bd8:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0104bdf:	00 
c0104be0:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c0104be7:	e8 da c0 ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p2) == 0);
c0104bec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104bef:	89 04 24             	mov    %eax,(%esp)
c0104bf2:	e8 ef ee ff ff       	call   c0103ae6 <page_ref>
c0104bf7:	85 c0                	test   %eax,%eax
c0104bf9:	74 24                	je     c0104c1f <check_pgdir+0x47c>
c0104bfb:	c7 44 24 0c b2 6d 10 	movl   $0xc0106db2,0xc(%esp)
c0104c02:	c0 
c0104c03:	c7 44 24 08 49 6b 10 	movl   $0xc0106b49,0x8(%esp)
c0104c0a:	c0 
c0104c0b:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c0104c12:	00 
c0104c13:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c0104c1a:	e8 a7 c0 ff ff       	call   c0100cc6 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104c1f:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104c24:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104c2b:	00 
c0104c2c:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104c33:	00 
c0104c34:	89 04 24             	mov    %eax,(%esp)
c0104c37:	e8 ee f7 ff ff       	call   c010442a <get_pte>
c0104c3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c3f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104c43:	75 24                	jne    c0104c69 <check_pgdir+0x4c6>
c0104c45:	c7 44 24 0c 00 6d 10 	movl   $0xc0106d00,0xc(%esp)
c0104c4c:	c0 
c0104c4d:	c7 44 24 08 49 6b 10 	movl   $0xc0106b49,0x8(%esp)
c0104c54:	c0 
c0104c55:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
c0104c5c:	00 
c0104c5d:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c0104c64:	e8 5d c0 ff ff       	call   c0100cc6 <__panic>
    assert(pa2page(*ptep) == p1);
c0104c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c6c:	8b 00                	mov    (%eax),%eax
c0104c6e:	89 04 24             	mov    %eax,(%esp)
c0104c71:	e8 8f ed ff ff       	call   c0103a05 <pa2page>
c0104c76:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104c79:	74 24                	je     c0104c9f <check_pgdir+0x4fc>
c0104c7b:	c7 44 24 0c 79 6c 10 	movl   $0xc0106c79,0xc(%esp)
c0104c82:	c0 
c0104c83:	c7 44 24 08 49 6b 10 	movl   $0xc0106b49,0x8(%esp)
c0104c8a:	c0 
c0104c8b:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c0104c92:	00 
c0104c93:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c0104c9a:	e8 27 c0 ff ff       	call   c0100cc6 <__panic>
    assert((*ptep & PTE_U) == 0);
c0104c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ca2:	8b 00                	mov    (%eax),%eax
c0104ca4:	83 e0 04             	and    $0x4,%eax
c0104ca7:	85 c0                	test   %eax,%eax
c0104ca9:	74 24                	je     c0104ccf <check_pgdir+0x52c>
c0104cab:	c7 44 24 0c c4 6d 10 	movl   $0xc0106dc4,0xc(%esp)
c0104cb2:	c0 
c0104cb3:	c7 44 24 08 49 6b 10 	movl   $0xc0106b49,0x8(%esp)
c0104cba:	c0 
c0104cbb:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c0104cc2:	00 
c0104cc3:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c0104cca:	e8 f7 bf ff ff       	call   c0100cc6 <__panic>

    page_remove(boot_pgdir, 0x0);
c0104ccf:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104cd4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104cdb:	00 
c0104cdc:	89 04 24             	mov    %eax,(%esp)
c0104cdf:	e8 47 f9 ff ff       	call   c010462b <page_remove>
    assert(page_ref(p1) == 1);
c0104ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ce7:	89 04 24             	mov    %eax,(%esp)
c0104cea:	e8 f7 ed ff ff       	call   c0103ae6 <page_ref>
c0104cef:	83 f8 01             	cmp    $0x1,%eax
c0104cf2:	74 24                	je     c0104d18 <check_pgdir+0x575>
c0104cf4:	c7 44 24 0c 8e 6c 10 	movl   $0xc0106c8e,0xc(%esp)
c0104cfb:	c0 
c0104cfc:	c7 44 24 08 49 6b 10 	movl   $0xc0106b49,0x8(%esp)
c0104d03:	c0 
c0104d04:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
c0104d0b:	00 
c0104d0c:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c0104d13:	e8 ae bf ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p2) == 0);
c0104d18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d1b:	89 04 24             	mov    %eax,(%esp)
c0104d1e:	e8 c3 ed ff ff       	call   c0103ae6 <page_ref>
c0104d23:	85 c0                	test   %eax,%eax
c0104d25:	74 24                	je     c0104d4b <check_pgdir+0x5a8>
c0104d27:	c7 44 24 0c b2 6d 10 	movl   $0xc0106db2,0xc(%esp)
c0104d2e:	c0 
c0104d2f:	c7 44 24 08 49 6b 10 	movl   $0xc0106b49,0x8(%esp)
c0104d36:	c0 
c0104d37:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c0104d3e:	00 
c0104d3f:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c0104d46:	e8 7b bf ff ff       	call   c0100cc6 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104d4b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104d50:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104d57:	00 
c0104d58:	89 04 24             	mov    %eax,(%esp)
c0104d5b:	e8 cb f8 ff ff       	call   c010462b <page_remove>
    assert(page_ref(p1) == 0);
c0104d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d63:	89 04 24             	mov    %eax,(%esp)
c0104d66:	e8 7b ed ff ff       	call   c0103ae6 <page_ref>
c0104d6b:	85 c0                	test   %eax,%eax
c0104d6d:	74 24                	je     c0104d93 <check_pgdir+0x5f0>
c0104d6f:	c7 44 24 0c d9 6d 10 	movl   $0xc0106dd9,0xc(%esp)
c0104d76:	c0 
c0104d77:	c7 44 24 08 49 6b 10 	movl   $0xc0106b49,0x8(%esp)
c0104d7e:	c0 
c0104d7f:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c0104d86:	00 
c0104d87:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c0104d8e:	e8 33 bf ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p2) == 0);
c0104d93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d96:	89 04 24             	mov    %eax,(%esp)
c0104d99:	e8 48 ed ff ff       	call   c0103ae6 <page_ref>
c0104d9e:	85 c0                	test   %eax,%eax
c0104da0:	74 24                	je     c0104dc6 <check_pgdir+0x623>
c0104da2:	c7 44 24 0c b2 6d 10 	movl   $0xc0106db2,0xc(%esp)
c0104da9:	c0 
c0104daa:	c7 44 24 08 49 6b 10 	movl   $0xc0106b49,0x8(%esp)
c0104db1:	c0 
c0104db2:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c0104db9:	00 
c0104dba:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c0104dc1:	e8 00 bf ff ff       	call   c0100cc6 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0104dc6:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104dcb:	8b 00                	mov    (%eax),%eax
c0104dcd:	89 04 24             	mov    %eax,(%esp)
c0104dd0:	e8 30 ec ff ff       	call   c0103a05 <pa2page>
c0104dd5:	89 04 24             	mov    %eax,(%esp)
c0104dd8:	e8 09 ed ff ff       	call   c0103ae6 <page_ref>
c0104ddd:	83 f8 01             	cmp    $0x1,%eax
c0104de0:	74 24                	je     c0104e06 <check_pgdir+0x663>
c0104de2:	c7 44 24 0c ec 6d 10 	movl   $0xc0106dec,0xc(%esp)
c0104de9:	c0 
c0104dea:	c7 44 24 08 49 6b 10 	movl   $0xc0106b49,0x8(%esp)
c0104df1:	c0 
c0104df2:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
c0104df9:	00 
c0104dfa:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c0104e01:	e8 c0 be ff ff       	call   c0100cc6 <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0104e06:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104e0b:	8b 00                	mov    (%eax),%eax
c0104e0d:	89 04 24             	mov    %eax,(%esp)
c0104e10:	e8 f0 eb ff ff       	call   c0103a05 <pa2page>
c0104e15:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104e1c:	00 
c0104e1d:	89 04 24             	mov    %eax,(%esp)
c0104e20:	e8 fe ee ff ff       	call   c0103d23 <free_pages>
    boot_pgdir[0] = 0;
c0104e25:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104e2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104e30:	c7 04 24 12 6e 10 c0 	movl   $0xc0106e12,(%esp)
c0104e37:	e8 00 b5 ff ff       	call   c010033c <cprintf>
}
c0104e3c:	c9                   	leave  
c0104e3d:	c3                   	ret    

c0104e3e <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104e3e:	55                   	push   %ebp
c0104e3f:	89 e5                	mov    %esp,%ebp
c0104e41:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104e44:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104e4b:	e9 ca 00 00 00       	jmp    c0104f1a <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e53:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104e56:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e59:	c1 e8 0c             	shr    $0xc,%eax
c0104e5c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104e5f:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104e64:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104e67:	72 23                	jb     c0104e8c <check_boot_pgdir+0x4e>
c0104e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e6c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104e70:	c7 44 24 08 5c 6a 10 	movl   $0xc0106a5c,0x8(%esp)
c0104e77:	c0 
c0104e78:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
c0104e7f:	00 
c0104e80:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c0104e87:	e8 3a be ff ff       	call   c0100cc6 <__panic>
c0104e8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e8f:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104e94:	89 c2                	mov    %eax,%edx
c0104e96:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104e9b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104ea2:	00 
c0104ea3:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104ea7:	89 04 24             	mov    %eax,(%esp)
c0104eaa:	e8 7b f5 ff ff       	call   c010442a <get_pte>
c0104eaf:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104eb2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104eb6:	75 24                	jne    c0104edc <check_boot_pgdir+0x9e>
c0104eb8:	c7 44 24 0c 2c 6e 10 	movl   $0xc0106e2c,0xc(%esp)
c0104ebf:	c0 
c0104ec0:	c7 44 24 08 49 6b 10 	movl   $0xc0106b49,0x8(%esp)
c0104ec7:	c0 
c0104ec8:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
c0104ecf:	00 
c0104ed0:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c0104ed7:	e8 ea bd ff ff       	call   c0100cc6 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104edc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104edf:	8b 00                	mov    (%eax),%eax
c0104ee1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104ee6:	89 c2                	mov    %eax,%edx
c0104ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104eeb:	39 c2                	cmp    %eax,%edx
c0104eed:	74 24                	je     c0104f13 <check_boot_pgdir+0xd5>
c0104eef:	c7 44 24 0c 69 6e 10 	movl   $0xc0106e69,0xc(%esp)
c0104ef6:	c0 
c0104ef7:	c7 44 24 08 49 6b 10 	movl   $0xc0106b49,0x8(%esp)
c0104efe:	c0 
c0104eff:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
c0104f06:	00 
c0104f07:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c0104f0e:	e8 b3 bd ff ff       	call   c0100cc6 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104f13:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104f1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104f1d:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104f22:	39 c2                	cmp    %eax,%edx
c0104f24:	0f 82 26 ff ff ff    	jb     c0104e50 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104f2a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104f2f:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104f34:	8b 00                	mov    (%eax),%eax
c0104f36:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104f3b:	89 c2                	mov    %eax,%edx
c0104f3d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104f42:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104f45:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0104f4c:	77 23                	ja     c0104f71 <check_boot_pgdir+0x133>
c0104f4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f51:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104f55:	c7 44 24 08 00 6b 10 	movl   $0xc0106b00,0x8(%esp)
c0104f5c:	c0 
c0104f5d:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c0104f64:	00 
c0104f65:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c0104f6c:	e8 55 bd ff ff       	call   c0100cc6 <__panic>
c0104f71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f74:	05 00 00 00 40       	add    $0x40000000,%eax
c0104f79:	39 c2                	cmp    %eax,%edx
c0104f7b:	74 24                	je     c0104fa1 <check_boot_pgdir+0x163>
c0104f7d:	c7 44 24 0c 80 6e 10 	movl   $0xc0106e80,0xc(%esp)
c0104f84:	c0 
c0104f85:	c7 44 24 08 49 6b 10 	movl   $0xc0106b49,0x8(%esp)
c0104f8c:	c0 
c0104f8d:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c0104f94:	00 
c0104f95:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c0104f9c:	e8 25 bd ff ff       	call   c0100cc6 <__panic>

    assert(boot_pgdir[0] == 0);
c0104fa1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104fa6:	8b 00                	mov    (%eax),%eax
c0104fa8:	85 c0                	test   %eax,%eax
c0104faa:	74 24                	je     c0104fd0 <check_boot_pgdir+0x192>
c0104fac:	c7 44 24 0c b4 6e 10 	movl   $0xc0106eb4,0xc(%esp)
c0104fb3:	c0 
c0104fb4:	c7 44 24 08 49 6b 10 	movl   $0xc0106b49,0x8(%esp)
c0104fbb:	c0 
c0104fbc:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
c0104fc3:	00 
c0104fc4:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c0104fcb:	e8 f6 bc ff ff       	call   c0100cc6 <__panic>

    struct Page *p;
    p = alloc_page();
c0104fd0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104fd7:	e8 0f ed ff ff       	call   c0103ceb <alloc_pages>
c0104fdc:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0104fdf:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104fe4:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104feb:	00 
c0104fec:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0104ff3:	00 
c0104ff4:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104ff7:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104ffb:	89 04 24             	mov    %eax,(%esp)
c0104ffe:	e8 6c f6 ff ff       	call   c010466f <page_insert>
c0105003:	85 c0                	test   %eax,%eax
c0105005:	74 24                	je     c010502b <check_boot_pgdir+0x1ed>
c0105007:	c7 44 24 0c c8 6e 10 	movl   $0xc0106ec8,0xc(%esp)
c010500e:	c0 
c010500f:	c7 44 24 08 49 6b 10 	movl   $0xc0106b49,0x8(%esp)
c0105016:	c0 
c0105017:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c010501e:	00 
c010501f:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c0105026:	e8 9b bc ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p) == 1);
c010502b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010502e:	89 04 24             	mov    %eax,(%esp)
c0105031:	e8 b0 ea ff ff       	call   c0103ae6 <page_ref>
c0105036:	83 f8 01             	cmp    $0x1,%eax
c0105039:	74 24                	je     c010505f <check_boot_pgdir+0x221>
c010503b:	c7 44 24 0c f6 6e 10 	movl   $0xc0106ef6,0xc(%esp)
c0105042:	c0 
c0105043:	c7 44 24 08 49 6b 10 	movl   $0xc0106b49,0x8(%esp)
c010504a:	c0 
c010504b:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
c0105052:	00 
c0105053:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c010505a:	e8 67 bc ff ff       	call   c0100cc6 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c010505f:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105064:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c010506b:	00 
c010506c:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0105073:	00 
c0105074:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105077:	89 54 24 04          	mov    %edx,0x4(%esp)
c010507b:	89 04 24             	mov    %eax,(%esp)
c010507e:	e8 ec f5 ff ff       	call   c010466f <page_insert>
c0105083:	85 c0                	test   %eax,%eax
c0105085:	74 24                	je     c01050ab <check_boot_pgdir+0x26d>
c0105087:	c7 44 24 0c 08 6f 10 	movl   $0xc0106f08,0xc(%esp)
c010508e:	c0 
c010508f:	c7 44 24 08 49 6b 10 	movl   $0xc0106b49,0x8(%esp)
c0105096:	c0 
c0105097:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
c010509e:	00 
c010509f:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c01050a6:	e8 1b bc ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p) == 2);
c01050ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01050ae:	89 04 24             	mov    %eax,(%esp)
c01050b1:	e8 30 ea ff ff       	call   c0103ae6 <page_ref>
c01050b6:	83 f8 02             	cmp    $0x2,%eax
c01050b9:	74 24                	je     c01050df <check_boot_pgdir+0x2a1>
c01050bb:	c7 44 24 0c 3f 6f 10 	movl   $0xc0106f3f,0xc(%esp)
c01050c2:	c0 
c01050c3:	c7 44 24 08 49 6b 10 	movl   $0xc0106b49,0x8(%esp)
c01050ca:	c0 
c01050cb:	c7 44 24 04 3f 02 00 	movl   $0x23f,0x4(%esp)
c01050d2:	00 
c01050d3:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c01050da:	e8 e7 bb ff ff       	call   c0100cc6 <__panic>

    const char *str = "ucore: Hello world!!";
c01050df:	c7 45 dc 50 6f 10 c0 	movl   $0xc0106f50,-0x24(%ebp)
    strcpy((void *)0x100, str);
c01050e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01050e9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01050ed:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01050f4:	e8 1e 0a 00 00       	call   c0105b17 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c01050f9:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0105100:	00 
c0105101:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105108:	e8 83 0a 00 00       	call   c0105b90 <strcmp>
c010510d:	85 c0                	test   %eax,%eax
c010510f:	74 24                	je     c0105135 <check_boot_pgdir+0x2f7>
c0105111:	c7 44 24 0c 68 6f 10 	movl   $0xc0106f68,0xc(%esp)
c0105118:	c0 
c0105119:	c7 44 24 08 49 6b 10 	movl   $0xc0106b49,0x8(%esp)
c0105120:	c0 
c0105121:	c7 44 24 04 43 02 00 	movl   $0x243,0x4(%esp)
c0105128:	00 
c0105129:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c0105130:	e8 91 bb ff ff       	call   c0100cc6 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0105135:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105138:	89 04 24             	mov    %eax,(%esp)
c010513b:	e8 14 e9 ff ff       	call   c0103a54 <page2kva>
c0105140:	05 00 01 00 00       	add    $0x100,%eax
c0105145:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0105148:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010514f:	e8 6b 09 00 00       	call   c0105abf <strlen>
c0105154:	85 c0                	test   %eax,%eax
c0105156:	74 24                	je     c010517c <check_boot_pgdir+0x33e>
c0105158:	c7 44 24 0c a0 6f 10 	movl   $0xc0106fa0,0xc(%esp)
c010515f:	c0 
c0105160:	c7 44 24 08 49 6b 10 	movl   $0xc0106b49,0x8(%esp)
c0105167:	c0 
c0105168:	c7 44 24 04 46 02 00 	movl   $0x246,0x4(%esp)
c010516f:	00 
c0105170:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c0105177:	e8 4a bb ff ff       	call   c0100cc6 <__panic>

    free_page(p);
c010517c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105183:	00 
c0105184:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105187:	89 04 24             	mov    %eax,(%esp)
c010518a:	e8 94 eb ff ff       	call   c0103d23 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c010518f:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105194:	8b 00                	mov    (%eax),%eax
c0105196:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010519b:	89 04 24             	mov    %eax,(%esp)
c010519e:	e8 62 e8 ff ff       	call   c0103a05 <pa2page>
c01051a3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01051aa:	00 
c01051ab:	89 04 24             	mov    %eax,(%esp)
c01051ae:	e8 70 eb ff ff       	call   c0103d23 <free_pages>
    boot_pgdir[0] = 0;
c01051b3:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01051b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c01051be:	c7 04 24 c4 6f 10 c0 	movl   $0xc0106fc4,(%esp)
c01051c5:	e8 72 b1 ff ff       	call   c010033c <cprintf>
}
c01051ca:	c9                   	leave  
c01051cb:	c3                   	ret    

c01051cc <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c01051cc:	55                   	push   %ebp
c01051cd:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01051cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01051d2:	83 e0 04             	and    $0x4,%eax
c01051d5:	85 c0                	test   %eax,%eax
c01051d7:	74 07                	je     c01051e0 <perm2str+0x14>
c01051d9:	b8 75 00 00 00       	mov    $0x75,%eax
c01051de:	eb 05                	jmp    c01051e5 <perm2str+0x19>
c01051e0:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01051e5:	a2 48 89 11 c0       	mov    %al,0xc0118948
    str[1] = 'r';
c01051ea:	c6 05 49 89 11 c0 72 	movb   $0x72,0xc0118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c01051f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01051f4:	83 e0 02             	and    $0x2,%eax
c01051f7:	85 c0                	test   %eax,%eax
c01051f9:	74 07                	je     c0105202 <perm2str+0x36>
c01051fb:	b8 77 00 00 00       	mov    $0x77,%eax
c0105200:	eb 05                	jmp    c0105207 <perm2str+0x3b>
c0105202:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105207:	a2 4a 89 11 c0       	mov    %al,0xc011894a
    str[3] = '\0';
c010520c:	c6 05 4b 89 11 c0 00 	movb   $0x0,0xc011894b
    return str;
c0105213:	b8 48 89 11 c0       	mov    $0xc0118948,%eax
}
c0105218:	5d                   	pop    %ebp
c0105219:	c3                   	ret    

c010521a <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c010521a:	55                   	push   %ebp
c010521b:	89 e5                	mov    %esp,%ebp
c010521d:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0105220:	8b 45 10             	mov    0x10(%ebp),%eax
c0105223:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105226:	72 0a                	jb     c0105232 <get_pgtable_items+0x18>
        return 0;
c0105228:	b8 00 00 00 00       	mov    $0x0,%eax
c010522d:	e9 9c 00 00 00       	jmp    c01052ce <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105232:	eb 04                	jmp    c0105238 <get_pgtable_items+0x1e>
        start ++;
c0105234:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105238:	8b 45 10             	mov    0x10(%ebp),%eax
c010523b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010523e:	73 18                	jae    c0105258 <get_pgtable_items+0x3e>
c0105240:	8b 45 10             	mov    0x10(%ebp),%eax
c0105243:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010524a:	8b 45 14             	mov    0x14(%ebp),%eax
c010524d:	01 d0                	add    %edx,%eax
c010524f:	8b 00                	mov    (%eax),%eax
c0105251:	83 e0 01             	and    $0x1,%eax
c0105254:	85 c0                	test   %eax,%eax
c0105256:	74 dc                	je     c0105234 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c0105258:	8b 45 10             	mov    0x10(%ebp),%eax
c010525b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010525e:	73 69                	jae    c01052c9 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0105260:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0105264:	74 08                	je     c010526e <get_pgtable_items+0x54>
            *left_store = start;
c0105266:	8b 45 18             	mov    0x18(%ebp),%eax
c0105269:	8b 55 10             	mov    0x10(%ebp),%edx
c010526c:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c010526e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105271:	8d 50 01             	lea    0x1(%eax),%edx
c0105274:	89 55 10             	mov    %edx,0x10(%ebp)
c0105277:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010527e:	8b 45 14             	mov    0x14(%ebp),%eax
c0105281:	01 d0                	add    %edx,%eax
c0105283:	8b 00                	mov    (%eax),%eax
c0105285:	83 e0 07             	and    $0x7,%eax
c0105288:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c010528b:	eb 04                	jmp    c0105291 <get_pgtable_items+0x77>
            start ++;
c010528d:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105291:	8b 45 10             	mov    0x10(%ebp),%eax
c0105294:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105297:	73 1d                	jae    c01052b6 <get_pgtable_items+0x9c>
c0105299:	8b 45 10             	mov    0x10(%ebp),%eax
c010529c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01052a3:	8b 45 14             	mov    0x14(%ebp),%eax
c01052a6:	01 d0                	add    %edx,%eax
c01052a8:	8b 00                	mov    (%eax),%eax
c01052aa:	83 e0 07             	and    $0x7,%eax
c01052ad:	89 c2                	mov    %eax,%edx
c01052af:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01052b2:	39 c2                	cmp    %eax,%edx
c01052b4:	74 d7                	je     c010528d <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c01052b6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01052ba:	74 08                	je     c01052c4 <get_pgtable_items+0xaa>
            *right_store = start;
c01052bc:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01052bf:	8b 55 10             	mov    0x10(%ebp),%edx
c01052c2:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01052c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01052c7:	eb 05                	jmp    c01052ce <get_pgtable_items+0xb4>
    }
    return 0;
c01052c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01052ce:	c9                   	leave  
c01052cf:	c3                   	ret    

c01052d0 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01052d0:	55                   	push   %ebp
c01052d1:	89 e5                	mov    %esp,%ebp
c01052d3:	57                   	push   %edi
c01052d4:	56                   	push   %esi
c01052d5:	53                   	push   %ebx
c01052d6:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01052d9:	c7 04 24 e4 6f 10 c0 	movl   $0xc0106fe4,(%esp)
c01052e0:	e8 57 b0 ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
c01052e5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01052ec:	e9 fa 00 00 00       	jmp    c01053eb <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01052f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01052f4:	89 04 24             	mov    %eax,(%esp)
c01052f7:	e8 d0 fe ff ff       	call   c01051cc <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c01052fc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01052ff:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105302:	29 d1                	sub    %edx,%ecx
c0105304:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105306:	89 d6                	mov    %edx,%esi
c0105308:	c1 e6 16             	shl    $0x16,%esi
c010530b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010530e:	89 d3                	mov    %edx,%ebx
c0105310:	c1 e3 16             	shl    $0x16,%ebx
c0105313:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105316:	89 d1                	mov    %edx,%ecx
c0105318:	c1 e1 16             	shl    $0x16,%ecx
c010531b:	8b 7d dc             	mov    -0x24(%ebp),%edi
c010531e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105321:	29 d7                	sub    %edx,%edi
c0105323:	89 fa                	mov    %edi,%edx
c0105325:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105329:	89 74 24 10          	mov    %esi,0x10(%esp)
c010532d:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105331:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105335:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105339:	c7 04 24 15 70 10 c0 	movl   $0xc0107015,(%esp)
c0105340:	e8 f7 af ff ff       	call   c010033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0105345:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105348:	c1 e0 0a             	shl    $0xa,%eax
c010534b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010534e:	eb 54                	jmp    c01053a4 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105350:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105353:	89 04 24             	mov    %eax,(%esp)
c0105356:	e8 71 fe ff ff       	call   c01051cc <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c010535b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c010535e:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105361:	29 d1                	sub    %edx,%ecx
c0105363:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105365:	89 d6                	mov    %edx,%esi
c0105367:	c1 e6 0c             	shl    $0xc,%esi
c010536a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010536d:	89 d3                	mov    %edx,%ebx
c010536f:	c1 e3 0c             	shl    $0xc,%ebx
c0105372:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105375:	c1 e2 0c             	shl    $0xc,%edx
c0105378:	89 d1                	mov    %edx,%ecx
c010537a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c010537d:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105380:	29 d7                	sub    %edx,%edi
c0105382:	89 fa                	mov    %edi,%edx
c0105384:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105388:	89 74 24 10          	mov    %esi,0x10(%esp)
c010538c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105390:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105394:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105398:	c7 04 24 34 70 10 c0 	movl   $0xc0107034,(%esp)
c010539f:	e8 98 af ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01053a4:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c01053a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01053ac:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01053af:	89 ce                	mov    %ecx,%esi
c01053b1:	c1 e6 0a             	shl    $0xa,%esi
c01053b4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c01053b7:	89 cb                	mov    %ecx,%ebx
c01053b9:	c1 e3 0a             	shl    $0xa,%ebx
c01053bc:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c01053bf:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01053c3:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c01053c6:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01053ca:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01053ce:	89 44 24 08          	mov    %eax,0x8(%esp)
c01053d2:	89 74 24 04          	mov    %esi,0x4(%esp)
c01053d6:	89 1c 24             	mov    %ebx,(%esp)
c01053d9:	e8 3c fe ff ff       	call   c010521a <get_pgtable_items>
c01053de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01053e1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01053e5:	0f 85 65 ff ff ff    	jne    c0105350 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01053eb:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c01053f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01053f3:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c01053f6:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01053fa:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c01053fd:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105401:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105405:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105409:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0105410:	00 
c0105411:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0105418:	e8 fd fd ff ff       	call   c010521a <get_pgtable_items>
c010541d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105420:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105424:	0f 85 c7 fe ff ff    	jne    c01052f1 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c010542a:	c7 04 24 58 70 10 c0 	movl   $0xc0107058,(%esp)
c0105431:	e8 06 af ff ff       	call   c010033c <cprintf>
}
c0105436:	83 c4 4c             	add    $0x4c,%esp
c0105439:	5b                   	pop    %ebx
c010543a:	5e                   	pop    %esi
c010543b:	5f                   	pop    %edi
c010543c:	5d                   	pop    %ebp
c010543d:	c3                   	ret    

c010543e <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c010543e:	55                   	push   %ebp
c010543f:	89 e5                	mov    %esp,%ebp
c0105441:	83 ec 58             	sub    $0x58,%esp
c0105444:	8b 45 10             	mov    0x10(%ebp),%eax
c0105447:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010544a:	8b 45 14             	mov    0x14(%ebp),%eax
c010544d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105450:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105453:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105456:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105459:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c010545c:	8b 45 18             	mov    0x18(%ebp),%eax
c010545f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105462:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105465:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105468:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010546b:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010546e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105471:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105474:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105478:	74 1c                	je     c0105496 <printnum+0x58>
c010547a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010547d:	ba 00 00 00 00       	mov    $0x0,%edx
c0105482:	f7 75 e4             	divl   -0x1c(%ebp)
c0105485:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105488:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010548b:	ba 00 00 00 00       	mov    $0x0,%edx
c0105490:	f7 75 e4             	divl   -0x1c(%ebp)
c0105493:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105496:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105499:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010549c:	f7 75 e4             	divl   -0x1c(%ebp)
c010549f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01054a2:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01054a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01054a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01054ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01054ae:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01054b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01054b4:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c01054b7:	8b 45 18             	mov    0x18(%ebp),%eax
c01054ba:	ba 00 00 00 00       	mov    $0x0,%edx
c01054bf:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01054c2:	77 56                	ja     c010551a <printnum+0xdc>
c01054c4:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01054c7:	72 05                	jb     c01054ce <printnum+0x90>
c01054c9:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01054cc:	77 4c                	ja     c010551a <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c01054ce:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01054d1:	8d 50 ff             	lea    -0x1(%eax),%edx
c01054d4:	8b 45 20             	mov    0x20(%ebp),%eax
c01054d7:	89 44 24 18          	mov    %eax,0x18(%esp)
c01054db:	89 54 24 14          	mov    %edx,0x14(%esp)
c01054df:	8b 45 18             	mov    0x18(%ebp),%eax
c01054e2:	89 44 24 10          	mov    %eax,0x10(%esp)
c01054e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01054e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01054ec:	89 44 24 08          	mov    %eax,0x8(%esp)
c01054f0:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01054f4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054f7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01054fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01054fe:	89 04 24             	mov    %eax,(%esp)
c0105501:	e8 38 ff ff ff       	call   c010543e <printnum>
c0105506:	eb 1c                	jmp    c0105524 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0105508:	8b 45 0c             	mov    0xc(%ebp),%eax
c010550b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010550f:	8b 45 20             	mov    0x20(%ebp),%eax
c0105512:	89 04 24             	mov    %eax,(%esp)
c0105515:	8b 45 08             	mov    0x8(%ebp),%eax
c0105518:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c010551a:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c010551e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105522:	7f e4                	jg     c0105508 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0105524:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105527:	05 0c 71 10 c0       	add    $0xc010710c,%eax
c010552c:	0f b6 00             	movzbl (%eax),%eax
c010552f:	0f be c0             	movsbl %al,%eax
c0105532:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105535:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105539:	89 04 24             	mov    %eax,(%esp)
c010553c:	8b 45 08             	mov    0x8(%ebp),%eax
c010553f:	ff d0                	call   *%eax
}
c0105541:	c9                   	leave  
c0105542:	c3                   	ret    

c0105543 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105543:	55                   	push   %ebp
c0105544:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105546:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010554a:	7e 14                	jle    c0105560 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c010554c:	8b 45 08             	mov    0x8(%ebp),%eax
c010554f:	8b 00                	mov    (%eax),%eax
c0105551:	8d 48 08             	lea    0x8(%eax),%ecx
c0105554:	8b 55 08             	mov    0x8(%ebp),%edx
c0105557:	89 0a                	mov    %ecx,(%edx)
c0105559:	8b 50 04             	mov    0x4(%eax),%edx
c010555c:	8b 00                	mov    (%eax),%eax
c010555e:	eb 30                	jmp    c0105590 <getuint+0x4d>
    }
    else if (lflag) {
c0105560:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105564:	74 16                	je     c010557c <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0105566:	8b 45 08             	mov    0x8(%ebp),%eax
c0105569:	8b 00                	mov    (%eax),%eax
c010556b:	8d 48 04             	lea    0x4(%eax),%ecx
c010556e:	8b 55 08             	mov    0x8(%ebp),%edx
c0105571:	89 0a                	mov    %ecx,(%edx)
c0105573:	8b 00                	mov    (%eax),%eax
c0105575:	ba 00 00 00 00       	mov    $0x0,%edx
c010557a:	eb 14                	jmp    c0105590 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c010557c:	8b 45 08             	mov    0x8(%ebp),%eax
c010557f:	8b 00                	mov    (%eax),%eax
c0105581:	8d 48 04             	lea    0x4(%eax),%ecx
c0105584:	8b 55 08             	mov    0x8(%ebp),%edx
c0105587:	89 0a                	mov    %ecx,(%edx)
c0105589:	8b 00                	mov    (%eax),%eax
c010558b:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105590:	5d                   	pop    %ebp
c0105591:	c3                   	ret    

c0105592 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0105592:	55                   	push   %ebp
c0105593:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105595:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105599:	7e 14                	jle    c01055af <getint+0x1d>
        return va_arg(*ap, long long);
c010559b:	8b 45 08             	mov    0x8(%ebp),%eax
c010559e:	8b 00                	mov    (%eax),%eax
c01055a0:	8d 48 08             	lea    0x8(%eax),%ecx
c01055a3:	8b 55 08             	mov    0x8(%ebp),%edx
c01055a6:	89 0a                	mov    %ecx,(%edx)
c01055a8:	8b 50 04             	mov    0x4(%eax),%edx
c01055ab:	8b 00                	mov    (%eax),%eax
c01055ad:	eb 28                	jmp    c01055d7 <getint+0x45>
    }
    else if (lflag) {
c01055af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01055b3:	74 12                	je     c01055c7 <getint+0x35>
        return va_arg(*ap, long);
c01055b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01055b8:	8b 00                	mov    (%eax),%eax
c01055ba:	8d 48 04             	lea    0x4(%eax),%ecx
c01055bd:	8b 55 08             	mov    0x8(%ebp),%edx
c01055c0:	89 0a                	mov    %ecx,(%edx)
c01055c2:	8b 00                	mov    (%eax),%eax
c01055c4:	99                   	cltd   
c01055c5:	eb 10                	jmp    c01055d7 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01055c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01055ca:	8b 00                	mov    (%eax),%eax
c01055cc:	8d 48 04             	lea    0x4(%eax),%ecx
c01055cf:	8b 55 08             	mov    0x8(%ebp),%edx
c01055d2:	89 0a                	mov    %ecx,(%edx)
c01055d4:	8b 00                	mov    (%eax),%eax
c01055d6:	99                   	cltd   
    }
}
c01055d7:	5d                   	pop    %ebp
c01055d8:	c3                   	ret    

c01055d9 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01055d9:	55                   	push   %ebp
c01055da:	89 e5                	mov    %esp,%ebp
c01055dc:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c01055df:	8d 45 14             	lea    0x14(%ebp),%eax
c01055e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01055e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01055e8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01055ec:	8b 45 10             	mov    0x10(%ebp),%eax
c01055ef:	89 44 24 08          	mov    %eax,0x8(%esp)
c01055f3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01055fd:	89 04 24             	mov    %eax,(%esp)
c0105600:	e8 02 00 00 00       	call   c0105607 <vprintfmt>
    va_end(ap);
}
c0105605:	c9                   	leave  
c0105606:	c3                   	ret    

c0105607 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0105607:	55                   	push   %ebp
c0105608:	89 e5                	mov    %esp,%ebp
c010560a:	56                   	push   %esi
c010560b:	53                   	push   %ebx
c010560c:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010560f:	eb 18                	jmp    c0105629 <vprintfmt+0x22>
            if (ch == '\0') {
c0105611:	85 db                	test   %ebx,%ebx
c0105613:	75 05                	jne    c010561a <vprintfmt+0x13>
                return;
c0105615:	e9 d1 03 00 00       	jmp    c01059eb <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c010561a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010561d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105621:	89 1c 24             	mov    %ebx,(%esp)
c0105624:	8b 45 08             	mov    0x8(%ebp),%eax
c0105627:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105629:	8b 45 10             	mov    0x10(%ebp),%eax
c010562c:	8d 50 01             	lea    0x1(%eax),%edx
c010562f:	89 55 10             	mov    %edx,0x10(%ebp)
c0105632:	0f b6 00             	movzbl (%eax),%eax
c0105635:	0f b6 d8             	movzbl %al,%ebx
c0105638:	83 fb 25             	cmp    $0x25,%ebx
c010563b:	75 d4                	jne    c0105611 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c010563d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105641:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0105648:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010564b:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c010564e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105655:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105658:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c010565b:	8b 45 10             	mov    0x10(%ebp),%eax
c010565e:	8d 50 01             	lea    0x1(%eax),%edx
c0105661:	89 55 10             	mov    %edx,0x10(%ebp)
c0105664:	0f b6 00             	movzbl (%eax),%eax
c0105667:	0f b6 d8             	movzbl %al,%ebx
c010566a:	8d 43 dd             	lea    -0x23(%ebx),%eax
c010566d:	83 f8 55             	cmp    $0x55,%eax
c0105670:	0f 87 44 03 00 00    	ja     c01059ba <vprintfmt+0x3b3>
c0105676:	8b 04 85 30 71 10 c0 	mov    -0x3fef8ed0(,%eax,4),%eax
c010567d:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c010567f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105683:	eb d6                	jmp    c010565b <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105685:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105689:	eb d0                	jmp    c010565b <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010568b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105692:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105695:	89 d0                	mov    %edx,%eax
c0105697:	c1 e0 02             	shl    $0x2,%eax
c010569a:	01 d0                	add    %edx,%eax
c010569c:	01 c0                	add    %eax,%eax
c010569e:	01 d8                	add    %ebx,%eax
c01056a0:	83 e8 30             	sub    $0x30,%eax
c01056a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01056a6:	8b 45 10             	mov    0x10(%ebp),%eax
c01056a9:	0f b6 00             	movzbl (%eax),%eax
c01056ac:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c01056af:	83 fb 2f             	cmp    $0x2f,%ebx
c01056b2:	7e 0b                	jle    c01056bf <vprintfmt+0xb8>
c01056b4:	83 fb 39             	cmp    $0x39,%ebx
c01056b7:	7f 06                	jg     c01056bf <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01056b9:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c01056bd:	eb d3                	jmp    c0105692 <vprintfmt+0x8b>
            goto process_precision;
c01056bf:	eb 33                	jmp    c01056f4 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c01056c1:	8b 45 14             	mov    0x14(%ebp),%eax
c01056c4:	8d 50 04             	lea    0x4(%eax),%edx
c01056c7:	89 55 14             	mov    %edx,0x14(%ebp)
c01056ca:	8b 00                	mov    (%eax),%eax
c01056cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01056cf:	eb 23                	jmp    c01056f4 <vprintfmt+0xed>

        case '.':
            if (width < 0)
c01056d1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01056d5:	79 0c                	jns    c01056e3 <vprintfmt+0xdc>
                width = 0;
c01056d7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01056de:	e9 78 ff ff ff       	jmp    c010565b <vprintfmt+0x54>
c01056e3:	e9 73 ff ff ff       	jmp    c010565b <vprintfmt+0x54>

        case '#':
            altflag = 1;
c01056e8:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01056ef:	e9 67 ff ff ff       	jmp    c010565b <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c01056f4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01056f8:	79 12                	jns    c010570c <vprintfmt+0x105>
                width = precision, precision = -1;
c01056fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01056fd:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105700:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0105707:	e9 4f ff ff ff       	jmp    c010565b <vprintfmt+0x54>
c010570c:	e9 4a ff ff ff       	jmp    c010565b <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105711:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c0105715:	e9 41 ff ff ff       	jmp    c010565b <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c010571a:	8b 45 14             	mov    0x14(%ebp),%eax
c010571d:	8d 50 04             	lea    0x4(%eax),%edx
c0105720:	89 55 14             	mov    %edx,0x14(%ebp)
c0105723:	8b 00                	mov    (%eax),%eax
c0105725:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105728:	89 54 24 04          	mov    %edx,0x4(%esp)
c010572c:	89 04 24             	mov    %eax,(%esp)
c010572f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105732:	ff d0                	call   *%eax
            break;
c0105734:	e9 ac 02 00 00       	jmp    c01059e5 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0105739:	8b 45 14             	mov    0x14(%ebp),%eax
c010573c:	8d 50 04             	lea    0x4(%eax),%edx
c010573f:	89 55 14             	mov    %edx,0x14(%ebp)
c0105742:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105744:	85 db                	test   %ebx,%ebx
c0105746:	79 02                	jns    c010574a <vprintfmt+0x143>
                err = -err;
c0105748:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c010574a:	83 fb 06             	cmp    $0x6,%ebx
c010574d:	7f 0b                	jg     c010575a <vprintfmt+0x153>
c010574f:	8b 34 9d f0 70 10 c0 	mov    -0x3fef8f10(,%ebx,4),%esi
c0105756:	85 f6                	test   %esi,%esi
c0105758:	75 23                	jne    c010577d <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c010575a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010575e:	c7 44 24 08 1d 71 10 	movl   $0xc010711d,0x8(%esp)
c0105765:	c0 
c0105766:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105769:	89 44 24 04          	mov    %eax,0x4(%esp)
c010576d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105770:	89 04 24             	mov    %eax,(%esp)
c0105773:	e8 61 fe ff ff       	call   c01055d9 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105778:	e9 68 02 00 00       	jmp    c01059e5 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c010577d:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105781:	c7 44 24 08 26 71 10 	movl   $0xc0107126,0x8(%esp)
c0105788:	c0 
c0105789:	8b 45 0c             	mov    0xc(%ebp),%eax
c010578c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105790:	8b 45 08             	mov    0x8(%ebp),%eax
c0105793:	89 04 24             	mov    %eax,(%esp)
c0105796:	e8 3e fe ff ff       	call   c01055d9 <printfmt>
            }
            break;
c010579b:	e9 45 02 00 00       	jmp    c01059e5 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c01057a0:	8b 45 14             	mov    0x14(%ebp),%eax
c01057a3:	8d 50 04             	lea    0x4(%eax),%edx
c01057a6:	89 55 14             	mov    %edx,0x14(%ebp)
c01057a9:	8b 30                	mov    (%eax),%esi
c01057ab:	85 f6                	test   %esi,%esi
c01057ad:	75 05                	jne    c01057b4 <vprintfmt+0x1ad>
                p = "(null)";
c01057af:	be 29 71 10 c0       	mov    $0xc0107129,%esi
            }
            if (width > 0 && padc != '-') {
c01057b4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01057b8:	7e 3e                	jle    c01057f8 <vprintfmt+0x1f1>
c01057ba:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01057be:	74 38                	je     c01057f8 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01057c0:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c01057c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01057c6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057ca:	89 34 24             	mov    %esi,(%esp)
c01057cd:	e8 15 03 00 00       	call   c0105ae7 <strnlen>
c01057d2:	29 c3                	sub    %eax,%ebx
c01057d4:	89 d8                	mov    %ebx,%eax
c01057d6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01057d9:	eb 17                	jmp    c01057f2 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c01057db:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01057df:	8b 55 0c             	mov    0xc(%ebp),%edx
c01057e2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01057e6:	89 04 24             	mov    %eax,(%esp)
c01057e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01057ec:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c01057ee:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01057f2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01057f6:	7f e3                	jg     c01057db <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01057f8:	eb 38                	jmp    c0105832 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c01057fa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01057fe:	74 1f                	je     c010581f <vprintfmt+0x218>
c0105800:	83 fb 1f             	cmp    $0x1f,%ebx
c0105803:	7e 05                	jle    c010580a <vprintfmt+0x203>
c0105805:	83 fb 7e             	cmp    $0x7e,%ebx
c0105808:	7e 15                	jle    c010581f <vprintfmt+0x218>
                    putch('?', putdat);
c010580a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010580d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105811:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0105818:	8b 45 08             	mov    0x8(%ebp),%eax
c010581b:	ff d0                	call   *%eax
c010581d:	eb 0f                	jmp    c010582e <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c010581f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105822:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105826:	89 1c 24             	mov    %ebx,(%esp)
c0105829:	8b 45 08             	mov    0x8(%ebp),%eax
c010582c:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010582e:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105832:	89 f0                	mov    %esi,%eax
c0105834:	8d 70 01             	lea    0x1(%eax),%esi
c0105837:	0f b6 00             	movzbl (%eax),%eax
c010583a:	0f be d8             	movsbl %al,%ebx
c010583d:	85 db                	test   %ebx,%ebx
c010583f:	74 10                	je     c0105851 <vprintfmt+0x24a>
c0105841:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105845:	78 b3                	js     c01057fa <vprintfmt+0x1f3>
c0105847:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c010584b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010584f:	79 a9                	jns    c01057fa <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105851:	eb 17                	jmp    c010586a <vprintfmt+0x263>
                putch(' ', putdat);
c0105853:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105856:	89 44 24 04          	mov    %eax,0x4(%esp)
c010585a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0105861:	8b 45 08             	mov    0x8(%ebp),%eax
c0105864:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105866:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010586a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010586e:	7f e3                	jg     c0105853 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c0105870:	e9 70 01 00 00       	jmp    c01059e5 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105875:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105878:	89 44 24 04          	mov    %eax,0x4(%esp)
c010587c:	8d 45 14             	lea    0x14(%ebp),%eax
c010587f:	89 04 24             	mov    %eax,(%esp)
c0105882:	e8 0b fd ff ff       	call   c0105592 <getint>
c0105887:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010588a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c010588d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105890:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105893:	85 d2                	test   %edx,%edx
c0105895:	79 26                	jns    c01058bd <vprintfmt+0x2b6>
                putch('-', putdat);
c0105897:	8b 45 0c             	mov    0xc(%ebp),%eax
c010589a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010589e:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c01058a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01058a8:	ff d0                	call   *%eax
                num = -(long long)num;
c01058aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01058b0:	f7 d8                	neg    %eax
c01058b2:	83 d2 00             	adc    $0x0,%edx
c01058b5:	f7 da                	neg    %edx
c01058b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058ba:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01058bd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01058c4:	e9 a8 00 00 00       	jmp    c0105971 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01058c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058cc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058d0:	8d 45 14             	lea    0x14(%ebp),%eax
c01058d3:	89 04 24             	mov    %eax,(%esp)
c01058d6:	e8 68 fc ff ff       	call   c0105543 <getuint>
c01058db:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058de:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01058e1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01058e8:	e9 84 00 00 00       	jmp    c0105971 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c01058ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058f0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058f4:	8d 45 14             	lea    0x14(%ebp),%eax
c01058f7:	89 04 24             	mov    %eax,(%esp)
c01058fa:	e8 44 fc ff ff       	call   c0105543 <getuint>
c01058ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105902:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105905:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c010590c:	eb 63                	jmp    c0105971 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c010590e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105911:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105915:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c010591c:	8b 45 08             	mov    0x8(%ebp),%eax
c010591f:	ff d0                	call   *%eax
            putch('x', putdat);
c0105921:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105924:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105928:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c010592f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105932:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105934:	8b 45 14             	mov    0x14(%ebp),%eax
c0105937:	8d 50 04             	lea    0x4(%eax),%edx
c010593a:	89 55 14             	mov    %edx,0x14(%ebp)
c010593d:	8b 00                	mov    (%eax),%eax
c010593f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105942:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105949:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105950:	eb 1f                	jmp    c0105971 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105952:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105955:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105959:	8d 45 14             	lea    0x14(%ebp),%eax
c010595c:	89 04 24             	mov    %eax,(%esp)
c010595f:	e8 df fb ff ff       	call   c0105543 <getuint>
c0105964:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105967:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c010596a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105971:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105975:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105978:	89 54 24 18          	mov    %edx,0x18(%esp)
c010597c:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010597f:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105983:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105987:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010598a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010598d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105991:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105995:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105998:	89 44 24 04          	mov    %eax,0x4(%esp)
c010599c:	8b 45 08             	mov    0x8(%ebp),%eax
c010599f:	89 04 24             	mov    %eax,(%esp)
c01059a2:	e8 97 fa ff ff       	call   c010543e <printnum>
            break;
c01059a7:	eb 3c                	jmp    c01059e5 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01059a9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059ac:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059b0:	89 1c 24             	mov    %ebx,(%esp)
c01059b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01059b6:	ff d0                	call   *%eax
            break;
c01059b8:	eb 2b                	jmp    c01059e5 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c01059ba:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059bd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059c1:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c01059c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01059cb:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c01059cd:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01059d1:	eb 04                	jmp    c01059d7 <vprintfmt+0x3d0>
c01059d3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01059d7:	8b 45 10             	mov    0x10(%ebp),%eax
c01059da:	83 e8 01             	sub    $0x1,%eax
c01059dd:	0f b6 00             	movzbl (%eax),%eax
c01059e0:	3c 25                	cmp    $0x25,%al
c01059e2:	75 ef                	jne    c01059d3 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c01059e4:	90                   	nop
        }
    }
c01059e5:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01059e6:	e9 3e fc ff ff       	jmp    c0105629 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c01059eb:	83 c4 40             	add    $0x40,%esp
c01059ee:	5b                   	pop    %ebx
c01059ef:	5e                   	pop    %esi
c01059f0:	5d                   	pop    %ebp
c01059f1:	c3                   	ret    

c01059f2 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c01059f2:	55                   	push   %ebp
c01059f3:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c01059f5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059f8:	8b 40 08             	mov    0x8(%eax),%eax
c01059fb:	8d 50 01             	lea    0x1(%eax),%edx
c01059fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a01:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105a04:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a07:	8b 10                	mov    (%eax),%edx
c0105a09:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a0c:	8b 40 04             	mov    0x4(%eax),%eax
c0105a0f:	39 c2                	cmp    %eax,%edx
c0105a11:	73 12                	jae    c0105a25 <sprintputch+0x33>
        *b->buf ++ = ch;
c0105a13:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a16:	8b 00                	mov    (%eax),%eax
c0105a18:	8d 48 01             	lea    0x1(%eax),%ecx
c0105a1b:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105a1e:	89 0a                	mov    %ecx,(%edx)
c0105a20:	8b 55 08             	mov    0x8(%ebp),%edx
c0105a23:	88 10                	mov    %dl,(%eax)
    }
}
c0105a25:	5d                   	pop    %ebp
c0105a26:	c3                   	ret    

c0105a27 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105a27:	55                   	push   %ebp
c0105a28:	89 e5                	mov    %esp,%ebp
c0105a2a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105a2d:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a30:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105a33:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a36:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105a3a:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a3d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a41:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a44:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a48:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a4b:	89 04 24             	mov    %eax,(%esp)
c0105a4e:	e8 08 00 00 00       	call   c0105a5b <vsnprintf>
c0105a53:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105a59:	c9                   	leave  
c0105a5a:	c3                   	ret    

c0105a5b <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105a5b:	55                   	push   %ebp
c0105a5c:	89 e5                	mov    %esp,%ebp
c0105a5e:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105a61:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a64:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105a67:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a6a:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105a6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a70:	01 d0                	add    %edx,%eax
c0105a72:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105a7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105a80:	74 0a                	je     c0105a8c <vsnprintf+0x31>
c0105a82:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105a85:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a88:	39 c2                	cmp    %eax,%edx
c0105a8a:	76 07                	jbe    c0105a93 <vsnprintf+0x38>
        return -E_INVAL;
c0105a8c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105a91:	eb 2a                	jmp    c0105abd <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105a93:	8b 45 14             	mov    0x14(%ebp),%eax
c0105a96:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105a9a:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a9d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105aa1:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105aa4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105aa8:	c7 04 24 f2 59 10 c0 	movl   $0xc01059f2,(%esp)
c0105aaf:	e8 53 fb ff ff       	call   c0105607 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105ab4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ab7:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105abd:	c9                   	leave  
c0105abe:	c3                   	ret    

c0105abf <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105abf:	55                   	push   %ebp
c0105ac0:	89 e5                	mov    %esp,%ebp
c0105ac2:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105ac5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105acc:	eb 04                	jmp    c0105ad2 <strlen+0x13>
        cnt ++;
c0105ace:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0105ad2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ad5:	8d 50 01             	lea    0x1(%eax),%edx
c0105ad8:	89 55 08             	mov    %edx,0x8(%ebp)
c0105adb:	0f b6 00             	movzbl (%eax),%eax
c0105ade:	84 c0                	test   %al,%al
c0105ae0:	75 ec                	jne    c0105ace <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0105ae2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105ae5:	c9                   	leave  
c0105ae6:	c3                   	ret    

c0105ae7 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105ae7:	55                   	push   %ebp
c0105ae8:	89 e5                	mov    %esp,%ebp
c0105aea:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105aed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105af4:	eb 04                	jmp    c0105afa <strnlen+0x13>
        cnt ++;
c0105af6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0105afa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105afd:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105b00:	73 10                	jae    c0105b12 <strnlen+0x2b>
c0105b02:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b05:	8d 50 01             	lea    0x1(%eax),%edx
c0105b08:	89 55 08             	mov    %edx,0x8(%ebp)
c0105b0b:	0f b6 00             	movzbl (%eax),%eax
c0105b0e:	84 c0                	test   %al,%al
c0105b10:	75 e4                	jne    c0105af6 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0105b12:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105b15:	c9                   	leave  
c0105b16:	c3                   	ret    

c0105b17 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105b17:	55                   	push   %ebp
c0105b18:	89 e5                	mov    %esp,%ebp
c0105b1a:	57                   	push   %edi
c0105b1b:	56                   	push   %esi
c0105b1c:	83 ec 20             	sub    $0x20,%esp
c0105b1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b22:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b25:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b28:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105b2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b31:	89 d1                	mov    %edx,%ecx
c0105b33:	89 c2                	mov    %eax,%edx
c0105b35:	89 ce                	mov    %ecx,%esi
c0105b37:	89 d7                	mov    %edx,%edi
c0105b39:	ac                   	lods   %ds:(%esi),%al
c0105b3a:	aa                   	stos   %al,%es:(%edi)
c0105b3b:	84 c0                	test   %al,%al
c0105b3d:	75 fa                	jne    c0105b39 <strcpy+0x22>
c0105b3f:	89 fa                	mov    %edi,%edx
c0105b41:	89 f1                	mov    %esi,%ecx
c0105b43:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105b46:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105b49:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105b4f:	83 c4 20             	add    $0x20,%esp
c0105b52:	5e                   	pop    %esi
c0105b53:	5f                   	pop    %edi
c0105b54:	5d                   	pop    %ebp
c0105b55:	c3                   	ret    

c0105b56 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105b56:	55                   	push   %ebp
c0105b57:	89 e5                	mov    %esp,%ebp
c0105b59:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105b5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105b62:	eb 21                	jmp    c0105b85 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105b64:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b67:	0f b6 10             	movzbl (%eax),%edx
c0105b6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b6d:	88 10                	mov    %dl,(%eax)
c0105b6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b72:	0f b6 00             	movzbl (%eax),%eax
c0105b75:	84 c0                	test   %al,%al
c0105b77:	74 04                	je     c0105b7d <strncpy+0x27>
            src ++;
c0105b79:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105b7d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105b81:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0105b85:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b89:	75 d9                	jne    c0105b64 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105b8b:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105b8e:	c9                   	leave  
c0105b8f:	c3                   	ret    

c0105b90 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105b90:	55                   	push   %ebp
c0105b91:	89 e5                	mov    %esp,%ebp
c0105b93:	57                   	push   %edi
c0105b94:	56                   	push   %esi
c0105b95:	83 ec 20             	sub    $0x20,%esp
c0105b98:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b9e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ba1:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0105ba4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105baa:	89 d1                	mov    %edx,%ecx
c0105bac:	89 c2                	mov    %eax,%edx
c0105bae:	89 ce                	mov    %ecx,%esi
c0105bb0:	89 d7                	mov    %edx,%edi
c0105bb2:	ac                   	lods   %ds:(%esi),%al
c0105bb3:	ae                   	scas   %es:(%edi),%al
c0105bb4:	75 08                	jne    c0105bbe <strcmp+0x2e>
c0105bb6:	84 c0                	test   %al,%al
c0105bb8:	75 f8                	jne    c0105bb2 <strcmp+0x22>
c0105bba:	31 c0                	xor    %eax,%eax
c0105bbc:	eb 04                	jmp    c0105bc2 <strcmp+0x32>
c0105bbe:	19 c0                	sbb    %eax,%eax
c0105bc0:	0c 01                	or     $0x1,%al
c0105bc2:	89 fa                	mov    %edi,%edx
c0105bc4:	89 f1                	mov    %esi,%ecx
c0105bc6:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105bc9:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105bcc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105bcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105bd2:	83 c4 20             	add    $0x20,%esp
c0105bd5:	5e                   	pop    %esi
c0105bd6:	5f                   	pop    %edi
c0105bd7:	5d                   	pop    %ebp
c0105bd8:	c3                   	ret    

c0105bd9 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105bd9:	55                   	push   %ebp
c0105bda:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105bdc:	eb 0c                	jmp    c0105bea <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105bde:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105be2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105be6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105bea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105bee:	74 1a                	je     c0105c0a <strncmp+0x31>
c0105bf0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bf3:	0f b6 00             	movzbl (%eax),%eax
c0105bf6:	84 c0                	test   %al,%al
c0105bf8:	74 10                	je     c0105c0a <strncmp+0x31>
c0105bfa:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bfd:	0f b6 10             	movzbl (%eax),%edx
c0105c00:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c03:	0f b6 00             	movzbl (%eax),%eax
c0105c06:	38 c2                	cmp    %al,%dl
c0105c08:	74 d4                	je     c0105bde <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105c0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c0e:	74 18                	je     c0105c28 <strncmp+0x4f>
c0105c10:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c13:	0f b6 00             	movzbl (%eax),%eax
c0105c16:	0f b6 d0             	movzbl %al,%edx
c0105c19:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c1c:	0f b6 00             	movzbl (%eax),%eax
c0105c1f:	0f b6 c0             	movzbl %al,%eax
c0105c22:	29 c2                	sub    %eax,%edx
c0105c24:	89 d0                	mov    %edx,%eax
c0105c26:	eb 05                	jmp    c0105c2d <strncmp+0x54>
c0105c28:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105c2d:	5d                   	pop    %ebp
c0105c2e:	c3                   	ret    

c0105c2f <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105c2f:	55                   	push   %ebp
c0105c30:	89 e5                	mov    %esp,%ebp
c0105c32:	83 ec 04             	sub    $0x4,%esp
c0105c35:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c38:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105c3b:	eb 14                	jmp    c0105c51 <strchr+0x22>
        if (*s == c) {
c0105c3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c40:	0f b6 00             	movzbl (%eax),%eax
c0105c43:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105c46:	75 05                	jne    c0105c4d <strchr+0x1e>
            return (char *)s;
c0105c48:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c4b:	eb 13                	jmp    c0105c60 <strchr+0x31>
        }
        s ++;
c0105c4d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105c51:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c54:	0f b6 00             	movzbl (%eax),%eax
c0105c57:	84 c0                	test   %al,%al
c0105c59:	75 e2                	jne    c0105c3d <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105c5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105c60:	c9                   	leave  
c0105c61:	c3                   	ret    

c0105c62 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105c62:	55                   	push   %ebp
c0105c63:	89 e5                	mov    %esp,%ebp
c0105c65:	83 ec 04             	sub    $0x4,%esp
c0105c68:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c6b:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105c6e:	eb 11                	jmp    c0105c81 <strfind+0x1f>
        if (*s == c) {
c0105c70:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c73:	0f b6 00             	movzbl (%eax),%eax
c0105c76:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105c79:	75 02                	jne    c0105c7d <strfind+0x1b>
            break;
c0105c7b:	eb 0e                	jmp    c0105c8b <strfind+0x29>
        }
        s ++;
c0105c7d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105c81:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c84:	0f b6 00             	movzbl (%eax),%eax
c0105c87:	84 c0                	test   %al,%al
c0105c89:	75 e5                	jne    c0105c70 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0105c8b:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105c8e:	c9                   	leave  
c0105c8f:	c3                   	ret    

c0105c90 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105c90:	55                   	push   %ebp
c0105c91:	89 e5                	mov    %esp,%ebp
c0105c93:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105c96:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105c9d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105ca4:	eb 04                	jmp    c0105caa <strtol+0x1a>
        s ++;
c0105ca6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105caa:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cad:	0f b6 00             	movzbl (%eax),%eax
c0105cb0:	3c 20                	cmp    $0x20,%al
c0105cb2:	74 f2                	je     c0105ca6 <strtol+0x16>
c0105cb4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cb7:	0f b6 00             	movzbl (%eax),%eax
c0105cba:	3c 09                	cmp    $0x9,%al
c0105cbc:	74 e8                	je     c0105ca6 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105cbe:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cc1:	0f b6 00             	movzbl (%eax),%eax
c0105cc4:	3c 2b                	cmp    $0x2b,%al
c0105cc6:	75 06                	jne    c0105cce <strtol+0x3e>
        s ++;
c0105cc8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105ccc:	eb 15                	jmp    c0105ce3 <strtol+0x53>
    }
    else if (*s == '-') {
c0105cce:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cd1:	0f b6 00             	movzbl (%eax),%eax
c0105cd4:	3c 2d                	cmp    $0x2d,%al
c0105cd6:	75 0b                	jne    c0105ce3 <strtol+0x53>
        s ++, neg = 1;
c0105cd8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105cdc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105ce3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105ce7:	74 06                	je     c0105cef <strtol+0x5f>
c0105ce9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105ced:	75 24                	jne    c0105d13 <strtol+0x83>
c0105cef:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cf2:	0f b6 00             	movzbl (%eax),%eax
c0105cf5:	3c 30                	cmp    $0x30,%al
c0105cf7:	75 1a                	jne    c0105d13 <strtol+0x83>
c0105cf9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cfc:	83 c0 01             	add    $0x1,%eax
c0105cff:	0f b6 00             	movzbl (%eax),%eax
c0105d02:	3c 78                	cmp    $0x78,%al
c0105d04:	75 0d                	jne    c0105d13 <strtol+0x83>
        s += 2, base = 16;
c0105d06:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105d0a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105d11:	eb 2a                	jmp    c0105d3d <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105d13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d17:	75 17                	jne    c0105d30 <strtol+0xa0>
c0105d19:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d1c:	0f b6 00             	movzbl (%eax),%eax
c0105d1f:	3c 30                	cmp    $0x30,%al
c0105d21:	75 0d                	jne    c0105d30 <strtol+0xa0>
        s ++, base = 8;
c0105d23:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105d27:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105d2e:	eb 0d                	jmp    c0105d3d <strtol+0xad>
    }
    else if (base == 0) {
c0105d30:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d34:	75 07                	jne    c0105d3d <strtol+0xad>
        base = 10;
c0105d36:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105d3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d40:	0f b6 00             	movzbl (%eax),%eax
c0105d43:	3c 2f                	cmp    $0x2f,%al
c0105d45:	7e 1b                	jle    c0105d62 <strtol+0xd2>
c0105d47:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d4a:	0f b6 00             	movzbl (%eax),%eax
c0105d4d:	3c 39                	cmp    $0x39,%al
c0105d4f:	7f 11                	jg     c0105d62 <strtol+0xd2>
            dig = *s - '0';
c0105d51:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d54:	0f b6 00             	movzbl (%eax),%eax
c0105d57:	0f be c0             	movsbl %al,%eax
c0105d5a:	83 e8 30             	sub    $0x30,%eax
c0105d5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d60:	eb 48                	jmp    c0105daa <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105d62:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d65:	0f b6 00             	movzbl (%eax),%eax
c0105d68:	3c 60                	cmp    $0x60,%al
c0105d6a:	7e 1b                	jle    c0105d87 <strtol+0xf7>
c0105d6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d6f:	0f b6 00             	movzbl (%eax),%eax
c0105d72:	3c 7a                	cmp    $0x7a,%al
c0105d74:	7f 11                	jg     c0105d87 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105d76:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d79:	0f b6 00             	movzbl (%eax),%eax
c0105d7c:	0f be c0             	movsbl %al,%eax
c0105d7f:	83 e8 57             	sub    $0x57,%eax
c0105d82:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d85:	eb 23                	jmp    c0105daa <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105d87:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d8a:	0f b6 00             	movzbl (%eax),%eax
c0105d8d:	3c 40                	cmp    $0x40,%al
c0105d8f:	7e 3d                	jle    c0105dce <strtol+0x13e>
c0105d91:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d94:	0f b6 00             	movzbl (%eax),%eax
c0105d97:	3c 5a                	cmp    $0x5a,%al
c0105d99:	7f 33                	jg     c0105dce <strtol+0x13e>
            dig = *s - 'A' + 10;
c0105d9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d9e:	0f b6 00             	movzbl (%eax),%eax
c0105da1:	0f be c0             	movsbl %al,%eax
c0105da4:	83 e8 37             	sub    $0x37,%eax
c0105da7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105dad:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105db0:	7c 02                	jl     c0105db4 <strtol+0x124>
            break;
c0105db2:	eb 1a                	jmp    c0105dce <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0105db4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105db8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105dbb:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105dbf:	89 c2                	mov    %eax,%edx
c0105dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105dc4:	01 d0                	add    %edx,%eax
c0105dc6:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105dc9:	e9 6f ff ff ff       	jmp    c0105d3d <strtol+0xad>

    if (endptr) {
c0105dce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105dd2:	74 08                	je     c0105ddc <strtol+0x14c>
        *endptr = (char *) s;
c0105dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105dd7:	8b 55 08             	mov    0x8(%ebp),%edx
c0105dda:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105ddc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105de0:	74 07                	je     c0105de9 <strtol+0x159>
c0105de2:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105de5:	f7 d8                	neg    %eax
c0105de7:	eb 03                	jmp    c0105dec <strtol+0x15c>
c0105de9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105dec:	c9                   	leave  
c0105ded:	c3                   	ret    

c0105dee <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105dee:	55                   	push   %ebp
c0105def:	89 e5                	mov    %esp,%ebp
c0105df1:	57                   	push   %edi
c0105df2:	83 ec 24             	sub    $0x24,%esp
c0105df5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105df8:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105dfb:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105dff:	8b 55 08             	mov    0x8(%ebp),%edx
c0105e02:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105e05:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105e08:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105e0e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105e11:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105e15:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105e18:	89 d7                	mov    %edx,%edi
c0105e1a:	f3 aa                	rep stos %al,%es:(%edi)
c0105e1c:	89 fa                	mov    %edi,%edx
c0105e1e:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105e21:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105e24:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105e27:	83 c4 24             	add    $0x24,%esp
c0105e2a:	5f                   	pop    %edi
c0105e2b:	5d                   	pop    %ebp
c0105e2c:	c3                   	ret    

c0105e2d <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105e2d:	55                   	push   %ebp
c0105e2e:	89 e5                	mov    %esp,%ebp
c0105e30:	57                   	push   %edi
c0105e31:	56                   	push   %esi
c0105e32:	53                   	push   %ebx
c0105e33:	83 ec 30             	sub    $0x30,%esp
c0105e36:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e39:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105e42:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e45:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105e48:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e4b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105e4e:	73 42                	jae    c0105e92 <memmove+0x65>
c0105e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e53:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105e56:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e59:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105e5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e5f:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105e62:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105e65:	c1 e8 02             	shr    $0x2,%eax
c0105e68:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105e6a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105e6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105e70:	89 d7                	mov    %edx,%edi
c0105e72:	89 c6                	mov    %eax,%esi
c0105e74:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105e76:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105e79:	83 e1 03             	and    $0x3,%ecx
c0105e7c:	74 02                	je     c0105e80 <memmove+0x53>
c0105e7e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105e80:	89 f0                	mov    %esi,%eax
c0105e82:	89 fa                	mov    %edi,%edx
c0105e84:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105e87:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105e8a:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105e8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105e90:	eb 36                	jmp    c0105ec8 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105e92:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e95:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105e98:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e9b:	01 c2                	add    %eax,%edx
c0105e9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105ea0:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105ea3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ea6:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0105ea9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105eac:	89 c1                	mov    %eax,%ecx
c0105eae:	89 d8                	mov    %ebx,%eax
c0105eb0:	89 d6                	mov    %edx,%esi
c0105eb2:	89 c7                	mov    %eax,%edi
c0105eb4:	fd                   	std    
c0105eb5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105eb7:	fc                   	cld    
c0105eb8:	89 f8                	mov    %edi,%eax
c0105eba:	89 f2                	mov    %esi,%edx
c0105ebc:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105ebf:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105ec2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0105ec5:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105ec8:	83 c4 30             	add    $0x30,%esp
c0105ecb:	5b                   	pop    %ebx
c0105ecc:	5e                   	pop    %esi
c0105ecd:	5f                   	pop    %edi
c0105ece:	5d                   	pop    %ebp
c0105ecf:	c3                   	ret    

c0105ed0 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105ed0:	55                   	push   %ebp
c0105ed1:	89 e5                	mov    %esp,%ebp
c0105ed3:	57                   	push   %edi
c0105ed4:	56                   	push   %esi
c0105ed5:	83 ec 20             	sub    $0x20,%esp
c0105ed8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105edb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105ede:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ee1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ee4:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ee7:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105eea:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105eed:	c1 e8 02             	shr    $0x2,%eax
c0105ef0:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105ef2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105ef5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ef8:	89 d7                	mov    %edx,%edi
c0105efa:	89 c6                	mov    %eax,%esi
c0105efc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105efe:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105f01:	83 e1 03             	and    $0x3,%ecx
c0105f04:	74 02                	je     c0105f08 <memcpy+0x38>
c0105f06:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105f08:	89 f0                	mov    %esi,%eax
c0105f0a:	89 fa                	mov    %edi,%edx
c0105f0c:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105f0f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105f12:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105f18:	83 c4 20             	add    $0x20,%esp
c0105f1b:	5e                   	pop    %esi
c0105f1c:	5f                   	pop    %edi
c0105f1d:	5d                   	pop    %ebp
c0105f1e:	c3                   	ret    

c0105f1f <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105f1f:	55                   	push   %ebp
c0105f20:	89 e5                	mov    %esp,%ebp
c0105f22:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105f25:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f28:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f2e:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105f31:	eb 30                	jmp    c0105f63 <memcmp+0x44>
        if (*s1 != *s2) {
c0105f33:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105f36:	0f b6 10             	movzbl (%eax),%edx
c0105f39:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f3c:	0f b6 00             	movzbl (%eax),%eax
c0105f3f:	38 c2                	cmp    %al,%dl
c0105f41:	74 18                	je     c0105f5b <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105f43:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105f46:	0f b6 00             	movzbl (%eax),%eax
c0105f49:	0f b6 d0             	movzbl %al,%edx
c0105f4c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f4f:	0f b6 00             	movzbl (%eax),%eax
c0105f52:	0f b6 c0             	movzbl %al,%eax
c0105f55:	29 c2                	sub    %eax,%edx
c0105f57:	89 d0                	mov    %edx,%eax
c0105f59:	eb 1a                	jmp    c0105f75 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105f5b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105f5f:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0105f63:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f66:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105f69:	89 55 10             	mov    %edx,0x10(%ebp)
c0105f6c:	85 c0                	test   %eax,%eax
c0105f6e:	75 c3                	jne    c0105f33 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0105f70:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105f75:	c9                   	leave  
c0105f76:	c3                   	ret    
