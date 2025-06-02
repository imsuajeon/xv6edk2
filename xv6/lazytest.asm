
_lazytest:     file format elf32-i386


Disassembly of section .text:

00000000 <sparse_memory>:

#define REGION_SZ (1024 * 1024 * 1024)

void
sparse_memory(char *s)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	83 ec 18             	sub    $0x18,%esp
  char *i, *prev_end, *new_end;
  
  prev_end = sbrk(REGION_SZ);
   a:	83 ec 0c             	sub    $0xc,%esp
   d:	68 00 00 00 40       	push   $0x40000000
  12:	e8 16 06 00 00       	call   62d <sbrk>
  17:	83 c4 10             	add    $0x10,%esp
  1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if (prev_end == (char*)0xffffffffffffffffL) {
  1d:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  21:	75 17                	jne    3a <sparse_memory+0x3a>
    printf(1,"sbrk() failed\n");
  23:	83 ec 08             	sub    $0x8,%esp
  26:	68 f0 0a 00 00       	push   $0xaf0
  2b:	6a 01                	push   $0x1
  2d:	e8 f7 06 00 00       	call   729 <printf>
  32:	83 c4 10             	add    $0x10,%esp
    exit();
  35:	e8 6b 05 00 00       	call   5a5 <exit>
  }
  new_end = prev_end + REGION_SZ;
  3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  3d:	05 00 00 00 40       	add    $0x40000000,%eax
  42:	89 45 ec             	mov    %eax,-0x14(%ebp)

  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
  45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  48:	05 00 10 00 00       	add    $0x1000,%eax
  4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  50:	eb 0f                	jmp    61 <sparse_memory+0x61>
    *(char **)i = i;
  52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  58:	89 10                	mov    %edx,(%eax)
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
  5a:	81 45 f4 00 00 04 00 	addl   $0x40000,-0xc(%ebp)
  61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  64:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  67:	72 e9                	jb     52 <sparse_memory+0x52>

  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
  69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  6c:	05 00 10 00 00       	add    $0x1000,%eax
  71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  74:	eb 28                	jmp    9e <sparse_memory+0x9e>
    if (*(char **)i != i) {
  76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  79:	8b 00                	mov    (%eax),%eax
  7b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  7e:	74 17                	je     97 <sparse_memory+0x97>
      printf(1,"failed to read value from memory\n");
  80:	83 ec 08             	sub    $0x8,%esp
  83:	68 00 0b 00 00       	push   $0xb00
  88:	6a 01                	push   $0x1
  8a:	e8 9a 06 00 00       	call   729 <printf>
  8f:	83 c4 10             	add    $0x10,%esp
      exit();
  92:	e8 0e 05 00 00       	call   5a5 <exit>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
  97:	81 45 f4 00 00 04 00 	addl   $0x40000,-0xc(%ebp)
  9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  a1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  a4:	72 d0                	jb     76 <sparse_memory+0x76>
    }
  }

  exit();
  a6:	e8 fa 04 00 00       	call   5a5 <exit>

000000ab <sparse_memory_unmap>:
}

void
sparse_memory_unmap(char *s)
{
  ab:	f3 0f 1e fb          	endbr32 
  af:	55                   	push   %ebp
  b0:	89 e5                	mov    %esp,%ebp
  b2:	83 ec 18             	sub    $0x18,%esp
  int pid;
  char *i, *prev_end, *new_end;

  prev_end = sbrk(REGION_SZ);
  b5:	83 ec 0c             	sub    $0xc,%esp
  b8:	68 00 00 00 40       	push   $0x40000000
  bd:	e8 6b 05 00 00       	call   62d <sbrk>
  c2:	83 c4 10             	add    $0x10,%esp
  c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if (prev_end == (char*)0xffffffffffffffffL) {
  c8:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  cc:	75 17                	jne    e5 <sparse_memory_unmap+0x3a>
    printf(1,"sbrk() failed\n");
  ce:	83 ec 08             	sub    $0x8,%esp
  d1:	68 f0 0a 00 00       	push   $0xaf0
  d6:	6a 01                	push   $0x1
  d8:	e8 4c 06 00 00       	call   729 <printf>
  dd:	83 c4 10             	add    $0x10,%esp
    exit();
  e0:	e8 c0 04 00 00       	call   5a5 <exit>
  }
  new_end = prev_end + REGION_SZ;
  e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  e8:	05 00 00 00 40       	add    $0x40000000,%eax
  ed:	89 45 ec             	mov    %eax,-0x14(%ebp)

  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
  f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  f3:	05 00 10 00 00       	add    $0x1000,%eax
  f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  fb:	eb 0f                	jmp    10c <sparse_memory_unmap+0x61>
    *(char **)i = i;
  fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 100:	8b 55 f4             	mov    -0xc(%ebp),%edx
 103:	89 10                	mov    %edx,(%eax)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
 105:	81 45 f4 00 00 00 01 	addl   $0x1000000,-0xc(%ebp)
 10c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 10f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 112:	72 e9                	jb     fd <sparse_memory_unmap+0x52>

  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
 114:	8b 45 f0             	mov    -0x10(%ebp),%eax
 117:	05 00 10 00 00       	add    $0x1000,%eax
 11c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 11f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 122:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 125:	73 64                	jae    18b <sparse_memory_unmap+0xe0>
    pid = fork();
 127:	e8 71 04 00 00       	call   59d <fork>
 12c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if (pid < 0) {
 12f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 133:	79 17                	jns    14c <sparse_memory_unmap+0xa1>
      printf(1,"error forking\n");
 135:	83 ec 08             	sub    $0x8,%esp
 138:	68 22 0b 00 00       	push   $0xb22
 13d:	6a 01                	push   $0x1
 13f:	e8 e5 05 00 00       	call   729 <printf>
 144:	83 c4 10             	add    $0x10,%esp
      exit();
 147:	e8 59 04 00 00       	call   5a5 <exit>
    } else if (pid == 0) {
 14c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 150:	75 1d                	jne    16f <sparse_memory_unmap+0xc4>
      sbrk(-1L * REGION_SZ);
 152:	83 ec 0c             	sub    $0xc,%esp
 155:	68 00 00 00 c0       	push   $0xc0000000
 15a:	e8 ce 04 00 00       	call   62d <sbrk>
 15f:	83 c4 10             	add    $0x10,%esp
      *(char **)i = i;
 162:	8b 45 f4             	mov    -0xc(%ebp),%eax
 165:	8b 55 f4             	mov    -0xc(%ebp),%edx
 168:	89 10                	mov    %edx,(%eax)
      exit();
 16a:	e8 36 04 00 00       	call   5a5 <exit>
    } else {
      wait();
 16f:	e8 39 04 00 00       	call   5ad <wait>
      printf(1,"memory not unmapped\n");
 174:	83 ec 08             	sub    $0x8,%esp
 177:	68 31 0b 00 00       	push   $0xb31
 17c:	6a 01                	push   $0x1
 17e:	e8 a6 05 00 00       	call   729 <printf>
 183:	83 c4 10             	add    $0x10,%esp
      exit();
 186:	e8 1a 04 00 00       	call   5a5 <exit>
    }
  }

  exit();
 18b:	e8 15 04 00 00       	call   5a5 <exit>

