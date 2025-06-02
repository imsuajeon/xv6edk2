
_recurse:     file format elf32-i386


Disassembly of section .text:

00000000 <recurse>:
// Prevent this function from being optimized, which might give it closed form
#pragma GCC push_options
#pragma GCC optimize ("O0")

static int recurse(int n)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	83 ec 08             	sub    $0x8,%esp
  if(n == 0)
   a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
   e:	75 07                	jne    17 <recurse+0x17>
    return 0;
  10:	b8 00 00 00 00       	mov    $0x0,%eax
  15:	eb 17                	jmp    2e <recurse+0x2e>
  return n + recurse(n - 1);
  17:	8b 45 08             	mov    0x8(%ebp),%eax
  1a:	83 e8 01             	sub    $0x1,%eax
  1d:	83 ec 0c             	sub    $0xc,%esp
  20:	50                   	push   %eax
  21:	e8 da ff ff ff       	call   0 <recurse>
  26:	83 c4 10             	add    $0x10,%esp
  29:	8b 55 08             	mov    0x8(%ebp),%edx
  2c:	01 d0                	add    %edx,%eax
}
  2e:	c9                   	leave  
  2f:	c3                   	ret    

00000030 <main>:
#pragma GCC pop_options

int main(int argc, char *argv[])
{
  30:	f3 0f 1e fb          	endbr32 
  34:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  38:	83 e4 f0             	and    $0xfffffff0,%esp
  3b:	ff 71 fc             	pushl  -0x4(%ecx)
  3e:	55                   	push   %ebp
  3f:	89 e5                	mov    %esp,%ebp
  41:	51                   	push   %ecx
  42:	83 ec 14             	sub    $0x14,%esp
  45:	89 c8                	mov    %ecx,%eax
  int n, m;

  if(argc != 2){
  47:	83 38 02             	cmpl   $0x2,(%eax)
  4a:	74 1d                	je     69 <main+0x39>
    printf(1, "Usage: %s levels\n", argv[0]);
  4c:	8b 40 04             	mov    0x4(%eax),%eax
  4f:	8b 00                	mov    (%eax),%eax
  51:	83 ec 04             	sub    $0x4,%esp
  54:	50                   	push   %eax
  55:	68 86 08 00 00       	push   $0x886
  5a:	6a 01                	push   $0x1
  5c:	e8 5e 04 00 00       	call   4bf <printf>
  61:	83 c4 10             	add    $0x10,%esp
    exit();
  64:	e8 d2 02 00 00       	call   33b <exit>
  }
  // printpt(getpid()); // Uncomment for the test.
  n = atoi(argv[1]);
  69:	8b 40 04             	mov    0x4(%eax),%eax
  6c:	83 c0 04             	add    $0x4,%eax
  6f:	8b 00                	mov    (%eax),%eax
  71:	83 ec 0c             	sub    $0xc,%esp
  74:	50                   	push   %eax
  75:	e8 27 02 00 00       	call   2a1 <atoi>
  7a:	83 c4 10             	add    $0x10,%esp
  7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1, "Recursing %d levels\n", n);
  80:	83 ec 04             	sub    $0x4,%esp
  83:	ff 75 f4             	pushl  -0xc(%ebp)
  86:	68 98 08 00 00       	push   $0x898
  8b:	6a 01                	push   $0x1
  8d:	e8 2d 04 00 00       	call   4bf <printf>
  92:	83 c4 10             	add    $0x10,%esp
  m = recurse(n);
  95:	83 ec 0c             	sub    $0xc,%esp
  98:	ff 75 f4             	pushl  -0xc(%ebp)
  9b:	e8 60 ff ff ff       	call   0 <recurse>
  a0:	83 c4 10             	add    $0x10,%esp
  a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  printf(1, "Yielded a value of %d\n", m);
  a6:	83 ec 04             	sub    $0x4,%esp
  a9:	ff 75 f0             	pushl  -0x10(%ebp)
  ac:	68 ad 08 00 00       	push   $0x8ad
  b1:	6a 01                	push   $0x1
  b3:	e8 07 04 00 00       	call   4bf <printf>
  b8:	83 c4 10             	add    $0x10,%esp
 // printpt(getpid()); // Uncomment for the test.
  exit();
  bb:	e8 7b 02 00 00       	call   33b <exit>

000000c0 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	57                   	push   %edi
  c4:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  c8:	8b 55 10             	mov    0x10(%ebp),%edx
  cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  ce:	89 cb                	mov    %ecx,%ebx
  d0:	89 df                	mov    %ebx,%edi
  d2:	89 d1                	mov    %edx,%ecx
  d4:	fc                   	cld    
  d5:	f3 aa                	rep stos %al,%es:(%edi)
  d7:	89 ca                	mov    %ecx,%edx
  d9:	89 fb                	mov    %edi,%ebx
  db:	89 5d 08             	mov    %ebx,0x8(%ebp)
  de:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  e1:	90                   	nop
  e2:	5b                   	pop    %ebx
  e3:	5f                   	pop    %edi
  e4:	5d                   	pop    %ebp
  e5:	c3                   	ret    

