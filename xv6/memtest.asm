
_memtest:     file format elf32-i386


Disassembly of section .text:

00000000 <mem>:
int stdout = 1;
#define TOTAL_MEMORY (1 << 20) + (1 << 18)

void
mem(void)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	83 ec 28             	sub    $0x28,%esp
	void *m1 = 0, *m2, *start;
   a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint cur = 0;
  11:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint count = 0;
  18:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint total_count;
	int pid;

	printf(1, "mem test\n");
  1f:	83 ec 08             	sub    $0x8,%esp
  22:	68 9c 09 00 00       	push   $0x99c
  27:	6a 01                	push   $0x1
  29:	e8 91 05 00 00       	call   5bf <printf>
  2e:	83 c4 10             	add    $0x10,%esp

	m1 = malloc(4096);
  31:	83 ec 0c             	sub    $0xc,%esp
  34:	68 00 10 00 00       	push   $0x1000
  39:	e8 61 08 00 00       	call   89f <malloc>
  3e:	83 c4 10             	add    $0x10,%esp
  41:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (m1 == 0)
  44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  48:	0f 84 18 01 00 00    	je     166 <mem+0x166>
		goto failed;
	start = m1;
  4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  51:	89 45 e8             	mov    %eax,-0x18(%ebp)

	while (cur < TOTAL_MEMORY) {
  54:	eb 43                	jmp    99 <mem+0x99>
		m2 = malloc(4096);
  56:	83 ec 0c             	sub    $0xc,%esp
  59:	68 00 10 00 00       	push   $0x1000
  5e:	e8 3c 08 00 00       	call   89f <malloc>
  63:	83 c4 10             	add    $0x10,%esp
  66:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (m2 == 0)
  69:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  6d:	0f 84 f6 00 00 00    	je     169 <mem+0x169>
			goto failed;
		*(char**)m1 = m2;
  73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  76:	8b 55 dc             	mov    -0x24(%ebp),%edx
  79:	89 10                	mov    %edx,(%eax)
		((int*)m1)[2] = count++;
  7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  7e:	8d 50 01             	lea    0x1(%eax),%edx
  81:	89 55 ec             	mov    %edx,-0x14(%ebp)
  84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  87:	83 c2 08             	add    $0x8,%edx
  8a:	89 02                	mov    %eax,(%edx)
		m1 = m2;
  8c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cur += 4096;
  92:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	while (cur < TOTAL_MEMORY) {
  99:	81 7d f0 ff ff 13 00 	cmpl   $0x13ffff,-0x10(%ebp)
  a0:	76 b4                	jbe    56 <mem+0x56>
	}
	((int*)m1)[2] = count;
  a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  a5:	8d 50 08             	lea    0x8(%eax),%edx
  a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  ab:	89 02                	mov    %eax,(%edx)
	total_count = count;
  ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	count = 0;
  b3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	m1 = start;
  ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  bd:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while (count != total_count) {
  c0:	eb 1d                	jmp    df <mem+0xdf>
		if (((int*)m1)[2] != count)
  c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  c5:	83 c0 08             	add    $0x8,%eax
  c8:	8b 00                	mov    (%eax),%eax
  ca:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  cd:	0f 85 99 00 00 00    	jne    16c <mem+0x16c>
			goto failed;
		m1 = *(char**)m1;
  d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  d6:	8b 00                	mov    (%eax),%eax
  d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		count++;
  db:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
	while (count != total_count) {
  df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  e2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  e5:	75 db                	jne    c2 <mem+0xc2>
	}

	pid = fork();
  e7:	e8 47 03 00 00       	call   433 <fork>
  ec:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (pid == 0){
  ef:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  f3:	75 35                	jne    12a <mem+0x12a>
		count = 0;
  f5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		m1 = start;
  fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	
		while (count != total_count) {
 102:	eb 19                	jmp    11d <mem+0x11d>
			if (((int*)m1)[2] != count){
 104:	8b 45 f4             	mov    -0xc(%ebp),%eax
 107:	83 c0 08             	add    $0x8,%eax
 10a:	8b 00                	mov    (%eax),%eax
 10c:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 10f:	75 5e                	jne    16f <mem+0x16f>
				goto failed;
			}
			m1 = *(char**)m1;
 111:	8b 45 f4             	mov    -0xc(%ebp),%eax
 114:	8b 00                	mov    (%eax),%eax
 116:	89 45 f4             	mov    %eax,-0xc(%ebp)
			count++;
 119:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
		while (count != total_count) {
 11d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 120:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
 123:	75 df                	jne    104 <mem+0x104>
		}
		exit();
 125:	e8 11 03 00 00       	call   43b <exit>
	}
	else if (pid < 0)
 12a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 12e:	79 14                	jns    144 <mem+0x144>
	{
		printf(1, "fork failed\n");
 130:	83 ec 08             	sub    $0x8,%esp
 133:	68 a6 09 00 00       	push   $0x9a6
 138:	6a 01                	push   $0x1
 13a:	e8 80 04 00 00       	call   5bf <printf>
 13f:	83 c4 10             	add    $0x10,%esp
 142:	eb 0b                	jmp    14f <mem+0x14f>
	}
	else if (pid > 0)
 144:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 148:	7e 05                	jle    14f <mem+0x14f>
	{
		wait();
 14a:	e8 f4 02 00 00       	call   443 <wait>
	}

	printf(1, "mem ok\n");
 14f:	83 ec 08             	sub    $0x8,%esp
 152:	68 b3 09 00 00       	push   $0x9b3
 157:	6a 01                	push   $0x1
 159:	e8 61 04 00 00       	call   5bf <printf>
 15e:	83 c4 10             	add    $0x10,%esp
	exit();
 161:	e8 d5 02 00 00       	call   43b <exit>
		goto failed;
 166:	90                   	nop
 167:	eb 07                	jmp    170 <mem+0x170>
			goto failed;
 169:	90                   	nop
 16a:	eb 04                	jmp    170 <mem+0x170>
			goto failed;
 16c:	90                   	nop
 16d:	eb 01                	jmp    170 <mem+0x170>
				goto failed;
 16f:	90                   	nop
failed:
	printf(1, "test failed!\n");
 170:	83 ec 08             	sub    $0x8,%esp
 173:	68 bb 09 00 00       	push   $0x9bb
 178:	6a 01                	push   $0x1
 17a:	e8 40 04 00 00       	call   5bf <printf>
 17f:	83 c4 10             	add    $0x10,%esp
	exit();
 182:	e8 b4 02 00 00       	call   43b <exit>

00000187 <main>:
}

int
main(int argc, char *argv[])
{
 187:	f3 0f 1e fb          	endbr32 
 18b:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 18f:	83 e4 f0             	and    $0xfffffff0,%esp
 192:	ff 71 fc             	pushl  -0x4(%ecx)
 195:	55                   	push   %ebp
 196:	89 e5                	mov    %esp,%ebp
 198:	51                   	push   %ecx
 199:	83 ec 04             	sub    $0x4,%esp
	printf(1, "memtest starting\n");
 19c:	83 ec 08             	sub    $0x8,%esp
 19f:	68 c9 09 00 00       	push   $0x9c9
 1a4:	6a 01                	push   $0x1
 1a6:	e8 14 04 00 00       	call   5bf <printf>
 1ab:	83 c4 10             	add    $0x10,%esp
	mem();
 1ae:	e8 4d fe ff ff       	call   0 <mem>
	return 0;
 1b3:	b8 00 00 00 00       	mov    $0x0,%eax
 1b8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
 1bb:	c9                   	leave  
 1bc:	8d 61 fc             	lea    -0x4(%ecx),%esp
 1bf:	c3                   	ret    

000001c0 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	57                   	push   %edi
 1c4:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1c8:	8b 55 10             	mov    0x10(%ebp),%edx
 1cb:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ce:	89 cb                	mov    %ecx,%ebx
 1d0:	89 df                	mov    %ebx,%edi
 1d2:	89 d1                	mov    %edx,%ecx
 1d4:	fc                   	cld    
 1d5:	f3 aa                	rep stos %al,%es:(%edi)
 1d7:	89 ca                	mov    %ecx,%edx
 1d9:	89 fb                	mov    %edi,%ebx
 1db:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1de:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1e1:	90                   	nop
 1e2:	5b                   	pop    %ebx
 1e3:	5f                   	pop    %edi
 1e4:	5d                   	pop    %ebp
 1e5:	c3                   	ret    

000001e6 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1e6:	f3 0f 1e fb          	endbr32 
 1ea:	55                   	push   %ebp
 1eb:	89 e5                	mov    %esp,%ebp
 1ed:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1f0:	8b 45 08             	mov    0x8(%ebp),%eax
 1f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1f6:	90                   	nop
 1f7:	8b 55 0c             	mov    0xc(%ebp),%edx
 1fa:	8d 42 01             	lea    0x1(%edx),%eax
 1fd:	89 45 0c             	mov    %eax,0xc(%ebp)
 200:	8b 45 08             	mov    0x8(%ebp),%eax
 203:	8d 48 01             	lea    0x1(%eax),%ecx
 206:	89 4d 08             	mov    %ecx,0x8(%ebp)
 209:	0f b6 12             	movzbl (%edx),%edx
 20c:	88 10                	mov    %dl,(%eax)
 20e:	0f b6 00             	movzbl (%eax),%eax
 211:	84 c0                	test   %al,%al
 213:	75 e2                	jne    1f7 <strcpy+0x11>
    ;
  return os;
 215:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 218:	c9                   	leave  
 219:	c3                   	ret    

0000021a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 21a:	f3 0f 1e fb          	endbr32 
 21e:	55                   	push   %ebp
 21f:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 221:	eb 08                	jmp    22b <strcmp+0x11>
    p++, q++;
 223:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 227:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 22b:	8b 45 08             	mov    0x8(%ebp),%eax
 22e:	0f b6 00             	movzbl (%eax),%eax
 231:	84 c0                	test   %al,%al
 233:	74 10                	je     245 <strcmp+0x2b>
 235:	8b 45 08             	mov    0x8(%ebp),%eax
 238:	0f b6 10             	movzbl (%eax),%edx
 23b:	8b 45 0c             	mov    0xc(%ebp),%eax
 23e:	0f b6 00             	movzbl (%eax),%eax
 241:	38 c2                	cmp    %al,%dl
 243:	74 de                	je     223 <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
 245:	8b 45 08             	mov    0x8(%ebp),%eax
 248:	0f b6 00             	movzbl (%eax),%eax
 24b:	0f b6 d0             	movzbl %al,%edx
 24e:	8b 45 0c             	mov    0xc(%ebp),%eax
 251:	0f b6 00             	movzbl (%eax),%eax
 254:	0f b6 c0             	movzbl %al,%eax
 257:	29 c2                	sub    %eax,%edx
 259:	89 d0                	mov    %edx,%eax
}
 25b:	5d                   	pop    %ebp
 25c:	c3                   	ret    

0000025d <strlen>:

uint
strlen(char *s)
{
 25d:	f3 0f 1e fb          	endbr32 
 261:	55                   	push   %ebp
 262:	89 e5                	mov    %esp,%ebp
 264:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 267:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 26e:	eb 04                	jmp    274 <strlen+0x17>
 270:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 274:	8b 55 fc             	mov    -0x4(%ebp),%edx
 277:	8b 45 08             	mov    0x8(%ebp),%eax
 27a:	01 d0                	add    %edx,%eax
 27c:	0f b6 00             	movzbl (%eax),%eax
 27f:	84 c0                	test   %al,%al
 281:	75 ed                	jne    270 <strlen+0x13>
    ;
  return n;
 283:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 286:	c9                   	leave  
 287:	c3                   	ret    

00000288 <memset>:

void*
memset(void *dst, int c, uint n)
{
 288:	f3 0f 1e fb          	endbr32 
 28c:	55                   	push   %ebp
 28d:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 28f:	8b 45 10             	mov    0x10(%ebp),%eax
 292:	50                   	push   %eax
 293:	ff 75 0c             	pushl  0xc(%ebp)
 296:	ff 75 08             	pushl  0x8(%ebp)
 299:	e8 22 ff ff ff       	call   1c0 <stosb>
 29e:	83 c4 0c             	add    $0xc,%esp
  return dst;
 2a1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a4:	c9                   	leave  
 2a5:	c3                   	ret    

000002a6 <strchr>:

char*
strchr(const char *s, char c)
{
 2a6:	f3 0f 1e fb          	endbr32 
 2aa:	55                   	push   %ebp
 2ab:	89 e5                	mov    %esp,%ebp
 2ad:	83 ec 04             	sub    $0x4,%esp
 2b0:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b3:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2b6:	eb 14                	jmp    2cc <strchr+0x26>
    if(*s == c)
 2b8:	8b 45 08             	mov    0x8(%ebp),%eax
 2bb:	0f b6 00             	movzbl (%eax),%eax
 2be:	38 45 fc             	cmp    %al,-0x4(%ebp)
 2c1:	75 05                	jne    2c8 <strchr+0x22>
      return (char*)s;
 2c3:	8b 45 08             	mov    0x8(%ebp),%eax
 2c6:	eb 13                	jmp    2db <strchr+0x35>
  for(; *s; s++)
 2c8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2cc:	8b 45 08             	mov    0x8(%ebp),%eax
 2cf:	0f b6 00             	movzbl (%eax),%eax
 2d2:	84 c0                	test   %al,%al
 2d4:	75 e2                	jne    2b8 <strchr+0x12>
  return 0;
 2d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2db:	c9                   	leave  
 2dc:	c3                   	ret    

000002dd <gets>:

char*
gets(char *buf, int max)
{
 2dd:	f3 0f 1e fb          	endbr32 
 2e1:	55                   	push   %ebp
 2e2:	89 e5                	mov    %esp,%ebp
 2e4:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2ee:	eb 42                	jmp    332 <gets+0x55>
    cc = read(0, &c, 1);
 2f0:	83 ec 04             	sub    $0x4,%esp
 2f3:	6a 01                	push   $0x1
 2f5:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2f8:	50                   	push   %eax
 2f9:	6a 00                	push   $0x0
 2fb:	e8 53 01 00 00       	call   453 <read>
 300:	83 c4 10             	add    $0x10,%esp
 303:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 306:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 30a:	7e 33                	jle    33f <gets+0x62>
      break;
    buf[i++] = c;
 30c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 30f:	8d 50 01             	lea    0x1(%eax),%edx
 312:	89 55 f4             	mov    %edx,-0xc(%ebp)
 315:	89 c2                	mov    %eax,%edx
 317:	8b 45 08             	mov    0x8(%ebp),%eax
 31a:	01 c2                	add    %eax,%edx
 31c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 320:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 322:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 326:	3c 0a                	cmp    $0xa,%al
 328:	74 16                	je     340 <gets+0x63>
 32a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 32e:	3c 0d                	cmp    $0xd,%al
 330:	74 0e                	je     340 <gets+0x63>
  for(i=0; i+1 < max; ){
 332:	8b 45 f4             	mov    -0xc(%ebp),%eax
 335:	83 c0 01             	add    $0x1,%eax
 338:	39 45 0c             	cmp    %eax,0xc(%ebp)
 33b:	7f b3                	jg     2f0 <gets+0x13>
 33d:	eb 01                	jmp    340 <gets+0x63>
      break;
 33f:	90                   	nop
      break;
  }
  buf[i] = '\0';
 340:	8b 55 f4             	mov    -0xc(%ebp),%edx
 343:	8b 45 08             	mov    0x8(%ebp),%eax
 346:	01 d0                	add    %edx,%eax
 348:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 34b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 34e:	c9                   	leave  
 34f:	c3                   	ret    

00000350 <stat>:

int
stat(char *n, struct stat *st)
{
 350:	f3 0f 1e fb          	endbr32 
 354:	55                   	push   %ebp
 355:	89 e5                	mov    %esp,%ebp
 357:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 35a:	83 ec 08             	sub    $0x8,%esp
 35d:	6a 00                	push   $0x0
 35f:	ff 75 08             	pushl  0x8(%ebp)
 362:	e8 14 01 00 00       	call   47b <open>
 367:	83 c4 10             	add    $0x10,%esp
 36a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 36d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 371:	79 07                	jns    37a <stat+0x2a>
    return -1;
 373:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 378:	eb 25                	jmp    39f <stat+0x4f>
  r = fstat(fd, st);
 37a:	83 ec 08             	sub    $0x8,%esp
 37d:	ff 75 0c             	pushl  0xc(%ebp)
 380:	ff 75 f4             	pushl  -0xc(%ebp)
 383:	e8 0b 01 00 00       	call   493 <fstat>
 388:	83 c4 10             	add    $0x10,%esp
 38b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 38e:	83 ec 0c             	sub    $0xc,%esp
 391:	ff 75 f4             	pushl  -0xc(%ebp)
 394:	e8 ca 00 00 00       	call   463 <close>
 399:	83 c4 10             	add    $0x10,%esp
  return r;
 39c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 39f:	c9                   	leave  
 3a0:	c3                   	ret    

000003a1 <atoi>:

int
atoi(const char *s)
{
 3a1:	f3 0f 1e fb          	endbr32 
 3a5:	55                   	push   %ebp
 3a6:	89 e5                	mov    %esp,%ebp
 3a8:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 3ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3b2:	eb 25                	jmp    3d9 <atoi+0x38>
    n = n*10 + *s++ - '0';
 3b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3b7:	89 d0                	mov    %edx,%eax
 3b9:	c1 e0 02             	shl    $0x2,%eax
 3bc:	01 d0                	add    %edx,%eax
 3be:	01 c0                	add    %eax,%eax
 3c0:	89 c1                	mov    %eax,%ecx
 3c2:	8b 45 08             	mov    0x8(%ebp),%eax
 3c5:	8d 50 01             	lea    0x1(%eax),%edx
 3c8:	89 55 08             	mov    %edx,0x8(%ebp)
 3cb:	0f b6 00             	movzbl (%eax),%eax
 3ce:	0f be c0             	movsbl %al,%eax
 3d1:	01 c8                	add    %ecx,%eax
 3d3:	83 e8 30             	sub    $0x30,%eax
 3d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3d9:	8b 45 08             	mov    0x8(%ebp),%eax
 3dc:	0f b6 00             	movzbl (%eax),%eax
 3df:	3c 2f                	cmp    $0x2f,%al
 3e1:	7e 0a                	jle    3ed <atoi+0x4c>
 3e3:	8b 45 08             	mov    0x8(%ebp),%eax
 3e6:	0f b6 00             	movzbl (%eax),%eax
 3e9:	3c 39                	cmp    $0x39,%al
 3eb:	7e c7                	jle    3b4 <atoi+0x13>
  return n;
 3ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3f0:	c9                   	leave  
 3f1:	c3                   	ret    

000003f2 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3f2:	f3 0f 1e fb          	endbr32 
 3f6:	55                   	push   %ebp
 3f7:	89 e5                	mov    %esp,%ebp
 3f9:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 3fc:	8b 45 08             	mov    0x8(%ebp),%eax
 3ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 402:	8b 45 0c             	mov    0xc(%ebp),%eax
 405:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 408:	eb 17                	jmp    421 <memmove+0x2f>
    *dst++ = *src++;
 40a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 40d:	8d 42 01             	lea    0x1(%edx),%eax
 410:	89 45 f8             	mov    %eax,-0x8(%ebp)
 413:	8b 45 fc             	mov    -0x4(%ebp),%eax
 416:	8d 48 01             	lea    0x1(%eax),%ecx
 419:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 41c:	0f b6 12             	movzbl (%edx),%edx
 41f:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 421:	8b 45 10             	mov    0x10(%ebp),%eax
 424:	8d 50 ff             	lea    -0x1(%eax),%edx
 427:	89 55 10             	mov    %edx,0x10(%ebp)
 42a:	85 c0                	test   %eax,%eax
 42c:	7f dc                	jg     40a <memmove+0x18>
  return vdst;
 42e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 431:	c9                   	leave  
 432:	c3                   	ret    

00000433 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 433:	b8 01 00 00 00       	mov    $0x1,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <exit>:
SYSCALL(exit)
 43b:	b8 02 00 00 00       	mov    $0x2,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <wait>:
SYSCALL(wait)
 443:	b8 03 00 00 00       	mov    $0x3,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <pipe>:
SYSCALL(pipe)
 44b:	b8 04 00 00 00       	mov    $0x4,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <read>:
SYSCALL(read)
 453:	b8 05 00 00 00       	mov    $0x5,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <write>:
SYSCALL(write)
 45b:	b8 10 00 00 00       	mov    $0x10,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <close>:
SYSCALL(close)
 463:	b8 15 00 00 00       	mov    $0x15,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <kill>:
SYSCALL(kill)
 46b:	b8 06 00 00 00       	mov    $0x6,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <exec>:
SYSCALL(exec)
 473:	b8 07 00 00 00       	mov    $0x7,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <open>:
SYSCALL(open)
 47b:	b8 0f 00 00 00       	mov    $0xf,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <mknod>:
SYSCALL(mknod)
 483:	b8 11 00 00 00       	mov    $0x11,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <unlink>:
SYSCALL(unlink)
 48b:	b8 12 00 00 00       	mov    $0x12,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <fstat>:
SYSCALL(fstat)
 493:	b8 08 00 00 00       	mov    $0x8,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <link>:
SYSCALL(link)
 49b:	b8 13 00 00 00       	mov    $0x13,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <mkdir>:
SYSCALL(mkdir)
 4a3:	b8 14 00 00 00       	mov    $0x14,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <chdir>:
SYSCALL(chdir)
 4ab:	b8 09 00 00 00       	mov    $0x9,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <dup>:
SYSCALL(dup)
 4b3:	b8 0a 00 00 00       	mov    $0xa,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <getpid>:
SYSCALL(getpid)
 4bb:	b8 0b 00 00 00       	mov    $0xb,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    

000004c3 <sbrk>:
SYSCALL(sbrk)
 4c3:	b8 0c 00 00 00       	mov    $0xc,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret    

000004cb <sleep>:
SYSCALL(sleep)
 4cb:	b8 0d 00 00 00       	mov    $0xd,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret    

000004d3 <uptime>:
SYSCALL(uptime)
 4d3:	b8 0e 00 00 00       	mov    $0xe,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret    

000004db <printpt>:
 4db:	b8 16 00 00 00       	mov    $0x16,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret    

000004e3 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4e3:	f3 0f 1e fb          	endbr32 
 4e7:	55                   	push   %ebp
 4e8:	89 e5                	mov    %esp,%ebp
 4ea:	83 ec 18             	sub    $0x18,%esp
 4ed:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f0:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4f3:	83 ec 04             	sub    $0x4,%esp
 4f6:	6a 01                	push   $0x1
 4f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4fb:	50                   	push   %eax
 4fc:	ff 75 08             	pushl  0x8(%ebp)
 4ff:	e8 57 ff ff ff       	call   45b <write>
 504:	83 c4 10             	add    $0x10,%esp
}
 507:	90                   	nop
 508:	c9                   	leave  
 509:	c3                   	ret    

0000050a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 50a:	f3 0f 1e fb          	endbr32 
 50e:	55                   	push   %ebp
 50f:	89 e5                	mov    %esp,%ebp
 511:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 514:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 51b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 51f:	74 17                	je     538 <printint+0x2e>
 521:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 525:	79 11                	jns    538 <printint+0x2e>
    neg = 1;
 527:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 52e:	8b 45 0c             	mov    0xc(%ebp),%eax
 531:	f7 d8                	neg    %eax
 533:	89 45 ec             	mov    %eax,-0x14(%ebp)
 536:	eb 06                	jmp    53e <printint+0x34>
  } else {
    x = xx;
 538:	8b 45 0c             	mov    0xc(%ebp),%eax
 53b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 53e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 545:	8b 4d 10             	mov    0x10(%ebp),%ecx
 548:	8b 45 ec             	mov    -0x14(%ebp),%eax
 54b:	ba 00 00 00 00       	mov    $0x0,%edx
 550:	f7 f1                	div    %ecx
 552:	89 d1                	mov    %edx,%ecx
 554:	8b 45 f4             	mov    -0xc(%ebp),%eax
 557:	8d 50 01             	lea    0x1(%eax),%edx
 55a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 55d:	0f b6 91 64 0c 00 00 	movzbl 0xc64(%ecx),%edx
 564:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 568:	8b 4d 10             	mov    0x10(%ebp),%ecx
 56b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 56e:	ba 00 00 00 00       	mov    $0x0,%edx
 573:	f7 f1                	div    %ecx
 575:	89 45 ec             	mov    %eax,-0x14(%ebp)
 578:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 57c:	75 c7                	jne    545 <printint+0x3b>
  if(neg)
 57e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 582:	74 2d                	je     5b1 <printint+0xa7>
    buf[i++] = '-';
 584:	8b 45 f4             	mov    -0xc(%ebp),%eax
 587:	8d 50 01             	lea    0x1(%eax),%edx
 58a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 58d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 592:	eb 1d                	jmp    5b1 <printint+0xa7>
    putc(fd, buf[i]);
 594:	8d 55 dc             	lea    -0x24(%ebp),%edx
 597:	8b 45 f4             	mov    -0xc(%ebp),%eax
 59a:	01 d0                	add    %edx,%eax
 59c:	0f b6 00             	movzbl (%eax),%eax
 59f:	0f be c0             	movsbl %al,%eax
 5a2:	83 ec 08             	sub    $0x8,%esp
 5a5:	50                   	push   %eax
 5a6:	ff 75 08             	pushl  0x8(%ebp)
 5a9:	e8 35 ff ff ff       	call   4e3 <putc>
 5ae:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 5b1:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5b9:	79 d9                	jns    594 <printint+0x8a>
}
 5bb:	90                   	nop
 5bc:	90                   	nop
 5bd:	c9                   	leave  
 5be:	c3                   	ret    

000005bf <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5bf:	f3 0f 1e fb          	endbr32 
 5c3:	55                   	push   %ebp
 5c4:	89 e5                	mov    %esp,%ebp
 5c6:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5c9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5d0:	8d 45 0c             	lea    0xc(%ebp),%eax
 5d3:	83 c0 04             	add    $0x4,%eax
 5d6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5d9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5e0:	e9 59 01 00 00       	jmp    73e <printf+0x17f>
    c = fmt[i] & 0xff;
 5e5:	8b 55 0c             	mov    0xc(%ebp),%edx
 5e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5eb:	01 d0                	add    %edx,%eax
 5ed:	0f b6 00             	movzbl (%eax),%eax
 5f0:	0f be c0             	movsbl %al,%eax
 5f3:	25 ff 00 00 00       	and    $0xff,%eax
 5f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5fb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5ff:	75 2c                	jne    62d <printf+0x6e>
      if(c == '%'){
 601:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 605:	75 0c                	jne    613 <printf+0x54>
        state = '%';
 607:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 60e:	e9 27 01 00 00       	jmp    73a <printf+0x17b>
      } else {
        putc(fd, c);
 613:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 616:	0f be c0             	movsbl %al,%eax
 619:	83 ec 08             	sub    $0x8,%esp
 61c:	50                   	push   %eax
 61d:	ff 75 08             	pushl  0x8(%ebp)
 620:	e8 be fe ff ff       	call   4e3 <putc>
 625:	83 c4 10             	add    $0x10,%esp
 628:	e9 0d 01 00 00       	jmp    73a <printf+0x17b>
      }
    } else if(state == '%'){
 62d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 631:	0f 85 03 01 00 00    	jne    73a <printf+0x17b>
      if(c == 'd'){
 637:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 63b:	75 1e                	jne    65b <printf+0x9c>
        printint(fd, *ap, 10, 1);
 63d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 640:	8b 00                	mov    (%eax),%eax
 642:	6a 01                	push   $0x1
 644:	6a 0a                	push   $0xa
 646:	50                   	push   %eax
 647:	ff 75 08             	pushl  0x8(%ebp)
 64a:	e8 bb fe ff ff       	call   50a <printint>
 64f:	83 c4 10             	add    $0x10,%esp
        ap++;
 652:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 656:	e9 d8 00 00 00       	jmp    733 <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 65b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 65f:	74 06                	je     667 <printf+0xa8>
 661:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 665:	75 1e                	jne    685 <printf+0xc6>
        printint(fd, *ap, 16, 0);
 667:	8b 45 e8             	mov    -0x18(%ebp),%eax
 66a:	8b 00                	mov    (%eax),%eax
 66c:	6a 00                	push   $0x0
 66e:	6a 10                	push   $0x10
 670:	50                   	push   %eax
 671:	ff 75 08             	pushl  0x8(%ebp)
 674:	e8 91 fe ff ff       	call   50a <printint>
 679:	83 c4 10             	add    $0x10,%esp
        ap++;
 67c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 680:	e9 ae 00 00 00       	jmp    733 <printf+0x174>
      } else if(c == 's'){
 685:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 689:	75 43                	jne    6ce <printf+0x10f>
        s = (char*)*ap;
 68b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 68e:	8b 00                	mov    (%eax),%eax
 690:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 693:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 697:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 69b:	75 25                	jne    6c2 <printf+0x103>
          s = "(null)";
 69d:	c7 45 f4 db 09 00 00 	movl   $0x9db,-0xc(%ebp)
        while(*s != 0){
 6a4:	eb 1c                	jmp    6c2 <printf+0x103>
          putc(fd, *s);
 6a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a9:	0f b6 00             	movzbl (%eax),%eax
 6ac:	0f be c0             	movsbl %al,%eax
 6af:	83 ec 08             	sub    $0x8,%esp
 6b2:	50                   	push   %eax
 6b3:	ff 75 08             	pushl  0x8(%ebp)
 6b6:	e8 28 fe ff ff       	call   4e3 <putc>
 6bb:	83 c4 10             	add    $0x10,%esp
          s++;
 6be:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 6c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c5:	0f b6 00             	movzbl (%eax),%eax
 6c8:	84 c0                	test   %al,%al
 6ca:	75 da                	jne    6a6 <printf+0xe7>
 6cc:	eb 65                	jmp    733 <printf+0x174>
        }
      } else if(c == 'c'){
 6ce:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6d2:	75 1d                	jne    6f1 <printf+0x132>
        putc(fd, *ap);
 6d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6d7:	8b 00                	mov    (%eax),%eax
 6d9:	0f be c0             	movsbl %al,%eax
 6dc:	83 ec 08             	sub    $0x8,%esp
 6df:	50                   	push   %eax
 6e0:	ff 75 08             	pushl  0x8(%ebp)
 6e3:	e8 fb fd ff ff       	call   4e3 <putc>
 6e8:	83 c4 10             	add    $0x10,%esp
        ap++;
 6eb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6ef:	eb 42                	jmp    733 <printf+0x174>
      } else if(c == '%'){
 6f1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6f5:	75 17                	jne    70e <printf+0x14f>
        putc(fd, c);
 6f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6fa:	0f be c0             	movsbl %al,%eax
 6fd:	83 ec 08             	sub    $0x8,%esp
 700:	50                   	push   %eax
 701:	ff 75 08             	pushl  0x8(%ebp)
 704:	e8 da fd ff ff       	call   4e3 <putc>
 709:	83 c4 10             	add    $0x10,%esp
 70c:	eb 25                	jmp    733 <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 70e:	83 ec 08             	sub    $0x8,%esp
 711:	6a 25                	push   $0x25
 713:	ff 75 08             	pushl  0x8(%ebp)
 716:	e8 c8 fd ff ff       	call   4e3 <putc>
 71b:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 71e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 721:	0f be c0             	movsbl %al,%eax
 724:	83 ec 08             	sub    $0x8,%esp
 727:	50                   	push   %eax
 728:	ff 75 08             	pushl  0x8(%ebp)
 72b:	e8 b3 fd ff ff       	call   4e3 <putc>
 730:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 733:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 73a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 73e:	8b 55 0c             	mov    0xc(%ebp),%edx
 741:	8b 45 f0             	mov    -0x10(%ebp),%eax
 744:	01 d0                	add    %edx,%eax
 746:	0f b6 00             	movzbl (%eax),%eax
 749:	84 c0                	test   %al,%al
 74b:	0f 85 94 fe ff ff    	jne    5e5 <printf+0x26>
    }
  }
}
 751:	90                   	nop
 752:	90                   	nop
 753:	c9                   	leave  
 754:	c3                   	ret    

00000755 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 755:	f3 0f 1e fb          	endbr32 
 759:	55                   	push   %ebp
 75a:	89 e5                	mov    %esp,%ebp
 75c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 75f:	8b 45 08             	mov    0x8(%ebp),%eax
 762:	83 e8 08             	sub    $0x8,%eax
 765:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 768:	a1 88 0c 00 00       	mov    0xc88,%eax
 76d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 770:	eb 24                	jmp    796 <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 772:	8b 45 fc             	mov    -0x4(%ebp),%eax
 775:	8b 00                	mov    (%eax),%eax
 777:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 77a:	72 12                	jb     78e <free+0x39>
 77c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 782:	77 24                	ja     7a8 <free+0x53>
 784:	8b 45 fc             	mov    -0x4(%ebp),%eax
 787:	8b 00                	mov    (%eax),%eax
 789:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 78c:	72 1a                	jb     7a8 <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 791:	8b 00                	mov    (%eax),%eax
 793:	89 45 fc             	mov    %eax,-0x4(%ebp)
 796:	8b 45 f8             	mov    -0x8(%ebp),%eax
 799:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 79c:	76 d4                	jbe    772 <free+0x1d>
 79e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a1:	8b 00                	mov    (%eax),%eax
 7a3:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 7a6:	73 ca                	jae    772 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ab:	8b 40 04             	mov    0x4(%eax),%eax
 7ae:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b8:	01 c2                	add    %eax,%edx
 7ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bd:	8b 00                	mov    (%eax),%eax
 7bf:	39 c2                	cmp    %eax,%edx
 7c1:	75 24                	jne    7e7 <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 7c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c6:	8b 50 04             	mov    0x4(%eax),%edx
 7c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cc:	8b 00                	mov    (%eax),%eax
 7ce:	8b 40 04             	mov    0x4(%eax),%eax
 7d1:	01 c2                	add    %eax,%edx
 7d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d6:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7dc:	8b 00                	mov    (%eax),%eax
 7de:	8b 10                	mov    (%eax),%edx
 7e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e3:	89 10                	mov    %edx,(%eax)
 7e5:	eb 0a                	jmp    7f1 <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 7e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ea:	8b 10                	mov    (%eax),%edx
 7ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ef:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f4:	8b 40 04             	mov    0x4(%eax),%eax
 7f7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 801:	01 d0                	add    %edx,%eax
 803:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 806:	75 20                	jne    828 <free+0xd3>
    p->s.size += bp->s.size;
 808:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80b:	8b 50 04             	mov    0x4(%eax),%edx
 80e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 811:	8b 40 04             	mov    0x4(%eax),%eax
 814:	01 c2                	add    %eax,%edx
 816:	8b 45 fc             	mov    -0x4(%ebp),%eax
 819:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 81c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81f:	8b 10                	mov    (%eax),%edx
 821:	8b 45 fc             	mov    -0x4(%ebp),%eax
 824:	89 10                	mov    %edx,(%eax)
 826:	eb 08                	jmp    830 <free+0xdb>
  } else
    p->s.ptr = bp;
 828:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 82e:	89 10                	mov    %edx,(%eax)
  freep = p;
 830:	8b 45 fc             	mov    -0x4(%ebp),%eax
 833:	a3 88 0c 00 00       	mov    %eax,0xc88
}
 838:	90                   	nop
 839:	c9                   	leave  
 83a:	c3                   	ret    

0000083b <morecore>:

static Header*
morecore(uint nu)
{
 83b:	f3 0f 1e fb          	endbr32 
 83f:	55                   	push   %ebp
 840:	89 e5                	mov    %esp,%ebp
 842:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 845:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 84c:	77 07                	ja     855 <morecore+0x1a>
    nu = 4096;
 84e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 855:	8b 45 08             	mov    0x8(%ebp),%eax
 858:	c1 e0 03             	shl    $0x3,%eax
 85b:	83 ec 0c             	sub    $0xc,%esp
 85e:	50                   	push   %eax
 85f:	e8 5f fc ff ff       	call   4c3 <sbrk>
 864:	83 c4 10             	add    $0x10,%esp
 867:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 86a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 86e:	75 07                	jne    877 <morecore+0x3c>
    return 0;
 870:	b8 00 00 00 00       	mov    $0x0,%eax
 875:	eb 26                	jmp    89d <morecore+0x62>
  hp = (Header*)p;
 877:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 87d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 880:	8b 55 08             	mov    0x8(%ebp),%edx
 883:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 886:	8b 45 f0             	mov    -0x10(%ebp),%eax
 889:	83 c0 08             	add    $0x8,%eax
 88c:	83 ec 0c             	sub    $0xc,%esp
 88f:	50                   	push   %eax
 890:	e8 c0 fe ff ff       	call   755 <free>
 895:	83 c4 10             	add    $0x10,%esp
  return freep;
 898:	a1 88 0c 00 00       	mov    0xc88,%eax
}
 89d:	c9                   	leave  
 89e:	c3                   	ret    

0000089f <malloc>:

void*
malloc(uint nbytes)
{
 89f:	f3 0f 1e fb          	endbr32 
 8a3:	55                   	push   %ebp
 8a4:	89 e5                	mov    %esp,%ebp
 8a6:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a9:	8b 45 08             	mov    0x8(%ebp),%eax
 8ac:	83 c0 07             	add    $0x7,%eax
 8af:	c1 e8 03             	shr    $0x3,%eax
 8b2:	83 c0 01             	add    $0x1,%eax
 8b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8b8:	a1 88 0c 00 00       	mov    0xc88,%eax
 8bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8c4:	75 23                	jne    8e9 <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 8c6:	c7 45 f0 80 0c 00 00 	movl   $0xc80,-0x10(%ebp)
 8cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d0:	a3 88 0c 00 00       	mov    %eax,0xc88
 8d5:	a1 88 0c 00 00       	mov    0xc88,%eax
 8da:	a3 80 0c 00 00       	mov    %eax,0xc80
    base.s.size = 0;
 8df:	c7 05 84 0c 00 00 00 	movl   $0x0,0xc84
 8e6:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ec:	8b 00                	mov    (%eax),%eax
 8ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f4:	8b 40 04             	mov    0x4(%eax),%eax
 8f7:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 8fa:	77 4d                	ja     949 <malloc+0xaa>
      if(p->s.size == nunits)
 8fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ff:	8b 40 04             	mov    0x4(%eax),%eax
 902:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 905:	75 0c                	jne    913 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 907:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90a:	8b 10                	mov    (%eax),%edx
 90c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 90f:	89 10                	mov    %edx,(%eax)
 911:	eb 26                	jmp    939 <malloc+0x9a>
      else {
        p->s.size -= nunits;
 913:	8b 45 f4             	mov    -0xc(%ebp),%eax
 916:	8b 40 04             	mov    0x4(%eax),%eax
 919:	2b 45 ec             	sub    -0x14(%ebp),%eax
 91c:	89 c2                	mov    %eax,%edx
 91e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 921:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 924:	8b 45 f4             	mov    -0xc(%ebp),%eax
 927:	8b 40 04             	mov    0x4(%eax),%eax
 92a:	c1 e0 03             	shl    $0x3,%eax
 92d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 930:	8b 45 f4             	mov    -0xc(%ebp),%eax
 933:	8b 55 ec             	mov    -0x14(%ebp),%edx
 936:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 939:	8b 45 f0             	mov    -0x10(%ebp),%eax
 93c:	a3 88 0c 00 00       	mov    %eax,0xc88
      return (void*)(p + 1);
 941:	8b 45 f4             	mov    -0xc(%ebp),%eax
 944:	83 c0 08             	add    $0x8,%eax
 947:	eb 3b                	jmp    984 <malloc+0xe5>
    }
    if(p == freep)
 949:	a1 88 0c 00 00       	mov    0xc88,%eax
 94e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 951:	75 1e                	jne    971 <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 953:	83 ec 0c             	sub    $0xc,%esp
 956:	ff 75 ec             	pushl  -0x14(%ebp)
 959:	e8 dd fe ff ff       	call   83b <morecore>
 95e:	83 c4 10             	add    $0x10,%esp
 961:	89 45 f4             	mov    %eax,-0xc(%ebp)
 964:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 968:	75 07                	jne    971 <malloc+0xd2>
        return 0;
 96a:	b8 00 00 00 00       	mov    $0x0,%eax
 96f:	eb 13                	jmp    984 <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 971:	8b 45 f4             	mov    -0xc(%ebp),%eax
 974:	89 45 f0             	mov    %eax,-0x10(%ebp)
 977:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97a:	8b 00                	mov    (%eax),%eax
 97c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 97f:	e9 6d ff ff ff       	jmp    8f1 <malloc+0x52>
  }
}
 984:	c9                   	leave  
 985:	c3                   	ret    