00000190 <oom>:
}

void
oom(char *s)
{
 190:	f3 0f 1e fb          	endbr32 
 194:	55                   	push   %ebp
 195:	89 e5                	mov    %esp,%ebp
 197:	83 ec 18             	sub    $0x18,%esp
  void *m1, *m2;
  int pid;

  if((pid = fork()) == 0){
 19a:	e8 fe 03 00 00       	call   59d <fork>
 19f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 1a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a6:	75 35                	jne    1dd <oom+0x4d>
    m1 = 0;
 1a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while((m2 = malloc(4096*4096)) != 0){
 1af:	eb 0e                	jmp    1bf <oom+0x2f>
      *(char**)m2 = m1;
 1b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 1b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1b7:	89 10                	mov    %edx,(%eax)
      m1 = m2;
 1b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 1bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while((m2 = malloc(4096*4096)) != 0){
 1bf:	83 ec 0c             	sub    $0xc,%esp
 1c2:	68 00 00 00 01       	push   $0x1000000
 1c7:	e8 3d 08 00 00       	call   a09 <malloc>
 1cc:	83 c4 10             	add    $0x10,%esp
 1cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
 1d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 1d6:	75 d9                	jne    1b1 <oom+0x21>
    }
    exit();
 1d8:	e8 c8 03 00 00       	call   5a5 <exit>
  } else {
    wait();
 1dd:	e8 cb 03 00 00       	call   5ad <wait>
    exit();
 1e2:	e8 be 03 00 00       	call   5a5 <exit>

000001e7 <run>:
}

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
 1e7:	f3 0f 1e fb          	endbr32 
 1eb:	55                   	push   %ebp
 1ec:	89 e5                	mov    %esp,%ebp
 1ee:	83 ec 18             	sub    $0x18,%esp
  int pid;
  
  printf(1,"running test %s\n", s);
 1f1:	83 ec 04             	sub    $0x4,%esp
 1f4:	ff 75 0c             	pushl  0xc(%ebp)
 1f7:	68 46 0b 00 00       	push   $0xb46
 1fc:	6a 01                	push   $0x1
 1fe:	e8 26 05 00 00       	call   729 <printf>
 203:	83 c4 10             	add    $0x10,%esp
  if((pid = fork()) < 0) {
 206:	e8 92 03 00 00       	call   59d <fork>
 20b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 20e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 212:	79 17                	jns    22b <run+0x44>
    printf(1,"runtest: fork error\n");
 214:	83 ec 08             	sub    $0x8,%esp
 217:	68 57 0b 00 00       	push   $0xb57
 21c:	6a 01                	push   $0x1
 21e:	e8 06 05 00 00       	call   729 <printf>
 223:	83 c4 10             	add    $0x10,%esp
    exit();
 226:	e8 7a 03 00 00       	call   5a5 <exit>
  }
  if(pid == 0) {
 22b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 22f:	75 13                	jne    244 <run+0x5d>
    f(s);
 231:	83 ec 0c             	sub    $0xc,%esp
 234:	ff 75 0c             	pushl  0xc(%ebp)
 237:	8b 45 08             	mov    0x8(%ebp),%eax
 23a:	ff d0                	call   *%eax
 23c:	83 c4 10             	add    $0x10,%esp
    exit();
 23f:	e8 61 03 00 00       	call   5a5 <exit>
  } else {
    wait();
 244:	e8 64 03 00 00       	call   5ad <wait>
    return 1;
 249:	b8 01 00 00 00       	mov    $0x1,%eax
  }
}
 24e:	c9                   	leave  
 24f:	c3                   	ret    

00000250 <main>:

int
main(int argc, char *argv[])
{
 250:	f3 0f 1e fb          	endbr32 
 254:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 258:	83 e4 f0             	and    $0xfffffff0,%esp
 25b:	ff 71 fc             	pushl  -0x4(%ecx)
 25e:	55                   	push   %ebp
 25f:	89 e5                	mov    %esp,%ebp
 261:	51                   	push   %ecx
 262:	83 ec 34             	sub    $0x34,%esp
 265:	89 c8                	mov    %ecx,%eax
  char *n = 0;
 267:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if(argc > 1) {
 26e:	83 38 01             	cmpl   $0x1,(%eax)
 271:	7e 09                	jle    27c <main+0x2c>
    n = argv[1];
 273:	8b 40 04             	mov    0x4(%eax),%eax
 276:	8b 40 04             	mov    0x4(%eax),%eax
 279:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
 27c:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
 283:	c7 45 d4 6c 0b 00 00 	movl   $0xb6c,-0x2c(%ebp)
 28a:	c7 45 d8 ab 00 00 00 	movl   $0xab,-0x28(%ebp)
 291:	c7 45 dc 77 0b 00 00 	movl   $0xb77,-0x24(%ebp)
 298:	c7 45 e0 90 01 00 00 	movl   $0x190,-0x20(%ebp)
 29f:	c7 45 e4 82 0b 00 00 	movl   $0xb82,-0x1c(%ebp)
 2a6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
 2ad:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    { sparse_memory_unmap, "lazy unmap"},
    { oom, "out of memory"},
    { 0, 0},
  };
    
  printf(1,"lazytests starting\n");
 2b4:	83 ec 08             	sub    $0x8,%esp
 2b7:	68 90 0b 00 00       	push   $0xb90
 2bc:	6a 01                	push   $0x1
 2be:	e8 66 04 00 00       	call   729 <printf>
 2c3:	83 c4 10             	add    $0x10,%esp

  for (struct test *t = tests; t->s != 0; t++) {
 2c6:	8d 45 d0             	lea    -0x30(%ebp),%eax
 2c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 2cc:	eb 3b                	jmp    309 <main+0xb9>
    if((n == 0) || strcmp(t->s, n) == 0) {
 2ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2d2:	74 19                	je     2ed <main+0x9d>
 2d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2d7:	8b 40 04             	mov    0x4(%eax),%eax
 2da:	83 ec 08             	sub    $0x8,%esp
 2dd:	ff 75 f4             	pushl  -0xc(%ebp)
 2e0:	50                   	push   %eax
 2e1:	e8 9e 00 00 00       	call   384 <strcmp>
 2e6:	83 c4 10             	add    $0x10,%esp
 2e9:	85 c0                	test   %eax,%eax
 2eb:	75 18                	jne    305 <main+0xb5>
      run(t->f, t->s);
 2ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2f0:	8b 50 04             	mov    0x4(%eax),%edx
 2f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2f6:	8b 00                	mov    (%eax),%eax
 2f8:	83 ec 08             	sub    $0x8,%esp
 2fb:	52                   	push   %edx
 2fc:	50                   	push   %eax
 2fd:	e8 e5 fe ff ff       	call   1e7 <run>
 302:	83 c4 10             	add    $0x10,%esp
  for (struct test *t = tests; t->s != 0; t++) {
 305:	83 45 f0 08          	addl   $0x8,-0x10(%ebp)
 309:	8b 45 f0             	mov    -0x10(%ebp),%eax
 30c:	8b 40 04             	mov    0x4(%eax),%eax
 30f:	85 c0                	test   %eax,%eax
 311:	75 bb                	jne    2ce <main+0x7e>
    }
  }
  printf(1,"ALL TESTS ENDED\n");
 313:	83 ec 08             	sub    $0x8,%esp
 316:	68 a4 0b 00 00       	push   $0xba4
 31b:	6a 01                	push   $0x1
 31d:	e8 07 04 00 00       	call   729 <printf>
 322:	83 c4 10             	add    $0x10,%esp
  exit();   // not reached.
 325:	e8 7b 02 00 00       	call   5a5 <exit>

0000032a <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 32a:	55                   	push   %ebp
 32b:	89 e5                	mov    %esp,%ebp
 32d:	57                   	push   %edi
 32e:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 32f:	8b 4d 08             	mov    0x8(%ebp),%ecx
 332:	8b 55 10             	mov    0x10(%ebp),%edx
 335:	8b 45 0c             	mov    0xc(%ebp),%eax
 338:	89 cb                	mov    %ecx,%ebx
 33a:	89 df                	mov    %ebx,%edi
 33c:	89 d1                	mov    %edx,%ecx
 33e:	fc                   	cld    
 33f:	f3 aa                	rep stos %al,%es:(%edi)
 341:	89 ca                	mov    %ecx,%edx
 343:	89 fb                	mov    %edi,%ebx
 345:	89 5d 08             	mov    %ebx,0x8(%ebp)
 348:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 34b:	90                   	nop
 34c:	5b                   	pop    %ebx
 34d:	5f                   	pop    %edi
 34e:	5d                   	pop    %ebp
 34f:	c3                   	ret    

00000350 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 350:	f3 0f 1e fb          	endbr32 
 354:	55                   	push   %ebp
 355:	89 e5                	mov    %esp,%ebp
 357:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 35a:	8b 45 08             	mov    0x8(%ebp),%eax
 35d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 360:	90                   	nop
 361:	8b 55 0c             	mov    0xc(%ebp),%edx
 364:	8d 42 01             	lea    0x1(%edx),%eax
 367:	89 45 0c             	mov    %eax,0xc(%ebp)
 36a:	8b 45 08             	mov    0x8(%ebp),%eax
 36d:	8d 48 01             	lea    0x1(%eax),%ecx
 370:	89 4d 08             	mov    %ecx,0x8(%ebp)
 373:	0f b6 12             	movzbl (%edx),%edx
 376:	88 10                	mov    %dl,(%eax)
 378:	0f b6 00             	movzbl (%eax),%eax
 37b:	84 c0                	test   %al,%al
 37d:	75 e2                	jne    361 <strcpy+0x11>
    ;
  return os;
 37f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 382:	c9                   	leave  
 383:	c3                   	ret    

00000384 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 384:	f3 0f 1e fb          	endbr32 
 388:	55                   	push   %ebp
 389:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 38b:	eb 08                	jmp    395 <strcmp+0x11>
    p++, q++;
 38d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 391:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 395:	8b 45 08             	mov    0x8(%ebp),%eax
 398:	0f b6 00             	movzbl (%eax),%eax
 39b:	84 c0                	test   %al,%al
 39d:	74 10                	je     3af <strcmp+0x2b>
 39f:	8b 45 08             	mov    0x8(%ebp),%eax
 3a2:	0f b6 10             	movzbl (%eax),%edx
 3a5:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a8:	0f b6 00             	movzbl (%eax),%eax
 3ab:	38 c2                	cmp    %al,%dl
 3ad:	74 de                	je     38d <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
 3af:	8b 45 08             	mov    0x8(%ebp),%eax
 3b2:	0f b6 00             	movzbl (%eax),%eax
 3b5:	0f b6 d0             	movzbl %al,%edx
 3b8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bb:	0f b6 00             	movzbl (%eax),%eax
 3be:	0f b6 c0             	movzbl %al,%eax
 3c1:	29 c2                	sub    %eax,%edx
 3c3:	89 d0                	mov    %edx,%eax
}
 3c5:	5d                   	pop    %ebp
 3c6:	c3                   	ret    

000003c7 <strlen>:

uint
strlen(char *s)
{
 3c7:	f3 0f 1e fb          	endbr32 
 3cb:	55                   	push   %ebp
 3cc:	89 e5                	mov    %esp,%ebp
 3ce:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3d8:	eb 04                	jmp    3de <strlen+0x17>
 3da:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3de:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3e1:	8b 45 08             	mov    0x8(%ebp),%eax
 3e4:	01 d0                	add    %edx,%eax
 3e6:	0f b6 00             	movzbl (%eax),%eax
 3e9:	84 c0                	test   %al,%al
 3eb:	75 ed                	jne    3da <strlen+0x13>
    ;
  return n;
 3ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3f0:	c9                   	leave  
 3f1:	c3                   	ret    

000003f2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3f2:	f3 0f 1e fb          	endbr32 
 3f6:	55                   	push   %ebp
 3f7:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 3f9:	8b 45 10             	mov    0x10(%ebp),%eax
 3fc:	50                   	push   %eax
 3fd:	ff 75 0c             	pushl  0xc(%ebp)
 400:	ff 75 08             	pushl  0x8(%ebp)
 403:	e8 22 ff ff ff       	call   32a <stosb>
 408:	83 c4 0c             	add    $0xc,%esp
  return dst;
 40b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 40e:	c9                   	leave  
 40f:	c3                   	ret    

00000410 <strchr>:

char*
strchr(const char *s, char c)
{
 410:	f3 0f 1e fb          	endbr32 
 414:	55                   	push   %ebp
 415:	89 e5                	mov    %esp,%ebp
 417:	83 ec 04             	sub    $0x4,%esp
 41a:	8b 45 0c             	mov    0xc(%ebp),%eax
 41d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 420:	eb 14                	jmp    436 <strchr+0x26>
    if(*s == c)
 422:	8b 45 08             	mov    0x8(%ebp),%eax
 425:	0f b6 00             	movzbl (%eax),%eax
 428:	38 45 fc             	cmp    %al,-0x4(%ebp)
 42b:	75 05                	jne    432 <strchr+0x22>
      return (char*)s;
 42d:	8b 45 08             	mov    0x8(%ebp),%eax
 430:	eb 13                	jmp    445 <strchr+0x35>
  for(; *s; s++)
 432:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 436:	8b 45 08             	mov    0x8(%ebp),%eax
 439:	0f b6 00             	movzbl (%eax),%eax
 43c:	84 c0                	test   %al,%al
 43e:	75 e2                	jne    422 <strchr+0x12>
  return 0;
 440:	b8 00 00 00 00       	mov    $0x0,%eax
}
 445:	c9                   	leave  
 446:	c3                   	ret    

00000447 <gets>:

char*
gets(char *buf, int max)
{
 447:	f3 0f 1e fb          	endbr32 
 44b:	55                   	push   %ebp
 44c:	89 e5                	mov    %esp,%ebp
 44e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 451:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 458:	eb 42                	jmp    49c <gets+0x55>
    cc = read(0, &c, 1);
 45a:	83 ec 04             	sub    $0x4,%esp
 45d:	6a 01                	push   $0x1
 45f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 462:	50                   	push   %eax
 463:	6a 00                	push   $0x0
 465:	e8 53 01 00 00       	call   5bd <read>
 46a:	83 c4 10             	add    $0x10,%esp
 46d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 470:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 474:	7e 33                	jle    4a9 <gets+0x62>
      break;
    buf[i++] = c;
 476:	8b 45 f4             	mov    -0xc(%ebp),%eax
 479:	8d 50 01             	lea    0x1(%eax),%edx
 47c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 47f:	89 c2                	mov    %eax,%edx
 481:	8b 45 08             	mov    0x8(%ebp),%eax
 484:	01 c2                	add    %eax,%edx
 486:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 48a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 48c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 490:	3c 0a                	cmp    $0xa,%al
 492:	74 16                	je     4aa <gets+0x63>
 494:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 498:	3c 0d                	cmp    $0xd,%al
 49a:	74 0e                	je     4aa <gets+0x63>
  for(i=0; i+1 < max; ){
 49c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 49f:	83 c0 01             	add    $0x1,%eax
 4a2:	39 45 0c             	cmp    %eax,0xc(%ebp)
 4a5:	7f b3                	jg     45a <gets+0x13>
 4a7:	eb 01                	jmp    4aa <gets+0x63>
      break;
 4a9:	90                   	nop
      break;
  }
  buf[i] = '\0';
 4aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4ad:	8b 45 08             	mov    0x8(%ebp),%eax
 4b0:	01 d0                	add    %edx,%eax
 4b2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4b5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4b8:	c9                   	leave  
 4b9:	c3                   	ret    

000004ba <stat>:

int
stat(char *n, struct stat *st)
{
 4ba:	f3 0f 1e fb          	endbr32 
 4be:	55                   	push   %ebp
 4bf:	89 e5                	mov    %esp,%ebp
 4c1:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4c4:	83 ec 08             	sub    $0x8,%esp
 4c7:	6a 00                	push   $0x0
 4c9:	ff 75 08             	pushl  0x8(%ebp)
 4cc:	e8 14 01 00 00       	call   5e5 <open>
 4d1:	83 c4 10             	add    $0x10,%esp
 4d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4db:	79 07                	jns    4e4 <stat+0x2a>
    return -1;
 4dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4e2:	eb 25                	jmp    509 <stat+0x4f>
  r = fstat(fd, st);
 4e4:	83 ec 08             	sub    $0x8,%esp
 4e7:	ff 75 0c             	pushl  0xc(%ebp)
 4ea:	ff 75 f4             	pushl  -0xc(%ebp)
 4ed:	e8 0b 01 00 00       	call   5fd <fstat>
 4f2:	83 c4 10             	add    $0x10,%esp
 4f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4f8:	83 ec 0c             	sub    $0xc,%esp
 4fb:	ff 75 f4             	pushl  -0xc(%ebp)
 4fe:	e8 ca 00 00 00       	call   5cd <close>
 503:	83 c4 10             	add    $0x10,%esp
  return r;
 506:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 509:	c9                   	leave  
 50a:	c3                   	ret    

0000050b <atoi>:

int
atoi(const char *s)
{
 50b:	f3 0f 1e fb          	endbr32 
 50f:	55                   	push   %ebp
 510:	89 e5                	mov    %esp,%ebp
 512:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 515:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 51c:	eb 25                	jmp    543 <atoi+0x38>
    n = n*10 + *s++ - '0';
 51e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 521:	89 d0                	mov    %edx,%eax
 523:	c1 e0 02             	shl    $0x2,%eax
 526:	01 d0                	add    %edx,%eax
 528:	01 c0                	add    %eax,%eax
 52a:	89 c1                	mov    %eax,%ecx
 52c:	8b 45 08             	mov    0x8(%ebp),%eax
 52f:	8d 50 01             	lea    0x1(%eax),%edx
 532:	89 55 08             	mov    %edx,0x8(%ebp)
 535:	0f b6 00             	movzbl (%eax),%eax
 538:	0f be c0             	movsbl %al,%eax
 53b:	01 c8                	add    %ecx,%eax
 53d:	83 e8 30             	sub    $0x30,%eax
 540:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 543:	8b 45 08             	mov    0x8(%ebp),%eax
 546:	0f b6 00             	movzbl (%eax),%eax
 549:	3c 2f                	cmp    $0x2f,%al
 54b:	7e 0a                	jle    557 <atoi+0x4c>
 54d:	8b 45 08             	mov    0x8(%ebp),%eax
 550:	0f b6 00             	movzbl (%eax),%eax
 553:	3c 39                	cmp    $0x39,%al
 555:	7e c7                	jle    51e <atoi+0x13>
  return n;
 557:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 55a:	c9                   	leave  
 55b:	c3                   	ret    

0000055c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 55c:	f3 0f 1e fb          	endbr32 
 560:	55                   	push   %ebp
 561:	89 e5                	mov    %esp,%ebp
 563:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 566:	8b 45 08             	mov    0x8(%ebp),%eax
 569:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 56c:	8b 45 0c             	mov    0xc(%ebp),%eax
 56f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 572:	eb 17                	jmp    58b <memmove+0x2f>
    *dst++ = *src++;
 574:	8b 55 f8             	mov    -0x8(%ebp),%edx
 577:	8d 42 01             	lea    0x1(%edx),%eax
 57a:	89 45 f8             	mov    %eax,-0x8(%ebp)
 57d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 580:	8d 48 01             	lea    0x1(%eax),%ecx
 583:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 586:	0f b6 12             	movzbl (%edx),%edx
 589:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 58b:	8b 45 10             	mov    0x10(%ebp),%eax
 58e:	8d 50 ff             	lea    -0x1(%eax),%edx
 591:	89 55 10             	mov    %edx,0x10(%ebp)
 594:	85 c0                	test   %eax,%eax
 596:	7f dc                	jg     574 <memmove+0x18>
  return vdst;
 598:	8b 45 08             	mov    0x8(%ebp),%eax
}
 59b:	c9                   	leave  
 59c:	c3                   	ret    

0000059d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 59d:	b8 01 00 00 00       	mov    $0x1,%eax
 5a2:	cd 40                	int    $0x40
 5a4:	c3                   	ret    

000005a5 <exit>:
SYSCALL(exit)
 5a5:	b8 02 00 00 00       	mov    $0x2,%eax
 5aa:	cd 40                	int    $0x40
 5ac:	c3                   	ret    

000005ad <wait>:
SYSCALL(wait)
 5ad:	b8 03 00 00 00       	mov    $0x3,%eax
 5b2:	cd 40                	int    $0x40
 5b4:	c3                   	ret    

000005b5 <pipe>:
SYSCALL(pipe)
 5b5:	b8 04 00 00 00       	mov    $0x4,%eax
 5ba:	cd 40                	int    $0x40
 5bc:	c3                   	ret    

000005bd <read>:
SYSCALL(read)
 5bd:	b8 05 00 00 00       	mov    $0x5,%eax
 5c2:	cd 40                	int    $0x40
 5c4:	c3                   	ret    

000005c5 <write>:
SYSCALL(write)
 5c5:	b8 10 00 00 00       	mov    $0x10,%eax
 5ca:	cd 40                	int    $0x40
 5cc:	c3                   	ret    

000005cd <close>:
SYSCALL(close)
 5cd:	b8 15 00 00 00       	mov    $0x15,%eax
 5d2:	cd 40                	int    $0x40
 5d4:	c3                   	ret    

000005d5 <kill>:
SYSCALL(kill)
 5d5:	b8 06 00 00 00       	mov    $0x6,%eax
 5da:	cd 40                	int    $0x40
 5dc:	c3                   	ret    

000005dd <exec>:
SYSCALL(exec)
 5dd:	b8 07 00 00 00       	mov    $0x7,%eax
 5e2:	cd 40                	int    $0x40
 5e4:	c3                   	ret    

000005e5 <open>:
SYSCALL(open)
 5e5:	b8 0f 00 00 00       	mov    $0xf,%eax
 5ea:	cd 40                	int    $0x40
 5ec:	c3                   	ret    

000005ed <mknod>:
SYSCALL(mknod)
 5ed:	b8 11 00 00 00       	mov    $0x11,%eax
 5f2:	cd 40                	int    $0x40
 5f4:	c3                   	ret    

000005f5 <unlink>:
SYSCALL(unlink)
 5f5:	b8 12 00 00 00       	mov    $0x12,%eax
 5fa:	cd 40                	int    $0x40
 5fc:	c3                   	ret    

000005fd <fstat>:
SYSCALL(fstat)
 5fd:	b8 08 00 00 00       	mov    $0x8,%eax
 602:	cd 40                	int    $0x40
 604:	c3                   	ret    

00000605 <link>:
SYSCALL(link)
 605:	b8 13 00 00 00       	mov    $0x13,%eax
 60a:	cd 40                	int    $0x40
 60c:	c3                   	ret    

0000060d <mkdir>:
SYSCALL(mkdir)
 60d:	b8 14 00 00 00       	mov    $0x14,%eax
 612:	cd 40                	int    $0x40
 614:	c3                   	ret    

00000615 <chdir>:
SYSCALL(chdir)
 615:	b8 09 00 00 00       	mov    $0x9,%eax
 61a:	cd 40                	int    $0x40
 61c:	c3                   	ret    

0000061d <dup>:
SYSCALL(dup)
 61d:	b8 0a 00 00 00       	mov    $0xa,%eax
 622:	cd 40                	int    $0x40
 624:	c3                   	ret    

00000625 <getpid>:
SYSCALL(getpid)
 625:	b8 0b 00 00 00       	mov    $0xb,%eax
 62a:	cd 40                	int    $0x40
 62c:	c3                   	ret    

0000062d <sbrk>:
SYSCALL(sbrk)
 62d:	b8 0c 00 00 00       	mov    $0xc,%eax
 632:	cd 40                	int    $0x40
 634:	c3                   	ret    

00000635 <sleep>:
SYSCALL(sleep)
 635:	b8 0d 00 00 00       	mov    $0xd,%eax
 63a:	cd 40                	int    $0x40
 63c:	c3                   	ret    

0000063d <uptime>:
SYSCALL(uptime)
 63d:	b8 0e 00 00 00       	mov    $0xe,%eax
 642:	cd 40                	int    $0x40
 644:	c3                   	ret    

00000645 <printpt>:
 645:	b8 16 00 00 00       	mov    $0x16,%eax
 64a:	cd 40                	int    $0x40
 64c:	c3                   	ret    

0000064d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 64d:	f3 0f 1e fb          	endbr32 
 651:	55                   	push   %ebp
 652:	89 e5                	mov    %esp,%ebp
 654:	83 ec 18             	sub    $0x18,%esp
 657:	8b 45 0c             	mov    0xc(%ebp),%eax
 65a:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 65d:	83 ec 04             	sub    $0x4,%esp
 660:	6a 01                	push   $0x1
 662:	8d 45 f4             	lea    -0xc(%ebp),%eax
 665:	50                   	push   %eax
 666:	ff 75 08             	pushl  0x8(%ebp)
 669:	e8 57 ff ff ff       	call   5c5 <write>
 66e:	83 c4 10             	add    $0x10,%esp
}
 671:	90                   	nop
 672:	c9                   	leave  
 673:	c3                   	ret    

00000674 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 674:	f3 0f 1e fb          	endbr32 
 678:	55                   	push   %ebp
 679:	89 e5                	mov    %esp,%ebp
 67b:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 67e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 685:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 689:	74 17                	je     6a2 <printint+0x2e>
 68b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 68f:	79 11                	jns    6a2 <printint+0x2e>
    neg = 1;
 691:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 698:	8b 45 0c             	mov    0xc(%ebp),%eax
 69b:	f7 d8                	neg    %eax
 69d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6a0:	eb 06                	jmp    6a8 <printint+0x34>
  } else {
    x = xx;
 6a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 6a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6af:	8b 4d 10             	mov    0x10(%ebp),%ecx
 6b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6b5:	ba 00 00 00 00       	mov    $0x0,%edx
 6ba:	f7 f1                	div    %ecx
 6bc:	89 d1                	mov    %edx,%ecx
 6be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c1:	8d 50 01             	lea    0x1(%eax),%edx
 6c4:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6c7:	0f b6 91 74 0e 00 00 	movzbl 0xe74(%ecx),%edx
 6ce:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 6d2:	8b 4d 10             	mov    0x10(%ebp),%ecx
 6d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6d8:	ba 00 00 00 00       	mov    $0x0,%edx
 6dd:	f7 f1                	div    %ecx
 6df:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6e2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6e6:	75 c7                	jne    6af <printint+0x3b>
  if(neg)
 6e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6ec:	74 2d                	je     71b <printint+0xa7>
    buf[i++] = '-';
 6ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f1:	8d 50 01             	lea    0x1(%eax),%edx
 6f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6f7:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6fc:	eb 1d                	jmp    71b <printint+0xa7>
    putc(fd, buf[i]);
 6fe:	8d 55 dc             	lea    -0x24(%ebp),%edx
 701:	8b 45 f4             	mov    -0xc(%ebp),%eax
 704:	01 d0                	add    %edx,%eax
 706:	0f b6 00             	movzbl (%eax),%eax
 709:	0f be c0             	movsbl %al,%eax
 70c:	83 ec 08             	sub    $0x8,%esp
 70f:	50                   	push   %eax
 710:	ff 75 08             	pushl  0x8(%ebp)
 713:	e8 35 ff ff ff       	call   64d <putc>
 718:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 71b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 71f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 723:	79 d9                	jns    6fe <printint+0x8a>
}
 725:	90                   	nop
 726:	90                   	nop
 727:	c9                   	leave  
 728:	c3                   	ret    

00000729 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 729:	f3 0f 1e fb          	endbr32 
 72d:	55                   	push   %ebp
 72e:	89 e5                	mov    %esp,%ebp
 730:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 733:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 73a:	8d 45 0c             	lea    0xc(%ebp),%eax
 73d:	83 c0 04             	add    $0x4,%eax
 740:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 743:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 74a:	e9 59 01 00 00       	jmp    8a8 <printf+0x17f>
    c = fmt[i] & 0xff;
 74f:	8b 55 0c             	mov    0xc(%ebp),%edx
 752:	8b 45 f0             	mov    -0x10(%ebp),%eax
 755:	01 d0                	add    %edx,%eax
 757:	0f b6 00             	movzbl (%eax),%eax
 75a:	0f be c0             	movsbl %al,%eax
 75d:	25 ff 00 00 00       	and    $0xff,%eax
 762:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 765:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 769:	75 2c                	jne    797 <printf+0x6e>
      if(c == '%'){
 76b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 76f:	75 0c                	jne    77d <printf+0x54>
        state = '%';
 771:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 778:	e9 27 01 00 00       	jmp    8a4 <printf+0x17b>
      } else {
        putc(fd, c);
 77d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 780:	0f be c0             	movsbl %al,%eax
 783:	83 ec 08             	sub    $0x8,%esp
 786:	50                   	push   %eax
 787:	ff 75 08             	pushl  0x8(%ebp)
 78a:	e8 be fe ff ff       	call   64d <putc>
 78f:	83 c4 10             	add    $0x10,%esp
 792:	e9 0d 01 00 00       	jmp    8a4 <printf+0x17b>
      }
    } else if(state == '%'){
 797:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 79b:	0f 85 03 01 00 00    	jne    8a4 <printf+0x17b>
      if(c == 'd'){
 7a1:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7a5:	75 1e                	jne    7c5 <printf+0x9c>
        printint(fd, *ap, 10, 1);
 7a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7aa:	8b 00                	mov    (%eax),%eax
 7ac:	6a 01                	push   $0x1
 7ae:	6a 0a                	push   $0xa
 7b0:	50                   	push   %eax
 7b1:	ff 75 08             	pushl  0x8(%ebp)
 7b4:	e8 bb fe ff ff       	call   674 <printint>
 7b9:	83 c4 10             	add    $0x10,%esp
        ap++;
 7bc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7c0:	e9 d8 00 00 00       	jmp    89d <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 7c5:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7c9:	74 06                	je     7d1 <printf+0xa8>
 7cb:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7cf:	75 1e                	jne    7ef <printf+0xc6>
        printint(fd, *ap, 16, 0);
 7d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7d4:	8b 00                	mov    (%eax),%eax
 7d6:	6a 00                	push   $0x0
 7d8:	6a 10                	push   $0x10
 7da:	50                   	push   %eax
 7db:	ff 75 08             	pushl  0x8(%ebp)
 7de:	e8 91 fe ff ff       	call   674 <printint>
 7e3:	83 c4 10             	add    $0x10,%esp
        ap++;
 7e6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7ea:	e9 ae 00 00 00       	jmp    89d <printf+0x174>
      } else if(c == 's'){
 7ef:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7f3:	75 43                	jne    838 <printf+0x10f>
        s = (char*)*ap;
 7f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7f8:	8b 00                	mov    (%eax),%eax
 7fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7fd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 801:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 805:	75 25                	jne    82c <printf+0x103>
          s = "(null)";
 807:	c7 45 f4 b5 0b 00 00 	movl   $0xbb5,-0xc(%ebp)
        while(*s != 0){
 80e:	eb 1c                	jmp    82c <printf+0x103>
          putc(fd, *s);
 810:	8b 45 f4             	mov    -0xc(%ebp),%eax
 813:	0f b6 00             	movzbl (%eax),%eax
 816:	0f be c0             	movsbl %al,%eax
 819:	83 ec 08             	sub    $0x8,%esp
 81c:	50                   	push   %eax
 81d:	ff 75 08             	pushl  0x8(%ebp)
 820:	e8 28 fe ff ff       	call   64d <putc>
 825:	83 c4 10             	add    $0x10,%esp
          s++;
 828:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 82c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82f:	0f b6 00             	movzbl (%eax),%eax
 832:	84 c0                	test   %al,%al
 834:	75 da                	jne    810 <printf+0xe7>
 836:	eb 65                	jmp    89d <printf+0x174>
        }
      } else if(c == 'c'){
 838:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 83c:	75 1d                	jne    85b <printf+0x132>
        putc(fd, *ap);
 83e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 841:	8b 00                	mov    (%eax),%eax
 843:	0f be c0             	movsbl %al,%eax
 846:	83 ec 08             	sub    $0x8,%esp
 849:	50                   	push   %eax
 84a:	ff 75 08             	pushl  0x8(%ebp)
 84d:	e8 fb fd ff ff       	call   64d <putc>
 852:	83 c4 10             	add    $0x10,%esp
        ap++;
 855:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 859:	eb 42                	jmp    89d <printf+0x174>
      } else if(c == '%'){
 85b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 85f:	75 17                	jne    878 <printf+0x14f>
        putc(fd, c);
 861:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 864:	0f be c0             	movsbl %al,%eax
 867:	83 ec 08             	sub    $0x8,%esp
 86a:	50                   	push   %eax
 86b:	ff 75 08             	pushl  0x8(%ebp)
 86e:	e8 da fd ff ff       	call   64d <putc>
 873:	83 c4 10             	add    $0x10,%esp
 876:	eb 25                	jmp    89d <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 878:	83 ec 08             	sub    $0x8,%esp
 87b:	6a 25                	push   $0x25
 87d:	ff 75 08             	pushl  0x8(%ebp)
 880:	e8 c8 fd ff ff       	call   64d <putc>
 885:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 888:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 88b:	0f be c0             	movsbl %al,%eax
 88e:	83 ec 08             	sub    $0x8,%esp
 891:	50                   	push   %eax
 892:	ff 75 08             	pushl  0x8(%ebp)
 895:	e8 b3 fd ff ff       	call   64d <putc>
 89a:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 89d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 8a4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8a8:	8b 55 0c             	mov    0xc(%ebp),%edx
 8ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ae:	01 d0                	add    %edx,%eax
 8b0:	0f b6 00             	movzbl (%eax),%eax
 8b3:	84 c0                	test   %al,%al
 8b5:	0f 85 94 fe ff ff    	jne    74f <printf+0x26>
    }
  }
}
 8bb:	90                   	nop
 8bc:	90                   	nop
 8bd:	c9                   	leave  
 8be:	c3                   	ret    

000008bf <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8bf:	f3 0f 1e fb          	endbr32 
 8c3:	55                   	push   %ebp
 8c4:	89 e5                	mov    %esp,%ebp
 8c6:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8c9:	8b 45 08             	mov    0x8(%ebp),%eax
 8cc:	83 e8 08             	sub    $0x8,%eax
 8cf:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d2:	a1 90 0e 00 00       	mov    0xe90,%eax
 8d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8da:	eb 24                	jmp    900 <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8df:	8b 00                	mov    (%eax),%eax
 8e1:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 8e4:	72 12                	jb     8f8 <free+0x39>
 8e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8ec:	77 24                	ja     912 <free+0x53>
 8ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f1:	8b 00                	mov    (%eax),%eax
 8f3:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 8f6:	72 1a                	jb     912 <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fb:	8b 00                	mov    (%eax),%eax
 8fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
 900:	8b 45 f8             	mov    -0x8(%ebp),%eax
 903:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 906:	76 d4                	jbe    8dc <free+0x1d>
 908:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90b:	8b 00                	mov    (%eax),%eax
 90d:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 910:	73 ca                	jae    8dc <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 912:	8b 45 f8             	mov    -0x8(%ebp),%eax
 915:	8b 40 04             	mov    0x4(%eax),%eax
 918:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 91f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 922:	01 c2                	add    %eax,%edx
 924:	8b 45 fc             	mov    -0x4(%ebp),%eax
 927:	8b 00                	mov    (%eax),%eax
 929:	39 c2                	cmp    %eax,%edx
 92b:	75 24                	jne    951 <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 92d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 930:	8b 50 04             	mov    0x4(%eax),%edx
 933:	8b 45 fc             	mov    -0x4(%ebp),%eax
 936:	8b 00                	mov    (%eax),%eax
 938:	8b 40 04             	mov    0x4(%eax),%eax
 93b:	01 c2                	add    %eax,%edx
 93d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 940:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 943:	8b 45 fc             	mov    -0x4(%ebp),%eax
 946:	8b 00                	mov    (%eax),%eax
 948:	8b 10                	mov    (%eax),%edx
 94a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 94d:	89 10                	mov    %edx,(%eax)
 94f:	eb 0a                	jmp    95b <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 951:	8b 45 fc             	mov    -0x4(%ebp),%eax
 954:	8b 10                	mov    (%eax),%edx
 956:	8b 45 f8             	mov    -0x8(%ebp),%eax
 959:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 95b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95e:	8b 40 04             	mov    0x4(%eax),%eax
 961:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 968:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96b:	01 d0                	add    %edx,%eax
 96d:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 970:	75 20                	jne    992 <free+0xd3>
    p->s.size += bp->s.size;
 972:	8b 45 fc             	mov    -0x4(%ebp),%eax
 975:	8b 50 04             	mov    0x4(%eax),%edx
 978:	8b 45 f8             	mov    -0x8(%ebp),%eax
 97b:	8b 40 04             	mov    0x4(%eax),%eax
 97e:	01 c2                	add    %eax,%edx
 980:	8b 45 fc             	mov    -0x4(%ebp),%eax
 983:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 986:	8b 45 f8             	mov    -0x8(%ebp),%eax
 989:	8b 10                	mov    (%eax),%edx
 98b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 98e:	89 10                	mov    %edx,(%eax)
 990:	eb 08                	jmp    99a <free+0xdb>
  } else
    p->s.ptr = bp;
 992:	8b 45 fc             	mov    -0x4(%ebp),%eax
 995:	8b 55 f8             	mov    -0x8(%ebp),%edx
 998:	89 10                	mov    %edx,(%eax)
  freep = p;
 99a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99d:	a3 90 0e 00 00       	mov    %eax,0xe90
}
 9a2:	90                   	nop
 9a3:	c9                   	leave  
 9a4:	c3                   	ret    