000000e6 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  e6:	f3 0f 1e fb          	endbr32 
  ea:	55                   	push   %ebp
  eb:	89 e5                	mov    %esp,%ebp
  ed:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  f0:	8b 45 08             	mov    0x8(%ebp),%eax
  f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  f6:	90                   	nop
  f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  fa:	8d 42 01             	lea    0x1(%edx),%eax
  fd:	89 45 0c             	mov    %eax,0xc(%ebp)
 100:	8b 45 08             	mov    0x8(%ebp),%eax
 103:	8d 48 01             	lea    0x1(%eax),%ecx
 106:	89 4d 08             	mov    %ecx,0x8(%ebp)
 109:	0f b6 12             	movzbl (%edx),%edx
 10c:	88 10                	mov    %dl,(%eax)
 10e:	0f b6 00             	movzbl (%eax),%eax
 111:	84 c0                	test   %al,%al
 113:	75 e2                	jne    f7 <strcpy+0x11>
    ;
  return os;
 115:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 118:	c9                   	leave  
 119:	c3                   	ret    

0000011a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 11a:	f3 0f 1e fb          	endbr32 
 11e:	55                   	push   %ebp
 11f:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 121:	eb 08                	jmp    12b <strcmp+0x11>
    p++, q++;
 123:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 127:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 12b:	8b 45 08             	mov    0x8(%ebp),%eax
 12e:	0f b6 00             	movzbl (%eax),%eax
 131:	84 c0                	test   %al,%al
 133:	74 10                	je     145 <strcmp+0x2b>
 135:	8b 45 08             	mov    0x8(%ebp),%eax
 138:	0f b6 10             	movzbl (%eax),%edx
 13b:	8b 45 0c             	mov    0xc(%ebp),%eax
 13e:	0f b6 00             	movzbl (%eax),%eax
 141:	38 c2                	cmp    %al,%dl
 143:	74 de                	je     123 <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
 145:	8b 45 08             	mov    0x8(%ebp),%eax
 148:	0f b6 00             	movzbl (%eax),%eax
 14b:	0f b6 d0             	movzbl %al,%edx
 14e:	8b 45 0c             	mov    0xc(%ebp),%eax
 151:	0f b6 00             	movzbl (%eax),%eax
 154:	0f b6 c0             	movzbl %al,%eax
 157:	29 c2                	sub    %eax,%edx
 159:	89 d0                	mov    %edx,%eax
}
 15b:	5d                   	pop    %ebp
 15c:	c3                   	ret    

0000015d <strlen>:

