---
layout: post
title: for循环中的++i和i++有什么区别
date: 2018-04-20 21:16 +0800
tags:   Code
author: moonagic
categories: moonagic
subclass: 'post tag-test tag-content'
navigation: True
logo: 'images/avatar.jpg'
---


i++和++i是C系语言的经典课题,  
我们知道i++和++i的表面区别为++i的返回值为`i+1`,而i++则为`i`,而它们的底层实现分别为:  
* ++i实现:

```c
int operator ++ ()
{
    return i+1;
}
```
* i++实现:

```c
int operator ++ (int flag)
{
    int j = i;
    i += 1;
    return j;
}
```
两者实现的本质区别为其中的`j`,这个`j`在程序中称为**匿名变量**.  
现在很明显了,因为这个匿名变量的存在直接导致了i++比++i实际开销大.  
那么,是否意味着`for(int i = 0;i < n;i++)`比`for(int i = 0;i < n;++i)`开销大呢?  
带着这个问题,我想可能需要对比汇编才能看出点区别了.  
现在分别创建了两份文件,内容分别为:  
```c
#include <stdio.h>
 
int main()
{
    for (int i = 0; i < 100; ++i)
    {
        printf("%d\n", i);
    }
    return 0;
}
```
```c
#include <stdio.h>
 
int main()
{
    for (int i = 0; i < 100; i++)
    {
        printf("%d\n", i);
    }
    return 0;
}
```
然而很遗憾,在使用gcc输出汇编代码后这两份C语言代码输出了完全相同的内容:  
```c
	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 13
	.globl	_main                   ## -- Begin function main
	.p2align	4, 0x90
_main:                                  ## @main
	.cfi_startproc
## BB#0:
	pushq	%rbp
Lcfi0:
	.cfi_def_cfa_offset 16
Lcfi1:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Lcfi2:
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movl	$0, -4(%rbp)
	movl	$0, -8(%rbp)
LBB0_1:                                 ## =>This Inner Loop Header: Depth=1
	cmpl	$100, -8(%rbp)
	jge	LBB0_4
## BB#2:                                ##   in Loop: Header=BB0_1 Depth=1
	leaq	L_.str(%rip), %rdi
	movl	-8(%rbp), %esi
	movb	$0, %al
	callq	_printf
	movl	%eax, -12(%rbp)         ## 4-byte Spill
## BB#3:                                ##   in Loop: Header=BB0_1 Depth=1
	movl	-8(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -8(%rbp)
	jmp	LBB0_1
LBB0_4:
	xorl	%eax, %eax
	addq	$16, %rsp
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.section	__TEXT,__cstring,cstring_literals
L_.str:                                 ## @.str
	.asciz	"%d\n"


.subsections_via_symbols
```
所以,现在只能作两个猜测:
* 编译器层面对for循环中的迭代操作做了针对优化
* 编译器层面对没有取++i/i++操作值的情况下做了针对优化  
简单思考了一下,如果我们自己来做编译器优化的话还是做第二项,毕竟直接做第一项的话显得有点二而且做了第二项优化以后自动获得第一项的优化特性.  
我们继续准备2份C语言文件:

```c
#include <stdio.h>
 
int main()
{
    int i = 0;
    i++;
    return 0;
}
```
```c
#include <stdio.h>
 
int main()
{
    int i = 0;
    ++i;
    return 0;
}
```
这两份C语言代码输出的汇编同样是相同的,汇编我就不贴了...  
我们再准备2份C语言文件:
```c
#include <stdio.h>
 
int main()
{
    int i = 0;
    printf("%d\n", i++);
    return 0;
}
```
```c
#include <stdio.h>
 
int main()
{
    int i = 0;
    printf("%d\n", ++i);
    return 0;
}
```
现在答案揭晓了,这2份C语言文件输出的汇编体现出了差别.
```c
	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 13
	.globl	_main                   ## -- Begin function main
	.p2align	4, 0x90
_main:                                  ## @main
	.cfi_startproc
## BB#0:
	pushq	%rbp
Lcfi0:
	.cfi_def_cfa_offset 16
Lcfi1:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Lcfi2:
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	leaq	L_.str(%rip), %rdi
	movl	$0, -4(%rbp)
	movl	$0, -8(%rbp)
	movl	-8(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -8(%rbp)
	movl	%eax, %esi
	movb	$0, %al
	callq	_printf
	xorl	%esi, %esi
	movl	%eax, -12(%rbp)         ## 4-byte Spill
	movl	%esi, %eax
	addq	$16, %rsp
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.section	__TEXT,__cstring,cstring_literals
L_.str:                                 ## @.str
	.asciz	"%d\n"


.subsections_via_symbols
```
```c
	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 13
	.globl	_main                   ## -- Begin function main
	.p2align	4, 0x90
_main:                                  ## @main
	.cfi_startproc
## BB#0:
	pushq	%rbp
Lcfi0:
	.cfi_def_cfa_offset 16
Lcfi1:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Lcfi2:
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	leaq	L_.str(%rip), %rdi
	movl	$0, -4(%rbp)
	movl	$0, -8(%rbp)
	movl	-8(%rbp), %eax
	movl	%eax, %ecx
	addl	$1, %ecx
	movl	%ecx, -8(%rbp)
	movl	%eax, %esi
	movb	$0, %al
	callq	_printf
	xorl	%ecx, %ecx
	movl	%eax, -12(%rbp)         ## 4-byte Spill
	movl	%ecx, %eax
	addq	$16, %rsp
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.section	__TEXT,__cstring,cstring_literals
L_.str:                                 ## @.str
	.asciz	"%d\n"


.subsections_via_symbols
```

i++相比++i多出一行
```c
    movl	%eax, %ecx
```

所以最后的结论就是,至少在gcc编译器层面for循环迭代中的i++和++i并没有实际区别.  
以及,或许我们可以使用其它的编译器验证一下是否其他编译器也做了相应优化.