000009a5 <morecore>:

static Header*
morecore(uint nu)
{
 9a5:	f3 0f 1e fb          	endbr32 
 9a9:	55                   	push   %ebp
 9aa:	89 e5                	mov    %esp,%ebp
 9ac:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9af:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9b6:	77 07                	ja     9bf <morecore+0x1a>
    nu = 4096;
 9b8:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9bf:	8b 45 08             	mov    0x8(%ebp),%eax
 9c2:	c1 e0 03             	shl    $0x3,%eax
 9c5:	83 ec 0c             	sub    $0xc,%esp
 9c8:	50                   	push   %eax
 9c9:	e8 5f fc ff ff       	call   62d <sbrk>
 9ce:	83 c4 10             	add    $0x10,%esp
 9d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9d4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9d8:	75 07                	jne    9e1 <morecore+0x3c>
    return 0;
 9da:	b8 00 00 00 00       	mov    $0x0,%eax
 9df:	eb 26                	jmp    a07 <morecore+0x62>
  hp = (Header*)p;
 9e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ea:	8b 55 08             	mov    0x8(%ebp),%edx
 9ed:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9f3:	83 c0 08             	add    $0x8,%eax
 9f6:	83 ec 0c             	sub    $0xc,%esp
 9f9:	50                   	push   %eax
 9fa:	e8 c0 fe ff ff       	call   8bf <free>
 9ff:	83 c4 10             	add    $0x10,%esp
  return freep;
 a02:	a1 90 0e 00 00       	mov    0xe90,%eax
}
 a07:	c9                   	leave  
 a08:	c3                   	ret    