uint
strlen(char *s)
{
 15d:	f3 0f 1e fb          	endbr32 
 161:	55                   	push   %ebp
 162:	89 e5                	mov    %esp,%ebp
 164:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 167:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 16e:	eb 04                	jmp    174 <strlen+0x17>
 170:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 174:	8b 55 fc             	mov    -0x4(%ebp),%edx
 177:	8b 45 08             	mov    0x8(%ebp),%eax
 17a:	01 d0                	add    %edx,%eax
 17c:	0f b6 00             	movzbl (%eax),%eax
 17f:	84 c0                	test   %al,%al
 181:	75 ed                	jne    170 <strlen+0x13>
    ;
  return n;
 183:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 186:	c9                   	leave  
 187:	c3                   	ret    

00000188 <memset>:

void*
memset(void *dst, int c, uint n)
{
 188:	f3 0f 1e fb          	endbr32 
 18c:	55                   	push   %ebp
 18d:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 18f:	8b 45 10             	mov    0x10(%ebp),%eax
 192:	50                   	push   %eax
 193:	ff 75 0c             	pushl  0xc(%ebp)
 196:	ff 75 08             	pushl  0x8(%ebp)
 199:	e8 22 ff ff ff       	call   c0 <stosb>
 19e:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1a1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a4:	c9                   	leave  
 1a5:	c3                   	ret    

000001a6 <strchr>:

char*
strchr(const char *s, char c)
{
 1a6:	f3 0f 1e fb          	endbr32 
 1aa:	55                   	push   %ebp
 1ab:	89 e5                	mov    %esp,%ebp
 1ad:	83 ec 04             	sub    $0x4,%esp
 1b0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b3:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1b6:	eb 14                	jmp    1cc <strchr+0x26>
    if(*s == c)
 1b8:	8b 45 08             	mov    0x8(%ebp),%eax
 1bb:	0f b6 00             	movzbl (%eax),%eax
 1be:	38 45 fc             	cmp    %al,-0x4(%ebp)
 1c1:	75 05                	jne    1c8 <strchr+0x22>
      return (char*)s;
 1c3:	8b 45 08             	mov    0x8(%ebp),%eax
 1c6:	eb 13                	jmp    1db <strchr+0x35>
  for(; *s; s++)
 1c8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1cc:	8b 45 08             	mov    0x8(%ebp),%eax
 1cf:	0f b6 00             	movzbl (%eax),%eax
 1d2:	84 c0                	test   %al,%al
 1d4:	75 e2                	jne    1b8 <strchr+0x12>
  return 0;
 1d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1db:	c9                   	leave  
 1dc:	c3                   	ret    

000001dd <gets>:

char*
gets(char *buf, int max)
{
 1dd:	f3 0f 1e fb          	endbr32 
 1e1:	55                   	push   %ebp
 1e2:	89 e5                	mov    %esp,%ebp
 1e4:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1ee:	eb 42                	jmp    232 <gets+0x55>
    cc = read(0, &c, 1);
 1f0:	83 ec 04             	sub    $0x4,%esp
 1f3:	6a 01                	push   $0x1
 1f5:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1f8:	50                   	push   %eax
 1f9:	6a 00                	push   $0x0
 1fb:	e8 53 01 00 00       	call   353 <read>
 200:	83 c4 10             	add    $0x10,%esp
 203:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 206:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 20a:	7e 33                	jle    23f <gets+0x62>
      break;
    buf[i++] = c;
 20c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 20f:	8d 50 01             	lea    0x1(%eax),%edx
 212:	89 55 f4             	mov    %edx,-0xc(%ebp)
 215:	89 c2                	mov    %eax,%edx
 217:	8b 45 08             	mov    0x8(%ebp),%eax
 21a:	01 c2                	add    %eax,%edx
 21c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 220:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 222:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 226:	3c 0a                	cmp    $0xa,%al
 228:	74 16                	je     240 <gets+0x63>
 22a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 22e:	3c 0d                	cmp    $0xd,%al
 230:	74 0e                	je     240 <gets+0x63>
  for(i=0; i+1 < max; ){
 232:	8b 45 f4             	mov    -0xc(%ebp),%eax
 235:	83 c0 01             	add    $0x1,%eax
 238:	39 45 0c             	cmp    %eax,0xc(%ebp)
 23b:	7f b3                	jg     1f0 <gets+0x13>
 23d:	eb 01                	jmp    240 <gets+0x63>
      break;
 23f:	90                   	nop
      break;
  }
  buf[i] = '\0';
 240:	8b 55 f4             	mov    -0xc(%ebp),%edx
 243:	8b 45 08             	mov    0x8(%ebp),%eax
 246:	01 d0                	add    %edx,%eax
 248:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 24b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 24e:	c9                   	leave  
 24f:	c3                   	ret    

00000250 <stat>:

int
stat(char *n, struct stat *st)
{
 250:	f3 0f 1e fb          	endbr32 
 254:	55                   	push   %ebp
 255:	89 e5                	mov    %esp,%ebp
 257:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 25a:	83 ec 08             	sub    $0x8,%esp
 25d:	6a 00                	push   $0x0
 25f:	ff 75 08             	pushl  0x8(%ebp)
 262:	e8 14 01 00 00       	call   37b <open>
 267:	83 c4 10             	add    $0x10,%esp
 26a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 26d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 271:	79 07                	jns    27a <stat+0x2a>
    return -1;
 273:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 278:	eb 25                	jmp    29f <stat+0x4f>
  r = fstat(fd, st);
 27a:	83 ec 08             	sub    $0x8,%esp
 27d:	ff 75 0c             	pushl  0xc(%ebp)
 280:	ff 75 f4             	pushl  -0xc(%ebp)
 283:	e8 0b 01 00 00       	call   393 <fstat>
 288:	83 c4 10             	add    $0x10,%esp
 28b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 28e:	83 ec 0c             	sub    $0xc,%esp
 291:	ff 75 f4             	pushl  -0xc(%ebp)
 294:	e8 ca 00 00 00       	call   363 <close>
 299:	83 c4 10             	add    $0x10,%esp
  return r;
 29c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 29f:	c9                   	leave  
 2a0:	c3                   	ret    

000002a1 <atoi>:

int
atoi(const char *s)
{
 2a1:	f3 0f 1e fb          	endbr32 
 2a5:	55                   	push   %ebp
 2a6:	89 e5                	mov    %esp,%ebp
 2a8:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2b2:	eb 25                	jmp    2d9 <atoi+0x38>
    n = n*10 + *s++ - '0';
 2b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2b7:	89 d0                	mov    %edx,%eax
 2b9:	c1 e0 02             	shl    $0x2,%eax
 2bc:	01 d0                	add    %edx,%eax
 2be:	01 c0                	add    %eax,%eax
 2c0:	89 c1                	mov    %eax,%ecx
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
 2c5:	8d 50 01             	lea    0x1(%eax),%edx
 2c8:	89 55 08             	mov    %edx,0x8(%ebp)
 2cb:	0f b6 00             	movzbl (%eax),%eax
 2ce:	0f be c0             	movsbl %al,%eax
 2d1:	01 c8                	add    %ecx,%eax
 2d3:	83 e8 30             	sub    $0x30,%eax
 2d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2d9:	8b 45 08             	mov    0x8(%ebp),%eax
 2dc:	0f b6 00             	movzbl (%eax),%eax
 2df:	3c 2f                	cmp    $0x2f,%al
 2e1:	7e 0a                	jle    2ed <atoi+0x4c>
 2e3:	8b 45 08             	mov    0x8(%ebp),%eax
 2e6:	0f b6 00             	movzbl (%eax),%eax
 2e9:	3c 39                	cmp    $0x39,%al
 2eb:	7e c7                	jle    2b4 <atoi+0x13>
  return n;
 2ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2f0:	c9                   	leave  
 2f1:	c3                   	ret    

000002f2 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2f2:	f3 0f 1e fb          	endbr32 
 2f6:	55                   	push   %ebp
 2f7:	89 e5                	mov    %esp,%ebp
 2f9:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
 2ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 302:	8b 45 0c             	mov    0xc(%ebp),%eax
 305:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 308:	eb 17                	jmp    321 <memmove+0x2f>
    *dst++ = *src++;
 30a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 30d:	8d 42 01             	lea    0x1(%edx),%eax
 310:	89 45 f8             	mov    %eax,-0x8(%ebp)
 313:	8b 45 fc             	mov    -0x4(%ebp),%eax
 316:	8d 48 01             	lea    0x1(%eax),%ecx
 319:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 31c:	0f b6 12             	movzbl (%edx),%edx
 31f:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 321:	8b 45 10             	mov    0x10(%ebp),%eax
 324:	8d 50 ff             	lea    -0x1(%eax),%edx
 327:	89 55 10             	mov    %edx,0x10(%ebp)
 32a:	85 c0                	test   %eax,%eax
 32c:	7f dc                	jg     30a <memmove+0x18>
  return vdst;
 32e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 331:	c9                   	leave  
 332:	c3                   	ret    

00000333 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 333:	b8 01 00 00 00       	mov    $0x1,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <exit>:
SYSCALL(exit)
 33b:	b8 02 00 00 00       	mov    $0x2,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <wait>:
SYSCALL(wait)
 343:	b8 03 00 00 00       	mov    $0x3,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <pipe>:
SYSCALL(pipe)
 34b:	b8 04 00 00 00       	mov    $0x4,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <read>:
SYSCALL(read)
 353:	b8 05 00 00 00       	mov    $0x5,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <write>:
SYSCALL(write)
 35b:	b8 10 00 00 00       	mov    $0x10,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <close>:
SYSCALL(close)
 363:	b8 15 00 00 00       	mov    $0x15,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <kill>:
SYSCALL(kill)
 36b:	b8 06 00 00 00       	mov    $0x6,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <exec>:
SYSCALL(exec)
 373:	b8 07 00 00 00       	mov    $0x7,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <open>:
SYSCALL(open)
 37b:	b8 0f 00 00 00       	mov    $0xf,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <mknod>:
SYSCALL(mknod)
 383:	b8 11 00 00 00       	mov    $0x11,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <unlink>:
SYSCALL(unlink)
 38b:	b8 12 00 00 00       	mov    $0x12,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <fstat>:
SYSCALL(fstat)
 393:	b8 08 00 00 00       	mov    $0x8,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <link>:
SYSCALL(link)
 39b:	b8 13 00 00 00       	mov    $0x13,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <mkdir>:
SYSCALL(mkdir)
 3a3:	b8 14 00 00 00       	mov    $0x14,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <chdir>:
SYSCALL(chdir)
 3ab:	b8 09 00 00 00       	mov    $0x9,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <dup>:
SYSCALL(dup)
 3b3:	b8 0a 00 00 00       	mov    $0xa,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <getpid>:
SYSCALL(getpid)
 3bb:	b8 0b 00 00 00       	mov    $0xb,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <sbrk>:
SYSCALL(sbrk)
 3c3:	b8 0c 00 00 00       	mov    $0xc,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <sleep>:
SYSCALL(sleep)
 3cb:	b8 0d 00 00 00       	mov    $0xd,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <uptime>:
SYSCALL(uptime)
 3d3:	b8 0e 00 00 00       	mov    $0xe,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <printpt>:
 3db:	b8 16 00 00 00       	mov    $0x16,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3e3:	f3 0f 1e fb          	endbr32 
 3e7:	55                   	push   %ebp
 3e8:	89 e5                	mov    %esp,%ebp
 3ea:	83 ec 18             	sub    $0x18,%esp
 3ed:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f0:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3f3:	83 ec 04             	sub    $0x4,%esp
 3f6:	6a 01                	push   $0x1
 3f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3fb:	50                   	push   %eax
 3fc:	ff 75 08             	pushl  0x8(%ebp)
 3ff:	e8 57 ff ff ff       	call   35b <write>
 404:	83 c4 10             	add    $0x10,%esp
}
 407:	90                   	nop
 408:	c9                   	leave  
 409:	c3                   	ret    

0000040a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 40a:	f3 0f 1e fb          	endbr32 
 40e:	55                   	push   %ebp
 40f:	89 e5                	mov    %esp,%ebp
 411:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 414:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 41b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 41f:	74 17                	je     438 <printint+0x2e>
 421:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 425:	79 11                	jns    438 <printint+0x2e>
    neg = 1;
 427:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 42e:	8b 45 0c             	mov    0xc(%ebp),%eax
 431:	f7 d8                	neg    %eax
 433:	89 45 ec             	mov    %eax,-0x14(%ebp)
 436:	eb 06                	jmp    43e <printint+0x34>
  } else {
    x = xx;
 438:	8b 45 0c             	mov    0xc(%ebp),%eax
 43b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 43e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 445:	8b 4d 10             	mov    0x10(%ebp),%ecx
 448:	8b 45 ec             	mov    -0x14(%ebp),%eax
 44b:	ba 00 00 00 00       	mov    $0x0,%edx
 450:	f7 f1                	div    %ecx
 452:	89 d1                	mov    %edx,%ecx
 454:	8b 45 f4             	mov    -0xc(%ebp),%eax
 457:	8d 50 01             	lea    0x1(%eax),%edx
 45a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 45d:	0f b6 91 30 0b 00 00 	movzbl 0xb30(%ecx),%edx
 464:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 468:	8b 4d 10             	mov    0x10(%ebp),%ecx
 46b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 46e:	ba 00 00 00 00       	mov    $0x0,%edx
 473:	f7 f1                	div    %ecx
 475:	89 45 ec             	mov    %eax,-0x14(%ebp)
 478:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 47c:	75 c7                	jne    445 <printint+0x3b>
  if(neg)
 47e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 482:	74 2d                	je     4b1 <printint+0xa7>
    buf[i++] = '-';
 484:	8b 45 f4             	mov    -0xc(%ebp),%eax
 487:	8d 50 01             	lea    0x1(%eax),%edx
 48a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 48d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 492:	eb 1d                	jmp    4b1 <printint+0xa7>
    putc(fd, buf[i]);
 494:	8d 55 dc             	lea    -0x24(%ebp),%edx
 497:	8b 45 f4             	mov    -0xc(%ebp),%eax
 49a:	01 d0                	add    %edx,%eax
 49c:	0f b6 00             	movzbl (%eax),%eax
 49f:	0f be c0             	movsbl %al,%eax
 4a2:	83 ec 08             	sub    $0x8,%esp
 4a5:	50                   	push   %eax
 4a6:	ff 75 08             	pushl  0x8(%ebp)
 4a9:	e8 35 ff ff ff       	call   3e3 <putc>
 4ae:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 4b1:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4b9:	79 d9                	jns    494 <printint+0x8a>
}
 4bb:	90                   	nop
 4bc:	90                   	nop
 4bd:	c9                   	leave  
 4be:	c3                   	ret    

000004bf <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4bf:	f3 0f 1e fb          	endbr32 
 4c3:	55                   	push   %ebp
 4c4:	89 e5                	mov    %esp,%ebp
 4c6:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4c9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4d0:	8d 45 0c             	lea    0xc(%ebp),%eax
 4d3:	83 c0 04             	add    $0x4,%eax
 4d6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4d9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4e0:	e9 59 01 00 00       	jmp    63e <printf+0x17f>
    c = fmt[i] & 0xff;
 4e5:	8b 55 0c             	mov    0xc(%ebp),%edx
 4e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4eb:	01 d0                	add    %edx,%eax
 4ed:	0f b6 00             	movzbl (%eax),%eax
 4f0:	0f be c0             	movsbl %al,%eax
 4f3:	25 ff 00 00 00       	and    $0xff,%eax
 4f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4fb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4ff:	75 2c                	jne    52d <printf+0x6e>
      if(c == '%'){
 501:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 505:	75 0c                	jne    513 <printf+0x54>
        state = '%';
 507:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 50e:	e9 27 01 00 00       	jmp    63a <printf+0x17b>
      } else {
        putc(fd, c);
 513:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 516:	0f be c0             	movsbl %al,%eax
 519:	83 ec 08             	sub    $0x8,%esp
 51c:	50                   	push   %eax
 51d:	ff 75 08             	pushl  0x8(%ebp)
 520:	e8 be fe ff ff       	call   3e3 <putc>
 525:	83 c4 10             	add    $0x10,%esp
 528:	e9 0d 01 00 00       	jmp    63a <printf+0x17b>
      }
    } else if(state == '%'){
 52d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 531:	0f 85 03 01 00 00    	jne    63a <printf+0x17b>
      if(c == 'd'){
 537:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 53b:	75 1e                	jne    55b <printf+0x9c>
        printint(fd, *ap, 10, 1);
 53d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 540:	8b 00                	mov    (%eax),%eax
 542:	6a 01                	push   $0x1
 544:	6a 0a                	push   $0xa
 546:	50                   	push   %eax
 547:	ff 75 08             	pushl  0x8(%ebp)
 54a:	e8 bb fe ff ff       	call   40a <printint>
 54f:	83 c4 10             	add    $0x10,%esp
        ap++;
 552:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 556:	e9 d8 00 00 00       	jmp    633 <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 55b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 55f:	74 06                	je     567 <printf+0xa8>
 561:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 565:	75 1e                	jne    585 <printf+0xc6>
        printint(fd, *ap, 16, 0);
 567:	8b 45 e8             	mov    -0x18(%ebp),%eax
 56a:	8b 00                	mov    (%eax),%eax
 56c:	6a 00                	push   $0x0
 56e:	6a 10                	push   $0x10
 570:	50                   	push   %eax
 571:	ff 75 08             	pushl  0x8(%ebp)
 574:	e8 91 fe ff ff       	call   40a <printint>
 579:	83 c4 10             	add    $0x10,%esp
        ap++;
 57c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 580:	e9 ae 00 00 00       	jmp    633 <printf+0x174>
      } else if(c == 's'){
 585:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 589:	75 43                	jne    5ce <printf+0x10f>
        s = (char*)*ap;
 58b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 58e:	8b 00                	mov    (%eax),%eax
 590:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 593:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 597:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 59b:	75 25                	jne    5c2 <printf+0x103>
          s = "(null)";
 59d:	c7 45 f4 c4 08 00 00 	movl   $0x8c4,-0xc(%ebp)
        while(*s != 0){
 5a4:	eb 1c                	jmp    5c2 <printf+0x103>
          putc(fd, *s);
 5a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a9:	0f b6 00             	movzbl (%eax),%eax
 5ac:	0f be c0             	movsbl %al,%eax
 5af:	83 ec 08             	sub    $0x8,%esp
 5b2:	50                   	push   %eax
 5b3:	ff 75 08             	pushl  0x8(%ebp)
 5b6:	e8 28 fe ff ff       	call   3e3 <putc>
 5bb:	83 c4 10             	add    $0x10,%esp
          s++;
 5be:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 5c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c5:	0f b6 00             	movzbl (%eax),%eax
 5c8:	84 c0                	test   %al,%al
 5ca:	75 da                	jne    5a6 <printf+0xe7>
 5cc:	eb 65                	jmp    633 <printf+0x174>
        }
      } else if(c == 'c'){
 5ce:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5d2:	75 1d                	jne    5f1 <printf+0x132>
        putc(fd, *ap);
 5d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d7:	8b 00                	mov    (%eax),%eax
 5d9:	0f be c0             	movsbl %al,%eax
 5dc:	83 ec 08             	sub    $0x8,%esp
 5df:	50                   	push   %eax
 5e0:	ff 75 08             	pushl  0x8(%ebp)
 5e3:	e8 fb fd ff ff       	call   3e3 <putc>
 5e8:	83 c4 10             	add    $0x10,%esp
        ap++;
 5eb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ef:	eb 42                	jmp    633 <printf+0x174>
      } else if(c == '%'){
 5f1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5f5:	75 17                	jne    60e <printf+0x14f>
        putc(fd, c);
 5f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5fa:	0f be c0             	movsbl %al,%eax
 5fd:	83 ec 08             	sub    $0x8,%esp
 600:	50                   	push   %eax
 601:	ff 75 08             	pushl  0x8(%ebp)
 604:	e8 da fd ff ff       	call   3e3 <putc>
 609:	83 c4 10             	add    $0x10,%esp
 60c:	eb 25                	jmp    633 <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 60e:	83 ec 08             	sub    $0x8,%esp
 611:	6a 25                	push   $0x25
 613:	ff 75 08             	pushl  0x8(%ebp)
 616:	e8 c8 fd ff ff       	call   3e3 <putc>
 61b:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 61e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 621:	0f be c0             	movsbl %al,%eax
 624:	83 ec 08             	sub    $0x8,%esp
 627:	50                   	push   %eax
 628:	ff 75 08             	pushl  0x8(%ebp)
 62b:	e8 b3 fd ff ff       	call   3e3 <putc>
 630:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 633:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 63a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 63e:	8b 55 0c             	mov    0xc(%ebp),%edx
 641:	8b 45 f0             	mov    -0x10(%ebp),%eax
 644:	01 d0                	add    %edx,%eax
 646:	0f b6 00             	movzbl (%eax),%eax
 649:	84 c0                	test   %al,%al
 64b:	0f 85 94 fe ff ff    	jne    4e5 <printf+0x26>
    }
  }
}
 651:	90                   	nop
 652:	90                   	nop
 653:	c9                   	leave  
 654:	c3                   	ret    

00000655 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 655:	f3 0f 1e fb          	endbr32 
 659:	55                   	push   %ebp
 65a:	89 e5                	mov    %esp,%ebp
 65c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 65f:	8b 45 08             	mov    0x8(%ebp),%eax
 662:	83 e8 08             	sub    $0x8,%eax
 665:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 668:	a1 4c 0b 00 00       	mov    0xb4c,%eax
 66d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 670:	eb 24                	jmp    696 <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 672:	8b 45 fc             	mov    -0x4(%ebp),%eax
 675:	8b 00                	mov    (%eax),%eax
 677:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 67a:	72 12                	jb     68e <free+0x39>
 67c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 682:	77 24                	ja     6a8 <free+0x53>
 684:	8b 45 fc             	mov    -0x4(%ebp),%eax
 687:	8b 00                	mov    (%eax),%eax
 689:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 68c:	72 1a                	jb     6a8 <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 68e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 691:	8b 00                	mov    (%eax),%eax
 693:	89 45 fc             	mov    %eax,-0x4(%ebp)
 696:	8b 45 f8             	mov    -0x8(%ebp),%eax
 699:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 69c:	76 d4                	jbe    672 <free+0x1d>
 69e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a1:	8b 00                	mov    (%eax),%eax
 6a3:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6a6:	73 ca                	jae    672 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ab:	8b 40 04             	mov    0x4(%eax),%eax
 6ae:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b8:	01 c2                	add    %eax,%edx
 6ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bd:	8b 00                	mov    (%eax),%eax
 6bf:	39 c2                	cmp    %eax,%edx
 6c1:	75 24                	jne    6e7 <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 6c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c6:	8b 50 04             	mov    0x4(%eax),%edx
 6c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cc:	8b 00                	mov    (%eax),%eax
 6ce:	8b 40 04             	mov    0x4(%eax),%eax
 6d1:	01 c2                	add    %eax,%edx
 6d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d6:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dc:	8b 00                	mov    (%eax),%eax
 6de:	8b 10                	mov    (%eax),%edx
 6e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e3:	89 10                	mov    %edx,(%eax)
 6e5:	eb 0a                	jmp    6f1 <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 6e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ea:	8b 10                	mov    (%eax),%edx
 6ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ef:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f4:	8b 40 04             	mov    0x4(%eax),%eax
 6f7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 701:	01 d0                	add    %edx,%eax
 703:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 706:	75 20                	jne    728 <free+0xd3>
    p->s.size += bp->s.size;
 708:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70b:	8b 50 04             	mov    0x4(%eax),%edx
 70e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 711:	8b 40 04             	mov    0x4(%eax),%eax
 714:	01 c2                	add    %eax,%edx
 716:	8b 45 fc             	mov    -0x4(%ebp),%eax
 719:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 71c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71f:	8b 10                	mov    (%eax),%edx
 721:	8b 45 fc             	mov    -0x4(%ebp),%eax
 724:	89 10                	mov    %edx,(%eax)
 726:	eb 08                	jmp    730 <free+0xdb>
  } else
    p->s.ptr = bp;
 728:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 72e:	89 10                	mov    %edx,(%eax)
  freep = p;
 730:	8b 45 fc             	mov    -0x4(%ebp),%eax
 733:	a3 4c 0b 00 00       	mov    %eax,0xb4c
}
 738:	90                   	nop
 739:	c9                   	leave  
 73a:	c3                   	ret    

0000073b <morecore>:

static Header*
morecore(uint nu)
{
 73b:	f3 0f 1e fb          	endbr32 
 73f:	55                   	push   %ebp
 740:	89 e5                	mov    %esp,%ebp
 742:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 745:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 74c:	77 07                	ja     755 <morecore+0x1a>
    nu = 4096;
 74e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 755:	8b 45 08             	mov    0x8(%ebp),%eax
 758:	c1 e0 03             	shl    $0x3,%eax
 75b:	83 ec 0c             	sub    $0xc,%esp
 75e:	50                   	push   %eax
 75f:	e8 5f fc ff ff       	call   3c3 <sbrk>
 764:	83 c4 10             	add    $0x10,%esp
 767:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 76a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 76e:	75 07                	jne    777 <morecore+0x3c>
    return 0;
 770:	b8 00 00 00 00       	mov    $0x0,%eax
 775:	eb 26                	jmp    79d <morecore+0x62>
  hp = (Header*)p;
 777:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 77d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 780:	8b 55 08             	mov    0x8(%ebp),%edx
 783:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 786:	8b 45 f0             	mov    -0x10(%ebp),%eax
 789:	83 c0 08             	add    $0x8,%eax
 78c:	83 ec 0c             	sub    $0xc,%esp
 78f:	50                   	push   %eax
 790:	e8 c0 fe ff ff       	call   655 <free>
 795:	83 c4 10             	add    $0x10,%esp
  return freep;
 798:	a1 4c 0b 00 00       	mov    0xb4c,%eax
}
 79d:	c9                   	leave  
 79e:	c3                   	ret    