00000a09 <malloc>:

void*
malloc(uint nbytes)
{
 a09:	f3 0f 1e fb          	endbr32 
 a0d:	55                   	push   %ebp
 a0e:	89 e5                	mov    %esp,%ebp
 a10:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a13:	8b 45 08             	mov    0x8(%ebp),%eax
 a16:	83 c0 07             	add    $0x7,%eax
 a19:	c1 e8 03             	shr    $0x3,%eax
 a1c:	83 c0 01             	add    $0x1,%eax
 a1f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a22:	a1 90 0e 00 00       	mov    0xe90,%eax
 a27:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a2a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a2e:	75 23                	jne    a53 <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 a30:	c7 45 f0 88 0e 00 00 	movl   $0xe88,-0x10(%ebp)
 a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a3a:	a3 90 0e 00 00       	mov    %eax,0xe90
 a3f:	a1 90 0e 00 00       	mov    0xe90,%eax
 a44:	a3 88 0e 00 00       	mov    %eax,0xe88
    base.s.size = 0;
 a49:	c7 05 8c 0e 00 00 00 	movl   $0x0,0xe8c
 a50:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a53:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a56:	8b 00                	mov    (%eax),%eax
 a58:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5e:	8b 40 04             	mov    0x4(%eax),%eax
 a61:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 a64:	77 4d                	ja     ab3 <malloc+0xaa>
      if(p->s.size == nunits)
 a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a69:	8b 40 04             	mov    0x4(%eax),%eax
 a6c:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 a6f:	75 0c                	jne    a7d <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a74:	8b 10                	mov    (%eax),%edx
 a76:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a79:	89 10                	mov    %edx,(%eax)
 a7b:	eb 26                	jmp    aa3 <malloc+0x9a>
      else {
        p->s.size -= nunits;
 a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a80:	8b 40 04             	mov    0x4(%eax),%eax
 a83:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a86:	89 c2                	mov    %eax,%edx
 a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a8b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a91:	8b 40 04             	mov    0x4(%eax),%eax
 a94:	c1 e0 03             	shl    $0x3,%eax
 a97:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a9d:	8b 55 ec             	mov    -0x14(%ebp),%edx
 aa0:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aa6:	a3 90 0e 00 00       	mov    %eax,0xe90
      return (void*)(p + 1);
 aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aae:	83 c0 08             	add    $0x8,%eax
 ab1:	eb 3b                	jmp    aee <malloc+0xe5>
    }
    if(p == freep)
 ab3:	a1 90 0e 00 00       	mov    0xe90,%eax
 ab8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 abb:	75 1e                	jne    adb <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 abd:	83 ec 0c             	sub    $0xc,%esp
 ac0:	ff 75 ec             	pushl  -0x14(%ebp)
 ac3:	e8 dd fe ff ff       	call   9a5 <morecore>
 ac8:	83 c4 10             	add    $0x10,%esp
 acb:	89 45 f4             	mov    %eax,-0xc(%ebp)
 ace:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ad2:	75 07                	jne    adb <malloc+0xd2>
        return 0;
 ad4:	b8 00 00 00 00       	mov    $0x0,%eax
 ad9:	eb 13                	jmp    aee <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ade:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae4:	8b 00                	mov    (%eax),%eax
 ae6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 ae9:	e9 6d ff ff ff       	jmp    a5b <malloc+0x52>
  }
}
 aee:	c9                   	leave  
 aef:	c3                   	ret    