0000079f <malloc>:

void*
malloc(uint nbytes)
{
 79f:	f3 0f 1e fb          	endbr32 
 7a3:	55                   	push   %ebp
 7a4:	89 e5                	mov    %esp,%ebp
 7a6:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7a9:	8b 45 08             	mov    0x8(%ebp),%eax
 7ac:	83 c0 07             	add    $0x7,%eax
 7af:	c1 e8 03             	shr    $0x3,%eax
 7b2:	83 c0 01             	add    $0x1,%eax
 7b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7b8:	a1 4c 0b 00 00       	mov    0xb4c,%eax
 7bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7c4:	75 23                	jne    7e9 <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 7c6:	c7 45 f0 44 0b 00 00 	movl   $0xb44,-0x10(%ebp)
 7cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d0:	a3 4c 0b 00 00       	mov    %eax,0xb4c
 7d5:	a1 4c 0b 00 00       	mov    0xb4c,%eax
 7da:	a3 44 0b 00 00       	mov    %eax,0xb44
    base.s.size = 0;
 7df:	c7 05 48 0b 00 00 00 	movl   $0x0,0xb48
 7e6:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ec:	8b 00                	mov    (%eax),%eax
 7ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f4:	8b 40 04             	mov    0x4(%eax),%eax
 7f7:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7fa:	77 4d                	ja     849 <malloc+0xaa>
      if(p->s.size == nunits)
 7fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ff:	8b 40 04             	mov    0x4(%eax),%eax
 802:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 805:	75 0c                	jne    813 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 807:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80a:	8b 10                	mov    (%eax),%edx
 80c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80f:	89 10                	mov    %edx,(%eax)
 811:	eb 26                	jmp    839 <malloc+0x9a>
      else {
        p->s.size -= nunits;
 813:	8b 45 f4             	mov    -0xc(%ebp),%eax
 816:	8b 40 04             	mov    0x4(%eax),%eax
 819:	2b 45 ec             	sub    -0x14(%ebp),%eax
 81c:	89 c2                	mov    %eax,%edx
 81e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 821:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 824:	8b 45 f4             	mov    -0xc(%ebp),%eax
 827:	8b 40 04             	mov    0x4(%eax),%eax
 82a:	c1 e0 03             	shl    $0x3,%eax
 82d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 830:	8b 45 f4             	mov    -0xc(%ebp),%eax
 833:	8b 55 ec             	mov    -0x14(%ebp),%edx
 836:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 839:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83c:	a3 4c 0b 00 00       	mov    %eax,0xb4c
      return (void*)(p + 1);
 841:	8b 45 f4             	mov    -0xc(%ebp),%eax
 844:	83 c0 08             	add    $0x8,%eax
 847:	eb 3b                	jmp    884 <malloc+0xe5>
    }
    if(p == freep)
 849:	a1 4c 0b 00 00       	mov    0xb4c,%eax
 84e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 851:	75 1e                	jne    871 <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 853:	83 ec 0c             	sub    $0xc,%esp
 856:	ff 75 ec             	pushl  -0x14(%ebp)
 859:	e8 dd fe ff ff       	call   73b <morecore>
 85e:	83 c4 10             	add    $0x10,%esp
 861:	89 45 f4             	mov    %eax,-0xc(%ebp)
 864:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 868:	75 07                	jne    871 <malloc+0xd2>
        return 0;
 86a:	b8 00 00 00 00       	mov    $0x0,%eax
 86f:	eb 13                	jmp    884 <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 871:	8b 45 f4             	mov    -0xc(%ebp),%eax
 874:	89 45 f0             	mov    %eax,-0x10(%ebp)
 877:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87a:	8b 00                	mov    (%eax),%eax
 87c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 87f:	e9 6d ff ff ff       	jmp    7f1 <malloc+0x52>
  }
}
 884:	c9                   	leave  
 885:	c3                   	ret    
