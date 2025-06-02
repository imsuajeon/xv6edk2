
kernelmemfs:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <wait_main>:
8010000c:	00 00                	add    %al,(%eax)
	...

80100010 <entry>:
  .long 0
# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  #Set Data Segment
  mov $0x10,%ax
80100010:	66 b8 10 00          	mov    $0x10,%ax
  mov %ax,%ds
80100014:	8e d8                	mov    %eax,%ds
  mov %ax,%es
80100016:	8e c0                	mov    %eax,%es
  mov %ax,%ss
80100018:	8e d0                	mov    %eax,%ss
  mov $0,%ax
8010001a:	66 b8 00 00          	mov    $0x0,%ax
  mov %ax,%fs
8010001e:	8e e0                	mov    %eax,%fs
  mov %ax,%gs
80100020:	8e e8                	mov    %eax,%gs

  #Turn off paing
  movl %cr0,%eax
80100022:	0f 20 c0             	mov    %cr0,%eax
  andl $0x7fffffff,%eax
80100025:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  movl %eax,%cr0 
8010002a:	0f 22 c0             	mov    %eax,%cr0

  #Set Page Table Base Address
  movl    $(V2P_WO(entrypgdir)), %eax
8010002d:	b8 00 e0 10 00       	mov    $0x10e000,%eax
  movl    %eax, %cr3
80100032:	0f 22 d8             	mov    %eax,%cr3
  
  #Disable IA32e mode
  movl $0x0c0000080,%ecx
80100035:	b9 80 00 00 c0       	mov    $0xc0000080,%ecx
  rdmsr
8010003a:	0f 32                	rdmsr  
  andl $0xFFFFFEFF,%eax
8010003c:	25 ff fe ff ff       	and    $0xfffffeff,%eax
  wrmsr
80100041:	0f 30                	wrmsr  

  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
80100043:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
80100046:	83 c8 10             	or     $0x10,%eax
  andl    $0xFFFFFFDF, %eax
80100049:	83 e0 df             	and    $0xffffffdf,%eax
  movl    %eax, %cr4
8010004c:	0f 22 e0             	mov    %eax,%cr4

  #Turn on Paging
  movl    %cr0, %eax
8010004f:	0f 20 c0             	mov    %cr0,%eax
  orl     $0x80010001, %eax
80100052:	0d 01 00 01 80       	or     $0x80010001,%eax
  movl    %eax, %cr0
80100057:	0f 22 c0             	mov    %eax,%cr0




  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
8010005a:	bc 60 e3 18 80       	mov    $0x8018e360,%esp
  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
#  jz .waiting_main
  movl $main, %edx
8010005f:	ba ae 34 10 80       	mov    $0x801034ae,%edx
  jmp %edx
80100064:	ff e2                	jmp    *%edx

80100066 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100066:	f3 0f 1e fb          	endbr32 
8010006a:	55                   	push   %ebp
8010006b:	89 e5                	mov    %esp,%ebp
8010006d:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
80100070:	83 ec 08             	sub    $0x8,%esp
80100073:	68 a0 a6 10 80       	push   $0x8010a6a0
80100078:	68 60 e3 18 80       	push   $0x8018e360
8010007d:	e8 a0 49 00 00       	call   80104a22 <initlock>
80100082:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
80100085:	c7 05 ac 2a 19 80 5c 	movl   $0x80192a5c,0x80192aac
8010008c:	2a 19 80 
  bcache.head.next = &bcache.head;
8010008f:	c7 05 b0 2a 19 80 5c 	movl   $0x80192a5c,0x80192ab0
80100096:	2a 19 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100099:	c7 45 f4 94 e3 18 80 	movl   $0x8018e394,-0xc(%ebp)
801000a0:	eb 47                	jmp    801000e9 <binit+0x83>
    b->next = bcache.head.next;
801000a2:	8b 15 b0 2a 19 80    	mov    0x80192ab0,%edx
801000a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ab:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
801000ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000b1:	c7 40 50 5c 2a 19 80 	movl   $0x80192a5c,0x50(%eax)
    initsleeplock(&b->lock, "buffer");
801000b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000bb:	83 c0 0c             	add    $0xc,%eax
801000be:	83 ec 08             	sub    $0x8,%esp
801000c1:	68 a7 a6 10 80       	push   $0x8010a6a7
801000c6:	50                   	push   %eax
801000c7:	e8 e9 47 00 00       	call   801048b5 <initsleeplock>
801000cc:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000cf:	a1 b0 2a 19 80       	mov    0x80192ab0,%eax
801000d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801000d7:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801000da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000dd:	a3 b0 2a 19 80       	mov    %eax,0x80192ab0
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000e2:	81 45 f4 5c 02 00 00 	addl   $0x25c,-0xc(%ebp)
801000e9:	b8 5c 2a 19 80       	mov    $0x80192a5c,%eax
801000ee:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000f1:	72 af                	jb     801000a2 <binit+0x3c>
  }
}
801000f3:	90                   	nop
801000f4:	90                   	nop
801000f5:	c9                   	leave  
801000f6:	c3                   	ret    

801000f7 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000f7:	f3 0f 1e fb          	endbr32 
801000fb:	55                   	push   %ebp
801000fc:	89 e5                	mov    %esp,%ebp
801000fe:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
80100101:	83 ec 0c             	sub    $0xc,%esp
80100104:	68 60 e3 18 80       	push   $0x8018e360
80100109:	e8 3a 49 00 00       	call   80104a48 <acquire>
8010010e:	83 c4 10             	add    $0x10,%esp

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100111:	a1 b0 2a 19 80       	mov    0x80192ab0,%eax
80100116:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100119:	eb 58                	jmp    80100173 <bget+0x7c>
    if(b->dev == dev && b->blockno == blockno){
8010011b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011e:	8b 40 04             	mov    0x4(%eax),%eax
80100121:	39 45 08             	cmp    %eax,0x8(%ebp)
80100124:	75 44                	jne    8010016a <bget+0x73>
80100126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100129:	8b 40 08             	mov    0x8(%eax),%eax
8010012c:	39 45 0c             	cmp    %eax,0xc(%ebp)
8010012f:	75 39                	jne    8010016a <bget+0x73>
      b->refcnt++;
80100131:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100134:	8b 40 4c             	mov    0x4c(%eax),%eax
80100137:	8d 50 01             	lea    0x1(%eax),%edx
8010013a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010013d:	89 50 4c             	mov    %edx,0x4c(%eax)
      release(&bcache.lock);
80100140:	83 ec 0c             	sub    $0xc,%esp
80100143:	68 60 e3 18 80       	push   $0x8018e360
80100148:	e8 6d 49 00 00       	call   80104aba <release>
8010014d:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
80100150:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100153:	83 c0 0c             	add    $0xc,%eax
80100156:	83 ec 0c             	sub    $0xc,%esp
80100159:	50                   	push   %eax
8010015a:	e8 96 47 00 00       	call   801048f5 <acquiresleep>
8010015f:	83 c4 10             	add    $0x10,%esp
      return b;
80100162:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100165:	e9 9d 00 00 00       	jmp    80100207 <bget+0x110>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010016a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016d:	8b 40 54             	mov    0x54(%eax),%eax
80100170:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100173:	81 7d f4 5c 2a 19 80 	cmpl   $0x80192a5c,-0xc(%ebp)
8010017a:	75 9f                	jne    8010011b <bget+0x24>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
8010017c:	a1 ac 2a 19 80       	mov    0x80192aac,%eax
80100181:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100184:	eb 6b                	jmp    801001f1 <bget+0xfa>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
80100186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100189:	8b 40 4c             	mov    0x4c(%eax),%eax
8010018c:	85 c0                	test   %eax,%eax
8010018e:	75 58                	jne    801001e8 <bget+0xf1>
80100190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100193:	8b 00                	mov    (%eax),%eax
80100195:	83 e0 04             	and    $0x4,%eax
80100198:	85 c0                	test   %eax,%eax
8010019a:	75 4c                	jne    801001e8 <bget+0xf1>
      b->dev = dev;
8010019c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010019f:	8b 55 08             	mov    0x8(%ebp),%edx
801001a2:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
801001a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001a8:	8b 55 0c             	mov    0xc(%ebp),%edx
801001ab:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = 0;
801001ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      b->refcnt = 1;
801001b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001ba:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
      release(&bcache.lock);
801001c1:	83 ec 0c             	sub    $0xc,%esp
801001c4:	68 60 e3 18 80       	push   $0x8018e360
801001c9:	e8 ec 48 00 00       	call   80104aba <release>
801001ce:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
801001d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d4:	83 c0 0c             	add    $0xc,%eax
801001d7:	83 ec 0c             	sub    $0xc,%esp
801001da:	50                   	push   %eax
801001db:	e8 15 47 00 00       	call   801048f5 <acquiresleep>
801001e0:	83 c4 10             	add    $0x10,%esp
      return b;
801001e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001e6:	eb 1f                	jmp    80100207 <bget+0x110>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
801001e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001eb:	8b 40 50             	mov    0x50(%eax),%eax
801001ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
801001f1:	81 7d f4 5c 2a 19 80 	cmpl   $0x80192a5c,-0xc(%ebp)
801001f8:	75 8c                	jne    80100186 <bget+0x8f>
    }
  }
  panic("bget: no buffers");
801001fa:	83 ec 0c             	sub    $0xc,%esp
801001fd:	68 ae a6 10 80       	push   $0x8010a6ae
80100202:	e8 be 03 00 00       	call   801005c5 <panic>
}
80100207:	c9                   	leave  
80100208:	c3                   	ret    

80100209 <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
80100209:	f3 0f 1e fb          	endbr32 
8010020d:	55                   	push   %ebp
8010020e:	89 e5                	mov    %esp,%ebp
80100210:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
80100213:	83 ec 08             	sub    $0x8,%esp
80100216:	ff 75 0c             	pushl  0xc(%ebp)
80100219:	ff 75 08             	pushl  0x8(%ebp)
8010021c:	e8 d6 fe ff ff       	call   801000f7 <bget>
80100221:	83 c4 10             	add    $0x10,%esp
80100224:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((b->flags & B_VALID) == 0) {
80100227:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010022a:	8b 00                	mov    (%eax),%eax
8010022c:	83 e0 02             	and    $0x2,%eax
8010022f:	85 c0                	test   %eax,%eax
80100231:	75 0e                	jne    80100241 <bread+0x38>
    iderw(b);
80100233:	83 ec 0c             	sub    $0xc,%esp
80100236:	ff 75 f4             	pushl  -0xc(%ebp)
80100239:	e8 66 a3 00 00       	call   8010a5a4 <iderw>
8010023e:	83 c4 10             	add    $0x10,%esp
  }
  return b;
80100241:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80100244:	c9                   	leave  
80100245:	c3                   	ret    

80100246 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
80100246:	f3 0f 1e fb          	endbr32 
8010024a:	55                   	push   %ebp
8010024b:	89 e5                	mov    %esp,%ebp
8010024d:	83 ec 08             	sub    $0x8,%esp
  if(!holdingsleep(&b->lock))
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	83 c0 0c             	add    $0xc,%eax
80100256:	83 ec 0c             	sub    $0xc,%esp
80100259:	50                   	push   %eax
8010025a:	e8 50 47 00 00       	call   801049af <holdingsleep>
8010025f:	83 c4 10             	add    $0x10,%esp
80100262:	85 c0                	test   %eax,%eax
80100264:	75 0d                	jne    80100273 <bwrite+0x2d>
    panic("bwrite");
80100266:	83 ec 0c             	sub    $0xc,%esp
80100269:	68 bf a6 10 80       	push   $0x8010a6bf
8010026e:	e8 52 03 00 00       	call   801005c5 <panic>
  b->flags |= B_DIRTY;
80100273:	8b 45 08             	mov    0x8(%ebp),%eax
80100276:	8b 00                	mov    (%eax),%eax
80100278:	83 c8 04             	or     $0x4,%eax
8010027b:	89 c2                	mov    %eax,%edx
8010027d:	8b 45 08             	mov    0x8(%ebp),%eax
80100280:	89 10                	mov    %edx,(%eax)
  iderw(b);
80100282:	83 ec 0c             	sub    $0xc,%esp
80100285:	ff 75 08             	pushl  0x8(%ebp)
80100288:	e8 17 a3 00 00       	call   8010a5a4 <iderw>
8010028d:	83 c4 10             	add    $0x10,%esp
}
80100290:	90                   	nop
80100291:	c9                   	leave  
80100292:	c3                   	ret    

80100293 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100293:	f3 0f 1e fb          	endbr32 
80100297:	55                   	push   %ebp
80100298:	89 e5                	mov    %esp,%ebp
8010029a:	83 ec 08             	sub    $0x8,%esp
  if(!holdingsleep(&b->lock))
8010029d:	8b 45 08             	mov    0x8(%ebp),%eax
801002a0:	83 c0 0c             	add    $0xc,%eax
801002a3:	83 ec 0c             	sub    $0xc,%esp
801002a6:	50                   	push   %eax
801002a7:	e8 03 47 00 00       	call   801049af <holdingsleep>
801002ac:	83 c4 10             	add    $0x10,%esp
801002af:	85 c0                	test   %eax,%eax
801002b1:	75 0d                	jne    801002c0 <brelse+0x2d>
    panic("brelse");
801002b3:	83 ec 0c             	sub    $0xc,%esp
801002b6:	68 c6 a6 10 80       	push   $0x8010a6c6
801002bb:	e8 05 03 00 00       	call   801005c5 <panic>

  releasesleep(&b->lock);
801002c0:	8b 45 08             	mov    0x8(%ebp),%eax
801002c3:	83 c0 0c             	add    $0xc,%eax
801002c6:	83 ec 0c             	sub    $0xc,%esp
801002c9:	50                   	push   %eax
801002ca:	e8 8e 46 00 00       	call   8010495d <releasesleep>
801002cf:	83 c4 10             	add    $0x10,%esp

  acquire(&bcache.lock);
801002d2:	83 ec 0c             	sub    $0xc,%esp
801002d5:	68 60 e3 18 80       	push   $0x8018e360
801002da:	e8 69 47 00 00       	call   80104a48 <acquire>
801002df:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
801002e2:	8b 45 08             	mov    0x8(%ebp),%eax
801002e5:	8b 40 4c             	mov    0x4c(%eax),%eax
801002e8:	8d 50 ff             	lea    -0x1(%eax),%edx
801002eb:	8b 45 08             	mov    0x8(%ebp),%eax
801002ee:	89 50 4c             	mov    %edx,0x4c(%eax)
  if (b->refcnt == 0) {
801002f1:	8b 45 08             	mov    0x8(%ebp),%eax
801002f4:	8b 40 4c             	mov    0x4c(%eax),%eax
801002f7:	85 c0                	test   %eax,%eax
801002f9:	75 47                	jne    80100342 <brelse+0xaf>
    // no one is waiting for it.
    b->next->prev = b->prev;
801002fb:	8b 45 08             	mov    0x8(%ebp),%eax
801002fe:	8b 40 54             	mov    0x54(%eax),%eax
80100301:	8b 55 08             	mov    0x8(%ebp),%edx
80100304:	8b 52 50             	mov    0x50(%edx),%edx
80100307:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010030a:	8b 45 08             	mov    0x8(%ebp),%eax
8010030d:	8b 40 50             	mov    0x50(%eax),%eax
80100310:	8b 55 08             	mov    0x8(%ebp),%edx
80100313:	8b 52 54             	mov    0x54(%edx),%edx
80100316:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100319:	8b 15 b0 2a 19 80    	mov    0x80192ab0,%edx
8010031f:	8b 45 08             	mov    0x8(%ebp),%eax
80100322:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
80100325:	8b 45 08             	mov    0x8(%ebp),%eax
80100328:	c7 40 50 5c 2a 19 80 	movl   $0x80192a5c,0x50(%eax)
    bcache.head.next->prev = b;
8010032f:	a1 b0 2a 19 80       	mov    0x80192ab0,%eax
80100334:	8b 55 08             	mov    0x8(%ebp),%edx
80100337:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
8010033a:	8b 45 08             	mov    0x8(%ebp),%eax
8010033d:	a3 b0 2a 19 80       	mov    %eax,0x80192ab0
  }
  
  release(&bcache.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	68 60 e3 18 80       	push   $0x8018e360
8010034a:	e8 6b 47 00 00       	call   80104aba <release>
8010034f:	83 c4 10             	add    $0x10,%esp
}
80100352:	90                   	nop
80100353:	c9                   	leave  
80100354:	c3                   	ret    

80100355 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100355:	55                   	push   %ebp
80100356:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100358:	fa                   	cli    
}
80100359:	90                   	nop
8010035a:	5d                   	pop    %ebp
8010035b:	c3                   	ret    

8010035c <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
8010035c:	f3 0f 1e fb          	endbr32 
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100366:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010036a:	74 1c                	je     80100388 <printint+0x2c>
8010036c:	8b 45 08             	mov    0x8(%ebp),%eax
8010036f:	c1 e8 1f             	shr    $0x1f,%eax
80100372:	0f b6 c0             	movzbl %al,%eax
80100375:	89 45 10             	mov    %eax,0x10(%ebp)
80100378:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010037c:	74 0a                	je     80100388 <printint+0x2c>
    x = -xx;
8010037e:	8b 45 08             	mov    0x8(%ebp),%eax
80100381:	f7 d8                	neg    %eax
80100383:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100386:	eb 06                	jmp    8010038e <printint+0x32>
  else
    x = xx;
80100388:	8b 45 08             	mov    0x8(%ebp),%eax
8010038b:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
8010038e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100395:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100398:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010039b:	ba 00 00 00 00       	mov    $0x0,%edx
801003a0:	f7 f1                	div    %ecx
801003a2:	89 d1                	mov    %edx,%ecx
801003a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003a7:	8d 50 01             	lea    0x1(%eax),%edx
801003aa:	89 55 f4             	mov    %edx,-0xc(%ebp)
801003ad:	0f b6 91 04 d0 10 80 	movzbl -0x7fef2ffc(%ecx),%edx
801003b4:	88 54 05 e0          	mov    %dl,-0x20(%ebp,%eax,1)
  }while((x /= base) != 0);
801003b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801003bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801003be:	ba 00 00 00 00       	mov    $0x0,%edx
801003c3:	f7 f1                	div    %ecx
801003c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801003c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801003cc:	75 c7                	jne    80100395 <printint+0x39>

  if(sign)
801003ce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801003d2:	74 2a                	je     801003fe <printint+0xa2>
    buf[i++] = '-';
801003d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003d7:	8d 50 01             	lea    0x1(%eax),%edx
801003da:	89 55 f4             	mov    %edx,-0xc(%ebp)
801003dd:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
801003e2:	eb 1a                	jmp    801003fe <printint+0xa2>
    consputc(buf[i]);
801003e4:	8d 55 e0             	lea    -0x20(%ebp),%edx
801003e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003ea:	01 d0                	add    %edx,%eax
801003ec:	0f b6 00             	movzbl (%eax),%eax
801003ef:	0f be c0             	movsbl %al,%eax
801003f2:	83 ec 0c             	sub    $0xc,%esp
801003f5:	50                   	push   %eax
801003f6:	e8 9a 03 00 00       	call   80100795 <consputc>
801003fb:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
801003fe:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100402:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100406:	79 dc                	jns    801003e4 <printint+0x88>
}
80100408:	90                   	nop
80100409:	90                   	nop
8010040a:	c9                   	leave  
8010040b:	c3                   	ret    

8010040c <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
8010040c:	f3 0f 1e fb          	endbr32 
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100416:	a1 54 d0 18 80       	mov    0x8018d054,%eax
8010041b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
8010041e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100422:	74 10                	je     80100434 <cprintf+0x28>
    acquire(&cons.lock);
80100424:	83 ec 0c             	sub    $0xc,%esp
80100427:	68 20 d0 18 80       	push   $0x8018d020
8010042c:	e8 17 46 00 00       	call   80104a48 <acquire>
80100431:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
80100434:	8b 45 08             	mov    0x8(%ebp),%eax
80100437:	85 c0                	test   %eax,%eax
80100439:	75 0d                	jne    80100448 <cprintf+0x3c>
    panic("null fmt");
8010043b:	83 ec 0c             	sub    $0xc,%esp
8010043e:	68 cd a6 10 80       	push   $0x8010a6cd
80100443:	e8 7d 01 00 00       	call   801005c5 <panic>


  argp = (uint*)(void*)(&fmt + 1);
80100448:	8d 45 0c             	lea    0xc(%ebp),%eax
8010044b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010044e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100455:	e9 2f 01 00 00       	jmp    80100589 <cprintf+0x17d>
    if(c != '%'){
8010045a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
8010045e:	74 13                	je     80100473 <cprintf+0x67>
      consputc(c);
80100460:	83 ec 0c             	sub    $0xc,%esp
80100463:	ff 75 e4             	pushl  -0x1c(%ebp)
80100466:	e8 2a 03 00 00       	call   80100795 <consputc>
8010046b:	83 c4 10             	add    $0x10,%esp
      continue;
8010046e:	e9 12 01 00 00       	jmp    80100585 <cprintf+0x179>
    }
    c = fmt[++i] & 0xff;
80100473:	8b 55 08             	mov    0x8(%ebp),%edx
80100476:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010047a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010047d:	01 d0                	add    %edx,%eax
8010047f:	0f b6 00             	movzbl (%eax),%eax
80100482:	0f be c0             	movsbl %al,%eax
80100485:	25 ff 00 00 00       	and    $0xff,%eax
8010048a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
8010048d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100491:	0f 84 14 01 00 00    	je     801005ab <cprintf+0x19f>
      break;
    switch(c){
80100497:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
8010049b:	74 5e                	je     801004fb <cprintf+0xef>
8010049d:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
801004a1:	0f 8f c2 00 00 00    	jg     80100569 <cprintf+0x15d>
801004a7:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
801004ab:	74 6b                	je     80100518 <cprintf+0x10c>
801004ad:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
801004b1:	0f 8f b2 00 00 00    	jg     80100569 <cprintf+0x15d>
801004b7:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
801004bb:	74 3e                	je     801004fb <cprintf+0xef>
801004bd:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
801004c1:	0f 8f a2 00 00 00    	jg     80100569 <cprintf+0x15d>
801004c7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801004cb:	0f 84 89 00 00 00    	je     8010055a <cprintf+0x14e>
801004d1:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
801004d5:	0f 85 8e 00 00 00    	jne    80100569 <cprintf+0x15d>
    case 'd':
      printint(*argp++, 10, 1);
801004db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004de:	8d 50 04             	lea    0x4(%eax),%edx
801004e1:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004e4:	8b 00                	mov    (%eax),%eax
801004e6:	83 ec 04             	sub    $0x4,%esp
801004e9:	6a 01                	push   $0x1
801004eb:	6a 0a                	push   $0xa
801004ed:	50                   	push   %eax
801004ee:	e8 69 fe ff ff       	call   8010035c <printint>
801004f3:	83 c4 10             	add    $0x10,%esp
      break;
801004f6:	e9 8a 00 00 00       	jmp    80100585 <cprintf+0x179>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
801004fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004fe:	8d 50 04             	lea    0x4(%eax),%edx
80100501:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100504:	8b 00                	mov    (%eax),%eax
80100506:	83 ec 04             	sub    $0x4,%esp
80100509:	6a 00                	push   $0x0
8010050b:	6a 10                	push   $0x10
8010050d:	50                   	push   %eax
8010050e:	e8 49 fe ff ff       	call   8010035c <printint>
80100513:	83 c4 10             	add    $0x10,%esp
      break;
80100516:	eb 6d                	jmp    80100585 <cprintf+0x179>
    case 's':
      if((s = (char*)*argp++) == 0)
80100518:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010051b:	8d 50 04             	lea    0x4(%eax),%edx
8010051e:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100521:	8b 00                	mov    (%eax),%eax
80100523:	89 45 ec             	mov    %eax,-0x14(%ebp)
80100526:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010052a:	75 22                	jne    8010054e <cprintf+0x142>
        s = "(null)";
8010052c:	c7 45 ec d6 a6 10 80 	movl   $0x8010a6d6,-0x14(%ebp)
      for(; *s; s++)
80100533:	eb 19                	jmp    8010054e <cprintf+0x142>
        consputc(*s);
80100535:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100538:	0f b6 00             	movzbl (%eax),%eax
8010053b:	0f be c0             	movsbl %al,%eax
8010053e:	83 ec 0c             	sub    $0xc,%esp
80100541:	50                   	push   %eax
80100542:	e8 4e 02 00 00       	call   80100795 <consputc>
80100547:	83 c4 10             	add    $0x10,%esp
      for(; *s; s++)
8010054a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010054e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100551:	0f b6 00             	movzbl (%eax),%eax
80100554:	84 c0                	test   %al,%al
80100556:	75 dd                	jne    80100535 <cprintf+0x129>
      break;
80100558:	eb 2b                	jmp    80100585 <cprintf+0x179>
    case '%':
      consputc('%');
8010055a:	83 ec 0c             	sub    $0xc,%esp
8010055d:	6a 25                	push   $0x25
8010055f:	e8 31 02 00 00       	call   80100795 <consputc>
80100564:	83 c4 10             	add    $0x10,%esp
      break;
80100567:	eb 1c                	jmp    80100585 <cprintf+0x179>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100569:	83 ec 0c             	sub    $0xc,%esp
8010056c:	6a 25                	push   $0x25
8010056e:	e8 22 02 00 00       	call   80100795 <consputc>
80100573:	83 c4 10             	add    $0x10,%esp
      consputc(c);
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	ff 75 e4             	pushl  -0x1c(%ebp)
8010057c:	e8 14 02 00 00       	call   80100795 <consputc>
80100581:	83 c4 10             	add    $0x10,%esp
      break;
80100584:	90                   	nop
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100585:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100589:	8b 55 08             	mov    0x8(%ebp),%edx
8010058c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010058f:	01 d0                	add    %edx,%eax
80100591:	0f b6 00             	movzbl (%eax),%eax
80100594:	0f be c0             	movsbl %al,%eax
80100597:	25 ff 00 00 00       	and    $0xff,%eax
8010059c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010059f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
801005a3:	0f 85 b1 fe ff ff    	jne    8010045a <cprintf+0x4e>
801005a9:	eb 01                	jmp    801005ac <cprintf+0x1a0>
      break;
801005ab:	90                   	nop
    }
  }

  if(locking)
801005ac:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801005b0:	74 10                	je     801005c2 <cprintf+0x1b6>
    release(&cons.lock);
801005b2:	83 ec 0c             	sub    $0xc,%esp
801005b5:	68 20 d0 18 80       	push   $0x8018d020
801005ba:	e8 fb 44 00 00       	call   80104aba <release>
801005bf:	83 c4 10             	add    $0x10,%esp
}
801005c2:	90                   	nop
801005c3:	c9                   	leave  
801005c4:	c3                   	ret    

801005c5 <panic>:

void
panic(char *s)
{
801005c5:	f3 0f 1e fb          	endbr32 
801005c9:	55                   	push   %ebp
801005ca:	89 e5                	mov    %esp,%ebp
801005cc:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];

  cli();
801005cf:	e8 81 fd ff ff       	call   80100355 <cli>
  cons.locking = 0;
801005d4:	c7 05 54 d0 18 80 00 	movl   $0x0,0x8018d054
801005db:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
801005de:	e8 1c 26 00 00       	call   80102bff <lapicid>
801005e3:	83 ec 08             	sub    $0x8,%esp
801005e6:	50                   	push   %eax
801005e7:	68 dd a6 10 80       	push   $0x8010a6dd
801005ec:	e8 1b fe ff ff       	call   8010040c <cprintf>
801005f1:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
801005f4:	8b 45 08             	mov    0x8(%ebp),%eax
801005f7:	83 ec 0c             	sub    $0xc,%esp
801005fa:	50                   	push   %eax
801005fb:	e8 0c fe ff ff       	call   8010040c <cprintf>
80100600:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
80100603:	83 ec 0c             	sub    $0xc,%esp
80100606:	68 f1 a6 10 80       	push   $0x8010a6f1
8010060b:	e8 fc fd ff ff       	call   8010040c <cprintf>
80100610:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
80100613:	83 ec 08             	sub    $0x8,%esp
80100616:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100619:	50                   	push   %eax
8010061a:	8d 45 08             	lea    0x8(%ebp),%eax
8010061d:	50                   	push   %eax
8010061e:	e8 ed 44 00 00       	call   80104b10 <getcallerpcs>
80100623:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100626:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010062d:	eb 1c                	jmp    8010064b <panic+0x86>
    cprintf(" %p", pcs[i]);
8010062f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100632:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
80100636:	83 ec 08             	sub    $0x8,%esp
80100639:	50                   	push   %eax
8010063a:	68 f3 a6 10 80       	push   $0x8010a6f3
8010063f:	e8 c8 fd ff ff       	call   8010040c <cprintf>
80100644:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100647:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010064b:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
8010064f:	7e de                	jle    8010062f <panic+0x6a>
  panicked = 1; // freeze other CPU
80100651:	c7 05 00 d0 18 80 01 	movl   $0x1,0x8018d000
80100658:	00 00 00 
  for(;;)
8010065b:	eb fe                	jmp    8010065b <panic+0x96>

8010065d <graphic_putc>:

#define CONSOLE_HORIZONTAL_MAX 53
#define CONSOLE_VERTICAL_MAX 20
int console_pos = CONSOLE_HORIZONTAL_MAX*(CONSOLE_VERTICAL_MAX);
//int console_pos = 0;
void graphic_putc(int c){
8010065d:	f3 0f 1e fb          	endbr32 
80100661:	55                   	push   %ebp
80100662:	89 e5                	mov    %esp,%ebp
80100664:	83 ec 18             	sub    $0x18,%esp
  if(c == '\n'){
80100667:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
8010066b:	75 64                	jne    801006d1 <graphic_putc+0x74>
    console_pos += CONSOLE_HORIZONTAL_MAX - console_pos%CONSOLE_HORIZONTAL_MAX;
8010066d:	8b 0d 00 d0 10 80    	mov    0x8010d000,%ecx
80100673:	ba ed 73 48 4d       	mov    $0x4d4873ed,%edx
80100678:	89 c8                	mov    %ecx,%eax
8010067a:	f7 ea                	imul   %edx
8010067c:	c1 fa 04             	sar    $0x4,%edx
8010067f:	89 c8                	mov    %ecx,%eax
80100681:	c1 f8 1f             	sar    $0x1f,%eax
80100684:	29 c2                	sub    %eax,%edx
80100686:	89 d0                	mov    %edx,%eax
80100688:	6b c0 35             	imul   $0x35,%eax,%eax
8010068b:	29 c1                	sub    %eax,%ecx
8010068d:	89 c8                	mov    %ecx,%eax
8010068f:	ba 35 00 00 00       	mov    $0x35,%edx
80100694:	29 c2                	sub    %eax,%edx
80100696:	a1 00 d0 10 80       	mov    0x8010d000,%eax
8010069b:	01 d0                	add    %edx,%eax
8010069d:	a3 00 d0 10 80       	mov    %eax,0x8010d000
    if(console_pos >= CONSOLE_VERTICAL_MAX * CONSOLE_HORIZONTAL_MAX){
801006a2:	a1 00 d0 10 80       	mov    0x8010d000,%eax
801006a7:	3d 23 04 00 00       	cmp    $0x423,%eax
801006ac:	0f 8e e0 00 00 00    	jle    80100792 <graphic_putc+0x135>
      console_pos -= CONSOLE_HORIZONTAL_MAX;
801006b2:	a1 00 d0 10 80       	mov    0x8010d000,%eax
801006b7:	83 e8 35             	sub    $0x35,%eax
801006ba:	a3 00 d0 10 80       	mov    %eax,0x8010d000
      graphic_scroll_up(30);
801006bf:	83 ec 0c             	sub    $0xc,%esp
801006c2:	6a 1e                	push   $0x1e
801006c4:	e8 6f 7d 00 00       	call   80108438 <graphic_scroll_up>
801006c9:	83 c4 10             	add    $0x10,%esp
    int x = (console_pos%CONSOLE_HORIZONTAL_MAX)*FONT_WIDTH + 2;
    int y = (console_pos/CONSOLE_HORIZONTAL_MAX)*FONT_HEIGHT;
    font_render(x,y,c);
    console_pos++;
  }
}
801006cc:	e9 c1 00 00 00       	jmp    80100792 <graphic_putc+0x135>
  }else if(c == BACKSPACE){
801006d1:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801006d8:	75 1f                	jne    801006f9 <graphic_putc+0x9c>
    if(console_pos>0) --console_pos;
801006da:	a1 00 d0 10 80       	mov    0x8010d000,%eax
801006df:	85 c0                	test   %eax,%eax
801006e1:	0f 8e ab 00 00 00    	jle    80100792 <graphic_putc+0x135>
801006e7:	a1 00 d0 10 80       	mov    0x8010d000,%eax
801006ec:	83 e8 01             	sub    $0x1,%eax
801006ef:	a3 00 d0 10 80       	mov    %eax,0x8010d000
}
801006f4:	e9 99 00 00 00       	jmp    80100792 <graphic_putc+0x135>
    if(console_pos >= CONSOLE_VERTICAL_MAX * CONSOLE_HORIZONTAL_MAX){
801006f9:	a1 00 d0 10 80       	mov    0x8010d000,%eax
801006fe:	3d 23 04 00 00       	cmp    $0x423,%eax
80100703:	7e 1a                	jle    8010071f <graphic_putc+0xc2>
      console_pos -= CONSOLE_HORIZONTAL_MAX;
80100705:	a1 00 d0 10 80       	mov    0x8010d000,%eax
8010070a:	83 e8 35             	sub    $0x35,%eax
8010070d:	a3 00 d0 10 80       	mov    %eax,0x8010d000
      graphic_scroll_up(30);
80100712:	83 ec 0c             	sub    $0xc,%esp
80100715:	6a 1e                	push   $0x1e
80100717:	e8 1c 7d 00 00       	call   80108438 <graphic_scroll_up>
8010071c:	83 c4 10             	add    $0x10,%esp
    int x = (console_pos%CONSOLE_HORIZONTAL_MAX)*FONT_WIDTH + 2;
8010071f:	8b 0d 00 d0 10 80    	mov    0x8010d000,%ecx
80100725:	ba ed 73 48 4d       	mov    $0x4d4873ed,%edx
8010072a:	89 c8                	mov    %ecx,%eax
8010072c:	f7 ea                	imul   %edx
8010072e:	c1 fa 04             	sar    $0x4,%edx
80100731:	89 c8                	mov    %ecx,%eax
80100733:	c1 f8 1f             	sar    $0x1f,%eax
80100736:	29 c2                	sub    %eax,%edx
80100738:	89 d0                	mov    %edx,%eax
8010073a:	6b c0 35             	imul   $0x35,%eax,%eax
8010073d:	29 c1                	sub    %eax,%ecx
8010073f:	89 c8                	mov    %ecx,%eax
80100741:	89 c2                	mov    %eax,%edx
80100743:	c1 e2 04             	shl    $0x4,%edx
80100746:	29 c2                	sub    %eax,%edx
80100748:	89 d0                	mov    %edx,%eax
8010074a:	83 c0 02             	add    $0x2,%eax
8010074d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int y = (console_pos/CONSOLE_HORIZONTAL_MAX)*FONT_HEIGHT;
80100750:	8b 0d 00 d0 10 80    	mov    0x8010d000,%ecx
80100756:	ba ed 73 48 4d       	mov    $0x4d4873ed,%edx
8010075b:	89 c8                	mov    %ecx,%eax
8010075d:	f7 ea                	imul   %edx
8010075f:	c1 fa 04             	sar    $0x4,%edx
80100762:	89 c8                	mov    %ecx,%eax
80100764:	c1 f8 1f             	sar    $0x1f,%eax
80100767:	29 c2                	sub    %eax,%edx
80100769:	89 d0                	mov    %edx,%eax
8010076b:	6b c0 1e             	imul   $0x1e,%eax,%eax
8010076e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    font_render(x,y,c);
80100771:	83 ec 04             	sub    $0x4,%esp
80100774:	ff 75 08             	pushl  0x8(%ebp)
80100777:	ff 75 f0             	pushl  -0x10(%ebp)
8010077a:	ff 75 f4             	pushl  -0xc(%ebp)
8010077d:	e8 2a 7d 00 00       	call   801084ac <font_render>
80100782:	83 c4 10             	add    $0x10,%esp
    console_pos++;
80100785:	a1 00 d0 10 80       	mov    0x8010d000,%eax
8010078a:	83 c0 01             	add    $0x1,%eax
8010078d:	a3 00 d0 10 80       	mov    %eax,0x8010d000
}
80100792:	90                   	nop
80100793:	c9                   	leave  
80100794:	c3                   	ret    

80100795 <consputc>:


void
consputc(int c)
{
80100795:	f3 0f 1e fb          	endbr32 
80100799:	55                   	push   %ebp
8010079a:	89 e5                	mov    %esp,%ebp
8010079c:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
8010079f:	a1 00 d0 18 80       	mov    0x8018d000,%eax
801007a4:	85 c0                	test   %eax,%eax
801007a6:	74 07                	je     801007af <consputc+0x1a>
    cli();
801007a8:	e8 a8 fb ff ff       	call   80100355 <cli>
    for(;;)
801007ad:	eb fe                	jmp    801007ad <consputc+0x18>
      ;
  }

  if(c == BACKSPACE){
801007af:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801007b6:	75 29                	jne    801007e1 <consputc+0x4c>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801007b8:	83 ec 0c             	sub    $0xc,%esp
801007bb:	6a 08                	push   $0x8
801007bd:	e8 60 60 00 00       	call   80106822 <uartputc>
801007c2:	83 c4 10             	add    $0x10,%esp
801007c5:	83 ec 0c             	sub    $0xc,%esp
801007c8:	6a 20                	push   $0x20
801007ca:	e8 53 60 00 00       	call   80106822 <uartputc>
801007cf:	83 c4 10             	add    $0x10,%esp
801007d2:	83 ec 0c             	sub    $0xc,%esp
801007d5:	6a 08                	push   $0x8
801007d7:	e8 46 60 00 00       	call   80106822 <uartputc>
801007dc:	83 c4 10             	add    $0x10,%esp
801007df:	eb 0e                	jmp    801007ef <consputc+0x5a>
  } else {
    uartputc(c);
801007e1:	83 ec 0c             	sub    $0xc,%esp
801007e4:	ff 75 08             	pushl  0x8(%ebp)
801007e7:	e8 36 60 00 00       	call   80106822 <uartputc>
801007ec:	83 c4 10             	add    $0x10,%esp
  }
  graphic_putc(c);
801007ef:	83 ec 0c             	sub    $0xc,%esp
801007f2:	ff 75 08             	pushl  0x8(%ebp)
801007f5:	e8 63 fe ff ff       	call   8010065d <graphic_putc>
801007fa:	83 c4 10             	add    $0x10,%esp
}
801007fd:	90                   	nop
801007fe:	c9                   	leave  
801007ff:	c3                   	ret    

80100800 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
80100800:	f3 0f 1e fb          	endbr32 
80100804:	55                   	push   %ebp
80100805:	89 e5                	mov    %esp,%ebp
80100807:	83 ec 18             	sub    $0x18,%esp
  int c, doprocdump = 0;
8010080a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&cons.lock);
80100811:	83 ec 0c             	sub    $0xc,%esp
80100814:	68 20 d0 18 80       	push   $0x8018d020
80100819:	e8 2a 42 00 00       	call   80104a48 <acquire>
8010081e:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
80100821:	e9 52 01 00 00       	jmp    80100978 <consoleintr+0x178>
    switch(c){
80100826:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
8010082a:	0f 84 81 00 00 00    	je     801008b1 <consoleintr+0xb1>
80100830:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
80100834:	0f 8f ac 00 00 00    	jg     801008e6 <consoleintr+0xe6>
8010083a:	83 7d f0 15          	cmpl   $0x15,-0x10(%ebp)
8010083e:	74 43                	je     80100883 <consoleintr+0x83>
80100840:	83 7d f0 15          	cmpl   $0x15,-0x10(%ebp)
80100844:	0f 8f 9c 00 00 00    	jg     801008e6 <consoleintr+0xe6>
8010084a:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
8010084e:	74 61                	je     801008b1 <consoleintr+0xb1>
80100850:	83 7d f0 10          	cmpl   $0x10,-0x10(%ebp)
80100854:	0f 85 8c 00 00 00    	jne    801008e6 <consoleintr+0xe6>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
8010085a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
80100861:	e9 12 01 00 00       	jmp    80100978 <consoleintr+0x178>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100866:	a1 48 2d 19 80       	mov    0x80192d48,%eax
8010086b:	83 e8 01             	sub    $0x1,%eax
8010086e:	a3 48 2d 19 80       	mov    %eax,0x80192d48
        consputc(BACKSPACE);
80100873:	83 ec 0c             	sub    $0xc,%esp
80100876:	68 00 01 00 00       	push   $0x100
8010087b:	e8 15 ff ff ff       	call   80100795 <consputc>
80100880:	83 c4 10             	add    $0x10,%esp
      while(input.e != input.w &&
80100883:	8b 15 48 2d 19 80    	mov    0x80192d48,%edx
80100889:	a1 44 2d 19 80       	mov    0x80192d44,%eax
8010088e:	39 c2                	cmp    %eax,%edx
80100890:	0f 84 e2 00 00 00    	je     80100978 <consoleintr+0x178>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100896:	a1 48 2d 19 80       	mov    0x80192d48,%eax
8010089b:	83 e8 01             	sub    $0x1,%eax
8010089e:	83 e0 7f             	and    $0x7f,%eax
801008a1:	0f b6 80 c0 2c 19 80 	movzbl -0x7fe6d340(%eax),%eax
      while(input.e != input.w &&
801008a8:	3c 0a                	cmp    $0xa,%al
801008aa:	75 ba                	jne    80100866 <consoleintr+0x66>
      }
      break;
801008ac:	e9 c7 00 00 00       	jmp    80100978 <consoleintr+0x178>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801008b1:	8b 15 48 2d 19 80    	mov    0x80192d48,%edx
801008b7:	a1 44 2d 19 80       	mov    0x80192d44,%eax
801008bc:	39 c2                	cmp    %eax,%edx
801008be:	0f 84 b4 00 00 00    	je     80100978 <consoleintr+0x178>
        input.e--;
801008c4:	a1 48 2d 19 80       	mov    0x80192d48,%eax
801008c9:	83 e8 01             	sub    $0x1,%eax
801008cc:	a3 48 2d 19 80       	mov    %eax,0x80192d48
        consputc(BACKSPACE);
801008d1:	83 ec 0c             	sub    $0xc,%esp
801008d4:	68 00 01 00 00       	push   $0x100
801008d9:	e8 b7 fe ff ff       	call   80100795 <consputc>
801008de:	83 c4 10             	add    $0x10,%esp
      }
      break;
801008e1:	e9 92 00 00 00       	jmp    80100978 <consoleintr+0x178>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801008ea:	0f 84 87 00 00 00    	je     80100977 <consoleintr+0x177>
801008f0:	8b 15 48 2d 19 80    	mov    0x80192d48,%edx
801008f6:	a1 40 2d 19 80       	mov    0x80192d40,%eax
801008fb:	29 c2                	sub    %eax,%edx
801008fd:	89 d0                	mov    %edx,%eax
801008ff:	83 f8 7f             	cmp    $0x7f,%eax
80100902:	77 73                	ja     80100977 <consoleintr+0x177>
        c = (c == '\r') ? '\n' : c;
80100904:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80100908:	74 05                	je     8010090f <consoleintr+0x10f>
8010090a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010090d:	eb 05                	jmp    80100914 <consoleintr+0x114>
8010090f:	b8 0a 00 00 00       	mov    $0xa,%eax
80100914:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
80100917:	a1 48 2d 19 80       	mov    0x80192d48,%eax
8010091c:	8d 50 01             	lea    0x1(%eax),%edx
8010091f:	89 15 48 2d 19 80    	mov    %edx,0x80192d48
80100925:	83 e0 7f             	and    $0x7f,%eax
80100928:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010092b:	88 90 c0 2c 19 80    	mov    %dl,-0x7fe6d340(%eax)
        consputc(c);
80100931:	83 ec 0c             	sub    $0xc,%esp
80100934:	ff 75 f0             	pushl  -0x10(%ebp)
80100937:	e8 59 fe ff ff       	call   80100795 <consputc>
8010093c:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010093f:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100943:	74 18                	je     8010095d <consoleintr+0x15d>
80100945:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100949:	74 12                	je     8010095d <consoleintr+0x15d>
8010094b:	a1 48 2d 19 80       	mov    0x80192d48,%eax
80100950:	8b 15 40 2d 19 80    	mov    0x80192d40,%edx
80100956:	83 ea 80             	sub    $0xffffff80,%edx
80100959:	39 d0                	cmp    %edx,%eax
8010095b:	75 1a                	jne    80100977 <consoleintr+0x177>
          input.w = input.e;
8010095d:	a1 48 2d 19 80       	mov    0x80192d48,%eax
80100962:	a3 44 2d 19 80       	mov    %eax,0x80192d44
          wakeup(&input.r);
80100967:	83 ec 0c             	sub    $0xc,%esp
8010096a:	68 40 2d 19 80       	push   $0x80192d40
8010096f:	e8 fd 3b 00 00       	call   80104571 <wakeup>
80100974:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
80100977:	90                   	nop
  while((c = getc()) >= 0){
80100978:	8b 45 08             	mov    0x8(%ebp),%eax
8010097b:	ff d0                	call   *%eax
8010097d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100980:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100984:	0f 89 9c fe ff ff    	jns    80100826 <consoleintr+0x26>
    }
  }
  release(&cons.lock);
8010098a:	83 ec 0c             	sub    $0xc,%esp
8010098d:	68 20 d0 18 80       	push   $0x8018d020
80100992:	e8 23 41 00 00       	call   80104aba <release>
80100997:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
8010099a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010099e:	74 05                	je     801009a5 <consoleintr+0x1a5>
    procdump();  // now call procdump() wo. cons.lock held
801009a0:	e8 8f 3c 00 00       	call   80104634 <procdump>
  }
}
801009a5:	90                   	nop
801009a6:	c9                   	leave  
801009a7:	c3                   	ret    

801009a8 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
801009a8:	f3 0f 1e fb          	endbr32 
801009ac:	55                   	push   %ebp
801009ad:	89 e5                	mov    %esp,%ebp
801009af:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
801009b2:	83 ec 0c             	sub    $0xc,%esp
801009b5:	ff 75 08             	pushl  0x8(%ebp)
801009b8:	e8 d6 11 00 00       	call   80101b93 <iunlock>
801009bd:	83 c4 10             	add    $0x10,%esp
  target = n;
801009c0:	8b 45 10             	mov    0x10(%ebp),%eax
801009c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
801009c6:	83 ec 0c             	sub    $0xc,%esp
801009c9:	68 20 d0 18 80       	push   $0x8018d020
801009ce:	e8 75 40 00 00       	call   80104a48 <acquire>
801009d3:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
801009d6:	e9 ab 00 00 00       	jmp    80100a86 <consoleread+0xde>
    while(input.r == input.w){
      if(myproc()->killed){
801009db:	e8 c9 31 00 00       	call   80103ba9 <myproc>
801009e0:	8b 40 24             	mov    0x24(%eax),%eax
801009e3:	85 c0                	test   %eax,%eax
801009e5:	74 28                	je     80100a0f <consoleread+0x67>
        release(&cons.lock);
801009e7:	83 ec 0c             	sub    $0xc,%esp
801009ea:	68 20 d0 18 80       	push   $0x8018d020
801009ef:	e8 c6 40 00 00       	call   80104aba <release>
801009f4:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
801009f7:	83 ec 0c             	sub    $0xc,%esp
801009fa:	ff 75 08             	pushl  0x8(%ebp)
801009fd:	e8 7a 10 00 00       	call   80101a7c <ilock>
80100a02:	83 c4 10             	add    $0x10,%esp
        return -1;
80100a05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a0a:	e9 ab 00 00 00       	jmp    80100aba <consoleread+0x112>
      }
      sleep(&input.r, &cons.lock);
80100a0f:	83 ec 08             	sub    $0x8,%esp
80100a12:	68 20 d0 18 80       	push   $0x8018d020
80100a17:	68 40 2d 19 80       	push   $0x80192d40
80100a1c:	e8 61 3a 00 00       	call   80104482 <sleep>
80100a21:	83 c4 10             	add    $0x10,%esp
    while(input.r == input.w){
80100a24:	8b 15 40 2d 19 80    	mov    0x80192d40,%edx
80100a2a:	a1 44 2d 19 80       	mov    0x80192d44,%eax
80100a2f:	39 c2                	cmp    %eax,%edx
80100a31:	74 a8                	je     801009db <consoleread+0x33>
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100a33:	a1 40 2d 19 80       	mov    0x80192d40,%eax
80100a38:	8d 50 01             	lea    0x1(%eax),%edx
80100a3b:	89 15 40 2d 19 80    	mov    %edx,0x80192d40
80100a41:	83 e0 7f             	and    $0x7f,%eax
80100a44:	0f b6 80 c0 2c 19 80 	movzbl -0x7fe6d340(%eax),%eax
80100a4b:	0f be c0             	movsbl %al,%eax
80100a4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a51:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a55:	75 17                	jne    80100a6e <consoleread+0xc6>
      if(n < target){
80100a57:	8b 45 10             	mov    0x10(%ebp),%eax
80100a5a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80100a5d:	76 2f                	jbe    80100a8e <consoleread+0xe6>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a5f:	a1 40 2d 19 80       	mov    0x80192d40,%eax
80100a64:	83 e8 01             	sub    $0x1,%eax
80100a67:	a3 40 2d 19 80       	mov    %eax,0x80192d40
      }
      break;
80100a6c:	eb 20                	jmp    80100a8e <consoleread+0xe6>
    }
    *dst++ = c;
80100a6e:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a71:	8d 50 01             	lea    0x1(%eax),%edx
80100a74:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a77:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a7a:	88 10                	mov    %dl,(%eax)
    --n;
80100a7c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a80:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a84:	74 0b                	je     80100a91 <consoleread+0xe9>
  while(n > 0){
80100a86:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a8a:	7f 98                	jg     80100a24 <consoleread+0x7c>
80100a8c:	eb 04                	jmp    80100a92 <consoleread+0xea>
      break;
80100a8e:	90                   	nop
80100a8f:	eb 01                	jmp    80100a92 <consoleread+0xea>
      break;
80100a91:	90                   	nop
  }
  release(&cons.lock);
80100a92:	83 ec 0c             	sub    $0xc,%esp
80100a95:	68 20 d0 18 80       	push   $0x8018d020
80100a9a:	e8 1b 40 00 00       	call   80104aba <release>
80100a9f:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100aa2:	83 ec 0c             	sub    $0xc,%esp
80100aa5:	ff 75 08             	pushl  0x8(%ebp)
80100aa8:	e8 cf 0f 00 00       	call   80101a7c <ilock>
80100aad:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100ab0:	8b 45 10             	mov    0x10(%ebp),%eax
80100ab3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100ab6:	29 c2                	sub    %eax,%edx
80100ab8:	89 d0                	mov    %edx,%eax
}
80100aba:	c9                   	leave  
80100abb:	c3                   	ret    

80100abc <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100abc:	f3 0f 1e fb          	endbr32 
80100ac0:	55                   	push   %ebp
80100ac1:	89 e5                	mov    %esp,%ebp
80100ac3:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100ac6:	83 ec 0c             	sub    $0xc,%esp
80100ac9:	ff 75 08             	pushl  0x8(%ebp)
80100acc:	e8 c2 10 00 00       	call   80101b93 <iunlock>
80100ad1:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100ad4:	83 ec 0c             	sub    $0xc,%esp
80100ad7:	68 20 d0 18 80       	push   $0x8018d020
80100adc:	e8 67 3f 00 00       	call   80104a48 <acquire>
80100ae1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100ae4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100aeb:	eb 21                	jmp    80100b0e <consolewrite+0x52>
    consputc(buf[i] & 0xff);
80100aed:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100af0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100af3:	01 d0                	add    %edx,%eax
80100af5:	0f b6 00             	movzbl (%eax),%eax
80100af8:	0f be c0             	movsbl %al,%eax
80100afb:	0f b6 c0             	movzbl %al,%eax
80100afe:	83 ec 0c             	sub    $0xc,%esp
80100b01:	50                   	push   %eax
80100b02:	e8 8e fc ff ff       	call   80100795 <consputc>
80100b07:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100b0a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b11:	3b 45 10             	cmp    0x10(%ebp),%eax
80100b14:	7c d7                	jl     80100aed <consolewrite+0x31>
  release(&cons.lock);
80100b16:	83 ec 0c             	sub    $0xc,%esp
80100b19:	68 20 d0 18 80       	push   $0x8018d020
80100b1e:	e8 97 3f 00 00       	call   80104aba <release>
80100b23:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b26:	83 ec 0c             	sub    $0xc,%esp
80100b29:	ff 75 08             	pushl  0x8(%ebp)
80100b2c:	e8 4b 0f 00 00       	call   80101a7c <ilock>
80100b31:	83 c4 10             	add    $0x10,%esp

  return n;
80100b34:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100b37:	c9                   	leave  
80100b38:	c3                   	ret    

80100b39 <consoleinit>:

void
consoleinit(void)
{
80100b39:	f3 0f 1e fb          	endbr32 
80100b3d:	55                   	push   %ebp
80100b3e:	89 e5                	mov    %esp,%ebp
80100b40:	83 ec 18             	sub    $0x18,%esp
  panicked = 0;
80100b43:	c7 05 00 d0 18 80 00 	movl   $0x0,0x8018d000
80100b4a:	00 00 00 
  initlock(&cons.lock, "console");
80100b4d:	83 ec 08             	sub    $0x8,%esp
80100b50:	68 f7 a6 10 80       	push   $0x8010a6f7
80100b55:	68 20 d0 18 80       	push   $0x8018d020
80100b5a:	e8 c3 3e 00 00       	call   80104a22 <initlock>
80100b5f:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b62:	c7 05 0c 37 19 80 bc 	movl   $0x80100abc,0x8019370c
80100b69:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b6c:	c7 05 08 37 19 80 a8 	movl   $0x801009a8,0x80193708
80100b73:	09 10 80 
  
  char *p;
  for(p="Starting XV6_UEFI...\n"; *p; p++)
80100b76:	c7 45 f4 ff a6 10 80 	movl   $0x8010a6ff,-0xc(%ebp)
80100b7d:	eb 19                	jmp    80100b98 <consoleinit+0x5f>
    graphic_putc(*p);
80100b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b82:	0f b6 00             	movzbl (%eax),%eax
80100b85:	0f be c0             	movsbl %al,%eax
80100b88:	83 ec 0c             	sub    $0xc,%esp
80100b8b:	50                   	push   %eax
80100b8c:	e8 cc fa ff ff       	call   8010065d <graphic_putc>
80100b91:	83 c4 10             	add    $0x10,%esp
  for(p="Starting XV6_UEFI...\n"; *p; p++)
80100b94:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b9b:	0f b6 00             	movzbl (%eax),%eax
80100b9e:	84 c0                	test   %al,%al
80100ba0:	75 dd                	jne    80100b7f <consoleinit+0x46>
  
  cons.locking = 1;
80100ba2:	c7 05 54 d0 18 80 01 	movl   $0x1,0x8018d054
80100ba9:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100bac:	83 ec 08             	sub    $0x8,%esp
80100baf:	6a 00                	push   $0x0
80100bb1:	6a 01                	push   $0x1
80100bb3:	e8 54 1b 00 00       	call   8010270c <ioapicenable>
80100bb8:	83 c4 10             	add    $0x10,%esp
}
80100bbb:	90                   	nop
80100bbc:	c9                   	leave  
80100bbd:	c3                   	ret    

80100bbe <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100bbe:	f3 0f 1e fb          	endbr32 
80100bc2:	55                   	push   %ebp
80100bc3:	89 e5                	mov    %esp,%ebp
80100bc5:	81 ec 18 01 00 00    	sub    $0x118,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100bcb:	e8 d9 2f 00 00       	call   80103ba9 <myproc>
80100bd0:	89 45 d0             	mov    %eax,-0x30(%ebp)

  begin_op();
80100bd3:	e8 99 25 00 00       	call   80103171 <begin_op>

  if((ip = namei(path)) == 0){
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	ff 75 08             	pushl  0x8(%ebp)
80100bde:	e8 04 1a 00 00       	call   801025e7 <namei>
80100be3:	83 c4 10             	add    $0x10,%esp
80100be6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100be9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100bed:	75 1f                	jne    80100c0e <exec+0x50>
    end_op();
80100bef:	e8 0d 26 00 00       	call   80103201 <end_op>
    cprintf("exec: fail\n");
80100bf4:	83 ec 0c             	sub    $0xc,%esp
80100bf7:	68 15 a7 10 80       	push   $0x8010a715
80100bfc:	e8 0b f8 ff ff       	call   8010040c <cprintf>
80100c01:	83 c4 10             	add    $0x10,%esp
    return -1;
80100c04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c09:	e9 f1 03 00 00       	jmp    80100fff <exec+0x441>
  }
  ilock(ip);
80100c0e:	83 ec 0c             	sub    $0xc,%esp
80100c11:	ff 75 d8             	pushl  -0x28(%ebp)
80100c14:	e8 63 0e 00 00       	call   80101a7c <ilock>
80100c19:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100c1c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100c23:	6a 34                	push   $0x34
80100c25:	6a 00                	push   $0x0
80100c27:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
80100c2d:	50                   	push   %eax
80100c2e:	ff 75 d8             	pushl  -0x28(%ebp)
80100c31:	e8 4e 13 00 00       	call   80101f84 <readi>
80100c36:	83 c4 10             	add    $0x10,%esp
80100c39:	83 f8 34             	cmp    $0x34,%eax
80100c3c:	0f 85 66 03 00 00    	jne    80100fa8 <exec+0x3ea>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100c42:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
80100c48:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100c4d:	0f 85 58 03 00 00    	jne    80100fab <exec+0x3ed>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100c53:	e8 de 6b 00 00       	call   80107836 <setupkvm>
80100c58:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100c5b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100c5f:	0f 84 49 03 00 00    	je     80100fae <exec+0x3f0>
    goto bad;

  // Load program into memory.
  sz = 0;
80100c65:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c6c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100c73:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
80100c79:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c7c:	e9 de 00 00 00       	jmp    80100d5f <exec+0x1a1>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c81:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c84:	6a 20                	push   $0x20
80100c86:	50                   	push   %eax
80100c87:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80100c8d:	50                   	push   %eax
80100c8e:	ff 75 d8             	pushl  -0x28(%ebp)
80100c91:	e8 ee 12 00 00       	call   80101f84 <readi>
80100c96:	83 c4 10             	add    $0x10,%esp
80100c99:	83 f8 20             	cmp    $0x20,%eax
80100c9c:	0f 85 0f 03 00 00    	jne    80100fb1 <exec+0x3f3>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100ca2:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100ca8:	83 f8 01             	cmp    $0x1,%eax
80100cab:	0f 85 a0 00 00 00    	jne    80100d51 <exec+0x193>
      continue;
    if(ph.memsz < ph.filesz)
80100cb1:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100cb7:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100cbd:	39 c2                	cmp    %eax,%edx
80100cbf:	0f 82 ef 02 00 00    	jb     80100fb4 <exec+0x3f6>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100cc5:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100ccb:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100cd1:	01 c2                	add    %eax,%edx
80100cd3:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100cd9:	39 c2                	cmp    %eax,%edx
80100cdb:	0f 82 d6 02 00 00    	jb     80100fb7 <exec+0x3f9>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100ce1:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100ce7:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100ced:	01 d0                	add    %edx,%eax
80100cef:	83 ec 04             	sub    $0x4,%esp
80100cf2:	50                   	push   %eax
80100cf3:	ff 75 e0             	pushl  -0x20(%ebp)
80100cf6:	ff 75 d4             	pushl  -0x2c(%ebp)
80100cf9:	e8 4a 6f 00 00       	call   80107c48 <allocuvm>
80100cfe:	83 c4 10             	add    $0x10,%esp
80100d01:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d04:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d08:	0f 84 ac 02 00 00    	je     80100fba <exec+0x3fc>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100d0e:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d14:	25 ff 0f 00 00       	and    $0xfff,%eax
80100d19:	85 c0                	test   %eax,%eax
80100d1b:	0f 85 9c 02 00 00    	jne    80100fbd <exec+0x3ff>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100d21:	8b 95 f8 fe ff ff    	mov    -0x108(%ebp),%edx
80100d27:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100d2d:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100d33:	83 ec 0c             	sub    $0xc,%esp
80100d36:	52                   	push   %edx
80100d37:	50                   	push   %eax
80100d38:	ff 75 d8             	pushl  -0x28(%ebp)
80100d3b:	51                   	push   %ecx
80100d3c:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d3f:	e8 33 6e 00 00       	call   80107b77 <loaduvm>
80100d44:	83 c4 20             	add    $0x20,%esp
80100d47:	85 c0                	test   %eax,%eax
80100d49:	0f 88 71 02 00 00    	js     80100fc0 <exec+0x402>
80100d4f:	eb 01                	jmp    80100d52 <exec+0x194>
      continue;
80100d51:	90                   	nop
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d52:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100d56:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d59:	83 c0 20             	add    $0x20,%eax
80100d5c:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d5f:	0f b7 85 34 ff ff ff 	movzwl -0xcc(%ebp),%eax
80100d66:	0f b7 c0             	movzwl %ax,%eax
80100d69:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80100d6c:	0f 8c 0f ff ff ff    	jl     80100c81 <exec+0xc3>
      goto bad;
  }
  iunlockput(ip);
80100d72:	83 ec 0c             	sub    $0xc,%esp
80100d75:	ff 75 d8             	pushl  -0x28(%ebp)
80100d78:	e8 3c 0f 00 00       	call   80101cb9 <iunlockput>
80100d7d:	83 c4 10             	add    $0x10,%esp
  end_op();
80100d80:	e8 7c 24 00 00       	call   80103201 <end_op>
  ip = 0;
80100d85:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  
  sz = PGROUNDUP(sz);
80100d8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d8f:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d94:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100d99:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d9f:	05 00 20 00 00       	add    $0x2000,%eax
80100da4:	83 ec 04             	sub    $0x4,%esp
80100da7:	50                   	push   %eax
80100da8:	ff 75 e0             	pushl  -0x20(%ebp)
80100dab:	ff 75 d4             	pushl  -0x2c(%ebp)
80100dae:	e8 95 6e 00 00       	call   80107c48 <allocuvm>
80100db3:	83 c4 10             	add    $0x10,%esp
80100db6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100db9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100dbd:	0f 84 00 02 00 00    	je     80100fc3 <exec+0x405>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100dc3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100dc6:	2d 00 20 00 00       	sub    $0x2000,%eax
80100dcb:	83 ec 08             	sub    $0x8,%esp
80100dce:	50                   	push   %eax
80100dcf:	ff 75 d4             	pushl  -0x2c(%ebp)
80100dd2:	e8 df 70 00 00       	call   80107eb6 <clearpteu>
80100dd7:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100dda:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ddd:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100de0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100de7:	e9 96 00 00 00       	jmp    80100e82 <exec+0x2c4>
    if(argc >= MAXARG)
80100dec:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100df0:	0f 87 d0 01 00 00    	ja     80100fc6 <exec+0x408>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100df6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100df9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e00:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e03:	01 d0                	add    %edx,%eax
80100e05:	8b 00                	mov    (%eax),%eax
80100e07:	83 ec 0c             	sub    $0xc,%esp
80100e0a:	50                   	push   %eax
80100e0b:	e8 30 41 00 00       	call   80104f40 <strlen>
80100e10:	83 c4 10             	add    $0x10,%esp
80100e13:	89 c2                	mov    %eax,%edx
80100e15:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e18:	29 d0                	sub    %edx,%eax
80100e1a:	83 e8 01             	sub    $0x1,%eax
80100e1d:	83 e0 fc             	and    $0xfffffffc,%eax
80100e20:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e26:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e2d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e30:	01 d0                	add    %edx,%eax
80100e32:	8b 00                	mov    (%eax),%eax
80100e34:	83 ec 0c             	sub    $0xc,%esp
80100e37:	50                   	push   %eax
80100e38:	e8 03 41 00 00       	call   80104f40 <strlen>
80100e3d:	83 c4 10             	add    $0x10,%esp
80100e40:	83 c0 01             	add    $0x1,%eax
80100e43:	89 c1                	mov    %eax,%ecx
80100e45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e48:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e52:	01 d0                	add    %edx,%eax
80100e54:	8b 00                	mov    (%eax),%eax
80100e56:	51                   	push   %ecx
80100e57:	50                   	push   %eax
80100e58:	ff 75 dc             	pushl  -0x24(%ebp)
80100e5b:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e5e:	e8 28 72 00 00       	call   8010808b <copyout>
80100e63:	83 c4 10             	add    $0x10,%esp
80100e66:	85 c0                	test   %eax,%eax
80100e68:	0f 88 5b 01 00 00    	js     80100fc9 <exec+0x40b>
      goto bad;
    ustack[3+argc] = sp;
80100e6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e71:	8d 50 03             	lea    0x3(%eax),%edx
80100e74:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e77:	89 84 95 3c ff ff ff 	mov    %eax,-0xc4(%ebp,%edx,4)
  for(argc = 0; argv[argc]; argc++) {
80100e7e:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100e82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e85:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e8f:	01 d0                	add    %edx,%eax
80100e91:	8b 00                	mov    (%eax),%eax
80100e93:	85 c0                	test   %eax,%eax
80100e95:	0f 85 51 ff ff ff    	jne    80100dec <exec+0x22e>
  }
  ustack[3+argc] = 0;
80100e9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e9e:	83 c0 03             	add    $0x3,%eax
80100ea1:	c7 84 85 3c ff ff ff 	movl   $0x0,-0xc4(%ebp,%eax,4)
80100ea8:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100eac:	c7 85 3c ff ff ff ff 	movl   $0xffffffff,-0xc4(%ebp)
80100eb3:	ff ff ff 
  ustack[1] = argc;
80100eb6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100eb9:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ebf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ec2:	83 c0 01             	add    $0x1,%eax
80100ec5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100ecc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ecf:	29 d0                	sub    %edx,%eax
80100ed1:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

  sp -= (3+argc+1) * 4;
80100ed7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100eda:	83 c0 04             	add    $0x4,%eax
80100edd:	c1 e0 02             	shl    $0x2,%eax
80100ee0:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ee3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ee6:	83 c0 04             	add    $0x4,%eax
80100ee9:	c1 e0 02             	shl    $0x2,%eax
80100eec:	50                   	push   %eax
80100eed:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
80100ef3:	50                   	push   %eax
80100ef4:	ff 75 dc             	pushl  -0x24(%ebp)
80100ef7:	ff 75 d4             	pushl  -0x2c(%ebp)
80100efa:	e8 8c 71 00 00       	call   8010808b <copyout>
80100eff:	83 c4 10             	add    $0x10,%esp
80100f02:	85 c0                	test   %eax,%eax
80100f04:	0f 88 c2 00 00 00    	js     80100fcc <exec+0x40e>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f0a:	8b 45 08             	mov    0x8(%ebp),%eax
80100f0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f13:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100f16:	eb 17                	jmp    80100f2f <exec+0x371>
    if(*s == '/')
80100f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f1b:	0f b6 00             	movzbl (%eax),%eax
80100f1e:	3c 2f                	cmp    $0x2f,%al
80100f20:	75 09                	jne    80100f2b <exec+0x36d>
      last = s+1;
80100f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f25:	83 c0 01             	add    $0x1,%eax
80100f28:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(last=s=path; *s; s++)
80100f2b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f32:	0f b6 00             	movzbl (%eax),%eax
80100f35:	84 c0                	test   %al,%al
80100f37:	75 df                	jne    80100f18 <exec+0x35a>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100f39:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f3c:	83 c0 6c             	add    $0x6c,%eax
80100f3f:	83 ec 04             	sub    $0x4,%esp
80100f42:	6a 10                	push   $0x10
80100f44:	ff 75 f0             	pushl  -0x10(%ebp)
80100f47:	50                   	push   %eax
80100f48:	e8 a5 3f 00 00       	call   80104ef2 <safestrcpy>
80100f4d:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100f50:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f53:	8b 40 04             	mov    0x4(%eax),%eax
80100f56:	89 45 cc             	mov    %eax,-0x34(%ebp)
  curproc->pgdir = pgdir;
80100f59:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f5c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100f5f:	89 50 04             	mov    %edx,0x4(%eax)
  curproc->sz = sz;
80100f62:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f65:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100f68:	89 10                	mov    %edx,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100f6a:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f6d:	8b 40 18             	mov    0x18(%eax),%eax
80100f70:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
80100f76:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100f79:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f7c:	8b 40 18             	mov    0x18(%eax),%eax
80100f7f:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f82:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(curproc);
80100f85:	83 ec 0c             	sub    $0xc,%esp
80100f88:	ff 75 d0             	pushl  -0x30(%ebp)
80100f8b:	e8 d0 69 00 00       	call   80107960 <switchuvm>
80100f90:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f93:	83 ec 0c             	sub    $0xc,%esp
80100f96:	ff 75 cc             	pushl  -0x34(%ebp)
80100f99:	e8 7b 6e 00 00       	call   80107e19 <freevm>
80100f9e:	83 c4 10             	add    $0x10,%esp
  return 0;
80100fa1:	b8 00 00 00 00       	mov    $0x0,%eax
80100fa6:	eb 57                	jmp    80100fff <exec+0x441>
    goto bad;
80100fa8:	90                   	nop
80100fa9:	eb 22                	jmp    80100fcd <exec+0x40f>
    goto bad;
80100fab:	90                   	nop
80100fac:	eb 1f                	jmp    80100fcd <exec+0x40f>
    goto bad;
80100fae:	90                   	nop
80100faf:	eb 1c                	jmp    80100fcd <exec+0x40f>
      goto bad;
80100fb1:	90                   	nop
80100fb2:	eb 19                	jmp    80100fcd <exec+0x40f>
      goto bad;
80100fb4:	90                   	nop
80100fb5:	eb 16                	jmp    80100fcd <exec+0x40f>
      goto bad;
80100fb7:	90                   	nop
80100fb8:	eb 13                	jmp    80100fcd <exec+0x40f>
      goto bad;
80100fba:	90                   	nop
80100fbb:	eb 10                	jmp    80100fcd <exec+0x40f>
      goto bad;
80100fbd:	90                   	nop
80100fbe:	eb 0d                	jmp    80100fcd <exec+0x40f>
      goto bad;
80100fc0:	90                   	nop
80100fc1:	eb 0a                	jmp    80100fcd <exec+0x40f>
    goto bad;
80100fc3:	90                   	nop
80100fc4:	eb 07                	jmp    80100fcd <exec+0x40f>
      goto bad;
80100fc6:	90                   	nop
80100fc7:	eb 04                	jmp    80100fcd <exec+0x40f>
      goto bad;
80100fc9:	90                   	nop
80100fca:	eb 01                	jmp    80100fcd <exec+0x40f>
    goto bad;
80100fcc:	90                   	nop

 bad:
  if(pgdir)
80100fcd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100fd1:	74 0e                	je     80100fe1 <exec+0x423>
    freevm(pgdir);
80100fd3:	83 ec 0c             	sub    $0xc,%esp
80100fd6:	ff 75 d4             	pushl  -0x2c(%ebp)
80100fd9:	e8 3b 6e 00 00       	call   80107e19 <freevm>
80100fde:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100fe1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100fe5:	74 13                	je     80100ffa <exec+0x43c>
    iunlockput(ip);
80100fe7:	83 ec 0c             	sub    $0xc,%esp
80100fea:	ff 75 d8             	pushl  -0x28(%ebp)
80100fed:	e8 c7 0c 00 00       	call   80101cb9 <iunlockput>
80100ff2:	83 c4 10             	add    $0x10,%esp
    end_op();
80100ff5:	e8 07 22 00 00       	call   80103201 <end_op>
  }
  return -1;
80100ffa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fff:	c9                   	leave  
80101000:	c3                   	ret    

80101001 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101001:	f3 0f 1e fb          	endbr32 
80101005:	55                   	push   %ebp
80101006:	89 e5                	mov    %esp,%ebp
80101008:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
8010100b:	83 ec 08             	sub    $0x8,%esp
8010100e:	68 21 a7 10 80       	push   $0x8010a721
80101013:	68 60 2d 19 80       	push   $0x80192d60
80101018:	e8 05 3a 00 00       	call   80104a22 <initlock>
8010101d:	83 c4 10             	add    $0x10,%esp
}
80101020:	90                   	nop
80101021:	c9                   	leave  
80101022:	c3                   	ret    

80101023 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101023:	f3 0f 1e fb          	endbr32 
80101027:	55                   	push   %ebp
80101028:	89 e5                	mov    %esp,%ebp
8010102a:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
8010102d:	83 ec 0c             	sub    $0xc,%esp
80101030:	68 60 2d 19 80       	push   $0x80192d60
80101035:	e8 0e 3a 00 00       	call   80104a48 <acquire>
8010103a:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010103d:	c7 45 f4 94 2d 19 80 	movl   $0x80192d94,-0xc(%ebp)
80101044:	eb 2d                	jmp    80101073 <filealloc+0x50>
    if(f->ref == 0){
80101046:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101049:	8b 40 04             	mov    0x4(%eax),%eax
8010104c:	85 c0                	test   %eax,%eax
8010104e:	75 1f                	jne    8010106f <filealloc+0x4c>
      f->ref = 1;
80101050:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101053:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
8010105a:	83 ec 0c             	sub    $0xc,%esp
8010105d:	68 60 2d 19 80       	push   $0x80192d60
80101062:	e8 53 3a 00 00       	call   80104aba <release>
80101067:	83 c4 10             	add    $0x10,%esp
      return f;
8010106a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010106d:	eb 23                	jmp    80101092 <filealloc+0x6f>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010106f:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80101073:	b8 f4 36 19 80       	mov    $0x801936f4,%eax
80101078:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010107b:	72 c9                	jb     80101046 <filealloc+0x23>
    }
  }
  release(&ftable.lock);
8010107d:	83 ec 0c             	sub    $0xc,%esp
80101080:	68 60 2d 19 80       	push   $0x80192d60
80101085:	e8 30 3a 00 00       	call   80104aba <release>
8010108a:	83 c4 10             	add    $0x10,%esp
  return 0;
8010108d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101092:	c9                   	leave  
80101093:	c3                   	ret    

80101094 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101094:	f3 0f 1e fb          	endbr32 
80101098:	55                   	push   %ebp
80101099:	89 e5                	mov    %esp,%ebp
8010109b:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
8010109e:	83 ec 0c             	sub    $0xc,%esp
801010a1:	68 60 2d 19 80       	push   $0x80192d60
801010a6:	e8 9d 39 00 00       	call   80104a48 <acquire>
801010ab:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010ae:	8b 45 08             	mov    0x8(%ebp),%eax
801010b1:	8b 40 04             	mov    0x4(%eax),%eax
801010b4:	85 c0                	test   %eax,%eax
801010b6:	7f 0d                	jg     801010c5 <filedup+0x31>
    panic("filedup");
801010b8:	83 ec 0c             	sub    $0xc,%esp
801010bb:	68 28 a7 10 80       	push   $0x8010a728
801010c0:	e8 00 f5 ff ff       	call   801005c5 <panic>
  f->ref++;
801010c5:	8b 45 08             	mov    0x8(%ebp),%eax
801010c8:	8b 40 04             	mov    0x4(%eax),%eax
801010cb:	8d 50 01             	lea    0x1(%eax),%edx
801010ce:	8b 45 08             	mov    0x8(%ebp),%eax
801010d1:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
801010d4:	83 ec 0c             	sub    $0xc,%esp
801010d7:	68 60 2d 19 80       	push   $0x80192d60
801010dc:	e8 d9 39 00 00       	call   80104aba <release>
801010e1:	83 c4 10             	add    $0x10,%esp
  return f;
801010e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
801010e7:	c9                   	leave  
801010e8:	c3                   	ret    

801010e9 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801010e9:	f3 0f 1e fb          	endbr32 
801010ed:	55                   	push   %ebp
801010ee:	89 e5                	mov    %esp,%ebp
801010f0:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
801010f3:	83 ec 0c             	sub    $0xc,%esp
801010f6:	68 60 2d 19 80       	push   $0x80192d60
801010fb:	e8 48 39 00 00       	call   80104a48 <acquire>
80101100:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101103:	8b 45 08             	mov    0x8(%ebp),%eax
80101106:	8b 40 04             	mov    0x4(%eax),%eax
80101109:	85 c0                	test   %eax,%eax
8010110b:	7f 0d                	jg     8010111a <fileclose+0x31>
    panic("fileclose");
8010110d:	83 ec 0c             	sub    $0xc,%esp
80101110:	68 30 a7 10 80       	push   $0x8010a730
80101115:	e8 ab f4 ff ff       	call   801005c5 <panic>
  if(--f->ref > 0){
8010111a:	8b 45 08             	mov    0x8(%ebp),%eax
8010111d:	8b 40 04             	mov    0x4(%eax),%eax
80101120:	8d 50 ff             	lea    -0x1(%eax),%edx
80101123:	8b 45 08             	mov    0x8(%ebp),%eax
80101126:	89 50 04             	mov    %edx,0x4(%eax)
80101129:	8b 45 08             	mov    0x8(%ebp),%eax
8010112c:	8b 40 04             	mov    0x4(%eax),%eax
8010112f:	85 c0                	test   %eax,%eax
80101131:	7e 15                	jle    80101148 <fileclose+0x5f>
    release(&ftable.lock);
80101133:	83 ec 0c             	sub    $0xc,%esp
80101136:	68 60 2d 19 80       	push   $0x80192d60
8010113b:	e8 7a 39 00 00       	call   80104aba <release>
80101140:	83 c4 10             	add    $0x10,%esp
80101143:	e9 8b 00 00 00       	jmp    801011d3 <fileclose+0xea>
    return;
  }
  ff = *f;
80101148:	8b 45 08             	mov    0x8(%ebp),%eax
8010114b:	8b 10                	mov    (%eax),%edx
8010114d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101150:	8b 50 04             	mov    0x4(%eax),%edx
80101153:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101156:	8b 50 08             	mov    0x8(%eax),%edx
80101159:	89 55 e8             	mov    %edx,-0x18(%ebp)
8010115c:	8b 50 0c             	mov    0xc(%eax),%edx
8010115f:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101162:	8b 50 10             	mov    0x10(%eax),%edx
80101165:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101168:	8b 40 14             	mov    0x14(%eax),%eax
8010116b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
8010116e:	8b 45 08             	mov    0x8(%ebp),%eax
80101171:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101178:	8b 45 08             	mov    0x8(%ebp),%eax
8010117b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101181:	83 ec 0c             	sub    $0xc,%esp
80101184:	68 60 2d 19 80       	push   $0x80192d60
80101189:	e8 2c 39 00 00       	call   80104aba <release>
8010118e:	83 c4 10             	add    $0x10,%esp

  if(ff.type == FD_PIPE)
80101191:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101194:	83 f8 01             	cmp    $0x1,%eax
80101197:	75 19                	jne    801011b2 <fileclose+0xc9>
    pipeclose(ff.pipe, ff.writable);
80101199:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
8010119d:	0f be d0             	movsbl %al,%edx
801011a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801011a3:	83 ec 08             	sub    $0x8,%esp
801011a6:	52                   	push   %edx
801011a7:	50                   	push   %eax
801011a8:	e8 73 26 00 00       	call   80103820 <pipeclose>
801011ad:	83 c4 10             	add    $0x10,%esp
801011b0:	eb 21                	jmp    801011d3 <fileclose+0xea>
  else if(ff.type == FD_INODE){
801011b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011b5:	83 f8 02             	cmp    $0x2,%eax
801011b8:	75 19                	jne    801011d3 <fileclose+0xea>
    begin_op();
801011ba:	e8 b2 1f 00 00       	call   80103171 <begin_op>
    iput(ff.ip);
801011bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801011c2:	83 ec 0c             	sub    $0xc,%esp
801011c5:	50                   	push   %eax
801011c6:	e8 1a 0a 00 00       	call   80101be5 <iput>
801011cb:	83 c4 10             	add    $0x10,%esp
    end_op();
801011ce:	e8 2e 20 00 00       	call   80103201 <end_op>
  }
}
801011d3:	c9                   	leave  
801011d4:	c3                   	ret    

801011d5 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801011d5:	f3 0f 1e fb          	endbr32 
801011d9:	55                   	push   %ebp
801011da:	89 e5                	mov    %esp,%ebp
801011dc:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
801011df:	8b 45 08             	mov    0x8(%ebp),%eax
801011e2:	8b 00                	mov    (%eax),%eax
801011e4:	83 f8 02             	cmp    $0x2,%eax
801011e7:	75 40                	jne    80101229 <filestat+0x54>
    ilock(f->ip);
801011e9:	8b 45 08             	mov    0x8(%ebp),%eax
801011ec:	8b 40 10             	mov    0x10(%eax),%eax
801011ef:	83 ec 0c             	sub    $0xc,%esp
801011f2:	50                   	push   %eax
801011f3:	e8 84 08 00 00       	call   80101a7c <ilock>
801011f8:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
801011fb:	8b 45 08             	mov    0x8(%ebp),%eax
801011fe:	8b 40 10             	mov    0x10(%eax),%eax
80101201:	83 ec 08             	sub    $0x8,%esp
80101204:	ff 75 0c             	pushl  0xc(%ebp)
80101207:	50                   	push   %eax
80101208:	e8 2d 0d 00 00       	call   80101f3a <stati>
8010120d:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
80101210:	8b 45 08             	mov    0x8(%ebp),%eax
80101213:	8b 40 10             	mov    0x10(%eax),%eax
80101216:	83 ec 0c             	sub    $0xc,%esp
80101219:	50                   	push   %eax
8010121a:	e8 74 09 00 00       	call   80101b93 <iunlock>
8010121f:	83 c4 10             	add    $0x10,%esp
    return 0;
80101222:	b8 00 00 00 00       	mov    $0x0,%eax
80101227:	eb 05                	jmp    8010122e <filestat+0x59>
  }
  return -1;
80101229:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010122e:	c9                   	leave  
8010122f:	c3                   	ret    

80101230 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101230:	f3 0f 1e fb          	endbr32 
80101234:	55                   	push   %ebp
80101235:	89 e5                	mov    %esp,%ebp
80101237:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
8010123a:	8b 45 08             	mov    0x8(%ebp),%eax
8010123d:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101241:	84 c0                	test   %al,%al
80101243:	75 0a                	jne    8010124f <fileread+0x1f>
    return -1;
80101245:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010124a:	e9 9b 00 00 00       	jmp    801012ea <fileread+0xba>
  if(f->type == FD_PIPE)
8010124f:	8b 45 08             	mov    0x8(%ebp),%eax
80101252:	8b 00                	mov    (%eax),%eax
80101254:	83 f8 01             	cmp    $0x1,%eax
80101257:	75 1a                	jne    80101273 <fileread+0x43>
    return piperead(f->pipe, addr, n);
80101259:	8b 45 08             	mov    0x8(%ebp),%eax
8010125c:	8b 40 0c             	mov    0xc(%eax),%eax
8010125f:	83 ec 04             	sub    $0x4,%esp
80101262:	ff 75 10             	pushl  0x10(%ebp)
80101265:	ff 75 0c             	pushl  0xc(%ebp)
80101268:	50                   	push   %eax
80101269:	e8 67 27 00 00       	call   801039d5 <piperead>
8010126e:	83 c4 10             	add    $0x10,%esp
80101271:	eb 77                	jmp    801012ea <fileread+0xba>
  if(f->type == FD_INODE){
80101273:	8b 45 08             	mov    0x8(%ebp),%eax
80101276:	8b 00                	mov    (%eax),%eax
80101278:	83 f8 02             	cmp    $0x2,%eax
8010127b:	75 60                	jne    801012dd <fileread+0xad>
    ilock(f->ip);
8010127d:	8b 45 08             	mov    0x8(%ebp),%eax
80101280:	8b 40 10             	mov    0x10(%eax),%eax
80101283:	83 ec 0c             	sub    $0xc,%esp
80101286:	50                   	push   %eax
80101287:	e8 f0 07 00 00       	call   80101a7c <ilock>
8010128c:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010128f:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101292:	8b 45 08             	mov    0x8(%ebp),%eax
80101295:	8b 50 14             	mov    0x14(%eax),%edx
80101298:	8b 45 08             	mov    0x8(%ebp),%eax
8010129b:	8b 40 10             	mov    0x10(%eax),%eax
8010129e:	51                   	push   %ecx
8010129f:	52                   	push   %edx
801012a0:	ff 75 0c             	pushl  0xc(%ebp)
801012a3:	50                   	push   %eax
801012a4:	e8 db 0c 00 00       	call   80101f84 <readi>
801012a9:	83 c4 10             	add    $0x10,%esp
801012ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
801012af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801012b3:	7e 11                	jle    801012c6 <fileread+0x96>
      f->off += r;
801012b5:	8b 45 08             	mov    0x8(%ebp),%eax
801012b8:	8b 50 14             	mov    0x14(%eax),%edx
801012bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012be:	01 c2                	add    %eax,%edx
801012c0:	8b 45 08             	mov    0x8(%ebp),%eax
801012c3:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801012c6:	8b 45 08             	mov    0x8(%ebp),%eax
801012c9:	8b 40 10             	mov    0x10(%eax),%eax
801012cc:	83 ec 0c             	sub    $0xc,%esp
801012cf:	50                   	push   %eax
801012d0:	e8 be 08 00 00       	call   80101b93 <iunlock>
801012d5:	83 c4 10             	add    $0x10,%esp
    return r;
801012d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012db:	eb 0d                	jmp    801012ea <fileread+0xba>
  }
  panic("fileread");
801012dd:	83 ec 0c             	sub    $0xc,%esp
801012e0:	68 3a a7 10 80       	push   $0x8010a73a
801012e5:	e8 db f2 ff ff       	call   801005c5 <panic>
}
801012ea:	c9                   	leave  
801012eb:	c3                   	ret    

801012ec <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801012ec:	f3 0f 1e fb          	endbr32 
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	53                   	push   %ebx
801012f4:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
801012f7:	8b 45 08             	mov    0x8(%ebp),%eax
801012fa:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801012fe:	84 c0                	test   %al,%al
80101300:	75 0a                	jne    8010130c <filewrite+0x20>
    return -1;
80101302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101307:	e9 1b 01 00 00       	jmp    80101427 <filewrite+0x13b>
  if(f->type == FD_PIPE)
8010130c:	8b 45 08             	mov    0x8(%ebp),%eax
8010130f:	8b 00                	mov    (%eax),%eax
80101311:	83 f8 01             	cmp    $0x1,%eax
80101314:	75 1d                	jne    80101333 <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
80101316:	8b 45 08             	mov    0x8(%ebp),%eax
80101319:	8b 40 0c             	mov    0xc(%eax),%eax
8010131c:	83 ec 04             	sub    $0x4,%esp
8010131f:	ff 75 10             	pushl  0x10(%ebp)
80101322:	ff 75 0c             	pushl  0xc(%ebp)
80101325:	50                   	push   %eax
80101326:	e8 a4 25 00 00       	call   801038cf <pipewrite>
8010132b:	83 c4 10             	add    $0x10,%esp
8010132e:	e9 f4 00 00 00       	jmp    80101427 <filewrite+0x13b>
  if(f->type == FD_INODE){
80101333:	8b 45 08             	mov    0x8(%ebp),%eax
80101336:	8b 00                	mov    (%eax),%eax
80101338:	83 f8 02             	cmp    $0x2,%eax
8010133b:	0f 85 d9 00 00 00    	jne    8010141a <filewrite+0x12e>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
80101341:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
80101348:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
8010134f:	e9 a3 00 00 00       	jmp    801013f7 <filewrite+0x10b>
      int n1 = n - i;
80101354:	8b 45 10             	mov    0x10(%ebp),%eax
80101357:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010135a:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
8010135d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101360:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101363:	7e 06                	jle    8010136b <filewrite+0x7f>
        n1 = max;
80101365:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101368:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
8010136b:	e8 01 1e 00 00       	call   80103171 <begin_op>
      ilock(f->ip);
80101370:	8b 45 08             	mov    0x8(%ebp),%eax
80101373:	8b 40 10             	mov    0x10(%eax),%eax
80101376:	83 ec 0c             	sub    $0xc,%esp
80101379:	50                   	push   %eax
8010137a:	e8 fd 06 00 00       	call   80101a7c <ilock>
8010137f:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101382:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101385:	8b 45 08             	mov    0x8(%ebp),%eax
80101388:	8b 50 14             	mov    0x14(%eax),%edx
8010138b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010138e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101391:	01 c3                	add    %eax,%ebx
80101393:	8b 45 08             	mov    0x8(%ebp),%eax
80101396:	8b 40 10             	mov    0x10(%eax),%eax
80101399:	51                   	push   %ecx
8010139a:	52                   	push   %edx
8010139b:	53                   	push   %ebx
8010139c:	50                   	push   %eax
8010139d:	e8 3b 0d 00 00       	call   801020dd <writei>
801013a2:	83 c4 10             	add    $0x10,%esp
801013a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
801013a8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801013ac:	7e 11                	jle    801013bf <filewrite+0xd3>
        f->off += r;
801013ae:	8b 45 08             	mov    0x8(%ebp),%eax
801013b1:	8b 50 14             	mov    0x14(%eax),%edx
801013b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013b7:	01 c2                	add    %eax,%edx
801013b9:	8b 45 08             	mov    0x8(%ebp),%eax
801013bc:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801013bf:	8b 45 08             	mov    0x8(%ebp),%eax
801013c2:	8b 40 10             	mov    0x10(%eax),%eax
801013c5:	83 ec 0c             	sub    $0xc,%esp
801013c8:	50                   	push   %eax
801013c9:	e8 c5 07 00 00       	call   80101b93 <iunlock>
801013ce:	83 c4 10             	add    $0x10,%esp
      end_op();
801013d1:	e8 2b 1e 00 00       	call   80103201 <end_op>

      if(r < 0)
801013d6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801013da:	78 29                	js     80101405 <filewrite+0x119>
        break;
      if(r != n1)
801013dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801013e2:	74 0d                	je     801013f1 <filewrite+0x105>
        panic("short filewrite");
801013e4:	83 ec 0c             	sub    $0xc,%esp
801013e7:	68 43 a7 10 80       	push   $0x8010a743
801013ec:	e8 d4 f1 ff ff       	call   801005c5 <panic>
      i += r;
801013f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013f4:	01 45 f4             	add    %eax,-0xc(%ebp)
    while(i < n){
801013f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013fa:	3b 45 10             	cmp    0x10(%ebp),%eax
801013fd:	0f 8c 51 ff ff ff    	jl     80101354 <filewrite+0x68>
80101403:	eb 01                	jmp    80101406 <filewrite+0x11a>
        break;
80101405:	90                   	nop
    }
    return i == n ? n : -1;
80101406:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101409:	3b 45 10             	cmp    0x10(%ebp),%eax
8010140c:	75 05                	jne    80101413 <filewrite+0x127>
8010140e:	8b 45 10             	mov    0x10(%ebp),%eax
80101411:	eb 14                	jmp    80101427 <filewrite+0x13b>
80101413:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101418:	eb 0d                	jmp    80101427 <filewrite+0x13b>
  }
  panic("filewrite");
8010141a:	83 ec 0c             	sub    $0xc,%esp
8010141d:	68 53 a7 10 80       	push   $0x8010a753
80101422:	e8 9e f1 ff ff       	call   801005c5 <panic>
}
80101427:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010142a:	c9                   	leave  
8010142b:	c3                   	ret    

8010142c <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
8010142c:	f3 0f 1e fb          	endbr32 
80101430:	55                   	push   %ebp
80101431:	89 e5                	mov    %esp,%ebp
80101433:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, 1);
80101436:	8b 45 08             	mov    0x8(%ebp),%eax
80101439:	83 ec 08             	sub    $0x8,%esp
8010143c:	6a 01                	push   $0x1
8010143e:	50                   	push   %eax
8010143f:	e8 c5 ed ff ff       	call   80100209 <bread>
80101444:	83 c4 10             	add    $0x10,%esp
80101447:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
8010144a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010144d:	83 c0 5c             	add    $0x5c,%eax
80101450:	83 ec 04             	sub    $0x4,%esp
80101453:	6a 1c                	push   $0x1c
80101455:	50                   	push   %eax
80101456:	ff 75 0c             	pushl  0xc(%ebp)
80101459:	e8 40 39 00 00       	call   80104d9e <memmove>
8010145e:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101461:	83 ec 0c             	sub    $0xc,%esp
80101464:	ff 75 f4             	pushl  -0xc(%ebp)
80101467:	e8 27 ee ff ff       	call   80100293 <brelse>
8010146c:	83 c4 10             	add    $0x10,%esp
}
8010146f:	90                   	nop
80101470:	c9                   	leave  
80101471:	c3                   	ret    

80101472 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101472:	f3 0f 1e fb          	endbr32 
80101476:	55                   	push   %ebp
80101477:	89 e5                	mov    %esp,%ebp
80101479:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, bno);
8010147c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010147f:	8b 45 08             	mov    0x8(%ebp),%eax
80101482:	83 ec 08             	sub    $0x8,%esp
80101485:	52                   	push   %edx
80101486:	50                   	push   %eax
80101487:	e8 7d ed ff ff       	call   80100209 <bread>
8010148c:	83 c4 10             	add    $0x10,%esp
8010148f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101492:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101495:	83 c0 5c             	add    $0x5c,%eax
80101498:	83 ec 04             	sub    $0x4,%esp
8010149b:	68 00 02 00 00       	push   $0x200
801014a0:	6a 00                	push   $0x0
801014a2:	50                   	push   %eax
801014a3:	e8 2f 38 00 00       	call   80104cd7 <memset>
801014a8:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801014ab:	83 ec 0c             	sub    $0xc,%esp
801014ae:	ff 75 f4             	pushl  -0xc(%ebp)
801014b1:	e8 04 1f 00 00       	call   801033ba <log_write>
801014b6:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801014b9:	83 ec 0c             	sub    $0xc,%esp
801014bc:	ff 75 f4             	pushl  -0xc(%ebp)
801014bf:	e8 cf ed ff ff       	call   80100293 <brelse>
801014c4:	83 c4 10             	add    $0x10,%esp
}
801014c7:	90                   	nop
801014c8:	c9                   	leave  
801014c9:	c3                   	ret    

801014ca <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801014ca:	f3 0f 1e fb          	endbr32 
801014ce:	55                   	push   %ebp
801014cf:	89 e5                	mov    %esp,%ebp
801014d1:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
801014d4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801014db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801014e2:	e9 13 01 00 00       	jmp    801015fa <balloc+0x130>
    bp = bread(dev, BBLOCK(b, sb));
801014e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014ea:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801014f0:	85 c0                	test   %eax,%eax
801014f2:	0f 48 c2             	cmovs  %edx,%eax
801014f5:	c1 f8 0c             	sar    $0xc,%eax
801014f8:	89 c2                	mov    %eax,%edx
801014fa:	a1 78 37 19 80       	mov    0x80193778,%eax
801014ff:	01 d0                	add    %edx,%eax
80101501:	83 ec 08             	sub    $0x8,%esp
80101504:	50                   	push   %eax
80101505:	ff 75 08             	pushl  0x8(%ebp)
80101508:	e8 fc ec ff ff       	call   80100209 <bread>
8010150d:	83 c4 10             	add    $0x10,%esp
80101510:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101513:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010151a:	e9 a6 00 00 00       	jmp    801015c5 <balloc+0xfb>
      m = 1 << (bi % 8);
8010151f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101522:	99                   	cltd   
80101523:	c1 ea 1d             	shr    $0x1d,%edx
80101526:	01 d0                	add    %edx,%eax
80101528:	83 e0 07             	and    $0x7,%eax
8010152b:	29 d0                	sub    %edx,%eax
8010152d:	ba 01 00 00 00       	mov    $0x1,%edx
80101532:	89 c1                	mov    %eax,%ecx
80101534:	d3 e2                	shl    %cl,%edx
80101536:	89 d0                	mov    %edx,%eax
80101538:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010153b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010153e:	8d 50 07             	lea    0x7(%eax),%edx
80101541:	85 c0                	test   %eax,%eax
80101543:	0f 48 c2             	cmovs  %edx,%eax
80101546:	c1 f8 03             	sar    $0x3,%eax
80101549:	89 c2                	mov    %eax,%edx
8010154b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010154e:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101553:	0f b6 c0             	movzbl %al,%eax
80101556:	23 45 e8             	and    -0x18(%ebp),%eax
80101559:	85 c0                	test   %eax,%eax
8010155b:	75 64                	jne    801015c1 <balloc+0xf7>
        bp->data[bi/8] |= m;  // Mark block in use.
8010155d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101560:	8d 50 07             	lea    0x7(%eax),%edx
80101563:	85 c0                	test   %eax,%eax
80101565:	0f 48 c2             	cmovs  %edx,%eax
80101568:	c1 f8 03             	sar    $0x3,%eax
8010156b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010156e:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
80101573:	89 d1                	mov    %edx,%ecx
80101575:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101578:	09 ca                	or     %ecx,%edx
8010157a:	89 d1                	mov    %edx,%ecx
8010157c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010157f:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
        log_write(bp);
80101583:	83 ec 0c             	sub    $0xc,%esp
80101586:	ff 75 ec             	pushl  -0x14(%ebp)
80101589:	e8 2c 1e 00 00       	call   801033ba <log_write>
8010158e:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
80101591:	83 ec 0c             	sub    $0xc,%esp
80101594:	ff 75 ec             	pushl  -0x14(%ebp)
80101597:	e8 f7 ec ff ff       	call   80100293 <brelse>
8010159c:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
8010159f:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015a5:	01 c2                	add    %eax,%edx
801015a7:	8b 45 08             	mov    0x8(%ebp),%eax
801015aa:	83 ec 08             	sub    $0x8,%esp
801015ad:	52                   	push   %edx
801015ae:	50                   	push   %eax
801015af:	e8 be fe ff ff       	call   80101472 <bzero>
801015b4:	83 c4 10             	add    $0x10,%esp
        return b + bi;
801015b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015bd:	01 d0                	add    %edx,%eax
801015bf:	eb 57                	jmp    80101618 <balloc+0x14e>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801015c1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801015c5:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801015cc:	7f 17                	jg     801015e5 <balloc+0x11b>
801015ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015d4:	01 d0                	add    %edx,%eax
801015d6:	89 c2                	mov    %eax,%edx
801015d8:	a1 60 37 19 80       	mov    0x80193760,%eax
801015dd:	39 c2                	cmp    %eax,%edx
801015df:	0f 82 3a ff ff ff    	jb     8010151f <balloc+0x55>
      }
    }
    brelse(bp);
801015e5:	83 ec 0c             	sub    $0xc,%esp
801015e8:	ff 75 ec             	pushl  -0x14(%ebp)
801015eb:	e8 a3 ec ff ff       	call   80100293 <brelse>
801015f0:	83 c4 10             	add    $0x10,%esp
  for(b = 0; b < sb.size; b += BPB){
801015f3:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801015fa:	8b 15 60 37 19 80    	mov    0x80193760,%edx
80101600:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101603:	39 c2                	cmp    %eax,%edx
80101605:	0f 87 dc fe ff ff    	ja     801014e7 <balloc+0x1d>
  }
  panic("balloc: out of blocks");
8010160b:	83 ec 0c             	sub    $0xc,%esp
8010160e:	68 60 a7 10 80       	push   $0x8010a760
80101613:	e8 ad ef ff ff       	call   801005c5 <panic>
}
80101618:	c9                   	leave  
80101619:	c3                   	ret    

8010161a <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
8010161a:	f3 0f 1e fb          	endbr32 
8010161e:	55                   	push   %ebp
8010161f:	89 e5                	mov    %esp,%ebp
80101621:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
80101624:	83 ec 08             	sub    $0x8,%esp
80101627:	68 60 37 19 80       	push   $0x80193760
8010162c:	ff 75 08             	pushl  0x8(%ebp)
8010162f:	e8 f8 fd ff ff       	call   8010142c <readsb>
80101634:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101637:	8b 45 0c             	mov    0xc(%ebp),%eax
8010163a:	c1 e8 0c             	shr    $0xc,%eax
8010163d:	89 c2                	mov    %eax,%edx
8010163f:	a1 78 37 19 80       	mov    0x80193778,%eax
80101644:	01 c2                	add    %eax,%edx
80101646:	8b 45 08             	mov    0x8(%ebp),%eax
80101649:	83 ec 08             	sub    $0x8,%esp
8010164c:	52                   	push   %edx
8010164d:	50                   	push   %eax
8010164e:	e8 b6 eb ff ff       	call   80100209 <bread>
80101653:	83 c4 10             	add    $0x10,%esp
80101656:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101659:	8b 45 0c             	mov    0xc(%ebp),%eax
8010165c:	25 ff 0f 00 00       	and    $0xfff,%eax
80101661:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101664:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101667:	99                   	cltd   
80101668:	c1 ea 1d             	shr    $0x1d,%edx
8010166b:	01 d0                	add    %edx,%eax
8010166d:	83 e0 07             	and    $0x7,%eax
80101670:	29 d0                	sub    %edx,%eax
80101672:	ba 01 00 00 00       	mov    $0x1,%edx
80101677:	89 c1                	mov    %eax,%ecx
80101679:	d3 e2                	shl    %cl,%edx
8010167b:	89 d0                	mov    %edx,%eax
8010167d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101680:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101683:	8d 50 07             	lea    0x7(%eax),%edx
80101686:	85 c0                	test   %eax,%eax
80101688:	0f 48 c2             	cmovs  %edx,%eax
8010168b:	c1 f8 03             	sar    $0x3,%eax
8010168e:	89 c2                	mov    %eax,%edx
80101690:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101693:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101698:	0f b6 c0             	movzbl %al,%eax
8010169b:	23 45 ec             	and    -0x14(%ebp),%eax
8010169e:	85 c0                	test   %eax,%eax
801016a0:	75 0d                	jne    801016af <bfree+0x95>
    panic("freeing free block");
801016a2:	83 ec 0c             	sub    $0xc,%esp
801016a5:	68 76 a7 10 80       	push   $0x8010a776
801016aa:	e8 16 ef ff ff       	call   801005c5 <panic>
  bp->data[bi/8] &= ~m;
801016af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016b2:	8d 50 07             	lea    0x7(%eax),%edx
801016b5:	85 c0                	test   %eax,%eax
801016b7:	0f 48 c2             	cmovs  %edx,%eax
801016ba:	c1 f8 03             	sar    $0x3,%eax
801016bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016c0:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
801016c5:	89 d1                	mov    %edx,%ecx
801016c7:	8b 55 ec             	mov    -0x14(%ebp),%edx
801016ca:	f7 d2                	not    %edx
801016cc:	21 ca                	and    %ecx,%edx
801016ce:	89 d1                	mov    %edx,%ecx
801016d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016d3:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
  log_write(bp);
801016d7:	83 ec 0c             	sub    $0xc,%esp
801016da:	ff 75 f4             	pushl  -0xc(%ebp)
801016dd:	e8 d8 1c 00 00       	call   801033ba <log_write>
801016e2:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801016e5:	83 ec 0c             	sub    $0xc,%esp
801016e8:	ff 75 f4             	pushl  -0xc(%ebp)
801016eb:	e8 a3 eb ff ff       	call   80100293 <brelse>
801016f0:	83 c4 10             	add    $0x10,%esp
}
801016f3:	90                   	nop
801016f4:	c9                   	leave  
801016f5:	c3                   	ret    

801016f6 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801016f6:	f3 0f 1e fb          	endbr32 
801016fa:	55                   	push   %ebp
801016fb:	89 e5                	mov    %esp,%ebp
801016fd:	57                   	push   %edi
801016fe:	56                   	push   %esi
801016ff:	53                   	push   %ebx
80101700:	83 ec 2c             	sub    $0x2c,%esp
  int i = 0;
80101703:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  
  initlock(&icache.lock, "icache");
8010170a:	83 ec 08             	sub    $0x8,%esp
8010170d:	68 89 a7 10 80       	push   $0x8010a789
80101712:	68 80 37 19 80       	push   $0x80193780
80101717:	e8 06 33 00 00       	call   80104a22 <initlock>
8010171c:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NINODE; i++) {
8010171f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101726:	eb 2d                	jmp    80101755 <iinit+0x5f>
    initsleeplock(&icache.inode[i].lock, "inode");
80101728:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010172b:	89 d0                	mov    %edx,%eax
8010172d:	c1 e0 03             	shl    $0x3,%eax
80101730:	01 d0                	add    %edx,%eax
80101732:	c1 e0 04             	shl    $0x4,%eax
80101735:	83 c0 30             	add    $0x30,%eax
80101738:	05 80 37 19 80       	add    $0x80193780,%eax
8010173d:	83 c0 10             	add    $0x10,%eax
80101740:	83 ec 08             	sub    $0x8,%esp
80101743:	68 90 a7 10 80       	push   $0x8010a790
80101748:	50                   	push   %eax
80101749:	e8 67 31 00 00       	call   801048b5 <initsleeplock>
8010174e:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NINODE; i++) {
80101751:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80101755:	83 7d e4 31          	cmpl   $0x31,-0x1c(%ebp)
80101759:	7e cd                	jle    80101728 <iinit+0x32>
  }

  readsb(dev, &sb);
8010175b:	83 ec 08             	sub    $0x8,%esp
8010175e:	68 60 37 19 80       	push   $0x80193760
80101763:	ff 75 08             	pushl  0x8(%ebp)
80101766:	e8 c1 fc ff ff       	call   8010142c <readsb>
8010176b:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010176e:	a1 78 37 19 80       	mov    0x80193778,%eax
80101773:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80101776:	8b 3d 74 37 19 80    	mov    0x80193774,%edi
8010177c:	8b 35 70 37 19 80    	mov    0x80193770,%esi
80101782:	8b 1d 6c 37 19 80    	mov    0x8019376c,%ebx
80101788:	8b 0d 68 37 19 80    	mov    0x80193768,%ecx
8010178e:	8b 15 64 37 19 80    	mov    0x80193764,%edx
80101794:	a1 60 37 19 80       	mov    0x80193760,%eax
80101799:	ff 75 d4             	pushl  -0x2c(%ebp)
8010179c:	57                   	push   %edi
8010179d:	56                   	push   %esi
8010179e:	53                   	push   %ebx
8010179f:	51                   	push   %ecx
801017a0:	52                   	push   %edx
801017a1:	50                   	push   %eax
801017a2:	68 98 a7 10 80       	push   $0x8010a798
801017a7:	e8 60 ec ff ff       	call   8010040c <cprintf>
801017ac:	83 c4 20             	add    $0x20,%esp
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
801017af:	90                   	nop
801017b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017b3:	5b                   	pop    %ebx
801017b4:	5e                   	pop    %esi
801017b5:	5f                   	pop    %edi
801017b6:	5d                   	pop    %ebp
801017b7:	c3                   	ret    

801017b8 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
801017b8:	f3 0f 1e fb          	endbr32 
801017bc:	55                   	push   %ebp
801017bd:	89 e5                	mov    %esp,%ebp
801017bf:	83 ec 28             	sub    $0x28,%esp
801017c2:	8b 45 0c             	mov    0xc(%ebp),%eax
801017c5:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801017c9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
801017d0:	e9 9e 00 00 00       	jmp    80101873 <ialloc+0xbb>
    bp = bread(dev, IBLOCK(inum, sb));
801017d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017d8:	c1 e8 03             	shr    $0x3,%eax
801017db:	89 c2                	mov    %eax,%edx
801017dd:	a1 74 37 19 80       	mov    0x80193774,%eax
801017e2:	01 d0                	add    %edx,%eax
801017e4:	83 ec 08             	sub    $0x8,%esp
801017e7:	50                   	push   %eax
801017e8:	ff 75 08             	pushl  0x8(%ebp)
801017eb:	e8 19 ea ff ff       	call   80100209 <bread>
801017f0:	83 c4 10             	add    $0x10,%esp
801017f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
801017f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017f9:	8d 50 5c             	lea    0x5c(%eax),%edx
801017fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017ff:	83 e0 07             	and    $0x7,%eax
80101802:	c1 e0 06             	shl    $0x6,%eax
80101805:	01 d0                	add    %edx,%eax
80101807:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
8010180a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010180d:	0f b7 00             	movzwl (%eax),%eax
80101810:	66 85 c0             	test   %ax,%ax
80101813:	75 4c                	jne    80101861 <ialloc+0xa9>
      memset(dip, 0, sizeof(*dip));
80101815:	83 ec 04             	sub    $0x4,%esp
80101818:	6a 40                	push   $0x40
8010181a:	6a 00                	push   $0x0
8010181c:	ff 75 ec             	pushl  -0x14(%ebp)
8010181f:	e8 b3 34 00 00       	call   80104cd7 <memset>
80101824:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
80101827:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010182a:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
8010182e:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
80101831:	83 ec 0c             	sub    $0xc,%esp
80101834:	ff 75 f0             	pushl  -0x10(%ebp)
80101837:	e8 7e 1b 00 00       	call   801033ba <log_write>
8010183c:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
8010183f:	83 ec 0c             	sub    $0xc,%esp
80101842:	ff 75 f0             	pushl  -0x10(%ebp)
80101845:	e8 49 ea ff ff       	call   80100293 <brelse>
8010184a:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
8010184d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101850:	83 ec 08             	sub    $0x8,%esp
80101853:	50                   	push   %eax
80101854:	ff 75 08             	pushl  0x8(%ebp)
80101857:	e8 fc 00 00 00       	call   80101958 <iget>
8010185c:	83 c4 10             	add    $0x10,%esp
8010185f:	eb 30                	jmp    80101891 <ialloc+0xd9>
    }
    brelse(bp);
80101861:	83 ec 0c             	sub    $0xc,%esp
80101864:	ff 75 f0             	pushl  -0x10(%ebp)
80101867:	e8 27 ea ff ff       	call   80100293 <brelse>
8010186c:	83 c4 10             	add    $0x10,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
8010186f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101873:	8b 15 68 37 19 80    	mov    0x80193768,%edx
80101879:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010187c:	39 c2                	cmp    %eax,%edx
8010187e:	0f 87 51 ff ff ff    	ja     801017d5 <ialloc+0x1d>
  }
  panic("ialloc: no inodes");
80101884:	83 ec 0c             	sub    $0xc,%esp
80101887:	68 eb a7 10 80       	push   $0x8010a7eb
8010188c:	e8 34 ed ff ff       	call   801005c5 <panic>
}
80101891:	c9                   	leave  
80101892:	c3                   	ret    

80101893 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
80101893:	f3 0f 1e fb          	endbr32 
80101897:	55                   	push   %ebp
80101898:	89 e5                	mov    %esp,%ebp
8010189a:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010189d:	8b 45 08             	mov    0x8(%ebp),%eax
801018a0:	8b 40 04             	mov    0x4(%eax),%eax
801018a3:	c1 e8 03             	shr    $0x3,%eax
801018a6:	89 c2                	mov    %eax,%edx
801018a8:	a1 74 37 19 80       	mov    0x80193774,%eax
801018ad:	01 c2                	add    %eax,%edx
801018af:	8b 45 08             	mov    0x8(%ebp),%eax
801018b2:	8b 00                	mov    (%eax),%eax
801018b4:	83 ec 08             	sub    $0x8,%esp
801018b7:	52                   	push   %edx
801018b8:	50                   	push   %eax
801018b9:	e8 4b e9 ff ff       	call   80100209 <bread>
801018be:	83 c4 10             	add    $0x10,%esp
801018c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801018c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018c7:	8d 50 5c             	lea    0x5c(%eax),%edx
801018ca:	8b 45 08             	mov    0x8(%ebp),%eax
801018cd:	8b 40 04             	mov    0x4(%eax),%eax
801018d0:	83 e0 07             	and    $0x7,%eax
801018d3:	c1 e0 06             	shl    $0x6,%eax
801018d6:	01 d0                	add    %edx,%eax
801018d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
801018db:	8b 45 08             	mov    0x8(%ebp),%eax
801018de:	0f b7 50 50          	movzwl 0x50(%eax),%edx
801018e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018e5:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801018e8:	8b 45 08             	mov    0x8(%ebp),%eax
801018eb:	0f b7 50 52          	movzwl 0x52(%eax),%edx
801018ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018f2:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801018f6:	8b 45 08             	mov    0x8(%ebp),%eax
801018f9:	0f b7 50 54          	movzwl 0x54(%eax),%edx
801018fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101900:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101904:	8b 45 08             	mov    0x8(%ebp),%eax
80101907:	0f b7 50 56          	movzwl 0x56(%eax),%edx
8010190b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010190e:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101912:	8b 45 08             	mov    0x8(%ebp),%eax
80101915:	8b 50 58             	mov    0x58(%eax),%edx
80101918:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010191b:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010191e:	8b 45 08             	mov    0x8(%ebp),%eax
80101921:	8d 50 5c             	lea    0x5c(%eax),%edx
80101924:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101927:	83 c0 0c             	add    $0xc,%eax
8010192a:	83 ec 04             	sub    $0x4,%esp
8010192d:	6a 34                	push   $0x34
8010192f:	52                   	push   %edx
80101930:	50                   	push   %eax
80101931:	e8 68 34 00 00       	call   80104d9e <memmove>
80101936:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101939:	83 ec 0c             	sub    $0xc,%esp
8010193c:	ff 75 f4             	pushl  -0xc(%ebp)
8010193f:	e8 76 1a 00 00       	call   801033ba <log_write>
80101944:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101947:	83 ec 0c             	sub    $0xc,%esp
8010194a:	ff 75 f4             	pushl  -0xc(%ebp)
8010194d:	e8 41 e9 ff ff       	call   80100293 <brelse>
80101952:	83 c4 10             	add    $0x10,%esp
}
80101955:	90                   	nop
80101956:	c9                   	leave  
80101957:	c3                   	ret    

80101958 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101958:	f3 0f 1e fb          	endbr32 
8010195c:	55                   	push   %ebp
8010195d:	89 e5                	mov    %esp,%ebp
8010195f:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101962:	83 ec 0c             	sub    $0xc,%esp
80101965:	68 80 37 19 80       	push   $0x80193780
8010196a:	e8 d9 30 00 00       	call   80104a48 <acquire>
8010196f:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
80101972:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101979:	c7 45 f4 b4 37 19 80 	movl   $0x801937b4,-0xc(%ebp)
80101980:	eb 60                	jmp    801019e2 <iget+0x8a>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101982:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101985:	8b 40 08             	mov    0x8(%eax),%eax
80101988:	85 c0                	test   %eax,%eax
8010198a:	7e 39                	jle    801019c5 <iget+0x6d>
8010198c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010198f:	8b 00                	mov    (%eax),%eax
80101991:	39 45 08             	cmp    %eax,0x8(%ebp)
80101994:	75 2f                	jne    801019c5 <iget+0x6d>
80101996:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101999:	8b 40 04             	mov    0x4(%eax),%eax
8010199c:	39 45 0c             	cmp    %eax,0xc(%ebp)
8010199f:	75 24                	jne    801019c5 <iget+0x6d>
      ip->ref++;
801019a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019a4:	8b 40 08             	mov    0x8(%eax),%eax
801019a7:	8d 50 01             	lea    0x1(%eax),%edx
801019aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019ad:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
801019b0:	83 ec 0c             	sub    $0xc,%esp
801019b3:	68 80 37 19 80       	push   $0x80193780
801019b8:	e8 fd 30 00 00       	call   80104aba <release>
801019bd:	83 c4 10             	add    $0x10,%esp
      return ip;
801019c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019c3:	eb 77                	jmp    80101a3c <iget+0xe4>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801019c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801019c9:	75 10                	jne    801019db <iget+0x83>
801019cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019ce:	8b 40 08             	mov    0x8(%eax),%eax
801019d1:	85 c0                	test   %eax,%eax
801019d3:	75 06                	jne    801019db <iget+0x83>
      empty = ip;
801019d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801019db:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
801019e2:	81 7d f4 d4 53 19 80 	cmpl   $0x801953d4,-0xc(%ebp)
801019e9:	72 97                	jb     80101982 <iget+0x2a>
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801019eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801019ef:	75 0d                	jne    801019fe <iget+0xa6>
    panic("iget: no inodes");
801019f1:	83 ec 0c             	sub    $0xc,%esp
801019f4:	68 fd a7 10 80       	push   $0x8010a7fd
801019f9:	e8 c7 eb ff ff       	call   801005c5 <panic>

  ip = empty;
801019fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a01:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a07:	8b 55 08             	mov    0x8(%ebp),%edx
80101a0a:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a0f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101a12:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a18:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->valid = 0;
80101a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a22:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  release(&icache.lock);
80101a29:	83 ec 0c             	sub    $0xc,%esp
80101a2c:	68 80 37 19 80       	push   $0x80193780
80101a31:	e8 84 30 00 00       	call   80104aba <release>
80101a36:	83 c4 10             	add    $0x10,%esp

  return ip;
80101a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101a3c:	c9                   	leave  
80101a3d:	c3                   	ret    

80101a3e <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101a3e:	f3 0f 1e fb          	endbr32 
80101a42:	55                   	push   %ebp
80101a43:	89 e5                	mov    %esp,%ebp
80101a45:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101a48:	83 ec 0c             	sub    $0xc,%esp
80101a4b:	68 80 37 19 80       	push   $0x80193780
80101a50:	e8 f3 2f 00 00       	call   80104a48 <acquire>
80101a55:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
80101a58:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5b:	8b 40 08             	mov    0x8(%eax),%eax
80101a5e:	8d 50 01             	lea    0x1(%eax),%edx
80101a61:	8b 45 08             	mov    0x8(%ebp),%eax
80101a64:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101a67:	83 ec 0c             	sub    $0xc,%esp
80101a6a:	68 80 37 19 80       	push   $0x80193780
80101a6f:	e8 46 30 00 00       	call   80104aba <release>
80101a74:	83 c4 10             	add    $0x10,%esp
  return ip;
80101a77:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101a7a:	c9                   	leave  
80101a7b:	c3                   	ret    

80101a7c <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101a7c:	f3 0f 1e fb          	endbr32 
80101a80:	55                   	push   %ebp
80101a81:	89 e5                	mov    %esp,%ebp
80101a83:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101a86:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a8a:	74 0a                	je     80101a96 <ilock+0x1a>
80101a8c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a8f:	8b 40 08             	mov    0x8(%eax),%eax
80101a92:	85 c0                	test   %eax,%eax
80101a94:	7f 0d                	jg     80101aa3 <ilock+0x27>
    panic("ilock");
80101a96:	83 ec 0c             	sub    $0xc,%esp
80101a99:	68 0d a8 10 80       	push   $0x8010a80d
80101a9e:	e8 22 eb ff ff       	call   801005c5 <panic>

  acquiresleep(&ip->lock);
80101aa3:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa6:	83 c0 0c             	add    $0xc,%eax
80101aa9:	83 ec 0c             	sub    $0xc,%esp
80101aac:	50                   	push   %eax
80101aad:	e8 43 2e 00 00       	call   801048f5 <acquiresleep>
80101ab2:	83 c4 10             	add    $0x10,%esp

  if(ip->valid == 0){
80101ab5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab8:	8b 40 4c             	mov    0x4c(%eax),%eax
80101abb:	85 c0                	test   %eax,%eax
80101abd:	0f 85 cd 00 00 00    	jne    80101b90 <ilock+0x114>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101ac3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac6:	8b 40 04             	mov    0x4(%eax),%eax
80101ac9:	c1 e8 03             	shr    $0x3,%eax
80101acc:	89 c2                	mov    %eax,%edx
80101ace:	a1 74 37 19 80       	mov    0x80193774,%eax
80101ad3:	01 c2                	add    %eax,%edx
80101ad5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad8:	8b 00                	mov    (%eax),%eax
80101ada:	83 ec 08             	sub    $0x8,%esp
80101add:	52                   	push   %edx
80101ade:	50                   	push   %eax
80101adf:	e8 25 e7 ff ff       	call   80100209 <bread>
80101ae4:	83 c4 10             	add    $0x10,%esp
80101ae7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101aed:	8d 50 5c             	lea    0x5c(%eax),%edx
80101af0:	8b 45 08             	mov    0x8(%ebp),%eax
80101af3:	8b 40 04             	mov    0x4(%eax),%eax
80101af6:	83 e0 07             	and    $0x7,%eax
80101af9:	c1 e0 06             	shl    $0x6,%eax
80101afc:	01 d0                	add    %edx,%eax
80101afe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101b01:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b04:	0f b7 10             	movzwl (%eax),%edx
80101b07:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0a:	66 89 50 50          	mov    %dx,0x50(%eax)
    ip->major = dip->major;
80101b0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b11:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101b15:	8b 45 08             	mov    0x8(%ebp),%eax
80101b18:	66 89 50 52          	mov    %dx,0x52(%eax)
    ip->minor = dip->minor;
80101b1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b1f:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101b23:	8b 45 08             	mov    0x8(%ebp),%eax
80101b26:	66 89 50 54          	mov    %dx,0x54(%eax)
    ip->nlink = dip->nlink;
80101b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b2d:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101b31:	8b 45 08             	mov    0x8(%ebp),%eax
80101b34:	66 89 50 56          	mov    %dx,0x56(%eax)
    ip->size = dip->size;
80101b38:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b3b:	8b 50 08             	mov    0x8(%eax),%edx
80101b3e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b41:	89 50 58             	mov    %edx,0x58(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b44:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b47:	8d 50 0c             	lea    0xc(%eax),%edx
80101b4a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b4d:	83 c0 5c             	add    $0x5c,%eax
80101b50:	83 ec 04             	sub    $0x4,%esp
80101b53:	6a 34                	push   $0x34
80101b55:	52                   	push   %edx
80101b56:	50                   	push   %eax
80101b57:	e8 42 32 00 00       	call   80104d9e <memmove>
80101b5c:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101b5f:	83 ec 0c             	sub    $0xc,%esp
80101b62:	ff 75 f4             	pushl  -0xc(%ebp)
80101b65:	e8 29 e7 ff ff       	call   80100293 <brelse>
80101b6a:	83 c4 10             	add    $0x10,%esp
    ip->valid = 1;
80101b6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b70:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
    if(ip->type == 0)
80101b77:	8b 45 08             	mov    0x8(%ebp),%eax
80101b7a:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101b7e:	66 85 c0             	test   %ax,%ax
80101b81:	75 0d                	jne    80101b90 <ilock+0x114>
      panic("ilock: no type");
80101b83:	83 ec 0c             	sub    $0xc,%esp
80101b86:	68 13 a8 10 80       	push   $0x8010a813
80101b8b:	e8 35 ea ff ff       	call   801005c5 <panic>
  }
}
80101b90:	90                   	nop
80101b91:	c9                   	leave  
80101b92:	c3                   	ret    

80101b93 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101b93:	f3 0f 1e fb          	endbr32 
80101b97:	55                   	push   %ebp
80101b98:	89 e5                	mov    %esp,%ebp
80101b9a:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b9d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101ba1:	74 20                	je     80101bc3 <iunlock+0x30>
80101ba3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba6:	83 c0 0c             	add    $0xc,%eax
80101ba9:	83 ec 0c             	sub    $0xc,%esp
80101bac:	50                   	push   %eax
80101bad:	e8 fd 2d 00 00       	call   801049af <holdingsleep>
80101bb2:	83 c4 10             	add    $0x10,%esp
80101bb5:	85 c0                	test   %eax,%eax
80101bb7:	74 0a                	je     80101bc3 <iunlock+0x30>
80101bb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bbc:	8b 40 08             	mov    0x8(%eax),%eax
80101bbf:	85 c0                	test   %eax,%eax
80101bc1:	7f 0d                	jg     80101bd0 <iunlock+0x3d>
    panic("iunlock");
80101bc3:	83 ec 0c             	sub    $0xc,%esp
80101bc6:	68 22 a8 10 80       	push   $0x8010a822
80101bcb:	e8 f5 e9 ff ff       	call   801005c5 <panic>

  releasesleep(&ip->lock);
80101bd0:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd3:	83 c0 0c             	add    $0xc,%eax
80101bd6:	83 ec 0c             	sub    $0xc,%esp
80101bd9:	50                   	push   %eax
80101bda:	e8 7e 2d 00 00       	call   8010495d <releasesleep>
80101bdf:	83 c4 10             	add    $0x10,%esp
}
80101be2:	90                   	nop
80101be3:	c9                   	leave  
80101be4:	c3                   	ret    

80101be5 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101be5:	f3 0f 1e fb          	endbr32 
80101be9:	55                   	push   %ebp
80101bea:	89 e5                	mov    %esp,%ebp
80101bec:	83 ec 18             	sub    $0x18,%esp
  acquiresleep(&ip->lock);
80101bef:	8b 45 08             	mov    0x8(%ebp),%eax
80101bf2:	83 c0 0c             	add    $0xc,%eax
80101bf5:	83 ec 0c             	sub    $0xc,%esp
80101bf8:	50                   	push   %eax
80101bf9:	e8 f7 2c 00 00       	call   801048f5 <acquiresleep>
80101bfe:	83 c4 10             	add    $0x10,%esp
  if(ip->valid && ip->nlink == 0){
80101c01:	8b 45 08             	mov    0x8(%ebp),%eax
80101c04:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c07:	85 c0                	test   %eax,%eax
80101c09:	74 6a                	je     80101c75 <iput+0x90>
80101c0b:	8b 45 08             	mov    0x8(%ebp),%eax
80101c0e:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80101c12:	66 85 c0             	test   %ax,%ax
80101c15:	75 5e                	jne    80101c75 <iput+0x90>
    acquire(&icache.lock);
80101c17:	83 ec 0c             	sub    $0xc,%esp
80101c1a:	68 80 37 19 80       	push   $0x80193780
80101c1f:	e8 24 2e 00 00       	call   80104a48 <acquire>
80101c24:	83 c4 10             	add    $0x10,%esp
    int r = ip->ref;
80101c27:	8b 45 08             	mov    0x8(%ebp),%eax
80101c2a:	8b 40 08             	mov    0x8(%eax),%eax
80101c2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101c30:	83 ec 0c             	sub    $0xc,%esp
80101c33:	68 80 37 19 80       	push   $0x80193780
80101c38:	e8 7d 2e 00 00       	call   80104aba <release>
80101c3d:	83 c4 10             	add    $0x10,%esp
    if(r == 1){
80101c40:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80101c44:	75 2f                	jne    80101c75 <iput+0x90>
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
80101c46:	83 ec 0c             	sub    $0xc,%esp
80101c49:	ff 75 08             	pushl  0x8(%ebp)
80101c4c:	e8 b5 01 00 00       	call   80101e06 <itrunc>
80101c51:	83 c4 10             	add    $0x10,%esp
      ip->type = 0;
80101c54:	8b 45 08             	mov    0x8(%ebp),%eax
80101c57:	66 c7 40 50 00 00    	movw   $0x0,0x50(%eax)
      iupdate(ip);
80101c5d:	83 ec 0c             	sub    $0xc,%esp
80101c60:	ff 75 08             	pushl  0x8(%ebp)
80101c63:	e8 2b fc ff ff       	call   80101893 <iupdate>
80101c68:	83 c4 10             	add    $0x10,%esp
      ip->valid = 0;
80101c6b:	8b 45 08             	mov    0x8(%ebp),%eax
80101c6e:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
    }
  }
  releasesleep(&ip->lock);
80101c75:	8b 45 08             	mov    0x8(%ebp),%eax
80101c78:	83 c0 0c             	add    $0xc,%eax
80101c7b:	83 ec 0c             	sub    $0xc,%esp
80101c7e:	50                   	push   %eax
80101c7f:	e8 d9 2c 00 00       	call   8010495d <releasesleep>
80101c84:	83 c4 10             	add    $0x10,%esp

  acquire(&icache.lock);
80101c87:	83 ec 0c             	sub    $0xc,%esp
80101c8a:	68 80 37 19 80       	push   $0x80193780
80101c8f:	e8 b4 2d 00 00       	call   80104a48 <acquire>
80101c94:	83 c4 10             	add    $0x10,%esp
  ip->ref--;
80101c97:	8b 45 08             	mov    0x8(%ebp),%eax
80101c9a:	8b 40 08             	mov    0x8(%eax),%eax
80101c9d:	8d 50 ff             	lea    -0x1(%eax),%edx
80101ca0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca3:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101ca6:	83 ec 0c             	sub    $0xc,%esp
80101ca9:	68 80 37 19 80       	push   $0x80193780
80101cae:	e8 07 2e 00 00       	call   80104aba <release>
80101cb3:	83 c4 10             	add    $0x10,%esp
}
80101cb6:	90                   	nop
80101cb7:	c9                   	leave  
80101cb8:	c3                   	ret    

80101cb9 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101cb9:	f3 0f 1e fb          	endbr32 
80101cbd:	55                   	push   %ebp
80101cbe:	89 e5                	mov    %esp,%ebp
80101cc0:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101cc3:	83 ec 0c             	sub    $0xc,%esp
80101cc6:	ff 75 08             	pushl  0x8(%ebp)
80101cc9:	e8 c5 fe ff ff       	call   80101b93 <iunlock>
80101cce:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101cd1:	83 ec 0c             	sub    $0xc,%esp
80101cd4:	ff 75 08             	pushl  0x8(%ebp)
80101cd7:	e8 09 ff ff ff       	call   80101be5 <iput>
80101cdc:	83 c4 10             	add    $0x10,%esp
}
80101cdf:	90                   	nop
80101ce0:	c9                   	leave  
80101ce1:	c3                   	ret    

80101ce2 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101ce2:	f3 0f 1e fb          	endbr32 
80101ce6:	55                   	push   %ebp
80101ce7:	89 e5                	mov    %esp,%ebp
80101ce9:	83 ec 18             	sub    $0x18,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101cec:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101cf0:	77 42                	ja     80101d34 <bmap+0x52>
    if((addr = ip->addrs[bn]) == 0)
80101cf2:	8b 45 08             	mov    0x8(%ebp),%eax
80101cf5:	8b 55 0c             	mov    0xc(%ebp),%edx
80101cf8:	83 c2 14             	add    $0x14,%edx
80101cfb:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101cff:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d06:	75 24                	jne    80101d2c <bmap+0x4a>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101d08:	8b 45 08             	mov    0x8(%ebp),%eax
80101d0b:	8b 00                	mov    (%eax),%eax
80101d0d:	83 ec 0c             	sub    $0xc,%esp
80101d10:	50                   	push   %eax
80101d11:	e8 b4 f7 ff ff       	call   801014ca <balloc>
80101d16:	83 c4 10             	add    $0x10,%esp
80101d19:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d1c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d1f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101d22:	8d 4a 14             	lea    0x14(%edx),%ecx
80101d25:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d28:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d2f:	e9 d0 00 00 00       	jmp    80101e04 <bmap+0x122>
  }
  bn -= NDIRECT;
80101d34:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101d38:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101d3c:	0f 87 b5 00 00 00    	ja     80101df7 <bmap+0x115>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101d42:	8b 45 08             	mov    0x8(%ebp),%eax
80101d45:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101d4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d52:	75 20                	jne    80101d74 <bmap+0x92>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101d54:	8b 45 08             	mov    0x8(%ebp),%eax
80101d57:	8b 00                	mov    (%eax),%eax
80101d59:	83 ec 0c             	sub    $0xc,%esp
80101d5c:	50                   	push   %eax
80101d5d:	e8 68 f7 ff ff       	call   801014ca <balloc>
80101d62:	83 c4 10             	add    $0x10,%esp
80101d65:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d68:	8b 45 08             	mov    0x8(%ebp),%eax
80101d6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d6e:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
    bp = bread(ip->dev, addr);
80101d74:	8b 45 08             	mov    0x8(%ebp),%eax
80101d77:	8b 00                	mov    (%eax),%eax
80101d79:	83 ec 08             	sub    $0x8,%esp
80101d7c:	ff 75 f4             	pushl  -0xc(%ebp)
80101d7f:	50                   	push   %eax
80101d80:	e8 84 e4 ff ff       	call   80100209 <bread>
80101d85:	83 c4 10             	add    $0x10,%esp
80101d88:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101d8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d8e:	83 c0 5c             	add    $0x5c,%eax
80101d91:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101d94:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d97:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101da1:	01 d0                	add    %edx,%eax
80101da3:	8b 00                	mov    (%eax),%eax
80101da5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101da8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101dac:	75 36                	jne    80101de4 <bmap+0x102>
      a[bn] = addr = balloc(ip->dev);
80101dae:	8b 45 08             	mov    0x8(%ebp),%eax
80101db1:	8b 00                	mov    (%eax),%eax
80101db3:	83 ec 0c             	sub    $0xc,%esp
80101db6:	50                   	push   %eax
80101db7:	e8 0e f7 ff ff       	call   801014ca <balloc>
80101dbc:	83 c4 10             	add    $0x10,%esp
80101dbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101dc2:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dc5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101dcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101dcf:	01 c2                	add    %eax,%edx
80101dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101dd4:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101dd6:	83 ec 0c             	sub    $0xc,%esp
80101dd9:	ff 75 f0             	pushl  -0x10(%ebp)
80101ddc:	e8 d9 15 00 00       	call   801033ba <log_write>
80101de1:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101de4:	83 ec 0c             	sub    $0xc,%esp
80101de7:	ff 75 f0             	pushl  -0x10(%ebp)
80101dea:	e8 a4 e4 ff ff       	call   80100293 <brelse>
80101def:	83 c4 10             	add    $0x10,%esp
    return addr;
80101df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101df5:	eb 0d                	jmp    80101e04 <bmap+0x122>
  }

  panic("bmap: out of range");
80101df7:	83 ec 0c             	sub    $0xc,%esp
80101dfa:	68 2a a8 10 80       	push   $0x8010a82a
80101dff:	e8 c1 e7 ff ff       	call   801005c5 <panic>
}
80101e04:	c9                   	leave  
80101e05:	c3                   	ret    

80101e06 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101e06:	f3 0f 1e fb          	endbr32 
80101e0a:	55                   	push   %ebp
80101e0b:	89 e5                	mov    %esp,%ebp
80101e0d:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101e10:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101e17:	eb 45                	jmp    80101e5e <itrunc+0x58>
    if(ip->addrs[i]){
80101e19:	8b 45 08             	mov    0x8(%ebp),%eax
80101e1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e1f:	83 c2 14             	add    $0x14,%edx
80101e22:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101e26:	85 c0                	test   %eax,%eax
80101e28:	74 30                	je     80101e5a <itrunc+0x54>
      bfree(ip->dev, ip->addrs[i]);
80101e2a:	8b 45 08             	mov    0x8(%ebp),%eax
80101e2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e30:	83 c2 14             	add    $0x14,%edx
80101e33:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101e37:	8b 55 08             	mov    0x8(%ebp),%edx
80101e3a:	8b 12                	mov    (%edx),%edx
80101e3c:	83 ec 08             	sub    $0x8,%esp
80101e3f:	50                   	push   %eax
80101e40:	52                   	push   %edx
80101e41:	e8 d4 f7 ff ff       	call   8010161a <bfree>
80101e46:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101e49:	8b 45 08             	mov    0x8(%ebp),%eax
80101e4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e4f:	83 c2 14             	add    $0x14,%edx
80101e52:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101e59:	00 
  for(i = 0; i < NDIRECT; i++){
80101e5a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101e5e:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101e62:	7e b5                	jle    80101e19 <itrunc+0x13>
    }
  }

  if(ip->addrs[NDIRECT]){
80101e64:	8b 45 08             	mov    0x8(%ebp),%eax
80101e67:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101e6d:	85 c0                	test   %eax,%eax
80101e6f:	0f 84 aa 00 00 00    	je     80101f1f <itrunc+0x119>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101e75:	8b 45 08             	mov    0x8(%ebp),%eax
80101e78:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101e7e:	8b 45 08             	mov    0x8(%ebp),%eax
80101e81:	8b 00                	mov    (%eax),%eax
80101e83:	83 ec 08             	sub    $0x8,%esp
80101e86:	52                   	push   %edx
80101e87:	50                   	push   %eax
80101e88:	e8 7c e3 ff ff       	call   80100209 <bread>
80101e8d:	83 c4 10             	add    $0x10,%esp
80101e90:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101e93:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e96:	83 c0 5c             	add    $0x5c,%eax
80101e99:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101e9c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101ea3:	eb 3c                	jmp    80101ee1 <itrunc+0xdb>
      if(a[j])
80101ea5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ea8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101eaf:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101eb2:	01 d0                	add    %edx,%eax
80101eb4:	8b 00                	mov    (%eax),%eax
80101eb6:	85 c0                	test   %eax,%eax
80101eb8:	74 23                	je     80101edd <itrunc+0xd7>
        bfree(ip->dev, a[j]);
80101eba:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ebd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101ec4:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101ec7:	01 d0                	add    %edx,%eax
80101ec9:	8b 00                	mov    (%eax),%eax
80101ecb:	8b 55 08             	mov    0x8(%ebp),%edx
80101ece:	8b 12                	mov    (%edx),%edx
80101ed0:	83 ec 08             	sub    $0x8,%esp
80101ed3:	50                   	push   %eax
80101ed4:	52                   	push   %edx
80101ed5:	e8 40 f7 ff ff       	call   8010161a <bfree>
80101eda:	83 c4 10             	add    $0x10,%esp
    for(j = 0; j < NINDIRECT; j++){
80101edd:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101ee1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ee4:	83 f8 7f             	cmp    $0x7f,%eax
80101ee7:	76 bc                	jbe    80101ea5 <itrunc+0x9f>
    }
    brelse(bp);
80101ee9:	83 ec 0c             	sub    $0xc,%esp
80101eec:	ff 75 ec             	pushl  -0x14(%ebp)
80101eef:	e8 9f e3 ff ff       	call   80100293 <brelse>
80101ef4:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101ef7:	8b 45 08             	mov    0x8(%ebp),%eax
80101efa:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101f00:	8b 55 08             	mov    0x8(%ebp),%edx
80101f03:	8b 12                	mov    (%edx),%edx
80101f05:	83 ec 08             	sub    $0x8,%esp
80101f08:	50                   	push   %eax
80101f09:	52                   	push   %edx
80101f0a:	e8 0b f7 ff ff       	call   8010161a <bfree>
80101f0f:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101f12:	8b 45 08             	mov    0x8(%ebp),%eax
80101f15:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80101f1c:	00 00 00 
  }

  ip->size = 0;
80101f1f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f22:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  iupdate(ip);
80101f29:	83 ec 0c             	sub    $0xc,%esp
80101f2c:	ff 75 08             	pushl  0x8(%ebp)
80101f2f:	e8 5f f9 ff ff       	call   80101893 <iupdate>
80101f34:	83 c4 10             	add    $0x10,%esp
}
80101f37:	90                   	nop
80101f38:	c9                   	leave  
80101f39:	c3                   	ret    

80101f3a <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101f3a:	f3 0f 1e fb          	endbr32 
80101f3e:	55                   	push   %ebp
80101f3f:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101f41:	8b 45 08             	mov    0x8(%ebp),%eax
80101f44:	8b 00                	mov    (%eax),%eax
80101f46:	89 c2                	mov    %eax,%edx
80101f48:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f4b:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101f4e:	8b 45 08             	mov    0x8(%ebp),%eax
80101f51:	8b 50 04             	mov    0x4(%eax),%edx
80101f54:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f57:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101f5a:	8b 45 08             	mov    0x8(%ebp),%eax
80101f5d:	0f b7 50 50          	movzwl 0x50(%eax),%edx
80101f61:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f64:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101f67:	8b 45 08             	mov    0x8(%ebp),%eax
80101f6a:	0f b7 50 56          	movzwl 0x56(%eax),%edx
80101f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f71:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101f75:	8b 45 08             	mov    0x8(%ebp),%eax
80101f78:	8b 50 58             	mov    0x58(%eax),%edx
80101f7b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f7e:	89 50 10             	mov    %edx,0x10(%eax)
}
80101f81:	90                   	nop
80101f82:	5d                   	pop    %ebp
80101f83:	c3                   	ret    

80101f84 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101f84:	f3 0f 1e fb          	endbr32 
80101f88:	55                   	push   %ebp
80101f89:	89 e5                	mov    %esp,%ebp
80101f8b:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f8e:	8b 45 08             	mov    0x8(%ebp),%eax
80101f91:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101f95:	66 83 f8 03          	cmp    $0x3,%ax
80101f99:	75 5c                	jne    80101ff7 <readi+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101f9b:	8b 45 08             	mov    0x8(%ebp),%eax
80101f9e:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101fa2:	66 85 c0             	test   %ax,%ax
80101fa5:	78 20                	js     80101fc7 <readi+0x43>
80101fa7:	8b 45 08             	mov    0x8(%ebp),%eax
80101faa:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101fae:	66 83 f8 09          	cmp    $0x9,%ax
80101fb2:	7f 13                	jg     80101fc7 <readi+0x43>
80101fb4:	8b 45 08             	mov    0x8(%ebp),%eax
80101fb7:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101fbb:	98                   	cwtl   
80101fbc:	8b 04 c5 00 37 19 80 	mov    -0x7fe6c900(,%eax,8),%eax
80101fc3:	85 c0                	test   %eax,%eax
80101fc5:	75 0a                	jne    80101fd1 <readi+0x4d>
      return -1;
80101fc7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fcc:	e9 0a 01 00 00       	jmp    801020db <readi+0x157>
    return devsw[ip->major].read(ip, dst, n);
80101fd1:	8b 45 08             	mov    0x8(%ebp),%eax
80101fd4:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101fd8:	98                   	cwtl   
80101fd9:	8b 04 c5 00 37 19 80 	mov    -0x7fe6c900(,%eax,8),%eax
80101fe0:	8b 55 14             	mov    0x14(%ebp),%edx
80101fe3:	83 ec 04             	sub    $0x4,%esp
80101fe6:	52                   	push   %edx
80101fe7:	ff 75 0c             	pushl  0xc(%ebp)
80101fea:	ff 75 08             	pushl  0x8(%ebp)
80101fed:	ff d0                	call   *%eax
80101fef:	83 c4 10             	add    $0x10,%esp
80101ff2:	e9 e4 00 00 00       	jmp    801020db <readi+0x157>
  }

  if(off > ip->size || off + n < off)
80101ff7:	8b 45 08             	mov    0x8(%ebp),%eax
80101ffa:	8b 40 58             	mov    0x58(%eax),%eax
80101ffd:	39 45 10             	cmp    %eax,0x10(%ebp)
80102000:	77 0d                	ja     8010200f <readi+0x8b>
80102002:	8b 55 10             	mov    0x10(%ebp),%edx
80102005:	8b 45 14             	mov    0x14(%ebp),%eax
80102008:	01 d0                	add    %edx,%eax
8010200a:	39 45 10             	cmp    %eax,0x10(%ebp)
8010200d:	76 0a                	jbe    80102019 <readi+0x95>
    return -1;
8010200f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102014:	e9 c2 00 00 00       	jmp    801020db <readi+0x157>
  if(off + n > ip->size)
80102019:	8b 55 10             	mov    0x10(%ebp),%edx
8010201c:	8b 45 14             	mov    0x14(%ebp),%eax
8010201f:	01 c2                	add    %eax,%edx
80102021:	8b 45 08             	mov    0x8(%ebp),%eax
80102024:	8b 40 58             	mov    0x58(%eax),%eax
80102027:	39 c2                	cmp    %eax,%edx
80102029:	76 0c                	jbe    80102037 <readi+0xb3>
    n = ip->size - off;
8010202b:	8b 45 08             	mov    0x8(%ebp),%eax
8010202e:	8b 40 58             	mov    0x58(%eax),%eax
80102031:	2b 45 10             	sub    0x10(%ebp),%eax
80102034:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102037:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010203e:	e9 89 00 00 00       	jmp    801020cc <readi+0x148>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102043:	8b 45 10             	mov    0x10(%ebp),%eax
80102046:	c1 e8 09             	shr    $0x9,%eax
80102049:	83 ec 08             	sub    $0x8,%esp
8010204c:	50                   	push   %eax
8010204d:	ff 75 08             	pushl  0x8(%ebp)
80102050:	e8 8d fc ff ff       	call   80101ce2 <bmap>
80102055:	83 c4 10             	add    $0x10,%esp
80102058:	8b 55 08             	mov    0x8(%ebp),%edx
8010205b:	8b 12                	mov    (%edx),%edx
8010205d:	83 ec 08             	sub    $0x8,%esp
80102060:	50                   	push   %eax
80102061:	52                   	push   %edx
80102062:	e8 a2 e1 ff ff       	call   80100209 <bread>
80102067:	83 c4 10             	add    $0x10,%esp
8010206a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
8010206d:	8b 45 10             	mov    0x10(%ebp),%eax
80102070:	25 ff 01 00 00       	and    $0x1ff,%eax
80102075:	ba 00 02 00 00       	mov    $0x200,%edx
8010207a:	29 c2                	sub    %eax,%edx
8010207c:	8b 45 14             	mov    0x14(%ebp),%eax
8010207f:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102082:	39 c2                	cmp    %eax,%edx
80102084:	0f 46 c2             	cmovbe %edx,%eax
80102087:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
8010208a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010208d:	8d 50 5c             	lea    0x5c(%eax),%edx
80102090:	8b 45 10             	mov    0x10(%ebp),%eax
80102093:	25 ff 01 00 00       	and    $0x1ff,%eax
80102098:	01 d0                	add    %edx,%eax
8010209a:	83 ec 04             	sub    $0x4,%esp
8010209d:	ff 75 ec             	pushl  -0x14(%ebp)
801020a0:	50                   	push   %eax
801020a1:	ff 75 0c             	pushl  0xc(%ebp)
801020a4:	e8 f5 2c 00 00       	call   80104d9e <memmove>
801020a9:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801020ac:	83 ec 0c             	sub    $0xc,%esp
801020af:	ff 75 f0             	pushl  -0x10(%ebp)
801020b2:	e8 dc e1 ff ff       	call   80100293 <brelse>
801020b7:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801020ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020bd:	01 45 f4             	add    %eax,-0xc(%ebp)
801020c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020c3:	01 45 10             	add    %eax,0x10(%ebp)
801020c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020c9:	01 45 0c             	add    %eax,0xc(%ebp)
801020cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020cf:	3b 45 14             	cmp    0x14(%ebp),%eax
801020d2:	0f 82 6b ff ff ff    	jb     80102043 <readi+0xbf>
  }
  return n;
801020d8:	8b 45 14             	mov    0x14(%ebp),%eax
}
801020db:	c9                   	leave  
801020dc:	c3                   	ret    

801020dd <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801020dd:	f3 0f 1e fb          	endbr32 
801020e1:	55                   	push   %ebp
801020e2:	89 e5                	mov    %esp,%ebp
801020e4:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801020e7:	8b 45 08             	mov    0x8(%ebp),%eax
801020ea:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801020ee:	66 83 f8 03          	cmp    $0x3,%ax
801020f2:	75 5c                	jne    80102150 <writei+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801020f4:	8b 45 08             	mov    0x8(%ebp),%eax
801020f7:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801020fb:	66 85 c0             	test   %ax,%ax
801020fe:	78 20                	js     80102120 <writei+0x43>
80102100:	8b 45 08             	mov    0x8(%ebp),%eax
80102103:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102107:	66 83 f8 09          	cmp    $0x9,%ax
8010210b:	7f 13                	jg     80102120 <writei+0x43>
8010210d:	8b 45 08             	mov    0x8(%ebp),%eax
80102110:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102114:	98                   	cwtl   
80102115:	8b 04 c5 04 37 19 80 	mov    -0x7fe6c8fc(,%eax,8),%eax
8010211c:	85 c0                	test   %eax,%eax
8010211e:	75 0a                	jne    8010212a <writei+0x4d>
      return -1;
80102120:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102125:	e9 3b 01 00 00       	jmp    80102265 <writei+0x188>
    return devsw[ip->major].write(ip, src, n);
8010212a:	8b 45 08             	mov    0x8(%ebp),%eax
8010212d:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102131:	98                   	cwtl   
80102132:	8b 04 c5 04 37 19 80 	mov    -0x7fe6c8fc(,%eax,8),%eax
80102139:	8b 55 14             	mov    0x14(%ebp),%edx
8010213c:	83 ec 04             	sub    $0x4,%esp
8010213f:	52                   	push   %edx
80102140:	ff 75 0c             	pushl  0xc(%ebp)
80102143:	ff 75 08             	pushl  0x8(%ebp)
80102146:	ff d0                	call   *%eax
80102148:	83 c4 10             	add    $0x10,%esp
8010214b:	e9 15 01 00 00       	jmp    80102265 <writei+0x188>
  }

  if(off > ip->size || off + n < off)
80102150:	8b 45 08             	mov    0x8(%ebp),%eax
80102153:	8b 40 58             	mov    0x58(%eax),%eax
80102156:	39 45 10             	cmp    %eax,0x10(%ebp)
80102159:	77 0d                	ja     80102168 <writei+0x8b>
8010215b:	8b 55 10             	mov    0x10(%ebp),%edx
8010215e:	8b 45 14             	mov    0x14(%ebp),%eax
80102161:	01 d0                	add    %edx,%eax
80102163:	39 45 10             	cmp    %eax,0x10(%ebp)
80102166:	76 0a                	jbe    80102172 <writei+0x95>
    return -1;
80102168:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010216d:	e9 f3 00 00 00       	jmp    80102265 <writei+0x188>
  if(off + n > MAXFILE*BSIZE)
80102172:	8b 55 10             	mov    0x10(%ebp),%edx
80102175:	8b 45 14             	mov    0x14(%ebp),%eax
80102178:	01 d0                	add    %edx,%eax
8010217a:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010217f:	76 0a                	jbe    8010218b <writei+0xae>
    return -1;
80102181:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102186:	e9 da 00 00 00       	jmp    80102265 <writei+0x188>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010218b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102192:	e9 97 00 00 00       	jmp    8010222e <writei+0x151>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102197:	8b 45 10             	mov    0x10(%ebp),%eax
8010219a:	c1 e8 09             	shr    $0x9,%eax
8010219d:	83 ec 08             	sub    $0x8,%esp
801021a0:	50                   	push   %eax
801021a1:	ff 75 08             	pushl  0x8(%ebp)
801021a4:	e8 39 fb ff ff       	call   80101ce2 <bmap>
801021a9:	83 c4 10             	add    $0x10,%esp
801021ac:	8b 55 08             	mov    0x8(%ebp),%edx
801021af:	8b 12                	mov    (%edx),%edx
801021b1:	83 ec 08             	sub    $0x8,%esp
801021b4:	50                   	push   %eax
801021b5:	52                   	push   %edx
801021b6:	e8 4e e0 ff ff       	call   80100209 <bread>
801021bb:	83 c4 10             	add    $0x10,%esp
801021be:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801021c1:	8b 45 10             	mov    0x10(%ebp),%eax
801021c4:	25 ff 01 00 00       	and    $0x1ff,%eax
801021c9:	ba 00 02 00 00       	mov    $0x200,%edx
801021ce:	29 c2                	sub    %eax,%edx
801021d0:	8b 45 14             	mov    0x14(%ebp),%eax
801021d3:	2b 45 f4             	sub    -0xc(%ebp),%eax
801021d6:	39 c2                	cmp    %eax,%edx
801021d8:	0f 46 c2             	cmovbe %edx,%eax
801021db:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
801021de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801021e1:	8d 50 5c             	lea    0x5c(%eax),%edx
801021e4:	8b 45 10             	mov    0x10(%ebp),%eax
801021e7:	25 ff 01 00 00       	and    $0x1ff,%eax
801021ec:	01 d0                	add    %edx,%eax
801021ee:	83 ec 04             	sub    $0x4,%esp
801021f1:	ff 75 ec             	pushl  -0x14(%ebp)
801021f4:	ff 75 0c             	pushl  0xc(%ebp)
801021f7:	50                   	push   %eax
801021f8:	e8 a1 2b 00 00       	call   80104d9e <memmove>
801021fd:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
80102200:	83 ec 0c             	sub    $0xc,%esp
80102203:	ff 75 f0             	pushl  -0x10(%ebp)
80102206:	e8 af 11 00 00       	call   801033ba <log_write>
8010220b:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
8010220e:	83 ec 0c             	sub    $0xc,%esp
80102211:	ff 75 f0             	pushl  -0x10(%ebp)
80102214:	e8 7a e0 ff ff       	call   80100293 <brelse>
80102219:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010221c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010221f:	01 45 f4             	add    %eax,-0xc(%ebp)
80102222:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102225:	01 45 10             	add    %eax,0x10(%ebp)
80102228:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010222b:	01 45 0c             	add    %eax,0xc(%ebp)
8010222e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102231:	3b 45 14             	cmp    0x14(%ebp),%eax
80102234:	0f 82 5d ff ff ff    	jb     80102197 <writei+0xba>
  }

  if(n > 0 && off > ip->size){
8010223a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010223e:	74 22                	je     80102262 <writei+0x185>
80102240:	8b 45 08             	mov    0x8(%ebp),%eax
80102243:	8b 40 58             	mov    0x58(%eax),%eax
80102246:	39 45 10             	cmp    %eax,0x10(%ebp)
80102249:	76 17                	jbe    80102262 <writei+0x185>
    ip->size = off;
8010224b:	8b 45 08             	mov    0x8(%ebp),%eax
8010224e:	8b 55 10             	mov    0x10(%ebp),%edx
80102251:	89 50 58             	mov    %edx,0x58(%eax)
    iupdate(ip);
80102254:	83 ec 0c             	sub    $0xc,%esp
80102257:	ff 75 08             	pushl  0x8(%ebp)
8010225a:	e8 34 f6 ff ff       	call   80101893 <iupdate>
8010225f:	83 c4 10             	add    $0x10,%esp
  }
  return n;
80102262:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102265:	c9                   	leave  
80102266:	c3                   	ret    

80102267 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102267:	f3 0f 1e fb          	endbr32 
8010226b:	55                   	push   %ebp
8010226c:	89 e5                	mov    %esp,%ebp
8010226e:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
80102271:	83 ec 04             	sub    $0x4,%esp
80102274:	6a 0e                	push   $0xe
80102276:	ff 75 0c             	pushl  0xc(%ebp)
80102279:	ff 75 08             	pushl  0x8(%ebp)
8010227c:	e8 bb 2b 00 00       	call   80104e3c <strncmp>
80102281:	83 c4 10             	add    $0x10,%esp
}
80102284:	c9                   	leave  
80102285:	c3                   	ret    

80102286 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102286:	f3 0f 1e fb          	endbr32 
8010228a:	55                   	push   %ebp
8010228b:	89 e5                	mov    %esp,%ebp
8010228d:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102290:	8b 45 08             	mov    0x8(%ebp),%eax
80102293:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80102297:	66 83 f8 01          	cmp    $0x1,%ax
8010229b:	74 0d                	je     801022aa <dirlookup+0x24>
    panic("dirlookup not DIR");
8010229d:	83 ec 0c             	sub    $0xc,%esp
801022a0:	68 3d a8 10 80       	push   $0x8010a83d
801022a5:	e8 1b e3 ff ff       	call   801005c5 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801022aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801022b1:	eb 7b                	jmp    8010232e <dirlookup+0xa8>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022b3:	6a 10                	push   $0x10
801022b5:	ff 75 f4             	pushl  -0xc(%ebp)
801022b8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022bb:	50                   	push   %eax
801022bc:	ff 75 08             	pushl  0x8(%ebp)
801022bf:	e8 c0 fc ff ff       	call   80101f84 <readi>
801022c4:	83 c4 10             	add    $0x10,%esp
801022c7:	83 f8 10             	cmp    $0x10,%eax
801022ca:	74 0d                	je     801022d9 <dirlookup+0x53>
      panic("dirlookup read");
801022cc:	83 ec 0c             	sub    $0xc,%esp
801022cf:	68 4f a8 10 80       	push   $0x8010a84f
801022d4:	e8 ec e2 ff ff       	call   801005c5 <panic>
    if(de.inum == 0)
801022d9:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801022dd:	66 85 c0             	test   %ax,%ax
801022e0:	74 47                	je     80102329 <dirlookup+0xa3>
      continue;
    if(namecmp(name, de.name) == 0){
801022e2:	83 ec 08             	sub    $0x8,%esp
801022e5:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022e8:	83 c0 02             	add    $0x2,%eax
801022eb:	50                   	push   %eax
801022ec:	ff 75 0c             	pushl  0xc(%ebp)
801022ef:	e8 73 ff ff ff       	call   80102267 <namecmp>
801022f4:	83 c4 10             	add    $0x10,%esp
801022f7:	85 c0                	test   %eax,%eax
801022f9:	75 2f                	jne    8010232a <dirlookup+0xa4>
      // entry matches path element
      if(poff)
801022fb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801022ff:	74 08                	je     80102309 <dirlookup+0x83>
        *poff = off;
80102301:	8b 45 10             	mov    0x10(%ebp),%eax
80102304:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102307:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102309:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010230d:	0f b7 c0             	movzwl %ax,%eax
80102310:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102313:	8b 45 08             	mov    0x8(%ebp),%eax
80102316:	8b 00                	mov    (%eax),%eax
80102318:	83 ec 08             	sub    $0x8,%esp
8010231b:	ff 75 f0             	pushl  -0x10(%ebp)
8010231e:	50                   	push   %eax
8010231f:	e8 34 f6 ff ff       	call   80101958 <iget>
80102324:	83 c4 10             	add    $0x10,%esp
80102327:	eb 19                	jmp    80102342 <dirlookup+0xbc>
      continue;
80102329:	90                   	nop
  for(off = 0; off < dp->size; off += sizeof(de)){
8010232a:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010232e:	8b 45 08             	mov    0x8(%ebp),%eax
80102331:	8b 40 58             	mov    0x58(%eax),%eax
80102334:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80102337:	0f 82 76 ff ff ff    	jb     801022b3 <dirlookup+0x2d>
    }
  }

  return 0;
8010233d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102342:	c9                   	leave  
80102343:	c3                   	ret    

80102344 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102344:	f3 0f 1e fb          	endbr32 
80102348:	55                   	push   %ebp
80102349:	89 e5                	mov    %esp,%ebp
8010234b:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010234e:	83 ec 04             	sub    $0x4,%esp
80102351:	6a 00                	push   $0x0
80102353:	ff 75 0c             	pushl  0xc(%ebp)
80102356:	ff 75 08             	pushl  0x8(%ebp)
80102359:	e8 28 ff ff ff       	call   80102286 <dirlookup>
8010235e:	83 c4 10             	add    $0x10,%esp
80102361:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102364:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102368:	74 18                	je     80102382 <dirlink+0x3e>
    iput(ip);
8010236a:	83 ec 0c             	sub    $0xc,%esp
8010236d:	ff 75 f0             	pushl  -0x10(%ebp)
80102370:	e8 70 f8 ff ff       	call   80101be5 <iput>
80102375:	83 c4 10             	add    $0x10,%esp
    return -1;
80102378:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010237d:	e9 9c 00 00 00       	jmp    8010241e <dirlink+0xda>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102382:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102389:	eb 39                	jmp    801023c4 <dirlink+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010238b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010238e:	6a 10                	push   $0x10
80102390:	50                   	push   %eax
80102391:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102394:	50                   	push   %eax
80102395:	ff 75 08             	pushl  0x8(%ebp)
80102398:	e8 e7 fb ff ff       	call   80101f84 <readi>
8010239d:	83 c4 10             	add    $0x10,%esp
801023a0:	83 f8 10             	cmp    $0x10,%eax
801023a3:	74 0d                	je     801023b2 <dirlink+0x6e>
      panic("dirlink read");
801023a5:	83 ec 0c             	sub    $0xc,%esp
801023a8:	68 5e a8 10 80       	push   $0x8010a85e
801023ad:	e8 13 e2 ff ff       	call   801005c5 <panic>
    if(de.inum == 0)
801023b2:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801023b6:	66 85 c0             	test   %ax,%ax
801023b9:	74 18                	je     801023d3 <dirlink+0x8f>
  for(off = 0; off < dp->size; off += sizeof(de)){
801023bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023be:	83 c0 10             	add    $0x10,%eax
801023c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801023c4:	8b 45 08             	mov    0x8(%ebp),%eax
801023c7:	8b 50 58             	mov    0x58(%eax),%edx
801023ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023cd:	39 c2                	cmp    %eax,%edx
801023cf:	77 ba                	ja     8010238b <dirlink+0x47>
801023d1:	eb 01                	jmp    801023d4 <dirlink+0x90>
      break;
801023d3:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
801023d4:	83 ec 04             	sub    $0x4,%esp
801023d7:	6a 0e                	push   $0xe
801023d9:	ff 75 0c             	pushl  0xc(%ebp)
801023dc:	8d 45 e0             	lea    -0x20(%ebp),%eax
801023df:	83 c0 02             	add    $0x2,%eax
801023e2:	50                   	push   %eax
801023e3:	e8 ae 2a 00 00       	call   80104e96 <strncpy>
801023e8:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
801023eb:	8b 45 10             	mov    0x10(%ebp),%eax
801023ee:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023f5:	6a 10                	push   $0x10
801023f7:	50                   	push   %eax
801023f8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801023fb:	50                   	push   %eax
801023fc:	ff 75 08             	pushl  0x8(%ebp)
801023ff:	e8 d9 fc ff ff       	call   801020dd <writei>
80102404:	83 c4 10             	add    $0x10,%esp
80102407:	83 f8 10             	cmp    $0x10,%eax
8010240a:	74 0d                	je     80102419 <dirlink+0xd5>
    panic("dirlink");
8010240c:	83 ec 0c             	sub    $0xc,%esp
8010240f:	68 6b a8 10 80       	push   $0x8010a86b
80102414:	e8 ac e1 ff ff       	call   801005c5 <panic>

  return 0;
80102419:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010241e:	c9                   	leave  
8010241f:	c3                   	ret    

80102420 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102420:	f3 0f 1e fb          	endbr32 
80102424:	55                   	push   %ebp
80102425:	89 e5                	mov    %esp,%ebp
80102427:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
8010242a:	eb 04                	jmp    80102430 <skipelem+0x10>
    path++;
8010242c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
80102430:	8b 45 08             	mov    0x8(%ebp),%eax
80102433:	0f b6 00             	movzbl (%eax),%eax
80102436:	3c 2f                	cmp    $0x2f,%al
80102438:	74 f2                	je     8010242c <skipelem+0xc>
  if(*path == 0)
8010243a:	8b 45 08             	mov    0x8(%ebp),%eax
8010243d:	0f b6 00             	movzbl (%eax),%eax
80102440:	84 c0                	test   %al,%al
80102442:	75 07                	jne    8010244b <skipelem+0x2b>
    return 0;
80102444:	b8 00 00 00 00       	mov    $0x0,%eax
80102449:	eb 77                	jmp    801024c2 <skipelem+0xa2>
  s = path;
8010244b:	8b 45 08             	mov    0x8(%ebp),%eax
8010244e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
80102451:	eb 04                	jmp    80102457 <skipelem+0x37>
    path++;
80102453:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path != '/' && *path != 0)
80102457:	8b 45 08             	mov    0x8(%ebp),%eax
8010245a:	0f b6 00             	movzbl (%eax),%eax
8010245d:	3c 2f                	cmp    $0x2f,%al
8010245f:	74 0a                	je     8010246b <skipelem+0x4b>
80102461:	8b 45 08             	mov    0x8(%ebp),%eax
80102464:	0f b6 00             	movzbl (%eax),%eax
80102467:	84 c0                	test   %al,%al
80102469:	75 e8                	jne    80102453 <skipelem+0x33>
  len = path - s;
8010246b:	8b 45 08             	mov    0x8(%ebp),%eax
8010246e:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102471:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102474:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102478:	7e 15                	jle    8010248f <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
8010247a:	83 ec 04             	sub    $0x4,%esp
8010247d:	6a 0e                	push   $0xe
8010247f:	ff 75 f4             	pushl  -0xc(%ebp)
80102482:	ff 75 0c             	pushl  0xc(%ebp)
80102485:	e8 14 29 00 00       	call   80104d9e <memmove>
8010248a:	83 c4 10             	add    $0x10,%esp
8010248d:	eb 26                	jmp    801024b5 <skipelem+0x95>
  else {
    memmove(name, s, len);
8010248f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102492:	83 ec 04             	sub    $0x4,%esp
80102495:	50                   	push   %eax
80102496:	ff 75 f4             	pushl  -0xc(%ebp)
80102499:	ff 75 0c             	pushl  0xc(%ebp)
8010249c:	e8 fd 28 00 00       	call   80104d9e <memmove>
801024a1:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
801024a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
801024a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801024aa:	01 d0                	add    %edx,%eax
801024ac:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801024af:	eb 04                	jmp    801024b5 <skipelem+0x95>
    path++;
801024b1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
801024b5:	8b 45 08             	mov    0x8(%ebp),%eax
801024b8:	0f b6 00             	movzbl (%eax),%eax
801024bb:	3c 2f                	cmp    $0x2f,%al
801024bd:	74 f2                	je     801024b1 <skipelem+0x91>
  return path;
801024bf:	8b 45 08             	mov    0x8(%ebp),%eax
}
801024c2:	c9                   	leave  
801024c3:	c3                   	ret    

801024c4 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801024c4:	f3 0f 1e fb          	endbr32 
801024c8:	55                   	push   %ebp
801024c9:	89 e5                	mov    %esp,%ebp
801024cb:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
801024ce:	8b 45 08             	mov    0x8(%ebp),%eax
801024d1:	0f b6 00             	movzbl (%eax),%eax
801024d4:	3c 2f                	cmp    $0x2f,%al
801024d6:	75 17                	jne    801024ef <namex+0x2b>
    ip = iget(ROOTDEV, ROOTINO);
801024d8:	83 ec 08             	sub    $0x8,%esp
801024db:	6a 01                	push   $0x1
801024dd:	6a 01                	push   $0x1
801024df:	e8 74 f4 ff ff       	call   80101958 <iget>
801024e4:	83 c4 10             	add    $0x10,%esp
801024e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801024ea:	e9 ba 00 00 00       	jmp    801025a9 <namex+0xe5>
  else
    ip = idup(myproc()->cwd);
801024ef:	e8 b5 16 00 00       	call   80103ba9 <myproc>
801024f4:	8b 40 68             	mov    0x68(%eax),%eax
801024f7:	83 ec 0c             	sub    $0xc,%esp
801024fa:	50                   	push   %eax
801024fb:	e8 3e f5 ff ff       	call   80101a3e <idup>
80102500:	83 c4 10             	add    $0x10,%esp
80102503:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102506:	e9 9e 00 00 00       	jmp    801025a9 <namex+0xe5>
    ilock(ip);
8010250b:	83 ec 0c             	sub    $0xc,%esp
8010250e:	ff 75 f4             	pushl  -0xc(%ebp)
80102511:	e8 66 f5 ff ff       	call   80101a7c <ilock>
80102516:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
80102519:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010251c:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80102520:	66 83 f8 01          	cmp    $0x1,%ax
80102524:	74 18                	je     8010253e <namex+0x7a>
      iunlockput(ip);
80102526:	83 ec 0c             	sub    $0xc,%esp
80102529:	ff 75 f4             	pushl  -0xc(%ebp)
8010252c:	e8 88 f7 ff ff       	call   80101cb9 <iunlockput>
80102531:	83 c4 10             	add    $0x10,%esp
      return 0;
80102534:	b8 00 00 00 00       	mov    $0x0,%eax
80102539:	e9 a7 00 00 00       	jmp    801025e5 <namex+0x121>
    }
    if(nameiparent && *path == '\0'){
8010253e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102542:	74 20                	je     80102564 <namex+0xa0>
80102544:	8b 45 08             	mov    0x8(%ebp),%eax
80102547:	0f b6 00             	movzbl (%eax),%eax
8010254a:	84 c0                	test   %al,%al
8010254c:	75 16                	jne    80102564 <namex+0xa0>
      // Stop one level early.
      iunlock(ip);
8010254e:	83 ec 0c             	sub    $0xc,%esp
80102551:	ff 75 f4             	pushl  -0xc(%ebp)
80102554:	e8 3a f6 ff ff       	call   80101b93 <iunlock>
80102559:	83 c4 10             	add    $0x10,%esp
      return ip;
8010255c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010255f:	e9 81 00 00 00       	jmp    801025e5 <namex+0x121>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102564:	83 ec 04             	sub    $0x4,%esp
80102567:	6a 00                	push   $0x0
80102569:	ff 75 10             	pushl  0x10(%ebp)
8010256c:	ff 75 f4             	pushl  -0xc(%ebp)
8010256f:	e8 12 fd ff ff       	call   80102286 <dirlookup>
80102574:	83 c4 10             	add    $0x10,%esp
80102577:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010257a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010257e:	75 15                	jne    80102595 <namex+0xd1>
      iunlockput(ip);
80102580:	83 ec 0c             	sub    $0xc,%esp
80102583:	ff 75 f4             	pushl  -0xc(%ebp)
80102586:	e8 2e f7 ff ff       	call   80101cb9 <iunlockput>
8010258b:	83 c4 10             	add    $0x10,%esp
      return 0;
8010258e:	b8 00 00 00 00       	mov    $0x0,%eax
80102593:	eb 50                	jmp    801025e5 <namex+0x121>
    }
    iunlockput(ip);
80102595:	83 ec 0c             	sub    $0xc,%esp
80102598:	ff 75 f4             	pushl  -0xc(%ebp)
8010259b:	e8 19 f7 ff ff       	call   80101cb9 <iunlockput>
801025a0:	83 c4 10             	add    $0x10,%esp
    ip = next;
801025a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801025a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while((path = skipelem(path, name)) != 0){
801025a9:	83 ec 08             	sub    $0x8,%esp
801025ac:	ff 75 10             	pushl  0x10(%ebp)
801025af:	ff 75 08             	pushl  0x8(%ebp)
801025b2:	e8 69 fe ff ff       	call   80102420 <skipelem>
801025b7:	83 c4 10             	add    $0x10,%esp
801025ba:	89 45 08             	mov    %eax,0x8(%ebp)
801025bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025c1:	0f 85 44 ff ff ff    	jne    8010250b <namex+0x47>
  }
  if(nameiparent){
801025c7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801025cb:	74 15                	je     801025e2 <namex+0x11e>
    iput(ip);
801025cd:	83 ec 0c             	sub    $0xc,%esp
801025d0:	ff 75 f4             	pushl  -0xc(%ebp)
801025d3:	e8 0d f6 ff ff       	call   80101be5 <iput>
801025d8:	83 c4 10             	add    $0x10,%esp
    return 0;
801025db:	b8 00 00 00 00       	mov    $0x0,%eax
801025e0:	eb 03                	jmp    801025e5 <namex+0x121>
  }
  return ip;
801025e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801025e5:	c9                   	leave  
801025e6:	c3                   	ret    

801025e7 <namei>:

struct inode*
namei(char *path)
{
801025e7:	f3 0f 1e fb          	endbr32 
801025eb:	55                   	push   %ebp
801025ec:	89 e5                	mov    %esp,%ebp
801025ee:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801025f1:	83 ec 04             	sub    $0x4,%esp
801025f4:	8d 45 ea             	lea    -0x16(%ebp),%eax
801025f7:	50                   	push   %eax
801025f8:	6a 00                	push   $0x0
801025fa:	ff 75 08             	pushl  0x8(%ebp)
801025fd:	e8 c2 fe ff ff       	call   801024c4 <namex>
80102602:	83 c4 10             	add    $0x10,%esp
}
80102605:	c9                   	leave  
80102606:	c3                   	ret    

80102607 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102607:	f3 0f 1e fb          	endbr32 
8010260b:	55                   	push   %ebp
8010260c:	89 e5                	mov    %esp,%ebp
8010260e:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80102611:	83 ec 04             	sub    $0x4,%esp
80102614:	ff 75 0c             	pushl  0xc(%ebp)
80102617:	6a 01                	push   $0x1
80102619:	ff 75 08             	pushl  0x8(%ebp)
8010261c:	e8 a3 fe ff ff       	call   801024c4 <namex>
80102621:	83 c4 10             	add    $0x10,%esp
}
80102624:	c9                   	leave  
80102625:	c3                   	ret    

80102626 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102626:	f3 0f 1e fb          	endbr32 
8010262a:	55                   	push   %ebp
8010262b:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010262d:	a1 d4 53 19 80       	mov    0x801953d4,%eax
80102632:	8b 55 08             	mov    0x8(%ebp),%edx
80102635:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102637:	a1 d4 53 19 80       	mov    0x801953d4,%eax
8010263c:	8b 40 10             	mov    0x10(%eax),%eax
}
8010263f:	5d                   	pop    %ebp
80102640:	c3                   	ret    

80102641 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102641:	f3 0f 1e fb          	endbr32 
80102645:	55                   	push   %ebp
80102646:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102648:	a1 d4 53 19 80       	mov    0x801953d4,%eax
8010264d:	8b 55 08             	mov    0x8(%ebp),%edx
80102650:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102652:	a1 d4 53 19 80       	mov    0x801953d4,%eax
80102657:	8b 55 0c             	mov    0xc(%ebp),%edx
8010265a:	89 50 10             	mov    %edx,0x10(%eax)
}
8010265d:	90                   	nop
8010265e:	5d                   	pop    %ebp
8010265f:	c3                   	ret    

80102660 <ioapicinit>:

void
ioapicinit(void)
{
80102660:	f3 0f 1e fb          	endbr32 
80102664:	55                   	push   %ebp
80102665:	89 e5                	mov    %esp,%ebp
80102667:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
8010266a:	c7 05 d4 53 19 80 00 	movl   $0xfec00000,0x801953d4
80102671:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102674:	6a 01                	push   $0x1
80102676:	e8 ab ff ff ff       	call   80102626 <ioapicread>
8010267b:	83 c4 04             	add    $0x4,%esp
8010267e:	c1 e8 10             	shr    $0x10,%eax
80102681:	25 ff 00 00 00       	and    $0xff,%eax
80102686:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102689:	6a 00                	push   $0x0
8010268b:	e8 96 ff ff ff       	call   80102626 <ioapicread>
80102690:	83 c4 04             	add    $0x4,%esp
80102693:	c1 e8 18             	shr    $0x18,%eax
80102696:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102699:	0f b6 05 a0 7c 19 80 	movzbl 0x80197ca0,%eax
801026a0:	0f b6 c0             	movzbl %al,%eax
801026a3:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801026a6:	74 10                	je     801026b8 <ioapicinit+0x58>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801026a8:	83 ec 0c             	sub    $0xc,%esp
801026ab:	68 74 a8 10 80       	push   $0x8010a874
801026b0:	e8 57 dd ff ff       	call   8010040c <cprintf>
801026b5:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801026b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801026bf:	eb 3f                	jmp    80102700 <ioapicinit+0xa0>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801026c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026c4:	83 c0 20             	add    $0x20,%eax
801026c7:	0d 00 00 01 00       	or     $0x10000,%eax
801026cc:	89 c2                	mov    %eax,%edx
801026ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026d1:	83 c0 08             	add    $0x8,%eax
801026d4:	01 c0                	add    %eax,%eax
801026d6:	83 ec 08             	sub    $0x8,%esp
801026d9:	52                   	push   %edx
801026da:	50                   	push   %eax
801026db:	e8 61 ff ff ff       	call   80102641 <ioapicwrite>
801026e0:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
801026e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026e6:	83 c0 08             	add    $0x8,%eax
801026e9:	01 c0                	add    %eax,%eax
801026eb:	83 c0 01             	add    $0x1,%eax
801026ee:	83 ec 08             	sub    $0x8,%esp
801026f1:	6a 00                	push   $0x0
801026f3:	50                   	push   %eax
801026f4:	e8 48 ff ff ff       	call   80102641 <ioapicwrite>
801026f9:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i <= maxintr; i++){
801026fc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102700:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102703:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102706:	7e b9                	jle    801026c1 <ioapicinit+0x61>
  }
}
80102708:	90                   	nop
80102709:	90                   	nop
8010270a:	c9                   	leave  
8010270b:	c3                   	ret    

8010270c <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
8010270c:	f3 0f 1e fb          	endbr32 
80102710:	55                   	push   %ebp
80102711:	89 e5                	mov    %esp,%ebp
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102713:	8b 45 08             	mov    0x8(%ebp),%eax
80102716:	83 c0 20             	add    $0x20,%eax
80102719:	89 c2                	mov    %eax,%edx
8010271b:	8b 45 08             	mov    0x8(%ebp),%eax
8010271e:	83 c0 08             	add    $0x8,%eax
80102721:	01 c0                	add    %eax,%eax
80102723:	52                   	push   %edx
80102724:	50                   	push   %eax
80102725:	e8 17 ff ff ff       	call   80102641 <ioapicwrite>
8010272a:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010272d:	8b 45 0c             	mov    0xc(%ebp),%eax
80102730:	c1 e0 18             	shl    $0x18,%eax
80102733:	89 c2                	mov    %eax,%edx
80102735:	8b 45 08             	mov    0x8(%ebp),%eax
80102738:	83 c0 08             	add    $0x8,%eax
8010273b:	01 c0                	add    %eax,%eax
8010273d:	83 c0 01             	add    $0x1,%eax
80102740:	52                   	push   %edx
80102741:	50                   	push   %eax
80102742:	e8 fa fe ff ff       	call   80102641 <ioapicwrite>
80102747:	83 c4 08             	add    $0x8,%esp
}
8010274a:	90                   	nop
8010274b:	c9                   	leave  
8010274c:	c3                   	ret    

8010274d <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
8010274d:	f3 0f 1e fb          	endbr32 
80102751:	55                   	push   %ebp
80102752:	89 e5                	mov    %esp,%ebp
80102754:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102757:	83 ec 08             	sub    $0x8,%esp
8010275a:	68 a6 a8 10 80       	push   $0x8010a8a6
8010275f:	68 e0 53 19 80       	push   $0x801953e0
80102764:	e8 b9 22 00 00       	call   80104a22 <initlock>
80102769:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
8010276c:	c7 05 14 54 19 80 00 	movl   $0x0,0x80195414
80102773:	00 00 00 
  freerange(vstart, vend);
80102776:	83 ec 08             	sub    $0x8,%esp
80102779:	ff 75 0c             	pushl  0xc(%ebp)
8010277c:	ff 75 08             	pushl  0x8(%ebp)
8010277f:	e8 2e 00 00 00       	call   801027b2 <freerange>
80102784:	83 c4 10             	add    $0x10,%esp
}
80102787:	90                   	nop
80102788:	c9                   	leave  
80102789:	c3                   	ret    

8010278a <kinit2>:

void
kinit2(void *vstart, void *vend)
{
8010278a:	f3 0f 1e fb          	endbr32 
8010278e:	55                   	push   %ebp
8010278f:	89 e5                	mov    %esp,%ebp
80102791:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102794:	83 ec 08             	sub    $0x8,%esp
80102797:	ff 75 0c             	pushl  0xc(%ebp)
8010279a:	ff 75 08             	pushl  0x8(%ebp)
8010279d:	e8 10 00 00 00       	call   801027b2 <freerange>
801027a2:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
801027a5:	c7 05 14 54 19 80 01 	movl   $0x1,0x80195414
801027ac:	00 00 00 
}
801027af:	90                   	nop
801027b0:	c9                   	leave  
801027b1:	c3                   	ret    

801027b2 <freerange>:

void
freerange(void *vstart, void *vend)
{
801027b2:	f3 0f 1e fb          	endbr32 
801027b6:	55                   	push   %ebp
801027b7:	89 e5                	mov    %esp,%ebp
801027b9:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801027bc:	8b 45 08             	mov    0x8(%ebp),%eax
801027bf:	05 ff 0f 00 00       	add    $0xfff,%eax
801027c4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801027c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027cc:	eb 15                	jmp    801027e3 <freerange+0x31>
    kfree(p);
801027ce:	83 ec 0c             	sub    $0xc,%esp
801027d1:	ff 75 f4             	pushl  -0xc(%ebp)
801027d4:	e8 1b 00 00 00       	call   801027f4 <kfree>
801027d9:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027dc:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801027e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027e6:	05 00 10 00 00       	add    $0x1000,%eax
801027eb:	39 45 0c             	cmp    %eax,0xc(%ebp)
801027ee:	73 de                	jae    801027ce <freerange+0x1c>
}
801027f0:	90                   	nop
801027f1:	90                   	nop
801027f2:	c9                   	leave  
801027f3:	c3                   	ret    

801027f4 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801027f4:	f3 0f 1e fb          	endbr32 
801027f8:	55                   	push   %ebp
801027f9:	89 e5                	mov    %esp,%ebp
801027fb:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801027fe:	8b 45 08             	mov    0x8(%ebp),%eax
80102801:	25 ff 0f 00 00       	and    $0xfff,%eax
80102806:	85 c0                	test   %eax,%eax
80102808:	75 18                	jne    80102822 <kfree+0x2e>
8010280a:	81 7d 08 00 80 19 80 	cmpl   $0x80198000,0x8(%ebp)
80102811:	72 0f                	jb     80102822 <kfree+0x2e>
80102813:	8b 45 08             	mov    0x8(%ebp),%eax
80102816:	05 00 00 00 80       	add    $0x80000000,%eax
8010281b:	3d ff ff ff 1f       	cmp    $0x1fffffff,%eax
80102820:	76 0d                	jbe    8010282f <kfree+0x3b>
    panic("kfree");
80102822:	83 ec 0c             	sub    $0xc,%esp
80102825:	68 ab a8 10 80       	push   $0x8010a8ab
8010282a:	e8 96 dd ff ff       	call   801005c5 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010282f:	83 ec 04             	sub    $0x4,%esp
80102832:	68 00 10 00 00       	push   $0x1000
80102837:	6a 01                	push   $0x1
80102839:	ff 75 08             	pushl  0x8(%ebp)
8010283c:	e8 96 24 00 00       	call   80104cd7 <memset>
80102841:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102844:	a1 14 54 19 80       	mov    0x80195414,%eax
80102849:	85 c0                	test   %eax,%eax
8010284b:	74 10                	je     8010285d <kfree+0x69>
    acquire(&kmem.lock);
8010284d:	83 ec 0c             	sub    $0xc,%esp
80102850:	68 e0 53 19 80       	push   $0x801953e0
80102855:	e8 ee 21 00 00       	call   80104a48 <acquire>
8010285a:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
8010285d:	8b 45 08             	mov    0x8(%ebp),%eax
80102860:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102863:	8b 15 18 54 19 80    	mov    0x80195418,%edx
80102869:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010286c:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
8010286e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102871:	a3 18 54 19 80       	mov    %eax,0x80195418
  if(kmem.use_lock)
80102876:	a1 14 54 19 80       	mov    0x80195414,%eax
8010287b:	85 c0                	test   %eax,%eax
8010287d:	74 10                	je     8010288f <kfree+0x9b>
    release(&kmem.lock);
8010287f:	83 ec 0c             	sub    $0xc,%esp
80102882:	68 e0 53 19 80       	push   $0x801953e0
80102887:	e8 2e 22 00 00       	call   80104aba <release>
8010288c:	83 c4 10             	add    $0x10,%esp
}
8010288f:	90                   	nop
80102890:	c9                   	leave  
80102891:	c3                   	ret    

80102892 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102892:	f3 0f 1e fb          	endbr32 
80102896:	55                   	push   %ebp
80102897:	89 e5                	mov    %esp,%ebp
80102899:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
8010289c:	a1 14 54 19 80       	mov    0x80195414,%eax
801028a1:	85 c0                	test   %eax,%eax
801028a3:	74 10                	je     801028b5 <kalloc+0x23>
    acquire(&kmem.lock);
801028a5:	83 ec 0c             	sub    $0xc,%esp
801028a8:	68 e0 53 19 80       	push   $0x801953e0
801028ad:	e8 96 21 00 00       	call   80104a48 <acquire>
801028b2:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
801028b5:	a1 18 54 19 80       	mov    0x80195418,%eax
801028ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
801028bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801028c1:	74 0a                	je     801028cd <kalloc+0x3b>
    kmem.freelist = r->next;
801028c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028c6:	8b 00                	mov    (%eax),%eax
801028c8:	a3 18 54 19 80       	mov    %eax,0x80195418
  if(kmem.use_lock)
801028cd:	a1 14 54 19 80       	mov    0x80195414,%eax
801028d2:	85 c0                	test   %eax,%eax
801028d4:	74 10                	je     801028e6 <kalloc+0x54>
    release(&kmem.lock);
801028d6:	83 ec 0c             	sub    $0xc,%esp
801028d9:	68 e0 53 19 80       	push   $0x801953e0
801028de:	e8 d7 21 00 00       	call   80104aba <release>
801028e3:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
801028e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801028e9:	c9                   	leave  
801028ea:	c3                   	ret    

801028eb <inb>:
{
801028eb:	55                   	push   %ebp
801028ec:	89 e5                	mov    %esp,%ebp
801028ee:	83 ec 14             	sub    $0x14,%esp
801028f1:	8b 45 08             	mov    0x8(%ebp),%eax
801028f4:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028f8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801028fc:	89 c2                	mov    %eax,%edx
801028fe:	ec                   	in     (%dx),%al
801028ff:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102902:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102906:	c9                   	leave  
80102907:	c3                   	ret    

80102908 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102908:	f3 0f 1e fb          	endbr32 
8010290c:	55                   	push   %ebp
8010290d:	89 e5                	mov    %esp,%ebp
8010290f:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102912:	6a 64                	push   $0x64
80102914:	e8 d2 ff ff ff       	call   801028eb <inb>
80102919:	83 c4 04             	add    $0x4,%esp
8010291c:	0f b6 c0             	movzbl %al,%eax
8010291f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102922:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102925:	83 e0 01             	and    $0x1,%eax
80102928:	85 c0                	test   %eax,%eax
8010292a:	75 0a                	jne    80102936 <kbdgetc+0x2e>
    return -1;
8010292c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102931:	e9 23 01 00 00       	jmp    80102a59 <kbdgetc+0x151>
  data = inb(KBDATAP);
80102936:	6a 60                	push   $0x60
80102938:	e8 ae ff ff ff       	call   801028eb <inb>
8010293d:	83 c4 04             	add    $0x4,%esp
80102940:	0f b6 c0             	movzbl %al,%eax
80102943:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102946:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
8010294d:	75 17                	jne    80102966 <kbdgetc+0x5e>
    shift |= E0ESC;
8010294f:	a1 58 d0 18 80       	mov    0x8018d058,%eax
80102954:	83 c8 40             	or     $0x40,%eax
80102957:	a3 58 d0 18 80       	mov    %eax,0x8018d058
    return 0;
8010295c:	b8 00 00 00 00       	mov    $0x0,%eax
80102961:	e9 f3 00 00 00       	jmp    80102a59 <kbdgetc+0x151>
  } else if(data & 0x80){
80102966:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102969:	25 80 00 00 00       	and    $0x80,%eax
8010296e:	85 c0                	test   %eax,%eax
80102970:	74 45                	je     801029b7 <kbdgetc+0xaf>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102972:	a1 58 d0 18 80       	mov    0x8018d058,%eax
80102977:	83 e0 40             	and    $0x40,%eax
8010297a:	85 c0                	test   %eax,%eax
8010297c:	75 08                	jne    80102986 <kbdgetc+0x7e>
8010297e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102981:	83 e0 7f             	and    $0x7f,%eax
80102984:	eb 03                	jmp    80102989 <kbdgetc+0x81>
80102986:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102989:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
8010298c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010298f:	05 20 d0 10 80       	add    $0x8010d020,%eax
80102994:	0f b6 00             	movzbl (%eax),%eax
80102997:	83 c8 40             	or     $0x40,%eax
8010299a:	0f b6 c0             	movzbl %al,%eax
8010299d:	f7 d0                	not    %eax
8010299f:	89 c2                	mov    %eax,%edx
801029a1:	a1 58 d0 18 80       	mov    0x8018d058,%eax
801029a6:	21 d0                	and    %edx,%eax
801029a8:	a3 58 d0 18 80       	mov    %eax,0x8018d058
    return 0;
801029ad:	b8 00 00 00 00       	mov    $0x0,%eax
801029b2:	e9 a2 00 00 00       	jmp    80102a59 <kbdgetc+0x151>
  } else if(shift & E0ESC){
801029b7:	a1 58 d0 18 80       	mov    0x8018d058,%eax
801029bc:	83 e0 40             	and    $0x40,%eax
801029bf:	85 c0                	test   %eax,%eax
801029c1:	74 14                	je     801029d7 <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801029c3:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
801029ca:	a1 58 d0 18 80       	mov    0x8018d058,%eax
801029cf:	83 e0 bf             	and    $0xffffffbf,%eax
801029d2:	a3 58 d0 18 80       	mov    %eax,0x8018d058
  }

  shift |= shiftcode[data];
801029d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801029da:	05 20 d0 10 80       	add    $0x8010d020,%eax
801029df:	0f b6 00             	movzbl (%eax),%eax
801029e2:	0f b6 d0             	movzbl %al,%edx
801029e5:	a1 58 d0 18 80       	mov    0x8018d058,%eax
801029ea:	09 d0                	or     %edx,%eax
801029ec:	a3 58 d0 18 80       	mov    %eax,0x8018d058
  shift ^= togglecode[data];
801029f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801029f4:	05 20 d1 10 80       	add    $0x8010d120,%eax
801029f9:	0f b6 00             	movzbl (%eax),%eax
801029fc:	0f b6 d0             	movzbl %al,%edx
801029ff:	a1 58 d0 18 80       	mov    0x8018d058,%eax
80102a04:	31 d0                	xor    %edx,%eax
80102a06:	a3 58 d0 18 80       	mov    %eax,0x8018d058
  c = charcode[shift & (CTL | SHIFT)][data];
80102a0b:	a1 58 d0 18 80       	mov    0x8018d058,%eax
80102a10:	83 e0 03             	and    $0x3,%eax
80102a13:	8b 14 85 20 d5 10 80 	mov    -0x7fef2ae0(,%eax,4),%edx
80102a1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102a1d:	01 d0                	add    %edx,%eax
80102a1f:	0f b6 00             	movzbl (%eax),%eax
80102a22:	0f b6 c0             	movzbl %al,%eax
80102a25:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102a28:	a1 58 d0 18 80       	mov    0x8018d058,%eax
80102a2d:	83 e0 08             	and    $0x8,%eax
80102a30:	85 c0                	test   %eax,%eax
80102a32:	74 22                	je     80102a56 <kbdgetc+0x14e>
    if('a' <= c && c <= 'z')
80102a34:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102a38:	76 0c                	jbe    80102a46 <kbdgetc+0x13e>
80102a3a:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102a3e:	77 06                	ja     80102a46 <kbdgetc+0x13e>
      c += 'A' - 'a';
80102a40:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102a44:	eb 10                	jmp    80102a56 <kbdgetc+0x14e>
    else if('A' <= c && c <= 'Z')
80102a46:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102a4a:	76 0a                	jbe    80102a56 <kbdgetc+0x14e>
80102a4c:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102a50:	77 04                	ja     80102a56 <kbdgetc+0x14e>
      c += 'a' - 'A';
80102a52:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102a56:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102a59:	c9                   	leave  
80102a5a:	c3                   	ret    

80102a5b <kbdintr>:

void
kbdintr(void)
{
80102a5b:	f3 0f 1e fb          	endbr32 
80102a5f:	55                   	push   %ebp
80102a60:	89 e5                	mov    %esp,%ebp
80102a62:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102a65:	83 ec 0c             	sub    $0xc,%esp
80102a68:	68 08 29 10 80       	push   $0x80102908
80102a6d:	e8 8e dd ff ff       	call   80100800 <consoleintr>
80102a72:	83 c4 10             	add    $0x10,%esp
}
80102a75:	90                   	nop
80102a76:	c9                   	leave  
80102a77:	c3                   	ret    

80102a78 <inb>:
{
80102a78:	55                   	push   %ebp
80102a79:	89 e5                	mov    %esp,%ebp
80102a7b:	83 ec 14             	sub    $0x14,%esp
80102a7e:	8b 45 08             	mov    0x8(%ebp),%eax
80102a81:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a85:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102a89:	89 c2                	mov    %eax,%edx
80102a8b:	ec                   	in     (%dx),%al
80102a8c:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102a8f:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102a93:	c9                   	leave  
80102a94:	c3                   	ret    

80102a95 <outb>:
{
80102a95:	55                   	push   %ebp
80102a96:	89 e5                	mov    %esp,%ebp
80102a98:	83 ec 08             	sub    $0x8,%esp
80102a9b:	8b 45 08             	mov    0x8(%ebp),%eax
80102a9e:	8b 55 0c             	mov    0xc(%ebp),%edx
80102aa1:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80102aa5:	89 d0                	mov    %edx,%eax
80102aa7:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aaa:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102aae:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102ab2:	ee                   	out    %al,(%dx)
}
80102ab3:	90                   	nop
80102ab4:	c9                   	leave  
80102ab5:	c3                   	ret    

80102ab6 <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

//PAGEBREAK!
static void
lapicw(int index, int value)
{
80102ab6:	f3 0f 1e fb          	endbr32 
80102aba:	55                   	push   %ebp
80102abb:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102abd:	a1 1c 54 19 80       	mov    0x8019541c,%eax
80102ac2:	8b 55 08             	mov    0x8(%ebp),%edx
80102ac5:	c1 e2 02             	shl    $0x2,%edx
80102ac8:	01 c2                	add    %eax,%edx
80102aca:	8b 45 0c             	mov    0xc(%ebp),%eax
80102acd:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102acf:	a1 1c 54 19 80       	mov    0x8019541c,%eax
80102ad4:	83 c0 20             	add    $0x20,%eax
80102ad7:	8b 00                	mov    (%eax),%eax
}
80102ad9:	90                   	nop
80102ada:	5d                   	pop    %ebp
80102adb:	c3                   	ret    

80102adc <lapicinit>:

void
lapicinit(void)
{
80102adc:	f3 0f 1e fb          	endbr32 
80102ae0:	55                   	push   %ebp
80102ae1:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102ae3:	a1 1c 54 19 80       	mov    0x8019541c,%eax
80102ae8:	85 c0                	test   %eax,%eax
80102aea:	0f 84 0c 01 00 00    	je     80102bfc <lapicinit+0x120>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102af0:	68 3f 01 00 00       	push   $0x13f
80102af5:	6a 3c                	push   $0x3c
80102af7:	e8 ba ff ff ff       	call   80102ab6 <lapicw>
80102afc:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102aff:	6a 0b                	push   $0xb
80102b01:	68 f8 00 00 00       	push   $0xf8
80102b06:	e8 ab ff ff ff       	call   80102ab6 <lapicw>
80102b0b:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102b0e:	68 20 00 02 00       	push   $0x20020
80102b13:	68 c8 00 00 00       	push   $0xc8
80102b18:	e8 99 ff ff ff       	call   80102ab6 <lapicw>
80102b1d:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000);
80102b20:	68 80 96 98 00       	push   $0x989680
80102b25:	68 e0 00 00 00       	push   $0xe0
80102b2a:	e8 87 ff ff ff       	call   80102ab6 <lapicw>
80102b2f:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102b32:	68 00 00 01 00       	push   $0x10000
80102b37:	68 d4 00 00 00       	push   $0xd4
80102b3c:	e8 75 ff ff ff       	call   80102ab6 <lapicw>
80102b41:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102b44:	68 00 00 01 00       	push   $0x10000
80102b49:	68 d8 00 00 00       	push   $0xd8
80102b4e:	e8 63 ff ff ff       	call   80102ab6 <lapicw>
80102b53:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102b56:	a1 1c 54 19 80       	mov    0x8019541c,%eax
80102b5b:	83 c0 30             	add    $0x30,%eax
80102b5e:	8b 00                	mov    (%eax),%eax
80102b60:	c1 e8 10             	shr    $0x10,%eax
80102b63:	25 fc 00 00 00       	and    $0xfc,%eax
80102b68:	85 c0                	test   %eax,%eax
80102b6a:	74 12                	je     80102b7e <lapicinit+0xa2>
    lapicw(PCINT, MASKED);
80102b6c:	68 00 00 01 00       	push   $0x10000
80102b71:	68 d0 00 00 00       	push   $0xd0
80102b76:	e8 3b ff ff ff       	call   80102ab6 <lapicw>
80102b7b:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102b7e:	6a 33                	push   $0x33
80102b80:	68 dc 00 00 00       	push   $0xdc
80102b85:	e8 2c ff ff ff       	call   80102ab6 <lapicw>
80102b8a:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102b8d:	6a 00                	push   $0x0
80102b8f:	68 a0 00 00 00       	push   $0xa0
80102b94:	e8 1d ff ff ff       	call   80102ab6 <lapicw>
80102b99:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80102b9c:	6a 00                	push   $0x0
80102b9e:	68 a0 00 00 00       	push   $0xa0
80102ba3:	e8 0e ff ff ff       	call   80102ab6 <lapicw>
80102ba8:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102bab:	6a 00                	push   $0x0
80102bad:	6a 2c                	push   $0x2c
80102baf:	e8 02 ff ff ff       	call   80102ab6 <lapicw>
80102bb4:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102bb7:	6a 00                	push   $0x0
80102bb9:	68 c4 00 00 00       	push   $0xc4
80102bbe:	e8 f3 fe ff ff       	call   80102ab6 <lapicw>
80102bc3:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102bc6:	68 00 85 08 00       	push   $0x88500
80102bcb:	68 c0 00 00 00       	push   $0xc0
80102bd0:	e8 e1 fe ff ff       	call   80102ab6 <lapicw>
80102bd5:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80102bd8:	90                   	nop
80102bd9:	a1 1c 54 19 80       	mov    0x8019541c,%eax
80102bde:	05 00 03 00 00       	add    $0x300,%eax
80102be3:	8b 00                	mov    (%eax),%eax
80102be5:	25 00 10 00 00       	and    $0x1000,%eax
80102bea:	85 c0                	test   %eax,%eax
80102bec:	75 eb                	jne    80102bd9 <lapicinit+0xfd>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102bee:	6a 00                	push   $0x0
80102bf0:	6a 20                	push   $0x20
80102bf2:	e8 bf fe ff ff       	call   80102ab6 <lapicw>
80102bf7:	83 c4 08             	add    $0x8,%esp
80102bfa:	eb 01                	jmp    80102bfd <lapicinit+0x121>
    return;
80102bfc:	90                   	nop
}
80102bfd:	c9                   	leave  
80102bfe:	c3                   	ret    

80102bff <lapicid>:

int
lapicid(void)
{
80102bff:	f3 0f 1e fb          	endbr32 
80102c03:	55                   	push   %ebp
80102c04:	89 e5                	mov    %esp,%ebp

  if (!lapic){
80102c06:	a1 1c 54 19 80       	mov    0x8019541c,%eax
80102c0b:	85 c0                	test   %eax,%eax
80102c0d:	75 07                	jne    80102c16 <lapicid+0x17>
    return 0;
80102c0f:	b8 00 00 00 00       	mov    $0x0,%eax
80102c14:	eb 0d                	jmp    80102c23 <lapicid+0x24>
  }
  return lapic[ID] >> 24;
80102c16:	a1 1c 54 19 80       	mov    0x8019541c,%eax
80102c1b:	83 c0 20             	add    $0x20,%eax
80102c1e:	8b 00                	mov    (%eax),%eax
80102c20:	c1 e8 18             	shr    $0x18,%eax
}
80102c23:	5d                   	pop    %ebp
80102c24:	c3                   	ret    

80102c25 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102c25:	f3 0f 1e fb          	endbr32 
80102c29:	55                   	push   %ebp
80102c2a:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102c2c:	a1 1c 54 19 80       	mov    0x8019541c,%eax
80102c31:	85 c0                	test   %eax,%eax
80102c33:	74 0c                	je     80102c41 <lapiceoi+0x1c>
    lapicw(EOI, 0);
80102c35:	6a 00                	push   $0x0
80102c37:	6a 2c                	push   $0x2c
80102c39:	e8 78 fe ff ff       	call   80102ab6 <lapicw>
80102c3e:	83 c4 08             	add    $0x8,%esp
}
80102c41:	90                   	nop
80102c42:	c9                   	leave  
80102c43:	c3                   	ret    

80102c44 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102c44:	f3 0f 1e fb          	endbr32 
80102c48:	55                   	push   %ebp
80102c49:	89 e5                	mov    %esp,%ebp
}
80102c4b:	90                   	nop
80102c4c:	5d                   	pop    %ebp
80102c4d:	c3                   	ret    

80102c4e <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102c4e:	f3 0f 1e fb          	endbr32 
80102c52:	55                   	push   %ebp
80102c53:	89 e5                	mov    %esp,%ebp
80102c55:	83 ec 14             	sub    $0x14,%esp
80102c58:	8b 45 08             	mov    0x8(%ebp),%eax
80102c5b:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80102c5e:	6a 0f                	push   $0xf
80102c60:	6a 70                	push   $0x70
80102c62:	e8 2e fe ff ff       	call   80102a95 <outb>
80102c67:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
80102c6a:	6a 0a                	push   $0xa
80102c6c:	6a 71                	push   $0x71
80102c6e:	e8 22 fe ff ff       	call   80102a95 <outb>
80102c73:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102c76:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102c7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102c80:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102c85:	8b 45 0c             	mov    0xc(%ebp),%eax
80102c88:	c1 e8 04             	shr    $0x4,%eax
80102c8b:	89 c2                	mov    %eax,%edx
80102c8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102c90:	83 c0 02             	add    $0x2,%eax
80102c93:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102c96:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102c9a:	c1 e0 18             	shl    $0x18,%eax
80102c9d:	50                   	push   %eax
80102c9e:	68 c4 00 00 00       	push   $0xc4
80102ca3:	e8 0e fe ff ff       	call   80102ab6 <lapicw>
80102ca8:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102cab:	68 00 c5 00 00       	push   $0xc500
80102cb0:	68 c0 00 00 00       	push   $0xc0
80102cb5:	e8 fc fd ff ff       	call   80102ab6 <lapicw>
80102cba:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80102cbd:	68 c8 00 00 00       	push   $0xc8
80102cc2:	e8 7d ff ff ff       	call   80102c44 <microdelay>
80102cc7:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
80102cca:	68 00 85 00 00       	push   $0x8500
80102ccf:	68 c0 00 00 00       	push   $0xc0
80102cd4:	e8 dd fd ff ff       	call   80102ab6 <lapicw>
80102cd9:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80102cdc:	6a 64                	push   $0x64
80102cde:	e8 61 ff ff ff       	call   80102c44 <microdelay>
80102ce3:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102ce6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80102ced:	eb 3d                	jmp    80102d2c <lapicstartap+0xde>
    lapicw(ICRHI, apicid<<24);
80102cef:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102cf3:	c1 e0 18             	shl    $0x18,%eax
80102cf6:	50                   	push   %eax
80102cf7:	68 c4 00 00 00       	push   $0xc4
80102cfc:	e8 b5 fd ff ff       	call   80102ab6 <lapicw>
80102d01:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
80102d04:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d07:	c1 e8 0c             	shr    $0xc,%eax
80102d0a:	80 cc 06             	or     $0x6,%ah
80102d0d:	50                   	push   %eax
80102d0e:	68 c0 00 00 00       	push   $0xc0
80102d13:	e8 9e fd ff ff       	call   80102ab6 <lapicw>
80102d18:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
80102d1b:	68 c8 00 00 00       	push   $0xc8
80102d20:	e8 1f ff ff ff       	call   80102c44 <microdelay>
80102d25:	83 c4 04             	add    $0x4,%esp
  for(i = 0; i < 2; i++){
80102d28:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80102d2c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80102d30:	7e bd                	jle    80102cef <lapicstartap+0xa1>
  }
}
80102d32:	90                   	nop
80102d33:	90                   	nop
80102d34:	c9                   	leave  
80102d35:	c3                   	ret    

80102d36 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
80102d36:	f3 0f 1e fb          	endbr32 
80102d3a:	55                   	push   %ebp
80102d3b:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
80102d3d:	8b 45 08             	mov    0x8(%ebp),%eax
80102d40:	0f b6 c0             	movzbl %al,%eax
80102d43:	50                   	push   %eax
80102d44:	6a 70                	push   $0x70
80102d46:	e8 4a fd ff ff       	call   80102a95 <outb>
80102d4b:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80102d4e:	68 c8 00 00 00       	push   $0xc8
80102d53:	e8 ec fe ff ff       	call   80102c44 <microdelay>
80102d58:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
80102d5b:	6a 71                	push   $0x71
80102d5d:	e8 16 fd ff ff       	call   80102a78 <inb>
80102d62:	83 c4 04             	add    $0x4,%esp
80102d65:	0f b6 c0             	movzbl %al,%eax
}
80102d68:	c9                   	leave  
80102d69:	c3                   	ret    

80102d6a <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
80102d6a:	f3 0f 1e fb          	endbr32 
80102d6e:	55                   	push   %ebp
80102d6f:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
80102d71:	6a 00                	push   $0x0
80102d73:	e8 be ff ff ff       	call   80102d36 <cmos_read>
80102d78:	83 c4 04             	add    $0x4,%esp
80102d7b:	8b 55 08             	mov    0x8(%ebp),%edx
80102d7e:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
80102d80:	6a 02                	push   $0x2
80102d82:	e8 af ff ff ff       	call   80102d36 <cmos_read>
80102d87:	83 c4 04             	add    $0x4,%esp
80102d8a:	8b 55 08             	mov    0x8(%ebp),%edx
80102d8d:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
80102d90:	6a 04                	push   $0x4
80102d92:	e8 9f ff ff ff       	call   80102d36 <cmos_read>
80102d97:	83 c4 04             	add    $0x4,%esp
80102d9a:	8b 55 08             	mov    0x8(%ebp),%edx
80102d9d:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
80102da0:	6a 07                	push   $0x7
80102da2:	e8 8f ff ff ff       	call   80102d36 <cmos_read>
80102da7:	83 c4 04             	add    $0x4,%esp
80102daa:	8b 55 08             	mov    0x8(%ebp),%edx
80102dad:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
80102db0:	6a 08                	push   $0x8
80102db2:	e8 7f ff ff ff       	call   80102d36 <cmos_read>
80102db7:	83 c4 04             	add    $0x4,%esp
80102dba:	8b 55 08             	mov    0x8(%ebp),%edx
80102dbd:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
80102dc0:	6a 09                	push   $0x9
80102dc2:	e8 6f ff ff ff       	call   80102d36 <cmos_read>
80102dc7:	83 c4 04             	add    $0x4,%esp
80102dca:	8b 55 08             	mov    0x8(%ebp),%edx
80102dcd:	89 42 14             	mov    %eax,0x14(%edx)
}
80102dd0:	90                   	nop
80102dd1:	c9                   	leave  
80102dd2:	c3                   	ret    

80102dd3 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102dd3:	f3 0f 1e fb          	endbr32 
80102dd7:	55                   	push   %ebp
80102dd8:	89 e5                	mov    %esp,%ebp
80102dda:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80102ddd:	6a 0b                	push   $0xb
80102ddf:	e8 52 ff ff ff       	call   80102d36 <cmos_read>
80102de4:	83 c4 04             	add    $0x4,%esp
80102de7:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80102dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ded:	83 e0 04             	and    $0x4,%eax
80102df0:	85 c0                	test   %eax,%eax
80102df2:	0f 94 c0             	sete   %al
80102df5:	0f b6 c0             	movzbl %al,%eax
80102df8:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
80102dfb:	8d 45 d8             	lea    -0x28(%ebp),%eax
80102dfe:	50                   	push   %eax
80102dff:	e8 66 ff ff ff       	call   80102d6a <fill_rtcdate>
80102e04:	83 c4 04             	add    $0x4,%esp
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102e07:	6a 0a                	push   $0xa
80102e09:	e8 28 ff ff ff       	call   80102d36 <cmos_read>
80102e0e:	83 c4 04             	add    $0x4,%esp
80102e11:	25 80 00 00 00       	and    $0x80,%eax
80102e16:	85 c0                	test   %eax,%eax
80102e18:	75 27                	jne    80102e41 <cmostime+0x6e>
        continue;
    fill_rtcdate(&t2);
80102e1a:	8d 45 c0             	lea    -0x40(%ebp),%eax
80102e1d:	50                   	push   %eax
80102e1e:	e8 47 ff ff ff       	call   80102d6a <fill_rtcdate>
80102e23:	83 c4 04             	add    $0x4,%esp
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102e26:	83 ec 04             	sub    $0x4,%esp
80102e29:	6a 18                	push   $0x18
80102e2b:	8d 45 c0             	lea    -0x40(%ebp),%eax
80102e2e:	50                   	push   %eax
80102e2f:	8d 45 d8             	lea    -0x28(%ebp),%eax
80102e32:	50                   	push   %eax
80102e33:	e8 0a 1f 00 00       	call   80104d42 <memcmp>
80102e38:	83 c4 10             	add    $0x10,%esp
80102e3b:	85 c0                	test   %eax,%eax
80102e3d:	74 05                	je     80102e44 <cmostime+0x71>
80102e3f:	eb ba                	jmp    80102dfb <cmostime+0x28>
        continue;
80102e41:	90                   	nop
    fill_rtcdate(&t1);
80102e42:	eb b7                	jmp    80102dfb <cmostime+0x28>
      break;
80102e44:	90                   	nop
  }

  // convert
  if(bcd) {
80102e45:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102e49:	0f 84 b4 00 00 00    	je     80102f03 <cmostime+0x130>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102e4f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102e52:	c1 e8 04             	shr    $0x4,%eax
80102e55:	89 c2                	mov    %eax,%edx
80102e57:	89 d0                	mov    %edx,%eax
80102e59:	c1 e0 02             	shl    $0x2,%eax
80102e5c:	01 d0                	add    %edx,%eax
80102e5e:	01 c0                	add    %eax,%eax
80102e60:	89 c2                	mov    %eax,%edx
80102e62:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102e65:	83 e0 0f             	and    $0xf,%eax
80102e68:	01 d0                	add    %edx,%eax
80102e6a:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80102e6d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102e70:	c1 e8 04             	shr    $0x4,%eax
80102e73:	89 c2                	mov    %eax,%edx
80102e75:	89 d0                	mov    %edx,%eax
80102e77:	c1 e0 02             	shl    $0x2,%eax
80102e7a:	01 d0                	add    %edx,%eax
80102e7c:	01 c0                	add    %eax,%eax
80102e7e:	89 c2                	mov    %eax,%edx
80102e80:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102e83:	83 e0 0f             	and    $0xf,%eax
80102e86:	01 d0                	add    %edx,%eax
80102e88:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
80102e8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102e8e:	c1 e8 04             	shr    $0x4,%eax
80102e91:	89 c2                	mov    %eax,%edx
80102e93:	89 d0                	mov    %edx,%eax
80102e95:	c1 e0 02             	shl    $0x2,%eax
80102e98:	01 d0                	add    %edx,%eax
80102e9a:	01 c0                	add    %eax,%eax
80102e9c:	89 c2                	mov    %eax,%edx
80102e9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102ea1:	83 e0 0f             	and    $0xf,%eax
80102ea4:	01 d0                	add    %edx,%eax
80102ea6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80102ea9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102eac:	c1 e8 04             	shr    $0x4,%eax
80102eaf:	89 c2                	mov    %eax,%edx
80102eb1:	89 d0                	mov    %edx,%eax
80102eb3:	c1 e0 02             	shl    $0x2,%eax
80102eb6:	01 d0                	add    %edx,%eax
80102eb8:	01 c0                	add    %eax,%eax
80102eba:	89 c2                	mov    %eax,%edx
80102ebc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102ebf:	83 e0 0f             	and    $0xf,%eax
80102ec2:	01 d0                	add    %edx,%eax
80102ec4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80102ec7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102eca:	c1 e8 04             	shr    $0x4,%eax
80102ecd:	89 c2                	mov    %eax,%edx
80102ecf:	89 d0                	mov    %edx,%eax
80102ed1:	c1 e0 02             	shl    $0x2,%eax
80102ed4:	01 d0                	add    %edx,%eax
80102ed6:	01 c0                	add    %eax,%eax
80102ed8:	89 c2                	mov    %eax,%edx
80102eda:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102edd:	83 e0 0f             	and    $0xf,%eax
80102ee0:	01 d0                	add    %edx,%eax
80102ee2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
80102ee5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102ee8:	c1 e8 04             	shr    $0x4,%eax
80102eeb:	89 c2                	mov    %eax,%edx
80102eed:	89 d0                	mov    %edx,%eax
80102eef:	c1 e0 02             	shl    $0x2,%eax
80102ef2:	01 d0                	add    %edx,%eax
80102ef4:	01 c0                	add    %eax,%eax
80102ef6:	89 c2                	mov    %eax,%edx
80102ef8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102efb:	83 e0 0f             	and    $0xf,%eax
80102efe:	01 d0                	add    %edx,%eax
80102f00:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
80102f03:	8b 45 08             	mov    0x8(%ebp),%eax
80102f06:	8b 55 d8             	mov    -0x28(%ebp),%edx
80102f09:	89 10                	mov    %edx,(%eax)
80102f0b:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102f0e:	89 50 04             	mov    %edx,0x4(%eax)
80102f11:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102f14:	89 50 08             	mov    %edx,0x8(%eax)
80102f17:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102f1a:	89 50 0c             	mov    %edx,0xc(%eax)
80102f1d:	8b 55 e8             	mov    -0x18(%ebp),%edx
80102f20:	89 50 10             	mov    %edx,0x10(%eax)
80102f23:	8b 55 ec             	mov    -0x14(%ebp),%edx
80102f26:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80102f29:	8b 45 08             	mov    0x8(%ebp),%eax
80102f2c:	8b 40 14             	mov    0x14(%eax),%eax
80102f2f:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
80102f35:	8b 45 08             	mov    0x8(%ebp),%eax
80102f38:	89 50 14             	mov    %edx,0x14(%eax)
}
80102f3b:	90                   	nop
80102f3c:	c9                   	leave  
80102f3d:	c3                   	ret    

80102f3e <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102f3e:	f3 0f 1e fb          	endbr32 
80102f42:	55                   	push   %ebp
80102f43:	89 e5                	mov    %esp,%ebp
80102f45:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102f48:	83 ec 08             	sub    $0x8,%esp
80102f4b:	68 b1 a8 10 80       	push   $0x8010a8b1
80102f50:	68 20 54 19 80       	push   $0x80195420
80102f55:	e8 c8 1a 00 00       	call   80104a22 <initlock>
80102f5a:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80102f5d:	83 ec 08             	sub    $0x8,%esp
80102f60:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102f63:	50                   	push   %eax
80102f64:	ff 75 08             	pushl  0x8(%ebp)
80102f67:	e8 c0 e4 ff ff       	call   8010142c <readsb>
80102f6c:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
80102f6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102f72:	a3 54 54 19 80       	mov    %eax,0x80195454
  log.size = sb.nlog;
80102f77:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102f7a:	a3 58 54 19 80       	mov    %eax,0x80195458
  log.dev = dev;
80102f7f:	8b 45 08             	mov    0x8(%ebp),%eax
80102f82:	a3 64 54 19 80       	mov    %eax,0x80195464
  recover_from_log();
80102f87:	e8 bf 01 00 00       	call   8010314b <recover_from_log>
}
80102f8c:	90                   	nop
80102f8d:	c9                   	leave  
80102f8e:	c3                   	ret    

80102f8f <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102f8f:	f3 0f 1e fb          	endbr32 
80102f93:	55                   	push   %ebp
80102f94:	89 e5                	mov    %esp,%ebp
80102f96:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102f99:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102fa0:	e9 95 00 00 00       	jmp    8010303a <install_trans+0xab>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102fa5:	8b 15 54 54 19 80    	mov    0x80195454,%edx
80102fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102fae:	01 d0                	add    %edx,%eax
80102fb0:	83 c0 01             	add    $0x1,%eax
80102fb3:	89 c2                	mov    %eax,%edx
80102fb5:	a1 64 54 19 80       	mov    0x80195464,%eax
80102fba:	83 ec 08             	sub    $0x8,%esp
80102fbd:	52                   	push   %edx
80102fbe:	50                   	push   %eax
80102fbf:	e8 45 d2 ff ff       	call   80100209 <bread>
80102fc4:	83 c4 10             	add    $0x10,%esp
80102fc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102fcd:	83 c0 10             	add    $0x10,%eax
80102fd0:	8b 04 85 2c 54 19 80 	mov    -0x7fe6abd4(,%eax,4),%eax
80102fd7:	89 c2                	mov    %eax,%edx
80102fd9:	a1 64 54 19 80       	mov    0x80195464,%eax
80102fde:	83 ec 08             	sub    $0x8,%esp
80102fe1:	52                   	push   %edx
80102fe2:	50                   	push   %eax
80102fe3:	e8 21 d2 ff ff       	call   80100209 <bread>
80102fe8:	83 c4 10             	add    $0x10,%esp
80102feb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102fee:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102ff1:	8d 50 5c             	lea    0x5c(%eax),%edx
80102ff4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102ff7:	83 c0 5c             	add    $0x5c,%eax
80102ffa:	83 ec 04             	sub    $0x4,%esp
80102ffd:	68 00 02 00 00       	push   $0x200
80103002:	52                   	push   %edx
80103003:	50                   	push   %eax
80103004:	e8 95 1d 00 00       	call   80104d9e <memmove>
80103009:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
8010300c:	83 ec 0c             	sub    $0xc,%esp
8010300f:	ff 75 ec             	pushl  -0x14(%ebp)
80103012:	e8 2f d2 ff ff       	call   80100246 <bwrite>
80103017:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf);
8010301a:	83 ec 0c             	sub    $0xc,%esp
8010301d:	ff 75 f0             	pushl  -0x10(%ebp)
80103020:	e8 6e d2 ff ff       	call   80100293 <brelse>
80103025:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
80103028:	83 ec 0c             	sub    $0xc,%esp
8010302b:	ff 75 ec             	pushl  -0x14(%ebp)
8010302e:	e8 60 d2 ff ff       	call   80100293 <brelse>
80103033:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80103036:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010303a:	a1 68 54 19 80       	mov    0x80195468,%eax
8010303f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103042:	0f 8c 5d ff ff ff    	jl     80102fa5 <install_trans+0x16>
  }
}
80103048:	90                   	nop
80103049:	90                   	nop
8010304a:	c9                   	leave  
8010304b:	c3                   	ret    

8010304c <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010304c:	f3 0f 1e fb          	endbr32 
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103056:	a1 54 54 19 80       	mov    0x80195454,%eax
8010305b:	89 c2                	mov    %eax,%edx
8010305d:	a1 64 54 19 80       	mov    0x80195464,%eax
80103062:	83 ec 08             	sub    $0x8,%esp
80103065:	52                   	push   %edx
80103066:	50                   	push   %eax
80103067:	e8 9d d1 ff ff       	call   80100209 <bread>
8010306c:	83 c4 10             	add    $0x10,%esp
8010306f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103072:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103075:	83 c0 5c             	add    $0x5c,%eax
80103078:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
8010307b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010307e:	8b 00                	mov    (%eax),%eax
80103080:	a3 68 54 19 80       	mov    %eax,0x80195468
  for (i = 0; i < log.lh.n; i++) {
80103085:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010308c:	eb 1b                	jmp    801030a9 <read_head+0x5d>
    log.lh.block[i] = lh->block[i];
8010308e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103094:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103098:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010309b:	83 c2 10             	add    $0x10,%edx
8010309e:	89 04 95 2c 54 19 80 	mov    %eax,-0x7fe6abd4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801030a5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801030a9:	a1 68 54 19 80       	mov    0x80195468,%eax
801030ae:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801030b1:	7c db                	jl     8010308e <read_head+0x42>
  }
  brelse(buf);
801030b3:	83 ec 0c             	sub    $0xc,%esp
801030b6:	ff 75 f0             	pushl  -0x10(%ebp)
801030b9:	e8 d5 d1 ff ff       	call   80100293 <brelse>
801030be:	83 c4 10             	add    $0x10,%esp
}
801030c1:	90                   	nop
801030c2:	c9                   	leave  
801030c3:	c3                   	ret    

801030c4 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801030c4:	f3 0f 1e fb          	endbr32 
801030c8:	55                   	push   %ebp
801030c9:	89 e5                	mov    %esp,%ebp
801030cb:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801030ce:	a1 54 54 19 80       	mov    0x80195454,%eax
801030d3:	89 c2                	mov    %eax,%edx
801030d5:	a1 64 54 19 80       	mov    0x80195464,%eax
801030da:	83 ec 08             	sub    $0x8,%esp
801030dd:	52                   	push   %edx
801030de:	50                   	push   %eax
801030df:	e8 25 d1 ff ff       	call   80100209 <bread>
801030e4:	83 c4 10             	add    $0x10,%esp
801030e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801030ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801030ed:	83 c0 5c             	add    $0x5c,%eax
801030f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801030f3:	8b 15 68 54 19 80    	mov    0x80195468,%edx
801030f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801030fc:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801030fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103105:	eb 1b                	jmp    80103122 <write_head+0x5e>
    hb->block[i] = log.lh.block[i];
80103107:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010310a:	83 c0 10             	add    $0x10,%eax
8010310d:	8b 0c 85 2c 54 19 80 	mov    -0x7fe6abd4(,%eax,4),%ecx
80103114:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103117:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010311a:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010311e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103122:	a1 68 54 19 80       	mov    0x80195468,%eax
80103127:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010312a:	7c db                	jl     80103107 <write_head+0x43>
  }
  bwrite(buf);
8010312c:	83 ec 0c             	sub    $0xc,%esp
8010312f:	ff 75 f0             	pushl  -0x10(%ebp)
80103132:	e8 0f d1 ff ff       	call   80100246 <bwrite>
80103137:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
8010313a:	83 ec 0c             	sub    $0xc,%esp
8010313d:	ff 75 f0             	pushl  -0x10(%ebp)
80103140:	e8 4e d1 ff ff       	call   80100293 <brelse>
80103145:	83 c4 10             	add    $0x10,%esp
}
80103148:	90                   	nop
80103149:	c9                   	leave  
8010314a:	c3                   	ret    

8010314b <recover_from_log>:

static void
recover_from_log(void)
{
8010314b:	f3 0f 1e fb          	endbr32 
8010314f:	55                   	push   %ebp
80103150:	89 e5                	mov    %esp,%ebp
80103152:	83 ec 08             	sub    $0x8,%esp
  read_head();
80103155:	e8 f2 fe ff ff       	call   8010304c <read_head>
  install_trans(); // if committed, copy from log to disk
8010315a:	e8 30 fe ff ff       	call   80102f8f <install_trans>
  log.lh.n = 0;
8010315f:	c7 05 68 54 19 80 00 	movl   $0x0,0x80195468
80103166:	00 00 00 
  write_head(); // clear the log
80103169:	e8 56 ff ff ff       	call   801030c4 <write_head>
}
8010316e:	90                   	nop
8010316f:	c9                   	leave  
80103170:	c3                   	ret    

80103171 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
80103171:	f3 0f 1e fb          	endbr32 
80103175:	55                   	push   %ebp
80103176:	89 e5                	mov    %esp,%ebp
80103178:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
8010317b:	83 ec 0c             	sub    $0xc,%esp
8010317e:	68 20 54 19 80       	push   $0x80195420
80103183:	e8 c0 18 00 00       	call   80104a48 <acquire>
80103188:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
8010318b:	a1 60 54 19 80       	mov    0x80195460,%eax
80103190:	85 c0                	test   %eax,%eax
80103192:	74 17                	je     801031ab <begin_op+0x3a>
      sleep(&log, &log.lock);
80103194:	83 ec 08             	sub    $0x8,%esp
80103197:	68 20 54 19 80       	push   $0x80195420
8010319c:	68 20 54 19 80       	push   $0x80195420
801031a1:	e8 dc 12 00 00       	call   80104482 <sleep>
801031a6:	83 c4 10             	add    $0x10,%esp
801031a9:	eb e0                	jmp    8010318b <begin_op+0x1a>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801031ab:	8b 0d 68 54 19 80    	mov    0x80195468,%ecx
801031b1:	a1 5c 54 19 80       	mov    0x8019545c,%eax
801031b6:	8d 50 01             	lea    0x1(%eax),%edx
801031b9:	89 d0                	mov    %edx,%eax
801031bb:	c1 e0 02             	shl    $0x2,%eax
801031be:	01 d0                	add    %edx,%eax
801031c0:	01 c0                	add    %eax,%eax
801031c2:	01 c8                	add    %ecx,%eax
801031c4:	83 f8 1e             	cmp    $0x1e,%eax
801031c7:	7e 17                	jle    801031e0 <begin_op+0x6f>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
801031c9:	83 ec 08             	sub    $0x8,%esp
801031cc:	68 20 54 19 80       	push   $0x80195420
801031d1:	68 20 54 19 80       	push   $0x80195420
801031d6:	e8 a7 12 00 00       	call   80104482 <sleep>
801031db:	83 c4 10             	add    $0x10,%esp
801031de:	eb ab                	jmp    8010318b <begin_op+0x1a>
    } else {
      log.outstanding += 1;
801031e0:	a1 5c 54 19 80       	mov    0x8019545c,%eax
801031e5:	83 c0 01             	add    $0x1,%eax
801031e8:	a3 5c 54 19 80       	mov    %eax,0x8019545c
      release(&log.lock);
801031ed:	83 ec 0c             	sub    $0xc,%esp
801031f0:	68 20 54 19 80       	push   $0x80195420
801031f5:	e8 c0 18 00 00       	call   80104aba <release>
801031fa:	83 c4 10             	add    $0x10,%esp
      break;
801031fd:	90                   	nop
    }
  }
}
801031fe:	90                   	nop
801031ff:	c9                   	leave  
80103200:	c3                   	ret    

80103201 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103201:	f3 0f 1e fb          	endbr32 
80103205:	55                   	push   %ebp
80103206:	89 e5                	mov    %esp,%ebp
80103208:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
8010320b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
80103212:	83 ec 0c             	sub    $0xc,%esp
80103215:	68 20 54 19 80       	push   $0x80195420
8010321a:	e8 29 18 00 00       	call   80104a48 <acquire>
8010321f:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103222:	a1 5c 54 19 80       	mov    0x8019545c,%eax
80103227:	83 e8 01             	sub    $0x1,%eax
8010322a:	a3 5c 54 19 80       	mov    %eax,0x8019545c
  if(log.committing)
8010322f:	a1 60 54 19 80       	mov    0x80195460,%eax
80103234:	85 c0                	test   %eax,%eax
80103236:	74 0d                	je     80103245 <end_op+0x44>
    panic("log.committing");
80103238:	83 ec 0c             	sub    $0xc,%esp
8010323b:	68 b5 a8 10 80       	push   $0x8010a8b5
80103240:	e8 80 d3 ff ff       	call   801005c5 <panic>
  if(log.outstanding == 0){
80103245:	a1 5c 54 19 80       	mov    0x8019545c,%eax
8010324a:	85 c0                	test   %eax,%eax
8010324c:	75 13                	jne    80103261 <end_op+0x60>
    do_commit = 1;
8010324e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
80103255:	c7 05 60 54 19 80 01 	movl   $0x1,0x80195460
8010325c:	00 00 00 
8010325f:	eb 10                	jmp    80103271 <end_op+0x70>
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80103261:	83 ec 0c             	sub    $0xc,%esp
80103264:	68 20 54 19 80       	push   $0x80195420
80103269:	e8 03 13 00 00       	call   80104571 <wakeup>
8010326e:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
80103271:	83 ec 0c             	sub    $0xc,%esp
80103274:	68 20 54 19 80       	push   $0x80195420
80103279:	e8 3c 18 00 00       	call   80104aba <release>
8010327e:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
80103281:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103285:	74 3f                	je     801032c6 <end_op+0xc5>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103287:	e8 fa 00 00 00       	call   80103386 <commit>
    acquire(&log.lock);
8010328c:	83 ec 0c             	sub    $0xc,%esp
8010328f:	68 20 54 19 80       	push   $0x80195420
80103294:	e8 af 17 00 00       	call   80104a48 <acquire>
80103299:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
8010329c:	c7 05 60 54 19 80 00 	movl   $0x0,0x80195460
801032a3:	00 00 00 
    wakeup(&log);
801032a6:	83 ec 0c             	sub    $0xc,%esp
801032a9:	68 20 54 19 80       	push   $0x80195420
801032ae:	e8 be 12 00 00       	call   80104571 <wakeup>
801032b3:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
801032b6:	83 ec 0c             	sub    $0xc,%esp
801032b9:	68 20 54 19 80       	push   $0x80195420
801032be:	e8 f7 17 00 00       	call   80104aba <release>
801032c3:	83 c4 10             	add    $0x10,%esp
  }
}
801032c6:	90                   	nop
801032c7:	c9                   	leave  
801032c8:	c3                   	ret    

801032c9 <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
801032c9:	f3 0f 1e fb          	endbr32 
801032cd:	55                   	push   %ebp
801032ce:	89 e5                	mov    %esp,%ebp
801032d0:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801032d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801032da:	e9 95 00 00 00       	jmp    80103374 <write_log+0xab>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801032df:	8b 15 54 54 19 80    	mov    0x80195454,%edx
801032e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032e8:	01 d0                	add    %edx,%eax
801032ea:	83 c0 01             	add    $0x1,%eax
801032ed:	89 c2                	mov    %eax,%edx
801032ef:	a1 64 54 19 80       	mov    0x80195464,%eax
801032f4:	83 ec 08             	sub    $0x8,%esp
801032f7:	52                   	push   %edx
801032f8:	50                   	push   %eax
801032f9:	e8 0b cf ff ff       	call   80100209 <bread>
801032fe:	83 c4 10             	add    $0x10,%esp
80103301:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103304:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103307:	83 c0 10             	add    $0x10,%eax
8010330a:	8b 04 85 2c 54 19 80 	mov    -0x7fe6abd4(,%eax,4),%eax
80103311:	89 c2                	mov    %eax,%edx
80103313:	a1 64 54 19 80       	mov    0x80195464,%eax
80103318:	83 ec 08             	sub    $0x8,%esp
8010331b:	52                   	push   %edx
8010331c:	50                   	push   %eax
8010331d:	e8 e7 ce ff ff       	call   80100209 <bread>
80103322:	83 c4 10             	add    $0x10,%esp
80103325:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
80103328:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010332b:	8d 50 5c             	lea    0x5c(%eax),%edx
8010332e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103331:	83 c0 5c             	add    $0x5c,%eax
80103334:	83 ec 04             	sub    $0x4,%esp
80103337:	68 00 02 00 00       	push   $0x200
8010333c:	52                   	push   %edx
8010333d:	50                   	push   %eax
8010333e:	e8 5b 1a 00 00       	call   80104d9e <memmove>
80103343:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
80103346:	83 ec 0c             	sub    $0xc,%esp
80103349:	ff 75 f0             	pushl  -0x10(%ebp)
8010334c:	e8 f5 ce ff ff       	call   80100246 <bwrite>
80103351:	83 c4 10             	add    $0x10,%esp
    brelse(from);
80103354:	83 ec 0c             	sub    $0xc,%esp
80103357:	ff 75 ec             	pushl  -0x14(%ebp)
8010335a:	e8 34 cf ff ff       	call   80100293 <brelse>
8010335f:	83 c4 10             	add    $0x10,%esp
    brelse(to);
80103362:	83 ec 0c             	sub    $0xc,%esp
80103365:	ff 75 f0             	pushl  -0x10(%ebp)
80103368:	e8 26 cf ff ff       	call   80100293 <brelse>
8010336d:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80103370:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103374:	a1 68 54 19 80       	mov    0x80195468,%eax
80103379:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010337c:	0f 8c 5d ff ff ff    	jl     801032df <write_log+0x16>
  }
}
80103382:	90                   	nop
80103383:	90                   	nop
80103384:	c9                   	leave  
80103385:	c3                   	ret    

80103386 <commit>:

static void
commit()
{
80103386:	f3 0f 1e fb          	endbr32 
8010338a:	55                   	push   %ebp
8010338b:	89 e5                	mov    %esp,%ebp
8010338d:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103390:	a1 68 54 19 80       	mov    0x80195468,%eax
80103395:	85 c0                	test   %eax,%eax
80103397:	7e 1e                	jle    801033b7 <commit+0x31>
    write_log();     // Write modified blocks from cache to log
80103399:	e8 2b ff ff ff       	call   801032c9 <write_log>
    write_head();    // Write header to disk -- the real commit
8010339e:	e8 21 fd ff ff       	call   801030c4 <write_head>
    install_trans(); // Now install writes to home locations
801033a3:	e8 e7 fb ff ff       	call   80102f8f <install_trans>
    log.lh.n = 0;
801033a8:	c7 05 68 54 19 80 00 	movl   $0x0,0x80195468
801033af:	00 00 00 
    write_head();    // Erase the transaction from the log
801033b2:	e8 0d fd ff ff       	call   801030c4 <write_head>
  }
}
801033b7:	90                   	nop
801033b8:	c9                   	leave  
801033b9:	c3                   	ret    

801033ba <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801033ba:	f3 0f 1e fb          	endbr32 
801033be:	55                   	push   %ebp
801033bf:	89 e5                	mov    %esp,%ebp
801033c1:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801033c4:	a1 68 54 19 80       	mov    0x80195468,%eax
801033c9:	83 f8 1d             	cmp    $0x1d,%eax
801033cc:	7f 12                	jg     801033e0 <log_write+0x26>
801033ce:	a1 68 54 19 80       	mov    0x80195468,%eax
801033d3:	8b 15 58 54 19 80    	mov    0x80195458,%edx
801033d9:	83 ea 01             	sub    $0x1,%edx
801033dc:	39 d0                	cmp    %edx,%eax
801033de:	7c 0d                	jl     801033ed <log_write+0x33>
    panic("too big a transaction");
801033e0:	83 ec 0c             	sub    $0xc,%esp
801033e3:	68 c4 a8 10 80       	push   $0x8010a8c4
801033e8:	e8 d8 d1 ff ff       	call   801005c5 <panic>
  if (log.outstanding < 1)
801033ed:	a1 5c 54 19 80       	mov    0x8019545c,%eax
801033f2:	85 c0                	test   %eax,%eax
801033f4:	7f 0d                	jg     80103403 <log_write+0x49>
    panic("log_write outside of trans");
801033f6:	83 ec 0c             	sub    $0xc,%esp
801033f9:	68 da a8 10 80       	push   $0x8010a8da
801033fe:	e8 c2 d1 ff ff       	call   801005c5 <panic>

  acquire(&log.lock);
80103403:	83 ec 0c             	sub    $0xc,%esp
80103406:	68 20 54 19 80       	push   $0x80195420
8010340b:	e8 38 16 00 00       	call   80104a48 <acquire>
80103410:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
80103413:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010341a:	eb 1d                	jmp    80103439 <log_write+0x7f>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
8010341c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010341f:	83 c0 10             	add    $0x10,%eax
80103422:	8b 04 85 2c 54 19 80 	mov    -0x7fe6abd4(,%eax,4),%eax
80103429:	89 c2                	mov    %eax,%edx
8010342b:	8b 45 08             	mov    0x8(%ebp),%eax
8010342e:	8b 40 08             	mov    0x8(%eax),%eax
80103431:	39 c2                	cmp    %eax,%edx
80103433:	74 10                	je     80103445 <log_write+0x8b>
  for (i = 0; i < log.lh.n; i++) {
80103435:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103439:	a1 68 54 19 80       	mov    0x80195468,%eax
8010343e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103441:	7c d9                	jl     8010341c <log_write+0x62>
80103443:	eb 01                	jmp    80103446 <log_write+0x8c>
      break;
80103445:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
80103446:	8b 45 08             	mov    0x8(%ebp),%eax
80103449:	8b 40 08             	mov    0x8(%eax),%eax
8010344c:	89 c2                	mov    %eax,%edx
8010344e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103451:	83 c0 10             	add    $0x10,%eax
80103454:	89 14 85 2c 54 19 80 	mov    %edx,-0x7fe6abd4(,%eax,4)
  if (i == log.lh.n)
8010345b:	a1 68 54 19 80       	mov    0x80195468,%eax
80103460:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103463:	75 0d                	jne    80103472 <log_write+0xb8>
    log.lh.n++;
80103465:	a1 68 54 19 80       	mov    0x80195468,%eax
8010346a:	83 c0 01             	add    $0x1,%eax
8010346d:	a3 68 54 19 80       	mov    %eax,0x80195468
  b->flags |= B_DIRTY; // prevent eviction
80103472:	8b 45 08             	mov    0x8(%ebp),%eax
80103475:	8b 00                	mov    (%eax),%eax
80103477:	83 c8 04             	or     $0x4,%eax
8010347a:	89 c2                	mov    %eax,%edx
8010347c:	8b 45 08             	mov    0x8(%ebp),%eax
8010347f:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
80103481:	83 ec 0c             	sub    $0xc,%esp
80103484:	68 20 54 19 80       	push   $0x80195420
80103489:	e8 2c 16 00 00       	call   80104aba <release>
8010348e:	83 c4 10             	add    $0x10,%esp
}
80103491:	90                   	nop
80103492:	c9                   	leave  
80103493:	c3                   	ret    

80103494 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103494:	55                   	push   %ebp
80103495:	89 e5                	mov    %esp,%ebp
80103497:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010349a:	8b 55 08             	mov    0x8(%ebp),%edx
8010349d:	8b 45 0c             	mov    0xc(%ebp),%eax
801034a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
801034a3:	f0 87 02             	lock xchg %eax,(%edx)
801034a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801034a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801034ac:	c9                   	leave  
801034ad:	c3                   	ret    

801034ae <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801034ae:	f3 0f 1e fb          	endbr32 
801034b2:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801034b6:	83 e4 f0             	and    $0xfffffff0,%esp
801034b9:	ff 71 fc             	pushl  -0x4(%ecx)
801034bc:	55                   	push   %ebp
801034bd:	89 e5                	mov    %esp,%ebp
801034bf:	51                   	push   %ecx
801034c0:	83 ec 04             	sub    $0x4,%esp
  graphic_init();
801034c3:	e8 ac 4e 00 00       	call   80108374 <graphic_init>
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801034c8:	83 ec 08             	sub    $0x8,%esp
801034cb:	68 00 00 40 80       	push   $0x80400000
801034d0:	68 00 80 19 80       	push   $0x80198000
801034d5:	e8 73 f2 ff ff       	call   8010274d <kinit1>
801034da:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
801034dd:	e8 45 44 00 00       	call   80107927 <kvmalloc>
  mpinit_uefi();
801034e2:	e8 46 4c 00 00       	call   8010812d <mpinit_uefi>
  lapicinit();     // interrupt controller
801034e7:	e8 f0 f5 ff ff       	call   80102adc <lapicinit>
  seginit();       // segment descriptors
801034ec:	e8 bd 3e 00 00       	call   801073ae <seginit>
  picinit();    // disable pic
801034f1:	e8 a9 01 00 00       	call   8010369f <picinit>
  ioapicinit();    // another interrupt controller
801034f6:	e8 65 f1 ff ff       	call   80102660 <ioapicinit>
  consoleinit();   // console hardware
801034fb:	e8 39 d6 ff ff       	call   80100b39 <consoleinit>
  uartinit();      // serial port
80103500:	e8 32 32 00 00       	call   80106737 <uartinit>
  pinit();         // process table
80103505:	e8 e2 05 00 00       	call   80103aec <pinit>
  tvinit();        // trap vectors
8010350a:	e8 be 2c 00 00       	call   801061cd <tvinit>
  binit();         // buffer cache
8010350f:	e8 52 cb ff ff       	call   80100066 <binit>
  fileinit();      // file table
80103514:	e8 e8 da ff ff       	call   80101001 <fileinit>
  ideinit();       // disk 
80103519:	e8 5b 70 00 00       	call   8010a579 <ideinit>
  startothers();   // start other processors
8010351e:	e8 92 00 00 00       	call   801035b5 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103523:	83 ec 08             	sub    $0x8,%esp
80103526:	68 00 00 00 a0       	push   $0xa0000000
8010352b:	68 00 00 40 80       	push   $0x80400000
80103530:	e8 55 f2 ff ff       	call   8010278a <kinit2>
80103535:	83 c4 10             	add    $0x10,%esp
  pci_init();
80103538:	e8 aa 50 00 00       	call   801085e7 <pci_init>
  arp_scan();
8010353d:	e8 23 5e 00 00       	call   80109365 <arp_scan>
  //i8254_recv();
  userinit();      // first user process
80103542:	e8 9b 07 00 00       	call   80103ce2 <userinit>

  mpmain();        // finish this processor's setup
80103547:	e8 1e 00 00 00       	call   8010356a <mpmain>

8010354c <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
8010354c:	f3 0f 1e fb          	endbr32 
80103550:	55                   	push   %ebp
80103551:	89 e5                	mov    %esp,%ebp
80103553:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103556:	e8 e8 43 00 00       	call   80107943 <switchkvm>
  seginit();
8010355b:	e8 4e 3e 00 00       	call   801073ae <seginit>
  lapicinit();
80103560:	e8 77 f5 ff ff       	call   80102adc <lapicinit>
  mpmain();
80103565:	e8 00 00 00 00       	call   8010356a <mpmain>

8010356a <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
8010356a:	f3 0f 1e fb          	endbr32 
8010356e:	55                   	push   %ebp
8010356f:	89 e5                	mov    %esp,%ebp
80103571:	53                   	push   %ebx
80103572:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103575:	e8 94 05 00 00       	call   80103b0e <cpuid>
8010357a:	89 c3                	mov    %eax,%ebx
8010357c:	e8 8d 05 00 00       	call   80103b0e <cpuid>
80103581:	83 ec 04             	sub    $0x4,%esp
80103584:	53                   	push   %ebx
80103585:	50                   	push   %eax
80103586:	68 f5 a8 10 80       	push   $0x8010a8f5
8010358b:	e8 7c ce ff ff       	call   8010040c <cprintf>
80103590:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103593:	e8 af 2d 00 00       	call   80106347 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103598:	e8 90 05 00 00       	call   80103b2d <mycpu>
8010359d:	05 a0 00 00 00       	add    $0xa0,%eax
801035a2:	83 ec 08             	sub    $0x8,%esp
801035a5:	6a 01                	push   $0x1
801035a7:	50                   	push   %eax
801035a8:	e8 e7 fe ff ff       	call   80103494 <xchg>
801035ad:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
801035b0:	e8 cc 0c 00 00       	call   80104281 <scheduler>

801035b5 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801035b5:	f3 0f 1e fb          	endbr32 
801035b9:	55                   	push   %ebp
801035ba:	89 e5                	mov    %esp,%ebp
801035bc:	83 ec 18             	sub    $0x18,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
801035bf:	c7 45 f0 00 70 00 80 	movl   $0x80007000,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801035c6:	b8 8a 00 00 00       	mov    $0x8a,%eax
801035cb:	83 ec 04             	sub    $0x4,%esp
801035ce:	50                   	push   %eax
801035cf:	68 18 f5 10 80       	push   $0x8010f518
801035d4:	ff 75 f0             	pushl  -0x10(%ebp)
801035d7:	e8 c2 17 00 00       	call   80104d9e <memmove>
801035dc:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
801035df:	c7 45 f4 c0 7c 19 80 	movl   $0x80197cc0,-0xc(%ebp)
801035e6:	eb 79                	jmp    80103661 <startothers+0xac>
    if(c == mycpu()){  // We've started already.
801035e8:	e8 40 05 00 00       	call   80103b2d <mycpu>
801035ed:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801035f0:	74 67                	je     80103659 <startothers+0xa4>
      continue;
    }
    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801035f2:	e8 9b f2 ff ff       	call   80102892 <kalloc>
801035f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
801035fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035fd:	83 e8 04             	sub    $0x4,%eax
80103600:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103603:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103609:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
8010360b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010360e:	83 e8 08             	sub    $0x8,%eax
80103611:	c7 00 4c 35 10 80    	movl   $0x8010354c,(%eax)
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103617:	b8 00 e0 10 80       	mov    $0x8010e000,%eax
8010361c:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80103622:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103625:	83 e8 0c             	sub    $0xc,%eax
80103628:	89 10                	mov    %edx,(%eax)

    lapicstartap(c->apicid, V2P(code));
8010362a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010362d:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80103633:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103636:	0f b6 00             	movzbl (%eax),%eax
80103639:	0f b6 c0             	movzbl %al,%eax
8010363c:	83 ec 08             	sub    $0x8,%esp
8010363f:	52                   	push   %edx
80103640:	50                   	push   %eax
80103641:	e8 08 f6 ff ff       	call   80102c4e <lapicstartap>
80103646:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103649:	90                   	nop
8010364a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010364d:	8b 80 a0 00 00 00    	mov    0xa0(%eax),%eax
80103653:	85 c0                	test   %eax,%eax
80103655:	74 f3                	je     8010364a <startothers+0x95>
80103657:	eb 01                	jmp    8010365a <startothers+0xa5>
      continue;
80103659:	90                   	nop
  for(c = cpus; c < cpus+ncpu; c++){
8010365a:	81 45 f4 b0 00 00 00 	addl   $0xb0,-0xc(%ebp)
80103661:	a1 80 7f 19 80       	mov    0x80197f80,%eax
80103666:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010366c:	05 c0 7c 19 80       	add    $0x80197cc0,%eax
80103671:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103674:	0f 82 6e ff ff ff    	jb     801035e8 <startothers+0x33>
      ;
  }
}
8010367a:	90                   	nop
8010367b:	90                   	nop
8010367c:	c9                   	leave  
8010367d:	c3                   	ret    

8010367e <outb>:
{
8010367e:	55                   	push   %ebp
8010367f:	89 e5                	mov    %esp,%ebp
80103681:	83 ec 08             	sub    $0x8,%esp
80103684:	8b 45 08             	mov    0x8(%ebp),%eax
80103687:	8b 55 0c             	mov    0xc(%ebp),%edx
8010368a:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
8010368e:	89 d0                	mov    %edx,%eax
80103690:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103693:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103697:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010369b:	ee                   	out    %al,(%dx)
}
8010369c:	90                   	nop
8010369d:	c9                   	leave  
8010369e:	c3                   	ret    

8010369f <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
8010369f:	f3 0f 1e fb          	endbr32 
801036a3:	55                   	push   %ebp
801036a4:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
801036a6:	68 ff 00 00 00       	push   $0xff
801036ab:	6a 21                	push   $0x21
801036ad:	e8 cc ff ff ff       	call   8010367e <outb>
801036b2:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
801036b5:	68 ff 00 00 00       	push   $0xff
801036ba:	68 a1 00 00 00       	push   $0xa1
801036bf:	e8 ba ff ff ff       	call   8010367e <outb>
801036c4:	83 c4 08             	add    $0x8,%esp
}
801036c7:	90                   	nop
801036c8:	c9                   	leave  
801036c9:	c3                   	ret    

801036ca <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801036ca:	f3 0f 1e fb          	endbr32 
801036ce:	55                   	push   %ebp
801036cf:	89 e5                	mov    %esp,%ebp
801036d1:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
801036d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
801036db:	8b 45 0c             	mov    0xc(%ebp),%eax
801036de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801036e4:	8b 45 0c             	mov    0xc(%ebp),%eax
801036e7:	8b 10                	mov    (%eax),%edx
801036e9:	8b 45 08             	mov    0x8(%ebp),%eax
801036ec:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801036ee:	e8 30 d9 ff ff       	call   80101023 <filealloc>
801036f3:	8b 55 08             	mov    0x8(%ebp),%edx
801036f6:	89 02                	mov    %eax,(%edx)
801036f8:	8b 45 08             	mov    0x8(%ebp),%eax
801036fb:	8b 00                	mov    (%eax),%eax
801036fd:	85 c0                	test   %eax,%eax
801036ff:	0f 84 c8 00 00 00    	je     801037cd <pipealloc+0x103>
80103705:	e8 19 d9 ff ff       	call   80101023 <filealloc>
8010370a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010370d:	89 02                	mov    %eax,(%edx)
8010370f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103712:	8b 00                	mov    (%eax),%eax
80103714:	85 c0                	test   %eax,%eax
80103716:	0f 84 b1 00 00 00    	je     801037cd <pipealloc+0x103>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010371c:	e8 71 f1 ff ff       	call   80102892 <kalloc>
80103721:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103724:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103728:	0f 84 a2 00 00 00    	je     801037d0 <pipealloc+0x106>
    goto bad;
  p->readopen = 1;
8010372e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103731:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103738:	00 00 00 
  p->writeopen = 1;
8010373b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010373e:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103745:	00 00 00 
  p->nwrite = 0;
80103748:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010374b:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103752:	00 00 00 
  p->nread = 0;
80103755:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103758:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
8010375f:	00 00 00 
  initlock(&p->lock, "pipe");
80103762:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103765:	83 ec 08             	sub    $0x8,%esp
80103768:	68 09 a9 10 80       	push   $0x8010a909
8010376d:	50                   	push   %eax
8010376e:	e8 af 12 00 00       	call   80104a22 <initlock>
80103773:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103776:	8b 45 08             	mov    0x8(%ebp),%eax
80103779:	8b 00                	mov    (%eax),%eax
8010377b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103781:	8b 45 08             	mov    0x8(%ebp),%eax
80103784:	8b 00                	mov    (%eax),%eax
80103786:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010378a:	8b 45 08             	mov    0x8(%ebp),%eax
8010378d:	8b 00                	mov    (%eax),%eax
8010378f:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103793:	8b 45 08             	mov    0x8(%ebp),%eax
80103796:	8b 00                	mov    (%eax),%eax
80103798:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010379b:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010379e:	8b 45 0c             	mov    0xc(%ebp),%eax
801037a1:	8b 00                	mov    (%eax),%eax
801037a3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801037a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801037ac:	8b 00                	mov    (%eax),%eax
801037ae:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801037b2:	8b 45 0c             	mov    0xc(%ebp),%eax
801037b5:	8b 00                	mov    (%eax),%eax
801037b7:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801037bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801037be:	8b 00                	mov    (%eax),%eax
801037c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801037c3:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
801037c6:	b8 00 00 00 00       	mov    $0x0,%eax
801037cb:	eb 51                	jmp    8010381e <pipealloc+0x154>
    goto bad;
801037cd:	90                   	nop
801037ce:	eb 01                	jmp    801037d1 <pipealloc+0x107>
    goto bad;
801037d0:	90                   	nop

//PAGEBREAK: 20
 bad:
  if(p)
801037d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801037d5:	74 0e                	je     801037e5 <pipealloc+0x11b>
    kfree((char*)p);
801037d7:	83 ec 0c             	sub    $0xc,%esp
801037da:	ff 75 f4             	pushl  -0xc(%ebp)
801037dd:	e8 12 f0 ff ff       	call   801027f4 <kfree>
801037e2:	83 c4 10             	add    $0x10,%esp
  if(*f0)
801037e5:	8b 45 08             	mov    0x8(%ebp),%eax
801037e8:	8b 00                	mov    (%eax),%eax
801037ea:	85 c0                	test   %eax,%eax
801037ec:	74 11                	je     801037ff <pipealloc+0x135>
    fileclose(*f0);
801037ee:	8b 45 08             	mov    0x8(%ebp),%eax
801037f1:	8b 00                	mov    (%eax),%eax
801037f3:	83 ec 0c             	sub    $0xc,%esp
801037f6:	50                   	push   %eax
801037f7:	e8 ed d8 ff ff       	call   801010e9 <fileclose>
801037fc:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801037ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80103802:	8b 00                	mov    (%eax),%eax
80103804:	85 c0                	test   %eax,%eax
80103806:	74 11                	je     80103819 <pipealloc+0x14f>
    fileclose(*f1);
80103808:	8b 45 0c             	mov    0xc(%ebp),%eax
8010380b:	8b 00                	mov    (%eax),%eax
8010380d:	83 ec 0c             	sub    $0xc,%esp
80103810:	50                   	push   %eax
80103811:	e8 d3 d8 ff ff       	call   801010e9 <fileclose>
80103816:	83 c4 10             	add    $0x10,%esp
  return -1;
80103819:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010381e:	c9                   	leave  
8010381f:	c3                   	ret    

80103820 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103820:	f3 0f 1e fb          	endbr32 
80103824:	55                   	push   %ebp
80103825:	89 e5                	mov    %esp,%ebp
80103827:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
8010382a:	8b 45 08             	mov    0x8(%ebp),%eax
8010382d:	83 ec 0c             	sub    $0xc,%esp
80103830:	50                   	push   %eax
80103831:	e8 12 12 00 00       	call   80104a48 <acquire>
80103836:	83 c4 10             	add    $0x10,%esp
  if(writable){
80103839:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010383d:	74 23                	je     80103862 <pipeclose+0x42>
    p->writeopen = 0;
8010383f:	8b 45 08             	mov    0x8(%ebp),%eax
80103842:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103849:	00 00 00 
    wakeup(&p->nread);
8010384c:	8b 45 08             	mov    0x8(%ebp),%eax
8010384f:	05 34 02 00 00       	add    $0x234,%eax
80103854:	83 ec 0c             	sub    $0xc,%esp
80103857:	50                   	push   %eax
80103858:	e8 14 0d 00 00       	call   80104571 <wakeup>
8010385d:	83 c4 10             	add    $0x10,%esp
80103860:	eb 21                	jmp    80103883 <pipeclose+0x63>
  } else {
    p->readopen = 0;
80103862:	8b 45 08             	mov    0x8(%ebp),%eax
80103865:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
8010386c:	00 00 00 
    wakeup(&p->nwrite);
8010386f:	8b 45 08             	mov    0x8(%ebp),%eax
80103872:	05 38 02 00 00       	add    $0x238,%eax
80103877:	83 ec 0c             	sub    $0xc,%esp
8010387a:	50                   	push   %eax
8010387b:	e8 f1 0c 00 00       	call   80104571 <wakeup>
80103880:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103883:	8b 45 08             	mov    0x8(%ebp),%eax
80103886:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
8010388c:	85 c0                	test   %eax,%eax
8010388e:	75 2c                	jne    801038bc <pipeclose+0x9c>
80103890:	8b 45 08             	mov    0x8(%ebp),%eax
80103893:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103899:	85 c0                	test   %eax,%eax
8010389b:	75 1f                	jne    801038bc <pipeclose+0x9c>
    release(&p->lock);
8010389d:	8b 45 08             	mov    0x8(%ebp),%eax
801038a0:	83 ec 0c             	sub    $0xc,%esp
801038a3:	50                   	push   %eax
801038a4:	e8 11 12 00 00       	call   80104aba <release>
801038a9:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
801038ac:	83 ec 0c             	sub    $0xc,%esp
801038af:	ff 75 08             	pushl  0x8(%ebp)
801038b2:	e8 3d ef ff ff       	call   801027f4 <kfree>
801038b7:	83 c4 10             	add    $0x10,%esp
801038ba:	eb 10                	jmp    801038cc <pipeclose+0xac>
  } else
    release(&p->lock);
801038bc:	8b 45 08             	mov    0x8(%ebp),%eax
801038bf:	83 ec 0c             	sub    $0xc,%esp
801038c2:	50                   	push   %eax
801038c3:	e8 f2 11 00 00       	call   80104aba <release>
801038c8:	83 c4 10             	add    $0x10,%esp
}
801038cb:	90                   	nop
801038cc:	90                   	nop
801038cd:	c9                   	leave  
801038ce:	c3                   	ret    

801038cf <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801038cf:	f3 0f 1e fb          	endbr32 
801038d3:	55                   	push   %ebp
801038d4:	89 e5                	mov    %esp,%ebp
801038d6:	53                   	push   %ebx
801038d7:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
801038da:	8b 45 08             	mov    0x8(%ebp),%eax
801038dd:	83 ec 0c             	sub    $0xc,%esp
801038e0:	50                   	push   %eax
801038e1:	e8 62 11 00 00       	call   80104a48 <acquire>
801038e6:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
801038e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801038f0:	e9 ad 00 00 00       	jmp    801039a2 <pipewrite+0xd3>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
801038f5:	8b 45 08             	mov    0x8(%ebp),%eax
801038f8:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801038fe:	85 c0                	test   %eax,%eax
80103900:	74 0c                	je     8010390e <pipewrite+0x3f>
80103902:	e8 a2 02 00 00       	call   80103ba9 <myproc>
80103907:	8b 40 24             	mov    0x24(%eax),%eax
8010390a:	85 c0                	test   %eax,%eax
8010390c:	74 19                	je     80103927 <pipewrite+0x58>
        release(&p->lock);
8010390e:	8b 45 08             	mov    0x8(%ebp),%eax
80103911:	83 ec 0c             	sub    $0xc,%esp
80103914:	50                   	push   %eax
80103915:	e8 a0 11 00 00       	call   80104aba <release>
8010391a:	83 c4 10             	add    $0x10,%esp
        return -1;
8010391d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103922:	e9 a9 00 00 00       	jmp    801039d0 <pipewrite+0x101>
      }
      wakeup(&p->nread);
80103927:	8b 45 08             	mov    0x8(%ebp),%eax
8010392a:	05 34 02 00 00       	add    $0x234,%eax
8010392f:	83 ec 0c             	sub    $0xc,%esp
80103932:	50                   	push   %eax
80103933:	e8 39 0c 00 00       	call   80104571 <wakeup>
80103938:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010393b:	8b 45 08             	mov    0x8(%ebp),%eax
8010393e:	8b 55 08             	mov    0x8(%ebp),%edx
80103941:	81 c2 38 02 00 00    	add    $0x238,%edx
80103947:	83 ec 08             	sub    $0x8,%esp
8010394a:	50                   	push   %eax
8010394b:	52                   	push   %edx
8010394c:	e8 31 0b 00 00       	call   80104482 <sleep>
80103951:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103954:	8b 45 08             	mov    0x8(%ebp),%eax
80103957:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
8010395d:	8b 45 08             	mov    0x8(%ebp),%eax
80103960:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103966:	05 00 02 00 00       	add    $0x200,%eax
8010396b:	39 c2                	cmp    %eax,%edx
8010396d:	74 86                	je     801038f5 <pipewrite+0x26>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010396f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103972:	8b 45 0c             	mov    0xc(%ebp),%eax
80103975:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80103978:	8b 45 08             	mov    0x8(%ebp),%eax
8010397b:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103981:	8d 48 01             	lea    0x1(%eax),%ecx
80103984:	8b 55 08             	mov    0x8(%ebp),%edx
80103987:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
8010398d:	25 ff 01 00 00       	and    $0x1ff,%eax
80103992:	89 c1                	mov    %eax,%ecx
80103994:	0f b6 13             	movzbl (%ebx),%edx
80103997:	8b 45 08             	mov    0x8(%ebp),%eax
8010399a:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
  for(i = 0; i < n; i++){
8010399e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801039a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039a5:	3b 45 10             	cmp    0x10(%ebp),%eax
801039a8:	7c aa                	jl     80103954 <pipewrite+0x85>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801039aa:	8b 45 08             	mov    0x8(%ebp),%eax
801039ad:	05 34 02 00 00       	add    $0x234,%eax
801039b2:	83 ec 0c             	sub    $0xc,%esp
801039b5:	50                   	push   %eax
801039b6:	e8 b6 0b 00 00       	call   80104571 <wakeup>
801039bb:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801039be:	8b 45 08             	mov    0x8(%ebp),%eax
801039c1:	83 ec 0c             	sub    $0xc,%esp
801039c4:	50                   	push   %eax
801039c5:	e8 f0 10 00 00       	call   80104aba <release>
801039ca:	83 c4 10             	add    $0x10,%esp
  return n;
801039cd:	8b 45 10             	mov    0x10(%ebp),%eax
}
801039d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039d3:	c9                   	leave  
801039d4:	c3                   	ret    

801039d5 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801039d5:	f3 0f 1e fb          	endbr32 
801039d9:	55                   	push   %ebp
801039da:	89 e5                	mov    %esp,%ebp
801039dc:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
801039df:	8b 45 08             	mov    0x8(%ebp),%eax
801039e2:	83 ec 0c             	sub    $0xc,%esp
801039e5:	50                   	push   %eax
801039e6:	e8 5d 10 00 00       	call   80104a48 <acquire>
801039eb:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801039ee:	eb 3e                	jmp    80103a2e <piperead+0x59>
    if(myproc()->killed){
801039f0:	e8 b4 01 00 00       	call   80103ba9 <myproc>
801039f5:	8b 40 24             	mov    0x24(%eax),%eax
801039f8:	85 c0                	test   %eax,%eax
801039fa:	74 19                	je     80103a15 <piperead+0x40>
      release(&p->lock);
801039fc:	8b 45 08             	mov    0x8(%ebp),%eax
801039ff:	83 ec 0c             	sub    $0xc,%esp
80103a02:	50                   	push   %eax
80103a03:	e8 b2 10 00 00       	call   80104aba <release>
80103a08:	83 c4 10             	add    $0x10,%esp
      return -1;
80103a0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a10:	e9 be 00 00 00       	jmp    80103ad3 <piperead+0xfe>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103a15:	8b 45 08             	mov    0x8(%ebp),%eax
80103a18:	8b 55 08             	mov    0x8(%ebp),%edx
80103a1b:	81 c2 34 02 00 00    	add    $0x234,%edx
80103a21:	83 ec 08             	sub    $0x8,%esp
80103a24:	50                   	push   %eax
80103a25:	52                   	push   %edx
80103a26:	e8 57 0a 00 00       	call   80104482 <sleep>
80103a2b:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103a2e:	8b 45 08             	mov    0x8(%ebp),%eax
80103a31:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103a37:	8b 45 08             	mov    0x8(%ebp),%eax
80103a3a:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103a40:	39 c2                	cmp    %eax,%edx
80103a42:	75 0d                	jne    80103a51 <piperead+0x7c>
80103a44:	8b 45 08             	mov    0x8(%ebp),%eax
80103a47:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103a4d:	85 c0                	test   %eax,%eax
80103a4f:	75 9f                	jne    801039f0 <piperead+0x1b>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103a51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103a58:	eb 48                	jmp    80103aa2 <piperead+0xcd>
    if(p->nread == p->nwrite)
80103a5a:	8b 45 08             	mov    0x8(%ebp),%eax
80103a5d:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103a63:	8b 45 08             	mov    0x8(%ebp),%eax
80103a66:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103a6c:	39 c2                	cmp    %eax,%edx
80103a6e:	74 3c                	je     80103aac <piperead+0xd7>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103a70:	8b 45 08             	mov    0x8(%ebp),%eax
80103a73:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103a79:	8d 48 01             	lea    0x1(%eax),%ecx
80103a7c:	8b 55 08             	mov    0x8(%ebp),%edx
80103a7f:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80103a85:	25 ff 01 00 00       	and    $0x1ff,%eax
80103a8a:	89 c1                	mov    %eax,%ecx
80103a8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103a8f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a92:	01 c2                	add    %eax,%edx
80103a94:	8b 45 08             	mov    0x8(%ebp),%eax
80103a97:	0f b6 44 08 34       	movzbl 0x34(%eax,%ecx,1),%eax
80103a9c:	88 02                	mov    %al,(%edx)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103a9e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103aa5:	3b 45 10             	cmp    0x10(%ebp),%eax
80103aa8:	7c b0                	jl     80103a5a <piperead+0x85>
80103aaa:	eb 01                	jmp    80103aad <piperead+0xd8>
      break;
80103aac:	90                   	nop
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103aad:	8b 45 08             	mov    0x8(%ebp),%eax
80103ab0:	05 38 02 00 00       	add    $0x238,%eax
80103ab5:	83 ec 0c             	sub    $0xc,%esp
80103ab8:	50                   	push   %eax
80103ab9:	e8 b3 0a 00 00       	call   80104571 <wakeup>
80103abe:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80103ac1:	8b 45 08             	mov    0x8(%ebp),%eax
80103ac4:	83 ec 0c             	sub    $0xc,%esp
80103ac7:	50                   	push   %eax
80103ac8:	e8 ed 0f 00 00       	call   80104aba <release>
80103acd:	83 c4 10             	add    $0x10,%esp
  return i;
80103ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103ad3:	c9                   	leave  
80103ad4:	c3                   	ret    

80103ad5 <readeflags>:
{
80103ad5:	55                   	push   %ebp
80103ad6:	89 e5                	mov    %esp,%ebp
80103ad8:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103adb:	9c                   	pushf  
80103adc:	58                   	pop    %eax
80103add:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80103ae0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103ae3:	c9                   	leave  
80103ae4:	c3                   	ret    

80103ae5 <sti>:
{
80103ae5:	55                   	push   %ebp
80103ae6:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80103ae8:	fb                   	sti    
}
80103ae9:	90                   	nop
80103aea:	5d                   	pop    %ebp
80103aeb:	c3                   	ret    

80103aec <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103aec:	f3 0f 1e fb          	endbr32 
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
80103af6:	83 ec 08             	sub    $0x8,%esp
80103af9:	68 10 a9 10 80       	push   $0x8010a910
80103afe:	68 00 55 19 80       	push   $0x80195500
80103b03:	e8 1a 0f 00 00       	call   80104a22 <initlock>
80103b08:	83 c4 10             	add    $0x10,%esp
}
80103b0b:	90                   	nop
80103b0c:	c9                   	leave  
80103b0d:	c3                   	ret    

80103b0e <cpuid>:

// Must be called with interrupts disabled
int
cpuid() {
80103b0e:	f3 0f 1e fb          	endbr32 
80103b12:	55                   	push   %ebp
80103b13:	89 e5                	mov    %esp,%ebp
80103b15:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b18:	e8 10 00 00 00       	call   80103b2d <mycpu>
80103b1d:	2d c0 7c 19 80       	sub    $0x80197cc0,%eax
80103b22:	c1 f8 04             	sar    $0x4,%eax
80103b25:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b2b:	c9                   	leave  
80103b2c:	c3                   	ret    

80103b2d <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80103b2d:	f3 0f 1e fb          	endbr32 
80103b31:	55                   	push   %ebp
80103b32:	89 e5                	mov    %esp,%ebp
80103b34:	83 ec 18             	sub    $0x18,%esp
  int apicid, i;
  
  if(readeflags()&FL_IF){
80103b37:	e8 99 ff ff ff       	call   80103ad5 <readeflags>
80103b3c:	25 00 02 00 00       	and    $0x200,%eax
80103b41:	85 c0                	test   %eax,%eax
80103b43:	74 0d                	je     80103b52 <mycpu+0x25>
    panic("mycpu called with interrupts enabled\n");
80103b45:	83 ec 0c             	sub    $0xc,%esp
80103b48:	68 18 a9 10 80       	push   $0x8010a918
80103b4d:	e8 73 ca ff ff       	call   801005c5 <panic>
  }

  apicid = lapicid();
80103b52:	e8 a8 f0 ff ff       	call   80102bff <lapicid>
80103b57:	89 45 f0             	mov    %eax,-0x10(%ebp)
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103b5a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103b61:	eb 2d                	jmp    80103b90 <mycpu+0x63>
    if (cpus[i].apicid == apicid){
80103b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b66:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80103b6c:	05 c0 7c 19 80       	add    $0x80197cc0,%eax
80103b71:	0f b6 00             	movzbl (%eax),%eax
80103b74:	0f b6 c0             	movzbl %al,%eax
80103b77:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80103b7a:	75 10                	jne    80103b8c <mycpu+0x5f>
      return &cpus[i];
80103b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b7f:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80103b85:	05 c0 7c 19 80       	add    $0x80197cc0,%eax
80103b8a:	eb 1b                	jmp    80103ba7 <mycpu+0x7a>
  for (i = 0; i < ncpu; ++i) {
80103b8c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103b90:	a1 80 7f 19 80       	mov    0x80197f80,%eax
80103b95:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103b98:	7c c9                	jl     80103b63 <mycpu+0x36>
    }
  }
  panic("unknown apicid\n");
80103b9a:	83 ec 0c             	sub    $0xc,%esp
80103b9d:	68 3e a9 10 80       	push   $0x8010a93e
80103ba2:	e8 1e ca ff ff       	call   801005c5 <panic>
}
80103ba7:	c9                   	leave  
80103ba8:	c3                   	ret    

80103ba9 <myproc>:

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103ba9:	f3 0f 1e fb          	endbr32 
80103bad:	55                   	push   %ebp
80103bae:	89 e5                	mov    %esp,%ebp
80103bb0:	83 ec 18             	sub    $0x18,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103bb3:	e8 0c 10 00 00       	call   80104bc4 <pushcli>
  c = mycpu();
80103bb8:	e8 70 ff ff ff       	call   80103b2d <mycpu>
80103bbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
80103bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bc3:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80103bc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();
80103bcc:	e8 44 10 00 00       	call   80104c15 <popcli>
  return p;
80103bd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103bd4:	c9                   	leave  
80103bd5:	c3                   	ret    

80103bd6 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103bd6:	f3 0f 1e fb          	endbr32 
80103bda:	55                   	push   %ebp
80103bdb:	89 e5                	mov    %esp,%ebp
80103bdd:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80103be0:	83 ec 0c             	sub    $0xc,%esp
80103be3:	68 00 55 19 80       	push   $0x80195500
80103be8:	e8 5b 0e 00 00       	call   80104a48 <acquire>
80103bed:	83 c4 10             	add    $0x10,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bf0:	c7 45 f4 34 55 19 80 	movl   $0x80195534,-0xc(%ebp)
80103bf7:	eb 0e                	jmp    80103c07 <allocproc+0x31>
    if(p->state == UNUSED){
80103bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bfc:	8b 40 0c             	mov    0xc(%eax),%eax
80103bff:	85 c0                	test   %eax,%eax
80103c01:	74 27                	je     80103c2a <allocproc+0x54>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c03:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80103c07:	81 7d f4 34 74 19 80 	cmpl   $0x80197434,-0xc(%ebp)
80103c0e:	72 e9                	jb     80103bf9 <allocproc+0x23>
      goto found;
    }

  release(&ptable.lock);
80103c10:	83 ec 0c             	sub    $0xc,%esp
80103c13:	68 00 55 19 80       	push   $0x80195500
80103c18:	e8 9d 0e 00 00       	call   80104aba <release>
80103c1d:	83 c4 10             	add    $0x10,%esp
  return 0;
80103c20:	b8 00 00 00 00       	mov    $0x0,%eax
80103c25:	e9 b6 00 00 00       	jmp    80103ce0 <allocproc+0x10a>
      goto found;
80103c2a:	90                   	nop
80103c2b:	f3 0f 1e fb          	endbr32 

found:
  p->state = EMBRYO;
80103c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c32:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80103c39:	a1 00 f0 10 80       	mov    0x8010f000,%eax
80103c3e:	8d 50 01             	lea    0x1(%eax),%edx
80103c41:	89 15 00 f0 10 80    	mov    %edx,0x8010f000
80103c47:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c4a:	89 42 10             	mov    %eax,0x10(%edx)

  release(&ptable.lock);
80103c4d:	83 ec 0c             	sub    $0xc,%esp
80103c50:	68 00 55 19 80       	push   $0x80195500
80103c55:	e8 60 0e 00 00       	call   80104aba <release>
80103c5a:	83 c4 10             	add    $0x10,%esp


  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103c5d:	e8 30 ec ff ff       	call   80102892 <kalloc>
80103c62:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c65:	89 42 08             	mov    %eax,0x8(%edx)
80103c68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c6b:	8b 40 08             	mov    0x8(%eax),%eax
80103c6e:	85 c0                	test   %eax,%eax
80103c70:	75 11                	jne    80103c83 <allocproc+0xad>
    p->state = UNUSED;
80103c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c75:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80103c7c:	b8 00 00 00 00       	mov    $0x0,%eax
80103c81:	eb 5d                	jmp    80103ce0 <allocproc+0x10a>
  }
  sp = p->kstack + KSTACKSIZE;
80103c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c86:	8b 40 08             	mov    0x8(%eax),%eax
80103c89:	05 00 10 00 00       	add    $0x1000,%eax
80103c8e:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103c91:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80103c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c98:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103c9b:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80103c9e:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80103ca2:	ba 7b 61 10 80       	mov    $0x8010617b,%edx
80103ca7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103caa:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80103cac:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80103cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cb3:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103cb6:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80103cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cbc:	8b 40 1c             	mov    0x1c(%eax),%eax
80103cbf:	83 ec 04             	sub    $0x4,%esp
80103cc2:	6a 14                	push   $0x14
80103cc4:	6a 00                	push   $0x0
80103cc6:	50                   	push   %eax
80103cc7:	e8 0b 10 00 00       	call   80104cd7 <memset>
80103ccc:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cd2:	8b 40 1c             	mov    0x1c(%eax),%eax
80103cd5:	ba 38 44 10 80       	mov    $0x80104438,%edx
80103cda:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
80103cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103ce0:	c9                   	leave  
80103ce1:	c3                   	ret    

80103ce2 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103ce2:	f3 0f 1e fb          	endbr32 
80103ce6:	55                   	push   %ebp
80103ce7:	89 e5                	mov    %esp,%ebp
80103ce9:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103cec:	e8 e5 fe ff ff       	call   80103bd6 <allocproc>
80103cf1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  initproc = p;
80103cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cf7:	a3 5c d0 18 80       	mov    %eax,0x8018d05c
  if((p->pgdir = setupkvm()) == 0){
80103cfc:	e8 35 3b 00 00       	call   80107836 <setupkvm>
80103d01:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d04:	89 42 04             	mov    %eax,0x4(%edx)
80103d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d0a:	8b 40 04             	mov    0x4(%eax),%eax
80103d0d:	85 c0                	test   %eax,%eax
80103d0f:	75 0d                	jne    80103d1e <userinit+0x3c>
    panic("userinit: out of memory?");
80103d11:	83 ec 0c             	sub    $0xc,%esp
80103d14:	68 4e a9 10 80       	push   $0x8010a94e
80103d19:	e8 a7 c8 ff ff       	call   801005c5 <panic>
  }
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103d1e:	ba 2c 00 00 00       	mov    $0x2c,%edx
80103d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d26:	8b 40 04             	mov    0x4(%eax),%eax
80103d29:	83 ec 04             	sub    $0x4,%esp
80103d2c:	52                   	push   %edx
80103d2d:	68 ec f4 10 80       	push   $0x8010f4ec
80103d32:	50                   	push   %eax
80103d33:	e8 cb 3d 00 00       	call   80107b03 <inituvm>
80103d38:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80103d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d3e:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80103d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d47:	8b 40 18             	mov    0x18(%eax),%eax
80103d4a:	83 ec 04             	sub    $0x4,%esp
80103d4d:	6a 4c                	push   $0x4c
80103d4f:	6a 00                	push   $0x0
80103d51:	50                   	push   %eax
80103d52:	e8 80 0f 00 00       	call   80104cd7 <memset>
80103d57:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d5d:	8b 40 18             	mov    0x18(%eax),%eax
80103d60:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d69:	8b 40 18             	mov    0x18(%eax),%eax
80103d6c:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d75:	8b 50 18             	mov    0x18(%eax),%edx
80103d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d7b:	8b 40 18             	mov    0x18(%eax),%eax
80103d7e:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80103d82:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d89:	8b 50 18             	mov    0x18(%eax),%edx
80103d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d8f:	8b 40 18             	mov    0x18(%eax),%eax
80103d92:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80103d96:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d9d:	8b 40 18             	mov    0x18(%eax),%eax
80103da0:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103daa:	8b 40 18             	mov    0x18(%eax),%eax
80103dad:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103db7:	8b 40 18             	mov    0x18(%eax),%eax
80103dba:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dc4:	83 c0 6c             	add    $0x6c,%eax
80103dc7:	83 ec 04             	sub    $0x4,%esp
80103dca:	6a 10                	push   $0x10
80103dcc:	68 67 a9 10 80       	push   $0x8010a967
80103dd1:	50                   	push   %eax
80103dd2:	e8 1b 11 00 00       	call   80104ef2 <safestrcpy>
80103dd7:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80103dda:	83 ec 0c             	sub    $0xc,%esp
80103ddd:	68 70 a9 10 80       	push   $0x8010a970
80103de2:	e8 00 e8 ff ff       	call   801025e7 <namei>
80103de7:	83 c4 10             	add    $0x10,%esp
80103dea:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103ded:	89 42 68             	mov    %eax,0x68(%edx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103df0:	83 ec 0c             	sub    $0xc,%esp
80103df3:	68 00 55 19 80       	push   $0x80195500
80103df8:	e8 4b 0c 00 00       	call   80104a48 <acquire>
80103dfd:	83 c4 10             	add    $0x10,%esp

  p->state = RUNNABLE;
80103e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e03:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80103e0a:	83 ec 0c             	sub    $0xc,%esp
80103e0d:	68 00 55 19 80       	push   $0x80195500
80103e12:	e8 a3 0c 00 00       	call   80104aba <release>
80103e17:	83 c4 10             	add    $0x10,%esp
}
80103e1a:	90                   	nop
80103e1b:	c9                   	leave  
80103e1c:	c3                   	ret    

80103e1d <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103e1d:	f3 0f 1e fb          	endbr32 
80103e21:	55                   	push   %ebp
80103e22:	89 e5                	mov    %esp,%ebp
80103e24:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  struct proc *curproc = myproc();
80103e27:	e8 7d fd ff ff       	call   80103ba9 <myproc>
80103e2c:	89 45 f0             	mov    %eax,-0x10(%ebp)

  sz = curproc->sz;
80103e2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e32:	8b 00                	mov    (%eax),%eax
80103e34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80103e37:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80103e3b:	7e 2e                	jle    80103e6b <growproc+0x4e>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103e3d:	8b 55 08             	mov    0x8(%ebp),%edx
80103e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e43:	01 c2                	add    %eax,%edx
80103e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e48:	8b 40 04             	mov    0x4(%eax),%eax
80103e4b:	83 ec 04             	sub    $0x4,%esp
80103e4e:	52                   	push   %edx
80103e4f:	ff 75 f4             	pushl  -0xc(%ebp)
80103e52:	50                   	push   %eax
80103e53:	e8 f0 3d 00 00       	call   80107c48 <allocuvm>
80103e58:	83 c4 10             	add    $0x10,%esp
80103e5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103e5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103e62:	75 3b                	jne    80103e9f <growproc+0x82>
      return -1;
80103e64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e69:	eb 4f                	jmp    80103eba <growproc+0x9d>
  } else if(n < 0){
80103e6b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80103e6f:	79 2e                	jns    80103e9f <growproc+0x82>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103e71:	8b 55 08             	mov    0x8(%ebp),%edx
80103e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e77:	01 c2                	add    %eax,%edx
80103e79:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e7c:	8b 40 04             	mov    0x4(%eax),%eax
80103e7f:	83 ec 04             	sub    $0x4,%esp
80103e82:	52                   	push   %edx
80103e83:	ff 75 f4             	pushl  -0xc(%ebp)
80103e86:	50                   	push   %eax
80103e87:	e8 c5 3e 00 00       	call   80107d51 <deallocuvm>
80103e8c:	83 c4 10             	add    $0x10,%esp
80103e8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103e92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103e96:	75 07                	jne    80103e9f <growproc+0x82>
      return -1;
80103e98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e9d:	eb 1b                	jmp    80103eba <growproc+0x9d>
  }
  curproc->sz = sz;
80103e9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ea2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103ea5:	89 10                	mov    %edx,(%eax)
  switchuvm(curproc);
80103ea7:	83 ec 0c             	sub    $0xc,%esp
80103eaa:	ff 75 f0             	pushl  -0x10(%ebp)
80103ead:	e8 ae 3a 00 00       	call   80107960 <switchuvm>
80103eb2:	83 c4 10             	add    $0x10,%esp
  return 0;
80103eb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103eba:	c9                   	leave  
80103ebb:	c3                   	ret    

80103ebc <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103ebc:	f3 0f 1e fb          	endbr32 
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	57                   	push   %edi
80103ec4:	56                   	push   %esi
80103ec5:	53                   	push   %ebx
80103ec6:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
80103ec9:	e8 db fc ff ff       	call   80103ba9 <myproc>
80103ece:	89 45 e0             	mov    %eax,-0x20(%ebp)

  // Allocate process.
  if((np = allocproc()) == 0){
80103ed1:	e8 00 fd ff ff       	call   80103bd6 <allocproc>
80103ed6:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103ed9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80103edd:	75 0a                	jne    80103ee9 <fork+0x2d>
    return -1;
80103edf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ee4:	e9 48 01 00 00       	jmp    80104031 <fork+0x175>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103ee9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103eec:	8b 10                	mov    (%eax),%edx
80103eee:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103ef1:	8b 40 04             	mov    0x4(%eax),%eax
80103ef4:	83 ec 08             	sub    $0x8,%esp
80103ef7:	52                   	push   %edx
80103ef8:	50                   	push   %eax
80103ef9:	e8 fd 3f 00 00       	call   80107efb <copyuvm>
80103efe:	83 c4 10             	add    $0x10,%esp
80103f01:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103f04:	89 42 04             	mov    %eax,0x4(%edx)
80103f07:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103f0a:	8b 40 04             	mov    0x4(%eax),%eax
80103f0d:	85 c0                	test   %eax,%eax
80103f0f:	75 30                	jne    80103f41 <fork+0x85>
    kfree(np->kstack);
80103f11:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103f14:	8b 40 08             	mov    0x8(%eax),%eax
80103f17:	83 ec 0c             	sub    $0xc,%esp
80103f1a:	50                   	push   %eax
80103f1b:	e8 d4 e8 ff ff       	call   801027f4 <kfree>
80103f20:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80103f23:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103f26:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80103f2d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103f30:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80103f37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f3c:	e9 f0 00 00 00       	jmp    80104031 <fork+0x175>
  }
  np->sz = curproc->sz;
80103f41:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103f44:	8b 10                	mov    (%eax),%edx
80103f46:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103f49:	89 10                	mov    %edx,(%eax)
  np->parent = curproc;
80103f4b:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103f4e:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103f51:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *curproc->tf;
80103f54:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103f57:	8b 48 18             	mov    0x18(%eax),%ecx
80103f5a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103f5d:	8b 40 18             	mov    0x18(%eax),%eax
80103f60:	89 c2                	mov    %eax,%edx
80103f62:	89 cb                	mov    %ecx,%ebx
80103f64:	b8 13 00 00 00       	mov    $0x13,%eax
80103f69:	89 d7                	mov    %edx,%edi
80103f6b:	89 de                	mov    %ebx,%esi
80103f6d:	89 c1                	mov    %eax,%ecx
80103f6f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103f71:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103f74:	8b 40 18             	mov    0x18(%eax),%eax
80103f77:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80103f7e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80103f85:	eb 3b                	jmp    80103fc2 <fork+0x106>
    if(curproc->ofile[i])
80103f87:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103f8a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103f8d:	83 c2 08             	add    $0x8,%edx
80103f90:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103f94:	85 c0                	test   %eax,%eax
80103f96:	74 26                	je     80103fbe <fork+0x102>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103f98:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103f9b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103f9e:	83 c2 08             	add    $0x8,%edx
80103fa1:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103fa5:	83 ec 0c             	sub    $0xc,%esp
80103fa8:	50                   	push   %eax
80103fa9:	e8 e6 d0 ff ff       	call   80101094 <filedup>
80103fae:	83 c4 10             	add    $0x10,%esp
80103fb1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103fb4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103fb7:	83 c1 08             	add    $0x8,%ecx
80103fba:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  for(i = 0; i < NOFILE; i++)
80103fbe:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80103fc2:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80103fc6:	7e bf                	jle    80103f87 <fork+0xcb>
  np->cwd = idup(curproc->cwd);
80103fc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103fcb:	8b 40 68             	mov    0x68(%eax),%eax
80103fce:	83 ec 0c             	sub    $0xc,%esp
80103fd1:	50                   	push   %eax
80103fd2:	e8 67 da ff ff       	call   80101a3e <idup>
80103fd7:	83 c4 10             	add    $0x10,%esp
80103fda:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103fdd:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103fe0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103fe3:	8d 50 6c             	lea    0x6c(%eax),%edx
80103fe6:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103fe9:	83 c0 6c             	add    $0x6c,%eax
80103fec:	83 ec 04             	sub    $0x4,%esp
80103fef:	6a 10                	push   $0x10
80103ff1:	52                   	push   %edx
80103ff2:	50                   	push   %eax
80103ff3:	e8 fa 0e 00 00       	call   80104ef2 <safestrcpy>
80103ff8:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
80103ffb:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103ffe:	8b 40 10             	mov    0x10(%eax),%eax
80104001:	89 45 d8             	mov    %eax,-0x28(%ebp)

  acquire(&ptable.lock);
80104004:	83 ec 0c             	sub    $0xc,%esp
80104007:	68 00 55 19 80       	push   $0x80195500
8010400c:	e8 37 0a 00 00       	call   80104a48 <acquire>
80104011:	83 c4 10             	add    $0x10,%esp

  np->state = RUNNABLE;
80104014:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104017:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
8010401e:	83 ec 0c             	sub    $0xc,%esp
80104021:	68 00 55 19 80       	push   $0x80195500
80104026:	e8 8f 0a 00 00       	call   80104aba <release>
8010402b:	83 c4 10             	add    $0x10,%esp

  return pid;
8010402e:	8b 45 d8             	mov    -0x28(%ebp),%eax
}
80104031:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104034:	5b                   	pop    %ebx
80104035:	5e                   	pop    %esi
80104036:	5f                   	pop    %edi
80104037:	5d                   	pop    %ebp
80104038:	c3                   	ret    

80104039 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104039:	f3 0f 1e fb          	endbr32 
8010403d:	55                   	push   %ebp
8010403e:	89 e5                	mov    %esp,%ebp
80104040:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80104043:	e8 61 fb ff ff       	call   80103ba9 <myproc>
80104048:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;

  if(curproc == initproc)
8010404b:	a1 5c d0 18 80       	mov    0x8018d05c,%eax
80104050:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104053:	75 0d                	jne    80104062 <exit+0x29>
    panic("init exiting");
80104055:	83 ec 0c             	sub    $0xc,%esp
80104058:	68 72 a9 10 80       	push   $0x8010a972
8010405d:	e8 63 c5 ff ff       	call   801005c5 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104062:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104069:	eb 3f                	jmp    801040aa <exit+0x71>
    if(curproc->ofile[fd]){
8010406b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010406e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104071:	83 c2 08             	add    $0x8,%edx
80104074:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104078:	85 c0                	test   %eax,%eax
8010407a:	74 2a                	je     801040a6 <exit+0x6d>
      fileclose(curproc->ofile[fd]);
8010407c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010407f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104082:	83 c2 08             	add    $0x8,%edx
80104085:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104089:	83 ec 0c             	sub    $0xc,%esp
8010408c:	50                   	push   %eax
8010408d:	e8 57 d0 ff ff       	call   801010e9 <fileclose>
80104092:	83 c4 10             	add    $0x10,%esp
      curproc->ofile[fd] = 0;
80104095:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104098:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010409b:	83 c2 08             	add    $0x8,%edx
8010409e:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801040a5:	00 
  for(fd = 0; fd < NOFILE; fd++){
801040a6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801040aa:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
801040ae:	7e bb                	jle    8010406b <exit+0x32>
    }
  }

  begin_op();
801040b0:	e8 bc f0 ff ff       	call   80103171 <begin_op>
  iput(curproc->cwd);
801040b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801040b8:	8b 40 68             	mov    0x68(%eax),%eax
801040bb:	83 ec 0c             	sub    $0xc,%esp
801040be:	50                   	push   %eax
801040bf:	e8 21 db ff ff       	call   80101be5 <iput>
801040c4:	83 c4 10             	add    $0x10,%esp
  end_op();
801040c7:	e8 35 f1 ff ff       	call   80103201 <end_op>
  curproc->cwd = 0;
801040cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801040cf:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
801040d6:	83 ec 0c             	sub    $0xc,%esp
801040d9:	68 00 55 19 80       	push   $0x80195500
801040de:	e8 65 09 00 00       	call   80104a48 <acquire>
801040e3:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
801040e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801040e9:	8b 40 14             	mov    0x14(%eax),%eax
801040ec:	83 ec 0c             	sub    $0xc,%esp
801040ef:	50                   	push   %eax
801040f0:	e8 38 04 00 00       	call   8010452d <wakeup1>
801040f5:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040f8:	c7 45 f4 34 55 19 80 	movl   $0x80195534,-0xc(%ebp)
801040ff:	eb 37                	jmp    80104138 <exit+0xff>
    if(p->parent == curproc){
80104101:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104104:	8b 40 14             	mov    0x14(%eax),%eax
80104107:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010410a:	75 28                	jne    80104134 <exit+0xfb>
      p->parent = initproc;
8010410c:	8b 15 5c d0 18 80    	mov    0x8018d05c,%edx
80104112:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104115:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104118:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010411b:	8b 40 0c             	mov    0xc(%eax),%eax
8010411e:	83 f8 05             	cmp    $0x5,%eax
80104121:	75 11                	jne    80104134 <exit+0xfb>
        wakeup1(initproc);
80104123:	a1 5c d0 18 80       	mov    0x8018d05c,%eax
80104128:	83 ec 0c             	sub    $0xc,%esp
8010412b:	50                   	push   %eax
8010412c:	e8 fc 03 00 00       	call   8010452d <wakeup1>
80104131:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104134:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104138:	81 7d f4 34 74 19 80 	cmpl   $0x80197434,-0xc(%ebp)
8010413f:	72 c0                	jb     80104101 <exit+0xc8>
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80104141:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104144:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
8010414b:	e8 ed 01 00 00       	call   8010433d <sched>
  panic("zombie exit");
80104150:	83 ec 0c             	sub    $0xc,%esp
80104153:	68 7f a9 10 80       	push   $0x8010a97f
80104158:	e8 68 c4 ff ff       	call   801005c5 <panic>

8010415d <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
8010415d:	f3 0f 1e fb          	endbr32 
80104161:	55                   	push   %ebp
80104162:	89 e5                	mov    %esp,%ebp
80104164:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80104167:	e8 3d fa ff ff       	call   80103ba9 <myproc>
8010416c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
8010416f:	83 ec 0c             	sub    $0xc,%esp
80104172:	68 00 55 19 80       	push   $0x80195500
80104177:	e8 cc 08 00 00       	call   80104a48 <acquire>
8010417c:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
8010417f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104186:	c7 45 f4 34 55 19 80 	movl   $0x80195534,-0xc(%ebp)
8010418d:	e9 a1 00 00 00       	jmp    80104233 <wait+0xd6>
      if(p->parent != curproc)
80104192:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104195:	8b 40 14             	mov    0x14(%eax),%eax
80104198:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010419b:	0f 85 8d 00 00 00    	jne    8010422e <wait+0xd1>
        continue;
      havekids = 1;
801041a1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
801041a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041ab:	8b 40 0c             	mov    0xc(%eax),%eax
801041ae:	83 f8 05             	cmp    $0x5,%eax
801041b1:	75 7c                	jne    8010422f <wait+0xd2>
        // Found one.
        pid = p->pid;
801041b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041b6:	8b 40 10             	mov    0x10(%eax),%eax
801041b9:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
801041bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041bf:	8b 40 08             	mov    0x8(%eax),%eax
801041c2:	83 ec 0c             	sub    $0xc,%esp
801041c5:	50                   	push   %eax
801041c6:	e8 29 e6 ff ff       	call   801027f4 <kfree>
801041cb:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
801041ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041d1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
801041d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041db:	8b 40 04             	mov    0x4(%eax),%eax
801041de:	83 ec 0c             	sub    $0xc,%esp
801041e1:	50                   	push   %eax
801041e2:	e8 32 3c 00 00       	call   80107e19 <freevm>
801041e7:	83 c4 10             	add    $0x10,%esp
        p->pid = 0;
801041ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041ed:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
801041f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041f7:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
801041fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104201:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104205:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104208:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
8010420f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104212:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
80104219:	83 ec 0c             	sub    $0xc,%esp
8010421c:	68 00 55 19 80       	push   $0x80195500
80104221:	e8 94 08 00 00       	call   80104aba <release>
80104226:	83 c4 10             	add    $0x10,%esp
        return pid;
80104229:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010422c:	eb 51                	jmp    8010427f <wait+0x122>
        continue;
8010422e:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010422f:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104233:	81 7d f4 34 74 19 80 	cmpl   $0x80197434,-0xc(%ebp)
8010423a:	0f 82 52 ff ff ff    	jb     80104192 <wait+0x35>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104240:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104244:	74 0a                	je     80104250 <wait+0xf3>
80104246:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104249:	8b 40 24             	mov    0x24(%eax),%eax
8010424c:	85 c0                	test   %eax,%eax
8010424e:	74 17                	je     80104267 <wait+0x10a>
      release(&ptable.lock);
80104250:	83 ec 0c             	sub    $0xc,%esp
80104253:	68 00 55 19 80       	push   $0x80195500
80104258:	e8 5d 08 00 00       	call   80104aba <release>
8010425d:	83 c4 10             	add    $0x10,%esp
      return -1;
80104260:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104265:	eb 18                	jmp    8010427f <wait+0x122>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104267:	83 ec 08             	sub    $0x8,%esp
8010426a:	68 00 55 19 80       	push   $0x80195500
8010426f:	ff 75 ec             	pushl  -0x14(%ebp)
80104272:	e8 0b 02 00 00       	call   80104482 <sleep>
80104277:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010427a:	e9 00 ff ff ff       	jmp    8010417f <wait+0x22>
  }
}
8010427f:	c9                   	leave  
80104280:	c3                   	ret    

80104281 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104281:	f3 0f 1e fb          	endbr32 
80104285:	55                   	push   %ebp
80104286:	89 e5                	mov    %esp,%ebp
80104288:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  struct cpu *c = mycpu();
8010428b:	e8 9d f8 ff ff       	call   80103b2d <mycpu>
80104290:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c->proc = 0;
80104293:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104296:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010429d:	00 00 00 
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
801042a0:	e8 40 f8 ff ff       	call   80103ae5 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801042a5:	83 ec 0c             	sub    $0xc,%esp
801042a8:	68 00 55 19 80       	push   $0x80195500
801042ad:	e8 96 07 00 00       	call   80104a48 <acquire>
801042b2:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042b5:	c7 45 f4 34 55 19 80 	movl   $0x80195534,-0xc(%ebp)
801042bc:	eb 61                	jmp    8010431f <scheduler+0x9e>
      if(p->state != RUNNABLE)
801042be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042c1:	8b 40 0c             	mov    0xc(%eax),%eax
801042c4:	83 f8 03             	cmp    $0x3,%eax
801042c7:	75 51                	jne    8010431a <scheduler+0x99>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
801042c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801042cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042cf:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
      switchuvm(p);
801042d5:	83 ec 0c             	sub    $0xc,%esp
801042d8:	ff 75 f4             	pushl  -0xc(%ebp)
801042db:	e8 80 36 00 00       	call   80107960 <switchuvm>
801042e0:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
801042e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042e6:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      swtch(&(c->scheduler), p->context);
801042ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042f0:	8b 40 1c             	mov    0x1c(%eax),%eax
801042f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
801042f6:	83 c2 04             	add    $0x4,%edx
801042f9:	83 ec 08             	sub    $0x8,%esp
801042fc:	50                   	push   %eax
801042fd:	52                   	push   %edx
801042fe:	e8 68 0c 00 00       	call   80104f6b <swtch>
80104303:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104306:	e8 38 36 00 00       	call   80107943 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
8010430b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010430e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104315:	00 00 00 
80104318:	eb 01                	jmp    8010431b <scheduler+0x9a>
        continue;
8010431a:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010431b:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
8010431f:	81 7d f4 34 74 19 80 	cmpl   $0x80197434,-0xc(%ebp)
80104326:	72 96                	jb     801042be <scheduler+0x3d>
    }
    release(&ptable.lock);
80104328:	83 ec 0c             	sub    $0xc,%esp
8010432b:	68 00 55 19 80       	push   $0x80195500
80104330:	e8 85 07 00 00       	call   80104aba <release>
80104335:	83 c4 10             	add    $0x10,%esp
    sti();
80104338:	e9 63 ff ff ff       	jmp    801042a0 <scheduler+0x1f>

8010433d <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
8010433d:	f3 0f 1e fb          	endbr32 
80104341:	55                   	push   %ebp
80104342:	89 e5                	mov    %esp,%ebp
80104344:	83 ec 18             	sub    $0x18,%esp
  int intena;
  struct proc *p = myproc();
80104347:	e8 5d f8 ff ff       	call   80103ba9 <myproc>
8010434c:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(!holding(&ptable.lock))
8010434f:	83 ec 0c             	sub    $0xc,%esp
80104352:	68 00 55 19 80       	push   $0x80195500
80104357:	e8 33 08 00 00       	call   80104b8f <holding>
8010435c:	83 c4 10             	add    $0x10,%esp
8010435f:	85 c0                	test   %eax,%eax
80104361:	75 0d                	jne    80104370 <sched+0x33>
    panic("sched ptable.lock");
80104363:	83 ec 0c             	sub    $0xc,%esp
80104366:	68 8b a9 10 80       	push   $0x8010a98b
8010436b:	e8 55 c2 ff ff       	call   801005c5 <panic>
  if(mycpu()->ncli != 1)
80104370:	e8 b8 f7 ff ff       	call   80103b2d <mycpu>
80104375:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
8010437b:	83 f8 01             	cmp    $0x1,%eax
8010437e:	74 0d                	je     8010438d <sched+0x50>
    panic("sched locks");
80104380:	83 ec 0c             	sub    $0xc,%esp
80104383:	68 9d a9 10 80       	push   $0x8010a99d
80104388:	e8 38 c2 ff ff       	call   801005c5 <panic>
  if(p->state == RUNNING)
8010438d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104390:	8b 40 0c             	mov    0xc(%eax),%eax
80104393:	83 f8 04             	cmp    $0x4,%eax
80104396:	75 0d                	jne    801043a5 <sched+0x68>
    panic("sched running");
80104398:	83 ec 0c             	sub    $0xc,%esp
8010439b:	68 a9 a9 10 80       	push   $0x8010a9a9
801043a0:	e8 20 c2 ff ff       	call   801005c5 <panic>
  if(readeflags()&FL_IF)
801043a5:	e8 2b f7 ff ff       	call   80103ad5 <readeflags>
801043aa:	25 00 02 00 00       	and    $0x200,%eax
801043af:	85 c0                	test   %eax,%eax
801043b1:	74 0d                	je     801043c0 <sched+0x83>
    panic("sched interruptible");
801043b3:	83 ec 0c             	sub    $0xc,%esp
801043b6:	68 b7 a9 10 80       	push   $0x8010a9b7
801043bb:	e8 05 c2 ff ff       	call   801005c5 <panic>
  intena = mycpu()->intena;
801043c0:	e8 68 f7 ff ff       	call   80103b2d <mycpu>
801043c5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801043cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  swtch(&p->context, mycpu()->scheduler);
801043ce:	e8 5a f7 ff ff       	call   80103b2d <mycpu>
801043d3:	8b 40 04             	mov    0x4(%eax),%eax
801043d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043d9:	83 c2 1c             	add    $0x1c,%edx
801043dc:	83 ec 08             	sub    $0x8,%esp
801043df:	50                   	push   %eax
801043e0:	52                   	push   %edx
801043e1:	e8 85 0b 00 00       	call   80104f6b <swtch>
801043e6:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801043e9:	e8 3f f7 ff ff       	call   80103b2d <mycpu>
801043ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
801043f1:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
}
801043f7:	90                   	nop
801043f8:	c9                   	leave  
801043f9:	c3                   	ret    

801043fa <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
801043fa:	f3 0f 1e fb          	endbr32 
801043fe:	55                   	push   %ebp
801043ff:	89 e5                	mov    %esp,%ebp
80104401:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104404:	83 ec 0c             	sub    $0xc,%esp
80104407:	68 00 55 19 80       	push   $0x80195500
8010440c:	e8 37 06 00 00       	call   80104a48 <acquire>
80104411:	83 c4 10             	add    $0x10,%esp
  myproc()->state = RUNNABLE;
80104414:	e8 90 f7 ff ff       	call   80103ba9 <myproc>
80104419:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104420:	e8 18 ff ff ff       	call   8010433d <sched>
  release(&ptable.lock);
80104425:	83 ec 0c             	sub    $0xc,%esp
80104428:	68 00 55 19 80       	push   $0x80195500
8010442d:	e8 88 06 00 00       	call   80104aba <release>
80104432:	83 c4 10             	add    $0x10,%esp
}
80104435:	90                   	nop
80104436:	c9                   	leave  
80104437:	c3                   	ret    

80104438 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104438:	f3 0f 1e fb          	endbr32 
8010443c:	55                   	push   %ebp
8010443d:	89 e5                	mov    %esp,%ebp
8010443f:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104442:	83 ec 0c             	sub    $0xc,%esp
80104445:	68 00 55 19 80       	push   $0x80195500
8010444a:	e8 6b 06 00 00       	call   80104aba <release>
8010444f:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104452:	a1 04 f0 10 80       	mov    0x8010f004,%eax
80104457:	85 c0                	test   %eax,%eax
80104459:	74 24                	je     8010447f <forkret+0x47>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
8010445b:	c7 05 04 f0 10 80 00 	movl   $0x0,0x8010f004
80104462:	00 00 00 
    iinit(ROOTDEV);
80104465:	83 ec 0c             	sub    $0xc,%esp
80104468:	6a 01                	push   $0x1
8010446a:	e8 87 d2 ff ff       	call   801016f6 <iinit>
8010446f:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80104472:	83 ec 0c             	sub    $0xc,%esp
80104475:	6a 01                	push   $0x1
80104477:	e8 c2 ea ff ff       	call   80102f3e <initlog>
8010447c:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010447f:	90                   	nop
80104480:	c9                   	leave  
80104481:	c3                   	ret    

80104482 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104482:	f3 0f 1e fb          	endbr32 
80104486:	55                   	push   %ebp
80104487:	89 e5                	mov    %esp,%ebp
80104489:	83 ec 18             	sub    $0x18,%esp
  struct proc *p = myproc();
8010448c:	e8 18 f7 ff ff       	call   80103ba9 <myproc>
80104491:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(p == 0)
80104494:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104498:	75 0d                	jne    801044a7 <sleep+0x25>
    panic("sleep");
8010449a:	83 ec 0c             	sub    $0xc,%esp
8010449d:	68 cb a9 10 80       	push   $0x8010a9cb
801044a2:	e8 1e c1 ff ff       	call   801005c5 <panic>

  if(lk == 0)
801044a7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801044ab:	75 0d                	jne    801044ba <sleep+0x38>
    panic("sleep without lk");
801044ad:	83 ec 0c             	sub    $0xc,%esp
801044b0:	68 d1 a9 10 80       	push   $0x8010a9d1
801044b5:	e8 0b c1 ff ff       	call   801005c5 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
801044ba:	81 7d 0c 00 55 19 80 	cmpl   $0x80195500,0xc(%ebp)
801044c1:	74 1e                	je     801044e1 <sleep+0x5f>
    acquire(&ptable.lock);  //DOC: sleeplock1
801044c3:	83 ec 0c             	sub    $0xc,%esp
801044c6:	68 00 55 19 80       	push   $0x80195500
801044cb:	e8 78 05 00 00       	call   80104a48 <acquire>
801044d0:	83 c4 10             	add    $0x10,%esp
    release(lk);
801044d3:	83 ec 0c             	sub    $0xc,%esp
801044d6:	ff 75 0c             	pushl  0xc(%ebp)
801044d9:	e8 dc 05 00 00       	call   80104aba <release>
801044de:	83 c4 10             	add    $0x10,%esp
  }
  // Go to sleep.
  p->chan = chan;
801044e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044e4:	8b 55 08             	mov    0x8(%ebp),%edx
801044e7:	89 50 20             	mov    %edx,0x20(%eax)
  p->state = SLEEPING;
801044ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044ed:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
801044f4:	e8 44 fe ff ff       	call   8010433d <sched>

  // Tidy up.
  p->chan = 0;
801044f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044fc:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104503:	81 7d 0c 00 55 19 80 	cmpl   $0x80195500,0xc(%ebp)
8010450a:	74 1e                	je     8010452a <sleep+0xa8>
    release(&ptable.lock);
8010450c:	83 ec 0c             	sub    $0xc,%esp
8010450f:	68 00 55 19 80       	push   $0x80195500
80104514:	e8 a1 05 00 00       	call   80104aba <release>
80104519:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
8010451c:	83 ec 0c             	sub    $0xc,%esp
8010451f:	ff 75 0c             	pushl  0xc(%ebp)
80104522:	e8 21 05 00 00       	call   80104a48 <acquire>
80104527:	83 c4 10             	add    $0x10,%esp
  }
}
8010452a:	90                   	nop
8010452b:	c9                   	leave  
8010452c:	c3                   	ret    

8010452d <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
8010452d:	f3 0f 1e fb          	endbr32 
80104531:	55                   	push   %ebp
80104532:	89 e5                	mov    %esp,%ebp
80104534:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104537:	c7 45 fc 34 55 19 80 	movl   $0x80195534,-0x4(%ebp)
8010453e:	eb 24                	jmp    80104564 <wakeup1+0x37>
    if(p->state == SLEEPING && p->chan == chan)
80104540:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104543:	8b 40 0c             	mov    0xc(%eax),%eax
80104546:	83 f8 02             	cmp    $0x2,%eax
80104549:	75 15                	jne    80104560 <wakeup1+0x33>
8010454b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010454e:	8b 40 20             	mov    0x20(%eax),%eax
80104551:	39 45 08             	cmp    %eax,0x8(%ebp)
80104554:	75 0a                	jne    80104560 <wakeup1+0x33>
      p->state = RUNNABLE;
80104556:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104559:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104560:	83 45 fc 7c          	addl   $0x7c,-0x4(%ebp)
80104564:	81 7d fc 34 74 19 80 	cmpl   $0x80197434,-0x4(%ebp)
8010456b:	72 d3                	jb     80104540 <wakeup1+0x13>
}
8010456d:	90                   	nop
8010456e:	90                   	nop
8010456f:	c9                   	leave  
80104570:	c3                   	ret    

80104571 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104571:	f3 0f 1e fb          	endbr32 
80104575:	55                   	push   %ebp
80104576:	89 e5                	mov    %esp,%ebp
80104578:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
8010457b:	83 ec 0c             	sub    $0xc,%esp
8010457e:	68 00 55 19 80       	push   $0x80195500
80104583:	e8 c0 04 00 00       	call   80104a48 <acquire>
80104588:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
8010458b:	83 ec 0c             	sub    $0xc,%esp
8010458e:	ff 75 08             	pushl  0x8(%ebp)
80104591:	e8 97 ff ff ff       	call   8010452d <wakeup1>
80104596:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104599:	83 ec 0c             	sub    $0xc,%esp
8010459c:	68 00 55 19 80       	push   $0x80195500
801045a1:	e8 14 05 00 00       	call   80104aba <release>
801045a6:	83 c4 10             	add    $0x10,%esp
}
801045a9:	90                   	nop
801045aa:	c9                   	leave  
801045ab:	c3                   	ret    

801045ac <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801045ac:	f3 0f 1e fb          	endbr32 
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
801045b6:	83 ec 0c             	sub    $0xc,%esp
801045b9:	68 00 55 19 80       	push   $0x80195500
801045be:	e8 85 04 00 00       	call   80104a48 <acquire>
801045c3:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045c6:	c7 45 f4 34 55 19 80 	movl   $0x80195534,-0xc(%ebp)
801045cd:	eb 45                	jmp    80104614 <kill+0x68>
    if(p->pid == pid){
801045cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d2:	8b 40 10             	mov    0x10(%eax),%eax
801045d5:	39 45 08             	cmp    %eax,0x8(%ebp)
801045d8:	75 36                	jne    80104610 <kill+0x64>
      p->killed = 1;
801045da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045dd:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801045e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045e7:	8b 40 0c             	mov    0xc(%eax),%eax
801045ea:	83 f8 02             	cmp    $0x2,%eax
801045ed:	75 0a                	jne    801045f9 <kill+0x4d>
        p->state = RUNNABLE;
801045ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045f2:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801045f9:	83 ec 0c             	sub    $0xc,%esp
801045fc:	68 00 55 19 80       	push   $0x80195500
80104601:	e8 b4 04 00 00       	call   80104aba <release>
80104606:	83 c4 10             	add    $0x10,%esp
      return 0;
80104609:	b8 00 00 00 00       	mov    $0x0,%eax
8010460e:	eb 22                	jmp    80104632 <kill+0x86>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104610:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104614:	81 7d f4 34 74 19 80 	cmpl   $0x80197434,-0xc(%ebp)
8010461b:	72 b2                	jb     801045cf <kill+0x23>
    }
  }
  release(&ptable.lock);
8010461d:	83 ec 0c             	sub    $0xc,%esp
80104620:	68 00 55 19 80       	push   $0x80195500
80104625:	e8 90 04 00 00       	call   80104aba <release>
8010462a:	83 c4 10             	add    $0x10,%esp
  return -1;
8010462d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104632:	c9                   	leave  
80104633:	c3                   	ret    

80104634 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104634:	f3 0f 1e fb          	endbr32 
80104638:	55                   	push   %ebp
80104639:	89 e5                	mov    %esp,%ebp
8010463b:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010463e:	c7 45 f0 34 55 19 80 	movl   $0x80195534,-0x10(%ebp)
80104645:	e9 d7 00 00 00       	jmp    80104721 <procdump+0xed>
    if(p->state == UNUSED)
8010464a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010464d:	8b 40 0c             	mov    0xc(%eax),%eax
80104650:	85 c0                	test   %eax,%eax
80104652:	0f 84 c4 00 00 00    	je     8010471c <procdump+0xe8>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104658:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010465b:	8b 40 0c             	mov    0xc(%eax),%eax
8010465e:	83 f8 05             	cmp    $0x5,%eax
80104661:	77 23                	ja     80104686 <procdump+0x52>
80104663:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104666:	8b 40 0c             	mov    0xc(%eax),%eax
80104669:	8b 04 85 08 f0 10 80 	mov    -0x7fef0ff8(,%eax,4),%eax
80104670:	85 c0                	test   %eax,%eax
80104672:	74 12                	je     80104686 <procdump+0x52>
      state = states[p->state];
80104674:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104677:	8b 40 0c             	mov    0xc(%eax),%eax
8010467a:	8b 04 85 08 f0 10 80 	mov    -0x7fef0ff8(,%eax,4),%eax
80104681:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104684:	eb 07                	jmp    8010468d <procdump+0x59>
    else
      state = "???";
80104686:	c7 45 ec e2 a9 10 80 	movl   $0x8010a9e2,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
8010468d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104690:	8d 50 6c             	lea    0x6c(%eax),%edx
80104693:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104696:	8b 40 10             	mov    0x10(%eax),%eax
80104699:	52                   	push   %edx
8010469a:	ff 75 ec             	pushl  -0x14(%ebp)
8010469d:	50                   	push   %eax
8010469e:	68 e6 a9 10 80       	push   $0x8010a9e6
801046a3:	e8 64 bd ff ff       	call   8010040c <cprintf>
801046a8:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
801046ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801046ae:	8b 40 0c             	mov    0xc(%eax),%eax
801046b1:	83 f8 02             	cmp    $0x2,%eax
801046b4:	75 54                	jne    8010470a <procdump+0xd6>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801046b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801046b9:	8b 40 1c             	mov    0x1c(%eax),%eax
801046bc:	8b 40 0c             	mov    0xc(%eax),%eax
801046bf:	83 c0 08             	add    $0x8,%eax
801046c2:	89 c2                	mov    %eax,%edx
801046c4:	83 ec 08             	sub    $0x8,%esp
801046c7:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801046ca:	50                   	push   %eax
801046cb:	52                   	push   %edx
801046cc:	e8 3f 04 00 00       	call   80104b10 <getcallerpcs>
801046d1:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801046d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801046db:	eb 1c                	jmp    801046f9 <procdump+0xc5>
        cprintf(" %p", pc[i]);
801046dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046e0:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801046e4:	83 ec 08             	sub    $0x8,%esp
801046e7:	50                   	push   %eax
801046e8:	68 ef a9 10 80       	push   $0x8010a9ef
801046ed:	e8 1a bd ff ff       	call   8010040c <cprintf>
801046f2:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801046f5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801046f9:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801046fd:	7f 0b                	jg     8010470a <procdump+0xd6>
801046ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104702:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104706:	85 c0                	test   %eax,%eax
80104708:	75 d3                	jne    801046dd <procdump+0xa9>
    }
    cprintf("\n");
8010470a:	83 ec 0c             	sub    $0xc,%esp
8010470d:	68 f3 a9 10 80       	push   $0x8010a9f3
80104712:	e8 f5 bc ff ff       	call   8010040c <cprintf>
80104717:	83 c4 10             	add    $0x10,%esp
8010471a:	eb 01                	jmp    8010471d <procdump+0xe9>
      continue;
8010471c:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010471d:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
80104721:	81 7d f0 34 74 19 80 	cmpl   $0x80197434,-0x10(%ebp)
80104728:	0f 82 1c ff ff ff    	jb     8010464a <procdump+0x16>
  }
}
8010472e:	90                   	nop
8010472f:	90                   	nop
80104730:	c9                   	leave  
80104731:	c3                   	ret    

80104732 <printpt>:


// walk 하면서 Present+User 페이지만 출력
void
printpt(int pid)
{
80104732:	f3 0f 1e fb          	endbr32 
80104736:	55                   	push   %ebp
80104737:	89 e5                	mov    %esp,%ebp
80104739:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  acquire(&ptable.lock);               // ① 동시성 보호
8010473c:	83 ec 0c             	sub    $0xc,%esp
8010473f:	68 00 55 19 80       	push   $0x80195500
80104744:	e8 ff 02 00 00       	call   80104a48 <acquire>
80104749:	83 c4 10             	add    $0x10,%esp

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010474c:	c7 45 f4 34 55 19 80 	movl   $0x80195534,-0xc(%ebp)
80104753:	e9 2b 01 00 00       	jmp    80104883 <printpt+0x151>
    if (p->pid != pid)
80104758:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010475b:	8b 40 10             	mov    0x10(%eax),%eax
8010475e:	39 45 08             	cmp    %eax,0x8(%ebp)
80104761:	74 09                	je     8010476c <printpt+0x3a>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104763:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104767:	e9 17 01 00 00       	jmp    80104883 <printpt+0x151>
      continue;

    cprintf("START PAGE TABLE (pid %d)\n", pid);
8010476c:	83 ec 08             	sub    $0x8,%esp
8010476f:	ff 75 08             	pushl  0x8(%ebp)
80104772:	68 f5 a9 10 80       	push   $0x8010a9f5
80104777:	e8 90 bc ff ff       	call   8010040c <cprintf>
8010477c:	83 c4 10             	add    $0x10,%esp

    // 유저 공간 0 ~ KERNBASE-1
    for (uint va = 0; va < KERNBASE; va += PGSIZE) {
8010477f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104786:	e9 cb 00 00 00       	jmp    80104856 <printpt+0x124>
      pde_t pde = p->pgdir[PDX(va)];
8010478b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010478e:	8b 40 04             	mov    0x4(%eax),%eax
80104791:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104794:	c1 ea 16             	shr    $0x16,%edx
80104797:	c1 e2 02             	shl    $0x2,%edx
8010479a:	01 d0                	add    %edx,%eax
8010479c:	8b 00                	mov    (%eax),%eax
8010479e:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if (!(pde & PTE_P))
801047a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047a4:	83 e0 01             	and    $0x1,%eax
801047a7:	85 c0                	test   %eax,%eax
801047a9:	0f 84 9c 00 00 00    	je     8010484b <printpt+0x119>
        continue;

      pte_t *ptab = (pte_t*)P2V(PTE_ADDR(pde));
801047af:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801047b7:	05 00 00 00 80       	add    $0x80000000,%eax
801047bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
      pte_t  pte  = ptab[PTX(va)];
801047bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801047c2:	c1 e8 0c             	shr    $0xc,%eax
801047c5:	25 ff 03 00 00       	and    $0x3ff,%eax
801047ca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801047d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801047d4:	01 d0                	add    %edx,%eax
801047d6:	8b 00                	mov    (%eax),%eax
801047d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if (!(pte & PTE_P))
801047db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801047de:	83 e0 01             	and    $0x1,%eax
801047e1:	85 c0                	test   %eax,%eax
801047e3:	74 69                	je     8010484e <printpt+0x11c>
        continue;

      // ② VPN = va >> PGSHIFT
      uint vpn = va >> PGSHIFT;
801047e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801047e8:	c1 e8 0c             	shr    $0xc,%eax
801047eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
      uint ppn = PTE_ADDR(pte) >> PGSHIFT;
801047ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801047f1:	c1 e8 0c             	shr    $0xc,%eax
801047f4:	89 45 dc             	mov    %eax,-0x24(%ebp)
      char acc_u = (pte & PTE_U) ? 'U' : 'K';
801047f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801047fa:	83 e0 04             	and    $0x4,%eax
801047fd:	85 c0                	test   %eax,%eax
801047ff:	74 07                	je     80104808 <printpt+0xd6>
80104801:	b8 55 00 00 00       	mov    $0x55,%eax
80104806:	eb 05                	jmp    8010480d <printpt+0xdb>
80104808:	b8 4b 00 00 00       	mov    $0x4b,%eax
8010480d:	88 45 db             	mov    %al,-0x25(%ebp)
      char acc_w = (pte & PTE_W) ? 'W' : '-';
80104810:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104813:	83 e0 02             	and    $0x2,%eax
80104816:	85 c0                	test   %eax,%eax
80104818:	74 07                	je     80104821 <printpt+0xef>
8010481a:	b8 57 00 00 00       	mov    $0x57,%eax
8010481f:	eb 05                	jmp    80104826 <printpt+0xf4>
80104821:	b8 2d 00 00 00       	mov    $0x2d,%eax
80104826:	88 45 da             	mov    %al,-0x26(%ebp)

      cprintf("%5x  P %c %c  %5x\n", vpn, acc_u, acc_w, ppn);
80104829:	0f be 55 da          	movsbl -0x26(%ebp),%edx
8010482d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
80104831:	83 ec 0c             	sub    $0xc,%esp
80104834:	ff 75 dc             	pushl  -0x24(%ebp)
80104837:	52                   	push   %edx
80104838:	50                   	push   %eax
80104839:	ff 75 e0             	pushl  -0x20(%ebp)
8010483c:	68 10 aa 10 80       	push   $0x8010aa10
80104841:	e8 c6 bb ff ff       	call   8010040c <cprintf>
80104846:	83 c4 20             	add    $0x20,%esp
80104849:	eb 04                	jmp    8010484f <printpt+0x11d>
        continue;
8010484b:	90                   	nop
8010484c:	eb 01                	jmp    8010484f <printpt+0x11d>
        continue;
8010484e:	90                   	nop
    for (uint va = 0; va < KERNBASE; va += PGSIZE) {
8010484f:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
80104856:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104859:	85 c0                	test   %eax,%eax
8010485b:	0f 89 2a ff ff ff    	jns    8010478b <printpt+0x59>
    }

    cprintf("END PAGE TABLE\n");
80104861:	83 ec 0c             	sub    $0xc,%esp
80104864:	68 23 aa 10 80       	push   $0x8010aa23
80104869:	e8 9e bb ff ff       	call   8010040c <cprintf>
8010486e:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80104871:	83 ec 0c             	sub    $0xc,%esp
80104874:	68 00 55 19 80       	push   $0x80195500
80104879:	e8 3c 02 00 00       	call   80104aba <release>
8010487e:	83 c4 10             	add    $0x10,%esp
    return;
80104881:	eb 30                	jmp    801048b3 <printpt+0x181>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104883:	81 7d f4 34 74 19 80 	cmpl   $0x80197434,-0xc(%ebp)
8010488a:	0f 82 c8 fe ff ff    	jb     80104758 <printpt+0x26>
  }

  cprintf("printpt: pid %d not found\n", pid);
80104890:	83 ec 08             	sub    $0x8,%esp
80104893:	ff 75 08             	pushl  0x8(%ebp)
80104896:	68 33 aa 10 80       	push   $0x8010aa33
8010489b:	e8 6c bb ff ff       	call   8010040c <cprintf>
801048a0:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
801048a3:	83 ec 0c             	sub    $0xc,%esp
801048a6:	68 00 55 19 80       	push   $0x80195500
801048ab:	e8 0a 02 00 00       	call   80104aba <release>
801048b0:	83 c4 10             	add    $0x10,%esp
}
801048b3:	c9                   	leave  
801048b4:	c3                   	ret    

801048b5 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801048b5:	f3 0f 1e fb          	endbr32 
801048b9:	55                   	push   %ebp
801048ba:	89 e5                	mov    %esp,%ebp
801048bc:	83 ec 08             	sub    $0x8,%esp
  initlock(&lk->lk, "sleep lock");
801048bf:	8b 45 08             	mov    0x8(%ebp),%eax
801048c2:	83 c0 04             	add    $0x4,%eax
801048c5:	83 ec 08             	sub    $0x8,%esp
801048c8:	68 78 aa 10 80       	push   $0x8010aa78
801048cd:	50                   	push   %eax
801048ce:	e8 4f 01 00 00       	call   80104a22 <initlock>
801048d3:	83 c4 10             	add    $0x10,%esp
  lk->name = name;
801048d6:	8b 45 08             	mov    0x8(%ebp),%eax
801048d9:	8b 55 0c             	mov    0xc(%ebp),%edx
801048dc:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
801048df:	8b 45 08             	mov    0x8(%ebp),%eax
801048e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
801048e8:	8b 45 08             	mov    0x8(%ebp),%eax
801048eb:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
801048f2:	90                   	nop
801048f3:	c9                   	leave  
801048f4:	c3                   	ret    

801048f5 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801048f5:	f3 0f 1e fb          	endbr32 
801048f9:	55                   	push   %ebp
801048fa:	89 e5                	mov    %esp,%ebp
801048fc:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
801048ff:	8b 45 08             	mov    0x8(%ebp),%eax
80104902:	83 c0 04             	add    $0x4,%eax
80104905:	83 ec 0c             	sub    $0xc,%esp
80104908:	50                   	push   %eax
80104909:	e8 3a 01 00 00       	call   80104a48 <acquire>
8010490e:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80104911:	eb 15                	jmp    80104928 <acquiresleep+0x33>
    sleep(lk, &lk->lk);
80104913:	8b 45 08             	mov    0x8(%ebp),%eax
80104916:	83 c0 04             	add    $0x4,%eax
80104919:	83 ec 08             	sub    $0x8,%esp
8010491c:	50                   	push   %eax
8010491d:	ff 75 08             	pushl  0x8(%ebp)
80104920:	e8 5d fb ff ff       	call   80104482 <sleep>
80104925:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80104928:	8b 45 08             	mov    0x8(%ebp),%eax
8010492b:	8b 00                	mov    (%eax),%eax
8010492d:	85 c0                	test   %eax,%eax
8010492f:	75 e2                	jne    80104913 <acquiresleep+0x1e>
  }
  lk->locked = 1;
80104931:	8b 45 08             	mov    0x8(%ebp),%eax
80104934:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
8010493a:	e8 6a f2 ff ff       	call   80103ba9 <myproc>
8010493f:	8b 50 10             	mov    0x10(%eax),%edx
80104942:	8b 45 08             	mov    0x8(%ebp),%eax
80104945:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
80104948:	8b 45 08             	mov    0x8(%ebp),%eax
8010494b:	83 c0 04             	add    $0x4,%eax
8010494e:	83 ec 0c             	sub    $0xc,%esp
80104951:	50                   	push   %eax
80104952:	e8 63 01 00 00       	call   80104aba <release>
80104957:	83 c4 10             	add    $0x10,%esp
}
8010495a:	90                   	nop
8010495b:	c9                   	leave  
8010495c:	c3                   	ret    

8010495d <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
8010495d:	f3 0f 1e fb          	endbr32 
80104961:	55                   	push   %ebp
80104962:	89 e5                	mov    %esp,%ebp
80104964:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
80104967:	8b 45 08             	mov    0x8(%ebp),%eax
8010496a:	83 c0 04             	add    $0x4,%eax
8010496d:	83 ec 0c             	sub    $0xc,%esp
80104970:	50                   	push   %eax
80104971:	e8 d2 00 00 00       	call   80104a48 <acquire>
80104976:	83 c4 10             	add    $0x10,%esp
  lk->locked = 0;
80104979:	8b 45 08             	mov    0x8(%ebp),%eax
8010497c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104982:	8b 45 08             	mov    0x8(%ebp),%eax
80104985:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
8010498c:	83 ec 0c             	sub    $0xc,%esp
8010498f:	ff 75 08             	pushl  0x8(%ebp)
80104992:	e8 da fb ff ff       	call   80104571 <wakeup>
80104997:	83 c4 10             	add    $0x10,%esp
  release(&lk->lk);
8010499a:	8b 45 08             	mov    0x8(%ebp),%eax
8010499d:	83 c0 04             	add    $0x4,%eax
801049a0:	83 ec 0c             	sub    $0xc,%esp
801049a3:	50                   	push   %eax
801049a4:	e8 11 01 00 00       	call   80104aba <release>
801049a9:	83 c4 10             	add    $0x10,%esp
}
801049ac:	90                   	nop
801049ad:	c9                   	leave  
801049ae:	c3                   	ret    

801049af <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801049af:	f3 0f 1e fb          	endbr32 
801049b3:	55                   	push   %ebp
801049b4:	89 e5                	mov    %esp,%ebp
801049b6:	83 ec 18             	sub    $0x18,%esp
  int r;
  
  acquire(&lk->lk);
801049b9:	8b 45 08             	mov    0x8(%ebp),%eax
801049bc:	83 c0 04             	add    $0x4,%eax
801049bf:	83 ec 0c             	sub    $0xc,%esp
801049c2:	50                   	push   %eax
801049c3:	e8 80 00 00 00       	call   80104a48 <acquire>
801049c8:	83 c4 10             	add    $0x10,%esp
  r = lk->locked;
801049cb:	8b 45 08             	mov    0x8(%ebp),%eax
801049ce:	8b 00                	mov    (%eax),%eax
801049d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
801049d3:	8b 45 08             	mov    0x8(%ebp),%eax
801049d6:	83 c0 04             	add    $0x4,%eax
801049d9:	83 ec 0c             	sub    $0xc,%esp
801049dc:	50                   	push   %eax
801049dd:	e8 d8 00 00 00       	call   80104aba <release>
801049e2:	83 c4 10             	add    $0x10,%esp
  return r;
801049e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801049e8:	c9                   	leave  
801049e9:	c3                   	ret    

801049ea <readeflags>:
{
801049ea:	55                   	push   %ebp
801049eb:	89 e5                	mov    %esp,%ebp
801049ed:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801049f0:	9c                   	pushf  
801049f1:	58                   	pop    %eax
801049f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801049f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801049f8:	c9                   	leave  
801049f9:	c3                   	ret    

801049fa <cli>:
{
801049fa:	55                   	push   %ebp
801049fb:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801049fd:	fa                   	cli    
}
801049fe:	90                   	nop
801049ff:	5d                   	pop    %ebp
80104a00:	c3                   	ret    

80104a01 <sti>:
{
80104a01:	55                   	push   %ebp
80104a02:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104a04:	fb                   	sti    
}
80104a05:	90                   	nop
80104a06:	5d                   	pop    %ebp
80104a07:	c3                   	ret    

80104a08 <xchg>:
{
80104a08:	55                   	push   %ebp
80104a09:	89 e5                	mov    %esp,%ebp
80104a0b:	83 ec 10             	sub    $0x10,%esp
  asm volatile("lock; xchgl %0, %1" :
80104a0e:	8b 55 08             	mov    0x8(%ebp),%edx
80104a11:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a14:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104a17:	f0 87 02             	lock xchg %eax,(%edx)
80104a1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return result;
80104a1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104a20:	c9                   	leave  
80104a21:	c3                   	ret    

80104a22 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104a22:	f3 0f 1e fb          	endbr32 
80104a26:	55                   	push   %ebp
80104a27:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104a29:	8b 45 08             	mov    0x8(%ebp),%eax
80104a2c:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a2f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104a32:	8b 45 08             	mov    0x8(%ebp),%eax
80104a35:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104a3b:	8b 45 08             	mov    0x8(%ebp),%eax
80104a3e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104a45:	90                   	nop
80104a46:	5d                   	pop    %ebp
80104a47:	c3                   	ret    

80104a48 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104a48:	f3 0f 1e fb          	endbr32 
80104a4c:	55                   	push   %ebp
80104a4d:	89 e5                	mov    %esp,%ebp
80104a4f:	53                   	push   %ebx
80104a50:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104a53:	e8 6c 01 00 00       	call   80104bc4 <pushcli>
  if(holding(lk)){
80104a58:	8b 45 08             	mov    0x8(%ebp),%eax
80104a5b:	83 ec 0c             	sub    $0xc,%esp
80104a5e:	50                   	push   %eax
80104a5f:	e8 2b 01 00 00       	call   80104b8f <holding>
80104a64:	83 c4 10             	add    $0x10,%esp
80104a67:	85 c0                	test   %eax,%eax
80104a69:	74 0d                	je     80104a78 <acquire+0x30>
    panic("acquire");
80104a6b:	83 ec 0c             	sub    $0xc,%esp
80104a6e:	68 83 aa 10 80       	push   $0x8010aa83
80104a73:	e8 4d bb ff ff       	call   801005c5 <panic>
  }

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104a78:	90                   	nop
80104a79:	8b 45 08             	mov    0x8(%ebp),%eax
80104a7c:	83 ec 08             	sub    $0x8,%esp
80104a7f:	6a 01                	push   $0x1
80104a81:	50                   	push   %eax
80104a82:	e8 81 ff ff ff       	call   80104a08 <xchg>
80104a87:	83 c4 10             	add    $0x10,%esp
80104a8a:	85 c0                	test   %eax,%eax
80104a8c:	75 eb                	jne    80104a79 <acquire+0x31>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104a8e:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104a93:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a96:	e8 92 f0 ff ff       	call   80103b2d <mycpu>
80104a9b:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80104a9e:	8b 45 08             	mov    0x8(%ebp),%eax
80104aa1:	83 c0 0c             	add    $0xc,%eax
80104aa4:	83 ec 08             	sub    $0x8,%esp
80104aa7:	50                   	push   %eax
80104aa8:	8d 45 08             	lea    0x8(%ebp),%eax
80104aab:	50                   	push   %eax
80104aac:	e8 5f 00 00 00       	call   80104b10 <getcallerpcs>
80104ab1:	83 c4 10             	add    $0x10,%esp
}
80104ab4:	90                   	nop
80104ab5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ab8:	c9                   	leave  
80104ab9:	c3                   	ret    

80104aba <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104aba:	f3 0f 1e fb          	endbr32 
80104abe:	55                   	push   %ebp
80104abf:	89 e5                	mov    %esp,%ebp
80104ac1:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80104ac4:	83 ec 0c             	sub    $0xc,%esp
80104ac7:	ff 75 08             	pushl  0x8(%ebp)
80104aca:	e8 c0 00 00 00       	call   80104b8f <holding>
80104acf:	83 c4 10             	add    $0x10,%esp
80104ad2:	85 c0                	test   %eax,%eax
80104ad4:	75 0d                	jne    80104ae3 <release+0x29>
    panic("release");
80104ad6:	83 ec 0c             	sub    $0xc,%esp
80104ad9:	68 8b aa 10 80       	push   $0x8010aa8b
80104ade:	e8 e2 ba ff ff       	call   801005c5 <panic>

  lk->pcs[0] = 0;
80104ae3:	8b 45 08             	mov    0x8(%ebp),%eax
80104ae6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104aed:	8b 45 08             	mov    0x8(%ebp),%eax
80104af0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104af7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104afc:	8b 45 08             	mov    0x8(%ebp),%eax
80104aff:	8b 55 08             	mov    0x8(%ebp),%edx
80104b02:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
80104b08:	e8 08 01 00 00       	call   80104c15 <popcli>
}
80104b0d:	90                   	nop
80104b0e:	c9                   	leave  
80104b0f:	c3                   	ret    

80104b10 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104b10:	f3 0f 1e fb          	endbr32 
80104b14:	55                   	push   %ebp
80104b15:	89 e5                	mov    %esp,%ebp
80104b17:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104b1a:	8b 45 08             	mov    0x8(%ebp),%eax
80104b1d:	83 e8 08             	sub    $0x8,%eax
80104b20:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104b23:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80104b2a:	eb 38                	jmp    80104b64 <getcallerpcs+0x54>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104b2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104b30:	74 53                	je     80104b85 <getcallerpcs+0x75>
80104b32:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80104b39:	76 4a                	jbe    80104b85 <getcallerpcs+0x75>
80104b3b:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80104b3f:	74 44                	je     80104b85 <getcallerpcs+0x75>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104b41:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104b44:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b4e:	01 c2                	add    %eax,%edx
80104b50:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104b53:	8b 40 04             	mov    0x4(%eax),%eax
80104b56:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80104b58:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104b5b:	8b 00                	mov    (%eax),%eax
80104b5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104b60:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104b64:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104b68:	7e c2                	jle    80104b2c <getcallerpcs+0x1c>
  }
  for(; i < 10; i++)
80104b6a:	eb 19                	jmp    80104b85 <getcallerpcs+0x75>
    pcs[i] = 0;
80104b6c:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104b6f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104b76:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b79:	01 d0                	add    %edx,%eax
80104b7b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104b81:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104b85:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104b89:	7e e1                	jle    80104b6c <getcallerpcs+0x5c>
}
80104b8b:	90                   	nop
80104b8c:	90                   	nop
80104b8d:	c9                   	leave  
80104b8e:	c3                   	ret    

80104b8f <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104b8f:	f3 0f 1e fb          	endbr32 
80104b93:	55                   	push   %ebp
80104b94:	89 e5                	mov    %esp,%ebp
80104b96:	53                   	push   %ebx
80104b97:	83 ec 04             	sub    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104b9a:	8b 45 08             	mov    0x8(%ebp),%eax
80104b9d:	8b 00                	mov    (%eax),%eax
80104b9f:	85 c0                	test   %eax,%eax
80104ba1:	74 16                	je     80104bb9 <holding+0x2a>
80104ba3:	8b 45 08             	mov    0x8(%ebp),%eax
80104ba6:	8b 58 08             	mov    0x8(%eax),%ebx
80104ba9:	e8 7f ef ff ff       	call   80103b2d <mycpu>
80104bae:	39 c3                	cmp    %eax,%ebx
80104bb0:	75 07                	jne    80104bb9 <holding+0x2a>
80104bb2:	b8 01 00 00 00       	mov    $0x1,%eax
80104bb7:	eb 05                	jmp    80104bbe <holding+0x2f>
80104bb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104bbe:	83 c4 04             	add    $0x4,%esp
80104bc1:	5b                   	pop    %ebx
80104bc2:	5d                   	pop    %ebp
80104bc3:	c3                   	ret    

80104bc4 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104bc4:	f3 0f 1e fb          	endbr32 
80104bc8:	55                   	push   %ebp
80104bc9:	89 e5                	mov    %esp,%ebp
80104bcb:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
80104bce:	e8 17 fe ff ff       	call   801049ea <readeflags>
80104bd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
80104bd6:	e8 1f fe ff ff       	call   801049fa <cli>
  if(mycpu()->ncli == 0)
80104bdb:	e8 4d ef ff ff       	call   80103b2d <mycpu>
80104be0:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104be6:	85 c0                	test   %eax,%eax
80104be8:	75 14                	jne    80104bfe <pushcli+0x3a>
    mycpu()->intena = eflags & FL_IF;
80104bea:	e8 3e ef ff ff       	call   80103b2d <mycpu>
80104bef:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104bf2:	81 e2 00 02 00 00    	and    $0x200,%edx
80104bf8:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
  mycpu()->ncli += 1;
80104bfe:	e8 2a ef ff ff       	call   80103b2d <mycpu>
80104c03:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104c09:	83 c2 01             	add    $0x1,%edx
80104c0c:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
80104c12:	90                   	nop
80104c13:	c9                   	leave  
80104c14:	c3                   	ret    

80104c15 <popcli>:

void
popcli(void)
{
80104c15:	f3 0f 1e fb          	endbr32 
80104c19:	55                   	push   %ebp
80104c1a:	89 e5                	mov    %esp,%ebp
80104c1c:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80104c1f:	e8 c6 fd ff ff       	call   801049ea <readeflags>
80104c24:	25 00 02 00 00       	and    $0x200,%eax
80104c29:	85 c0                	test   %eax,%eax
80104c2b:	74 0d                	je     80104c3a <popcli+0x25>
    panic("popcli - interruptible");
80104c2d:	83 ec 0c             	sub    $0xc,%esp
80104c30:	68 93 aa 10 80       	push   $0x8010aa93
80104c35:	e8 8b b9 ff ff       	call   801005c5 <panic>
  if(--mycpu()->ncli < 0)
80104c3a:	e8 ee ee ff ff       	call   80103b2d <mycpu>
80104c3f:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104c45:	83 ea 01             	sub    $0x1,%edx
80104c48:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104c4e:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104c54:	85 c0                	test   %eax,%eax
80104c56:	79 0d                	jns    80104c65 <popcli+0x50>
    panic("popcli");
80104c58:	83 ec 0c             	sub    $0xc,%esp
80104c5b:	68 aa aa 10 80       	push   $0x8010aaaa
80104c60:	e8 60 b9 ff ff       	call   801005c5 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104c65:	e8 c3 ee ff ff       	call   80103b2d <mycpu>
80104c6a:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104c70:	85 c0                	test   %eax,%eax
80104c72:	75 14                	jne    80104c88 <popcli+0x73>
80104c74:	e8 b4 ee ff ff       	call   80103b2d <mycpu>
80104c79:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104c7f:	85 c0                	test   %eax,%eax
80104c81:	74 05                	je     80104c88 <popcli+0x73>
    sti();
80104c83:	e8 79 fd ff ff       	call   80104a01 <sti>
}
80104c88:	90                   	nop
80104c89:	c9                   	leave  
80104c8a:	c3                   	ret    

80104c8b <stosb>:
{
80104c8b:	55                   	push   %ebp
80104c8c:	89 e5                	mov    %esp,%ebp
80104c8e:	57                   	push   %edi
80104c8f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80104c90:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104c93:	8b 55 10             	mov    0x10(%ebp),%edx
80104c96:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c99:	89 cb                	mov    %ecx,%ebx
80104c9b:	89 df                	mov    %ebx,%edi
80104c9d:	89 d1                	mov    %edx,%ecx
80104c9f:	fc                   	cld    
80104ca0:	f3 aa                	rep stos %al,%es:(%edi)
80104ca2:	89 ca                	mov    %ecx,%edx
80104ca4:	89 fb                	mov    %edi,%ebx
80104ca6:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104ca9:	89 55 10             	mov    %edx,0x10(%ebp)
}
80104cac:	90                   	nop
80104cad:	5b                   	pop    %ebx
80104cae:	5f                   	pop    %edi
80104caf:	5d                   	pop    %ebp
80104cb0:	c3                   	ret    

80104cb1 <stosl>:
{
80104cb1:	55                   	push   %ebp
80104cb2:	89 e5                	mov    %esp,%ebp
80104cb4:	57                   	push   %edi
80104cb5:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80104cb6:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104cb9:	8b 55 10             	mov    0x10(%ebp),%edx
80104cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cbf:	89 cb                	mov    %ecx,%ebx
80104cc1:	89 df                	mov    %ebx,%edi
80104cc3:	89 d1                	mov    %edx,%ecx
80104cc5:	fc                   	cld    
80104cc6:	f3 ab                	rep stos %eax,%es:(%edi)
80104cc8:	89 ca                	mov    %ecx,%edx
80104cca:	89 fb                	mov    %edi,%ebx
80104ccc:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104ccf:	89 55 10             	mov    %edx,0x10(%ebp)
}
80104cd2:	90                   	nop
80104cd3:	5b                   	pop    %ebx
80104cd4:	5f                   	pop    %edi
80104cd5:	5d                   	pop    %ebp
80104cd6:	c3                   	ret    

80104cd7 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104cd7:	f3 0f 1e fb          	endbr32 
80104cdb:	55                   	push   %ebp
80104cdc:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80104cde:	8b 45 08             	mov    0x8(%ebp),%eax
80104ce1:	83 e0 03             	and    $0x3,%eax
80104ce4:	85 c0                	test   %eax,%eax
80104ce6:	75 43                	jne    80104d2b <memset+0x54>
80104ce8:	8b 45 10             	mov    0x10(%ebp),%eax
80104ceb:	83 e0 03             	and    $0x3,%eax
80104cee:	85 c0                	test   %eax,%eax
80104cf0:	75 39                	jne    80104d2b <memset+0x54>
    c &= 0xFF;
80104cf2:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104cf9:	8b 45 10             	mov    0x10(%ebp),%eax
80104cfc:	c1 e8 02             	shr    $0x2,%eax
80104cff:	89 c1                	mov    %eax,%ecx
80104d01:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d04:	c1 e0 18             	shl    $0x18,%eax
80104d07:	89 c2                	mov    %eax,%edx
80104d09:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d0c:	c1 e0 10             	shl    $0x10,%eax
80104d0f:	09 c2                	or     %eax,%edx
80104d11:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d14:	c1 e0 08             	shl    $0x8,%eax
80104d17:	09 d0                	or     %edx,%eax
80104d19:	0b 45 0c             	or     0xc(%ebp),%eax
80104d1c:	51                   	push   %ecx
80104d1d:	50                   	push   %eax
80104d1e:	ff 75 08             	pushl  0x8(%ebp)
80104d21:	e8 8b ff ff ff       	call   80104cb1 <stosl>
80104d26:	83 c4 0c             	add    $0xc,%esp
80104d29:	eb 12                	jmp    80104d3d <memset+0x66>
  } else
    stosb(dst, c, n);
80104d2b:	8b 45 10             	mov    0x10(%ebp),%eax
80104d2e:	50                   	push   %eax
80104d2f:	ff 75 0c             	pushl  0xc(%ebp)
80104d32:	ff 75 08             	pushl  0x8(%ebp)
80104d35:	e8 51 ff ff ff       	call   80104c8b <stosb>
80104d3a:	83 c4 0c             	add    $0xc,%esp
  return dst;
80104d3d:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104d40:	c9                   	leave  
80104d41:	c3                   	ret    

80104d42 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104d42:	f3 0f 1e fb          	endbr32 
80104d46:	55                   	push   %ebp
80104d47:	89 e5                	mov    %esp,%ebp
80104d49:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
80104d4c:	8b 45 08             	mov    0x8(%ebp),%eax
80104d4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80104d52:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d55:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80104d58:	eb 30                	jmp    80104d8a <memcmp+0x48>
    if(*s1 != *s2)
80104d5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d5d:	0f b6 10             	movzbl (%eax),%edx
80104d60:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104d63:	0f b6 00             	movzbl (%eax),%eax
80104d66:	38 c2                	cmp    %al,%dl
80104d68:	74 18                	je     80104d82 <memcmp+0x40>
      return *s1 - *s2;
80104d6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d6d:	0f b6 00             	movzbl (%eax),%eax
80104d70:	0f b6 d0             	movzbl %al,%edx
80104d73:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104d76:	0f b6 00             	movzbl (%eax),%eax
80104d79:	0f b6 c0             	movzbl %al,%eax
80104d7c:	29 c2                	sub    %eax,%edx
80104d7e:	89 d0                	mov    %edx,%eax
80104d80:	eb 1a                	jmp    80104d9c <memcmp+0x5a>
    s1++, s2++;
80104d82:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104d86:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  while(n-- > 0){
80104d8a:	8b 45 10             	mov    0x10(%ebp),%eax
80104d8d:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d90:	89 55 10             	mov    %edx,0x10(%ebp)
80104d93:	85 c0                	test   %eax,%eax
80104d95:	75 c3                	jne    80104d5a <memcmp+0x18>
  }

  return 0;
80104d97:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104d9c:	c9                   	leave  
80104d9d:	c3                   	ret    

80104d9e <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104d9e:	f3 0f 1e fb          	endbr32 
80104da2:	55                   	push   %ebp
80104da3:	89 e5                	mov    %esp,%ebp
80104da5:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80104da8:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dab:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80104dae:	8b 45 08             	mov    0x8(%ebp),%eax
80104db1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80104db4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104db7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104dba:	73 54                	jae    80104e10 <memmove+0x72>
80104dbc:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104dbf:	8b 45 10             	mov    0x10(%ebp),%eax
80104dc2:	01 d0                	add    %edx,%eax
80104dc4:	39 45 f8             	cmp    %eax,-0x8(%ebp)
80104dc7:	73 47                	jae    80104e10 <memmove+0x72>
    s += n;
80104dc9:	8b 45 10             	mov    0x10(%ebp),%eax
80104dcc:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80104dcf:	8b 45 10             	mov    0x10(%ebp),%eax
80104dd2:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80104dd5:	eb 13                	jmp    80104dea <memmove+0x4c>
      *--d = *--s;
80104dd7:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80104ddb:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80104ddf:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104de2:	0f b6 10             	movzbl (%eax),%edx
80104de5:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104de8:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
80104dea:	8b 45 10             	mov    0x10(%ebp),%eax
80104ded:	8d 50 ff             	lea    -0x1(%eax),%edx
80104df0:	89 55 10             	mov    %edx,0x10(%ebp)
80104df3:	85 c0                	test   %eax,%eax
80104df5:	75 e0                	jne    80104dd7 <memmove+0x39>
  if(s < d && s + n > d){
80104df7:	eb 24                	jmp    80104e1d <memmove+0x7f>
  } else
    while(n-- > 0)
      *d++ = *s++;
80104df9:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104dfc:	8d 42 01             	lea    0x1(%edx),%eax
80104dff:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104e02:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104e05:	8d 48 01             	lea    0x1(%eax),%ecx
80104e08:	89 4d f8             	mov    %ecx,-0x8(%ebp)
80104e0b:	0f b6 12             	movzbl (%edx),%edx
80104e0e:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
80104e10:	8b 45 10             	mov    0x10(%ebp),%eax
80104e13:	8d 50 ff             	lea    -0x1(%eax),%edx
80104e16:	89 55 10             	mov    %edx,0x10(%ebp)
80104e19:	85 c0                	test   %eax,%eax
80104e1b:	75 dc                	jne    80104df9 <memmove+0x5b>

  return dst;
80104e1d:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104e20:	c9                   	leave  
80104e21:	c3                   	ret    

80104e22 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104e22:	f3 0f 1e fb          	endbr32 
80104e26:	55                   	push   %ebp
80104e27:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80104e29:	ff 75 10             	pushl  0x10(%ebp)
80104e2c:	ff 75 0c             	pushl  0xc(%ebp)
80104e2f:	ff 75 08             	pushl  0x8(%ebp)
80104e32:	e8 67 ff ff ff       	call   80104d9e <memmove>
80104e37:	83 c4 0c             	add    $0xc,%esp
}
80104e3a:	c9                   	leave  
80104e3b:	c3                   	ret    

80104e3c <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104e3c:	f3 0f 1e fb          	endbr32 
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80104e43:	eb 0c                	jmp    80104e51 <strncmp+0x15>
    n--, p++, q++;
80104e45:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104e49:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80104e4d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(n > 0 && *p && *p == *q)
80104e51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104e55:	74 1a                	je     80104e71 <strncmp+0x35>
80104e57:	8b 45 08             	mov    0x8(%ebp),%eax
80104e5a:	0f b6 00             	movzbl (%eax),%eax
80104e5d:	84 c0                	test   %al,%al
80104e5f:	74 10                	je     80104e71 <strncmp+0x35>
80104e61:	8b 45 08             	mov    0x8(%ebp),%eax
80104e64:	0f b6 10             	movzbl (%eax),%edx
80104e67:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e6a:	0f b6 00             	movzbl (%eax),%eax
80104e6d:	38 c2                	cmp    %al,%dl
80104e6f:	74 d4                	je     80104e45 <strncmp+0x9>
  if(n == 0)
80104e71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104e75:	75 07                	jne    80104e7e <strncmp+0x42>
    return 0;
80104e77:	b8 00 00 00 00       	mov    $0x0,%eax
80104e7c:	eb 16                	jmp    80104e94 <strncmp+0x58>
  return (uchar)*p - (uchar)*q;
80104e7e:	8b 45 08             	mov    0x8(%ebp),%eax
80104e81:	0f b6 00             	movzbl (%eax),%eax
80104e84:	0f b6 d0             	movzbl %al,%edx
80104e87:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e8a:	0f b6 00             	movzbl (%eax),%eax
80104e8d:	0f b6 c0             	movzbl %al,%eax
80104e90:	29 c2                	sub    %eax,%edx
80104e92:	89 d0                	mov    %edx,%eax
}
80104e94:	5d                   	pop    %ebp
80104e95:	c3                   	ret    

80104e96 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104e96:	f3 0f 1e fb          	endbr32 
80104e9a:	55                   	push   %ebp
80104e9b:	89 e5                	mov    %esp,%ebp
80104e9d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80104ea0:	8b 45 08             	mov    0x8(%ebp),%eax
80104ea3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80104ea6:	90                   	nop
80104ea7:	8b 45 10             	mov    0x10(%ebp),%eax
80104eaa:	8d 50 ff             	lea    -0x1(%eax),%edx
80104ead:	89 55 10             	mov    %edx,0x10(%ebp)
80104eb0:	85 c0                	test   %eax,%eax
80104eb2:	7e 2c                	jle    80104ee0 <strncpy+0x4a>
80104eb4:	8b 55 0c             	mov    0xc(%ebp),%edx
80104eb7:	8d 42 01             	lea    0x1(%edx),%eax
80104eba:	89 45 0c             	mov    %eax,0xc(%ebp)
80104ebd:	8b 45 08             	mov    0x8(%ebp),%eax
80104ec0:	8d 48 01             	lea    0x1(%eax),%ecx
80104ec3:	89 4d 08             	mov    %ecx,0x8(%ebp)
80104ec6:	0f b6 12             	movzbl (%edx),%edx
80104ec9:	88 10                	mov    %dl,(%eax)
80104ecb:	0f b6 00             	movzbl (%eax),%eax
80104ece:	84 c0                	test   %al,%al
80104ed0:	75 d5                	jne    80104ea7 <strncpy+0x11>
    ;
  while(n-- > 0)
80104ed2:	eb 0c                	jmp    80104ee0 <strncpy+0x4a>
    *s++ = 0;
80104ed4:	8b 45 08             	mov    0x8(%ebp),%eax
80104ed7:	8d 50 01             	lea    0x1(%eax),%edx
80104eda:	89 55 08             	mov    %edx,0x8(%ebp)
80104edd:	c6 00 00             	movb   $0x0,(%eax)
  while(n-- > 0)
80104ee0:	8b 45 10             	mov    0x10(%ebp),%eax
80104ee3:	8d 50 ff             	lea    -0x1(%eax),%edx
80104ee6:	89 55 10             	mov    %edx,0x10(%ebp)
80104ee9:	85 c0                	test   %eax,%eax
80104eeb:	7f e7                	jg     80104ed4 <strncpy+0x3e>
  return os;
80104eed:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104ef0:	c9                   	leave  
80104ef1:	c3                   	ret    

80104ef2 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104ef2:	f3 0f 1e fb          	endbr32 
80104ef6:	55                   	push   %ebp
80104ef7:	89 e5                	mov    %esp,%ebp
80104ef9:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80104efc:	8b 45 08             	mov    0x8(%ebp),%eax
80104eff:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80104f02:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104f06:	7f 05                	jg     80104f0d <safestrcpy+0x1b>
    return os;
80104f08:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f0b:	eb 31                	jmp    80104f3e <safestrcpy+0x4c>
  while(--n > 0 && (*s++ = *t++) != 0)
80104f0d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104f11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104f15:	7e 1e                	jle    80104f35 <safestrcpy+0x43>
80104f17:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f1a:	8d 42 01             	lea    0x1(%edx),%eax
80104f1d:	89 45 0c             	mov    %eax,0xc(%ebp)
80104f20:	8b 45 08             	mov    0x8(%ebp),%eax
80104f23:	8d 48 01             	lea    0x1(%eax),%ecx
80104f26:	89 4d 08             	mov    %ecx,0x8(%ebp)
80104f29:	0f b6 12             	movzbl (%edx),%edx
80104f2c:	88 10                	mov    %dl,(%eax)
80104f2e:	0f b6 00             	movzbl (%eax),%eax
80104f31:	84 c0                	test   %al,%al
80104f33:	75 d8                	jne    80104f0d <safestrcpy+0x1b>
    ;
  *s = 0;
80104f35:	8b 45 08             	mov    0x8(%ebp),%eax
80104f38:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80104f3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104f3e:	c9                   	leave  
80104f3f:	c3                   	ret    

80104f40 <strlen>:

int
strlen(const char *s)
{
80104f40:	f3 0f 1e fb          	endbr32 
80104f44:	55                   	push   %ebp
80104f45:	89 e5                	mov    %esp,%ebp
80104f47:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80104f4a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80104f51:	eb 04                	jmp    80104f57 <strlen+0x17>
80104f53:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104f57:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104f5a:	8b 45 08             	mov    0x8(%ebp),%eax
80104f5d:	01 d0                	add    %edx,%eax
80104f5f:	0f b6 00             	movzbl (%eax),%eax
80104f62:	84 c0                	test   %al,%al
80104f64:	75 ed                	jne    80104f53 <strlen+0x13>
    ;
  return n;
80104f66:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104f69:	c9                   	leave  
80104f6a:	c3                   	ret    

80104f6b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104f6b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104f6f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104f73:	55                   	push   %ebp
  pushl %ebx
80104f74:	53                   	push   %ebx
  pushl %esi
80104f75:	56                   	push   %esi
  pushl %edi
80104f76:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104f77:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104f79:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104f7b:	5f                   	pop    %edi
  popl %esi
80104f7c:	5e                   	pop    %esi
  popl %ebx
80104f7d:	5b                   	pop    %ebx
  popl %ebp
80104f7e:	5d                   	pop    %ebp
  ret
80104f7f:	c3                   	ret    

80104f80 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104f80:	f3 0f 1e fb          	endbr32 
80104f84:	55                   	push   %ebp
80104f85:	89 e5                	mov    %esp,%ebp
80104f87:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80104f8a:	e8 1a ec ff ff       	call   80103ba9 <myproc>
80104f8f:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f95:	8b 00                	mov    (%eax),%eax
80104f97:	39 45 08             	cmp    %eax,0x8(%ebp)
80104f9a:	73 0f                	jae    80104fab <fetchint+0x2b>
80104f9c:	8b 45 08             	mov    0x8(%ebp),%eax
80104f9f:	8d 50 04             	lea    0x4(%eax),%edx
80104fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fa5:	8b 00                	mov    (%eax),%eax
80104fa7:	39 c2                	cmp    %eax,%edx
80104fa9:	76 07                	jbe    80104fb2 <fetchint+0x32>
    return -1;
80104fab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fb0:	eb 0f                	jmp    80104fc1 <fetchint+0x41>
  *ip = *(int*)(addr);
80104fb2:	8b 45 08             	mov    0x8(%ebp),%eax
80104fb5:	8b 10                	mov    (%eax),%edx
80104fb7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fba:	89 10                	mov    %edx,(%eax)
  return 0;
80104fbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104fc1:	c9                   	leave  
80104fc2:	c3                   	ret    

80104fc3 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104fc3:	f3 0f 1e fb          	endbr32 
80104fc7:	55                   	push   %ebp
80104fc8:	89 e5                	mov    %esp,%ebp
80104fca:	83 ec 18             	sub    $0x18,%esp
  char *s, *ep;
  struct proc *curproc = myproc();
80104fcd:	e8 d7 eb ff ff       	call   80103ba9 <myproc>
80104fd2:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(addr >= curproc->sz)
80104fd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fd8:	8b 00                	mov    (%eax),%eax
80104fda:	39 45 08             	cmp    %eax,0x8(%ebp)
80104fdd:	72 07                	jb     80104fe6 <fetchstr+0x23>
    return -1;
80104fdf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fe4:	eb 43                	jmp    80105029 <fetchstr+0x66>
  *pp = (char*)addr;
80104fe6:	8b 55 08             	mov    0x8(%ebp),%edx
80104fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fec:	89 10                	mov    %edx,(%eax)
  ep = (char*)curproc->sz;
80104fee:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ff1:	8b 00                	mov    (%eax),%eax
80104ff3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(s = *pp; s < ep; s++){
80104ff6:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ff9:	8b 00                	mov    (%eax),%eax
80104ffb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104ffe:	eb 1c                	jmp    8010501c <fetchstr+0x59>
    if(*s == 0)
80105000:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105003:	0f b6 00             	movzbl (%eax),%eax
80105006:	84 c0                	test   %al,%al
80105008:	75 0e                	jne    80105018 <fetchstr+0x55>
      return s - *pp;
8010500a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010500d:	8b 00                	mov    (%eax),%eax
8010500f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105012:	29 c2                	sub    %eax,%edx
80105014:	89 d0                	mov    %edx,%eax
80105016:	eb 11                	jmp    80105029 <fetchstr+0x66>
  for(s = *pp; s < ep; s++){
80105018:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010501c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010501f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80105022:	72 dc                	jb     80105000 <fetchstr+0x3d>
  }
  return -1;
80105024:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105029:	c9                   	leave  
8010502a:	c3                   	ret    

8010502b <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
8010502b:	f3 0f 1e fb          	endbr32 
8010502f:	55                   	push   %ebp
80105030:	89 e5                	mov    %esp,%ebp
80105032:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105035:	e8 6f eb ff ff       	call   80103ba9 <myproc>
8010503a:	8b 40 18             	mov    0x18(%eax),%eax
8010503d:	8b 40 44             	mov    0x44(%eax),%eax
80105040:	8b 55 08             	mov    0x8(%ebp),%edx
80105043:	c1 e2 02             	shl    $0x2,%edx
80105046:	01 d0                	add    %edx,%eax
80105048:	83 c0 04             	add    $0x4,%eax
8010504b:	83 ec 08             	sub    $0x8,%esp
8010504e:	ff 75 0c             	pushl  0xc(%ebp)
80105051:	50                   	push   %eax
80105052:	e8 29 ff ff ff       	call   80104f80 <fetchint>
80105057:	83 c4 10             	add    $0x10,%esp
}
8010505a:	c9                   	leave  
8010505b:	c3                   	ret    

8010505c <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
8010505c:	f3 0f 1e fb          	endbr32 
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	83 ec 18             	sub    $0x18,%esp
  int i;
  struct proc *curproc = myproc();
80105066:	e8 3e eb ff ff       	call   80103ba9 <myproc>
8010506b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  if(argint(n, &i) < 0)
8010506e:	83 ec 08             	sub    $0x8,%esp
80105071:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105074:	50                   	push   %eax
80105075:	ff 75 08             	pushl  0x8(%ebp)
80105078:	e8 ae ff ff ff       	call   8010502b <argint>
8010507d:	83 c4 10             	add    $0x10,%esp
80105080:	85 c0                	test   %eax,%eax
80105082:	79 07                	jns    8010508b <argptr+0x2f>
    return -1;
80105084:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105089:	eb 3b                	jmp    801050c6 <argptr+0x6a>
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010508b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010508f:	78 1f                	js     801050b0 <argptr+0x54>
80105091:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105094:	8b 00                	mov    (%eax),%eax
80105096:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105099:	39 d0                	cmp    %edx,%eax
8010509b:	76 13                	jbe    801050b0 <argptr+0x54>
8010509d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050a0:	89 c2                	mov    %eax,%edx
801050a2:	8b 45 10             	mov    0x10(%ebp),%eax
801050a5:	01 c2                	add    %eax,%edx
801050a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050aa:	8b 00                	mov    (%eax),%eax
801050ac:	39 c2                	cmp    %eax,%edx
801050ae:	76 07                	jbe    801050b7 <argptr+0x5b>
    return -1;
801050b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050b5:	eb 0f                	jmp    801050c6 <argptr+0x6a>
  *pp = (char*)i;
801050b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050ba:	89 c2                	mov    %eax,%edx
801050bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801050bf:	89 10                	mov    %edx,(%eax)
  return 0;
801050c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801050c6:	c9                   	leave  
801050c7:	c3                   	ret    

801050c8 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801050c8:	f3 0f 1e fb          	endbr32 
801050cc:	55                   	push   %ebp
801050cd:	89 e5                	mov    %esp,%ebp
801050cf:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
801050d2:	83 ec 08             	sub    $0x8,%esp
801050d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050d8:	50                   	push   %eax
801050d9:	ff 75 08             	pushl  0x8(%ebp)
801050dc:	e8 4a ff ff ff       	call   8010502b <argint>
801050e1:	83 c4 10             	add    $0x10,%esp
801050e4:	85 c0                	test   %eax,%eax
801050e6:	79 07                	jns    801050ef <argstr+0x27>
    return -1;
801050e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050ed:	eb 12                	jmp    80105101 <argstr+0x39>
  return fetchstr(addr, pp);
801050ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050f2:	83 ec 08             	sub    $0x8,%esp
801050f5:	ff 75 0c             	pushl  0xc(%ebp)
801050f8:	50                   	push   %eax
801050f9:	e8 c5 fe ff ff       	call   80104fc3 <fetchstr>
801050fe:	83 c4 10             	add    $0x10,%esp
}
80105101:	c9                   	leave  
80105102:	c3                   	ret    

80105103 <syscall>:
[SYS_printpt] sys_printpt,
};

void
syscall(void)
{
80105103:	f3 0f 1e fb          	endbr32 
80105107:	55                   	push   %ebp
80105108:	89 e5                	mov    %esp,%ebp
8010510a:	83 ec 18             	sub    $0x18,%esp
  int num;
  struct proc *curproc = myproc();
8010510d:	e8 97 ea ff ff       	call   80103ba9 <myproc>
80105112:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
80105115:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105118:	8b 40 18             	mov    0x18(%eax),%eax
8010511b:	8b 40 1c             	mov    0x1c(%eax),%eax
8010511e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105121:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105125:	7e 2f                	jle    80105156 <syscall+0x53>
80105127:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010512a:	83 f8 16             	cmp    $0x16,%eax
8010512d:	77 27                	ja     80105156 <syscall+0x53>
8010512f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105132:	8b 04 85 20 f0 10 80 	mov    -0x7fef0fe0(,%eax,4),%eax
80105139:	85 c0                	test   %eax,%eax
8010513b:	74 19                	je     80105156 <syscall+0x53>
    curproc->tf->eax = syscalls[num]();
8010513d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105140:	8b 04 85 20 f0 10 80 	mov    -0x7fef0fe0(,%eax,4),%eax
80105147:	ff d0                	call   *%eax
80105149:	89 c2                	mov    %eax,%edx
8010514b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010514e:	8b 40 18             	mov    0x18(%eax),%eax
80105151:	89 50 1c             	mov    %edx,0x1c(%eax)
80105154:	eb 2c                	jmp    80105182 <syscall+0x7f>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
80105156:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105159:	8d 50 6c             	lea    0x6c(%eax),%edx
    cprintf("%d %s: unknown sys call %d\n",
8010515c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010515f:	8b 40 10             	mov    0x10(%eax),%eax
80105162:	ff 75 f0             	pushl  -0x10(%ebp)
80105165:	52                   	push   %edx
80105166:	50                   	push   %eax
80105167:	68 b1 aa 10 80       	push   $0x8010aab1
8010516c:	e8 9b b2 ff ff       	call   8010040c <cprintf>
80105171:	83 c4 10             	add    $0x10,%esp
    curproc->tf->eax = -1;
80105174:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105177:	8b 40 18             	mov    0x18(%eax),%eax
8010517a:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105181:	90                   	nop
80105182:	90                   	nop
80105183:	c9                   	leave  
80105184:	c3                   	ret    

80105185 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105185:	f3 0f 1e fb          	endbr32 
80105189:	55                   	push   %ebp
8010518a:	89 e5                	mov    %esp,%ebp
8010518c:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010518f:	83 ec 08             	sub    $0x8,%esp
80105192:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105195:	50                   	push   %eax
80105196:	ff 75 08             	pushl  0x8(%ebp)
80105199:	e8 8d fe ff ff       	call   8010502b <argint>
8010519e:	83 c4 10             	add    $0x10,%esp
801051a1:	85 c0                	test   %eax,%eax
801051a3:	79 07                	jns    801051ac <argfd+0x27>
    return -1;
801051a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051aa:	eb 4f                	jmp    801051fb <argfd+0x76>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801051ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051af:	85 c0                	test   %eax,%eax
801051b1:	78 20                	js     801051d3 <argfd+0x4e>
801051b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051b6:	83 f8 0f             	cmp    $0xf,%eax
801051b9:	7f 18                	jg     801051d3 <argfd+0x4e>
801051bb:	e8 e9 e9 ff ff       	call   80103ba9 <myproc>
801051c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801051c3:	83 c2 08             	add    $0x8,%edx
801051c6:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801051ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
801051cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801051d1:	75 07                	jne    801051da <argfd+0x55>
    return -1;
801051d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051d8:	eb 21                	jmp    801051fb <argfd+0x76>
  if(pfd)
801051da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801051de:	74 08                	je     801051e8 <argfd+0x63>
    *pfd = fd;
801051e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801051e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801051e6:	89 10                	mov    %edx,(%eax)
  if(pf)
801051e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801051ec:	74 08                	je     801051f6 <argfd+0x71>
    *pf = f;
801051ee:	8b 45 10             	mov    0x10(%ebp),%eax
801051f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801051f4:	89 10                	mov    %edx,(%eax)
  return 0;
801051f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801051fb:	c9                   	leave  
801051fc:	c3                   	ret    

801051fd <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801051fd:	f3 0f 1e fb          	endbr32 
80105201:	55                   	push   %ebp
80105202:	89 e5                	mov    %esp,%ebp
80105204:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
80105207:	e8 9d e9 ff ff       	call   80103ba9 <myproc>
8010520c:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
8010520f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105216:	eb 2a                	jmp    80105242 <fdalloc+0x45>
    if(curproc->ofile[fd] == 0){
80105218:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010521b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010521e:	83 c2 08             	add    $0x8,%edx
80105221:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105225:	85 c0                	test   %eax,%eax
80105227:	75 15                	jne    8010523e <fdalloc+0x41>
      curproc->ofile[fd] = f;
80105229:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010522c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010522f:	8d 4a 08             	lea    0x8(%edx),%ecx
80105232:	8b 55 08             	mov    0x8(%ebp),%edx
80105235:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105239:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010523c:	eb 0f                	jmp    8010524d <fdalloc+0x50>
  for(fd = 0; fd < NOFILE; fd++){
8010523e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105242:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105246:	7e d0                	jle    80105218 <fdalloc+0x1b>
    }
  }
  return -1;
80105248:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010524d:	c9                   	leave  
8010524e:	c3                   	ret    

8010524f <sys_dup>:

int
sys_dup(void)
{
8010524f:	f3 0f 1e fb          	endbr32 
80105253:	55                   	push   %ebp
80105254:	89 e5                	mov    %esp,%ebp
80105256:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105259:	83 ec 04             	sub    $0x4,%esp
8010525c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010525f:	50                   	push   %eax
80105260:	6a 00                	push   $0x0
80105262:	6a 00                	push   $0x0
80105264:	e8 1c ff ff ff       	call   80105185 <argfd>
80105269:	83 c4 10             	add    $0x10,%esp
8010526c:	85 c0                	test   %eax,%eax
8010526e:	79 07                	jns    80105277 <sys_dup+0x28>
    return -1;
80105270:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105275:	eb 31                	jmp    801052a8 <sys_dup+0x59>
  if((fd=fdalloc(f)) < 0)
80105277:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010527a:	83 ec 0c             	sub    $0xc,%esp
8010527d:	50                   	push   %eax
8010527e:	e8 7a ff ff ff       	call   801051fd <fdalloc>
80105283:	83 c4 10             	add    $0x10,%esp
80105286:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105289:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010528d:	79 07                	jns    80105296 <sys_dup+0x47>
    return -1;
8010528f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105294:	eb 12                	jmp    801052a8 <sys_dup+0x59>
  filedup(f);
80105296:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105299:	83 ec 0c             	sub    $0xc,%esp
8010529c:	50                   	push   %eax
8010529d:	e8 f2 bd ff ff       	call   80101094 <filedup>
801052a2:	83 c4 10             	add    $0x10,%esp
  return fd;
801052a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801052a8:	c9                   	leave  
801052a9:	c3                   	ret    

801052aa <sys_read>:

int
sys_read(void)
{
801052aa:	f3 0f 1e fb          	endbr32 
801052ae:	55                   	push   %ebp
801052af:	89 e5                	mov    %esp,%ebp
801052b1:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801052b4:	83 ec 04             	sub    $0x4,%esp
801052b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052ba:	50                   	push   %eax
801052bb:	6a 00                	push   $0x0
801052bd:	6a 00                	push   $0x0
801052bf:	e8 c1 fe ff ff       	call   80105185 <argfd>
801052c4:	83 c4 10             	add    $0x10,%esp
801052c7:	85 c0                	test   %eax,%eax
801052c9:	78 2e                	js     801052f9 <sys_read+0x4f>
801052cb:	83 ec 08             	sub    $0x8,%esp
801052ce:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052d1:	50                   	push   %eax
801052d2:	6a 02                	push   $0x2
801052d4:	e8 52 fd ff ff       	call   8010502b <argint>
801052d9:	83 c4 10             	add    $0x10,%esp
801052dc:	85 c0                	test   %eax,%eax
801052de:	78 19                	js     801052f9 <sys_read+0x4f>
801052e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052e3:	83 ec 04             	sub    $0x4,%esp
801052e6:	50                   	push   %eax
801052e7:	8d 45 ec             	lea    -0x14(%ebp),%eax
801052ea:	50                   	push   %eax
801052eb:	6a 01                	push   $0x1
801052ed:	e8 6a fd ff ff       	call   8010505c <argptr>
801052f2:	83 c4 10             	add    $0x10,%esp
801052f5:	85 c0                	test   %eax,%eax
801052f7:	79 07                	jns    80105300 <sys_read+0x56>
    return -1;
801052f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052fe:	eb 17                	jmp    80105317 <sys_read+0x6d>
  return fileread(f, p, n);
80105300:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105303:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105306:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105309:	83 ec 04             	sub    $0x4,%esp
8010530c:	51                   	push   %ecx
8010530d:	52                   	push   %edx
8010530e:	50                   	push   %eax
8010530f:	e8 1c bf ff ff       	call   80101230 <fileread>
80105314:	83 c4 10             	add    $0x10,%esp
}
80105317:	c9                   	leave  
80105318:	c3                   	ret    

80105319 <sys_write>:

int
sys_write(void)
{
80105319:	f3 0f 1e fb          	endbr32 
8010531d:	55                   	push   %ebp
8010531e:	89 e5                	mov    %esp,%ebp
80105320:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105323:	83 ec 04             	sub    $0x4,%esp
80105326:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105329:	50                   	push   %eax
8010532a:	6a 00                	push   $0x0
8010532c:	6a 00                	push   $0x0
8010532e:	e8 52 fe ff ff       	call   80105185 <argfd>
80105333:	83 c4 10             	add    $0x10,%esp
80105336:	85 c0                	test   %eax,%eax
80105338:	78 2e                	js     80105368 <sys_write+0x4f>
8010533a:	83 ec 08             	sub    $0x8,%esp
8010533d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105340:	50                   	push   %eax
80105341:	6a 02                	push   $0x2
80105343:	e8 e3 fc ff ff       	call   8010502b <argint>
80105348:	83 c4 10             	add    $0x10,%esp
8010534b:	85 c0                	test   %eax,%eax
8010534d:	78 19                	js     80105368 <sys_write+0x4f>
8010534f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105352:	83 ec 04             	sub    $0x4,%esp
80105355:	50                   	push   %eax
80105356:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105359:	50                   	push   %eax
8010535a:	6a 01                	push   $0x1
8010535c:	e8 fb fc ff ff       	call   8010505c <argptr>
80105361:	83 c4 10             	add    $0x10,%esp
80105364:	85 c0                	test   %eax,%eax
80105366:	79 07                	jns    8010536f <sys_write+0x56>
    return -1;
80105368:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010536d:	eb 17                	jmp    80105386 <sys_write+0x6d>
  return filewrite(f, p, n);
8010536f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105372:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105375:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105378:	83 ec 04             	sub    $0x4,%esp
8010537b:	51                   	push   %ecx
8010537c:	52                   	push   %edx
8010537d:	50                   	push   %eax
8010537e:	e8 69 bf ff ff       	call   801012ec <filewrite>
80105383:	83 c4 10             	add    $0x10,%esp
}
80105386:	c9                   	leave  
80105387:	c3                   	ret    

80105388 <sys_close>:

int
sys_close(void)
{
80105388:	f3 0f 1e fb          	endbr32 
8010538c:	55                   	push   %ebp
8010538d:	89 e5                	mov    %esp,%ebp
8010538f:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105392:	83 ec 04             	sub    $0x4,%esp
80105395:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105398:	50                   	push   %eax
80105399:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010539c:	50                   	push   %eax
8010539d:	6a 00                	push   $0x0
8010539f:	e8 e1 fd ff ff       	call   80105185 <argfd>
801053a4:	83 c4 10             	add    $0x10,%esp
801053a7:	85 c0                	test   %eax,%eax
801053a9:	79 07                	jns    801053b2 <sys_close+0x2a>
    return -1;
801053ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053b0:	eb 27                	jmp    801053d9 <sys_close+0x51>
  myproc()->ofile[fd] = 0;
801053b2:	e8 f2 e7 ff ff       	call   80103ba9 <myproc>
801053b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801053ba:	83 c2 08             	add    $0x8,%edx
801053bd:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801053c4:	00 
  fileclose(f);
801053c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053c8:	83 ec 0c             	sub    $0xc,%esp
801053cb:	50                   	push   %eax
801053cc:	e8 18 bd ff ff       	call   801010e9 <fileclose>
801053d1:	83 c4 10             	add    $0x10,%esp
  return 0;
801053d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801053d9:	c9                   	leave  
801053da:	c3                   	ret    

801053db <sys_fstat>:

int
sys_fstat(void)
{
801053db:	f3 0f 1e fb          	endbr32 
801053df:	55                   	push   %ebp
801053e0:	89 e5                	mov    %esp,%ebp
801053e2:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801053e5:	83 ec 04             	sub    $0x4,%esp
801053e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053eb:	50                   	push   %eax
801053ec:	6a 00                	push   $0x0
801053ee:	6a 00                	push   $0x0
801053f0:	e8 90 fd ff ff       	call   80105185 <argfd>
801053f5:	83 c4 10             	add    $0x10,%esp
801053f8:	85 c0                	test   %eax,%eax
801053fa:	78 17                	js     80105413 <sys_fstat+0x38>
801053fc:	83 ec 04             	sub    $0x4,%esp
801053ff:	6a 14                	push   $0x14
80105401:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105404:	50                   	push   %eax
80105405:	6a 01                	push   $0x1
80105407:	e8 50 fc ff ff       	call   8010505c <argptr>
8010540c:	83 c4 10             	add    $0x10,%esp
8010540f:	85 c0                	test   %eax,%eax
80105411:	79 07                	jns    8010541a <sys_fstat+0x3f>
    return -1;
80105413:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105418:	eb 13                	jmp    8010542d <sys_fstat+0x52>
  return filestat(f, st);
8010541a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010541d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105420:	83 ec 08             	sub    $0x8,%esp
80105423:	52                   	push   %edx
80105424:	50                   	push   %eax
80105425:	e8 ab bd ff ff       	call   801011d5 <filestat>
8010542a:	83 c4 10             	add    $0x10,%esp
}
8010542d:	c9                   	leave  
8010542e:	c3                   	ret    

8010542f <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
8010542f:	f3 0f 1e fb          	endbr32 
80105433:	55                   	push   %ebp
80105434:	89 e5                	mov    %esp,%ebp
80105436:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105439:	83 ec 08             	sub    $0x8,%esp
8010543c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010543f:	50                   	push   %eax
80105440:	6a 00                	push   $0x0
80105442:	e8 81 fc ff ff       	call   801050c8 <argstr>
80105447:	83 c4 10             	add    $0x10,%esp
8010544a:	85 c0                	test   %eax,%eax
8010544c:	78 15                	js     80105463 <sys_link+0x34>
8010544e:	83 ec 08             	sub    $0x8,%esp
80105451:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105454:	50                   	push   %eax
80105455:	6a 01                	push   $0x1
80105457:	e8 6c fc ff ff       	call   801050c8 <argstr>
8010545c:	83 c4 10             	add    $0x10,%esp
8010545f:	85 c0                	test   %eax,%eax
80105461:	79 0a                	jns    8010546d <sys_link+0x3e>
    return -1;
80105463:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105468:	e9 68 01 00 00       	jmp    801055d5 <sys_link+0x1a6>

  begin_op();
8010546d:	e8 ff dc ff ff       	call   80103171 <begin_op>
  if((ip = namei(old)) == 0){
80105472:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105475:	83 ec 0c             	sub    $0xc,%esp
80105478:	50                   	push   %eax
80105479:	e8 69 d1 ff ff       	call   801025e7 <namei>
8010547e:	83 c4 10             	add    $0x10,%esp
80105481:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105484:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105488:	75 0f                	jne    80105499 <sys_link+0x6a>
    end_op();
8010548a:	e8 72 dd ff ff       	call   80103201 <end_op>
    return -1;
8010548f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105494:	e9 3c 01 00 00       	jmp    801055d5 <sys_link+0x1a6>
  }

  ilock(ip);
80105499:	83 ec 0c             	sub    $0xc,%esp
8010549c:	ff 75 f4             	pushl  -0xc(%ebp)
8010549f:	e8 d8 c5 ff ff       	call   80101a7c <ilock>
801054a4:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
801054a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054aa:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801054ae:	66 83 f8 01          	cmp    $0x1,%ax
801054b2:	75 1d                	jne    801054d1 <sys_link+0xa2>
    iunlockput(ip);
801054b4:	83 ec 0c             	sub    $0xc,%esp
801054b7:	ff 75 f4             	pushl  -0xc(%ebp)
801054ba:	e8 fa c7 ff ff       	call   80101cb9 <iunlockput>
801054bf:	83 c4 10             	add    $0x10,%esp
    end_op();
801054c2:	e8 3a dd ff ff       	call   80103201 <end_op>
    return -1;
801054c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054cc:	e9 04 01 00 00       	jmp    801055d5 <sys_link+0x1a6>
  }

  ip->nlink++;
801054d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054d4:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801054d8:	83 c0 01             	add    $0x1,%eax
801054db:	89 c2                	mov    %eax,%edx
801054dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054e0:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
801054e4:	83 ec 0c             	sub    $0xc,%esp
801054e7:	ff 75 f4             	pushl  -0xc(%ebp)
801054ea:	e8 a4 c3 ff ff       	call   80101893 <iupdate>
801054ef:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
801054f2:	83 ec 0c             	sub    $0xc,%esp
801054f5:	ff 75 f4             	pushl  -0xc(%ebp)
801054f8:	e8 96 c6 ff ff       	call   80101b93 <iunlock>
801054fd:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105500:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105503:	83 ec 08             	sub    $0x8,%esp
80105506:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105509:	52                   	push   %edx
8010550a:	50                   	push   %eax
8010550b:	e8 f7 d0 ff ff       	call   80102607 <nameiparent>
80105510:	83 c4 10             	add    $0x10,%esp
80105513:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105516:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010551a:	74 71                	je     8010558d <sys_link+0x15e>
    goto bad;
  ilock(dp);
8010551c:	83 ec 0c             	sub    $0xc,%esp
8010551f:	ff 75 f0             	pushl  -0x10(%ebp)
80105522:	e8 55 c5 ff ff       	call   80101a7c <ilock>
80105527:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
8010552a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010552d:	8b 10                	mov    (%eax),%edx
8010552f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105532:	8b 00                	mov    (%eax),%eax
80105534:	39 c2                	cmp    %eax,%edx
80105536:	75 1d                	jne    80105555 <sys_link+0x126>
80105538:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010553b:	8b 40 04             	mov    0x4(%eax),%eax
8010553e:	83 ec 04             	sub    $0x4,%esp
80105541:	50                   	push   %eax
80105542:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105545:	50                   	push   %eax
80105546:	ff 75 f0             	pushl  -0x10(%ebp)
80105549:	e8 f6 cd ff ff       	call   80102344 <dirlink>
8010554e:	83 c4 10             	add    $0x10,%esp
80105551:	85 c0                	test   %eax,%eax
80105553:	79 10                	jns    80105565 <sys_link+0x136>
    iunlockput(dp);
80105555:	83 ec 0c             	sub    $0xc,%esp
80105558:	ff 75 f0             	pushl  -0x10(%ebp)
8010555b:	e8 59 c7 ff ff       	call   80101cb9 <iunlockput>
80105560:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105563:	eb 29                	jmp    8010558e <sys_link+0x15f>
  }
  iunlockput(dp);
80105565:	83 ec 0c             	sub    $0xc,%esp
80105568:	ff 75 f0             	pushl  -0x10(%ebp)
8010556b:	e8 49 c7 ff ff       	call   80101cb9 <iunlockput>
80105570:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105573:	83 ec 0c             	sub    $0xc,%esp
80105576:	ff 75 f4             	pushl  -0xc(%ebp)
80105579:	e8 67 c6 ff ff       	call   80101be5 <iput>
8010557e:	83 c4 10             	add    $0x10,%esp

  end_op();
80105581:	e8 7b dc ff ff       	call   80103201 <end_op>

  return 0;
80105586:	b8 00 00 00 00       	mov    $0x0,%eax
8010558b:	eb 48                	jmp    801055d5 <sys_link+0x1a6>
    goto bad;
8010558d:	90                   	nop

bad:
  ilock(ip);
8010558e:	83 ec 0c             	sub    $0xc,%esp
80105591:	ff 75 f4             	pushl  -0xc(%ebp)
80105594:	e8 e3 c4 ff ff       	call   80101a7c <ilock>
80105599:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
8010559c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010559f:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801055a3:	83 e8 01             	sub    $0x1,%eax
801055a6:	89 c2                	mov    %eax,%edx
801055a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055ab:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
801055af:	83 ec 0c             	sub    $0xc,%esp
801055b2:	ff 75 f4             	pushl  -0xc(%ebp)
801055b5:	e8 d9 c2 ff ff       	call   80101893 <iupdate>
801055ba:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
801055bd:	83 ec 0c             	sub    $0xc,%esp
801055c0:	ff 75 f4             	pushl  -0xc(%ebp)
801055c3:	e8 f1 c6 ff ff       	call   80101cb9 <iunlockput>
801055c8:	83 c4 10             	add    $0x10,%esp
  end_op();
801055cb:	e8 31 dc ff ff       	call   80103201 <end_op>
  return -1;
801055d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055d5:	c9                   	leave  
801055d6:	c3                   	ret    

801055d7 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801055d7:	f3 0f 1e fb          	endbr32 
801055db:	55                   	push   %ebp
801055dc:	89 e5                	mov    %esp,%ebp
801055de:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801055e1:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
801055e8:	eb 40                	jmp    8010562a <isdirempty+0x53>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801055ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055ed:	6a 10                	push   $0x10
801055ef:	50                   	push   %eax
801055f0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801055f3:	50                   	push   %eax
801055f4:	ff 75 08             	pushl  0x8(%ebp)
801055f7:	e8 88 c9 ff ff       	call   80101f84 <readi>
801055fc:	83 c4 10             	add    $0x10,%esp
801055ff:	83 f8 10             	cmp    $0x10,%eax
80105602:	74 0d                	je     80105611 <isdirempty+0x3a>
      panic("isdirempty: readi");
80105604:	83 ec 0c             	sub    $0xc,%esp
80105607:	68 cd aa 10 80       	push   $0x8010aacd
8010560c:	e8 b4 af ff ff       	call   801005c5 <panic>
    if(de.inum != 0)
80105611:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105615:	66 85 c0             	test   %ax,%ax
80105618:	74 07                	je     80105621 <isdirempty+0x4a>
      return 0;
8010561a:	b8 00 00 00 00       	mov    $0x0,%eax
8010561f:	eb 1b                	jmp    8010563c <isdirempty+0x65>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105621:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105624:	83 c0 10             	add    $0x10,%eax
80105627:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010562a:	8b 45 08             	mov    0x8(%ebp),%eax
8010562d:	8b 50 58             	mov    0x58(%eax),%edx
80105630:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105633:	39 c2                	cmp    %eax,%edx
80105635:	77 b3                	ja     801055ea <isdirempty+0x13>
  }
  return 1;
80105637:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010563c:	c9                   	leave  
8010563d:	c3                   	ret    

8010563e <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
8010563e:	f3 0f 1e fb          	endbr32 
80105642:	55                   	push   %ebp
80105643:	89 e5                	mov    %esp,%ebp
80105645:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105648:	83 ec 08             	sub    $0x8,%esp
8010564b:	8d 45 cc             	lea    -0x34(%ebp),%eax
8010564e:	50                   	push   %eax
8010564f:	6a 00                	push   $0x0
80105651:	e8 72 fa ff ff       	call   801050c8 <argstr>
80105656:	83 c4 10             	add    $0x10,%esp
80105659:	85 c0                	test   %eax,%eax
8010565b:	79 0a                	jns    80105667 <sys_unlink+0x29>
    return -1;
8010565d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105662:	e9 bf 01 00 00       	jmp    80105826 <sys_unlink+0x1e8>

  begin_op();
80105667:	e8 05 db ff ff       	call   80103171 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
8010566c:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010566f:	83 ec 08             	sub    $0x8,%esp
80105672:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105675:	52                   	push   %edx
80105676:	50                   	push   %eax
80105677:	e8 8b cf ff ff       	call   80102607 <nameiparent>
8010567c:	83 c4 10             	add    $0x10,%esp
8010567f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105682:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105686:	75 0f                	jne    80105697 <sys_unlink+0x59>
    end_op();
80105688:	e8 74 db ff ff       	call   80103201 <end_op>
    return -1;
8010568d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105692:	e9 8f 01 00 00       	jmp    80105826 <sys_unlink+0x1e8>
  }

  ilock(dp);
80105697:	83 ec 0c             	sub    $0xc,%esp
8010569a:	ff 75 f4             	pushl  -0xc(%ebp)
8010569d:	e8 da c3 ff ff       	call   80101a7c <ilock>
801056a2:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801056a5:	83 ec 08             	sub    $0x8,%esp
801056a8:	68 df aa 10 80       	push   $0x8010aadf
801056ad:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801056b0:	50                   	push   %eax
801056b1:	e8 b1 cb ff ff       	call   80102267 <namecmp>
801056b6:	83 c4 10             	add    $0x10,%esp
801056b9:	85 c0                	test   %eax,%eax
801056bb:	0f 84 49 01 00 00    	je     8010580a <sys_unlink+0x1cc>
801056c1:	83 ec 08             	sub    $0x8,%esp
801056c4:	68 e1 aa 10 80       	push   $0x8010aae1
801056c9:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801056cc:	50                   	push   %eax
801056cd:	e8 95 cb ff ff       	call   80102267 <namecmp>
801056d2:	83 c4 10             	add    $0x10,%esp
801056d5:	85 c0                	test   %eax,%eax
801056d7:	0f 84 2d 01 00 00    	je     8010580a <sys_unlink+0x1cc>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801056dd:	83 ec 04             	sub    $0x4,%esp
801056e0:	8d 45 c8             	lea    -0x38(%ebp),%eax
801056e3:	50                   	push   %eax
801056e4:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801056e7:	50                   	push   %eax
801056e8:	ff 75 f4             	pushl  -0xc(%ebp)
801056eb:	e8 96 cb ff ff       	call   80102286 <dirlookup>
801056f0:	83 c4 10             	add    $0x10,%esp
801056f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
801056f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801056fa:	0f 84 0d 01 00 00    	je     8010580d <sys_unlink+0x1cf>
    goto bad;
  ilock(ip);
80105700:	83 ec 0c             	sub    $0xc,%esp
80105703:	ff 75 f0             	pushl  -0x10(%ebp)
80105706:	e8 71 c3 ff ff       	call   80101a7c <ilock>
8010570b:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
8010570e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105711:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105715:	66 85 c0             	test   %ax,%ax
80105718:	7f 0d                	jg     80105727 <sys_unlink+0xe9>
    panic("unlink: nlink < 1");
8010571a:	83 ec 0c             	sub    $0xc,%esp
8010571d:	68 e4 aa 10 80       	push   $0x8010aae4
80105722:	e8 9e ae ff ff       	call   801005c5 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105727:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010572a:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010572e:	66 83 f8 01          	cmp    $0x1,%ax
80105732:	75 25                	jne    80105759 <sys_unlink+0x11b>
80105734:	83 ec 0c             	sub    $0xc,%esp
80105737:	ff 75 f0             	pushl  -0x10(%ebp)
8010573a:	e8 98 fe ff ff       	call   801055d7 <isdirempty>
8010573f:	83 c4 10             	add    $0x10,%esp
80105742:	85 c0                	test   %eax,%eax
80105744:	75 13                	jne    80105759 <sys_unlink+0x11b>
    iunlockput(ip);
80105746:	83 ec 0c             	sub    $0xc,%esp
80105749:	ff 75 f0             	pushl  -0x10(%ebp)
8010574c:	e8 68 c5 ff ff       	call   80101cb9 <iunlockput>
80105751:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105754:	e9 b5 00 00 00       	jmp    8010580e <sys_unlink+0x1d0>
  }

  memset(&de, 0, sizeof(de));
80105759:	83 ec 04             	sub    $0x4,%esp
8010575c:	6a 10                	push   $0x10
8010575e:	6a 00                	push   $0x0
80105760:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105763:	50                   	push   %eax
80105764:	e8 6e f5 ff ff       	call   80104cd7 <memset>
80105769:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010576c:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010576f:	6a 10                	push   $0x10
80105771:	50                   	push   %eax
80105772:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105775:	50                   	push   %eax
80105776:	ff 75 f4             	pushl  -0xc(%ebp)
80105779:	e8 5f c9 ff ff       	call   801020dd <writei>
8010577e:	83 c4 10             	add    $0x10,%esp
80105781:	83 f8 10             	cmp    $0x10,%eax
80105784:	74 0d                	je     80105793 <sys_unlink+0x155>
    panic("unlink: writei");
80105786:	83 ec 0c             	sub    $0xc,%esp
80105789:	68 f6 aa 10 80       	push   $0x8010aaf6
8010578e:	e8 32 ae ff ff       	call   801005c5 <panic>
  if(ip->type == T_DIR){
80105793:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105796:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010579a:	66 83 f8 01          	cmp    $0x1,%ax
8010579e:	75 21                	jne    801057c1 <sys_unlink+0x183>
    dp->nlink--;
801057a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057a3:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801057a7:	83 e8 01             	sub    $0x1,%eax
801057aa:	89 c2                	mov    %eax,%edx
801057ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057af:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
801057b3:	83 ec 0c             	sub    $0xc,%esp
801057b6:	ff 75 f4             	pushl  -0xc(%ebp)
801057b9:	e8 d5 c0 ff ff       	call   80101893 <iupdate>
801057be:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
801057c1:	83 ec 0c             	sub    $0xc,%esp
801057c4:	ff 75 f4             	pushl  -0xc(%ebp)
801057c7:	e8 ed c4 ff ff       	call   80101cb9 <iunlockput>
801057cc:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
801057cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057d2:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801057d6:	83 e8 01             	sub    $0x1,%eax
801057d9:	89 c2                	mov    %eax,%edx
801057db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057de:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
801057e2:	83 ec 0c             	sub    $0xc,%esp
801057e5:	ff 75 f0             	pushl  -0x10(%ebp)
801057e8:	e8 a6 c0 ff ff       	call   80101893 <iupdate>
801057ed:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
801057f0:	83 ec 0c             	sub    $0xc,%esp
801057f3:	ff 75 f0             	pushl  -0x10(%ebp)
801057f6:	e8 be c4 ff ff       	call   80101cb9 <iunlockput>
801057fb:	83 c4 10             	add    $0x10,%esp

  end_op();
801057fe:	e8 fe d9 ff ff       	call   80103201 <end_op>

  return 0;
80105803:	b8 00 00 00 00       	mov    $0x0,%eax
80105808:	eb 1c                	jmp    80105826 <sys_unlink+0x1e8>
    goto bad;
8010580a:	90                   	nop
8010580b:	eb 01                	jmp    8010580e <sys_unlink+0x1d0>
    goto bad;
8010580d:	90                   	nop

bad:
  iunlockput(dp);
8010580e:	83 ec 0c             	sub    $0xc,%esp
80105811:	ff 75 f4             	pushl  -0xc(%ebp)
80105814:	e8 a0 c4 ff ff       	call   80101cb9 <iunlockput>
80105819:	83 c4 10             	add    $0x10,%esp
  end_op();
8010581c:	e8 e0 d9 ff ff       	call   80103201 <end_op>
  return -1;
80105821:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105826:	c9                   	leave  
80105827:	c3                   	ret    

80105828 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105828:	f3 0f 1e fb          	endbr32 
8010582c:	55                   	push   %ebp
8010582d:	89 e5                	mov    %esp,%ebp
8010582f:	83 ec 38             	sub    $0x38,%esp
80105832:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105835:	8b 55 10             	mov    0x10(%ebp),%edx
80105838:	8b 45 14             	mov    0x14(%ebp),%eax
8010583b:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
8010583f:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105843:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105847:	83 ec 08             	sub    $0x8,%esp
8010584a:	8d 45 de             	lea    -0x22(%ebp),%eax
8010584d:	50                   	push   %eax
8010584e:	ff 75 08             	pushl  0x8(%ebp)
80105851:	e8 b1 cd ff ff       	call   80102607 <nameiparent>
80105856:	83 c4 10             	add    $0x10,%esp
80105859:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010585c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105860:	75 0a                	jne    8010586c <create+0x44>
    return 0;
80105862:	b8 00 00 00 00       	mov    $0x0,%eax
80105867:	e9 90 01 00 00       	jmp    801059fc <create+0x1d4>
  ilock(dp);
8010586c:	83 ec 0c             	sub    $0xc,%esp
8010586f:	ff 75 f4             	pushl  -0xc(%ebp)
80105872:	e8 05 c2 ff ff       	call   80101a7c <ilock>
80105877:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
8010587a:	83 ec 04             	sub    $0x4,%esp
8010587d:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105880:	50                   	push   %eax
80105881:	8d 45 de             	lea    -0x22(%ebp),%eax
80105884:	50                   	push   %eax
80105885:	ff 75 f4             	pushl  -0xc(%ebp)
80105888:	e8 f9 c9 ff ff       	call   80102286 <dirlookup>
8010588d:	83 c4 10             	add    $0x10,%esp
80105890:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105893:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105897:	74 50                	je     801058e9 <create+0xc1>
    iunlockput(dp);
80105899:	83 ec 0c             	sub    $0xc,%esp
8010589c:	ff 75 f4             	pushl  -0xc(%ebp)
8010589f:	e8 15 c4 ff ff       	call   80101cb9 <iunlockput>
801058a4:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
801058a7:	83 ec 0c             	sub    $0xc,%esp
801058aa:	ff 75 f0             	pushl  -0x10(%ebp)
801058ad:	e8 ca c1 ff ff       	call   80101a7c <ilock>
801058b2:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
801058b5:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801058ba:	75 15                	jne    801058d1 <create+0xa9>
801058bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058bf:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801058c3:	66 83 f8 02          	cmp    $0x2,%ax
801058c7:	75 08                	jne    801058d1 <create+0xa9>
      return ip;
801058c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058cc:	e9 2b 01 00 00       	jmp    801059fc <create+0x1d4>
    iunlockput(ip);
801058d1:	83 ec 0c             	sub    $0xc,%esp
801058d4:	ff 75 f0             	pushl  -0x10(%ebp)
801058d7:	e8 dd c3 ff ff       	call   80101cb9 <iunlockput>
801058dc:	83 c4 10             	add    $0x10,%esp
    return 0;
801058df:	b8 00 00 00 00       	mov    $0x0,%eax
801058e4:	e9 13 01 00 00       	jmp    801059fc <create+0x1d4>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801058e9:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
801058ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058f0:	8b 00                	mov    (%eax),%eax
801058f2:	83 ec 08             	sub    $0x8,%esp
801058f5:	52                   	push   %edx
801058f6:	50                   	push   %eax
801058f7:	e8 bc be ff ff       	call   801017b8 <ialloc>
801058fc:	83 c4 10             	add    $0x10,%esp
801058ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105902:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105906:	75 0d                	jne    80105915 <create+0xed>
    panic("create: ialloc");
80105908:	83 ec 0c             	sub    $0xc,%esp
8010590b:	68 05 ab 10 80       	push   $0x8010ab05
80105910:	e8 b0 ac ff ff       	call   801005c5 <panic>

  ilock(ip);
80105915:	83 ec 0c             	sub    $0xc,%esp
80105918:	ff 75 f0             	pushl  -0x10(%ebp)
8010591b:	e8 5c c1 ff ff       	call   80101a7c <ilock>
80105920:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80105923:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105926:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
8010592a:	66 89 50 52          	mov    %dx,0x52(%eax)
  ip->minor = minor;
8010592e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105931:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105935:	66 89 50 54          	mov    %dx,0x54(%eax)
  ip->nlink = 1;
80105939:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010593c:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
80105942:	83 ec 0c             	sub    $0xc,%esp
80105945:	ff 75 f0             	pushl  -0x10(%ebp)
80105948:	e8 46 bf ff ff       	call   80101893 <iupdate>
8010594d:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80105950:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105955:	75 6a                	jne    801059c1 <create+0x199>
    dp->nlink++;  // for ".."
80105957:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010595a:	0f b7 40 56          	movzwl 0x56(%eax),%eax
8010595e:	83 c0 01             	add    $0x1,%eax
80105961:	89 c2                	mov    %eax,%edx
80105963:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105966:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
8010596a:	83 ec 0c             	sub    $0xc,%esp
8010596d:	ff 75 f4             	pushl  -0xc(%ebp)
80105970:	e8 1e bf ff ff       	call   80101893 <iupdate>
80105975:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105978:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010597b:	8b 40 04             	mov    0x4(%eax),%eax
8010597e:	83 ec 04             	sub    $0x4,%esp
80105981:	50                   	push   %eax
80105982:	68 df aa 10 80       	push   $0x8010aadf
80105987:	ff 75 f0             	pushl  -0x10(%ebp)
8010598a:	e8 b5 c9 ff ff       	call   80102344 <dirlink>
8010598f:	83 c4 10             	add    $0x10,%esp
80105992:	85 c0                	test   %eax,%eax
80105994:	78 1e                	js     801059b4 <create+0x18c>
80105996:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105999:	8b 40 04             	mov    0x4(%eax),%eax
8010599c:	83 ec 04             	sub    $0x4,%esp
8010599f:	50                   	push   %eax
801059a0:	68 e1 aa 10 80       	push   $0x8010aae1
801059a5:	ff 75 f0             	pushl  -0x10(%ebp)
801059a8:	e8 97 c9 ff ff       	call   80102344 <dirlink>
801059ad:	83 c4 10             	add    $0x10,%esp
801059b0:	85 c0                	test   %eax,%eax
801059b2:	79 0d                	jns    801059c1 <create+0x199>
      panic("create dots");
801059b4:	83 ec 0c             	sub    $0xc,%esp
801059b7:	68 14 ab 10 80       	push   $0x8010ab14
801059bc:	e8 04 ac ff ff       	call   801005c5 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
801059c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059c4:	8b 40 04             	mov    0x4(%eax),%eax
801059c7:	83 ec 04             	sub    $0x4,%esp
801059ca:	50                   	push   %eax
801059cb:	8d 45 de             	lea    -0x22(%ebp),%eax
801059ce:	50                   	push   %eax
801059cf:	ff 75 f4             	pushl  -0xc(%ebp)
801059d2:	e8 6d c9 ff ff       	call   80102344 <dirlink>
801059d7:	83 c4 10             	add    $0x10,%esp
801059da:	85 c0                	test   %eax,%eax
801059dc:	79 0d                	jns    801059eb <create+0x1c3>
    panic("create: dirlink");
801059de:	83 ec 0c             	sub    $0xc,%esp
801059e1:	68 20 ab 10 80       	push   $0x8010ab20
801059e6:	e8 da ab ff ff       	call   801005c5 <panic>

  iunlockput(dp);
801059eb:	83 ec 0c             	sub    $0xc,%esp
801059ee:	ff 75 f4             	pushl  -0xc(%ebp)
801059f1:	e8 c3 c2 ff ff       	call   80101cb9 <iunlockput>
801059f6:	83 c4 10             	add    $0x10,%esp

  return ip;
801059f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801059fc:	c9                   	leave  
801059fd:	c3                   	ret    

801059fe <sys_open>:

int
sys_open(void)
{
801059fe:	f3 0f 1e fb          	endbr32 
80105a02:	55                   	push   %ebp
80105a03:	89 e5                	mov    %esp,%ebp
80105a05:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a08:	83 ec 08             	sub    $0x8,%esp
80105a0b:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105a0e:	50                   	push   %eax
80105a0f:	6a 00                	push   $0x0
80105a11:	e8 b2 f6 ff ff       	call   801050c8 <argstr>
80105a16:	83 c4 10             	add    $0x10,%esp
80105a19:	85 c0                	test   %eax,%eax
80105a1b:	78 15                	js     80105a32 <sys_open+0x34>
80105a1d:	83 ec 08             	sub    $0x8,%esp
80105a20:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a23:	50                   	push   %eax
80105a24:	6a 01                	push   $0x1
80105a26:	e8 00 f6 ff ff       	call   8010502b <argint>
80105a2b:	83 c4 10             	add    $0x10,%esp
80105a2e:	85 c0                	test   %eax,%eax
80105a30:	79 0a                	jns    80105a3c <sys_open+0x3e>
    return -1;
80105a32:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a37:	e9 61 01 00 00       	jmp    80105b9d <sys_open+0x19f>

  begin_op();
80105a3c:	e8 30 d7 ff ff       	call   80103171 <begin_op>

  if(omode & O_CREATE){
80105a41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105a44:	25 00 02 00 00       	and    $0x200,%eax
80105a49:	85 c0                	test   %eax,%eax
80105a4b:	74 2a                	je     80105a77 <sys_open+0x79>
    ip = create(path, T_FILE, 0, 0);
80105a4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105a50:	6a 00                	push   $0x0
80105a52:	6a 00                	push   $0x0
80105a54:	6a 02                	push   $0x2
80105a56:	50                   	push   %eax
80105a57:	e8 cc fd ff ff       	call   80105828 <create>
80105a5c:	83 c4 10             	add    $0x10,%esp
80105a5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80105a62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a66:	75 75                	jne    80105add <sys_open+0xdf>
      end_op();
80105a68:	e8 94 d7 ff ff       	call   80103201 <end_op>
      return -1;
80105a6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a72:	e9 26 01 00 00       	jmp    80105b9d <sys_open+0x19f>
    }
  } else {
    if((ip = namei(path)) == 0){
80105a77:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105a7a:	83 ec 0c             	sub    $0xc,%esp
80105a7d:	50                   	push   %eax
80105a7e:	e8 64 cb ff ff       	call   801025e7 <namei>
80105a83:	83 c4 10             	add    $0x10,%esp
80105a86:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a8d:	75 0f                	jne    80105a9e <sys_open+0xa0>
      end_op();
80105a8f:	e8 6d d7 ff ff       	call   80103201 <end_op>
      return -1;
80105a94:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a99:	e9 ff 00 00 00       	jmp    80105b9d <sys_open+0x19f>
    }
    ilock(ip);
80105a9e:	83 ec 0c             	sub    $0xc,%esp
80105aa1:	ff 75 f4             	pushl  -0xc(%ebp)
80105aa4:	e8 d3 bf ff ff       	call   80101a7c <ilock>
80105aa9:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80105aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aaf:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105ab3:	66 83 f8 01          	cmp    $0x1,%ax
80105ab7:	75 24                	jne    80105add <sys_open+0xdf>
80105ab9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105abc:	85 c0                	test   %eax,%eax
80105abe:	74 1d                	je     80105add <sys_open+0xdf>
      iunlockput(ip);
80105ac0:	83 ec 0c             	sub    $0xc,%esp
80105ac3:	ff 75 f4             	pushl  -0xc(%ebp)
80105ac6:	e8 ee c1 ff ff       	call   80101cb9 <iunlockput>
80105acb:	83 c4 10             	add    $0x10,%esp
      end_op();
80105ace:	e8 2e d7 ff ff       	call   80103201 <end_op>
      return -1;
80105ad3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ad8:	e9 c0 00 00 00       	jmp    80105b9d <sys_open+0x19f>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105add:	e8 41 b5 ff ff       	call   80101023 <filealloc>
80105ae2:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105ae5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105ae9:	74 17                	je     80105b02 <sys_open+0x104>
80105aeb:	83 ec 0c             	sub    $0xc,%esp
80105aee:	ff 75 f0             	pushl  -0x10(%ebp)
80105af1:	e8 07 f7 ff ff       	call   801051fd <fdalloc>
80105af6:	83 c4 10             	add    $0x10,%esp
80105af9:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105afc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105b00:	79 2e                	jns    80105b30 <sys_open+0x132>
    if(f)
80105b02:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105b06:	74 0e                	je     80105b16 <sys_open+0x118>
      fileclose(f);
80105b08:	83 ec 0c             	sub    $0xc,%esp
80105b0b:	ff 75 f0             	pushl  -0x10(%ebp)
80105b0e:	e8 d6 b5 ff ff       	call   801010e9 <fileclose>
80105b13:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105b16:	83 ec 0c             	sub    $0xc,%esp
80105b19:	ff 75 f4             	pushl  -0xc(%ebp)
80105b1c:	e8 98 c1 ff ff       	call   80101cb9 <iunlockput>
80105b21:	83 c4 10             	add    $0x10,%esp
    end_op();
80105b24:	e8 d8 d6 ff ff       	call   80103201 <end_op>
    return -1;
80105b29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b2e:	eb 6d                	jmp    80105b9d <sys_open+0x19f>
  }
  iunlock(ip);
80105b30:	83 ec 0c             	sub    $0xc,%esp
80105b33:	ff 75 f4             	pushl  -0xc(%ebp)
80105b36:	e8 58 c0 ff ff       	call   80101b93 <iunlock>
80105b3b:	83 c4 10             	add    $0x10,%esp
  end_op();
80105b3e:	e8 be d6 ff ff       	call   80103201 <end_op>

  f->type = FD_INODE;
80105b43:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b46:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105b4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b52:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105b55:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b58:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105b5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105b62:	83 e0 01             	and    $0x1,%eax
80105b65:	85 c0                	test   %eax,%eax
80105b67:	0f 94 c0             	sete   %al
80105b6a:	89 c2                	mov    %eax,%edx
80105b6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b6f:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105b75:	83 e0 01             	and    $0x1,%eax
80105b78:	85 c0                	test   %eax,%eax
80105b7a:	75 0a                	jne    80105b86 <sys_open+0x188>
80105b7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105b7f:	83 e0 02             	and    $0x2,%eax
80105b82:	85 c0                	test   %eax,%eax
80105b84:	74 07                	je     80105b8d <sys_open+0x18f>
80105b86:	b8 01 00 00 00       	mov    $0x1,%eax
80105b8b:	eb 05                	jmp    80105b92 <sys_open+0x194>
80105b8d:	b8 00 00 00 00       	mov    $0x0,%eax
80105b92:	89 c2                	mov    %eax,%edx
80105b94:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b97:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80105b9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80105b9d:	c9                   	leave  
80105b9e:	c3                   	ret    

80105b9f <sys_mkdir>:

int
sys_mkdir(void)
{
80105b9f:	f3 0f 1e fb          	endbr32 
80105ba3:	55                   	push   %ebp
80105ba4:	89 e5                	mov    %esp,%ebp
80105ba6:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105ba9:	e8 c3 d5 ff ff       	call   80103171 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105bae:	83 ec 08             	sub    $0x8,%esp
80105bb1:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bb4:	50                   	push   %eax
80105bb5:	6a 00                	push   $0x0
80105bb7:	e8 0c f5 ff ff       	call   801050c8 <argstr>
80105bbc:	83 c4 10             	add    $0x10,%esp
80105bbf:	85 c0                	test   %eax,%eax
80105bc1:	78 1b                	js     80105bde <sys_mkdir+0x3f>
80105bc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bc6:	6a 00                	push   $0x0
80105bc8:	6a 00                	push   $0x0
80105bca:	6a 01                	push   $0x1
80105bcc:	50                   	push   %eax
80105bcd:	e8 56 fc ff ff       	call   80105828 <create>
80105bd2:	83 c4 10             	add    $0x10,%esp
80105bd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105bd8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105bdc:	75 0c                	jne    80105bea <sys_mkdir+0x4b>
    end_op();
80105bde:	e8 1e d6 ff ff       	call   80103201 <end_op>
    return -1;
80105be3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105be8:	eb 18                	jmp    80105c02 <sys_mkdir+0x63>
  }
  iunlockput(ip);
80105bea:	83 ec 0c             	sub    $0xc,%esp
80105bed:	ff 75 f4             	pushl  -0xc(%ebp)
80105bf0:	e8 c4 c0 ff ff       	call   80101cb9 <iunlockput>
80105bf5:	83 c4 10             	add    $0x10,%esp
  end_op();
80105bf8:	e8 04 d6 ff ff       	call   80103201 <end_op>
  return 0;
80105bfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105c02:	c9                   	leave  
80105c03:	c3                   	ret    

80105c04 <sys_mknod>:

int
sys_mknod(void)
{
80105c04:	f3 0f 1e fb          	endbr32 
80105c08:	55                   	push   %ebp
80105c09:	89 e5                	mov    %esp,%ebp
80105c0b:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105c0e:	e8 5e d5 ff ff       	call   80103171 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105c13:	83 ec 08             	sub    $0x8,%esp
80105c16:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c19:	50                   	push   %eax
80105c1a:	6a 00                	push   $0x0
80105c1c:	e8 a7 f4 ff ff       	call   801050c8 <argstr>
80105c21:	83 c4 10             	add    $0x10,%esp
80105c24:	85 c0                	test   %eax,%eax
80105c26:	78 4f                	js     80105c77 <sys_mknod+0x73>
     argint(1, &major) < 0 ||
80105c28:	83 ec 08             	sub    $0x8,%esp
80105c2b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c2e:	50                   	push   %eax
80105c2f:	6a 01                	push   $0x1
80105c31:	e8 f5 f3 ff ff       	call   8010502b <argint>
80105c36:	83 c4 10             	add    $0x10,%esp
  if((argstr(0, &path)) < 0 ||
80105c39:	85 c0                	test   %eax,%eax
80105c3b:	78 3a                	js     80105c77 <sys_mknod+0x73>
     argint(2, &minor) < 0 ||
80105c3d:	83 ec 08             	sub    $0x8,%esp
80105c40:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105c43:	50                   	push   %eax
80105c44:	6a 02                	push   $0x2
80105c46:	e8 e0 f3 ff ff       	call   8010502b <argint>
80105c4b:	83 c4 10             	add    $0x10,%esp
     argint(1, &major) < 0 ||
80105c4e:	85 c0                	test   %eax,%eax
80105c50:	78 25                	js     80105c77 <sys_mknod+0x73>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105c52:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105c55:	0f bf c8             	movswl %ax,%ecx
80105c58:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105c5b:	0f bf d0             	movswl %ax,%edx
80105c5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c61:	51                   	push   %ecx
80105c62:	52                   	push   %edx
80105c63:	6a 03                	push   $0x3
80105c65:	50                   	push   %eax
80105c66:	e8 bd fb ff ff       	call   80105828 <create>
80105c6b:	83 c4 10             	add    $0x10,%esp
80105c6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
     argint(2, &minor) < 0 ||
80105c71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c75:	75 0c                	jne    80105c83 <sys_mknod+0x7f>
    end_op();
80105c77:	e8 85 d5 ff ff       	call   80103201 <end_op>
    return -1;
80105c7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c81:	eb 18                	jmp    80105c9b <sys_mknod+0x97>
  }
  iunlockput(ip);
80105c83:	83 ec 0c             	sub    $0xc,%esp
80105c86:	ff 75 f4             	pushl  -0xc(%ebp)
80105c89:	e8 2b c0 ff ff       	call   80101cb9 <iunlockput>
80105c8e:	83 c4 10             	add    $0x10,%esp
  end_op();
80105c91:	e8 6b d5 ff ff       	call   80103201 <end_op>
  return 0;
80105c96:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105c9b:	c9                   	leave  
80105c9c:	c3                   	ret    

80105c9d <sys_chdir>:

int
sys_chdir(void)
{
80105c9d:	f3 0f 1e fb          	endbr32 
80105ca1:	55                   	push   %ebp
80105ca2:	89 e5                	mov    %esp,%ebp
80105ca4:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105ca7:	e8 fd de ff ff       	call   80103ba9 <myproc>
80105cac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
80105caf:	e8 bd d4 ff ff       	call   80103171 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105cb4:	83 ec 08             	sub    $0x8,%esp
80105cb7:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105cba:	50                   	push   %eax
80105cbb:	6a 00                	push   $0x0
80105cbd:	e8 06 f4 ff ff       	call   801050c8 <argstr>
80105cc2:	83 c4 10             	add    $0x10,%esp
80105cc5:	85 c0                	test   %eax,%eax
80105cc7:	78 18                	js     80105ce1 <sys_chdir+0x44>
80105cc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105ccc:	83 ec 0c             	sub    $0xc,%esp
80105ccf:	50                   	push   %eax
80105cd0:	e8 12 c9 ff ff       	call   801025e7 <namei>
80105cd5:	83 c4 10             	add    $0x10,%esp
80105cd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105cdb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105cdf:	75 0c                	jne    80105ced <sys_chdir+0x50>
    end_op();
80105ce1:	e8 1b d5 ff ff       	call   80103201 <end_op>
    return -1;
80105ce6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ceb:	eb 68                	jmp    80105d55 <sys_chdir+0xb8>
  }
  ilock(ip);
80105ced:	83 ec 0c             	sub    $0xc,%esp
80105cf0:	ff 75 f0             	pushl  -0x10(%ebp)
80105cf3:	e8 84 bd ff ff       	call   80101a7c <ilock>
80105cf8:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80105cfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cfe:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105d02:	66 83 f8 01          	cmp    $0x1,%ax
80105d06:	74 1a                	je     80105d22 <sys_chdir+0x85>
    iunlockput(ip);
80105d08:	83 ec 0c             	sub    $0xc,%esp
80105d0b:	ff 75 f0             	pushl  -0x10(%ebp)
80105d0e:	e8 a6 bf ff ff       	call   80101cb9 <iunlockput>
80105d13:	83 c4 10             	add    $0x10,%esp
    end_op();
80105d16:	e8 e6 d4 ff ff       	call   80103201 <end_op>
    return -1;
80105d1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d20:	eb 33                	jmp    80105d55 <sys_chdir+0xb8>
  }
  iunlock(ip);
80105d22:	83 ec 0c             	sub    $0xc,%esp
80105d25:	ff 75 f0             	pushl  -0x10(%ebp)
80105d28:	e8 66 be ff ff       	call   80101b93 <iunlock>
80105d2d:	83 c4 10             	add    $0x10,%esp
  iput(curproc->cwd);
80105d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d33:	8b 40 68             	mov    0x68(%eax),%eax
80105d36:	83 ec 0c             	sub    $0xc,%esp
80105d39:	50                   	push   %eax
80105d3a:	e8 a6 be ff ff       	call   80101be5 <iput>
80105d3f:	83 c4 10             	add    $0x10,%esp
  end_op();
80105d42:	e8 ba d4 ff ff       	call   80103201 <end_op>
  curproc->cwd = ip;
80105d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105d4d:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80105d50:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105d55:	c9                   	leave  
80105d56:	c3                   	ret    

80105d57 <sys_exec>:

int
sys_exec(void)
{
80105d57:	f3 0f 1e fb          	endbr32 
80105d5b:	55                   	push   %ebp
80105d5c:	89 e5                	mov    %esp,%ebp
80105d5e:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d64:	83 ec 08             	sub    $0x8,%esp
80105d67:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d6a:	50                   	push   %eax
80105d6b:	6a 00                	push   $0x0
80105d6d:	e8 56 f3 ff ff       	call   801050c8 <argstr>
80105d72:	83 c4 10             	add    $0x10,%esp
80105d75:	85 c0                	test   %eax,%eax
80105d77:	78 18                	js     80105d91 <sys_exec+0x3a>
80105d79:	83 ec 08             	sub    $0x8,%esp
80105d7c:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80105d82:	50                   	push   %eax
80105d83:	6a 01                	push   $0x1
80105d85:	e8 a1 f2 ff ff       	call   8010502b <argint>
80105d8a:	83 c4 10             	add    $0x10,%esp
80105d8d:	85 c0                	test   %eax,%eax
80105d8f:	79 0a                	jns    80105d9b <sys_exec+0x44>
    return -1;
80105d91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d96:	e9 c6 00 00 00       	jmp    80105e61 <sys_exec+0x10a>
  }
  memset(argv, 0, sizeof(argv));
80105d9b:	83 ec 04             	sub    $0x4,%esp
80105d9e:	68 80 00 00 00       	push   $0x80
80105da3:	6a 00                	push   $0x0
80105da5:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105dab:	50                   	push   %eax
80105dac:	e8 26 ef ff ff       	call   80104cd7 <memset>
80105db1:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80105db4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80105dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dbe:	83 f8 1f             	cmp    $0x1f,%eax
80105dc1:	76 0a                	jbe    80105dcd <sys_exec+0x76>
      return -1;
80105dc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dc8:	e9 94 00 00 00       	jmp    80105e61 <sys_exec+0x10a>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dd0:	c1 e0 02             	shl    $0x2,%eax
80105dd3:	89 c2                	mov    %eax,%edx
80105dd5:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80105ddb:	01 c2                	add    %eax,%edx
80105ddd:	83 ec 08             	sub    $0x8,%esp
80105de0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105de6:	50                   	push   %eax
80105de7:	52                   	push   %edx
80105de8:	e8 93 f1 ff ff       	call   80104f80 <fetchint>
80105ded:	83 c4 10             	add    $0x10,%esp
80105df0:	85 c0                	test   %eax,%eax
80105df2:	79 07                	jns    80105dfb <sys_exec+0xa4>
      return -1;
80105df4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105df9:	eb 66                	jmp    80105e61 <sys_exec+0x10a>
    if(uarg == 0){
80105dfb:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105e01:	85 c0                	test   %eax,%eax
80105e03:	75 27                	jne    80105e2c <sys_exec+0xd5>
      argv[i] = 0;
80105e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e08:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80105e0f:	00 00 00 00 
      break;
80105e13:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105e14:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e17:	83 ec 08             	sub    $0x8,%esp
80105e1a:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80105e20:	52                   	push   %edx
80105e21:	50                   	push   %eax
80105e22:	e8 97 ad ff ff       	call   80100bbe <exec>
80105e27:	83 c4 10             	add    $0x10,%esp
80105e2a:	eb 35                	jmp    80105e61 <sys_exec+0x10a>
    if(fetchstr(uarg, &argv[i]) < 0)
80105e2c:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105e32:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e35:	c1 e2 02             	shl    $0x2,%edx
80105e38:	01 c2                	add    %eax,%edx
80105e3a:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105e40:	83 ec 08             	sub    $0x8,%esp
80105e43:	52                   	push   %edx
80105e44:	50                   	push   %eax
80105e45:	e8 79 f1 ff ff       	call   80104fc3 <fetchstr>
80105e4a:	83 c4 10             	add    $0x10,%esp
80105e4d:	85 c0                	test   %eax,%eax
80105e4f:	79 07                	jns    80105e58 <sys_exec+0x101>
      return -1;
80105e51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e56:	eb 09                	jmp    80105e61 <sys_exec+0x10a>
  for(i=0;; i++){
80105e58:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(i >= NELEM(argv))
80105e5c:	e9 5a ff ff ff       	jmp    80105dbb <sys_exec+0x64>
}
80105e61:	c9                   	leave  
80105e62:	c3                   	ret    

80105e63 <sys_pipe>:

int
sys_pipe(void)
{
80105e63:	f3 0f 1e fb          	endbr32 
80105e67:	55                   	push   %ebp
80105e68:	89 e5                	mov    %esp,%ebp
80105e6a:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e6d:	83 ec 04             	sub    $0x4,%esp
80105e70:	6a 08                	push   $0x8
80105e72:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e75:	50                   	push   %eax
80105e76:	6a 00                	push   $0x0
80105e78:	e8 df f1 ff ff       	call   8010505c <argptr>
80105e7d:	83 c4 10             	add    $0x10,%esp
80105e80:	85 c0                	test   %eax,%eax
80105e82:	79 0a                	jns    80105e8e <sys_pipe+0x2b>
    return -1;
80105e84:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e89:	e9 ae 00 00 00       	jmp    80105f3c <sys_pipe+0xd9>
  if(pipealloc(&rf, &wf) < 0)
80105e8e:	83 ec 08             	sub    $0x8,%esp
80105e91:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e94:	50                   	push   %eax
80105e95:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105e98:	50                   	push   %eax
80105e99:	e8 2c d8 ff ff       	call   801036ca <pipealloc>
80105e9e:	83 c4 10             	add    $0x10,%esp
80105ea1:	85 c0                	test   %eax,%eax
80105ea3:	79 0a                	jns    80105eaf <sys_pipe+0x4c>
    return -1;
80105ea5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eaa:	e9 8d 00 00 00       	jmp    80105f3c <sys_pipe+0xd9>
  fd0 = -1;
80105eaf:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105eb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105eb9:	83 ec 0c             	sub    $0xc,%esp
80105ebc:	50                   	push   %eax
80105ebd:	e8 3b f3 ff ff       	call   801051fd <fdalloc>
80105ec2:	83 c4 10             	add    $0x10,%esp
80105ec5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ec8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ecc:	78 18                	js     80105ee6 <sys_pipe+0x83>
80105ece:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ed1:	83 ec 0c             	sub    $0xc,%esp
80105ed4:	50                   	push   %eax
80105ed5:	e8 23 f3 ff ff       	call   801051fd <fdalloc>
80105eda:	83 c4 10             	add    $0x10,%esp
80105edd:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105ee0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105ee4:	79 3e                	jns    80105f24 <sys_pipe+0xc1>
    if(fd0 >= 0)
80105ee6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105eea:	78 13                	js     80105eff <sys_pipe+0x9c>
      myproc()->ofile[fd0] = 0;
80105eec:	e8 b8 dc ff ff       	call   80103ba9 <myproc>
80105ef1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ef4:	83 c2 08             	add    $0x8,%edx
80105ef7:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105efe:	00 
    fileclose(rf);
80105eff:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105f02:	83 ec 0c             	sub    $0xc,%esp
80105f05:	50                   	push   %eax
80105f06:	e8 de b1 ff ff       	call   801010e9 <fileclose>
80105f0b:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80105f0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f11:	83 ec 0c             	sub    $0xc,%esp
80105f14:	50                   	push   %eax
80105f15:	e8 cf b1 ff ff       	call   801010e9 <fileclose>
80105f1a:	83 c4 10             	add    $0x10,%esp
    return -1;
80105f1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f22:	eb 18                	jmp    80105f3c <sys_pipe+0xd9>
  }
  fd[0] = fd0;
80105f24:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105f27:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f2a:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80105f2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105f2f:	8d 50 04             	lea    0x4(%eax),%edx
80105f32:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f35:	89 02                	mov    %eax,(%edx)
  return 0;
80105f37:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105f3c:	c9                   	leave  
80105f3d:	c3                   	ret    

80105f3e <sys_fork>:
#include "proc.h"

extern void printpt(int pid);
int
sys_fork(void)
{
80105f3e:	f3 0f 1e fb          	endbr32 
80105f42:	55                   	push   %ebp
80105f43:	89 e5                	mov    %esp,%ebp
80105f45:	83 ec 08             	sub    $0x8,%esp
  return fork();
80105f48:	e8 6f df ff ff       	call   80103ebc <fork>
}
80105f4d:	c9                   	leave  
80105f4e:	c3                   	ret    

80105f4f <sys_exit>:

int
sys_exit(void)
{
80105f4f:	f3 0f 1e fb          	endbr32 
80105f53:	55                   	push   %ebp
80105f54:	89 e5                	mov    %esp,%ebp
80105f56:	83 ec 08             	sub    $0x8,%esp
  exit();
80105f59:	e8 db e0 ff ff       	call   80104039 <exit>
  return 0;  // not reached
80105f5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105f63:	c9                   	leave  
80105f64:	c3                   	ret    

80105f65 <sys_wait>:

int
sys_wait(void)
{
80105f65:	f3 0f 1e fb          	endbr32 
80105f69:	55                   	push   %ebp
80105f6a:	89 e5                	mov    %esp,%ebp
80105f6c:	83 ec 08             	sub    $0x8,%esp
  return wait();
80105f6f:	e8 e9 e1 ff ff       	call   8010415d <wait>
}
80105f74:	c9                   	leave  
80105f75:	c3                   	ret    

80105f76 <sys_kill>:

int
sys_kill(void)
{
80105f76:	f3 0f 1e fb          	endbr32 
80105f7a:	55                   	push   %ebp
80105f7b:	89 e5                	mov    %esp,%ebp
80105f7d:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105f80:	83 ec 08             	sub    $0x8,%esp
80105f83:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f86:	50                   	push   %eax
80105f87:	6a 00                	push   $0x0
80105f89:	e8 9d f0 ff ff       	call   8010502b <argint>
80105f8e:	83 c4 10             	add    $0x10,%esp
80105f91:	85 c0                	test   %eax,%eax
80105f93:	79 07                	jns    80105f9c <sys_kill+0x26>
    return -1;
80105f95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f9a:	eb 0f                	jmp    80105fab <sys_kill+0x35>
  return kill(pid);
80105f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f9f:	83 ec 0c             	sub    $0xc,%esp
80105fa2:	50                   	push   %eax
80105fa3:	e8 04 e6 ff ff       	call   801045ac <kill>
80105fa8:	83 c4 10             	add    $0x10,%esp
}
80105fab:	c9                   	leave  
80105fac:	c3                   	ret    

80105fad <sys_getpid>:

int
sys_getpid(void)
{
80105fad:	f3 0f 1e fb          	endbr32 
80105fb1:	55                   	push   %ebp
80105fb2:	89 e5                	mov    %esp,%ebp
80105fb4:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105fb7:	e8 ed db ff ff       	call   80103ba9 <myproc>
80105fbc:	8b 40 10             	mov    0x10(%eax),%eax
}
80105fbf:	c9                   	leave  
80105fc0:	c3                   	ret    

80105fc1 <sys_sbrk>:

int
sys_sbrk(void)
{
80105fc1:	f3 0f 1e fb          	endbr32 
80105fc5:	55                   	push   %ebp
80105fc6:	89 e5                	mov    %esp,%ebp
80105fc8:	83 ec 18             	sub    $0x18,%esp
  int n;
  if(argint(0, &n) < 0)
80105fcb:	83 ec 08             	sub    $0x8,%esp
80105fce:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105fd1:	50                   	push   %eax
80105fd2:	6a 00                	push   $0x0
80105fd4:	e8 52 f0 ff ff       	call   8010502b <argint>
80105fd9:	83 c4 10             	add    $0x10,%esp
80105fdc:	85 c0                	test   %eax,%eax
80105fde:	79 07                	jns    80105fe7 <sys_sbrk+0x26>
    return -1;
80105fe0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fe5:	eb 69                	jmp    80106050 <sys_sbrk+0x8f>

  struct proc *p = myproc();
80105fe7:	e8 bd db ff ff       	call   80103ba9 <myproc>
80105fec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint oldsz = p->sz;           // 호출 전 힙 끝
80105fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ff2:	8b 00                	mov    (%eax),%eax
80105ff4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  uint newsz = oldsz + n;       // 늘어난(또는 줄어든) 힙 끝
80105ff7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105ffa:	89 c2                	mov    %eax,%edx
80105ffc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fff:	01 d0                	add    %edx,%eax
80106001:	89 45 ec             	mov    %eax,-0x14(%ebp)

  /* ───── 경계 체크 ─────
     USERTOP 은 memlayout.h 에 0x80000000 으로 정의돼 있음               */
  if(newsz >= USERTOP || newsz < PGSIZE)
80106004:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106007:	85 c0                	test   %eax,%eax
80106009:	78 09                	js     80106014 <sys_sbrk+0x53>
8010600b:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
80106012:	77 07                	ja     8010601b <sys_sbrk+0x5a>
    return -1;
80106014:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106019:	eb 35                	jmp    80106050 <sys_sbrk+0x8f>

  /* ───── 크기 조정 ───── */
  if(n < 0){
8010601b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010601e:	85 c0                	test   %eax,%eax
80106020:	79 23                	jns    80106045 <sys_sbrk+0x84>
    // 힙 축소 : 이미 매핑된 페이지만 언맵
    if(deallocuvm(p->pgdir, oldsz, newsz) == 0)
80106022:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106025:	8b 40 04             	mov    0x4(%eax),%eax
80106028:	83 ec 04             	sub    $0x4,%esp
8010602b:	ff 75 ec             	pushl  -0x14(%ebp)
8010602e:	ff 75 f0             	pushl  -0x10(%ebp)
80106031:	50                   	push   %eax
80106032:	e8 1a 1d 00 00       	call   80107d51 <deallocuvm>
80106037:	83 c4 10             	add    $0x10,%esp
8010603a:	85 c0                	test   %eax,%eax
8010603c:	75 07                	jne    80106045 <sys_sbrk+0x84>
      return -1;                // 실패 시 -1
8010603e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106043:	eb 0b                	jmp    80106050 <sys_sbrk+0x8f>
  }
  /* n > 0 인 경우 : lazy allocation
     ── 실제 물리 페이지를 붙이지 않고 sz 값만 늘린다                 */

  p->sz = newsz;
80106045:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106048:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010604b:	89 10                	mov    %edx,(%eax)
  return oldsz;                 // glibc sbrk 규약 : 이전 브레이크 반환
8010604d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80106050:	c9                   	leave  
80106051:	c3                   	ret    

80106052 <sys_sleep>:


int
sys_sleep(void)
{
80106052:	f3 0f 1e fb          	endbr32 
80106056:	55                   	push   %ebp
80106057:	89 e5                	mov    %esp,%ebp
80106059:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
8010605c:	83 ec 08             	sub    $0x8,%esp
8010605f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106062:	50                   	push   %eax
80106063:	6a 00                	push   $0x0
80106065:	e8 c1 ef ff ff       	call   8010502b <argint>
8010606a:	83 c4 10             	add    $0x10,%esp
8010606d:	85 c0                	test   %eax,%eax
8010606f:	79 07                	jns    80106078 <sys_sleep+0x26>
    return -1;
80106071:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106076:	eb 76                	jmp    801060ee <sys_sleep+0x9c>
  acquire(&tickslock);
80106078:	83 ec 0c             	sub    $0xc,%esp
8010607b:	68 40 74 19 80       	push   $0x80197440
80106080:	e8 c3 e9 ff ff       	call   80104a48 <acquire>
80106085:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106088:	a1 80 7c 19 80       	mov    0x80197c80,%eax
8010608d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106090:	eb 38                	jmp    801060ca <sys_sleep+0x78>
    if(myproc()->killed){
80106092:	e8 12 db ff ff       	call   80103ba9 <myproc>
80106097:	8b 40 24             	mov    0x24(%eax),%eax
8010609a:	85 c0                	test   %eax,%eax
8010609c:	74 17                	je     801060b5 <sys_sleep+0x63>
      release(&tickslock);
8010609e:	83 ec 0c             	sub    $0xc,%esp
801060a1:	68 40 74 19 80       	push   $0x80197440
801060a6:	e8 0f ea ff ff       	call   80104aba <release>
801060ab:	83 c4 10             	add    $0x10,%esp
      return -1;
801060ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060b3:	eb 39                	jmp    801060ee <sys_sleep+0x9c>
    }
    sleep(&ticks, &tickslock);
801060b5:	83 ec 08             	sub    $0x8,%esp
801060b8:	68 40 74 19 80       	push   $0x80197440
801060bd:	68 80 7c 19 80       	push   $0x80197c80
801060c2:	e8 bb e3 ff ff       	call   80104482 <sleep>
801060c7:	83 c4 10             	add    $0x10,%esp
  while(ticks - ticks0 < n){
801060ca:	a1 80 7c 19 80       	mov    0x80197c80,%eax
801060cf:	2b 45 f4             	sub    -0xc(%ebp),%eax
801060d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801060d5:	39 d0                	cmp    %edx,%eax
801060d7:	72 b9                	jb     80106092 <sys_sleep+0x40>
  }
  release(&tickslock);
801060d9:	83 ec 0c             	sub    $0xc,%esp
801060dc:	68 40 74 19 80       	push   $0x80197440
801060e1:	e8 d4 e9 ff ff       	call   80104aba <release>
801060e6:	83 c4 10             	add    $0x10,%esp
  return 0;
801060e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801060ee:	c9                   	leave  
801060ef:	c3                   	ret    

801060f0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801060f0:	f3 0f 1e fb          	endbr32 
801060f4:	55                   	push   %ebp
801060f5:	89 e5                	mov    %esp,%ebp
801060f7:	83 ec 18             	sub    $0x18,%esp
  uint xticks;

  acquire(&tickslock);
801060fa:	83 ec 0c             	sub    $0xc,%esp
801060fd:	68 40 74 19 80       	push   $0x80197440
80106102:	e8 41 e9 ff ff       	call   80104a48 <acquire>
80106107:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
8010610a:	a1 80 7c 19 80       	mov    0x80197c80,%eax
8010610f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106112:	83 ec 0c             	sub    $0xc,%esp
80106115:	68 40 74 19 80       	push   $0x80197440
8010611a:	e8 9b e9 ff ff       	call   80104aba <release>
8010611f:	83 c4 10             	add    $0x10,%esp
  return xticks;
80106122:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106125:	c9                   	leave  
80106126:	c3                   	ret    

80106127 <sys_printpt>:


int
sys_printpt(void)
{
80106127:	f3 0f 1e fb          	endbr32 
8010612b:	55                   	push   %ebp
8010612c:	89 e5                	mov    %esp,%ebp
8010612e:	83 ec 18             	sub    $0x18,%esp
  int pid;
  if(argint(0, &pid) < 0) return -1;
80106131:	83 ec 08             	sub    $0x8,%esp
80106134:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106137:	50                   	push   %eax
80106138:	6a 00                	push   $0x0
8010613a:	e8 ec ee ff ff       	call   8010502b <argint>
8010613f:	83 c4 10             	add    $0x10,%esp
80106142:	85 c0                	test   %eax,%eax
80106144:	79 07                	jns    8010614d <sys_printpt+0x26>
80106146:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010614b:	eb 14                	jmp    80106161 <sys_printpt+0x3a>
  printpt(pid);
8010614d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106150:	83 ec 0c             	sub    $0xc,%esp
80106153:	50                   	push   %eax
80106154:	e8 d9 e5 ff ff       	call   80104732 <printpt>
80106159:	83 c4 10             	add    $0x10,%esp
  return 0;
8010615c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106161:	c9                   	leave  
80106162:	c3                   	ret    

80106163 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106163:	1e                   	push   %ds
  pushl %es
80106164:	06                   	push   %es
  pushl %fs
80106165:	0f a0                	push   %fs
  pushl %gs
80106167:	0f a8                	push   %gs
  pushal
80106169:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010616a:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010616e:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106170:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106172:	54                   	push   %esp
  call trap
80106173:	e8 eb 01 00 00       	call   80106363 <trap>
  addl $4, %esp
80106178:	83 c4 04             	add    $0x4,%esp

8010617b <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010617b:	61                   	popa   
  popl %gs
8010617c:	0f a9                	pop    %gs
  popl %fs
8010617e:	0f a1                	pop    %fs
  popl %es
80106180:	07                   	pop    %es
  popl %ds
80106181:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106182:	83 c4 08             	add    $0x8,%esp
  iret
80106185:	cf                   	iret   

80106186 <lidt>:
{
80106186:	55                   	push   %ebp
80106187:	89 e5                	mov    %esp,%ebp
80106189:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
8010618c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010618f:	83 e8 01             	sub    $0x1,%eax
80106192:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106196:	8b 45 08             	mov    0x8(%ebp),%eax
80106199:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010619d:	8b 45 08             	mov    0x8(%ebp),%eax
801061a0:	c1 e8 10             	shr    $0x10,%eax
801061a3:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801061a7:	8d 45 fa             	lea    -0x6(%ebp),%eax
801061aa:	0f 01 18             	lidtl  (%eax)
}
801061ad:	90                   	nop
801061ae:	c9                   	leave  
801061af:	c3                   	ret    

801061b0 <rcr2>:

static inline uint
rcr2(void)
{
801061b0:	55                   	push   %ebp
801061b1:	89 e5                	mov    %esp,%ebp
801061b3:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801061b6:	0f 20 d0             	mov    %cr2,%eax
801061b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
801061bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801061bf:	c9                   	leave  
801061c0:	c3                   	ret    

801061c1 <lcr3>:

static inline void
lcr3(uint val)
{
801061c1:	55                   	push   %ebp
801061c2:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
801061c4:	8b 45 08             	mov    0x8(%ebp),%eax
801061c7:	0f 22 d8             	mov    %eax,%cr3
}
801061ca:	90                   	nop
801061cb:	5d                   	pop    %ebp
801061cc:	c3                   	ret    

801061cd <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801061cd:	f3 0f 1e fb          	endbr32 
801061d1:	55                   	push   %ebp
801061d2:	89 e5                	mov    %esp,%ebp
801061d4:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
801061d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801061de:	e9 c3 00 00 00       	jmp    801062a6 <tvinit+0xd9>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801061e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061e6:	8b 04 85 7c f0 10 80 	mov    -0x7fef0f84(,%eax,4),%eax
801061ed:	89 c2                	mov    %eax,%edx
801061ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061f2:	66 89 14 c5 80 74 19 	mov    %dx,-0x7fe68b80(,%eax,8)
801061f9:	80 
801061fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061fd:	66 c7 04 c5 82 74 19 	movw   $0x8,-0x7fe68b7e(,%eax,8)
80106204:	80 08 00 
80106207:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010620a:	0f b6 14 c5 84 74 19 	movzbl -0x7fe68b7c(,%eax,8),%edx
80106211:	80 
80106212:	83 e2 e0             	and    $0xffffffe0,%edx
80106215:	88 14 c5 84 74 19 80 	mov    %dl,-0x7fe68b7c(,%eax,8)
8010621c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010621f:	0f b6 14 c5 84 74 19 	movzbl -0x7fe68b7c(,%eax,8),%edx
80106226:	80 
80106227:	83 e2 1f             	and    $0x1f,%edx
8010622a:	88 14 c5 84 74 19 80 	mov    %dl,-0x7fe68b7c(,%eax,8)
80106231:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106234:	0f b6 14 c5 85 74 19 	movzbl -0x7fe68b7b(,%eax,8),%edx
8010623b:	80 
8010623c:	83 e2 f0             	and    $0xfffffff0,%edx
8010623f:	83 ca 0e             	or     $0xe,%edx
80106242:	88 14 c5 85 74 19 80 	mov    %dl,-0x7fe68b7b(,%eax,8)
80106249:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010624c:	0f b6 14 c5 85 74 19 	movzbl -0x7fe68b7b(,%eax,8),%edx
80106253:	80 
80106254:	83 e2 ef             	and    $0xffffffef,%edx
80106257:	88 14 c5 85 74 19 80 	mov    %dl,-0x7fe68b7b(,%eax,8)
8010625e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106261:	0f b6 14 c5 85 74 19 	movzbl -0x7fe68b7b(,%eax,8),%edx
80106268:	80 
80106269:	83 e2 9f             	and    $0xffffff9f,%edx
8010626c:	88 14 c5 85 74 19 80 	mov    %dl,-0x7fe68b7b(,%eax,8)
80106273:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106276:	0f b6 14 c5 85 74 19 	movzbl -0x7fe68b7b(,%eax,8),%edx
8010627d:	80 
8010627e:	83 ca 80             	or     $0xffffff80,%edx
80106281:	88 14 c5 85 74 19 80 	mov    %dl,-0x7fe68b7b(,%eax,8)
80106288:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010628b:	8b 04 85 7c f0 10 80 	mov    -0x7fef0f84(,%eax,4),%eax
80106292:	c1 e8 10             	shr    $0x10,%eax
80106295:	89 c2                	mov    %eax,%edx
80106297:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010629a:	66 89 14 c5 86 74 19 	mov    %dx,-0x7fe68b7a(,%eax,8)
801062a1:	80 
  for(i = 0; i < 256; i++)
801062a2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801062a6:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801062ad:	0f 8e 30 ff ff ff    	jle    801061e3 <tvinit+0x16>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801062b3:	a1 7c f1 10 80       	mov    0x8010f17c,%eax
801062b8:	66 a3 80 76 19 80    	mov    %ax,0x80197680
801062be:	66 c7 05 82 76 19 80 	movw   $0x8,0x80197682
801062c5:	08 00 
801062c7:	0f b6 05 84 76 19 80 	movzbl 0x80197684,%eax
801062ce:	83 e0 e0             	and    $0xffffffe0,%eax
801062d1:	a2 84 76 19 80       	mov    %al,0x80197684
801062d6:	0f b6 05 84 76 19 80 	movzbl 0x80197684,%eax
801062dd:	83 e0 1f             	and    $0x1f,%eax
801062e0:	a2 84 76 19 80       	mov    %al,0x80197684
801062e5:	0f b6 05 85 76 19 80 	movzbl 0x80197685,%eax
801062ec:	83 c8 0f             	or     $0xf,%eax
801062ef:	a2 85 76 19 80       	mov    %al,0x80197685
801062f4:	0f b6 05 85 76 19 80 	movzbl 0x80197685,%eax
801062fb:	83 e0 ef             	and    $0xffffffef,%eax
801062fe:	a2 85 76 19 80       	mov    %al,0x80197685
80106303:	0f b6 05 85 76 19 80 	movzbl 0x80197685,%eax
8010630a:	83 c8 60             	or     $0x60,%eax
8010630d:	a2 85 76 19 80       	mov    %al,0x80197685
80106312:	0f b6 05 85 76 19 80 	movzbl 0x80197685,%eax
80106319:	83 c8 80             	or     $0xffffff80,%eax
8010631c:	a2 85 76 19 80       	mov    %al,0x80197685
80106321:	a1 7c f1 10 80       	mov    0x8010f17c,%eax
80106326:	c1 e8 10             	shr    $0x10,%eax
80106329:	66 a3 86 76 19 80    	mov    %ax,0x80197686

  initlock(&tickslock, "time");
8010632f:	83 ec 08             	sub    $0x8,%esp
80106332:	68 30 ab 10 80       	push   $0x8010ab30
80106337:	68 40 74 19 80       	push   $0x80197440
8010633c:	e8 e1 e6 ff ff       	call   80104a22 <initlock>
80106341:	83 c4 10             	add    $0x10,%esp
}
80106344:	90                   	nop
80106345:	c9                   	leave  
80106346:	c3                   	ret    

80106347 <idtinit>:

void
idtinit(void)
{
80106347:	f3 0f 1e fb          	endbr32 
8010634b:	55                   	push   %ebp
8010634c:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
8010634e:	68 00 08 00 00       	push   $0x800
80106353:	68 80 74 19 80       	push   $0x80197480
80106358:	e8 29 fe ff ff       	call   80106186 <lidt>
8010635d:	83 c4 08             	add    $0x8,%esp
}
80106360:	90                   	nop
80106361:	c9                   	leave  
80106362:	c3                   	ret    

80106363 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106363:	f3 0f 1e fb          	endbr32 
80106367:	55                   	push   %ebp
80106368:	89 e5                	mov    %esp,%ebp
8010636a:	57                   	push   %edi
8010636b:	56                   	push   %esi
8010636c:	53                   	push   %ebx
8010636d:	83 ec 2c             	sub    $0x2c,%esp
  if(tf->trapno == T_SYSCALL){
80106370:	8b 45 08             	mov    0x8(%ebp),%eax
80106373:	8b 40 30             	mov    0x30(%eax),%eax
80106376:	83 f8 40             	cmp    $0x40,%eax
80106379:	75 3b                	jne    801063b6 <trap+0x53>
    if(myproc()->killed)
8010637b:	e8 29 d8 ff ff       	call   80103ba9 <myproc>
80106380:	8b 40 24             	mov    0x24(%eax),%eax
80106383:	85 c0                	test   %eax,%eax
80106385:	74 05                	je     8010638c <trap+0x29>
      exit();
80106387:	e8 ad dc ff ff       	call   80104039 <exit>
    myproc()->tf = tf;
8010638c:	e8 18 d8 ff ff       	call   80103ba9 <myproc>
80106391:	8b 55 08             	mov    0x8(%ebp),%edx
80106394:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106397:	e8 67 ed ff ff       	call   80105103 <syscall>
    if(myproc()->killed)
8010639c:	e8 08 d8 ff ff       	call   80103ba9 <myproc>
801063a1:	8b 40 24             	mov    0x24(%eax),%eax
801063a4:	85 c0                	test   %eax,%eax
801063a6:	0f 84 44 03 00 00    	je     801066f0 <trap+0x38d>
      exit();
801063ac:	e8 88 dc ff ff       	call   80104039 <exit>
    return;
801063b1:	e9 3a 03 00 00       	jmp    801066f0 <trap+0x38d>
  }

  switch(tf->trapno){
801063b6:	8b 45 08             	mov    0x8(%ebp),%eax
801063b9:	8b 40 30             	mov    0x30(%eax),%eax
801063bc:	83 e8 0e             	sub    $0xe,%eax
801063bf:	83 f8 31             	cmp    $0x31,%eax
801063c2:	0f 87 f3 01 00 00    	ja     801065bb <trap+0x258>
801063c8:	8b 04 85 d8 ab 10 80 	mov    -0x7fef5428(,%eax,4),%eax
801063cf:	3e ff e0             	notrack jmp *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801063d2:	e8 37 d7 ff ff       	call   80103b0e <cpuid>
801063d7:	85 c0                	test   %eax,%eax
801063d9:	75 3d                	jne    80106418 <trap+0xb5>
      acquire(&tickslock);
801063db:	83 ec 0c             	sub    $0xc,%esp
801063de:	68 40 74 19 80       	push   $0x80197440
801063e3:	e8 60 e6 ff ff       	call   80104a48 <acquire>
801063e8:	83 c4 10             	add    $0x10,%esp
      ticks++;
801063eb:	a1 80 7c 19 80       	mov    0x80197c80,%eax
801063f0:	83 c0 01             	add    $0x1,%eax
801063f3:	a3 80 7c 19 80       	mov    %eax,0x80197c80
      wakeup(&ticks);
801063f8:	83 ec 0c             	sub    $0xc,%esp
801063fb:	68 80 7c 19 80       	push   $0x80197c80
80106400:	e8 6c e1 ff ff       	call   80104571 <wakeup>
80106405:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80106408:	83 ec 0c             	sub    $0xc,%esp
8010640b:	68 40 74 19 80       	push   $0x80197440
80106410:	e8 a5 e6 ff ff       	call   80104aba <release>
80106415:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80106418:	e8 08 c8 ff ff       	call   80102c25 <lapiceoi>
    break;
8010641d:	e9 4e 02 00 00       	jmp    80106670 <trap+0x30d>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106422:	e8 73 41 00 00       	call   8010a59a <ideintr>
    lapiceoi();
80106427:	e8 f9 c7 ff ff       	call   80102c25 <lapiceoi>
    break;
8010642c:	e9 3f 02 00 00       	jmp    80106670 <trap+0x30d>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106431:	e8 25 c6 ff ff       	call   80102a5b <kbdintr>
    lapiceoi();
80106436:	e8 ea c7 ff ff       	call   80102c25 <lapiceoi>
    break;
8010643b:	e9 30 02 00 00       	jmp    80106670 <trap+0x30d>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106440:	e8 8d 04 00 00       	call   801068d2 <uartintr>
    lapiceoi();
80106445:	e8 db c7 ff ff       	call   80102c25 <lapiceoi>
    break;
8010644a:	e9 21 02 00 00       	jmp    80106670 <trap+0x30d>
  case T_PGFLT: {
  uint va = PGROUNDDOWN(rcr2());
8010644f:	e8 5c fd ff ff       	call   801061b0 <rcr2>
80106454:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106459:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct proc *p = myproc();
8010645c:	e8 48 d7 ff ff       	call   80103ba9 <myproc>
80106461:	89 45 e0             	mov    %eax,-0x20(%ebp)

  if(va >= USERTOP || va < PGSIZE){           // 0x0 ~ 커널 영역
80106464:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106467:	85 c0                	test   %eax,%eax
80106469:	78 09                	js     80106474 <trap+0x111>
8010646b:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
80106472:	77 0f                	ja     80106483 <trap+0x120>
    p->killed = 1;  break;
80106474:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106477:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010647e:	e9 ed 01 00 00       	jmp    80106670 <trap+0x30d>
  }

  pte_t *pte = walkpgdir(p->pgdir, (void*)va, 0);
80106483:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106486:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106489:	8b 40 04             	mov    0x4(%eax),%eax
8010648c:	83 ec 04             	sub    $0x4,%esp
8010648f:	6a 00                	push   $0x0
80106491:	52                   	push   %edx
80106492:	50                   	push   %eax
80106493:	e8 70 12 00 00       	call   80107708 <walkpgdir>
80106498:	83 c4 10             	add    $0x10,%esp
8010649b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(pte && (*pte & PTE_P)){                  // 이미 매핑: 권한 오류/가드
8010649e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
801064a2:	74 1b                	je     801064bf <trap+0x15c>
801064a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801064a7:	8b 00                	mov    (%eax),%eax
801064a9:	83 e0 01             	and    $0x1,%eax
801064ac:	85 c0                	test   %eax,%eax
801064ae:	74 0f                	je     801064bf <trap+0x15c>
    p->killed = 1;  break;
801064b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801064b3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801064ba:	e9 b1 01 00 00       	jmp    80106670 <trap+0x30d>
  }

  if(va + PGSIZE < p->tf->esp - 32){          // 스택 허용 범위 바깥
801064bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801064c2:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
801064c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801064cb:	8b 40 18             	mov    0x18(%eax),%eax
801064ce:	8b 40 44             	mov    0x44(%eax),%eax
801064d1:	83 e8 20             	sub    $0x20,%eax
801064d4:	39 c2                	cmp    %eax,%edx
801064d6:	73 0f                	jae    801064e7 <trap+0x184>
    p->killed = 1;  break;
801064d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801064db:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801064e2:	e9 89 01 00 00       	jmp    80106670 <trap+0x30d>
  }

  char *mem = kalloc();
801064e7:	e8 a6 c3 ff ff       	call   80102892 <kalloc>
801064ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  if(!mem){ p->killed = 1; break; }
801064ef:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
801064f3:	75 0f                	jne    80106504 <trap+0x1a1>
801064f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801064f8:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801064ff:	e9 6c 01 00 00       	jmp    80106670 <trap+0x30d>
  memset(mem, 0, PGSIZE);
80106504:	83 ec 04             	sub    $0x4,%esp
80106507:	68 00 10 00 00       	push   $0x1000
8010650c:	6a 00                	push   $0x0
8010650e:	ff 75 d8             	pushl  -0x28(%ebp)
80106511:	e8 c1 e7 ff ff       	call   80104cd7 <memset>
80106516:	83 c4 10             	add    $0x10,%esp

  if(mappages(p->pgdir, (void*)va, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106519:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010651c:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80106522:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106525:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106528:	8b 40 04             	mov    0x4(%eax),%eax
8010652b:	83 ec 0c             	sub    $0xc,%esp
8010652e:	6a 06                	push   $0x6
80106530:	51                   	push   %ecx
80106531:	68 00 10 00 00       	push   $0x1000
80106536:	52                   	push   %edx
80106537:	50                   	push   %eax
80106538:	e8 65 12 00 00       	call   801077a2 <mappages>
8010653d:	83 c4 20             	add    $0x20,%esp
80106540:	85 c0                	test   %eax,%eax
80106542:	79 1d                	jns    80106561 <trap+0x1fe>
    kfree(mem); p->killed = 1; break;
80106544:	83 ec 0c             	sub    $0xc,%esp
80106547:	ff 75 d8             	pushl  -0x28(%ebp)
8010654a:	e8 a5 c2 ff ff       	call   801027f4 <kfree>
8010654f:	83 c4 10             	add    $0x10,%esp
80106552:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106555:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010655c:	e9 0f 01 00 00       	jmp    80106670 <trap+0x30d>
  }
  lcr3(V2P(p->pgdir));                        // TLB flush
80106561:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106564:	8b 40 04             	mov    0x4(%eax),%eax
80106567:	05 00 00 00 80       	add    $0x80000000,%eax
8010656c:	83 ec 0c             	sub    $0xc,%esp
8010656f:	50                   	push   %eax
80106570:	e8 4c fc ff ff       	call   801061c1 <lcr3>
80106575:	83 c4 10             	add    $0x10,%esp
  break;
80106578:	e9 f3 00 00 00       	jmp    80106670 <trap+0x30d>
}


  case T_IRQ0 + 0xB:
    i8254_intr();
8010657d:	e8 57 2c 00 00       	call   801091d9 <i8254_intr>
    lapiceoi();
80106582:	e8 9e c6 ff ff       	call   80102c25 <lapiceoi>
    break;
80106587:	e9 e4 00 00 00       	jmp    80106670 <trap+0x30d>
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010658c:	8b 45 08             	mov    0x8(%ebp),%eax
8010658f:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
80106592:	8b 45 08             	mov    0x8(%ebp),%eax
80106595:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106599:	0f b7 d8             	movzwl %ax,%ebx
8010659c:	e8 6d d5 ff ff       	call   80103b0e <cpuid>
801065a1:	56                   	push   %esi
801065a2:	53                   	push   %ebx
801065a3:	50                   	push   %eax
801065a4:	68 38 ab 10 80       	push   $0x8010ab38
801065a9:	e8 5e 9e ff ff       	call   8010040c <cprintf>
801065ae:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801065b1:	e8 6f c6 ff ff       	call   80102c25 <lapiceoi>
    break;
801065b6:	e9 b5 00 00 00       	jmp    80106670 <trap+0x30d>

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801065bb:	e8 e9 d5 ff ff       	call   80103ba9 <myproc>
801065c0:	85 c0                	test   %eax,%eax
801065c2:	74 11                	je     801065d5 <trap+0x272>
801065c4:	8b 45 08             	mov    0x8(%ebp),%eax
801065c7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801065cb:	0f b7 c0             	movzwl %ax,%eax
801065ce:	83 e0 03             	and    $0x3,%eax
801065d1:	85 c0                	test   %eax,%eax
801065d3:	75 39                	jne    8010660e <trap+0x2ab>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801065d5:	e8 d6 fb ff ff       	call   801061b0 <rcr2>
801065da:	89 c3                	mov    %eax,%ebx
801065dc:	8b 45 08             	mov    0x8(%ebp),%eax
801065df:	8b 70 38             	mov    0x38(%eax),%esi
801065e2:	e8 27 d5 ff ff       	call   80103b0e <cpuid>
801065e7:	8b 55 08             	mov    0x8(%ebp),%edx
801065ea:	8b 52 30             	mov    0x30(%edx),%edx
801065ed:	83 ec 0c             	sub    $0xc,%esp
801065f0:	53                   	push   %ebx
801065f1:	56                   	push   %esi
801065f2:	50                   	push   %eax
801065f3:	52                   	push   %edx
801065f4:	68 5c ab 10 80       	push   $0x8010ab5c
801065f9:	e8 0e 9e ff ff       	call   8010040c <cprintf>
801065fe:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80106601:	83 ec 0c             	sub    $0xc,%esp
80106604:	68 8e ab 10 80       	push   $0x8010ab8e
80106609:	e8 b7 9f ff ff       	call   801005c5 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010660e:	e8 9d fb ff ff       	call   801061b0 <rcr2>
80106613:	89 c6                	mov    %eax,%esi
80106615:	8b 45 08             	mov    0x8(%ebp),%eax
80106618:	8b 40 38             	mov    0x38(%eax),%eax
8010661b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
8010661e:	e8 eb d4 ff ff       	call   80103b0e <cpuid>
80106623:	89 c3                	mov    %eax,%ebx
80106625:	8b 45 08             	mov    0x8(%ebp),%eax
80106628:	8b 48 34             	mov    0x34(%eax),%ecx
8010662b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010662e:	8b 45 08             	mov    0x8(%ebp),%eax
80106631:	8b 78 30             	mov    0x30(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106634:	e8 70 d5 ff ff       	call   80103ba9 <myproc>
80106639:	8d 50 6c             	lea    0x6c(%eax),%edx
8010663c:	89 55 cc             	mov    %edx,-0x34(%ebp)
8010663f:	e8 65 d5 ff ff       	call   80103ba9 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106644:	8b 40 10             	mov    0x10(%eax),%eax
80106647:	56                   	push   %esi
80106648:	ff 75 d4             	pushl  -0x2c(%ebp)
8010664b:	53                   	push   %ebx
8010664c:	ff 75 d0             	pushl  -0x30(%ebp)
8010664f:	57                   	push   %edi
80106650:	ff 75 cc             	pushl  -0x34(%ebp)
80106653:	50                   	push   %eax
80106654:	68 94 ab 10 80       	push   $0x8010ab94
80106659:	e8 ae 9d ff ff       	call   8010040c <cprintf>
8010665e:	83 c4 20             	add    $0x20,%esp
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106661:	e8 43 d5 ff ff       	call   80103ba9 <myproc>
80106666:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010666d:	eb 01                	jmp    80106670 <trap+0x30d>
    break;
8010666f:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106670:	e8 34 d5 ff ff       	call   80103ba9 <myproc>
80106675:	85 c0                	test   %eax,%eax
80106677:	74 23                	je     8010669c <trap+0x339>
80106679:	e8 2b d5 ff ff       	call   80103ba9 <myproc>
8010667e:	8b 40 24             	mov    0x24(%eax),%eax
80106681:	85 c0                	test   %eax,%eax
80106683:	74 17                	je     8010669c <trap+0x339>
80106685:	8b 45 08             	mov    0x8(%ebp),%eax
80106688:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010668c:	0f b7 c0             	movzwl %ax,%eax
8010668f:	83 e0 03             	and    $0x3,%eax
80106692:	83 f8 03             	cmp    $0x3,%eax
80106695:	75 05                	jne    8010669c <trap+0x339>
    exit();
80106697:	e8 9d d9 ff ff       	call   80104039 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
8010669c:	e8 08 d5 ff ff       	call   80103ba9 <myproc>
801066a1:	85 c0                	test   %eax,%eax
801066a3:	74 1d                	je     801066c2 <trap+0x35f>
801066a5:	e8 ff d4 ff ff       	call   80103ba9 <myproc>
801066aa:	8b 40 0c             	mov    0xc(%eax),%eax
801066ad:	83 f8 04             	cmp    $0x4,%eax
801066b0:	75 10                	jne    801066c2 <trap+0x35f>
     tf->trapno == T_IRQ0+IRQ_TIMER)
801066b2:	8b 45 08             	mov    0x8(%ebp),%eax
801066b5:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->state == RUNNING &&
801066b8:	83 f8 20             	cmp    $0x20,%eax
801066bb:	75 05                	jne    801066c2 <trap+0x35f>
    yield();
801066bd:	e8 38 dd ff ff       	call   801043fa <yield>

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801066c2:	e8 e2 d4 ff ff       	call   80103ba9 <myproc>
801066c7:	85 c0                	test   %eax,%eax
801066c9:	74 26                	je     801066f1 <trap+0x38e>
801066cb:	e8 d9 d4 ff ff       	call   80103ba9 <myproc>
801066d0:	8b 40 24             	mov    0x24(%eax),%eax
801066d3:	85 c0                	test   %eax,%eax
801066d5:	74 1a                	je     801066f1 <trap+0x38e>
801066d7:	8b 45 08             	mov    0x8(%ebp),%eax
801066da:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801066de:	0f b7 c0             	movzwl %ax,%eax
801066e1:	83 e0 03             	and    $0x3,%eax
801066e4:	83 f8 03             	cmp    $0x3,%eax
801066e7:	75 08                	jne    801066f1 <trap+0x38e>
    exit();
801066e9:	e8 4b d9 ff ff       	call   80104039 <exit>
801066ee:	eb 01                	jmp    801066f1 <trap+0x38e>
    return;
801066f0:	90                   	nop
}
801066f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066f4:	5b                   	pop    %ebx
801066f5:	5e                   	pop    %esi
801066f6:	5f                   	pop    %edi
801066f7:	5d                   	pop    %ebp
801066f8:	c3                   	ret    

801066f9 <inb>:
{
801066f9:	55                   	push   %ebp
801066fa:	89 e5                	mov    %esp,%ebp
801066fc:	83 ec 14             	sub    $0x14,%esp
801066ff:	8b 45 08             	mov    0x8(%ebp),%eax
80106702:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106706:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010670a:	89 c2                	mov    %eax,%edx
8010670c:	ec                   	in     (%dx),%al
8010670d:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106710:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106714:	c9                   	leave  
80106715:	c3                   	ret    

80106716 <outb>:
{
80106716:	55                   	push   %ebp
80106717:	89 e5                	mov    %esp,%ebp
80106719:	83 ec 08             	sub    $0x8,%esp
8010671c:	8b 45 08             	mov    0x8(%ebp),%eax
8010671f:	8b 55 0c             	mov    0xc(%ebp),%edx
80106722:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80106726:	89 d0                	mov    %edx,%eax
80106728:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010672b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010672f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106733:	ee                   	out    %al,(%dx)
}
80106734:	90                   	nop
80106735:	c9                   	leave  
80106736:	c3                   	ret    

80106737 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106737:	f3 0f 1e fb          	endbr32 
8010673b:	55                   	push   %ebp
8010673c:	89 e5                	mov    %esp,%ebp
8010673e:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106741:	6a 00                	push   $0x0
80106743:	68 fa 03 00 00       	push   $0x3fa
80106748:	e8 c9 ff ff ff       	call   80106716 <outb>
8010674d:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106750:	68 80 00 00 00       	push   $0x80
80106755:	68 fb 03 00 00       	push   $0x3fb
8010675a:	e8 b7 ff ff ff       	call   80106716 <outb>
8010675f:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80106762:	6a 0c                	push   $0xc
80106764:	68 f8 03 00 00       	push   $0x3f8
80106769:	e8 a8 ff ff ff       	call   80106716 <outb>
8010676e:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80106771:	6a 00                	push   $0x0
80106773:	68 f9 03 00 00       	push   $0x3f9
80106778:	e8 99 ff ff ff       	call   80106716 <outb>
8010677d:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106780:	6a 03                	push   $0x3
80106782:	68 fb 03 00 00       	push   $0x3fb
80106787:	e8 8a ff ff ff       	call   80106716 <outb>
8010678c:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
8010678f:	6a 00                	push   $0x0
80106791:	68 fc 03 00 00       	push   $0x3fc
80106796:	e8 7b ff ff ff       	call   80106716 <outb>
8010679b:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
8010679e:	6a 01                	push   $0x1
801067a0:	68 f9 03 00 00       	push   $0x3f9
801067a5:	e8 6c ff ff ff       	call   80106716 <outb>
801067aa:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801067ad:	68 fd 03 00 00       	push   $0x3fd
801067b2:	e8 42 ff ff ff       	call   801066f9 <inb>
801067b7:	83 c4 04             	add    $0x4,%esp
801067ba:	3c ff                	cmp    $0xff,%al
801067bc:	74 61                	je     8010681f <uartinit+0xe8>
    return;
  uart = 1;
801067be:	c7 05 60 d0 18 80 01 	movl   $0x1,0x8018d060
801067c5:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
801067c8:	68 fa 03 00 00       	push   $0x3fa
801067cd:	e8 27 ff ff ff       	call   801066f9 <inb>
801067d2:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
801067d5:	68 f8 03 00 00       	push   $0x3f8
801067da:	e8 1a ff ff ff       	call   801066f9 <inb>
801067df:	83 c4 04             	add    $0x4,%esp
  ioapicenable(IRQ_COM1, 0);
801067e2:	83 ec 08             	sub    $0x8,%esp
801067e5:	6a 00                	push   $0x0
801067e7:	6a 04                	push   $0x4
801067e9:	e8 1e bf ff ff       	call   8010270c <ioapicenable>
801067ee:	83 c4 10             	add    $0x10,%esp

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801067f1:	c7 45 f4 a0 ac 10 80 	movl   $0x8010aca0,-0xc(%ebp)
801067f8:	eb 19                	jmp    80106813 <uartinit+0xdc>
    uartputc(*p);
801067fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067fd:	0f b6 00             	movzbl (%eax),%eax
80106800:	0f be c0             	movsbl %al,%eax
80106803:	83 ec 0c             	sub    $0xc,%esp
80106806:	50                   	push   %eax
80106807:	e8 16 00 00 00       	call   80106822 <uartputc>
8010680c:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
8010680f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106813:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106816:	0f b6 00             	movzbl (%eax),%eax
80106819:	84 c0                	test   %al,%al
8010681b:	75 dd                	jne    801067fa <uartinit+0xc3>
8010681d:	eb 01                	jmp    80106820 <uartinit+0xe9>
    return;
8010681f:	90                   	nop
}
80106820:	c9                   	leave  
80106821:	c3                   	ret    

80106822 <uartputc>:

void
uartputc(int c)
{
80106822:	f3 0f 1e fb          	endbr32 
80106826:	55                   	push   %ebp
80106827:	89 e5                	mov    %esp,%ebp
80106829:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
8010682c:	a1 60 d0 18 80       	mov    0x8018d060,%eax
80106831:	85 c0                	test   %eax,%eax
80106833:	74 53                	je     80106888 <uartputc+0x66>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106835:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010683c:	eb 11                	jmp    8010684f <uartputc+0x2d>
    microdelay(10);
8010683e:	83 ec 0c             	sub    $0xc,%esp
80106841:	6a 0a                	push   $0xa
80106843:	e8 fc c3 ff ff       	call   80102c44 <microdelay>
80106848:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010684b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010684f:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106853:	7f 1a                	jg     8010686f <uartputc+0x4d>
80106855:	83 ec 0c             	sub    $0xc,%esp
80106858:	68 fd 03 00 00       	push   $0x3fd
8010685d:	e8 97 fe ff ff       	call   801066f9 <inb>
80106862:	83 c4 10             	add    $0x10,%esp
80106865:	0f b6 c0             	movzbl %al,%eax
80106868:	83 e0 20             	and    $0x20,%eax
8010686b:	85 c0                	test   %eax,%eax
8010686d:	74 cf                	je     8010683e <uartputc+0x1c>
  outb(COM1+0, c);
8010686f:	8b 45 08             	mov    0x8(%ebp),%eax
80106872:	0f b6 c0             	movzbl %al,%eax
80106875:	83 ec 08             	sub    $0x8,%esp
80106878:	50                   	push   %eax
80106879:	68 f8 03 00 00       	push   $0x3f8
8010687e:	e8 93 fe ff ff       	call   80106716 <outb>
80106883:	83 c4 10             	add    $0x10,%esp
80106886:	eb 01                	jmp    80106889 <uartputc+0x67>
    return;
80106888:	90                   	nop
}
80106889:	c9                   	leave  
8010688a:	c3                   	ret    

8010688b <uartgetc>:

static int
uartgetc(void)
{
8010688b:	f3 0f 1e fb          	endbr32 
8010688f:	55                   	push   %ebp
80106890:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106892:	a1 60 d0 18 80       	mov    0x8018d060,%eax
80106897:	85 c0                	test   %eax,%eax
80106899:	75 07                	jne    801068a2 <uartgetc+0x17>
    return -1;
8010689b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068a0:	eb 2e                	jmp    801068d0 <uartgetc+0x45>
  if(!(inb(COM1+5) & 0x01))
801068a2:	68 fd 03 00 00       	push   $0x3fd
801068a7:	e8 4d fe ff ff       	call   801066f9 <inb>
801068ac:	83 c4 04             	add    $0x4,%esp
801068af:	0f b6 c0             	movzbl %al,%eax
801068b2:	83 e0 01             	and    $0x1,%eax
801068b5:	85 c0                	test   %eax,%eax
801068b7:	75 07                	jne    801068c0 <uartgetc+0x35>
    return -1;
801068b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068be:	eb 10                	jmp    801068d0 <uartgetc+0x45>
  return inb(COM1+0);
801068c0:	68 f8 03 00 00       	push   $0x3f8
801068c5:	e8 2f fe ff ff       	call   801066f9 <inb>
801068ca:	83 c4 04             	add    $0x4,%esp
801068cd:	0f b6 c0             	movzbl %al,%eax
}
801068d0:	c9                   	leave  
801068d1:	c3                   	ret    

801068d2 <uartintr>:

void
uartintr(void)
{
801068d2:	f3 0f 1e fb          	endbr32 
801068d6:	55                   	push   %ebp
801068d7:	89 e5                	mov    %esp,%ebp
801068d9:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
801068dc:	83 ec 0c             	sub    $0xc,%esp
801068df:	68 8b 68 10 80       	push   $0x8010688b
801068e4:	e8 17 9f ff ff       	call   80100800 <consoleintr>
801068e9:	83 c4 10             	add    $0x10,%esp
}
801068ec:	90                   	nop
801068ed:	c9                   	leave  
801068ee:	c3                   	ret    

801068ef <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $0
801068f1:	6a 00                	push   $0x0
  jmp alltraps
801068f3:	e9 6b f8 ff ff       	jmp    80106163 <alltraps>

801068f8 <vector1>:
.globl vector1
vector1:
  pushl $0
801068f8:	6a 00                	push   $0x0
  pushl $1
801068fa:	6a 01                	push   $0x1
  jmp alltraps
801068fc:	e9 62 f8 ff ff       	jmp    80106163 <alltraps>

80106901 <vector2>:
.globl vector2
vector2:
  pushl $0
80106901:	6a 00                	push   $0x0
  pushl $2
80106903:	6a 02                	push   $0x2
  jmp alltraps
80106905:	e9 59 f8 ff ff       	jmp    80106163 <alltraps>

8010690a <vector3>:
.globl vector3
vector3:
  pushl $0
8010690a:	6a 00                	push   $0x0
  pushl $3
8010690c:	6a 03                	push   $0x3
  jmp alltraps
8010690e:	e9 50 f8 ff ff       	jmp    80106163 <alltraps>

80106913 <vector4>:
.globl vector4
vector4:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $4
80106915:	6a 04                	push   $0x4
  jmp alltraps
80106917:	e9 47 f8 ff ff       	jmp    80106163 <alltraps>

8010691c <vector5>:
.globl vector5
vector5:
  pushl $0
8010691c:	6a 00                	push   $0x0
  pushl $5
8010691e:	6a 05                	push   $0x5
  jmp alltraps
80106920:	e9 3e f8 ff ff       	jmp    80106163 <alltraps>

80106925 <vector6>:
.globl vector6
vector6:
  pushl $0
80106925:	6a 00                	push   $0x0
  pushl $6
80106927:	6a 06                	push   $0x6
  jmp alltraps
80106929:	e9 35 f8 ff ff       	jmp    80106163 <alltraps>

8010692e <vector7>:
.globl vector7
vector7:
  pushl $0
8010692e:	6a 00                	push   $0x0
  pushl $7
80106930:	6a 07                	push   $0x7
  jmp alltraps
80106932:	e9 2c f8 ff ff       	jmp    80106163 <alltraps>

80106937 <vector8>:
.globl vector8
vector8:
  pushl $8
80106937:	6a 08                	push   $0x8
  jmp alltraps
80106939:	e9 25 f8 ff ff       	jmp    80106163 <alltraps>

8010693e <vector9>:
.globl vector9
vector9:
  pushl $0
8010693e:	6a 00                	push   $0x0
  pushl $9
80106940:	6a 09                	push   $0x9
  jmp alltraps
80106942:	e9 1c f8 ff ff       	jmp    80106163 <alltraps>

80106947 <vector10>:
.globl vector10
vector10:
  pushl $10
80106947:	6a 0a                	push   $0xa
  jmp alltraps
80106949:	e9 15 f8 ff ff       	jmp    80106163 <alltraps>

8010694e <vector11>:
.globl vector11
vector11:
  pushl $11
8010694e:	6a 0b                	push   $0xb
  jmp alltraps
80106950:	e9 0e f8 ff ff       	jmp    80106163 <alltraps>

80106955 <vector12>:
.globl vector12
vector12:
  pushl $12
80106955:	6a 0c                	push   $0xc
  jmp alltraps
80106957:	e9 07 f8 ff ff       	jmp    80106163 <alltraps>

8010695c <vector13>:
.globl vector13
vector13:
  pushl $13
8010695c:	6a 0d                	push   $0xd
  jmp alltraps
8010695e:	e9 00 f8 ff ff       	jmp    80106163 <alltraps>

80106963 <vector14>:
.globl vector14
vector14:
  pushl $14
80106963:	6a 0e                	push   $0xe
  jmp alltraps
80106965:	e9 f9 f7 ff ff       	jmp    80106163 <alltraps>

8010696a <vector15>:
.globl vector15
vector15:
  pushl $0
8010696a:	6a 00                	push   $0x0
  pushl $15
8010696c:	6a 0f                	push   $0xf
  jmp alltraps
8010696e:	e9 f0 f7 ff ff       	jmp    80106163 <alltraps>

80106973 <vector16>:
.globl vector16
vector16:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $16
80106975:	6a 10                	push   $0x10
  jmp alltraps
80106977:	e9 e7 f7 ff ff       	jmp    80106163 <alltraps>

8010697c <vector17>:
.globl vector17
vector17:
  pushl $17
8010697c:	6a 11                	push   $0x11
  jmp alltraps
8010697e:	e9 e0 f7 ff ff       	jmp    80106163 <alltraps>

80106983 <vector18>:
.globl vector18
vector18:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $18
80106985:	6a 12                	push   $0x12
  jmp alltraps
80106987:	e9 d7 f7 ff ff       	jmp    80106163 <alltraps>

8010698c <vector19>:
.globl vector19
vector19:
  pushl $0
8010698c:	6a 00                	push   $0x0
  pushl $19
8010698e:	6a 13                	push   $0x13
  jmp alltraps
80106990:	e9 ce f7 ff ff       	jmp    80106163 <alltraps>

80106995 <vector20>:
.globl vector20
vector20:
  pushl $0
80106995:	6a 00                	push   $0x0
  pushl $20
80106997:	6a 14                	push   $0x14
  jmp alltraps
80106999:	e9 c5 f7 ff ff       	jmp    80106163 <alltraps>

8010699e <vector21>:
.globl vector21
vector21:
  pushl $0
8010699e:	6a 00                	push   $0x0
  pushl $21
801069a0:	6a 15                	push   $0x15
  jmp alltraps
801069a2:	e9 bc f7 ff ff       	jmp    80106163 <alltraps>

801069a7 <vector22>:
.globl vector22
vector22:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $22
801069a9:	6a 16                	push   $0x16
  jmp alltraps
801069ab:	e9 b3 f7 ff ff       	jmp    80106163 <alltraps>

801069b0 <vector23>:
.globl vector23
vector23:
  pushl $0
801069b0:	6a 00                	push   $0x0
  pushl $23
801069b2:	6a 17                	push   $0x17
  jmp alltraps
801069b4:	e9 aa f7 ff ff       	jmp    80106163 <alltraps>

801069b9 <vector24>:
.globl vector24
vector24:
  pushl $0
801069b9:	6a 00                	push   $0x0
  pushl $24
801069bb:	6a 18                	push   $0x18
  jmp alltraps
801069bd:	e9 a1 f7 ff ff       	jmp    80106163 <alltraps>

801069c2 <vector25>:
.globl vector25
vector25:
  pushl $0
801069c2:	6a 00                	push   $0x0
  pushl $25
801069c4:	6a 19                	push   $0x19
  jmp alltraps
801069c6:	e9 98 f7 ff ff       	jmp    80106163 <alltraps>

801069cb <vector26>:
.globl vector26
vector26:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $26
801069cd:	6a 1a                	push   $0x1a
  jmp alltraps
801069cf:	e9 8f f7 ff ff       	jmp    80106163 <alltraps>

801069d4 <vector27>:
.globl vector27
vector27:
  pushl $0
801069d4:	6a 00                	push   $0x0
  pushl $27
801069d6:	6a 1b                	push   $0x1b
  jmp alltraps
801069d8:	e9 86 f7 ff ff       	jmp    80106163 <alltraps>

801069dd <vector28>:
.globl vector28
vector28:
  pushl $0
801069dd:	6a 00                	push   $0x0
  pushl $28
801069df:	6a 1c                	push   $0x1c
  jmp alltraps
801069e1:	e9 7d f7 ff ff       	jmp    80106163 <alltraps>

801069e6 <vector29>:
.globl vector29
vector29:
  pushl $0
801069e6:	6a 00                	push   $0x0
  pushl $29
801069e8:	6a 1d                	push   $0x1d
  jmp alltraps
801069ea:	e9 74 f7 ff ff       	jmp    80106163 <alltraps>

801069ef <vector30>:
.globl vector30
vector30:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $30
801069f1:	6a 1e                	push   $0x1e
  jmp alltraps
801069f3:	e9 6b f7 ff ff       	jmp    80106163 <alltraps>

801069f8 <vector31>:
.globl vector31
vector31:
  pushl $0
801069f8:	6a 00                	push   $0x0
  pushl $31
801069fa:	6a 1f                	push   $0x1f
  jmp alltraps
801069fc:	e9 62 f7 ff ff       	jmp    80106163 <alltraps>

80106a01 <vector32>:
.globl vector32
vector32:
  pushl $0
80106a01:	6a 00                	push   $0x0
  pushl $32
80106a03:	6a 20                	push   $0x20
  jmp alltraps
80106a05:	e9 59 f7 ff ff       	jmp    80106163 <alltraps>

80106a0a <vector33>:
.globl vector33
vector33:
  pushl $0
80106a0a:	6a 00                	push   $0x0
  pushl $33
80106a0c:	6a 21                	push   $0x21
  jmp alltraps
80106a0e:	e9 50 f7 ff ff       	jmp    80106163 <alltraps>

80106a13 <vector34>:
.globl vector34
vector34:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $34
80106a15:	6a 22                	push   $0x22
  jmp alltraps
80106a17:	e9 47 f7 ff ff       	jmp    80106163 <alltraps>

80106a1c <vector35>:
.globl vector35
vector35:
  pushl $0
80106a1c:	6a 00                	push   $0x0
  pushl $35
80106a1e:	6a 23                	push   $0x23
  jmp alltraps
80106a20:	e9 3e f7 ff ff       	jmp    80106163 <alltraps>

80106a25 <vector36>:
.globl vector36
vector36:
  pushl $0
80106a25:	6a 00                	push   $0x0
  pushl $36
80106a27:	6a 24                	push   $0x24
  jmp alltraps
80106a29:	e9 35 f7 ff ff       	jmp    80106163 <alltraps>

80106a2e <vector37>:
.globl vector37
vector37:
  pushl $0
80106a2e:	6a 00                	push   $0x0
  pushl $37
80106a30:	6a 25                	push   $0x25
  jmp alltraps
80106a32:	e9 2c f7 ff ff       	jmp    80106163 <alltraps>

80106a37 <vector38>:
.globl vector38
vector38:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $38
80106a39:	6a 26                	push   $0x26
  jmp alltraps
80106a3b:	e9 23 f7 ff ff       	jmp    80106163 <alltraps>

80106a40 <vector39>:
.globl vector39
vector39:
  pushl $0
80106a40:	6a 00                	push   $0x0
  pushl $39
80106a42:	6a 27                	push   $0x27
  jmp alltraps
80106a44:	e9 1a f7 ff ff       	jmp    80106163 <alltraps>

80106a49 <vector40>:
.globl vector40
vector40:
  pushl $0
80106a49:	6a 00                	push   $0x0
  pushl $40
80106a4b:	6a 28                	push   $0x28
  jmp alltraps
80106a4d:	e9 11 f7 ff ff       	jmp    80106163 <alltraps>

80106a52 <vector41>:
.globl vector41
vector41:
  pushl $0
80106a52:	6a 00                	push   $0x0
  pushl $41
80106a54:	6a 29                	push   $0x29
  jmp alltraps
80106a56:	e9 08 f7 ff ff       	jmp    80106163 <alltraps>

80106a5b <vector42>:
.globl vector42
vector42:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $42
80106a5d:	6a 2a                	push   $0x2a
  jmp alltraps
80106a5f:	e9 ff f6 ff ff       	jmp    80106163 <alltraps>

80106a64 <vector43>:
.globl vector43
vector43:
  pushl $0
80106a64:	6a 00                	push   $0x0
  pushl $43
80106a66:	6a 2b                	push   $0x2b
  jmp alltraps
80106a68:	e9 f6 f6 ff ff       	jmp    80106163 <alltraps>

80106a6d <vector44>:
.globl vector44
vector44:
  pushl $0
80106a6d:	6a 00                	push   $0x0
  pushl $44
80106a6f:	6a 2c                	push   $0x2c
  jmp alltraps
80106a71:	e9 ed f6 ff ff       	jmp    80106163 <alltraps>

80106a76 <vector45>:
.globl vector45
vector45:
  pushl $0
80106a76:	6a 00                	push   $0x0
  pushl $45
80106a78:	6a 2d                	push   $0x2d
  jmp alltraps
80106a7a:	e9 e4 f6 ff ff       	jmp    80106163 <alltraps>

80106a7f <vector46>:
.globl vector46
vector46:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $46
80106a81:	6a 2e                	push   $0x2e
  jmp alltraps
80106a83:	e9 db f6 ff ff       	jmp    80106163 <alltraps>

80106a88 <vector47>:
.globl vector47
vector47:
  pushl $0
80106a88:	6a 00                	push   $0x0
  pushl $47
80106a8a:	6a 2f                	push   $0x2f
  jmp alltraps
80106a8c:	e9 d2 f6 ff ff       	jmp    80106163 <alltraps>

80106a91 <vector48>:
.globl vector48
vector48:
  pushl $0
80106a91:	6a 00                	push   $0x0
  pushl $48
80106a93:	6a 30                	push   $0x30
  jmp alltraps
80106a95:	e9 c9 f6 ff ff       	jmp    80106163 <alltraps>

80106a9a <vector49>:
.globl vector49
vector49:
  pushl $0
80106a9a:	6a 00                	push   $0x0
  pushl $49
80106a9c:	6a 31                	push   $0x31
  jmp alltraps
80106a9e:	e9 c0 f6 ff ff       	jmp    80106163 <alltraps>

80106aa3 <vector50>:
.globl vector50
vector50:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $50
80106aa5:	6a 32                	push   $0x32
  jmp alltraps
80106aa7:	e9 b7 f6 ff ff       	jmp    80106163 <alltraps>

80106aac <vector51>:
.globl vector51
vector51:
  pushl $0
80106aac:	6a 00                	push   $0x0
  pushl $51
80106aae:	6a 33                	push   $0x33
  jmp alltraps
80106ab0:	e9 ae f6 ff ff       	jmp    80106163 <alltraps>

80106ab5 <vector52>:
.globl vector52
vector52:
  pushl $0
80106ab5:	6a 00                	push   $0x0
  pushl $52
80106ab7:	6a 34                	push   $0x34
  jmp alltraps
80106ab9:	e9 a5 f6 ff ff       	jmp    80106163 <alltraps>

80106abe <vector53>:
.globl vector53
vector53:
  pushl $0
80106abe:	6a 00                	push   $0x0
  pushl $53
80106ac0:	6a 35                	push   $0x35
  jmp alltraps
80106ac2:	e9 9c f6 ff ff       	jmp    80106163 <alltraps>

80106ac7 <vector54>:
.globl vector54
vector54:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $54
80106ac9:	6a 36                	push   $0x36
  jmp alltraps
80106acb:	e9 93 f6 ff ff       	jmp    80106163 <alltraps>

80106ad0 <vector55>:
.globl vector55
vector55:
  pushl $0
80106ad0:	6a 00                	push   $0x0
  pushl $55
80106ad2:	6a 37                	push   $0x37
  jmp alltraps
80106ad4:	e9 8a f6 ff ff       	jmp    80106163 <alltraps>

80106ad9 <vector56>:
.globl vector56
vector56:
  pushl $0
80106ad9:	6a 00                	push   $0x0
  pushl $56
80106adb:	6a 38                	push   $0x38
  jmp alltraps
80106add:	e9 81 f6 ff ff       	jmp    80106163 <alltraps>

80106ae2 <vector57>:
.globl vector57
vector57:
  pushl $0
80106ae2:	6a 00                	push   $0x0
  pushl $57
80106ae4:	6a 39                	push   $0x39
  jmp alltraps
80106ae6:	e9 78 f6 ff ff       	jmp    80106163 <alltraps>

80106aeb <vector58>:
.globl vector58
vector58:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $58
80106aed:	6a 3a                	push   $0x3a
  jmp alltraps
80106aef:	e9 6f f6 ff ff       	jmp    80106163 <alltraps>

80106af4 <vector59>:
.globl vector59
vector59:
  pushl $0
80106af4:	6a 00                	push   $0x0
  pushl $59
80106af6:	6a 3b                	push   $0x3b
  jmp alltraps
80106af8:	e9 66 f6 ff ff       	jmp    80106163 <alltraps>

80106afd <vector60>:
.globl vector60
vector60:
  pushl $0
80106afd:	6a 00                	push   $0x0
  pushl $60
80106aff:	6a 3c                	push   $0x3c
  jmp alltraps
80106b01:	e9 5d f6 ff ff       	jmp    80106163 <alltraps>

80106b06 <vector61>:
.globl vector61
vector61:
  pushl $0
80106b06:	6a 00                	push   $0x0
  pushl $61
80106b08:	6a 3d                	push   $0x3d
  jmp alltraps
80106b0a:	e9 54 f6 ff ff       	jmp    80106163 <alltraps>

80106b0f <vector62>:
.globl vector62
vector62:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $62
80106b11:	6a 3e                	push   $0x3e
  jmp alltraps
80106b13:	e9 4b f6 ff ff       	jmp    80106163 <alltraps>

80106b18 <vector63>:
.globl vector63
vector63:
  pushl $0
80106b18:	6a 00                	push   $0x0
  pushl $63
80106b1a:	6a 3f                	push   $0x3f
  jmp alltraps
80106b1c:	e9 42 f6 ff ff       	jmp    80106163 <alltraps>

80106b21 <vector64>:
.globl vector64
vector64:
  pushl $0
80106b21:	6a 00                	push   $0x0
  pushl $64
80106b23:	6a 40                	push   $0x40
  jmp alltraps
80106b25:	e9 39 f6 ff ff       	jmp    80106163 <alltraps>

80106b2a <vector65>:
.globl vector65
vector65:
  pushl $0
80106b2a:	6a 00                	push   $0x0
  pushl $65
80106b2c:	6a 41                	push   $0x41
  jmp alltraps
80106b2e:	e9 30 f6 ff ff       	jmp    80106163 <alltraps>

80106b33 <vector66>:
.globl vector66
vector66:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $66
80106b35:	6a 42                	push   $0x42
  jmp alltraps
80106b37:	e9 27 f6 ff ff       	jmp    80106163 <alltraps>

80106b3c <vector67>:
.globl vector67
vector67:
  pushl $0
80106b3c:	6a 00                	push   $0x0
  pushl $67
80106b3e:	6a 43                	push   $0x43
  jmp alltraps
80106b40:	e9 1e f6 ff ff       	jmp    80106163 <alltraps>

80106b45 <vector68>:
.globl vector68
vector68:
  pushl $0
80106b45:	6a 00                	push   $0x0
  pushl $68
80106b47:	6a 44                	push   $0x44
  jmp alltraps
80106b49:	e9 15 f6 ff ff       	jmp    80106163 <alltraps>

80106b4e <vector69>:
.globl vector69
vector69:
  pushl $0
80106b4e:	6a 00                	push   $0x0
  pushl $69
80106b50:	6a 45                	push   $0x45
  jmp alltraps
80106b52:	e9 0c f6 ff ff       	jmp    80106163 <alltraps>

80106b57 <vector70>:
.globl vector70
vector70:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $70
80106b59:	6a 46                	push   $0x46
  jmp alltraps
80106b5b:	e9 03 f6 ff ff       	jmp    80106163 <alltraps>

80106b60 <vector71>:
.globl vector71
vector71:
  pushl $0
80106b60:	6a 00                	push   $0x0
  pushl $71
80106b62:	6a 47                	push   $0x47
  jmp alltraps
80106b64:	e9 fa f5 ff ff       	jmp    80106163 <alltraps>

80106b69 <vector72>:
.globl vector72
vector72:
  pushl $0
80106b69:	6a 00                	push   $0x0
  pushl $72
80106b6b:	6a 48                	push   $0x48
  jmp alltraps
80106b6d:	e9 f1 f5 ff ff       	jmp    80106163 <alltraps>

80106b72 <vector73>:
.globl vector73
vector73:
  pushl $0
80106b72:	6a 00                	push   $0x0
  pushl $73
80106b74:	6a 49                	push   $0x49
  jmp alltraps
80106b76:	e9 e8 f5 ff ff       	jmp    80106163 <alltraps>

80106b7b <vector74>:
.globl vector74
vector74:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $74
80106b7d:	6a 4a                	push   $0x4a
  jmp alltraps
80106b7f:	e9 df f5 ff ff       	jmp    80106163 <alltraps>

80106b84 <vector75>:
.globl vector75
vector75:
  pushl $0
80106b84:	6a 00                	push   $0x0
  pushl $75
80106b86:	6a 4b                	push   $0x4b
  jmp alltraps
80106b88:	e9 d6 f5 ff ff       	jmp    80106163 <alltraps>

80106b8d <vector76>:
.globl vector76
vector76:
  pushl $0
80106b8d:	6a 00                	push   $0x0
  pushl $76
80106b8f:	6a 4c                	push   $0x4c
  jmp alltraps
80106b91:	e9 cd f5 ff ff       	jmp    80106163 <alltraps>

80106b96 <vector77>:
.globl vector77
vector77:
  pushl $0
80106b96:	6a 00                	push   $0x0
  pushl $77
80106b98:	6a 4d                	push   $0x4d
  jmp alltraps
80106b9a:	e9 c4 f5 ff ff       	jmp    80106163 <alltraps>

80106b9f <vector78>:
.globl vector78
vector78:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $78
80106ba1:	6a 4e                	push   $0x4e
  jmp alltraps
80106ba3:	e9 bb f5 ff ff       	jmp    80106163 <alltraps>

80106ba8 <vector79>:
.globl vector79
vector79:
  pushl $0
80106ba8:	6a 00                	push   $0x0
  pushl $79
80106baa:	6a 4f                	push   $0x4f
  jmp alltraps
80106bac:	e9 b2 f5 ff ff       	jmp    80106163 <alltraps>

80106bb1 <vector80>:
.globl vector80
vector80:
  pushl $0
80106bb1:	6a 00                	push   $0x0
  pushl $80
80106bb3:	6a 50                	push   $0x50
  jmp alltraps
80106bb5:	e9 a9 f5 ff ff       	jmp    80106163 <alltraps>

80106bba <vector81>:
.globl vector81
vector81:
  pushl $0
80106bba:	6a 00                	push   $0x0
  pushl $81
80106bbc:	6a 51                	push   $0x51
  jmp alltraps
80106bbe:	e9 a0 f5 ff ff       	jmp    80106163 <alltraps>

80106bc3 <vector82>:
.globl vector82
vector82:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $82
80106bc5:	6a 52                	push   $0x52
  jmp alltraps
80106bc7:	e9 97 f5 ff ff       	jmp    80106163 <alltraps>

80106bcc <vector83>:
.globl vector83
vector83:
  pushl $0
80106bcc:	6a 00                	push   $0x0
  pushl $83
80106bce:	6a 53                	push   $0x53
  jmp alltraps
80106bd0:	e9 8e f5 ff ff       	jmp    80106163 <alltraps>

80106bd5 <vector84>:
.globl vector84
vector84:
  pushl $0
80106bd5:	6a 00                	push   $0x0
  pushl $84
80106bd7:	6a 54                	push   $0x54
  jmp alltraps
80106bd9:	e9 85 f5 ff ff       	jmp    80106163 <alltraps>

80106bde <vector85>:
.globl vector85
vector85:
  pushl $0
80106bde:	6a 00                	push   $0x0
  pushl $85
80106be0:	6a 55                	push   $0x55
  jmp alltraps
80106be2:	e9 7c f5 ff ff       	jmp    80106163 <alltraps>

80106be7 <vector86>:
.globl vector86
vector86:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $86
80106be9:	6a 56                	push   $0x56
  jmp alltraps
80106beb:	e9 73 f5 ff ff       	jmp    80106163 <alltraps>

80106bf0 <vector87>:
.globl vector87
vector87:
  pushl $0
80106bf0:	6a 00                	push   $0x0
  pushl $87
80106bf2:	6a 57                	push   $0x57
  jmp alltraps
80106bf4:	e9 6a f5 ff ff       	jmp    80106163 <alltraps>

80106bf9 <vector88>:
.globl vector88
vector88:
  pushl $0
80106bf9:	6a 00                	push   $0x0
  pushl $88
80106bfb:	6a 58                	push   $0x58
  jmp alltraps
80106bfd:	e9 61 f5 ff ff       	jmp    80106163 <alltraps>

80106c02 <vector89>:
.globl vector89
vector89:
  pushl $0
80106c02:	6a 00                	push   $0x0
  pushl $89
80106c04:	6a 59                	push   $0x59
  jmp alltraps
80106c06:	e9 58 f5 ff ff       	jmp    80106163 <alltraps>

80106c0b <vector90>:
.globl vector90
vector90:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $90
80106c0d:	6a 5a                	push   $0x5a
  jmp alltraps
80106c0f:	e9 4f f5 ff ff       	jmp    80106163 <alltraps>

80106c14 <vector91>:
.globl vector91
vector91:
  pushl $0
80106c14:	6a 00                	push   $0x0
  pushl $91
80106c16:	6a 5b                	push   $0x5b
  jmp alltraps
80106c18:	e9 46 f5 ff ff       	jmp    80106163 <alltraps>

80106c1d <vector92>:
.globl vector92
vector92:
  pushl $0
80106c1d:	6a 00                	push   $0x0
  pushl $92
80106c1f:	6a 5c                	push   $0x5c
  jmp alltraps
80106c21:	e9 3d f5 ff ff       	jmp    80106163 <alltraps>

80106c26 <vector93>:
.globl vector93
vector93:
  pushl $0
80106c26:	6a 00                	push   $0x0
  pushl $93
80106c28:	6a 5d                	push   $0x5d
  jmp alltraps
80106c2a:	e9 34 f5 ff ff       	jmp    80106163 <alltraps>

80106c2f <vector94>:
.globl vector94
vector94:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $94
80106c31:	6a 5e                	push   $0x5e
  jmp alltraps
80106c33:	e9 2b f5 ff ff       	jmp    80106163 <alltraps>

80106c38 <vector95>:
.globl vector95
vector95:
  pushl $0
80106c38:	6a 00                	push   $0x0
  pushl $95
80106c3a:	6a 5f                	push   $0x5f
  jmp alltraps
80106c3c:	e9 22 f5 ff ff       	jmp    80106163 <alltraps>

80106c41 <vector96>:
.globl vector96
vector96:
  pushl $0
80106c41:	6a 00                	push   $0x0
  pushl $96
80106c43:	6a 60                	push   $0x60
  jmp alltraps
80106c45:	e9 19 f5 ff ff       	jmp    80106163 <alltraps>

80106c4a <vector97>:
.globl vector97
vector97:
  pushl $0
80106c4a:	6a 00                	push   $0x0
  pushl $97
80106c4c:	6a 61                	push   $0x61
  jmp alltraps
80106c4e:	e9 10 f5 ff ff       	jmp    80106163 <alltraps>

80106c53 <vector98>:
.globl vector98
vector98:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $98
80106c55:	6a 62                	push   $0x62
  jmp alltraps
80106c57:	e9 07 f5 ff ff       	jmp    80106163 <alltraps>

80106c5c <vector99>:
.globl vector99
vector99:
  pushl $0
80106c5c:	6a 00                	push   $0x0
  pushl $99
80106c5e:	6a 63                	push   $0x63
  jmp alltraps
80106c60:	e9 fe f4 ff ff       	jmp    80106163 <alltraps>

80106c65 <vector100>:
.globl vector100
vector100:
  pushl $0
80106c65:	6a 00                	push   $0x0
  pushl $100
80106c67:	6a 64                	push   $0x64
  jmp alltraps
80106c69:	e9 f5 f4 ff ff       	jmp    80106163 <alltraps>

80106c6e <vector101>:
.globl vector101
vector101:
  pushl $0
80106c6e:	6a 00                	push   $0x0
  pushl $101
80106c70:	6a 65                	push   $0x65
  jmp alltraps
80106c72:	e9 ec f4 ff ff       	jmp    80106163 <alltraps>

80106c77 <vector102>:
.globl vector102
vector102:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $102
80106c79:	6a 66                	push   $0x66
  jmp alltraps
80106c7b:	e9 e3 f4 ff ff       	jmp    80106163 <alltraps>

80106c80 <vector103>:
.globl vector103
vector103:
  pushl $0
80106c80:	6a 00                	push   $0x0
  pushl $103
80106c82:	6a 67                	push   $0x67
  jmp alltraps
80106c84:	e9 da f4 ff ff       	jmp    80106163 <alltraps>

80106c89 <vector104>:
.globl vector104
vector104:
  pushl $0
80106c89:	6a 00                	push   $0x0
  pushl $104
80106c8b:	6a 68                	push   $0x68
  jmp alltraps
80106c8d:	e9 d1 f4 ff ff       	jmp    80106163 <alltraps>

80106c92 <vector105>:
.globl vector105
vector105:
  pushl $0
80106c92:	6a 00                	push   $0x0
  pushl $105
80106c94:	6a 69                	push   $0x69
  jmp alltraps
80106c96:	e9 c8 f4 ff ff       	jmp    80106163 <alltraps>

80106c9b <vector106>:
.globl vector106
vector106:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $106
80106c9d:	6a 6a                	push   $0x6a
  jmp alltraps
80106c9f:	e9 bf f4 ff ff       	jmp    80106163 <alltraps>

80106ca4 <vector107>:
.globl vector107
vector107:
  pushl $0
80106ca4:	6a 00                	push   $0x0
  pushl $107
80106ca6:	6a 6b                	push   $0x6b
  jmp alltraps
80106ca8:	e9 b6 f4 ff ff       	jmp    80106163 <alltraps>

80106cad <vector108>:
.globl vector108
vector108:
  pushl $0
80106cad:	6a 00                	push   $0x0
  pushl $108
80106caf:	6a 6c                	push   $0x6c
  jmp alltraps
80106cb1:	e9 ad f4 ff ff       	jmp    80106163 <alltraps>

80106cb6 <vector109>:
.globl vector109
vector109:
  pushl $0
80106cb6:	6a 00                	push   $0x0
  pushl $109
80106cb8:	6a 6d                	push   $0x6d
  jmp alltraps
80106cba:	e9 a4 f4 ff ff       	jmp    80106163 <alltraps>

80106cbf <vector110>:
.globl vector110
vector110:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $110
80106cc1:	6a 6e                	push   $0x6e
  jmp alltraps
80106cc3:	e9 9b f4 ff ff       	jmp    80106163 <alltraps>

80106cc8 <vector111>:
.globl vector111
vector111:
  pushl $0
80106cc8:	6a 00                	push   $0x0
  pushl $111
80106cca:	6a 6f                	push   $0x6f
  jmp alltraps
80106ccc:	e9 92 f4 ff ff       	jmp    80106163 <alltraps>

80106cd1 <vector112>:
.globl vector112
vector112:
  pushl $0
80106cd1:	6a 00                	push   $0x0
  pushl $112
80106cd3:	6a 70                	push   $0x70
  jmp alltraps
80106cd5:	e9 89 f4 ff ff       	jmp    80106163 <alltraps>

80106cda <vector113>:
.globl vector113
vector113:
  pushl $0
80106cda:	6a 00                	push   $0x0
  pushl $113
80106cdc:	6a 71                	push   $0x71
  jmp alltraps
80106cde:	e9 80 f4 ff ff       	jmp    80106163 <alltraps>

80106ce3 <vector114>:
.globl vector114
vector114:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $114
80106ce5:	6a 72                	push   $0x72
  jmp alltraps
80106ce7:	e9 77 f4 ff ff       	jmp    80106163 <alltraps>

80106cec <vector115>:
.globl vector115
vector115:
  pushl $0
80106cec:	6a 00                	push   $0x0
  pushl $115
80106cee:	6a 73                	push   $0x73
  jmp alltraps
80106cf0:	e9 6e f4 ff ff       	jmp    80106163 <alltraps>

80106cf5 <vector116>:
.globl vector116
vector116:
  pushl $0
80106cf5:	6a 00                	push   $0x0
  pushl $116
80106cf7:	6a 74                	push   $0x74
  jmp alltraps
80106cf9:	e9 65 f4 ff ff       	jmp    80106163 <alltraps>

80106cfe <vector117>:
.globl vector117
vector117:
  pushl $0
80106cfe:	6a 00                	push   $0x0
  pushl $117
80106d00:	6a 75                	push   $0x75
  jmp alltraps
80106d02:	e9 5c f4 ff ff       	jmp    80106163 <alltraps>

80106d07 <vector118>:
.globl vector118
vector118:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $118
80106d09:	6a 76                	push   $0x76
  jmp alltraps
80106d0b:	e9 53 f4 ff ff       	jmp    80106163 <alltraps>

80106d10 <vector119>:
.globl vector119
vector119:
  pushl $0
80106d10:	6a 00                	push   $0x0
  pushl $119
80106d12:	6a 77                	push   $0x77
  jmp alltraps
80106d14:	e9 4a f4 ff ff       	jmp    80106163 <alltraps>

80106d19 <vector120>:
.globl vector120
vector120:
  pushl $0
80106d19:	6a 00                	push   $0x0
  pushl $120
80106d1b:	6a 78                	push   $0x78
  jmp alltraps
80106d1d:	e9 41 f4 ff ff       	jmp    80106163 <alltraps>

80106d22 <vector121>:
.globl vector121
vector121:
  pushl $0
80106d22:	6a 00                	push   $0x0
  pushl $121
80106d24:	6a 79                	push   $0x79
  jmp alltraps
80106d26:	e9 38 f4 ff ff       	jmp    80106163 <alltraps>

80106d2b <vector122>:
.globl vector122
vector122:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $122
80106d2d:	6a 7a                	push   $0x7a
  jmp alltraps
80106d2f:	e9 2f f4 ff ff       	jmp    80106163 <alltraps>

80106d34 <vector123>:
.globl vector123
vector123:
  pushl $0
80106d34:	6a 00                	push   $0x0
  pushl $123
80106d36:	6a 7b                	push   $0x7b
  jmp alltraps
80106d38:	e9 26 f4 ff ff       	jmp    80106163 <alltraps>

80106d3d <vector124>:
.globl vector124
vector124:
  pushl $0
80106d3d:	6a 00                	push   $0x0
  pushl $124
80106d3f:	6a 7c                	push   $0x7c
  jmp alltraps
80106d41:	e9 1d f4 ff ff       	jmp    80106163 <alltraps>

80106d46 <vector125>:
.globl vector125
vector125:
  pushl $0
80106d46:	6a 00                	push   $0x0
  pushl $125
80106d48:	6a 7d                	push   $0x7d
  jmp alltraps
80106d4a:	e9 14 f4 ff ff       	jmp    80106163 <alltraps>

80106d4f <vector126>:
.globl vector126
vector126:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $126
80106d51:	6a 7e                	push   $0x7e
  jmp alltraps
80106d53:	e9 0b f4 ff ff       	jmp    80106163 <alltraps>

80106d58 <vector127>:
.globl vector127
vector127:
  pushl $0
80106d58:	6a 00                	push   $0x0
  pushl $127
80106d5a:	6a 7f                	push   $0x7f
  jmp alltraps
80106d5c:	e9 02 f4 ff ff       	jmp    80106163 <alltraps>

80106d61 <vector128>:
.globl vector128
vector128:
  pushl $0
80106d61:	6a 00                	push   $0x0
  pushl $128
80106d63:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106d68:	e9 f6 f3 ff ff       	jmp    80106163 <alltraps>

80106d6d <vector129>:
.globl vector129
vector129:
  pushl $0
80106d6d:	6a 00                	push   $0x0
  pushl $129
80106d6f:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106d74:	e9 ea f3 ff ff       	jmp    80106163 <alltraps>

80106d79 <vector130>:
.globl vector130
vector130:
  pushl $0
80106d79:	6a 00                	push   $0x0
  pushl $130
80106d7b:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106d80:	e9 de f3 ff ff       	jmp    80106163 <alltraps>

80106d85 <vector131>:
.globl vector131
vector131:
  pushl $0
80106d85:	6a 00                	push   $0x0
  pushl $131
80106d87:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106d8c:	e9 d2 f3 ff ff       	jmp    80106163 <alltraps>

80106d91 <vector132>:
.globl vector132
vector132:
  pushl $0
80106d91:	6a 00                	push   $0x0
  pushl $132
80106d93:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106d98:	e9 c6 f3 ff ff       	jmp    80106163 <alltraps>

80106d9d <vector133>:
.globl vector133
vector133:
  pushl $0
80106d9d:	6a 00                	push   $0x0
  pushl $133
80106d9f:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106da4:	e9 ba f3 ff ff       	jmp    80106163 <alltraps>

80106da9 <vector134>:
.globl vector134
vector134:
  pushl $0
80106da9:	6a 00                	push   $0x0
  pushl $134
80106dab:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106db0:	e9 ae f3 ff ff       	jmp    80106163 <alltraps>

80106db5 <vector135>:
.globl vector135
vector135:
  pushl $0
80106db5:	6a 00                	push   $0x0
  pushl $135
80106db7:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106dbc:	e9 a2 f3 ff ff       	jmp    80106163 <alltraps>

80106dc1 <vector136>:
.globl vector136
vector136:
  pushl $0
80106dc1:	6a 00                	push   $0x0
  pushl $136
80106dc3:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106dc8:	e9 96 f3 ff ff       	jmp    80106163 <alltraps>

80106dcd <vector137>:
.globl vector137
vector137:
  pushl $0
80106dcd:	6a 00                	push   $0x0
  pushl $137
80106dcf:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106dd4:	e9 8a f3 ff ff       	jmp    80106163 <alltraps>

80106dd9 <vector138>:
.globl vector138
vector138:
  pushl $0
80106dd9:	6a 00                	push   $0x0
  pushl $138
80106ddb:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106de0:	e9 7e f3 ff ff       	jmp    80106163 <alltraps>

80106de5 <vector139>:
.globl vector139
vector139:
  pushl $0
80106de5:	6a 00                	push   $0x0
  pushl $139
80106de7:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106dec:	e9 72 f3 ff ff       	jmp    80106163 <alltraps>

80106df1 <vector140>:
.globl vector140
vector140:
  pushl $0
80106df1:	6a 00                	push   $0x0
  pushl $140
80106df3:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106df8:	e9 66 f3 ff ff       	jmp    80106163 <alltraps>

80106dfd <vector141>:
.globl vector141
vector141:
  pushl $0
80106dfd:	6a 00                	push   $0x0
  pushl $141
80106dff:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106e04:	e9 5a f3 ff ff       	jmp    80106163 <alltraps>

80106e09 <vector142>:
.globl vector142
vector142:
  pushl $0
80106e09:	6a 00                	push   $0x0
  pushl $142
80106e0b:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106e10:	e9 4e f3 ff ff       	jmp    80106163 <alltraps>

80106e15 <vector143>:
.globl vector143
vector143:
  pushl $0
80106e15:	6a 00                	push   $0x0
  pushl $143
80106e17:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106e1c:	e9 42 f3 ff ff       	jmp    80106163 <alltraps>

80106e21 <vector144>:
.globl vector144
vector144:
  pushl $0
80106e21:	6a 00                	push   $0x0
  pushl $144
80106e23:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106e28:	e9 36 f3 ff ff       	jmp    80106163 <alltraps>

80106e2d <vector145>:
.globl vector145
vector145:
  pushl $0
80106e2d:	6a 00                	push   $0x0
  pushl $145
80106e2f:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106e34:	e9 2a f3 ff ff       	jmp    80106163 <alltraps>

80106e39 <vector146>:
.globl vector146
vector146:
  pushl $0
80106e39:	6a 00                	push   $0x0
  pushl $146
80106e3b:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106e40:	e9 1e f3 ff ff       	jmp    80106163 <alltraps>

80106e45 <vector147>:
.globl vector147
vector147:
  pushl $0
80106e45:	6a 00                	push   $0x0
  pushl $147
80106e47:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106e4c:	e9 12 f3 ff ff       	jmp    80106163 <alltraps>

80106e51 <vector148>:
.globl vector148
vector148:
  pushl $0
80106e51:	6a 00                	push   $0x0
  pushl $148
80106e53:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106e58:	e9 06 f3 ff ff       	jmp    80106163 <alltraps>

80106e5d <vector149>:
.globl vector149
vector149:
  pushl $0
80106e5d:	6a 00                	push   $0x0
  pushl $149
80106e5f:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106e64:	e9 fa f2 ff ff       	jmp    80106163 <alltraps>

80106e69 <vector150>:
.globl vector150
vector150:
  pushl $0
80106e69:	6a 00                	push   $0x0
  pushl $150
80106e6b:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106e70:	e9 ee f2 ff ff       	jmp    80106163 <alltraps>

80106e75 <vector151>:
.globl vector151
vector151:
  pushl $0
80106e75:	6a 00                	push   $0x0
  pushl $151
80106e77:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106e7c:	e9 e2 f2 ff ff       	jmp    80106163 <alltraps>

80106e81 <vector152>:
.globl vector152
vector152:
  pushl $0
80106e81:	6a 00                	push   $0x0
  pushl $152
80106e83:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106e88:	e9 d6 f2 ff ff       	jmp    80106163 <alltraps>

80106e8d <vector153>:
.globl vector153
vector153:
  pushl $0
80106e8d:	6a 00                	push   $0x0
  pushl $153
80106e8f:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106e94:	e9 ca f2 ff ff       	jmp    80106163 <alltraps>

80106e99 <vector154>:
.globl vector154
vector154:
  pushl $0
80106e99:	6a 00                	push   $0x0
  pushl $154
80106e9b:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106ea0:	e9 be f2 ff ff       	jmp    80106163 <alltraps>

80106ea5 <vector155>:
.globl vector155
vector155:
  pushl $0
80106ea5:	6a 00                	push   $0x0
  pushl $155
80106ea7:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106eac:	e9 b2 f2 ff ff       	jmp    80106163 <alltraps>

80106eb1 <vector156>:
.globl vector156
vector156:
  pushl $0
80106eb1:	6a 00                	push   $0x0
  pushl $156
80106eb3:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106eb8:	e9 a6 f2 ff ff       	jmp    80106163 <alltraps>

80106ebd <vector157>:
.globl vector157
vector157:
  pushl $0
80106ebd:	6a 00                	push   $0x0
  pushl $157
80106ebf:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106ec4:	e9 9a f2 ff ff       	jmp    80106163 <alltraps>

80106ec9 <vector158>:
.globl vector158
vector158:
  pushl $0
80106ec9:	6a 00                	push   $0x0
  pushl $158
80106ecb:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106ed0:	e9 8e f2 ff ff       	jmp    80106163 <alltraps>

80106ed5 <vector159>:
.globl vector159
vector159:
  pushl $0
80106ed5:	6a 00                	push   $0x0
  pushl $159
80106ed7:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106edc:	e9 82 f2 ff ff       	jmp    80106163 <alltraps>

80106ee1 <vector160>:
.globl vector160
vector160:
  pushl $0
80106ee1:	6a 00                	push   $0x0
  pushl $160
80106ee3:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106ee8:	e9 76 f2 ff ff       	jmp    80106163 <alltraps>

80106eed <vector161>:
.globl vector161
vector161:
  pushl $0
80106eed:	6a 00                	push   $0x0
  pushl $161
80106eef:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106ef4:	e9 6a f2 ff ff       	jmp    80106163 <alltraps>

80106ef9 <vector162>:
.globl vector162
vector162:
  pushl $0
80106ef9:	6a 00                	push   $0x0
  pushl $162
80106efb:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106f00:	e9 5e f2 ff ff       	jmp    80106163 <alltraps>

80106f05 <vector163>:
.globl vector163
vector163:
  pushl $0
80106f05:	6a 00                	push   $0x0
  pushl $163
80106f07:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106f0c:	e9 52 f2 ff ff       	jmp    80106163 <alltraps>

80106f11 <vector164>:
.globl vector164
vector164:
  pushl $0
80106f11:	6a 00                	push   $0x0
  pushl $164
80106f13:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106f18:	e9 46 f2 ff ff       	jmp    80106163 <alltraps>

80106f1d <vector165>:
.globl vector165
vector165:
  pushl $0
80106f1d:	6a 00                	push   $0x0
  pushl $165
80106f1f:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106f24:	e9 3a f2 ff ff       	jmp    80106163 <alltraps>

80106f29 <vector166>:
.globl vector166
vector166:
  pushl $0
80106f29:	6a 00                	push   $0x0
  pushl $166
80106f2b:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106f30:	e9 2e f2 ff ff       	jmp    80106163 <alltraps>

80106f35 <vector167>:
.globl vector167
vector167:
  pushl $0
80106f35:	6a 00                	push   $0x0
  pushl $167
80106f37:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106f3c:	e9 22 f2 ff ff       	jmp    80106163 <alltraps>

80106f41 <vector168>:
.globl vector168
vector168:
  pushl $0
80106f41:	6a 00                	push   $0x0
  pushl $168
80106f43:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106f48:	e9 16 f2 ff ff       	jmp    80106163 <alltraps>

80106f4d <vector169>:
.globl vector169
vector169:
  pushl $0
80106f4d:	6a 00                	push   $0x0
  pushl $169
80106f4f:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106f54:	e9 0a f2 ff ff       	jmp    80106163 <alltraps>

80106f59 <vector170>:
.globl vector170
vector170:
  pushl $0
80106f59:	6a 00                	push   $0x0
  pushl $170
80106f5b:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106f60:	e9 fe f1 ff ff       	jmp    80106163 <alltraps>

80106f65 <vector171>:
.globl vector171
vector171:
  pushl $0
80106f65:	6a 00                	push   $0x0
  pushl $171
80106f67:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106f6c:	e9 f2 f1 ff ff       	jmp    80106163 <alltraps>

80106f71 <vector172>:
.globl vector172
vector172:
  pushl $0
80106f71:	6a 00                	push   $0x0
  pushl $172
80106f73:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106f78:	e9 e6 f1 ff ff       	jmp    80106163 <alltraps>

80106f7d <vector173>:
.globl vector173
vector173:
  pushl $0
80106f7d:	6a 00                	push   $0x0
  pushl $173
80106f7f:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106f84:	e9 da f1 ff ff       	jmp    80106163 <alltraps>

80106f89 <vector174>:
.globl vector174
vector174:
  pushl $0
80106f89:	6a 00                	push   $0x0
  pushl $174
80106f8b:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106f90:	e9 ce f1 ff ff       	jmp    80106163 <alltraps>

80106f95 <vector175>:
.globl vector175
vector175:
  pushl $0
80106f95:	6a 00                	push   $0x0
  pushl $175
80106f97:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106f9c:	e9 c2 f1 ff ff       	jmp    80106163 <alltraps>

80106fa1 <vector176>:
.globl vector176
vector176:
  pushl $0
80106fa1:	6a 00                	push   $0x0
  pushl $176
80106fa3:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106fa8:	e9 b6 f1 ff ff       	jmp    80106163 <alltraps>

80106fad <vector177>:
.globl vector177
vector177:
  pushl $0
80106fad:	6a 00                	push   $0x0
  pushl $177
80106faf:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106fb4:	e9 aa f1 ff ff       	jmp    80106163 <alltraps>

80106fb9 <vector178>:
.globl vector178
vector178:
  pushl $0
80106fb9:	6a 00                	push   $0x0
  pushl $178
80106fbb:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106fc0:	e9 9e f1 ff ff       	jmp    80106163 <alltraps>

80106fc5 <vector179>:
.globl vector179
vector179:
  pushl $0
80106fc5:	6a 00                	push   $0x0
  pushl $179
80106fc7:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106fcc:	e9 92 f1 ff ff       	jmp    80106163 <alltraps>

80106fd1 <vector180>:
.globl vector180
vector180:
  pushl $0
80106fd1:	6a 00                	push   $0x0
  pushl $180
80106fd3:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106fd8:	e9 86 f1 ff ff       	jmp    80106163 <alltraps>

80106fdd <vector181>:
.globl vector181
vector181:
  pushl $0
80106fdd:	6a 00                	push   $0x0
  pushl $181
80106fdf:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106fe4:	e9 7a f1 ff ff       	jmp    80106163 <alltraps>

80106fe9 <vector182>:
.globl vector182
vector182:
  pushl $0
80106fe9:	6a 00                	push   $0x0
  pushl $182
80106feb:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106ff0:	e9 6e f1 ff ff       	jmp    80106163 <alltraps>

80106ff5 <vector183>:
.globl vector183
vector183:
  pushl $0
80106ff5:	6a 00                	push   $0x0
  pushl $183
80106ff7:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106ffc:	e9 62 f1 ff ff       	jmp    80106163 <alltraps>

80107001 <vector184>:
.globl vector184
vector184:
  pushl $0
80107001:	6a 00                	push   $0x0
  pushl $184
80107003:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107008:	e9 56 f1 ff ff       	jmp    80106163 <alltraps>

8010700d <vector185>:
.globl vector185
vector185:
  pushl $0
8010700d:	6a 00                	push   $0x0
  pushl $185
8010700f:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107014:	e9 4a f1 ff ff       	jmp    80106163 <alltraps>

80107019 <vector186>:
.globl vector186
vector186:
  pushl $0
80107019:	6a 00                	push   $0x0
  pushl $186
8010701b:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107020:	e9 3e f1 ff ff       	jmp    80106163 <alltraps>

80107025 <vector187>:
.globl vector187
vector187:
  pushl $0
80107025:	6a 00                	push   $0x0
  pushl $187
80107027:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
8010702c:	e9 32 f1 ff ff       	jmp    80106163 <alltraps>

80107031 <vector188>:
.globl vector188
vector188:
  pushl $0
80107031:	6a 00                	push   $0x0
  pushl $188
80107033:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107038:	e9 26 f1 ff ff       	jmp    80106163 <alltraps>

8010703d <vector189>:
.globl vector189
vector189:
  pushl $0
8010703d:	6a 00                	push   $0x0
  pushl $189
8010703f:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107044:	e9 1a f1 ff ff       	jmp    80106163 <alltraps>

80107049 <vector190>:
.globl vector190
vector190:
  pushl $0
80107049:	6a 00                	push   $0x0
  pushl $190
8010704b:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107050:	e9 0e f1 ff ff       	jmp    80106163 <alltraps>

80107055 <vector191>:
.globl vector191
vector191:
  pushl $0
80107055:	6a 00                	push   $0x0
  pushl $191
80107057:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
8010705c:	e9 02 f1 ff ff       	jmp    80106163 <alltraps>

80107061 <vector192>:
.globl vector192
vector192:
  pushl $0
80107061:	6a 00                	push   $0x0
  pushl $192
80107063:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107068:	e9 f6 f0 ff ff       	jmp    80106163 <alltraps>

8010706d <vector193>:
.globl vector193
vector193:
  pushl $0
8010706d:	6a 00                	push   $0x0
  pushl $193
8010706f:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107074:	e9 ea f0 ff ff       	jmp    80106163 <alltraps>

80107079 <vector194>:
.globl vector194
vector194:
  pushl $0
80107079:	6a 00                	push   $0x0
  pushl $194
8010707b:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107080:	e9 de f0 ff ff       	jmp    80106163 <alltraps>

80107085 <vector195>:
.globl vector195
vector195:
  pushl $0
80107085:	6a 00                	push   $0x0
  pushl $195
80107087:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
8010708c:	e9 d2 f0 ff ff       	jmp    80106163 <alltraps>

80107091 <vector196>:
.globl vector196
vector196:
  pushl $0
80107091:	6a 00                	push   $0x0
  pushl $196
80107093:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107098:	e9 c6 f0 ff ff       	jmp    80106163 <alltraps>

8010709d <vector197>:
.globl vector197
vector197:
  pushl $0
8010709d:	6a 00                	push   $0x0
  pushl $197
8010709f:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801070a4:	e9 ba f0 ff ff       	jmp    80106163 <alltraps>

801070a9 <vector198>:
.globl vector198
vector198:
  pushl $0
801070a9:	6a 00                	push   $0x0
  pushl $198
801070ab:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801070b0:	e9 ae f0 ff ff       	jmp    80106163 <alltraps>

801070b5 <vector199>:
.globl vector199
vector199:
  pushl $0
801070b5:	6a 00                	push   $0x0
  pushl $199
801070b7:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801070bc:	e9 a2 f0 ff ff       	jmp    80106163 <alltraps>

801070c1 <vector200>:
.globl vector200
vector200:
  pushl $0
801070c1:	6a 00                	push   $0x0
  pushl $200
801070c3:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801070c8:	e9 96 f0 ff ff       	jmp    80106163 <alltraps>

801070cd <vector201>:
.globl vector201
vector201:
  pushl $0
801070cd:	6a 00                	push   $0x0
  pushl $201
801070cf:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801070d4:	e9 8a f0 ff ff       	jmp    80106163 <alltraps>

801070d9 <vector202>:
.globl vector202
vector202:
  pushl $0
801070d9:	6a 00                	push   $0x0
  pushl $202
801070db:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801070e0:	e9 7e f0 ff ff       	jmp    80106163 <alltraps>

801070e5 <vector203>:
.globl vector203
vector203:
  pushl $0
801070e5:	6a 00                	push   $0x0
  pushl $203
801070e7:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801070ec:	e9 72 f0 ff ff       	jmp    80106163 <alltraps>

801070f1 <vector204>:
.globl vector204
vector204:
  pushl $0
801070f1:	6a 00                	push   $0x0
  pushl $204
801070f3:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801070f8:	e9 66 f0 ff ff       	jmp    80106163 <alltraps>

801070fd <vector205>:
.globl vector205
vector205:
  pushl $0
801070fd:	6a 00                	push   $0x0
  pushl $205
801070ff:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107104:	e9 5a f0 ff ff       	jmp    80106163 <alltraps>

80107109 <vector206>:
.globl vector206
vector206:
  pushl $0
80107109:	6a 00                	push   $0x0
  pushl $206
8010710b:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107110:	e9 4e f0 ff ff       	jmp    80106163 <alltraps>

80107115 <vector207>:
.globl vector207
vector207:
  pushl $0
80107115:	6a 00                	push   $0x0
  pushl $207
80107117:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
8010711c:	e9 42 f0 ff ff       	jmp    80106163 <alltraps>

80107121 <vector208>:
.globl vector208
vector208:
  pushl $0
80107121:	6a 00                	push   $0x0
  pushl $208
80107123:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107128:	e9 36 f0 ff ff       	jmp    80106163 <alltraps>

8010712d <vector209>:
.globl vector209
vector209:
  pushl $0
8010712d:	6a 00                	push   $0x0
  pushl $209
8010712f:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107134:	e9 2a f0 ff ff       	jmp    80106163 <alltraps>

80107139 <vector210>:
.globl vector210
vector210:
  pushl $0
80107139:	6a 00                	push   $0x0
  pushl $210
8010713b:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107140:	e9 1e f0 ff ff       	jmp    80106163 <alltraps>

80107145 <vector211>:
.globl vector211
vector211:
  pushl $0
80107145:	6a 00                	push   $0x0
  pushl $211
80107147:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
8010714c:	e9 12 f0 ff ff       	jmp    80106163 <alltraps>

80107151 <vector212>:
.globl vector212
vector212:
  pushl $0
80107151:	6a 00                	push   $0x0
  pushl $212
80107153:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107158:	e9 06 f0 ff ff       	jmp    80106163 <alltraps>

8010715d <vector213>:
.globl vector213
vector213:
  pushl $0
8010715d:	6a 00                	push   $0x0
  pushl $213
8010715f:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107164:	e9 fa ef ff ff       	jmp    80106163 <alltraps>

80107169 <vector214>:
.globl vector214
vector214:
  pushl $0
80107169:	6a 00                	push   $0x0
  pushl $214
8010716b:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107170:	e9 ee ef ff ff       	jmp    80106163 <alltraps>

80107175 <vector215>:
.globl vector215
vector215:
  pushl $0
80107175:	6a 00                	push   $0x0
  pushl $215
80107177:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
8010717c:	e9 e2 ef ff ff       	jmp    80106163 <alltraps>

80107181 <vector216>:
.globl vector216
vector216:
  pushl $0
80107181:	6a 00                	push   $0x0
  pushl $216
80107183:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107188:	e9 d6 ef ff ff       	jmp    80106163 <alltraps>

8010718d <vector217>:
.globl vector217
vector217:
  pushl $0
8010718d:	6a 00                	push   $0x0
  pushl $217
8010718f:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107194:	e9 ca ef ff ff       	jmp    80106163 <alltraps>

80107199 <vector218>:
.globl vector218
vector218:
  pushl $0
80107199:	6a 00                	push   $0x0
  pushl $218
8010719b:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801071a0:	e9 be ef ff ff       	jmp    80106163 <alltraps>

801071a5 <vector219>:
.globl vector219
vector219:
  pushl $0
801071a5:	6a 00                	push   $0x0
  pushl $219
801071a7:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801071ac:	e9 b2 ef ff ff       	jmp    80106163 <alltraps>

801071b1 <vector220>:
.globl vector220
vector220:
  pushl $0
801071b1:	6a 00                	push   $0x0
  pushl $220
801071b3:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801071b8:	e9 a6 ef ff ff       	jmp    80106163 <alltraps>

801071bd <vector221>:
.globl vector221
vector221:
  pushl $0
801071bd:	6a 00                	push   $0x0
  pushl $221
801071bf:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801071c4:	e9 9a ef ff ff       	jmp    80106163 <alltraps>

801071c9 <vector222>:
.globl vector222
vector222:
  pushl $0
801071c9:	6a 00                	push   $0x0
  pushl $222
801071cb:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801071d0:	e9 8e ef ff ff       	jmp    80106163 <alltraps>

801071d5 <vector223>:
.globl vector223
vector223:
  pushl $0
801071d5:	6a 00                	push   $0x0
  pushl $223
801071d7:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801071dc:	e9 82 ef ff ff       	jmp    80106163 <alltraps>

801071e1 <vector224>:
.globl vector224
vector224:
  pushl $0
801071e1:	6a 00                	push   $0x0
  pushl $224
801071e3:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801071e8:	e9 76 ef ff ff       	jmp    80106163 <alltraps>

801071ed <vector225>:
.globl vector225
vector225:
  pushl $0
801071ed:	6a 00                	push   $0x0
  pushl $225
801071ef:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801071f4:	e9 6a ef ff ff       	jmp    80106163 <alltraps>

801071f9 <vector226>:
.globl vector226
vector226:
  pushl $0
801071f9:	6a 00                	push   $0x0
  pushl $226
801071fb:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107200:	e9 5e ef ff ff       	jmp    80106163 <alltraps>

80107205 <vector227>:
.globl vector227
vector227:
  pushl $0
80107205:	6a 00                	push   $0x0
  pushl $227
80107207:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
8010720c:	e9 52 ef ff ff       	jmp    80106163 <alltraps>

80107211 <vector228>:
.globl vector228
vector228:
  pushl $0
80107211:	6a 00                	push   $0x0
  pushl $228
80107213:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107218:	e9 46 ef ff ff       	jmp    80106163 <alltraps>

8010721d <vector229>:
.globl vector229
vector229:
  pushl $0
8010721d:	6a 00                	push   $0x0
  pushl $229
8010721f:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107224:	e9 3a ef ff ff       	jmp    80106163 <alltraps>

80107229 <vector230>:
.globl vector230
vector230:
  pushl $0
80107229:	6a 00                	push   $0x0
  pushl $230
8010722b:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107230:	e9 2e ef ff ff       	jmp    80106163 <alltraps>

80107235 <vector231>:
.globl vector231
vector231:
  pushl $0
80107235:	6a 00                	push   $0x0
  pushl $231
80107237:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
8010723c:	e9 22 ef ff ff       	jmp    80106163 <alltraps>

80107241 <vector232>:
.globl vector232
vector232:
  pushl $0
80107241:	6a 00                	push   $0x0
  pushl $232
80107243:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107248:	e9 16 ef ff ff       	jmp    80106163 <alltraps>

8010724d <vector233>:
.globl vector233
vector233:
  pushl $0
8010724d:	6a 00                	push   $0x0
  pushl $233
8010724f:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107254:	e9 0a ef ff ff       	jmp    80106163 <alltraps>

80107259 <vector234>:
.globl vector234
vector234:
  pushl $0
80107259:	6a 00                	push   $0x0
  pushl $234
8010725b:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107260:	e9 fe ee ff ff       	jmp    80106163 <alltraps>

80107265 <vector235>:
.globl vector235
vector235:
  pushl $0
80107265:	6a 00                	push   $0x0
  pushl $235
80107267:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
8010726c:	e9 f2 ee ff ff       	jmp    80106163 <alltraps>

80107271 <vector236>:
.globl vector236
vector236:
  pushl $0
80107271:	6a 00                	push   $0x0
  pushl $236
80107273:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107278:	e9 e6 ee ff ff       	jmp    80106163 <alltraps>

8010727d <vector237>:
.globl vector237
vector237:
  pushl $0
8010727d:	6a 00                	push   $0x0
  pushl $237
8010727f:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107284:	e9 da ee ff ff       	jmp    80106163 <alltraps>

80107289 <vector238>:
.globl vector238
vector238:
  pushl $0
80107289:	6a 00                	push   $0x0
  pushl $238
8010728b:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107290:	e9 ce ee ff ff       	jmp    80106163 <alltraps>

80107295 <vector239>:
.globl vector239
vector239:
  pushl $0
80107295:	6a 00                	push   $0x0
  pushl $239
80107297:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
8010729c:	e9 c2 ee ff ff       	jmp    80106163 <alltraps>

801072a1 <vector240>:
.globl vector240
vector240:
  pushl $0
801072a1:	6a 00                	push   $0x0
  pushl $240
801072a3:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801072a8:	e9 b6 ee ff ff       	jmp    80106163 <alltraps>

801072ad <vector241>:
.globl vector241
vector241:
  pushl $0
801072ad:	6a 00                	push   $0x0
  pushl $241
801072af:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801072b4:	e9 aa ee ff ff       	jmp    80106163 <alltraps>

801072b9 <vector242>:
.globl vector242
vector242:
  pushl $0
801072b9:	6a 00                	push   $0x0
  pushl $242
801072bb:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801072c0:	e9 9e ee ff ff       	jmp    80106163 <alltraps>

801072c5 <vector243>:
.globl vector243
vector243:
  pushl $0
801072c5:	6a 00                	push   $0x0
  pushl $243
801072c7:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801072cc:	e9 92 ee ff ff       	jmp    80106163 <alltraps>

801072d1 <vector244>:
.globl vector244
vector244:
  pushl $0
801072d1:	6a 00                	push   $0x0
  pushl $244
801072d3:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801072d8:	e9 86 ee ff ff       	jmp    80106163 <alltraps>

801072dd <vector245>:
.globl vector245
vector245:
  pushl $0
801072dd:	6a 00                	push   $0x0
  pushl $245
801072df:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801072e4:	e9 7a ee ff ff       	jmp    80106163 <alltraps>

801072e9 <vector246>:
.globl vector246
vector246:
  pushl $0
801072e9:	6a 00                	push   $0x0
  pushl $246
801072eb:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801072f0:	e9 6e ee ff ff       	jmp    80106163 <alltraps>

801072f5 <vector247>:
.globl vector247
vector247:
  pushl $0
801072f5:	6a 00                	push   $0x0
  pushl $247
801072f7:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801072fc:	e9 62 ee ff ff       	jmp    80106163 <alltraps>

80107301 <vector248>:
.globl vector248
vector248:
  pushl $0
80107301:	6a 00                	push   $0x0
  pushl $248
80107303:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107308:	e9 56 ee ff ff       	jmp    80106163 <alltraps>

8010730d <vector249>:
.globl vector249
vector249:
  pushl $0
8010730d:	6a 00                	push   $0x0
  pushl $249
8010730f:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107314:	e9 4a ee ff ff       	jmp    80106163 <alltraps>

80107319 <vector250>:
.globl vector250
vector250:
  pushl $0
80107319:	6a 00                	push   $0x0
  pushl $250
8010731b:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107320:	e9 3e ee ff ff       	jmp    80106163 <alltraps>

80107325 <vector251>:
.globl vector251
vector251:
  pushl $0
80107325:	6a 00                	push   $0x0
  pushl $251
80107327:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
8010732c:	e9 32 ee ff ff       	jmp    80106163 <alltraps>

80107331 <vector252>:
.globl vector252
vector252:
  pushl $0
80107331:	6a 00                	push   $0x0
  pushl $252
80107333:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107338:	e9 26 ee ff ff       	jmp    80106163 <alltraps>

8010733d <vector253>:
.globl vector253
vector253:
  pushl $0
8010733d:	6a 00                	push   $0x0
  pushl $253
8010733f:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107344:	e9 1a ee ff ff       	jmp    80106163 <alltraps>

80107349 <vector254>:
.globl vector254
vector254:
  pushl $0
80107349:	6a 00                	push   $0x0
  pushl $254
8010734b:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107350:	e9 0e ee ff ff       	jmp    80106163 <alltraps>

80107355 <vector255>:
.globl vector255
vector255:
  pushl $0
80107355:	6a 00                	push   $0x0
  pushl $255
80107357:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
8010735c:	e9 02 ee ff ff       	jmp    80106163 <alltraps>

80107361 <lgdt>:
{
80107361:	55                   	push   %ebp
80107362:	89 e5                	mov    %esp,%ebp
80107364:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80107367:	8b 45 0c             	mov    0xc(%ebp),%eax
8010736a:	83 e8 01             	sub    $0x1,%eax
8010736d:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107371:	8b 45 08             	mov    0x8(%ebp),%eax
80107374:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107378:	8b 45 08             	mov    0x8(%ebp),%eax
8010737b:	c1 e8 10             	shr    $0x10,%eax
8010737e:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107382:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107385:	0f 01 10             	lgdtl  (%eax)
}
80107388:	90                   	nop
80107389:	c9                   	leave  
8010738a:	c3                   	ret    

8010738b <ltr>:
{
8010738b:	55                   	push   %ebp
8010738c:	89 e5                	mov    %esp,%ebp
8010738e:	83 ec 04             	sub    $0x4,%esp
80107391:	8b 45 08             	mov    0x8(%ebp),%eax
80107394:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107398:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010739c:	0f 00 d8             	ltr    %ax
}
8010739f:	90                   	nop
801073a0:	c9                   	leave  
801073a1:	c3                   	ret    

801073a2 <lcr3>:
{
801073a2:	55                   	push   %ebp
801073a3:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
801073a5:	8b 45 08             	mov    0x8(%ebp),%eax
801073a8:	0f 22 d8             	mov    %eax,%cr3
}
801073ab:	90                   	nop
801073ac:	5d                   	pop    %ebp
801073ad:	c3                   	ret    

801073ae <seginit>:
extern struct gpu gpu;
// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801073ae:	f3 0f 1e fb          	endbr32 
801073b2:	55                   	push   %ebp
801073b3:	89 e5                	mov    %esp,%ebp
801073b5:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
801073b8:	e8 51 c7 ff ff       	call   80103b0e <cpuid>
801073bd:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801073c3:	05 c0 7c 19 80       	add    $0x80197cc0,%eax
801073c8:	89 45 f4             	mov    %eax,-0xc(%ebp)

  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801073cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073ce:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
801073d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073d7:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
801073dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073e0:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
801073e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073e7:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801073eb:	83 e2 f0             	and    $0xfffffff0,%edx
801073ee:	83 ca 0a             	or     $0xa,%edx
801073f1:	88 50 7d             	mov    %dl,0x7d(%eax)
801073f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073f7:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801073fb:	83 ca 10             	or     $0x10,%edx
801073fe:	88 50 7d             	mov    %dl,0x7d(%eax)
80107401:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107404:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107408:	83 e2 9f             	and    $0xffffff9f,%edx
8010740b:	88 50 7d             	mov    %dl,0x7d(%eax)
8010740e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107411:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107415:	83 ca 80             	or     $0xffffff80,%edx
80107418:	88 50 7d             	mov    %dl,0x7d(%eax)
8010741b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010741e:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107422:	83 ca 0f             	or     $0xf,%edx
80107425:	88 50 7e             	mov    %dl,0x7e(%eax)
80107428:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010742b:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010742f:	83 e2 ef             	and    $0xffffffef,%edx
80107432:	88 50 7e             	mov    %dl,0x7e(%eax)
80107435:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107438:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010743c:	83 e2 df             	and    $0xffffffdf,%edx
8010743f:	88 50 7e             	mov    %dl,0x7e(%eax)
80107442:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107445:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107449:	83 ca 40             	or     $0x40,%edx
8010744c:	88 50 7e             	mov    %dl,0x7e(%eax)
8010744f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107452:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107456:	83 ca 80             	or     $0xffffff80,%edx
80107459:	88 50 7e             	mov    %dl,0x7e(%eax)
8010745c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010745f:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107463:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107466:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
8010746d:	ff ff 
8010746f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107472:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107479:	00 00 
8010747b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010747e:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107485:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107488:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010748f:	83 e2 f0             	and    $0xfffffff0,%edx
80107492:	83 ca 02             	or     $0x2,%edx
80107495:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010749b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010749e:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801074a5:	83 ca 10             	or     $0x10,%edx
801074a8:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801074ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074b1:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801074b8:	83 e2 9f             	and    $0xffffff9f,%edx
801074bb:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801074c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074c4:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801074cb:	83 ca 80             	or     $0xffffff80,%edx
801074ce:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801074d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074d7:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801074de:	83 ca 0f             	or     $0xf,%edx
801074e1:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801074e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074ea:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801074f1:	83 e2 ef             	and    $0xffffffef,%edx
801074f4:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801074fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074fd:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107504:	83 e2 df             	and    $0xffffffdf,%edx
80107507:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010750d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107510:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107517:	83 ca 40             	or     $0x40,%edx
8010751a:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107520:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107523:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010752a:	83 ca 80             	or     $0xffffff80,%edx
8010752d:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107533:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107536:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010753d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107540:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
80107547:	ff ff 
80107549:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010754c:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
80107553:	00 00 
80107555:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107558:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
8010755f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107562:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107569:	83 e2 f0             	and    $0xfffffff0,%edx
8010756c:	83 ca 0a             	or     $0xa,%edx
8010756f:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107575:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107578:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010757f:	83 ca 10             	or     $0x10,%edx
80107582:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107588:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010758b:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107592:	83 ca 60             	or     $0x60,%edx
80107595:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010759b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010759e:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801075a5:	83 ca 80             	or     $0xffffff80,%edx
801075a8:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801075ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075b1:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801075b8:	83 ca 0f             	or     $0xf,%edx
801075bb:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801075c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075c4:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801075cb:	83 e2 ef             	and    $0xffffffef,%edx
801075ce:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801075d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075d7:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801075de:	83 e2 df             	and    $0xffffffdf,%edx
801075e1:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801075e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075ea:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801075f1:	83 ca 40             	or     $0x40,%edx
801075f4:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801075fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075fd:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107604:	83 ca 80             	or     $0xffffff80,%edx
80107607:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010760d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107610:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107617:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010761a:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107621:	ff ff 
80107623:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107626:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
8010762d:	00 00 
8010762f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107632:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107639:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010763c:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107643:	83 e2 f0             	and    $0xfffffff0,%edx
80107646:	83 ca 02             	or     $0x2,%edx
80107649:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010764f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107652:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107659:	83 ca 10             	or     $0x10,%edx
8010765c:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107662:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107665:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010766c:	83 ca 60             	or     $0x60,%edx
8010766f:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107675:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107678:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010767f:	83 ca 80             	or     $0xffffff80,%edx
80107682:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107688:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010768b:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107692:	83 ca 0f             	or     $0xf,%edx
80107695:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010769b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010769e:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801076a5:	83 e2 ef             	and    $0xffffffef,%edx
801076a8:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801076ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076b1:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801076b8:	83 e2 df             	and    $0xffffffdf,%edx
801076bb:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801076c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076c4:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801076cb:	83 ca 40             	or     $0x40,%edx
801076ce:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801076d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076d7:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801076de:	83 ca 80             	or     $0xffffff80,%edx
801076e1:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801076e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076ea:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
801076f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076f4:	83 c0 70             	add    $0x70,%eax
801076f7:	83 ec 08             	sub    $0x8,%esp
801076fa:	6a 30                	push   $0x30
801076fc:	50                   	push   %eax
801076fd:	e8 5f fc ff ff       	call   80107361 <lgdt>
80107702:	83 c4 10             	add    $0x10,%esp
}
80107705:	90                   	nop
80107706:	c9                   	leave  
80107707:	c3                   	ret    

80107708 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107708:	f3 0f 1e fb          	endbr32 
8010770c:	55                   	push   %ebp
8010770d:	89 e5                	mov    %esp,%ebp
8010770f:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107712:	8b 45 0c             	mov    0xc(%ebp),%eax
80107715:	c1 e8 16             	shr    $0x16,%eax
80107718:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010771f:	8b 45 08             	mov    0x8(%ebp),%eax
80107722:	01 d0                	add    %edx,%eax
80107724:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107727:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010772a:	8b 00                	mov    (%eax),%eax
8010772c:	83 e0 01             	and    $0x1,%eax
8010772f:	85 c0                	test   %eax,%eax
80107731:	74 14                	je     80107747 <walkpgdir+0x3f>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107733:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107736:	8b 00                	mov    (%eax),%eax
80107738:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010773d:	05 00 00 00 80       	add    $0x80000000,%eax
80107742:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107745:	eb 42                	jmp    80107789 <walkpgdir+0x81>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107747:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010774b:	74 0e                	je     8010775b <walkpgdir+0x53>
8010774d:	e8 40 b1 ff ff       	call   80102892 <kalloc>
80107752:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107755:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107759:	75 07                	jne    80107762 <walkpgdir+0x5a>
      return 0;
8010775b:	b8 00 00 00 00       	mov    $0x0,%eax
80107760:	eb 3e                	jmp    801077a0 <walkpgdir+0x98>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107762:	83 ec 04             	sub    $0x4,%esp
80107765:	68 00 10 00 00       	push   $0x1000
8010776a:	6a 00                	push   $0x0
8010776c:	ff 75 f4             	pushl  -0xc(%ebp)
8010776f:	e8 63 d5 ff ff       	call   80104cd7 <memset>
80107774:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107777:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010777a:	05 00 00 00 80       	add    $0x80000000,%eax
8010777f:	83 c8 07             	or     $0x7,%eax
80107782:	89 c2                	mov    %eax,%edx
80107784:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107787:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107789:	8b 45 0c             	mov    0xc(%ebp),%eax
8010778c:	c1 e8 0c             	shr    $0xc,%eax
8010778f:	25 ff 03 00 00       	and    $0x3ff,%eax
80107794:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010779b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010779e:	01 d0                	add    %edx,%eax
}
801077a0:	c9                   	leave  
801077a1:	c3                   	ret    

801077a2 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801077a2:	f3 0f 1e fb          	endbr32 
801077a6:	55                   	push   %ebp
801077a7:	89 e5                	mov    %esp,%ebp
801077a9:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801077ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801077af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801077b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801077b7:	8b 55 0c             	mov    0xc(%ebp),%edx
801077ba:	8b 45 10             	mov    0x10(%ebp),%eax
801077bd:	01 d0                	add    %edx,%eax
801077bf:	83 e8 01             	sub    $0x1,%eax
801077c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801077c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801077ca:	83 ec 04             	sub    $0x4,%esp
801077cd:	6a 01                	push   $0x1
801077cf:	ff 75 f4             	pushl  -0xc(%ebp)
801077d2:	ff 75 08             	pushl  0x8(%ebp)
801077d5:	e8 2e ff ff ff       	call   80107708 <walkpgdir>
801077da:	83 c4 10             	add    $0x10,%esp
801077dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
801077e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801077e4:	75 07                	jne    801077ed <mappages+0x4b>
      return -1;
801077e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801077eb:	eb 47                	jmp    80107834 <mappages+0x92>
    if(*pte & PTE_P)
801077ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
801077f0:	8b 00                	mov    (%eax),%eax
801077f2:	83 e0 01             	and    $0x1,%eax
801077f5:	85 c0                	test   %eax,%eax
801077f7:	74 0d                	je     80107806 <mappages+0x64>
      panic("remap");
801077f9:	83 ec 0c             	sub    $0xc,%esp
801077fc:	68 a8 ac 10 80       	push   $0x8010aca8
80107801:	e8 bf 8d ff ff       	call   801005c5 <panic>
    *pte = pa | perm | PTE_P;
80107806:	8b 45 18             	mov    0x18(%ebp),%eax
80107809:	0b 45 14             	or     0x14(%ebp),%eax
8010780c:	83 c8 01             	or     $0x1,%eax
8010780f:	89 c2                	mov    %eax,%edx
80107811:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107814:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107816:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107819:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010781c:	74 10                	je     8010782e <mappages+0x8c>
      break;
    a += PGSIZE;
8010781e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107825:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010782c:	eb 9c                	jmp    801077ca <mappages+0x28>
      break;
8010782e:	90                   	nop
  }
  return 0;
8010782f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107834:	c9                   	leave  
80107835:	c3                   	ret    

80107836 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107836:	f3 0f 1e fb          	endbr32 
8010783a:	55                   	push   %ebp
8010783b:	89 e5                	mov    %esp,%ebp
8010783d:	53                   	push   %ebx
8010783e:	83 ec 24             	sub    $0x24,%esp
  pde_t *pgdir;
  struct kmap *k;
  k = kmap;
80107841:	c7 45 f4 80 f4 10 80 	movl   $0x8010f480,-0xc(%ebp)
  struct kmap vram = { (void*)(DEVSPACE - gpu.vram_size),gpu.pvram_addr,gpu.pvram_addr+gpu.vram_size, PTE_W};
80107848:	a1 8c 7f 19 80       	mov    0x80197f8c,%eax
8010784d:	ba 00 00 00 fe       	mov    $0xfe000000,%edx
80107852:	29 c2                	sub    %eax,%edx
80107854:	89 d0                	mov    %edx,%eax
80107856:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107859:	a1 84 7f 19 80       	mov    0x80197f84,%eax
8010785e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107861:	8b 15 84 7f 19 80    	mov    0x80197f84,%edx
80107867:	a1 8c 7f 19 80       	mov    0x80197f8c,%eax
8010786c:	01 d0                	add    %edx,%eax
8010786e:	89 45 e8             	mov    %eax,-0x18(%ebp)
80107871:	c7 45 ec 02 00 00 00 	movl   $0x2,-0x14(%ebp)
  k[3] = vram;
80107878:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010787b:	83 c0 30             	add    $0x30,%eax
8010787e:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107881:	89 10                	mov    %edx,(%eax)
80107883:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107886:	89 50 04             	mov    %edx,0x4(%eax)
80107889:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010788c:	89 50 08             	mov    %edx,0x8(%eax)
8010788f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80107892:	89 50 0c             	mov    %edx,0xc(%eax)
  if((pgdir = (pde_t*)kalloc()) == 0){
80107895:	e8 f8 af ff ff       	call   80102892 <kalloc>
8010789a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010789d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801078a1:	75 07                	jne    801078aa <setupkvm+0x74>
    return 0;
801078a3:	b8 00 00 00 00       	mov    $0x0,%eax
801078a8:	eb 78                	jmp    80107922 <setupkvm+0xec>
  }
  memset(pgdir, 0, PGSIZE);
801078aa:	83 ec 04             	sub    $0x4,%esp
801078ad:	68 00 10 00 00       	push   $0x1000
801078b2:	6a 00                	push   $0x0
801078b4:	ff 75 f0             	pushl  -0x10(%ebp)
801078b7:	e8 1b d4 ff ff       	call   80104cd7 <memset>
801078bc:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801078bf:	c7 45 f4 80 f4 10 80 	movl   $0x8010f480,-0xc(%ebp)
801078c6:	eb 4e                	jmp    80107916 <setupkvm+0xe0>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801078c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078cb:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0) {
801078ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078d1:	8b 50 04             	mov    0x4(%eax),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801078d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078d7:	8b 58 08             	mov    0x8(%eax),%ebx
801078da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078dd:	8b 40 04             	mov    0x4(%eax),%eax
801078e0:	29 c3                	sub    %eax,%ebx
801078e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078e5:	8b 00                	mov    (%eax),%eax
801078e7:	83 ec 0c             	sub    $0xc,%esp
801078ea:	51                   	push   %ecx
801078eb:	52                   	push   %edx
801078ec:	53                   	push   %ebx
801078ed:	50                   	push   %eax
801078ee:	ff 75 f0             	pushl  -0x10(%ebp)
801078f1:	e8 ac fe ff ff       	call   801077a2 <mappages>
801078f6:	83 c4 20             	add    $0x20,%esp
801078f9:	85 c0                	test   %eax,%eax
801078fb:	79 15                	jns    80107912 <setupkvm+0xdc>
      freevm(pgdir);
801078fd:	83 ec 0c             	sub    $0xc,%esp
80107900:	ff 75 f0             	pushl  -0x10(%ebp)
80107903:	e8 11 05 00 00       	call   80107e19 <freevm>
80107908:	83 c4 10             	add    $0x10,%esp
      return 0;
8010790b:	b8 00 00 00 00       	mov    $0x0,%eax
80107910:	eb 10                	jmp    80107922 <setupkvm+0xec>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107912:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107916:	81 7d f4 e0 f4 10 80 	cmpl   $0x8010f4e0,-0xc(%ebp)
8010791d:	72 a9                	jb     801078c8 <setupkvm+0x92>
    }
  return pgdir;
8010791f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107922:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107925:	c9                   	leave  
80107926:	c3                   	ret    

80107927 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107927:	f3 0f 1e fb          	endbr32 
8010792b:	55                   	push   %ebp
8010792c:	89 e5                	mov    %esp,%ebp
8010792e:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107931:	e8 00 ff ff ff       	call   80107836 <setupkvm>
80107936:	a3 84 7c 19 80       	mov    %eax,0x80197c84
  switchkvm();
8010793b:	e8 03 00 00 00       	call   80107943 <switchkvm>
}
80107940:	90                   	nop
80107941:	c9                   	leave  
80107942:	c3                   	ret    

80107943 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107943:	f3 0f 1e fb          	endbr32 
80107947:	55                   	push   %ebp
80107948:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
8010794a:	a1 84 7c 19 80       	mov    0x80197c84,%eax
8010794f:	05 00 00 00 80       	add    $0x80000000,%eax
80107954:	50                   	push   %eax
80107955:	e8 48 fa ff ff       	call   801073a2 <lcr3>
8010795a:	83 c4 04             	add    $0x4,%esp
}
8010795d:	90                   	nop
8010795e:	c9                   	leave  
8010795f:	c3                   	ret    

80107960 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107960:	f3 0f 1e fb          	endbr32 
80107964:	55                   	push   %ebp
80107965:	89 e5                	mov    %esp,%ebp
80107967:	56                   	push   %esi
80107968:	53                   	push   %ebx
80107969:	83 ec 10             	sub    $0x10,%esp
  if(p == 0)
8010796c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107970:	75 0d                	jne    8010797f <switchuvm+0x1f>
    panic("switchuvm: no process");
80107972:	83 ec 0c             	sub    $0xc,%esp
80107975:	68 ae ac 10 80       	push   $0x8010acae
8010797a:	e8 46 8c ff ff       	call   801005c5 <panic>
  if(p->kstack == 0)
8010797f:	8b 45 08             	mov    0x8(%ebp),%eax
80107982:	8b 40 08             	mov    0x8(%eax),%eax
80107985:	85 c0                	test   %eax,%eax
80107987:	75 0d                	jne    80107996 <switchuvm+0x36>
    panic("switchuvm: no kstack");
80107989:	83 ec 0c             	sub    $0xc,%esp
8010798c:	68 c4 ac 10 80       	push   $0x8010acc4
80107991:	e8 2f 8c ff ff       	call   801005c5 <panic>
  if(p->pgdir == 0)
80107996:	8b 45 08             	mov    0x8(%ebp),%eax
80107999:	8b 40 04             	mov    0x4(%eax),%eax
8010799c:	85 c0                	test   %eax,%eax
8010799e:	75 0d                	jne    801079ad <switchuvm+0x4d>
    panic("switchuvm: no pgdir");
801079a0:	83 ec 0c             	sub    $0xc,%esp
801079a3:	68 d9 ac 10 80       	push   $0x8010acd9
801079a8:	e8 18 8c ff ff       	call   801005c5 <panic>

  pushcli();
801079ad:	e8 12 d2 ff ff       	call   80104bc4 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801079b2:	e8 76 c1 ff ff       	call   80103b2d <mycpu>
801079b7:	89 c3                	mov    %eax,%ebx
801079b9:	e8 6f c1 ff ff       	call   80103b2d <mycpu>
801079be:	83 c0 08             	add    $0x8,%eax
801079c1:	89 c6                	mov    %eax,%esi
801079c3:	e8 65 c1 ff ff       	call   80103b2d <mycpu>
801079c8:	83 c0 08             	add    $0x8,%eax
801079cb:	c1 e8 10             	shr    $0x10,%eax
801079ce:	88 45 f7             	mov    %al,-0x9(%ebp)
801079d1:	e8 57 c1 ff ff       	call   80103b2d <mycpu>
801079d6:	83 c0 08             	add    $0x8,%eax
801079d9:	c1 e8 18             	shr    $0x18,%eax
801079dc:	89 c2                	mov    %eax,%edx
801079de:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
801079e5:	67 00 
801079e7:	66 89 b3 9a 00 00 00 	mov    %si,0x9a(%ebx)
801079ee:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
801079f2:	88 83 9c 00 00 00    	mov    %al,0x9c(%ebx)
801079f8:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
801079ff:	83 e0 f0             	and    $0xfffffff0,%eax
80107a02:	83 c8 09             	or     $0x9,%eax
80107a05:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107a0b:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107a12:	83 c8 10             	or     $0x10,%eax
80107a15:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107a1b:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107a22:	83 e0 9f             	and    $0xffffff9f,%eax
80107a25:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107a2b:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107a32:	83 c8 80             	or     $0xffffff80,%eax
80107a35:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107a3b:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107a42:	83 e0 f0             	and    $0xfffffff0,%eax
80107a45:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107a4b:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107a52:	83 e0 ef             	and    $0xffffffef,%eax
80107a55:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107a5b:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107a62:	83 e0 df             	and    $0xffffffdf,%eax
80107a65:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107a6b:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107a72:	83 c8 40             	or     $0x40,%eax
80107a75:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107a7b:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107a82:	83 e0 7f             	and    $0x7f,%eax
80107a85:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107a8b:	88 93 9f 00 00 00    	mov    %dl,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80107a91:	e8 97 c0 ff ff       	call   80103b2d <mycpu>
80107a96:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107a9d:	83 e2 ef             	and    $0xffffffef,%edx
80107aa0:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107aa6:	e8 82 c0 ff ff       	call   80103b2d <mycpu>
80107aab:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107ab1:	8b 45 08             	mov    0x8(%ebp),%eax
80107ab4:	8b 40 08             	mov    0x8(%eax),%eax
80107ab7:	89 c3                	mov    %eax,%ebx
80107ab9:	e8 6f c0 ff ff       	call   80103b2d <mycpu>
80107abe:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
80107ac4:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107ac7:	e8 61 c0 ff ff       	call   80103b2d <mycpu>
80107acc:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
80107ad2:	83 ec 0c             	sub    $0xc,%esp
80107ad5:	6a 28                	push   $0x28
80107ad7:	e8 af f8 ff ff       	call   8010738b <ltr>
80107adc:	83 c4 10             	add    $0x10,%esp
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107adf:	8b 45 08             	mov    0x8(%ebp),%eax
80107ae2:	8b 40 04             	mov    0x4(%eax),%eax
80107ae5:	05 00 00 00 80       	add    $0x80000000,%eax
80107aea:	83 ec 0c             	sub    $0xc,%esp
80107aed:	50                   	push   %eax
80107aee:	e8 af f8 ff ff       	call   801073a2 <lcr3>
80107af3:	83 c4 10             	add    $0x10,%esp
  popcli();
80107af6:	e8 1a d1 ff ff       	call   80104c15 <popcli>
}
80107afb:	90                   	nop
80107afc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107aff:	5b                   	pop    %ebx
80107b00:	5e                   	pop    %esi
80107b01:	5d                   	pop    %ebp
80107b02:	c3                   	ret    

80107b03 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107b03:	f3 0f 1e fb          	endbr32 
80107b07:	55                   	push   %ebp
80107b08:	89 e5                	mov    %esp,%ebp
80107b0a:	83 ec 18             	sub    $0x18,%esp
  char *mem;

  if(sz >= PGSIZE)
80107b0d:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107b14:	76 0d                	jbe    80107b23 <inituvm+0x20>
    panic("inituvm: more than a page");
80107b16:	83 ec 0c             	sub    $0xc,%esp
80107b19:	68 ed ac 10 80       	push   $0x8010aced
80107b1e:	e8 a2 8a ff ff       	call   801005c5 <panic>
  mem = kalloc();
80107b23:	e8 6a ad ff ff       	call   80102892 <kalloc>
80107b28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107b2b:	83 ec 04             	sub    $0x4,%esp
80107b2e:	68 00 10 00 00       	push   $0x1000
80107b33:	6a 00                	push   $0x0
80107b35:	ff 75 f4             	pushl  -0xc(%ebp)
80107b38:	e8 9a d1 ff ff       	call   80104cd7 <memset>
80107b3d:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b43:	05 00 00 00 80       	add    $0x80000000,%eax
80107b48:	83 ec 0c             	sub    $0xc,%esp
80107b4b:	6a 06                	push   $0x6
80107b4d:	50                   	push   %eax
80107b4e:	68 00 10 00 00       	push   $0x1000
80107b53:	6a 00                	push   $0x0
80107b55:	ff 75 08             	pushl  0x8(%ebp)
80107b58:	e8 45 fc ff ff       	call   801077a2 <mappages>
80107b5d:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80107b60:	83 ec 04             	sub    $0x4,%esp
80107b63:	ff 75 10             	pushl  0x10(%ebp)
80107b66:	ff 75 0c             	pushl  0xc(%ebp)
80107b69:	ff 75 f4             	pushl  -0xc(%ebp)
80107b6c:	e8 2d d2 ff ff       	call   80104d9e <memmove>
80107b71:	83 c4 10             	add    $0x10,%esp
}
80107b74:	90                   	nop
80107b75:	c9                   	leave  
80107b76:	c3                   	ret    

80107b77 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107b77:	f3 0f 1e fb          	endbr32 
80107b7b:	55                   	push   %ebp
80107b7c:	89 e5                	mov    %esp,%ebp
80107b7e:	83 ec 18             	sub    $0x18,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107b81:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b84:	25 ff 0f 00 00       	and    $0xfff,%eax
80107b89:	85 c0                	test   %eax,%eax
80107b8b:	74 0d                	je     80107b9a <loaduvm+0x23>
    panic("loaduvm: addr must be page aligned");
80107b8d:	83 ec 0c             	sub    $0xc,%esp
80107b90:	68 08 ad 10 80       	push   $0x8010ad08
80107b95:	e8 2b 8a ff ff       	call   801005c5 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107b9a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107ba1:	e9 8f 00 00 00       	jmp    80107c35 <loaduvm+0xbe>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107ba6:	8b 55 0c             	mov    0xc(%ebp),%edx
80107ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bac:	01 d0                	add    %edx,%eax
80107bae:	83 ec 04             	sub    $0x4,%esp
80107bb1:	6a 00                	push   $0x0
80107bb3:	50                   	push   %eax
80107bb4:	ff 75 08             	pushl  0x8(%ebp)
80107bb7:	e8 4c fb ff ff       	call   80107708 <walkpgdir>
80107bbc:	83 c4 10             	add    $0x10,%esp
80107bbf:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107bc2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107bc6:	75 0d                	jne    80107bd5 <loaduvm+0x5e>
      panic("loaduvm: address should exist");
80107bc8:	83 ec 0c             	sub    $0xc,%esp
80107bcb:	68 2b ad 10 80       	push   $0x8010ad2b
80107bd0:	e8 f0 89 ff ff       	call   801005c5 <panic>
    pa = PTE_ADDR(*pte);
80107bd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107bd8:	8b 00                	mov    (%eax),%eax
80107bda:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107bdf:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80107be2:	8b 45 18             	mov    0x18(%ebp),%eax
80107be5:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107be8:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107bed:	77 0b                	ja     80107bfa <loaduvm+0x83>
      n = sz - i;
80107bef:	8b 45 18             	mov    0x18(%ebp),%eax
80107bf2:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107bf5:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107bf8:	eb 07                	jmp    80107c01 <loaduvm+0x8a>
    else
      n = PGSIZE;
80107bfa:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107c01:	8b 55 14             	mov    0x14(%ebp),%edx
80107c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c07:	01 d0                	add    %edx,%eax
80107c09:	8b 55 e8             	mov    -0x18(%ebp),%edx
80107c0c:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107c12:	ff 75 f0             	pushl  -0x10(%ebp)
80107c15:	50                   	push   %eax
80107c16:	52                   	push   %edx
80107c17:	ff 75 10             	pushl  0x10(%ebp)
80107c1a:	e8 65 a3 ff ff       	call   80101f84 <readi>
80107c1f:	83 c4 10             	add    $0x10,%esp
80107c22:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80107c25:	74 07                	je     80107c2e <loaduvm+0xb7>
      return -1;
80107c27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c2c:	eb 18                	jmp    80107c46 <loaduvm+0xcf>
  for(i = 0; i < sz; i += PGSIZE){
80107c2e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c38:	3b 45 18             	cmp    0x18(%ebp),%eax
80107c3b:	0f 82 65 ff ff ff    	jb     80107ba6 <loaduvm+0x2f>
  }
  return 0;
80107c41:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107c46:	c9                   	leave  
80107c47:	c3                   	ret    

80107c48 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107c48:	f3 0f 1e fb          	endbr32 
80107c4c:	55                   	push   %ebp
80107c4d:	89 e5                	mov    %esp,%ebp
80107c4f:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107c52:	8b 45 10             	mov    0x10(%ebp),%eax
80107c55:	85 c0                	test   %eax,%eax
80107c57:	79 0a                	jns    80107c63 <allocuvm+0x1b>
    return 0;
80107c59:	b8 00 00 00 00       	mov    $0x0,%eax
80107c5e:	e9 ec 00 00 00       	jmp    80107d4f <allocuvm+0x107>
  if(newsz < oldsz)
80107c63:	8b 45 10             	mov    0x10(%ebp),%eax
80107c66:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107c69:	73 08                	jae    80107c73 <allocuvm+0x2b>
    return oldsz;
80107c6b:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c6e:	e9 dc 00 00 00       	jmp    80107d4f <allocuvm+0x107>

  a = PGROUNDUP(oldsz);
80107c73:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c76:	05 ff 0f 00 00       	add    $0xfff,%eax
80107c7b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c80:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80107c83:	e9 b8 00 00 00       	jmp    80107d40 <allocuvm+0xf8>
    mem = kalloc();
80107c88:	e8 05 ac ff ff       	call   80102892 <kalloc>
80107c8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80107c90:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107c94:	75 2e                	jne    80107cc4 <allocuvm+0x7c>
      cprintf("allocuvm out of memory\n");
80107c96:	83 ec 0c             	sub    $0xc,%esp
80107c99:	68 49 ad 10 80       	push   $0x8010ad49
80107c9e:	e8 69 87 ff ff       	call   8010040c <cprintf>
80107ca3:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80107ca6:	83 ec 04             	sub    $0x4,%esp
80107ca9:	ff 75 0c             	pushl  0xc(%ebp)
80107cac:	ff 75 10             	pushl  0x10(%ebp)
80107caf:	ff 75 08             	pushl  0x8(%ebp)
80107cb2:	e8 9a 00 00 00       	call   80107d51 <deallocuvm>
80107cb7:	83 c4 10             	add    $0x10,%esp
      return 0;
80107cba:	b8 00 00 00 00       	mov    $0x0,%eax
80107cbf:	e9 8b 00 00 00       	jmp    80107d4f <allocuvm+0x107>
    }
    memset(mem, 0, PGSIZE);
80107cc4:	83 ec 04             	sub    $0x4,%esp
80107cc7:	68 00 10 00 00       	push   $0x1000
80107ccc:	6a 00                	push   $0x0
80107cce:	ff 75 f0             	pushl  -0x10(%ebp)
80107cd1:	e8 01 d0 ff ff       	call   80104cd7 <memset>
80107cd6:	83 c4 10             	add    $0x10,%esp
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107cd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107cdc:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80107ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ce5:	83 ec 0c             	sub    $0xc,%esp
80107ce8:	6a 06                	push   $0x6
80107cea:	52                   	push   %edx
80107ceb:	68 00 10 00 00       	push   $0x1000
80107cf0:	50                   	push   %eax
80107cf1:	ff 75 08             	pushl  0x8(%ebp)
80107cf4:	e8 a9 fa ff ff       	call   801077a2 <mappages>
80107cf9:	83 c4 20             	add    $0x20,%esp
80107cfc:	85 c0                	test   %eax,%eax
80107cfe:	79 39                	jns    80107d39 <allocuvm+0xf1>
      cprintf("allocuvm out of memory (2)\n");
80107d00:	83 ec 0c             	sub    $0xc,%esp
80107d03:	68 61 ad 10 80       	push   $0x8010ad61
80107d08:	e8 ff 86 ff ff       	call   8010040c <cprintf>
80107d0d:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80107d10:	83 ec 04             	sub    $0x4,%esp
80107d13:	ff 75 0c             	pushl  0xc(%ebp)
80107d16:	ff 75 10             	pushl  0x10(%ebp)
80107d19:	ff 75 08             	pushl  0x8(%ebp)
80107d1c:	e8 30 00 00 00       	call   80107d51 <deallocuvm>
80107d21:	83 c4 10             	add    $0x10,%esp
      kfree(mem);
80107d24:	83 ec 0c             	sub    $0xc,%esp
80107d27:	ff 75 f0             	pushl  -0x10(%ebp)
80107d2a:	e8 c5 aa ff ff       	call   801027f4 <kfree>
80107d2f:	83 c4 10             	add    $0x10,%esp
      return 0;
80107d32:	b8 00 00 00 00       	mov    $0x0,%eax
80107d37:	eb 16                	jmp    80107d4f <allocuvm+0x107>
  for(; a < newsz; a += PGSIZE){
80107d39:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d43:	3b 45 10             	cmp    0x10(%ebp),%eax
80107d46:	0f 82 3c ff ff ff    	jb     80107c88 <allocuvm+0x40>
    }
  }
  return newsz;
80107d4c:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107d4f:	c9                   	leave  
80107d50:	c3                   	ret    

80107d51 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107d51:	f3 0f 1e fb          	endbr32 
80107d55:	55                   	push   %ebp
80107d56:	89 e5                	mov    %esp,%ebp
80107d58:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107d5b:	8b 45 10             	mov    0x10(%ebp),%eax
80107d5e:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107d61:	72 08                	jb     80107d6b <deallocuvm+0x1a>
    return oldsz;
80107d63:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d66:	e9 ac 00 00 00       	jmp    80107e17 <deallocuvm+0xc6>

  a = PGROUNDUP(newsz);
80107d6b:	8b 45 10             	mov    0x10(%ebp),%eax
80107d6e:	05 ff 0f 00 00       	add    $0xfff,%eax
80107d73:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107d78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107d7b:	e9 88 00 00 00       	jmp    80107e08 <deallocuvm+0xb7>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d83:	83 ec 04             	sub    $0x4,%esp
80107d86:	6a 00                	push   $0x0
80107d88:	50                   	push   %eax
80107d89:	ff 75 08             	pushl  0x8(%ebp)
80107d8c:	e8 77 f9 ff ff       	call   80107708 <walkpgdir>
80107d91:	83 c4 10             	add    $0x10,%esp
80107d94:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte){
80107d97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107d9b:	75 16                	jne    80107db3 <deallocuvm+0x62>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107da0:	c1 e8 16             	shr    $0x16,%eax
80107da3:	83 c0 01             	add    $0x1,%eax
80107da6:	c1 e0 16             	shl    $0x16,%eax
80107da9:	2d 00 10 00 00       	sub    $0x1000,%eax
80107dae:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107db1:	eb 4e                	jmp    80107e01 <deallocuvm+0xb0>
    }
    else if((*pte & PTE_P)!=0){
80107db3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107db6:	8b 00                	mov    (%eax),%eax
80107db8:	83 e0 01             	and    $0x1,%eax
80107dbb:	85 c0                	test   %eax,%eax
80107dbd:	74 42                	je     80107e01 <deallocuvm+0xb0>
      pa = PTE_ADDR(*pte);
80107dbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107dc2:	8b 00                	mov    (%eax),%eax
80107dc4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107dc9:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80107dcc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107dd0:	75 0d                	jne    80107ddf <deallocuvm+0x8e>
        panic("kfree");
80107dd2:	83 ec 0c             	sub    $0xc,%esp
80107dd5:	68 7d ad 10 80       	push   $0x8010ad7d
80107dda:	e8 e6 87 ff ff       	call   801005c5 <panic>
      char *v = P2V(pa);
80107ddf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107de2:	05 00 00 00 80       	add    $0x80000000,%eax
80107de7:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);  // free the physical page
80107dea:	83 ec 0c             	sub    $0xc,%esp
80107ded:	ff 75 e8             	pushl  -0x18(%ebp)
80107df0:	e8 ff a9 ff ff       	call   801027f4 <kfree>
80107df5:	83 c4 10             	add    $0x10,%esp
      *pte = 0;  // clear the PTE
80107df8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107dfb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107e01:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e0b:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107e0e:	0f 82 6c ff ff ff    	jb     80107d80 <deallocuvm+0x2f>
    }
  }
  return newsz;  // return the new size
80107e14:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107e17:	c9                   	leave  
80107e18:	c3                   	ret    

80107e19 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107e19:	f3 0f 1e fb          	endbr32 
80107e1d:	55                   	push   %ebp
80107e1e:	89 e5                	mov    %esp,%ebp
80107e20:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80107e23:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107e27:	75 0d                	jne    80107e36 <freevm+0x1d>
    panic("freevm: no pgdir");
80107e29:	83 ec 0c             	sub    $0xc,%esp
80107e2c:	68 83 ad 10 80       	push   $0x8010ad83
80107e31:	e8 8f 87 ff ff       	call   801005c5 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80107e36:	83 ec 04             	sub    $0x4,%esp
80107e39:	6a 00                	push   $0x0
80107e3b:	68 00 00 00 80       	push   $0x80000000
80107e40:	ff 75 08             	pushl  0x8(%ebp)
80107e43:	e8 09 ff ff ff       	call   80107d51 <deallocuvm>
80107e48:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107e4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107e52:	eb 48                	jmp    80107e9c <freevm+0x83>
    if(pgdir[i] & PTE_P){
80107e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e57:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107e5e:	8b 45 08             	mov    0x8(%ebp),%eax
80107e61:	01 d0                	add    %edx,%eax
80107e63:	8b 00                	mov    (%eax),%eax
80107e65:	83 e0 01             	and    $0x1,%eax
80107e68:	85 c0                	test   %eax,%eax
80107e6a:	74 2c                	je     80107e98 <freevm+0x7f>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e6f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107e76:	8b 45 08             	mov    0x8(%ebp),%eax
80107e79:	01 d0                	add    %edx,%eax
80107e7b:	8b 00                	mov    (%eax),%eax
80107e7d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107e82:	05 00 00 00 80       	add    $0x80000000,%eax
80107e87:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80107e8a:	83 ec 0c             	sub    $0xc,%esp
80107e8d:	ff 75 f0             	pushl  -0x10(%ebp)
80107e90:	e8 5f a9 ff ff       	call   801027f4 <kfree>
80107e95:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107e98:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107e9c:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80107ea3:	76 af                	jbe    80107e54 <freevm+0x3b>
    }
  }
  kfree((char*)pgdir);
80107ea5:	83 ec 0c             	sub    $0xc,%esp
80107ea8:	ff 75 08             	pushl  0x8(%ebp)
80107eab:	e8 44 a9 ff ff       	call   801027f4 <kfree>
80107eb0:	83 c4 10             	add    $0x10,%esp
}
80107eb3:	90                   	nop
80107eb4:	c9                   	leave  
80107eb5:	c3                   	ret    

80107eb6 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107eb6:	f3 0f 1e fb          	endbr32 
80107eba:	55                   	push   %ebp
80107ebb:	89 e5                	mov    %esp,%ebp
80107ebd:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107ec0:	83 ec 04             	sub    $0x4,%esp
80107ec3:	6a 00                	push   $0x0
80107ec5:	ff 75 0c             	pushl  0xc(%ebp)
80107ec8:	ff 75 08             	pushl  0x8(%ebp)
80107ecb:	e8 38 f8 ff ff       	call   80107708 <walkpgdir>
80107ed0:	83 c4 10             	add    $0x10,%esp
80107ed3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80107ed6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107eda:	75 0d                	jne    80107ee9 <clearpteu+0x33>
    panic("clearpteu");
80107edc:	83 ec 0c             	sub    $0xc,%esp
80107edf:	68 94 ad 10 80       	push   $0x8010ad94
80107ee4:	e8 dc 86 ff ff       	call   801005c5 <panic>
  *pte &= ~PTE_U;
80107ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eec:	8b 00                	mov    (%eax),%eax
80107eee:	83 e0 fb             	and    $0xfffffffb,%eax
80107ef1:	89 c2                	mov    %eax,%edx
80107ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ef6:	89 10                	mov    %edx,(%eax)
}
80107ef8:	90                   	nop
80107ef9:	c9                   	leave  
80107efa:	c3                   	ret    

80107efb <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107efb:	f3 0f 1e fb          	endbr32 
80107eff:	55                   	push   %ebp
80107f00:	89 e5                	mov    %esp,%ebp
80107f02:	83 ec 28             	sub    $0x28,%esp
  pde_t *d;
  pte_t *pte, *dst_pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107f05:	e8 2c f9 ff ff       	call   80107836 <setupkvm>
80107f0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107f0d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107f11:	75 0a                	jne    80107f1d <copyuvm+0x22>
    return 0;
80107f13:	b8 00 00 00 00       	mov    $0x0,%eax
80107f18:	e9 15 01 00 00       	jmp    80108032 <copyuvm+0x137>

  for(i = 0; i < sz; i += PGSIZE){
80107f1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107f24:	e9 de 00 00 00       	jmp    80108007 <copyuvm+0x10c>
    pte = walkpgdir(pgdir, (void*)i, 0);
80107f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f2c:	83 ec 04             	sub    $0x4,%esp
80107f2f:	6a 00                	push   $0x0
80107f31:	50                   	push   %eax
80107f32:	ff 75 08             	pushl  0x8(%ebp)
80107f35:	e8 ce f7 ff ff       	call   80107708 <walkpgdir>
80107f3a:	83 c4 10             	add    $0x10,%esp
80107f3d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pte == 0 || *pte == 0)         // PTE 자체가 없다
80107f40:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107f44:	0f 84 b5 00 00 00    	je     80107fff <copyuvm+0x104>
80107f4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f4d:	8b 00                	mov    (%eax),%eax
80107f4f:	85 c0                	test   %eax,%eax
80107f51:	0f 84 a8 00 00 00    	je     80107fff <copyuvm+0x104>
      continue;

    /* ───── case 1: non-present PTE (lazy page) ───── */
    if(!(*pte & PTE_P)){
80107f57:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f5a:	8b 00                	mov    (%eax),%eax
80107f5c:	83 e0 01             	and    $0x1,%eax
80107f5f:	85 c0                	test   %eax,%eax
80107f61:	75 2d                	jne    80107f90 <copyuvm+0x95>
      dst_pte = walkpgdir(d, (void*)i, 1);   // page table 새로 만들 수 있도록 1
80107f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f66:	83 ec 04             	sub    $0x4,%esp
80107f69:	6a 01                	push   $0x1
80107f6b:	50                   	push   %eax
80107f6c:	ff 75 f0             	pushl  -0x10(%ebp)
80107f6f:	e8 94 f7 ff ff       	call   80107708 <walkpgdir>
80107f74:	83 c4 10             	add    $0x10,%esp
80107f77:	89 45 dc             	mov    %eax,-0x24(%ebp)
      if(dst_pte == 0)
80107f7a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80107f7e:	0f 84 94 00 00 00    	je     80108018 <copyuvm+0x11d>
        goto bad;
      *dst_pte = *pte;                       // 물리 페이지 없이 그대로 복사
80107f84:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f87:	8b 10                	mov    (%eax),%edx
80107f89:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107f8c:	89 10                	mov    %edx,(%eax)
      continue;
80107f8e:	eb 70                	jmp    80108000 <copyuvm+0x105>
    }

    /* ───── case 2: present page, 실제 메모리 복사 ───── */
    pa    = PTE_ADDR(*pte);
80107f90:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f93:	8b 00                	mov    (%eax),%eax
80107f95:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f9a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80107f9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107fa0:	8b 00                	mov    (%eax),%eax
80107fa2:	25 ff 0f 00 00       	and    $0xfff,%eax
80107fa7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107faa:	e8 e3 a8 ff ff       	call   80102892 <kalloc>
80107faf:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107fb2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80107fb6:	74 63                	je     8010801b <copyuvm+0x120>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107fb8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107fbb:	05 00 00 00 80       	add    $0x80000000,%eax
80107fc0:	83 ec 04             	sub    $0x4,%esp
80107fc3:	68 00 10 00 00       	push   $0x1000
80107fc8:	50                   	push   %eax
80107fc9:	ff 75 e0             	pushl  -0x20(%ebp)
80107fcc:	e8 cd cd ff ff       	call   80104d9e <memmove>
80107fd1:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107fd4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107fd7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107fda:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80107fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fe3:	83 ec 0c             	sub    $0xc,%esp
80107fe6:	52                   	push   %edx
80107fe7:	51                   	push   %ecx
80107fe8:	68 00 10 00 00       	push   $0x1000
80107fed:	50                   	push   %eax
80107fee:	ff 75 f0             	pushl  -0x10(%ebp)
80107ff1:	e8 ac f7 ff ff       	call   801077a2 <mappages>
80107ff6:	83 c4 20             	add    $0x20,%esp
80107ff9:	85 c0                	test   %eax,%eax
80107ffb:	78 21                	js     8010801e <copyuvm+0x123>
80107ffd:	eb 01                	jmp    80108000 <copyuvm+0x105>
      continue;
80107fff:	90                   	nop
  for(i = 0; i < sz; i += PGSIZE){
80108000:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108007:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010800a:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010800d:	0f 82 16 ff ff ff    	jb     80107f29 <copyuvm+0x2e>
      goto bad;
  }
  return d;
80108013:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108016:	eb 1a                	jmp    80108032 <copyuvm+0x137>
        goto bad;
80108018:	90                   	nop
80108019:	eb 04                	jmp    8010801f <copyuvm+0x124>
      goto bad;
8010801b:	90                   	nop
8010801c:	eb 01                	jmp    8010801f <copyuvm+0x124>
      goto bad;
8010801e:	90                   	nop

bad:
  freevm(d);
8010801f:	83 ec 0c             	sub    $0xc,%esp
80108022:	ff 75 f0             	pushl  -0x10(%ebp)
80108025:	e8 ef fd ff ff       	call   80107e19 <freevm>
8010802a:	83 c4 10             	add    $0x10,%esp
  return 0;
8010802d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108032:	c9                   	leave  
80108033:	c3                   	ret    

80108034 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108034:	f3 0f 1e fb          	endbr32 
80108038:	55                   	push   %ebp
80108039:	89 e5                	mov    %esp,%ebp
8010803b:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010803e:	83 ec 04             	sub    $0x4,%esp
80108041:	6a 00                	push   $0x0
80108043:	ff 75 0c             	pushl  0xc(%ebp)
80108046:	ff 75 08             	pushl  0x8(%ebp)
80108049:	e8 ba f6 ff ff       	call   80107708 <walkpgdir>
8010804e:	83 c4 10             	add    $0x10,%esp
80108051:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108054:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108057:	8b 00                	mov    (%eax),%eax
80108059:	83 e0 01             	and    $0x1,%eax
8010805c:	85 c0                	test   %eax,%eax
8010805e:	75 07                	jne    80108067 <uva2ka+0x33>
    return 0;
80108060:	b8 00 00 00 00       	mov    $0x0,%eax
80108065:	eb 22                	jmp    80108089 <uva2ka+0x55>
  if((*pte & PTE_U) == 0)
80108067:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010806a:	8b 00                	mov    (%eax),%eax
8010806c:	83 e0 04             	and    $0x4,%eax
8010806f:	85 c0                	test   %eax,%eax
80108071:	75 07                	jne    8010807a <uva2ka+0x46>
    return 0;
80108073:	b8 00 00 00 00       	mov    $0x0,%eax
80108078:	eb 0f                	jmp    80108089 <uva2ka+0x55>
  return (char*)P2V(PTE_ADDR(*pte));
8010807a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010807d:	8b 00                	mov    (%eax),%eax
8010807f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108084:	05 00 00 00 80       	add    $0x80000000,%eax
}
80108089:	c9                   	leave  
8010808a:	c3                   	ret    

8010808b <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
8010808b:	f3 0f 1e fb          	endbr32 
8010808f:	55                   	push   %ebp
80108090:	89 e5                	mov    %esp,%ebp
80108092:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108095:	8b 45 10             	mov    0x10(%ebp),%eax
80108098:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
8010809b:	eb 7f                	jmp    8010811c <copyout+0x91>
    va0 = (uint)PGROUNDDOWN(va);
8010809d:	8b 45 0c             	mov    0xc(%ebp),%eax
801080a0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801080a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
801080a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801080ab:	83 ec 08             	sub    $0x8,%esp
801080ae:	50                   	push   %eax
801080af:	ff 75 08             	pushl  0x8(%ebp)
801080b2:	e8 7d ff ff ff       	call   80108034 <uva2ka>
801080b7:	83 c4 10             	add    $0x10,%esp
801080ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
801080bd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801080c1:	75 07                	jne    801080ca <copyout+0x3f>
      return -1;
801080c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801080c8:	eb 61                	jmp    8010812b <copyout+0xa0>
    n = PGSIZE - (va - va0);
801080ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
801080cd:	2b 45 0c             	sub    0xc(%ebp),%eax
801080d0:	05 00 10 00 00       	add    $0x1000,%eax
801080d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
801080d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080db:	3b 45 14             	cmp    0x14(%ebp),%eax
801080de:	76 06                	jbe    801080e6 <copyout+0x5b>
      n = len;
801080e0:	8b 45 14             	mov    0x14(%ebp),%eax
801080e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
801080e6:	8b 45 0c             	mov    0xc(%ebp),%eax
801080e9:	2b 45 ec             	sub    -0x14(%ebp),%eax
801080ec:	89 c2                	mov    %eax,%edx
801080ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
801080f1:	01 d0                	add    %edx,%eax
801080f3:	83 ec 04             	sub    $0x4,%esp
801080f6:	ff 75 f0             	pushl  -0x10(%ebp)
801080f9:	ff 75 f4             	pushl  -0xc(%ebp)
801080fc:	50                   	push   %eax
801080fd:	e8 9c cc ff ff       	call   80104d9e <memmove>
80108102:	83 c4 10             	add    $0x10,%esp
    len -= n;
80108105:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108108:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
8010810b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010810e:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108111:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108114:	05 00 10 00 00       	add    $0x1000,%eax
80108119:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
8010811c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108120:	0f 85 77 ff ff ff    	jne    8010809d <copyout+0x12>
  }
  return 0;
80108126:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010812b:	c9                   	leave  
8010812c:	c3                   	ret    

8010812d <mpinit_uefi>:

struct cpu cpus[NCPU];
int ncpu;
uchar ioapicid;
void mpinit_uefi(void)
{
8010812d:	f3 0f 1e fb          	endbr32 
80108131:	55                   	push   %ebp
80108132:	89 e5                	mov    %esp,%ebp
80108134:	83 ec 20             	sub    $0x20,%esp
  struct boot_param *boot_param = (struct boot_param *)P2V_WO(BOOTPARAM);
80108137:	c7 45 f8 00 00 05 80 	movl   $0x80050000,-0x8(%ebp)
  struct uefi_madt *madt = (struct uefi_madt*)(P2V_WO(boot_param->madt_addr));
8010813e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80108141:	8b 40 08             	mov    0x8(%eax),%eax
80108144:	05 00 00 00 80       	add    $0x80000000,%eax
80108149:	89 45 f4             	mov    %eax,-0xc(%ebp)

  uint i=sizeof(struct uefi_madt);
8010814c:	c7 45 fc 2c 00 00 00 	movl   $0x2c,-0x4(%ebp)
  struct uefi_lapic *lapic_entry;
  struct uefi_ioapic *ioapic;
  struct uefi_iso *iso;
  struct uefi_non_maskable_intr *non_mask_intr; 
  
  lapic = (uint *)(madt->lapic_addr);
80108153:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108156:	8b 40 24             	mov    0x24(%eax),%eax
80108159:	a3 1c 54 19 80       	mov    %eax,0x8019541c
  ncpu = 0;
8010815e:	c7 05 80 7f 19 80 00 	movl   $0x0,0x80197f80
80108165:	00 00 00 

  while(i<madt->len){
80108168:	90                   	nop
80108169:	e9 be 00 00 00       	jmp    8010822c <mpinit_uefi+0xff>
    uchar *entry_type = ((uchar *)madt)+i;
8010816e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108171:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108174:	01 d0                	add    %edx,%eax
80108176:	89 45 f0             	mov    %eax,-0x10(%ebp)
    switch(*entry_type){
80108179:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010817c:	0f b6 00             	movzbl (%eax),%eax
8010817f:	0f b6 c0             	movzbl %al,%eax
80108182:	83 f8 05             	cmp    $0x5,%eax
80108185:	0f 87 a1 00 00 00    	ja     8010822c <mpinit_uefi+0xff>
8010818b:	8b 04 85 a0 ad 10 80 	mov    -0x7fef5260(,%eax,4),%eax
80108192:	3e ff e0             	notrack jmp *%eax
      case 0:
        lapic_entry = (struct uefi_lapic *)entry_type;
80108195:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108198:	89 45 e0             	mov    %eax,-0x20(%ebp)
        if(ncpu < NCPU) {
8010819b:	a1 80 7f 19 80       	mov    0x80197f80,%eax
801081a0:	83 f8 03             	cmp    $0x3,%eax
801081a3:	7f 28                	jg     801081cd <mpinit_uefi+0xa0>
          cpus[ncpu].apicid = lapic_entry->lapic_id;
801081a5:	8b 15 80 7f 19 80    	mov    0x80197f80,%edx
801081ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
801081ae:	0f b6 40 03          	movzbl 0x3(%eax),%eax
801081b2:	69 d2 b0 00 00 00    	imul   $0xb0,%edx,%edx
801081b8:	81 c2 c0 7c 19 80    	add    $0x80197cc0,%edx
801081be:	88 02                	mov    %al,(%edx)
          ncpu++;
801081c0:	a1 80 7f 19 80       	mov    0x80197f80,%eax
801081c5:	83 c0 01             	add    $0x1,%eax
801081c8:	a3 80 7f 19 80       	mov    %eax,0x80197f80
        }
        i += lapic_entry->record_len;
801081cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801081d0:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801081d4:	0f b6 c0             	movzbl %al,%eax
801081d7:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
801081da:	eb 50                	jmp    8010822c <mpinit_uefi+0xff>

      case 1:
        ioapic = (struct uefi_ioapic *)entry_type;
801081dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ioapicid = ioapic->ioapic_id;
801081e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801081e5:	0f b6 40 02          	movzbl 0x2(%eax),%eax
801081e9:	a2 a0 7c 19 80       	mov    %al,0x80197ca0
        i += ioapic->record_len;
801081ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801081f1:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801081f5:	0f b6 c0             	movzbl %al,%eax
801081f8:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
801081fb:	eb 2f                	jmp    8010822c <mpinit_uefi+0xff>

      case 2:
        iso = (struct uefi_iso *)entry_type;
801081fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108200:	89 45 e8             	mov    %eax,-0x18(%ebp)
        i += iso->record_len;
80108203:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108206:	0f b6 40 01          	movzbl 0x1(%eax),%eax
8010820a:	0f b6 c0             	movzbl %al,%eax
8010820d:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80108210:	eb 1a                	jmp    8010822c <mpinit_uefi+0xff>

      case 4:
        non_mask_intr = (struct uefi_non_maskable_intr *)entry_type;
80108212:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108215:	89 45 ec             	mov    %eax,-0x14(%ebp)
        i += non_mask_intr->record_len;
80108218:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010821b:	0f b6 40 01          	movzbl 0x1(%eax),%eax
8010821f:	0f b6 c0             	movzbl %al,%eax
80108222:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80108225:	eb 05                	jmp    8010822c <mpinit_uefi+0xff>

      case 5:
        i = i + 0xC;
80108227:	83 45 fc 0c          	addl   $0xc,-0x4(%ebp)
        break;
8010822b:	90                   	nop
  while(i<madt->len){
8010822c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010822f:	8b 40 04             	mov    0x4(%eax),%eax
80108232:	39 45 fc             	cmp    %eax,-0x4(%ebp)
80108235:	0f 82 33 ff ff ff    	jb     8010816e <mpinit_uefi+0x41>
    }
  }

}
8010823b:	90                   	nop
8010823c:	90                   	nop
8010823d:	c9                   	leave  
8010823e:	c3                   	ret    

8010823f <inb>:
{
8010823f:	55                   	push   %ebp
80108240:	89 e5                	mov    %esp,%ebp
80108242:	83 ec 14             	sub    $0x14,%esp
80108245:	8b 45 08             	mov    0x8(%ebp),%eax
80108248:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010824c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80108250:	89 c2                	mov    %eax,%edx
80108252:	ec                   	in     (%dx),%al
80108253:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80108256:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010825a:	c9                   	leave  
8010825b:	c3                   	ret    

8010825c <outb>:
{
8010825c:	55                   	push   %ebp
8010825d:	89 e5                	mov    %esp,%ebp
8010825f:	83 ec 08             	sub    $0x8,%esp
80108262:	8b 45 08             	mov    0x8(%ebp),%eax
80108265:	8b 55 0c             	mov    0xc(%ebp),%edx
80108268:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
8010826c:	89 d0                	mov    %edx,%eax
8010826e:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80108271:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80108275:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80108279:	ee                   	out    %al,(%dx)
}
8010827a:	90                   	nop
8010827b:	c9                   	leave  
8010827c:	c3                   	ret    

8010827d <uart_debug>:
#include "proc.h"
#include "x86.h"

#define COM1    0x3f8

void uart_debug(char p){
8010827d:	f3 0f 1e fb          	endbr32 
80108281:	55                   	push   %ebp
80108282:	89 e5                	mov    %esp,%ebp
80108284:	83 ec 28             	sub    $0x28,%esp
80108287:	8b 45 08             	mov    0x8(%ebp),%eax
8010828a:	88 45 e4             	mov    %al,-0x1c(%ebp)
    // Turn off the FIFO
  outb(COM1+2, 0);
8010828d:	6a 00                	push   $0x0
8010828f:	68 fa 03 00 00       	push   $0x3fa
80108294:	e8 c3 ff ff ff       	call   8010825c <outb>
80108299:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
8010829c:	68 80 00 00 00       	push   $0x80
801082a1:	68 fb 03 00 00       	push   $0x3fb
801082a6:	e8 b1 ff ff ff       	call   8010825c <outb>
801082ab:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
801082ae:	6a 0c                	push   $0xc
801082b0:	68 f8 03 00 00       	push   $0x3f8
801082b5:	e8 a2 ff ff ff       	call   8010825c <outb>
801082ba:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
801082bd:	6a 00                	push   $0x0
801082bf:	68 f9 03 00 00       	push   $0x3f9
801082c4:	e8 93 ff ff ff       	call   8010825c <outb>
801082c9:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
801082cc:	6a 03                	push   $0x3
801082ce:	68 fb 03 00 00       	push   $0x3fb
801082d3:	e8 84 ff ff ff       	call   8010825c <outb>
801082d8:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
801082db:	6a 00                	push   $0x0
801082dd:	68 fc 03 00 00       	push   $0x3fc
801082e2:	e8 75 ff ff ff       	call   8010825c <outb>
801082e7:	83 c4 08             	add    $0x8,%esp

  for(int i=0;i<128 && !(inb(COM1+5) & 0x20); i++) microdelay(10);
801082ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801082f1:	eb 11                	jmp    80108304 <uart_debug+0x87>
801082f3:	83 ec 0c             	sub    $0xc,%esp
801082f6:	6a 0a                	push   $0xa
801082f8:	e8 47 a9 ff ff       	call   80102c44 <microdelay>
801082fd:	83 c4 10             	add    $0x10,%esp
80108300:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108304:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80108308:	7f 1a                	jg     80108324 <uart_debug+0xa7>
8010830a:	83 ec 0c             	sub    $0xc,%esp
8010830d:	68 fd 03 00 00       	push   $0x3fd
80108312:	e8 28 ff ff ff       	call   8010823f <inb>
80108317:	83 c4 10             	add    $0x10,%esp
8010831a:	0f b6 c0             	movzbl %al,%eax
8010831d:	83 e0 20             	and    $0x20,%eax
80108320:	85 c0                	test   %eax,%eax
80108322:	74 cf                	je     801082f3 <uart_debug+0x76>
  outb(COM1+0, p);
80108324:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
80108328:	0f b6 c0             	movzbl %al,%eax
8010832b:	83 ec 08             	sub    $0x8,%esp
8010832e:	50                   	push   %eax
8010832f:	68 f8 03 00 00       	push   $0x3f8
80108334:	e8 23 ff ff ff       	call   8010825c <outb>
80108339:	83 c4 10             	add    $0x10,%esp
}
8010833c:	90                   	nop
8010833d:	c9                   	leave  
8010833e:	c3                   	ret    

8010833f <uart_debugs>:

void uart_debugs(char *p){
8010833f:	f3 0f 1e fb          	endbr32 
80108343:	55                   	push   %ebp
80108344:	89 e5                	mov    %esp,%ebp
80108346:	83 ec 08             	sub    $0x8,%esp
  while(*p){
80108349:	eb 1b                	jmp    80108366 <uart_debugs+0x27>
    uart_debug(*p++);
8010834b:	8b 45 08             	mov    0x8(%ebp),%eax
8010834e:	8d 50 01             	lea    0x1(%eax),%edx
80108351:	89 55 08             	mov    %edx,0x8(%ebp)
80108354:	0f b6 00             	movzbl (%eax),%eax
80108357:	0f be c0             	movsbl %al,%eax
8010835a:	83 ec 0c             	sub    $0xc,%esp
8010835d:	50                   	push   %eax
8010835e:	e8 1a ff ff ff       	call   8010827d <uart_debug>
80108363:	83 c4 10             	add    $0x10,%esp
  while(*p){
80108366:	8b 45 08             	mov    0x8(%ebp),%eax
80108369:	0f b6 00             	movzbl (%eax),%eax
8010836c:	84 c0                	test   %al,%al
8010836e:	75 db                	jne    8010834b <uart_debugs+0xc>
  }
}
80108370:	90                   	nop
80108371:	90                   	nop
80108372:	c9                   	leave  
80108373:	c3                   	ret    

80108374 <graphic_init>:
 * i%4 = 2 : red
 * i%4 = 3 : black
 */

struct gpu gpu;
void graphic_init(){
80108374:	f3 0f 1e fb          	endbr32 
80108378:	55                   	push   %ebp
80108379:	89 e5                	mov    %esp,%ebp
8010837b:	83 ec 10             	sub    $0x10,%esp
  struct boot_param *boot_param = (struct boot_param *)P2V_WO(BOOTPARAM);
8010837e:	c7 45 fc 00 00 05 80 	movl   $0x80050000,-0x4(%ebp)
  gpu.pvram_addr = boot_param->graphic_config.frame_base;
80108385:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108388:	8b 50 14             	mov    0x14(%eax),%edx
8010838b:	8b 40 10             	mov    0x10(%eax),%eax
8010838e:	a3 84 7f 19 80       	mov    %eax,0x80197f84
  gpu.vram_size = boot_param->graphic_config.frame_size;
80108393:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108396:	8b 50 1c             	mov    0x1c(%eax),%edx
80108399:	8b 40 18             	mov    0x18(%eax),%eax
8010839c:	a3 8c 7f 19 80       	mov    %eax,0x80197f8c
  gpu.vvram_addr = DEVSPACE - gpu.vram_size;
801083a1:	a1 8c 7f 19 80       	mov    0x80197f8c,%eax
801083a6:	ba 00 00 00 fe       	mov    $0xfe000000,%edx
801083ab:	29 c2                	sub    %eax,%edx
801083ad:	89 d0                	mov    %edx,%eax
801083af:	a3 88 7f 19 80       	mov    %eax,0x80197f88
  gpu.horizontal_resolution = (uint)(boot_param->graphic_config.horizontal_resolution & 0xFFFFFFFF);
801083b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801083b7:	8b 50 24             	mov    0x24(%eax),%edx
801083ba:	8b 40 20             	mov    0x20(%eax),%eax
801083bd:	a3 90 7f 19 80       	mov    %eax,0x80197f90
  gpu.vertical_resolution = (uint)(boot_param->graphic_config.vertical_resolution & 0xFFFFFFFF);
801083c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801083c5:	8b 50 2c             	mov    0x2c(%eax),%edx
801083c8:	8b 40 28             	mov    0x28(%eax),%eax
801083cb:	a3 94 7f 19 80       	mov    %eax,0x80197f94
  gpu.pixels_per_line = (uint)(boot_param->graphic_config.pixels_per_line & 0xFFFFFFFF);
801083d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801083d3:	8b 50 34             	mov    0x34(%eax),%edx
801083d6:	8b 40 30             	mov    0x30(%eax),%eax
801083d9:	a3 98 7f 19 80       	mov    %eax,0x80197f98
}
801083de:	90                   	nop
801083df:	c9                   	leave  
801083e0:	c3                   	ret    

801083e1 <graphic_draw_pixel>:

void graphic_draw_pixel(int x,int y,struct graphic_pixel * buffer){
801083e1:	f3 0f 1e fb          	endbr32 
801083e5:	55                   	push   %ebp
801083e6:	89 e5                	mov    %esp,%ebp
801083e8:	83 ec 10             	sub    $0x10,%esp
  int pixel_addr = (sizeof(struct graphic_pixel))*(y*gpu.pixels_per_line + x);
801083eb:	8b 15 98 7f 19 80    	mov    0x80197f98,%edx
801083f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801083f4:	0f af d0             	imul   %eax,%edx
801083f7:	8b 45 08             	mov    0x8(%ebp),%eax
801083fa:	01 d0                	add    %edx,%eax
801083fc:	c1 e0 02             	shl    $0x2,%eax
801083ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
  struct graphic_pixel *pixel = (struct graphic_pixel *)(gpu.vvram_addr + pixel_addr);
80108402:	8b 15 88 7f 19 80    	mov    0x80197f88,%edx
80108408:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010840b:	01 d0                	add    %edx,%eax
8010840d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  pixel->blue = buffer->blue;
80108410:	8b 45 10             	mov    0x10(%ebp),%eax
80108413:	0f b6 10             	movzbl (%eax),%edx
80108416:	8b 45 f8             	mov    -0x8(%ebp),%eax
80108419:	88 10                	mov    %dl,(%eax)
  pixel->green = buffer->green;
8010841b:	8b 45 10             	mov    0x10(%ebp),%eax
8010841e:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80108422:	8b 45 f8             	mov    -0x8(%ebp),%eax
80108425:	88 50 01             	mov    %dl,0x1(%eax)
  pixel->red = buffer->red;
80108428:	8b 45 10             	mov    0x10(%ebp),%eax
8010842b:	0f b6 50 02          	movzbl 0x2(%eax),%edx
8010842f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80108432:	88 50 02             	mov    %dl,0x2(%eax)
}
80108435:	90                   	nop
80108436:	c9                   	leave  
80108437:	c3                   	ret    

80108438 <graphic_scroll_up>:

void graphic_scroll_up(int height){
80108438:	f3 0f 1e fb          	endbr32 
8010843c:	55                   	push   %ebp
8010843d:	89 e5                	mov    %esp,%ebp
8010843f:	83 ec 18             	sub    $0x18,%esp
  int addr_diff = (sizeof(struct graphic_pixel))*gpu.pixels_per_line*height;
80108442:	8b 15 98 7f 19 80    	mov    0x80197f98,%edx
80108448:	8b 45 08             	mov    0x8(%ebp),%eax
8010844b:	0f af c2             	imul   %edx,%eax
8010844e:	c1 e0 02             	shl    $0x2,%eax
80108451:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove((unsigned int *)gpu.vvram_addr,(unsigned int *)(gpu.vvram_addr + addr_diff),gpu.vram_size - addr_diff);
80108454:	8b 15 8c 7f 19 80    	mov    0x80197f8c,%edx
8010845a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010845d:	29 c2                	sub    %eax,%edx
8010845f:	89 d0                	mov    %edx,%eax
80108461:	8b 0d 88 7f 19 80    	mov    0x80197f88,%ecx
80108467:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010846a:	01 ca                	add    %ecx,%edx
8010846c:	89 d1                	mov    %edx,%ecx
8010846e:	8b 15 88 7f 19 80    	mov    0x80197f88,%edx
80108474:	83 ec 04             	sub    $0x4,%esp
80108477:	50                   	push   %eax
80108478:	51                   	push   %ecx
80108479:	52                   	push   %edx
8010847a:	e8 1f c9 ff ff       	call   80104d9e <memmove>
8010847f:	83 c4 10             	add    $0x10,%esp
  memset((unsigned int *)(gpu.vvram_addr + gpu.vram_size - addr_diff),0,addr_diff);
80108482:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108485:	8b 0d 88 7f 19 80    	mov    0x80197f88,%ecx
8010848b:	8b 15 8c 7f 19 80    	mov    0x80197f8c,%edx
80108491:	01 d1                	add    %edx,%ecx
80108493:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108496:	29 d1                	sub    %edx,%ecx
80108498:	89 ca                	mov    %ecx,%edx
8010849a:	83 ec 04             	sub    $0x4,%esp
8010849d:	50                   	push   %eax
8010849e:	6a 00                	push   $0x0
801084a0:	52                   	push   %edx
801084a1:	e8 31 c8 ff ff       	call   80104cd7 <memset>
801084a6:	83 c4 10             	add    $0x10,%esp
}
801084a9:	90                   	nop
801084aa:	c9                   	leave  
801084ab:	c3                   	ret    

801084ac <font_render>:
#include "font.h"


struct graphic_pixel black_pixel = {0x0,0x0,0x0,0x0};
struct graphic_pixel white_pixel = {0xFF,0xFF,0xFF,0x0};
void font_render(int x,int y,int index){
801084ac:	f3 0f 1e fb          	endbr32 
801084b0:	55                   	push   %ebp
801084b1:	89 e5                	mov    %esp,%ebp
801084b3:	53                   	push   %ebx
801084b4:	83 ec 14             	sub    $0x14,%esp
  int bin;
  for(int i=0;i<30;i++){
801084b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801084be:	e9 b1 00 00 00       	jmp    80108574 <font_render+0xc8>
    for(int j=14;j>-1;j--){
801084c3:	c7 45 f0 0e 00 00 00 	movl   $0xe,-0x10(%ebp)
801084ca:	e9 97 00 00 00       	jmp    80108566 <font_render+0xba>
      bin = (font_bin[index-0x20][i])&(1 << j);
801084cf:	8b 45 10             	mov    0x10(%ebp),%eax
801084d2:	83 e8 20             	sub    $0x20,%eax
801084d5:	6b d0 1e             	imul   $0x1e,%eax,%edx
801084d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084db:	01 d0                	add    %edx,%eax
801084dd:	0f b7 84 00 c0 ad 10 	movzwl -0x7fef5240(%eax,%eax,1),%eax
801084e4:	80 
801084e5:	0f b7 d0             	movzwl %ax,%edx
801084e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084eb:	bb 01 00 00 00       	mov    $0x1,%ebx
801084f0:	89 c1                	mov    %eax,%ecx
801084f2:	d3 e3                	shl    %cl,%ebx
801084f4:	89 d8                	mov    %ebx,%eax
801084f6:	21 d0                	and    %edx,%eax
801084f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(bin == (1 << j)){
801084fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084fe:	ba 01 00 00 00       	mov    $0x1,%edx
80108503:	89 c1                	mov    %eax,%ecx
80108505:	d3 e2                	shl    %cl,%edx
80108507:	89 d0                	mov    %edx,%eax
80108509:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010850c:	75 2b                	jne    80108539 <font_render+0x8d>
        graphic_draw_pixel(x+(14-j),y+i,&white_pixel);
8010850e:	8b 55 0c             	mov    0xc(%ebp),%edx
80108511:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108514:	01 c2                	add    %eax,%edx
80108516:	b8 0e 00 00 00       	mov    $0xe,%eax
8010851b:	2b 45 f0             	sub    -0x10(%ebp),%eax
8010851e:	89 c1                	mov    %eax,%ecx
80108520:	8b 45 08             	mov    0x8(%ebp),%eax
80108523:	01 c8                	add    %ecx,%eax
80108525:	83 ec 04             	sub    $0x4,%esp
80108528:	68 e0 f4 10 80       	push   $0x8010f4e0
8010852d:	52                   	push   %edx
8010852e:	50                   	push   %eax
8010852f:	e8 ad fe ff ff       	call   801083e1 <graphic_draw_pixel>
80108534:	83 c4 10             	add    $0x10,%esp
80108537:	eb 29                	jmp    80108562 <font_render+0xb6>
      } else {
        graphic_draw_pixel(x+(14-j),y+i,&black_pixel);
80108539:	8b 55 0c             	mov    0xc(%ebp),%edx
8010853c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010853f:	01 c2                	add    %eax,%edx
80108541:	b8 0e 00 00 00       	mov    $0xe,%eax
80108546:	2b 45 f0             	sub    -0x10(%ebp),%eax
80108549:	89 c1                	mov    %eax,%ecx
8010854b:	8b 45 08             	mov    0x8(%ebp),%eax
8010854e:	01 c8                	add    %ecx,%eax
80108550:	83 ec 04             	sub    $0x4,%esp
80108553:	68 64 d0 18 80       	push   $0x8018d064
80108558:	52                   	push   %edx
80108559:	50                   	push   %eax
8010855a:	e8 82 fe ff ff       	call   801083e1 <graphic_draw_pixel>
8010855f:	83 c4 10             	add    $0x10,%esp
    for(int j=14;j>-1;j--){
80108562:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
80108566:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010856a:	0f 89 5f ff ff ff    	jns    801084cf <font_render+0x23>
  for(int i=0;i<30;i++){
80108570:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108574:	83 7d f4 1d          	cmpl   $0x1d,-0xc(%ebp)
80108578:	0f 8e 45 ff ff ff    	jle    801084c3 <font_render+0x17>
      }
    }
  }
}
8010857e:	90                   	nop
8010857f:	90                   	nop
80108580:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108583:	c9                   	leave  
80108584:	c3                   	ret    

80108585 <font_render_string>:

void font_render_string(char *string,int row){
80108585:	f3 0f 1e fb          	endbr32 
80108589:	55                   	push   %ebp
8010858a:	89 e5                	mov    %esp,%ebp
8010858c:	53                   	push   %ebx
8010858d:	83 ec 14             	sub    $0x14,%esp
  int i = 0;
80108590:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while(string[i] && i < 52){
80108597:	eb 33                	jmp    801085cc <font_render_string+0x47>
    font_render(i*15+2,row*30,string[i]);
80108599:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010859c:	8b 45 08             	mov    0x8(%ebp),%eax
8010859f:	01 d0                	add    %edx,%eax
801085a1:	0f b6 00             	movzbl (%eax),%eax
801085a4:	0f be d8             	movsbl %al,%ebx
801085a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801085aa:	6b c8 1e             	imul   $0x1e,%eax,%ecx
801085ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
801085b0:	89 d0                	mov    %edx,%eax
801085b2:	c1 e0 04             	shl    $0x4,%eax
801085b5:	29 d0                	sub    %edx,%eax
801085b7:	83 c0 02             	add    $0x2,%eax
801085ba:	83 ec 04             	sub    $0x4,%esp
801085bd:	53                   	push   %ebx
801085be:	51                   	push   %ecx
801085bf:	50                   	push   %eax
801085c0:	e8 e7 fe ff ff       	call   801084ac <font_render>
801085c5:	83 c4 10             	add    $0x10,%esp
    i++;
801085c8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  while(string[i] && i < 52){
801085cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801085cf:	8b 45 08             	mov    0x8(%ebp),%eax
801085d2:	01 d0                	add    %edx,%eax
801085d4:	0f b6 00             	movzbl (%eax),%eax
801085d7:	84 c0                	test   %al,%al
801085d9:	74 06                	je     801085e1 <font_render_string+0x5c>
801085db:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
801085df:	7e b8                	jle    80108599 <font_render_string+0x14>
  }
}
801085e1:	90                   	nop
801085e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801085e5:	c9                   	leave  
801085e6:	c3                   	ret    

801085e7 <pci_init>:
#include "pci.h"
#include "defs.h"
#include "types.h"
#include "i8254.h"

void pci_init(){
801085e7:	f3 0f 1e fb          	endbr32 
801085eb:	55                   	push   %ebp
801085ec:	89 e5                	mov    %esp,%ebp
801085ee:	53                   	push   %ebx
801085ef:	83 ec 14             	sub    $0x14,%esp
  uint data;
  for(int i=0;i<256;i++){
801085f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801085f9:	eb 6b                	jmp    80108666 <pci_init+0x7f>
    for(int j=0;j<32;j++){
801085fb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80108602:	eb 58                	jmp    8010865c <pci_init+0x75>
      for(int k=0;k<8;k++){
80108604:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
8010860b:	eb 45                	jmp    80108652 <pci_init+0x6b>
      pci_access_config(i,j,k,0,&data);
8010860d:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80108610:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108613:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108616:	83 ec 0c             	sub    $0xc,%esp
80108619:	8d 5d e8             	lea    -0x18(%ebp),%ebx
8010861c:	53                   	push   %ebx
8010861d:	6a 00                	push   $0x0
8010861f:	51                   	push   %ecx
80108620:	52                   	push   %edx
80108621:	50                   	push   %eax
80108622:	e8 c0 00 00 00       	call   801086e7 <pci_access_config>
80108627:	83 c4 20             	add    $0x20,%esp
      if((data&0xFFFF) != 0xFFFF){
8010862a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010862d:	0f b7 c0             	movzwl %ax,%eax
80108630:	3d ff ff 00 00       	cmp    $0xffff,%eax
80108635:	74 17                	je     8010864e <pci_init+0x67>
        pci_init_device(i,j,k);
80108637:	8b 4d ec             	mov    -0x14(%ebp),%ecx
8010863a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010863d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108640:	83 ec 04             	sub    $0x4,%esp
80108643:	51                   	push   %ecx
80108644:	52                   	push   %edx
80108645:	50                   	push   %eax
80108646:	e8 4f 01 00 00       	call   8010879a <pci_init_device>
8010864b:	83 c4 10             	add    $0x10,%esp
      for(int k=0;k<8;k++){
8010864e:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80108652:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
80108656:	7e b5                	jle    8010860d <pci_init+0x26>
    for(int j=0;j<32;j++){
80108658:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010865c:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
80108660:	7e a2                	jle    80108604 <pci_init+0x1d>
  for(int i=0;i<256;i++){
80108662:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108666:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
8010866d:	7e 8c                	jle    801085fb <pci_init+0x14>
      }
      }
    }
  }
}
8010866f:	90                   	nop
80108670:	90                   	nop
80108671:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108674:	c9                   	leave  
80108675:	c3                   	ret    

80108676 <pci_write_config>:

void pci_write_config(uint config){
80108676:	f3 0f 1e fb          	endbr32 
8010867a:	55                   	push   %ebp
8010867b:	89 e5                	mov    %esp,%ebp
  asm("mov $0xCF8,%%edx\n\t"
8010867d:	8b 45 08             	mov    0x8(%ebp),%eax
80108680:	ba f8 0c 00 00       	mov    $0xcf8,%edx
80108685:	89 c0                	mov    %eax,%eax
80108687:	ef                   	out    %eax,(%dx)
      "mov %0,%%eax\n\t"
      "out %%eax,%%dx\n\t"
      : :"r"(config));
}
80108688:	90                   	nop
80108689:	5d                   	pop    %ebp
8010868a:	c3                   	ret    

8010868b <pci_write_data>:

void pci_write_data(uint config){
8010868b:	f3 0f 1e fb          	endbr32 
8010868f:	55                   	push   %ebp
80108690:	89 e5                	mov    %esp,%ebp
  asm("mov $0xCFC,%%edx\n\t"
80108692:	8b 45 08             	mov    0x8(%ebp),%eax
80108695:	ba fc 0c 00 00       	mov    $0xcfc,%edx
8010869a:	89 c0                	mov    %eax,%eax
8010869c:	ef                   	out    %eax,(%dx)
      "mov %0,%%eax\n\t"
      "out %%eax,%%dx\n\t"
      : :"r"(config));
}
8010869d:	90                   	nop
8010869e:	5d                   	pop    %ebp
8010869f:	c3                   	ret    

801086a0 <pci_read_config>:
uint pci_read_config(){
801086a0:	f3 0f 1e fb          	endbr32 
801086a4:	55                   	push   %ebp
801086a5:	89 e5                	mov    %esp,%ebp
801086a7:	83 ec 18             	sub    $0x18,%esp
  uint data;
  asm("mov $0xCFC,%%edx\n\t"
801086aa:	ba fc 0c 00 00       	mov    $0xcfc,%edx
801086af:	ed                   	in     (%dx),%eax
801086b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
      "in %%dx,%%eax\n\t"
      "mov %%eax,%0"
      :"=m"(data):);
  microdelay(200);
801086b3:	83 ec 0c             	sub    $0xc,%esp
801086b6:	68 c8 00 00 00       	push   $0xc8
801086bb:	e8 84 a5 ff ff       	call   80102c44 <microdelay>
801086c0:	83 c4 10             	add    $0x10,%esp
  return data;
801086c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801086c6:	c9                   	leave  
801086c7:	c3                   	ret    

801086c8 <pci_test>:


void pci_test(){
801086c8:	f3 0f 1e fb          	endbr32 
801086cc:	55                   	push   %ebp
801086cd:	89 e5                	mov    %esp,%ebp
801086cf:	83 ec 10             	sub    $0x10,%esp
  uint data = 0x80001804;
801086d2:	c7 45 fc 04 18 00 80 	movl   $0x80001804,-0x4(%ebp)
  pci_write_config(data);
801086d9:	ff 75 fc             	pushl  -0x4(%ebp)
801086dc:	e8 95 ff ff ff       	call   80108676 <pci_write_config>
801086e1:	83 c4 04             	add    $0x4,%esp
}
801086e4:	90                   	nop
801086e5:	c9                   	leave  
801086e6:	c3                   	ret    

801086e7 <pci_access_config>:

void pci_access_config(uint bus_num,uint device_num,uint function_num,uint reg_addr,uint *data){
801086e7:	f3 0f 1e fb          	endbr32 
801086eb:	55                   	push   %ebp
801086ec:	89 e5                	mov    %esp,%ebp
801086ee:	83 ec 18             	sub    $0x18,%esp
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
801086f1:	8b 45 08             	mov    0x8(%ebp),%eax
801086f4:	c1 e0 10             	shl    $0x10,%eax
801086f7:	25 00 00 ff 00       	and    $0xff0000,%eax
801086fc:	89 c2                	mov    %eax,%edx
801086fe:	8b 45 0c             	mov    0xc(%ebp),%eax
80108701:	c1 e0 0b             	shl    $0xb,%eax
80108704:	0f b7 c0             	movzwl %ax,%eax
80108707:	09 c2                	or     %eax,%edx
80108709:	8b 45 10             	mov    0x10(%ebp),%eax
8010870c:	c1 e0 08             	shl    $0x8,%eax
8010870f:	25 00 07 00 00       	and    $0x700,%eax
80108714:	09 c2                	or     %eax,%edx
    (reg_addr & 0xFC) | 0x80000000;
80108716:	8b 45 14             	mov    0x14(%ebp),%eax
80108719:	25 fc 00 00 00       	and    $0xfc,%eax
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
8010871e:	09 d0                	or     %edx,%eax
80108720:	0d 00 00 00 80       	or     $0x80000000,%eax
80108725:	89 45 f4             	mov    %eax,-0xc(%ebp)
  pci_write_config(config_addr);
80108728:	ff 75 f4             	pushl  -0xc(%ebp)
8010872b:	e8 46 ff ff ff       	call   80108676 <pci_write_config>
80108730:	83 c4 04             	add    $0x4,%esp
  *data = pci_read_config();
80108733:	e8 68 ff ff ff       	call   801086a0 <pci_read_config>
80108738:	8b 55 18             	mov    0x18(%ebp),%edx
8010873b:	89 02                	mov    %eax,(%edx)
}
8010873d:	90                   	nop
8010873e:	c9                   	leave  
8010873f:	c3                   	ret    

80108740 <pci_write_config_register>:

void pci_write_config_register(uint bus_num,uint device_num,uint function_num,uint reg_addr,uint data){
80108740:	f3 0f 1e fb          	endbr32 
80108744:	55                   	push   %ebp
80108745:	89 e5                	mov    %esp,%ebp
80108747:	83 ec 10             	sub    $0x10,%esp
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
8010874a:	8b 45 08             	mov    0x8(%ebp),%eax
8010874d:	c1 e0 10             	shl    $0x10,%eax
80108750:	25 00 00 ff 00       	and    $0xff0000,%eax
80108755:	89 c2                	mov    %eax,%edx
80108757:	8b 45 0c             	mov    0xc(%ebp),%eax
8010875a:	c1 e0 0b             	shl    $0xb,%eax
8010875d:	0f b7 c0             	movzwl %ax,%eax
80108760:	09 c2                	or     %eax,%edx
80108762:	8b 45 10             	mov    0x10(%ebp),%eax
80108765:	c1 e0 08             	shl    $0x8,%eax
80108768:	25 00 07 00 00       	and    $0x700,%eax
8010876d:	09 c2                	or     %eax,%edx
    (reg_addr & 0xFC) | 0x80000000;
8010876f:	8b 45 14             	mov    0x14(%ebp),%eax
80108772:	25 fc 00 00 00       	and    $0xfc,%eax
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
80108777:	09 d0                	or     %edx,%eax
80108779:	0d 00 00 00 80       	or     $0x80000000,%eax
8010877e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  pci_write_config(config_addr);
80108781:	ff 75 fc             	pushl  -0x4(%ebp)
80108784:	e8 ed fe ff ff       	call   80108676 <pci_write_config>
80108789:	83 c4 04             	add    $0x4,%esp
  pci_write_data(data);
8010878c:	ff 75 18             	pushl  0x18(%ebp)
8010878f:	e8 f7 fe ff ff       	call   8010868b <pci_write_data>
80108794:	83 c4 04             	add    $0x4,%esp
}
80108797:	90                   	nop
80108798:	c9                   	leave  
80108799:	c3                   	ret    

8010879a <pci_init_device>:

struct pci_dev dev;
void pci_init_device(uint bus_num,uint device_num,uint function_num){
8010879a:	f3 0f 1e fb          	endbr32 
8010879e:	55                   	push   %ebp
8010879f:	89 e5                	mov    %esp,%ebp
801087a1:	53                   	push   %ebx
801087a2:	83 ec 14             	sub    $0x14,%esp
  uint data;
  dev.bus_num = bus_num;
801087a5:	8b 45 08             	mov    0x8(%ebp),%eax
801087a8:	a2 9c 7f 19 80       	mov    %al,0x80197f9c
  dev.device_num = device_num;
801087ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801087b0:	a2 9d 7f 19 80       	mov    %al,0x80197f9d
  dev.function_num = function_num;
801087b5:	8b 45 10             	mov    0x10(%ebp),%eax
801087b8:	a2 9e 7f 19 80       	mov    %al,0x80197f9e
  cprintf("PCI Device Found Bus:0x%x Device:0x%x Function:%x\n",bus_num,device_num,function_num);
801087bd:	ff 75 10             	pushl  0x10(%ebp)
801087c0:	ff 75 0c             	pushl  0xc(%ebp)
801087c3:	ff 75 08             	pushl  0x8(%ebp)
801087c6:	68 04 c4 10 80       	push   $0x8010c404
801087cb:	e8 3c 7c ff ff       	call   8010040c <cprintf>
801087d0:	83 c4 10             	add    $0x10,%esp
  
  pci_access_config(bus_num,device_num,function_num,0,&data);
801087d3:	83 ec 0c             	sub    $0xc,%esp
801087d6:	8d 45 ec             	lea    -0x14(%ebp),%eax
801087d9:	50                   	push   %eax
801087da:	6a 00                	push   $0x0
801087dc:	ff 75 10             	pushl  0x10(%ebp)
801087df:	ff 75 0c             	pushl  0xc(%ebp)
801087e2:	ff 75 08             	pushl  0x8(%ebp)
801087e5:	e8 fd fe ff ff       	call   801086e7 <pci_access_config>
801087ea:	83 c4 20             	add    $0x20,%esp
  uint device_id = data>>16;
801087ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087f0:	c1 e8 10             	shr    $0x10,%eax
801087f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint vendor_id = data&0xFFFF;
801087f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087f9:	25 ff ff 00 00       	and    $0xffff,%eax
801087fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dev.device_id = device_id;
80108801:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108804:	a3 a0 7f 19 80       	mov    %eax,0x80197fa0
  dev.vendor_id = vendor_id;
80108809:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010880c:	a3 a4 7f 19 80       	mov    %eax,0x80197fa4
  cprintf("  Device ID:0x%x  Vendor ID:0x%x\n",device_id,vendor_id);
80108811:	83 ec 04             	sub    $0x4,%esp
80108814:	ff 75 f0             	pushl  -0x10(%ebp)
80108817:	ff 75 f4             	pushl  -0xc(%ebp)
8010881a:	68 38 c4 10 80       	push   $0x8010c438
8010881f:	e8 e8 7b ff ff       	call   8010040c <cprintf>
80108824:	83 c4 10             	add    $0x10,%esp
  
  pci_access_config(bus_num,device_num,function_num,0x8,&data);
80108827:	83 ec 0c             	sub    $0xc,%esp
8010882a:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010882d:	50                   	push   %eax
8010882e:	6a 08                	push   $0x8
80108830:	ff 75 10             	pushl  0x10(%ebp)
80108833:	ff 75 0c             	pushl  0xc(%ebp)
80108836:	ff 75 08             	pushl  0x8(%ebp)
80108839:	e8 a9 fe ff ff       	call   801086e7 <pci_access_config>
8010883e:	83 c4 20             	add    $0x20,%esp
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
80108841:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108844:	0f b6 c8             	movzbl %al,%ecx
      data>>24,(data>>16)&0xFF,(data>>8)&0xFF,data&0xFF);
80108847:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010884a:	c1 e8 08             	shr    $0x8,%eax
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
8010884d:	0f b6 d0             	movzbl %al,%edx
      data>>24,(data>>16)&0xFF,(data>>8)&0xFF,data&0xFF);
80108850:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108853:	c1 e8 10             	shr    $0x10,%eax
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
80108856:	0f b6 c0             	movzbl %al,%eax
80108859:	8b 5d ec             	mov    -0x14(%ebp),%ebx
8010885c:	c1 eb 18             	shr    $0x18,%ebx
8010885f:	83 ec 0c             	sub    $0xc,%esp
80108862:	51                   	push   %ecx
80108863:	52                   	push   %edx
80108864:	50                   	push   %eax
80108865:	53                   	push   %ebx
80108866:	68 5c c4 10 80       	push   $0x8010c45c
8010886b:	e8 9c 7b ff ff       	call   8010040c <cprintf>
80108870:	83 c4 20             	add    $0x20,%esp
  dev.base_class = data>>24;
80108873:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108876:	c1 e8 18             	shr    $0x18,%eax
80108879:	a2 a8 7f 19 80       	mov    %al,0x80197fa8
  dev.sub_class = (data>>16)&0xFF;
8010887e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108881:	c1 e8 10             	shr    $0x10,%eax
80108884:	a2 a9 7f 19 80       	mov    %al,0x80197fa9
  dev.interface = (data>>8)&0xFF;
80108889:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010888c:	c1 e8 08             	shr    $0x8,%eax
8010888f:	a2 aa 7f 19 80       	mov    %al,0x80197faa
  dev.revision_id = data&0xFF;
80108894:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108897:	a2 ab 7f 19 80       	mov    %al,0x80197fab
  
  pci_access_config(bus_num,device_num,function_num,0x10,&data);
8010889c:	83 ec 0c             	sub    $0xc,%esp
8010889f:	8d 45 ec             	lea    -0x14(%ebp),%eax
801088a2:	50                   	push   %eax
801088a3:	6a 10                	push   $0x10
801088a5:	ff 75 10             	pushl  0x10(%ebp)
801088a8:	ff 75 0c             	pushl  0xc(%ebp)
801088ab:	ff 75 08             	pushl  0x8(%ebp)
801088ae:	e8 34 fe ff ff       	call   801086e7 <pci_access_config>
801088b3:	83 c4 20             	add    $0x20,%esp
  dev.bar0 = data;
801088b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801088b9:	a3 ac 7f 19 80       	mov    %eax,0x80197fac
  pci_access_config(bus_num,device_num,function_num,0x14,&data);
801088be:	83 ec 0c             	sub    $0xc,%esp
801088c1:	8d 45 ec             	lea    -0x14(%ebp),%eax
801088c4:	50                   	push   %eax
801088c5:	6a 14                	push   $0x14
801088c7:	ff 75 10             	pushl  0x10(%ebp)
801088ca:	ff 75 0c             	pushl  0xc(%ebp)
801088cd:	ff 75 08             	pushl  0x8(%ebp)
801088d0:	e8 12 fe ff ff       	call   801086e7 <pci_access_config>
801088d5:	83 c4 20             	add    $0x20,%esp
  dev.bar1 = data;
801088d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801088db:	a3 b0 7f 19 80       	mov    %eax,0x80197fb0
  if(device_id == I8254_DEVICE_ID && vendor_id == I8254_VENDOR_ID){
801088e0:	81 7d f4 0e 10 00 00 	cmpl   $0x100e,-0xc(%ebp)
801088e7:	75 5a                	jne    80108943 <pci_init_device+0x1a9>
801088e9:	81 7d f0 86 80 00 00 	cmpl   $0x8086,-0x10(%ebp)
801088f0:	75 51                	jne    80108943 <pci_init_device+0x1a9>
    cprintf("E1000 Ethernet NIC Found\n");
801088f2:	83 ec 0c             	sub    $0xc,%esp
801088f5:	68 a1 c4 10 80       	push   $0x8010c4a1
801088fa:	e8 0d 7b ff ff       	call   8010040c <cprintf>
801088ff:	83 c4 10             	add    $0x10,%esp
    pci_access_config(bus_num,device_num,function_num,0xF0,&data);
80108902:	83 ec 0c             	sub    $0xc,%esp
80108905:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108908:	50                   	push   %eax
80108909:	68 f0 00 00 00       	push   $0xf0
8010890e:	ff 75 10             	pushl  0x10(%ebp)
80108911:	ff 75 0c             	pushl  0xc(%ebp)
80108914:	ff 75 08             	pushl  0x8(%ebp)
80108917:	e8 cb fd ff ff       	call   801086e7 <pci_access_config>
8010891c:	83 c4 20             	add    $0x20,%esp
    cprintf("Message Control:%x\n",data);
8010891f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108922:	83 ec 08             	sub    $0x8,%esp
80108925:	50                   	push   %eax
80108926:	68 bb c4 10 80       	push   $0x8010c4bb
8010892b:	e8 dc 7a ff ff       	call   8010040c <cprintf>
80108930:	83 c4 10             	add    $0x10,%esp
    i8254_init(&dev);
80108933:	83 ec 0c             	sub    $0xc,%esp
80108936:	68 9c 7f 19 80       	push   $0x80197f9c
8010893b:	e8 09 00 00 00       	call   80108949 <i8254_init>
80108940:	83 c4 10             	add    $0x10,%esp
  }
}
80108943:	90                   	nop
80108944:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108947:	c9                   	leave  
80108948:	c3                   	ret    

80108949 <i8254_init>:

uint base_addr;
uchar mac_addr[6] = {0};
uchar my_ip[4] = {10,0,1,10}; 
uint *intr_addr;
void i8254_init(struct pci_dev *dev){
80108949:	f3 0f 1e fb          	endbr32 
8010894d:	55                   	push   %ebp
8010894e:	89 e5                	mov    %esp,%ebp
80108950:	53                   	push   %ebx
80108951:	83 ec 14             	sub    $0x14,%esp
  uint cmd_reg;
  //Enable Bus Master
  pci_access_config(dev->bus_num,dev->device_num,dev->function_num,0x04,&cmd_reg);
80108954:	8b 45 08             	mov    0x8(%ebp),%eax
80108957:	0f b6 40 02          	movzbl 0x2(%eax),%eax
8010895b:	0f b6 c8             	movzbl %al,%ecx
8010895e:	8b 45 08             	mov    0x8(%ebp),%eax
80108961:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80108965:	0f b6 d0             	movzbl %al,%edx
80108968:	8b 45 08             	mov    0x8(%ebp),%eax
8010896b:	0f b6 00             	movzbl (%eax),%eax
8010896e:	0f b6 c0             	movzbl %al,%eax
80108971:	83 ec 0c             	sub    $0xc,%esp
80108974:	8d 5d ec             	lea    -0x14(%ebp),%ebx
80108977:	53                   	push   %ebx
80108978:	6a 04                	push   $0x4
8010897a:	51                   	push   %ecx
8010897b:	52                   	push   %edx
8010897c:	50                   	push   %eax
8010897d:	e8 65 fd ff ff       	call   801086e7 <pci_access_config>
80108982:	83 c4 20             	add    $0x20,%esp
  cmd_reg = cmd_reg | PCI_CMD_BUS_MASTER;
80108985:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108988:	83 c8 04             	or     $0x4,%eax
8010898b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  pci_write_config_register(dev->bus_num,dev->device_num,dev->function_num,0x04,cmd_reg);
8010898e:	8b 5d ec             	mov    -0x14(%ebp),%ebx
80108991:	8b 45 08             	mov    0x8(%ebp),%eax
80108994:	0f b6 40 02          	movzbl 0x2(%eax),%eax
80108998:	0f b6 c8             	movzbl %al,%ecx
8010899b:	8b 45 08             	mov    0x8(%ebp),%eax
8010899e:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801089a2:	0f b6 d0             	movzbl %al,%edx
801089a5:	8b 45 08             	mov    0x8(%ebp),%eax
801089a8:	0f b6 00             	movzbl (%eax),%eax
801089ab:	0f b6 c0             	movzbl %al,%eax
801089ae:	83 ec 0c             	sub    $0xc,%esp
801089b1:	53                   	push   %ebx
801089b2:	6a 04                	push   $0x4
801089b4:	51                   	push   %ecx
801089b5:	52                   	push   %edx
801089b6:	50                   	push   %eax
801089b7:	e8 84 fd ff ff       	call   80108740 <pci_write_config_register>
801089bc:	83 c4 20             	add    $0x20,%esp
  
  base_addr = PCI_P2V(dev->bar0);
801089bf:	8b 45 08             	mov    0x8(%ebp),%eax
801089c2:	8b 40 10             	mov    0x10(%eax),%eax
801089c5:	05 00 00 00 40       	add    $0x40000000,%eax
801089ca:	a3 b4 7f 19 80       	mov    %eax,0x80197fb4
  uint *ctrl = (uint *)base_addr;
801089cf:	a1 b4 7f 19 80       	mov    0x80197fb4,%eax
801089d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  //Disable Interrupts
  uint *imc = (uint *)(base_addr+0xD8);
801089d7:	a1 b4 7f 19 80       	mov    0x80197fb4,%eax
801089dc:	05 d8 00 00 00       	add    $0xd8,%eax
801089e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  *imc = 0xFFFFFFFF;
801089e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089e7:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
  
  //Reset NIC
  *ctrl = *ctrl | I8254_CTRL_RST;
801089ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089f0:	8b 00                	mov    (%eax),%eax
801089f2:	0d 00 00 00 04       	or     $0x4000000,%eax
801089f7:	89 c2                	mov    %eax,%edx
801089f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089fc:	89 10                	mov    %edx,(%eax)

  //Enable Interrupts
  *imc = 0xFFFFFFFF;
801089fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a01:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)

  //Enable Link
  *ctrl |= I8254_CTRL_SLU;
80108a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a0a:	8b 00                	mov    (%eax),%eax
80108a0c:	83 c8 40             	or     $0x40,%eax
80108a0f:	89 c2                	mov    %eax,%edx
80108a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a14:	89 10                	mov    %edx,(%eax)
  
  //General Configuration
  *ctrl &= (~I8254_CTRL_PHY_RST | ~I8254_CTRL_VME | ~I8254_CTRL_ILOS);
80108a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a19:	8b 10                	mov    (%eax),%edx
80108a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a1e:	89 10                	mov    %edx,(%eax)
  cprintf("E1000 General Configuration Done\n");
80108a20:	83 ec 0c             	sub    $0xc,%esp
80108a23:	68 d0 c4 10 80       	push   $0x8010c4d0
80108a28:	e8 df 79 ff ff       	call   8010040c <cprintf>
80108a2d:	83 c4 10             	add    $0x10,%esp
  intr_addr = (uint *)kalloc();
80108a30:	e8 5d 9e ff ff       	call   80102892 <kalloc>
80108a35:	a3 b8 7f 19 80       	mov    %eax,0x80197fb8
  *intr_addr = 0;
80108a3a:	a1 b8 7f 19 80       	mov    0x80197fb8,%eax
80108a3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  cprintf("INTR_ADDR:%x\n",intr_addr);
80108a45:	a1 b8 7f 19 80       	mov    0x80197fb8,%eax
80108a4a:	83 ec 08             	sub    $0x8,%esp
80108a4d:	50                   	push   %eax
80108a4e:	68 f2 c4 10 80       	push   $0x8010c4f2
80108a53:	e8 b4 79 ff ff       	call   8010040c <cprintf>
80108a58:	83 c4 10             	add    $0x10,%esp
  i8254_init_recv();
80108a5b:	e8 50 00 00 00       	call   80108ab0 <i8254_init_recv>
  i8254_init_send();
80108a60:	e8 6d 03 00 00       	call   80108dd2 <i8254_init_send>
  cprintf("IP Address %d.%d.%d.%d\n",
      my_ip[0],
      my_ip[1],
      my_ip[2],
      my_ip[3]);
80108a65:	0f b6 05 e7 f4 10 80 	movzbl 0x8010f4e7,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
80108a6c:	0f b6 d8             	movzbl %al,%ebx
      my_ip[2],
80108a6f:	0f b6 05 e6 f4 10 80 	movzbl 0x8010f4e6,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
80108a76:	0f b6 c8             	movzbl %al,%ecx
      my_ip[1],
80108a79:	0f b6 05 e5 f4 10 80 	movzbl 0x8010f4e5,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
80108a80:	0f b6 d0             	movzbl %al,%edx
      my_ip[0],
80108a83:	0f b6 05 e4 f4 10 80 	movzbl 0x8010f4e4,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
80108a8a:	0f b6 c0             	movzbl %al,%eax
80108a8d:	83 ec 0c             	sub    $0xc,%esp
80108a90:	53                   	push   %ebx
80108a91:	51                   	push   %ecx
80108a92:	52                   	push   %edx
80108a93:	50                   	push   %eax
80108a94:	68 00 c5 10 80       	push   $0x8010c500
80108a99:	e8 6e 79 ff ff       	call   8010040c <cprintf>
80108a9e:	83 c4 20             	add    $0x20,%esp
  *imc = 0x0;
80108aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108aa4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
80108aaa:	90                   	nop
80108aab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108aae:	c9                   	leave  
80108aaf:	c3                   	ret    

80108ab0 <i8254_init_recv>:

void i8254_init_recv(){
80108ab0:	f3 0f 1e fb          	endbr32 
80108ab4:	55                   	push   %ebp
80108ab5:	89 e5                	mov    %esp,%ebp
80108ab7:	57                   	push   %edi
80108ab8:	56                   	push   %esi
80108ab9:	53                   	push   %ebx
80108aba:	83 ec 6c             	sub    $0x6c,%esp
  
  uint data_l = i8254_read_eeprom(0x0);
80108abd:	83 ec 0c             	sub    $0xc,%esp
80108ac0:	6a 00                	push   $0x0
80108ac2:	e8 ec 04 00 00       	call   80108fb3 <i8254_read_eeprom>
80108ac7:	83 c4 10             	add    $0x10,%esp
80108aca:	89 45 d8             	mov    %eax,-0x28(%ebp)
  mac_addr[0] = data_l&0xFF;
80108acd:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108ad0:	a2 68 d0 18 80       	mov    %al,0x8018d068
  mac_addr[1] = data_l>>8;
80108ad5:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108ad8:	c1 e8 08             	shr    $0x8,%eax
80108adb:	a2 69 d0 18 80       	mov    %al,0x8018d069
  uint data_m = i8254_read_eeprom(0x1);
80108ae0:	83 ec 0c             	sub    $0xc,%esp
80108ae3:	6a 01                	push   $0x1
80108ae5:	e8 c9 04 00 00       	call   80108fb3 <i8254_read_eeprom>
80108aea:	83 c4 10             	add    $0x10,%esp
80108aed:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  mac_addr[2] = data_m&0xFF;
80108af0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108af3:	a2 6a d0 18 80       	mov    %al,0x8018d06a
  mac_addr[3] = data_m>>8;
80108af8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108afb:	c1 e8 08             	shr    $0x8,%eax
80108afe:	a2 6b d0 18 80       	mov    %al,0x8018d06b
  uint data_h = i8254_read_eeprom(0x2);
80108b03:	83 ec 0c             	sub    $0xc,%esp
80108b06:	6a 02                	push   $0x2
80108b08:	e8 a6 04 00 00       	call   80108fb3 <i8254_read_eeprom>
80108b0d:	83 c4 10             	add    $0x10,%esp
80108b10:	89 45 d0             	mov    %eax,-0x30(%ebp)
  mac_addr[4] = data_h&0xFF;
80108b13:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b16:	a2 6c d0 18 80       	mov    %al,0x8018d06c
  mac_addr[5] = data_h>>8;
80108b1b:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b1e:	c1 e8 08             	shr    $0x8,%eax
80108b21:	a2 6d d0 18 80       	mov    %al,0x8018d06d
      mac_addr[0],
      mac_addr[1],
      mac_addr[2],
      mac_addr[3],
      mac_addr[4],
      mac_addr[5]);
80108b26:	0f b6 05 6d d0 18 80 	movzbl 0x8018d06d,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108b2d:	0f b6 f8             	movzbl %al,%edi
      mac_addr[4],
80108b30:	0f b6 05 6c d0 18 80 	movzbl 0x8018d06c,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108b37:	0f b6 f0             	movzbl %al,%esi
      mac_addr[3],
80108b3a:	0f b6 05 6b d0 18 80 	movzbl 0x8018d06b,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108b41:	0f b6 d8             	movzbl %al,%ebx
      mac_addr[2],
80108b44:	0f b6 05 6a d0 18 80 	movzbl 0x8018d06a,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108b4b:	0f b6 c8             	movzbl %al,%ecx
      mac_addr[1],
80108b4e:	0f b6 05 69 d0 18 80 	movzbl 0x8018d069,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108b55:	0f b6 d0             	movzbl %al,%edx
      mac_addr[0],
80108b58:	0f b6 05 68 d0 18 80 	movzbl 0x8018d068,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108b5f:	0f b6 c0             	movzbl %al,%eax
80108b62:	83 ec 04             	sub    $0x4,%esp
80108b65:	57                   	push   %edi
80108b66:	56                   	push   %esi
80108b67:	53                   	push   %ebx
80108b68:	51                   	push   %ecx
80108b69:	52                   	push   %edx
80108b6a:	50                   	push   %eax
80108b6b:	68 18 c5 10 80       	push   $0x8010c518
80108b70:	e8 97 78 ff ff       	call   8010040c <cprintf>
80108b75:	83 c4 20             	add    $0x20,%esp

  uint *ral = (uint *)(base_addr + 0x5400);
80108b78:	a1 b4 7f 19 80       	mov    0x80197fb4,%eax
80108b7d:	05 00 54 00 00       	add    $0x5400,%eax
80108b82:	89 45 cc             	mov    %eax,-0x34(%ebp)
  uint *rah = (uint *)(base_addr + 0x5404);
80108b85:	a1 b4 7f 19 80       	mov    0x80197fb4,%eax
80108b8a:	05 04 54 00 00       	add    $0x5404,%eax
80108b8f:	89 45 c8             	mov    %eax,-0x38(%ebp)

  *ral = (data_l | (data_m << 16));
80108b92:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108b95:	c1 e0 10             	shl    $0x10,%eax
80108b98:	0b 45 d8             	or     -0x28(%ebp),%eax
80108b9b:	89 c2                	mov    %eax,%edx
80108b9d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80108ba0:	89 10                	mov    %edx,(%eax)
  *rah = (data_h | I8254_RAH_AS_DEST | I8254_RAH_AV);
80108ba2:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108ba5:	0d 00 00 00 80       	or     $0x80000000,%eax
80108baa:	89 c2                	mov    %eax,%edx
80108bac:	8b 45 c8             	mov    -0x38(%ebp),%eax
80108baf:	89 10                	mov    %edx,(%eax)

  uint *mta = (uint *)(base_addr + 0x5200);
80108bb1:	a1 b4 7f 19 80       	mov    0x80197fb4,%eax
80108bb6:	05 00 52 00 00       	add    $0x5200,%eax
80108bbb:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  for(int i=0;i<128;i++){
80108bbe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80108bc5:	eb 19                	jmp    80108be0 <i8254_init_recv+0x130>
    mta[i] = 0;
80108bc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108bca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108bd1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80108bd4:	01 d0                	add    %edx,%eax
80108bd6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(int i=0;i<128;i++){
80108bdc:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80108be0:	83 7d e4 7f          	cmpl   $0x7f,-0x1c(%ebp)
80108be4:	7e e1                	jle    80108bc7 <i8254_init_recv+0x117>
  }

  uint *ims = (uint *)(base_addr + 0xD0);
80108be6:	a1 b4 7f 19 80       	mov    0x80197fb4,%eax
80108beb:	05 d0 00 00 00       	add    $0xd0,%eax
80108bf0:	89 45 c0             	mov    %eax,-0x40(%ebp)
  *ims = (I8254_IMS_RXT0 | I8254_IMS_RXDMT0 | I8254_IMS_RXSEQ | I8254_IMS_LSC | I8254_IMS_RXO);
80108bf3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80108bf6:	c7 00 dc 00 00 00    	movl   $0xdc,(%eax)
  uint *ics = (uint *)(base_addr + 0xC8);
80108bfc:	a1 b4 7f 19 80       	mov    0x80197fb4,%eax
80108c01:	05 c8 00 00 00       	add    $0xc8,%eax
80108c06:	89 45 bc             	mov    %eax,-0x44(%ebp)
  *ics = (I8254_IMS_RXT0 | I8254_IMS_RXDMT0 | I8254_IMS_RXSEQ | I8254_IMS_LSC | I8254_IMS_RXO);
80108c09:	8b 45 bc             	mov    -0x44(%ebp),%eax
80108c0c:	c7 00 dc 00 00 00    	movl   $0xdc,(%eax)



  uint *rxdctl = (uint *)(base_addr + 0x2828);
80108c12:	a1 b4 7f 19 80       	mov    0x80197fb4,%eax
80108c17:	05 28 28 00 00       	add    $0x2828,%eax
80108c1c:	89 45 b8             	mov    %eax,-0x48(%ebp)
  *rxdctl = 0;
80108c1f:	8b 45 b8             	mov    -0x48(%ebp),%eax
80108c22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  uint *rctl = (uint *)(base_addr + 0x100);
80108c28:	a1 b4 7f 19 80       	mov    0x80197fb4,%eax
80108c2d:	05 00 01 00 00       	add    $0x100,%eax
80108c32:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  *rctl = (I8254_RCTL_UPE | I8254_RCTL_MPE | I8254_RCTL_BAM | I8254_RCTL_BSIZE | I8254_RCTL_SECRC);
80108c35:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80108c38:	c7 00 18 80 00 04    	movl   $0x4008018,(%eax)

  uint recv_desc_addr = (uint)kalloc();
80108c3e:	e8 4f 9c ff ff       	call   80102892 <kalloc>
80108c43:	89 45 b0             	mov    %eax,-0x50(%ebp)
  uint *rdbal = (uint *)(base_addr + 0x2800);
80108c46:	a1 b4 7f 19 80       	mov    0x80197fb4,%eax
80108c4b:	05 00 28 00 00       	add    $0x2800,%eax
80108c50:	89 45 ac             	mov    %eax,-0x54(%ebp)
  uint *rdbah = (uint *)(base_addr + 0x2804);
80108c53:	a1 b4 7f 19 80       	mov    0x80197fb4,%eax
80108c58:	05 04 28 00 00       	add    $0x2804,%eax
80108c5d:	89 45 a8             	mov    %eax,-0x58(%ebp)
  uint *rdlen = (uint *)(base_addr + 0x2808);
80108c60:	a1 b4 7f 19 80       	mov    0x80197fb4,%eax
80108c65:	05 08 28 00 00       	add    $0x2808,%eax
80108c6a:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  uint *rdh = (uint *)(base_addr + 0x2810);
80108c6d:	a1 b4 7f 19 80       	mov    0x80197fb4,%eax
80108c72:	05 10 28 00 00       	add    $0x2810,%eax
80108c77:	89 45 a0             	mov    %eax,-0x60(%ebp)
  uint *rdt = (uint *)(base_addr + 0x2818);
80108c7a:	a1 b4 7f 19 80       	mov    0x80197fb4,%eax
80108c7f:	05 18 28 00 00       	add    $0x2818,%eax
80108c84:	89 45 9c             	mov    %eax,-0x64(%ebp)

  *rdbal = V2P(recv_desc_addr);
80108c87:	8b 45 b0             	mov    -0x50(%ebp),%eax
80108c8a:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80108c90:	8b 45 ac             	mov    -0x54(%ebp),%eax
80108c93:	89 10                	mov    %edx,(%eax)
  *rdbah = 0;
80108c95:	8b 45 a8             	mov    -0x58(%ebp),%eax
80108c98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *rdlen = sizeof(struct i8254_recv_desc)*I8254_RECV_DESC_NUM;
80108c9e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80108ca1:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  *rdh = 0;
80108ca7:	8b 45 a0             	mov    -0x60(%ebp),%eax
80108caa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *rdt = I8254_RECV_DESC_NUM;
80108cb0:	8b 45 9c             	mov    -0x64(%ebp),%eax
80108cb3:	c7 00 00 01 00 00    	movl   $0x100,(%eax)

  struct i8254_recv_desc *recv_desc = (struct i8254_recv_desc *)recv_desc_addr;
80108cb9:	8b 45 b0             	mov    -0x50(%ebp),%eax
80108cbc:	89 45 98             	mov    %eax,-0x68(%ebp)
  for(int i=0;i<I8254_RECV_DESC_NUM;i++){
80108cbf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80108cc6:	eb 73                	jmp    80108d3b <i8254_init_recv+0x28b>
    recv_desc[i].padding = 0;
80108cc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108ccb:	c1 e0 04             	shl    $0x4,%eax
80108cce:	89 c2                	mov    %eax,%edx
80108cd0:	8b 45 98             	mov    -0x68(%ebp),%eax
80108cd3:	01 d0                	add    %edx,%eax
80108cd5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    recv_desc[i].len = 0;
80108cdc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108cdf:	c1 e0 04             	shl    $0x4,%eax
80108ce2:	89 c2                	mov    %eax,%edx
80108ce4:	8b 45 98             	mov    -0x68(%ebp),%eax
80108ce7:	01 d0                	add    %edx,%eax
80108ce9:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
    recv_desc[i].chk_sum = 0;
80108cef:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108cf2:	c1 e0 04             	shl    $0x4,%eax
80108cf5:	89 c2                	mov    %eax,%edx
80108cf7:	8b 45 98             	mov    -0x68(%ebp),%eax
80108cfa:	01 d0                	add    %edx,%eax
80108cfc:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
    recv_desc[i].status = 0;
80108d02:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108d05:	c1 e0 04             	shl    $0x4,%eax
80108d08:	89 c2                	mov    %eax,%edx
80108d0a:	8b 45 98             	mov    -0x68(%ebp),%eax
80108d0d:	01 d0                	add    %edx,%eax
80108d0f:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    recv_desc[i].errors = 0;
80108d13:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108d16:	c1 e0 04             	shl    $0x4,%eax
80108d19:	89 c2                	mov    %eax,%edx
80108d1b:	8b 45 98             	mov    -0x68(%ebp),%eax
80108d1e:	01 d0                	add    %edx,%eax
80108d20:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    recv_desc[i].special = 0;
80108d24:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108d27:	c1 e0 04             	shl    $0x4,%eax
80108d2a:	89 c2                	mov    %eax,%edx
80108d2c:	8b 45 98             	mov    -0x68(%ebp),%eax
80108d2f:	01 d0                	add    %edx,%eax
80108d31:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
  for(int i=0;i<I8254_RECV_DESC_NUM;i++){
80108d37:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
80108d3b:	81 7d e0 ff 00 00 00 	cmpl   $0xff,-0x20(%ebp)
80108d42:	7e 84                	jle    80108cc8 <i8254_init_recv+0x218>
  }

  for(int i=0;i<(I8254_RECV_DESC_NUM)/2;i++){
80108d44:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
80108d4b:	eb 57                	jmp    80108da4 <i8254_init_recv+0x2f4>
    uint buf_addr = (uint)kalloc();
80108d4d:	e8 40 9b ff ff       	call   80102892 <kalloc>
80108d52:	89 45 94             	mov    %eax,-0x6c(%ebp)
    if(buf_addr == 0){
80108d55:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
80108d59:	75 12                	jne    80108d6d <i8254_init_recv+0x2bd>
      cprintf("failed to allocate buffer area\n");
80108d5b:	83 ec 0c             	sub    $0xc,%esp
80108d5e:	68 38 c5 10 80       	push   $0x8010c538
80108d63:	e8 a4 76 ff ff       	call   8010040c <cprintf>
80108d68:	83 c4 10             	add    $0x10,%esp
      break;
80108d6b:	eb 3d                	jmp    80108daa <i8254_init_recv+0x2fa>
    }
    recv_desc[i].buf_addr = V2P(buf_addr);
80108d6d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108d70:	c1 e0 04             	shl    $0x4,%eax
80108d73:	89 c2                	mov    %eax,%edx
80108d75:	8b 45 98             	mov    -0x68(%ebp),%eax
80108d78:	01 d0                	add    %edx,%eax
80108d7a:	8b 55 94             	mov    -0x6c(%ebp),%edx
80108d7d:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108d83:	89 10                	mov    %edx,(%eax)
    recv_desc[i+1].buf_addr = V2P(buf_addr + 0x800);
80108d85:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108d88:	83 c0 01             	add    $0x1,%eax
80108d8b:	c1 e0 04             	shl    $0x4,%eax
80108d8e:	89 c2                	mov    %eax,%edx
80108d90:	8b 45 98             	mov    -0x68(%ebp),%eax
80108d93:	01 d0                	add    %edx,%eax
80108d95:	8b 55 94             	mov    -0x6c(%ebp),%edx
80108d98:	81 ea 00 f8 ff 7f    	sub    $0x7ffff800,%edx
80108d9e:	89 10                	mov    %edx,(%eax)
  for(int i=0;i<(I8254_RECV_DESC_NUM)/2;i++){
80108da0:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
80108da4:	83 7d dc 7f          	cmpl   $0x7f,-0x24(%ebp)
80108da8:	7e a3                	jle    80108d4d <i8254_init_recv+0x29d>
  }

  *rctl |= I8254_RCTL_EN;
80108daa:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80108dad:	8b 00                	mov    (%eax),%eax
80108daf:	83 c8 02             	or     $0x2,%eax
80108db2:	89 c2                	mov    %eax,%edx
80108db4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80108db7:	89 10                	mov    %edx,(%eax)
  cprintf("E1000 Recieve Initialize Done\n");
80108db9:	83 ec 0c             	sub    $0xc,%esp
80108dbc:	68 58 c5 10 80       	push   $0x8010c558
80108dc1:	e8 46 76 ff ff       	call   8010040c <cprintf>
80108dc6:	83 c4 10             	add    $0x10,%esp
}
80108dc9:	90                   	nop
80108dca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108dcd:	5b                   	pop    %ebx
80108dce:	5e                   	pop    %esi
80108dcf:	5f                   	pop    %edi
80108dd0:	5d                   	pop    %ebp
80108dd1:	c3                   	ret    

80108dd2 <i8254_init_send>:

void i8254_init_send(){
80108dd2:	f3 0f 1e fb          	endbr32 
80108dd6:	55                   	push   %ebp
80108dd7:	89 e5                	mov    %esp,%ebp
80108dd9:	83 ec 48             	sub    $0x48,%esp
  uint *txdctl = (uint *)(base_addr + 0x3828);
80108ddc:	a1 b4 7f 19 80       	mov    0x80197fb4,%eax
80108de1:	05 28 38 00 00       	add    $0x3828,%eax
80108de6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  *txdctl = (I8254_TXDCTL_WTHRESH | I8254_TXDCTL_GRAN_DESC);
80108de9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108dec:	c7 00 00 00 01 01    	movl   $0x1010000,(%eax)

  uint tx_desc_addr = (uint)kalloc();
80108df2:	e8 9b 9a ff ff       	call   80102892 <kalloc>
80108df7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  uint *tdbal = (uint *)(base_addr + 0x3800);
80108dfa:	a1 b4 7f 19 80       	mov    0x80197fb4,%eax
80108dff:	05 00 38 00 00       	add    $0x3800,%eax
80108e04:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint *tdbah = (uint *)(base_addr + 0x3804);
80108e07:	a1 b4 7f 19 80       	mov    0x80197fb4,%eax
80108e0c:	05 04 38 00 00       	add    $0x3804,%eax
80108e11:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint *tdlen = (uint *)(base_addr + 0x3808);
80108e14:	a1 b4 7f 19 80       	mov    0x80197fb4,%eax
80108e19:	05 08 38 00 00       	add    $0x3808,%eax
80108e1e:	89 45 dc             	mov    %eax,-0x24(%ebp)

  *tdbal = V2P(tx_desc_addr);
80108e21:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108e24:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80108e2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108e2d:	89 10                	mov    %edx,(%eax)
  *tdbah = 0;
80108e2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108e32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *tdlen = sizeof(struct i8254_send_desc)*I8254_SEND_DESC_NUM;
80108e38:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108e3b:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  uint *tdh = (uint *)(base_addr + 0x3810);
80108e41:	a1 b4 7f 19 80       	mov    0x80197fb4,%eax
80108e46:	05 10 38 00 00       	add    $0x3810,%eax
80108e4b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  uint *tdt = (uint *)(base_addr + 0x3818);
80108e4e:	a1 b4 7f 19 80       	mov    0x80197fb4,%eax
80108e53:	05 18 38 00 00       	add    $0x3818,%eax
80108e58:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  
  *tdh = 0;
80108e5b:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108e5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *tdt = 0;
80108e64:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108e67:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  struct i8254_send_desc *send_desc = (struct i8254_send_desc *)tx_desc_addr;
80108e6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108e70:	89 45 d0             	mov    %eax,-0x30(%ebp)
  for(int i=0;i<I8254_SEND_DESC_NUM;i++){
80108e73:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108e7a:	e9 82 00 00 00       	jmp    80108f01 <i8254_init_send+0x12f>
    send_desc[i].padding = 0;
80108e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e82:	c1 e0 04             	shl    $0x4,%eax
80108e85:	89 c2                	mov    %eax,%edx
80108e87:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108e8a:	01 d0                	add    %edx,%eax
80108e8c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    send_desc[i].len = 0;
80108e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e96:	c1 e0 04             	shl    $0x4,%eax
80108e99:	89 c2                	mov    %eax,%edx
80108e9b:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108e9e:	01 d0                	add    %edx,%eax
80108ea0:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
    send_desc[i].cso = 0;
80108ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ea9:	c1 e0 04             	shl    $0x4,%eax
80108eac:	89 c2                	mov    %eax,%edx
80108eae:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108eb1:	01 d0                	add    %edx,%eax
80108eb3:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
    send_desc[i].cmd = 0;
80108eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108eba:	c1 e0 04             	shl    $0x4,%eax
80108ebd:	89 c2                	mov    %eax,%edx
80108ebf:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108ec2:	01 d0                	add    %edx,%eax
80108ec4:	c6 40 0b 00          	movb   $0x0,0xb(%eax)
    send_desc[i].sta = 0;
80108ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ecb:	c1 e0 04             	shl    $0x4,%eax
80108ece:	89 c2                	mov    %eax,%edx
80108ed0:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108ed3:	01 d0                	add    %edx,%eax
80108ed5:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    send_desc[i].css = 0;
80108ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108edc:	c1 e0 04             	shl    $0x4,%eax
80108edf:	89 c2                	mov    %eax,%edx
80108ee1:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108ee4:	01 d0                	add    %edx,%eax
80108ee6:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    send_desc[i].special = 0;
80108eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108eed:	c1 e0 04             	shl    $0x4,%eax
80108ef0:	89 c2                	mov    %eax,%edx
80108ef2:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108ef5:	01 d0                	add    %edx,%eax
80108ef7:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
  for(int i=0;i<I8254_SEND_DESC_NUM;i++){
80108efd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108f01:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80108f08:	0f 8e 71 ff ff ff    	jle    80108e7f <i8254_init_send+0xad>
  }

  for(int i=0;i<(I8254_SEND_DESC_NUM)/2;i++){
80108f0e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80108f15:	eb 57                	jmp    80108f6e <i8254_init_send+0x19c>
    uint buf_addr = (uint)kalloc();
80108f17:	e8 76 99 ff ff       	call   80102892 <kalloc>
80108f1c:	89 45 cc             	mov    %eax,-0x34(%ebp)
    if(buf_addr == 0){
80108f1f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
80108f23:	75 12                	jne    80108f37 <i8254_init_send+0x165>
      cprintf("failed to allocate buffer area\n");
80108f25:	83 ec 0c             	sub    $0xc,%esp
80108f28:	68 38 c5 10 80       	push   $0x8010c538
80108f2d:	e8 da 74 ff ff       	call   8010040c <cprintf>
80108f32:	83 c4 10             	add    $0x10,%esp
      break;
80108f35:	eb 3d                	jmp    80108f74 <i8254_init_send+0x1a2>
    }
    send_desc[i].buf_addr = V2P(buf_addr);
80108f37:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f3a:	c1 e0 04             	shl    $0x4,%eax
80108f3d:	89 c2                	mov    %eax,%edx
80108f3f:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108f42:	01 d0                	add    %edx,%eax
80108f44:	8b 55 cc             	mov    -0x34(%ebp),%edx
80108f47:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108f4d:	89 10                	mov    %edx,(%eax)
    send_desc[i+1].buf_addr = V2P(buf_addr + 0x800);
80108f4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f52:	83 c0 01             	add    $0x1,%eax
80108f55:	c1 e0 04             	shl    $0x4,%eax
80108f58:	89 c2                	mov    %eax,%edx
80108f5a:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108f5d:	01 d0                	add    %edx,%eax
80108f5f:	8b 55 cc             	mov    -0x34(%ebp),%edx
80108f62:	81 ea 00 f8 ff 7f    	sub    $0x7ffff800,%edx
80108f68:	89 10                	mov    %edx,(%eax)
  for(int i=0;i<(I8254_SEND_DESC_NUM)/2;i++){
80108f6a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80108f6e:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
80108f72:	7e a3                	jle    80108f17 <i8254_init_send+0x145>
  }

  uint *tctl = (uint *)(base_addr + 0x400);
80108f74:	a1 b4 7f 19 80       	mov    0x80197fb4,%eax
80108f79:	05 00 04 00 00       	add    $0x400,%eax
80108f7e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  *tctl = (I8254_TCTL_EN | I8254_TCTL_PSP | I8254_TCTL_COLD | I8254_TCTL_CT);
80108f81:	8b 45 c8             	mov    -0x38(%ebp),%eax
80108f84:	c7 00 fa 00 04 00    	movl   $0x400fa,(%eax)

  uint *tipg = (uint *)(base_addr + 0x410);
80108f8a:	a1 b4 7f 19 80       	mov    0x80197fb4,%eax
80108f8f:	05 10 04 00 00       	add    $0x410,%eax
80108f94:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  *tipg = (10 | (10<<10) | (10<<20));
80108f97:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80108f9a:	c7 00 0a 28 a0 00    	movl   $0xa0280a,(%eax)
  cprintf("E1000 Transmit Initialize Done\n");
80108fa0:	83 ec 0c             	sub    $0xc,%esp
80108fa3:	68 78 c5 10 80       	push   $0x8010c578
80108fa8:	e8 5f 74 ff ff       	call   8010040c <cprintf>
80108fad:	83 c4 10             	add    $0x10,%esp

}
80108fb0:	90                   	nop
80108fb1:	c9                   	leave  
80108fb2:	c3                   	ret    

80108fb3 <i8254_read_eeprom>:
uint i8254_read_eeprom(uint addr){
80108fb3:	f3 0f 1e fb          	endbr32 
80108fb7:	55                   	push   %ebp
80108fb8:	89 e5                	mov    %esp,%ebp
80108fba:	83 ec 18             	sub    $0x18,%esp
  uint *eerd = (uint *)(base_addr + 0x14);
80108fbd:	a1 b4 7f 19 80       	mov    0x80197fb4,%eax
80108fc2:	83 c0 14             	add    $0x14,%eax
80108fc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  *eerd = (((addr & 0xFF) << 8) | 1);
80108fc8:	8b 45 08             	mov    0x8(%ebp),%eax
80108fcb:	c1 e0 08             	shl    $0x8,%eax
80108fce:	0f b7 c0             	movzwl %ax,%eax
80108fd1:	83 c8 01             	or     $0x1,%eax
80108fd4:	89 c2                	mov    %eax,%edx
80108fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fd9:	89 10                	mov    %edx,(%eax)
  while(1){
    cprintf("");
80108fdb:	83 ec 0c             	sub    $0xc,%esp
80108fde:	68 98 c5 10 80       	push   $0x8010c598
80108fe3:	e8 24 74 ff ff       	call   8010040c <cprintf>
80108fe8:	83 c4 10             	add    $0x10,%esp
    volatile uint data = *eerd;
80108feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fee:	8b 00                	mov    (%eax),%eax
80108ff0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((data & (1<<4)) != 0){
80108ff3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ff6:	83 e0 10             	and    $0x10,%eax
80108ff9:	85 c0                	test   %eax,%eax
80108ffb:	75 02                	jne    80108fff <i8254_read_eeprom+0x4c>
  while(1){
80108ffd:	eb dc                	jmp    80108fdb <i8254_read_eeprom+0x28>
      break;
80108fff:	90                   	nop
    }
  }

  return (*eerd >> 16) & 0xFFFF;
80109000:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109003:	8b 00                	mov    (%eax),%eax
80109005:	c1 e8 10             	shr    $0x10,%eax
}
80109008:	c9                   	leave  
80109009:	c3                   	ret    

8010900a <i8254_recv>:
void i8254_recv(){
8010900a:	f3 0f 1e fb          	endbr32 
8010900e:	55                   	push   %ebp
8010900f:	89 e5                	mov    %esp,%ebp
80109011:	83 ec 28             	sub    $0x28,%esp
  uint *rdh = (uint *)(base_addr + 0x2810);
80109014:	a1 b4 7f 19 80       	mov    0x80197fb4,%eax
80109019:	05 10 28 00 00       	add    $0x2810,%eax
8010901e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint *rdt = (uint *)(base_addr + 0x2818);
80109021:	a1 b4 7f 19 80       	mov    0x80197fb4,%eax
80109026:	05 18 28 00 00       	add    $0x2818,%eax
8010902b:	89 45 f0             	mov    %eax,-0x10(%ebp)
//  uint *torl = (uint *)(base_addr + 0x40C0);
//  uint *tpr = (uint *)(base_addr + 0x40D0);
//  uint *icr = (uint *)(base_addr + 0xC0);
  uint *rdbal = (uint *)(base_addr + 0x2800);
8010902e:	a1 b4 7f 19 80       	mov    0x80197fb4,%eax
80109033:	05 00 28 00 00       	add    $0x2800,%eax
80109038:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct i8254_recv_desc *recv_desc = (struct i8254_recv_desc *)(P2V(*rdbal));
8010903b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010903e:	8b 00                	mov    (%eax),%eax
80109040:	05 00 00 00 80       	add    $0x80000000,%eax
80109045:	89 45 e8             	mov    %eax,-0x18(%ebp)
  while(1){
    int rx_available = (I8254_RECV_DESC_NUM - *rdt + *rdh)%I8254_RECV_DESC_NUM;
80109048:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010904b:	8b 10                	mov    (%eax),%edx
8010904d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109050:	8b 00                	mov    (%eax),%eax
80109052:	29 c2                	sub    %eax,%edx
80109054:	89 d0                	mov    %edx,%eax
80109056:	25 ff 00 00 00       	and    $0xff,%eax
8010905b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(rx_available > 0){
8010905e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80109062:	7e 37                	jle    8010909b <i8254_recv+0x91>
      uint buffer_addr = P2V_WO(recv_desc[*rdt].buf_addr);
80109064:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109067:	8b 00                	mov    (%eax),%eax
80109069:	c1 e0 04             	shl    $0x4,%eax
8010906c:	89 c2                	mov    %eax,%edx
8010906e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109071:	01 d0                	add    %edx,%eax
80109073:	8b 00                	mov    (%eax),%eax
80109075:	05 00 00 00 80       	add    $0x80000000,%eax
8010907a:	89 45 e0             	mov    %eax,-0x20(%ebp)
      *rdt = (*rdt + 1)%I8254_RECV_DESC_NUM;
8010907d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109080:	8b 00                	mov    (%eax),%eax
80109082:	83 c0 01             	add    $0x1,%eax
80109085:	0f b6 d0             	movzbl %al,%edx
80109088:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010908b:	89 10                	mov    %edx,(%eax)
      eth_proc(buffer_addr);
8010908d:	83 ec 0c             	sub    $0xc,%esp
80109090:	ff 75 e0             	pushl  -0x20(%ebp)
80109093:	e8 47 09 00 00       	call   801099df <eth_proc>
80109098:	83 c4 10             	add    $0x10,%esp
    }
    if(*rdt == *rdh) {
8010909b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010909e:	8b 10                	mov    (%eax),%edx
801090a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090a3:	8b 00                	mov    (%eax),%eax
801090a5:	39 c2                	cmp    %eax,%edx
801090a7:	75 9f                	jne    80109048 <i8254_recv+0x3e>
      (*rdt)--;
801090a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090ac:	8b 00                	mov    (%eax),%eax
801090ae:	8d 50 ff             	lea    -0x1(%eax),%edx
801090b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090b4:	89 10                	mov    %edx,(%eax)
  while(1){
801090b6:	eb 90                	jmp    80109048 <i8254_recv+0x3e>

801090b8 <i8254_send>:
    }
  }
}

int i8254_send(const uint pkt_addr,uint len){
801090b8:	f3 0f 1e fb          	endbr32 
801090bc:	55                   	push   %ebp
801090bd:	89 e5                	mov    %esp,%ebp
801090bf:	83 ec 28             	sub    $0x28,%esp
  uint *tdh = (uint *)(base_addr + 0x3810);
801090c2:	a1 b4 7f 19 80       	mov    0x80197fb4,%eax
801090c7:	05 10 38 00 00       	add    $0x3810,%eax
801090cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint *tdt = (uint *)(base_addr + 0x3818);
801090cf:	a1 b4 7f 19 80       	mov    0x80197fb4,%eax
801090d4:	05 18 38 00 00       	add    $0x3818,%eax
801090d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  uint *tdbal = (uint *)(base_addr + 0x3800);
801090dc:	a1 b4 7f 19 80       	mov    0x80197fb4,%eax
801090e1:	05 00 38 00 00       	add    $0x3800,%eax
801090e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct i8254_send_desc *txdesc = (struct i8254_send_desc *)P2V_WO(*tdbal);
801090e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801090ec:	8b 00                	mov    (%eax),%eax
801090ee:	05 00 00 00 80       	add    $0x80000000,%eax
801090f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  int tx_available = I8254_SEND_DESC_NUM - ((I8254_SEND_DESC_NUM - *tdh + *tdt) % I8254_SEND_DESC_NUM);
801090f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090f9:	8b 10                	mov    (%eax),%edx
801090fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090fe:	8b 00                	mov    (%eax),%eax
80109100:	29 c2                	sub    %eax,%edx
80109102:	89 d0                	mov    %edx,%eax
80109104:	0f b6 c0             	movzbl %al,%eax
80109107:	ba 00 01 00 00       	mov    $0x100,%edx
8010910c:	29 c2                	sub    %eax,%edx
8010910e:	89 d0                	mov    %edx,%eax
80109110:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint index = *tdt%I8254_SEND_DESC_NUM;
80109113:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109116:	8b 00                	mov    (%eax),%eax
80109118:	25 ff 00 00 00       	and    $0xff,%eax
8010911d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(tx_available > 0) {
80109120:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80109124:	0f 8e a8 00 00 00    	jle    801091d2 <i8254_send+0x11a>
    memmove(P2V_WO((void *)txdesc[index].buf_addr),(void *)pkt_addr,len);
8010912a:	8b 45 08             	mov    0x8(%ebp),%eax
8010912d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109130:	89 d1                	mov    %edx,%ecx
80109132:	c1 e1 04             	shl    $0x4,%ecx
80109135:	8b 55 e8             	mov    -0x18(%ebp),%edx
80109138:	01 ca                	add    %ecx,%edx
8010913a:	8b 12                	mov    (%edx),%edx
8010913c:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80109142:	83 ec 04             	sub    $0x4,%esp
80109145:	ff 75 0c             	pushl  0xc(%ebp)
80109148:	50                   	push   %eax
80109149:	52                   	push   %edx
8010914a:	e8 4f bc ff ff       	call   80104d9e <memmove>
8010914f:	83 c4 10             	add    $0x10,%esp
    txdesc[index].len = len;
80109152:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109155:	c1 e0 04             	shl    $0x4,%eax
80109158:	89 c2                	mov    %eax,%edx
8010915a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010915d:	01 d0                	add    %edx,%eax
8010915f:	8b 55 0c             	mov    0xc(%ebp),%edx
80109162:	66 89 50 08          	mov    %dx,0x8(%eax)
    txdesc[index].sta = 0;
80109166:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109169:	c1 e0 04             	shl    $0x4,%eax
8010916c:	89 c2                	mov    %eax,%edx
8010916e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109171:	01 d0                	add    %edx,%eax
80109173:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    txdesc[index].css = 0;
80109177:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010917a:	c1 e0 04             	shl    $0x4,%eax
8010917d:	89 c2                	mov    %eax,%edx
8010917f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109182:	01 d0                	add    %edx,%eax
80109184:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    txdesc[index].cmd = 0xb;
80109188:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010918b:	c1 e0 04             	shl    $0x4,%eax
8010918e:	89 c2                	mov    %eax,%edx
80109190:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109193:	01 d0                	add    %edx,%eax
80109195:	c6 40 0b 0b          	movb   $0xb,0xb(%eax)
    txdesc[index].special = 0;
80109199:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010919c:	c1 e0 04             	shl    $0x4,%eax
8010919f:	89 c2                	mov    %eax,%edx
801091a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801091a4:	01 d0                	add    %edx,%eax
801091a6:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
    txdesc[index].cso = 0;
801091ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
801091af:	c1 e0 04             	shl    $0x4,%eax
801091b2:	89 c2                	mov    %eax,%edx
801091b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801091b7:	01 d0                	add    %edx,%eax
801091b9:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
    *tdt = (*tdt + 1)%I8254_SEND_DESC_NUM;
801091bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801091c0:	8b 00                	mov    (%eax),%eax
801091c2:	83 c0 01             	add    $0x1,%eax
801091c5:	0f b6 d0             	movzbl %al,%edx
801091c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801091cb:	89 10                	mov    %edx,(%eax)
    return len;
801091cd:	8b 45 0c             	mov    0xc(%ebp),%eax
801091d0:	eb 05                	jmp    801091d7 <i8254_send+0x11f>
  }else{
    return -1;
801091d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
801091d7:	c9                   	leave  
801091d8:	c3                   	ret    

801091d9 <i8254_intr>:

void i8254_intr(){
801091d9:	f3 0f 1e fb          	endbr32 
801091dd:	55                   	push   %ebp
801091de:	89 e5                	mov    %esp,%ebp
  *intr_addr = 0xEEEEEE;
801091e0:	a1 b8 7f 19 80       	mov    0x80197fb8,%eax
801091e5:	c7 00 ee ee ee 00    	movl   $0xeeeeee,(%eax)
}
801091eb:	90                   	nop
801091ec:	5d                   	pop    %ebp
801091ed:	c3                   	ret    

801091ee <arp_proc>:
extern uchar mac_addr[6];
extern uchar my_ip[4];

struct arp_entry arp_table[ARP_TABLE_MAX] = {0};

int arp_proc(uint buffer_addr){
801091ee:	f3 0f 1e fb          	endbr32 
801091f2:	55                   	push   %ebp
801091f3:	89 e5                	mov    %esp,%ebp
801091f5:	83 ec 18             	sub    $0x18,%esp
  struct arp_pkt *arp_p = (struct arp_pkt *)(buffer_addr);
801091f8:	8b 45 08             	mov    0x8(%ebp),%eax
801091fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(arp_p->hrd_type != ARP_HARDWARE_TYPE) return -1;
801091fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109201:	0f b7 00             	movzwl (%eax),%eax
80109204:	66 3d 00 01          	cmp    $0x100,%ax
80109208:	74 0a                	je     80109214 <arp_proc+0x26>
8010920a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010920f:	e9 4f 01 00 00       	jmp    80109363 <arp_proc+0x175>
  if(arp_p->pro_type != ARP_PROTOCOL_TYPE) return -1;
80109214:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109217:	0f b7 40 02          	movzwl 0x2(%eax),%eax
8010921b:	66 83 f8 08          	cmp    $0x8,%ax
8010921f:	74 0a                	je     8010922b <arp_proc+0x3d>
80109221:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109226:	e9 38 01 00 00       	jmp    80109363 <arp_proc+0x175>
  if(arp_p->hrd_len != 6) return -1;
8010922b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010922e:	0f b6 40 04          	movzbl 0x4(%eax),%eax
80109232:	3c 06                	cmp    $0x6,%al
80109234:	74 0a                	je     80109240 <arp_proc+0x52>
80109236:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010923b:	e9 23 01 00 00       	jmp    80109363 <arp_proc+0x175>
  if(arp_p->pro_len != 4) return -1;
80109240:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109243:	0f b6 40 05          	movzbl 0x5(%eax),%eax
80109247:	3c 04                	cmp    $0x4,%al
80109249:	74 0a                	je     80109255 <arp_proc+0x67>
8010924b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109250:	e9 0e 01 00 00       	jmp    80109363 <arp_proc+0x175>
  if(memcmp(my_ip,arp_p->dst_ip,4) != 0 && memcmp(my_ip,arp_p->src_ip,4) != 0) return -1;
80109255:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109258:	83 c0 18             	add    $0x18,%eax
8010925b:	83 ec 04             	sub    $0x4,%esp
8010925e:	6a 04                	push   $0x4
80109260:	50                   	push   %eax
80109261:	68 e4 f4 10 80       	push   $0x8010f4e4
80109266:	e8 d7 ba ff ff       	call   80104d42 <memcmp>
8010926b:	83 c4 10             	add    $0x10,%esp
8010926e:	85 c0                	test   %eax,%eax
80109270:	74 27                	je     80109299 <arp_proc+0xab>
80109272:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109275:	83 c0 0e             	add    $0xe,%eax
80109278:	83 ec 04             	sub    $0x4,%esp
8010927b:	6a 04                	push   $0x4
8010927d:	50                   	push   %eax
8010927e:	68 e4 f4 10 80       	push   $0x8010f4e4
80109283:	e8 ba ba ff ff       	call   80104d42 <memcmp>
80109288:	83 c4 10             	add    $0x10,%esp
8010928b:	85 c0                	test   %eax,%eax
8010928d:	74 0a                	je     80109299 <arp_proc+0xab>
8010928f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109294:	e9 ca 00 00 00       	jmp    80109363 <arp_proc+0x175>
  if(arp_p->op == ARP_OPS_REQUEST && memcmp(my_ip,arp_p->dst_ip,4) == 0){
80109299:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010929c:	0f b7 40 06          	movzwl 0x6(%eax),%eax
801092a0:	66 3d 00 01          	cmp    $0x100,%ax
801092a4:	75 69                	jne    8010930f <arp_proc+0x121>
801092a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092a9:	83 c0 18             	add    $0x18,%eax
801092ac:	83 ec 04             	sub    $0x4,%esp
801092af:	6a 04                	push   $0x4
801092b1:	50                   	push   %eax
801092b2:	68 e4 f4 10 80       	push   $0x8010f4e4
801092b7:	e8 86 ba ff ff       	call   80104d42 <memcmp>
801092bc:	83 c4 10             	add    $0x10,%esp
801092bf:	85 c0                	test   %eax,%eax
801092c1:	75 4c                	jne    8010930f <arp_proc+0x121>
    uint send = (uint)kalloc();
801092c3:	e8 ca 95 ff ff       	call   80102892 <kalloc>
801092c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint send_size=0;
801092cb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    arp_reply_pkt_create(arp_p,send,&send_size);
801092d2:	83 ec 04             	sub    $0x4,%esp
801092d5:	8d 45 ec             	lea    -0x14(%ebp),%eax
801092d8:	50                   	push   %eax
801092d9:	ff 75 f0             	pushl  -0x10(%ebp)
801092dc:	ff 75 f4             	pushl  -0xc(%ebp)
801092df:	e8 33 04 00 00       	call   80109717 <arp_reply_pkt_create>
801092e4:	83 c4 10             	add    $0x10,%esp
    i8254_send(send,send_size);
801092e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801092ea:	83 ec 08             	sub    $0x8,%esp
801092ed:	50                   	push   %eax
801092ee:	ff 75 f0             	pushl  -0x10(%ebp)
801092f1:	e8 c2 fd ff ff       	call   801090b8 <i8254_send>
801092f6:	83 c4 10             	add    $0x10,%esp
    kfree((char *)send);
801092f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801092fc:	83 ec 0c             	sub    $0xc,%esp
801092ff:	50                   	push   %eax
80109300:	e8 ef 94 ff ff       	call   801027f4 <kfree>
80109305:	83 c4 10             	add    $0x10,%esp
    return ARP_CREATED_REPLY;
80109308:	b8 02 00 00 00       	mov    $0x2,%eax
8010930d:	eb 54                	jmp    80109363 <arp_proc+0x175>
  }else if(arp_p->op == ARP_OPS_REPLY && memcmp(my_ip,arp_p->dst_ip,4) == 0){
8010930f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109312:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80109316:	66 3d 00 02          	cmp    $0x200,%ax
8010931a:	75 42                	jne    8010935e <arp_proc+0x170>
8010931c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010931f:	83 c0 18             	add    $0x18,%eax
80109322:	83 ec 04             	sub    $0x4,%esp
80109325:	6a 04                	push   $0x4
80109327:	50                   	push   %eax
80109328:	68 e4 f4 10 80       	push   $0x8010f4e4
8010932d:	e8 10 ba ff ff       	call   80104d42 <memcmp>
80109332:	83 c4 10             	add    $0x10,%esp
80109335:	85 c0                	test   %eax,%eax
80109337:	75 25                	jne    8010935e <arp_proc+0x170>
    cprintf("ARP TABLE UPDATED\n");
80109339:	83 ec 0c             	sub    $0xc,%esp
8010933c:	68 9c c5 10 80       	push   $0x8010c59c
80109341:	e8 c6 70 ff ff       	call   8010040c <cprintf>
80109346:	83 c4 10             	add    $0x10,%esp
    arp_table_update(arp_p);
80109349:	83 ec 0c             	sub    $0xc,%esp
8010934c:	ff 75 f4             	pushl  -0xc(%ebp)
8010934f:	e8 b7 01 00 00       	call   8010950b <arp_table_update>
80109354:	83 c4 10             	add    $0x10,%esp
    return ARP_UPDATED_TABLE;
80109357:	b8 01 00 00 00       	mov    $0x1,%eax
8010935c:	eb 05                	jmp    80109363 <arp_proc+0x175>
  }else{
    return -1;
8010935e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
}
80109363:	c9                   	leave  
80109364:	c3                   	ret    

80109365 <arp_scan>:

void arp_scan(){
80109365:	f3 0f 1e fb          	endbr32 
80109369:	55                   	push   %ebp
8010936a:	89 e5                	mov    %esp,%ebp
8010936c:	83 ec 18             	sub    $0x18,%esp
  uint send_size;
  for(int i=0;i<256;i++){
8010936f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109376:	eb 6f                	jmp    801093e7 <arp_scan+0x82>
    uint send = (uint)kalloc();
80109378:	e8 15 95 ff ff       	call   80102892 <kalloc>
8010937d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    arp_broadcast(send,&send_size,i);
80109380:	83 ec 04             	sub    $0x4,%esp
80109383:	ff 75 f4             	pushl  -0xc(%ebp)
80109386:	8d 45 e8             	lea    -0x18(%ebp),%eax
80109389:	50                   	push   %eax
8010938a:	ff 75 ec             	pushl  -0x14(%ebp)
8010938d:	e8 62 00 00 00       	call   801093f4 <arp_broadcast>
80109392:	83 c4 10             	add    $0x10,%esp
    uint res = i8254_send(send,send_size);
80109395:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109398:	83 ec 08             	sub    $0x8,%esp
8010939b:	50                   	push   %eax
8010939c:	ff 75 ec             	pushl  -0x14(%ebp)
8010939f:	e8 14 fd ff ff       	call   801090b8 <i8254_send>
801093a4:	83 c4 10             	add    $0x10,%esp
801093a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(res == -1){
801093aa:	eb 22                	jmp    801093ce <arp_scan+0x69>
      microdelay(1);
801093ac:	83 ec 0c             	sub    $0xc,%esp
801093af:	6a 01                	push   $0x1
801093b1:	e8 8e 98 ff ff       	call   80102c44 <microdelay>
801093b6:	83 c4 10             	add    $0x10,%esp
      res = i8254_send(send,send_size);
801093b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801093bc:	83 ec 08             	sub    $0x8,%esp
801093bf:	50                   	push   %eax
801093c0:	ff 75 ec             	pushl  -0x14(%ebp)
801093c3:	e8 f0 fc ff ff       	call   801090b8 <i8254_send>
801093c8:	83 c4 10             	add    $0x10,%esp
801093cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(res == -1){
801093ce:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
801093d2:	74 d8                	je     801093ac <arp_scan+0x47>
    }
    kfree((char *)send);
801093d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801093d7:	83 ec 0c             	sub    $0xc,%esp
801093da:	50                   	push   %eax
801093db:	e8 14 94 ff ff       	call   801027f4 <kfree>
801093e0:	83 c4 10             	add    $0x10,%esp
  for(int i=0;i<256;i++){
801093e3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801093e7:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801093ee:	7e 88                	jle    80109378 <arp_scan+0x13>
  }
}
801093f0:	90                   	nop
801093f1:	90                   	nop
801093f2:	c9                   	leave  
801093f3:	c3                   	ret    

801093f4 <arp_broadcast>:

void arp_broadcast(uint send,uint *send_size,uint ip){
801093f4:	f3 0f 1e fb          	endbr32 
801093f8:	55                   	push   %ebp
801093f9:	89 e5                	mov    %esp,%ebp
801093fb:	83 ec 28             	sub    $0x28,%esp
  uchar dst_ip[4] = {10,0,1,ip};
801093fe:	c6 45 ec 0a          	movb   $0xa,-0x14(%ebp)
80109402:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
80109406:	c6 45 ee 01          	movb   $0x1,-0x12(%ebp)
8010940a:	8b 45 10             	mov    0x10(%ebp),%eax
8010940d:	88 45 ef             	mov    %al,-0x11(%ebp)
  uchar dst_mac_eth[6] = {0xff,0xff,0xff,0xff,0xff,0xff};
80109410:	c7 45 e6 ff ff ff ff 	movl   $0xffffffff,-0x1a(%ebp)
80109417:	66 c7 45 ea ff ff    	movw   $0xffff,-0x16(%ebp)
  uchar dst_mac_arp[6] = {0,0,0,0,0,0};
8010941d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80109424:	66 c7 45 e4 00 00    	movw   $0x0,-0x1c(%ebp)
  
  *send_size = sizeof(struct eth_pkt) + sizeof(struct arp_pkt);
8010942a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010942d:	c7 00 2c 00 00 00    	movl   $0x2c,(%eax)

  struct eth_pkt *reply_eth = (struct eth_pkt *)send;
80109433:	8b 45 08             	mov    0x8(%ebp),%eax
80109436:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct arp_pkt *reply_arp = (struct arp_pkt *)(send + sizeof(struct eth_pkt));
80109439:	8b 45 08             	mov    0x8(%ebp),%eax
8010943c:	83 c0 0e             	add    $0xe,%eax
8010943f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  reply_eth->type[0] = 0x08;
80109442:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109445:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  reply_eth->type[1] = 0x06;
80109449:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010944c:	c6 40 0d 06          	movb   $0x6,0xd(%eax)
  memmove(reply_eth->dst_mac,dst_mac_eth,6);
80109450:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109453:	83 ec 04             	sub    $0x4,%esp
80109456:	6a 06                	push   $0x6
80109458:	8d 55 e6             	lea    -0x1a(%ebp),%edx
8010945b:	52                   	push   %edx
8010945c:	50                   	push   %eax
8010945d:	e8 3c b9 ff ff       	call   80104d9e <memmove>
80109462:	83 c4 10             	add    $0x10,%esp
  memmove(reply_eth->src_mac,mac_addr,6);
80109465:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109468:	83 c0 06             	add    $0x6,%eax
8010946b:	83 ec 04             	sub    $0x4,%esp
8010946e:	6a 06                	push   $0x6
80109470:	68 68 d0 18 80       	push   $0x8018d068
80109475:	50                   	push   %eax
80109476:	e8 23 b9 ff ff       	call   80104d9e <memmove>
8010947b:	83 c4 10             	add    $0x10,%esp

  reply_arp->hrd_type = ARP_HARDWARE_TYPE;
8010947e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109481:	66 c7 00 00 01       	movw   $0x100,(%eax)
  reply_arp->pro_type = ARP_PROTOCOL_TYPE;
80109486:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109489:	66 c7 40 02 08 00    	movw   $0x8,0x2(%eax)
  reply_arp->hrd_len = 6;
8010948f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109492:	c6 40 04 06          	movb   $0x6,0x4(%eax)
  reply_arp->pro_len = 4;
80109496:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109499:	c6 40 05 04          	movb   $0x4,0x5(%eax)
  reply_arp->op = ARP_OPS_REQUEST;
8010949d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801094a0:	66 c7 40 06 00 01    	movw   $0x100,0x6(%eax)
  memmove(reply_arp->dst_mac,dst_mac_arp,6);
801094a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801094a9:	8d 50 12             	lea    0x12(%eax),%edx
801094ac:	83 ec 04             	sub    $0x4,%esp
801094af:	6a 06                	push   $0x6
801094b1:	8d 45 e0             	lea    -0x20(%ebp),%eax
801094b4:	50                   	push   %eax
801094b5:	52                   	push   %edx
801094b6:	e8 e3 b8 ff ff       	call   80104d9e <memmove>
801094bb:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->dst_ip,dst_ip,4);
801094be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801094c1:	8d 50 18             	lea    0x18(%eax),%edx
801094c4:	83 ec 04             	sub    $0x4,%esp
801094c7:	6a 04                	push   $0x4
801094c9:	8d 45 ec             	lea    -0x14(%ebp),%eax
801094cc:	50                   	push   %eax
801094cd:	52                   	push   %edx
801094ce:	e8 cb b8 ff ff       	call   80104d9e <memmove>
801094d3:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_mac,mac_addr,6);
801094d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801094d9:	83 c0 08             	add    $0x8,%eax
801094dc:	83 ec 04             	sub    $0x4,%esp
801094df:	6a 06                	push   $0x6
801094e1:	68 68 d0 18 80       	push   $0x8018d068
801094e6:	50                   	push   %eax
801094e7:	e8 b2 b8 ff ff       	call   80104d9e <memmove>
801094ec:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_ip,my_ip,4);
801094ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801094f2:	83 c0 0e             	add    $0xe,%eax
801094f5:	83 ec 04             	sub    $0x4,%esp
801094f8:	6a 04                	push   $0x4
801094fa:	68 e4 f4 10 80       	push   $0x8010f4e4
801094ff:	50                   	push   %eax
80109500:	e8 99 b8 ff ff       	call   80104d9e <memmove>
80109505:	83 c4 10             	add    $0x10,%esp
}
80109508:	90                   	nop
80109509:	c9                   	leave  
8010950a:	c3                   	ret    

8010950b <arp_table_update>:

void arp_table_update(struct arp_pkt *recv_arp){
8010950b:	f3 0f 1e fb          	endbr32 
8010950f:	55                   	push   %ebp
80109510:	89 e5                	mov    %esp,%ebp
80109512:	83 ec 18             	sub    $0x18,%esp
  int index = arp_table_search(recv_arp->src_ip);
80109515:	8b 45 08             	mov    0x8(%ebp),%eax
80109518:	83 c0 0e             	add    $0xe,%eax
8010951b:	83 ec 0c             	sub    $0xc,%esp
8010951e:	50                   	push   %eax
8010951f:	e8 bc 00 00 00       	call   801095e0 <arp_table_search>
80109524:	83 c4 10             	add    $0x10,%esp
80109527:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(index > -1){
8010952a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010952e:	78 2d                	js     8010955d <arp_table_update+0x52>
    memmove(arp_table[index].mac,recv_arp->src_mac,6);
80109530:	8b 45 08             	mov    0x8(%ebp),%eax
80109533:	8d 48 08             	lea    0x8(%eax),%ecx
80109536:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109539:	89 d0                	mov    %edx,%eax
8010953b:	c1 e0 02             	shl    $0x2,%eax
8010953e:	01 d0                	add    %edx,%eax
80109540:	01 c0                	add    %eax,%eax
80109542:	01 d0                	add    %edx,%eax
80109544:	05 80 d0 18 80       	add    $0x8018d080,%eax
80109549:	83 c0 04             	add    $0x4,%eax
8010954c:	83 ec 04             	sub    $0x4,%esp
8010954f:	6a 06                	push   $0x6
80109551:	51                   	push   %ecx
80109552:	50                   	push   %eax
80109553:	e8 46 b8 ff ff       	call   80104d9e <memmove>
80109558:	83 c4 10             	add    $0x10,%esp
8010955b:	eb 70                	jmp    801095cd <arp_table_update+0xc2>
  }else{
    index += 1;
8010955d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    index = -index;
80109561:	f7 5d f4             	negl   -0xc(%ebp)
    memmove(arp_table[index].mac,recv_arp->src_mac,6);
80109564:	8b 45 08             	mov    0x8(%ebp),%eax
80109567:	8d 48 08             	lea    0x8(%eax),%ecx
8010956a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010956d:	89 d0                	mov    %edx,%eax
8010956f:	c1 e0 02             	shl    $0x2,%eax
80109572:	01 d0                	add    %edx,%eax
80109574:	01 c0                	add    %eax,%eax
80109576:	01 d0                	add    %edx,%eax
80109578:	05 80 d0 18 80       	add    $0x8018d080,%eax
8010957d:	83 c0 04             	add    $0x4,%eax
80109580:	83 ec 04             	sub    $0x4,%esp
80109583:	6a 06                	push   $0x6
80109585:	51                   	push   %ecx
80109586:	50                   	push   %eax
80109587:	e8 12 b8 ff ff       	call   80104d9e <memmove>
8010958c:	83 c4 10             	add    $0x10,%esp
    memmove(arp_table[index].ip,recv_arp->src_ip,4);
8010958f:	8b 45 08             	mov    0x8(%ebp),%eax
80109592:	8d 48 0e             	lea    0xe(%eax),%ecx
80109595:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109598:	89 d0                	mov    %edx,%eax
8010959a:	c1 e0 02             	shl    $0x2,%eax
8010959d:	01 d0                	add    %edx,%eax
8010959f:	01 c0                	add    %eax,%eax
801095a1:	01 d0                	add    %edx,%eax
801095a3:	05 80 d0 18 80       	add    $0x8018d080,%eax
801095a8:	83 ec 04             	sub    $0x4,%esp
801095ab:	6a 04                	push   $0x4
801095ad:	51                   	push   %ecx
801095ae:	50                   	push   %eax
801095af:	e8 ea b7 ff ff       	call   80104d9e <memmove>
801095b4:	83 c4 10             	add    $0x10,%esp
    arp_table[index].use = 1;
801095b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801095ba:	89 d0                	mov    %edx,%eax
801095bc:	c1 e0 02             	shl    $0x2,%eax
801095bf:	01 d0                	add    %edx,%eax
801095c1:	01 c0                	add    %eax,%eax
801095c3:	01 d0                	add    %edx,%eax
801095c5:	05 8a d0 18 80       	add    $0x8018d08a,%eax
801095ca:	c6 00 01             	movb   $0x1,(%eax)
  }
  print_arp_table(arp_table);
801095cd:	83 ec 0c             	sub    $0xc,%esp
801095d0:	68 80 d0 18 80       	push   $0x8018d080
801095d5:	e8 87 00 00 00       	call   80109661 <print_arp_table>
801095da:	83 c4 10             	add    $0x10,%esp
}
801095dd:	90                   	nop
801095de:	c9                   	leave  
801095df:	c3                   	ret    

801095e0 <arp_table_search>:

int arp_table_search(uchar *ip){
801095e0:	f3 0f 1e fb          	endbr32 
801095e4:	55                   	push   %ebp
801095e5:	89 e5                	mov    %esp,%ebp
801095e7:	83 ec 18             	sub    $0x18,%esp
  int empty=1;
801095ea:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  for(int i=0;i<ARP_TABLE_MAX;i++){
801095f1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801095f8:	eb 59                	jmp    80109653 <arp_table_search+0x73>
    if(memcmp(arp_table[i].ip,ip,4) == 0){
801095fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
801095fd:	89 d0                	mov    %edx,%eax
801095ff:	c1 e0 02             	shl    $0x2,%eax
80109602:	01 d0                	add    %edx,%eax
80109604:	01 c0                	add    %eax,%eax
80109606:	01 d0                	add    %edx,%eax
80109608:	05 80 d0 18 80       	add    $0x8018d080,%eax
8010960d:	83 ec 04             	sub    $0x4,%esp
80109610:	6a 04                	push   $0x4
80109612:	ff 75 08             	pushl  0x8(%ebp)
80109615:	50                   	push   %eax
80109616:	e8 27 b7 ff ff       	call   80104d42 <memcmp>
8010961b:	83 c4 10             	add    $0x10,%esp
8010961e:	85 c0                	test   %eax,%eax
80109620:	75 05                	jne    80109627 <arp_table_search+0x47>
      return i;
80109622:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109625:	eb 38                	jmp    8010965f <arp_table_search+0x7f>
    }
    if(arp_table[i].use == 0 && empty == 1){
80109627:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010962a:	89 d0                	mov    %edx,%eax
8010962c:	c1 e0 02             	shl    $0x2,%eax
8010962f:	01 d0                	add    %edx,%eax
80109631:	01 c0                	add    %eax,%eax
80109633:	01 d0                	add    %edx,%eax
80109635:	05 8a d0 18 80       	add    $0x8018d08a,%eax
8010963a:	0f b6 00             	movzbl (%eax),%eax
8010963d:	84 c0                	test   %al,%al
8010963f:	75 0e                	jne    8010964f <arp_table_search+0x6f>
80109641:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80109645:	75 08                	jne    8010964f <arp_table_search+0x6f>
      empty = -i;
80109647:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010964a:	f7 d8                	neg    %eax
8010964c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(int i=0;i<ARP_TABLE_MAX;i++){
8010964f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80109653:	83 7d f0 3f          	cmpl   $0x3f,-0x10(%ebp)
80109657:	7e a1                	jle    801095fa <arp_table_search+0x1a>
    }
  }
  return empty-1;
80109659:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010965c:	83 e8 01             	sub    $0x1,%eax
}
8010965f:	c9                   	leave  
80109660:	c3                   	ret    

80109661 <print_arp_table>:

void print_arp_table(){
80109661:	f3 0f 1e fb          	endbr32 
80109665:	55                   	push   %ebp
80109666:	89 e5                	mov    %esp,%ebp
80109668:	83 ec 18             	sub    $0x18,%esp
  for(int i=0;i < ARP_TABLE_MAX;i++){
8010966b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109672:	e9 92 00 00 00       	jmp    80109709 <print_arp_table+0xa8>
    if(arp_table[i].use != 0){
80109677:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010967a:	89 d0                	mov    %edx,%eax
8010967c:	c1 e0 02             	shl    $0x2,%eax
8010967f:	01 d0                	add    %edx,%eax
80109681:	01 c0                	add    %eax,%eax
80109683:	01 d0                	add    %edx,%eax
80109685:	05 8a d0 18 80       	add    $0x8018d08a,%eax
8010968a:	0f b6 00             	movzbl (%eax),%eax
8010968d:	84 c0                	test   %al,%al
8010968f:	74 74                	je     80109705 <print_arp_table+0xa4>
      cprintf("Entry Num: %d ",i);
80109691:	83 ec 08             	sub    $0x8,%esp
80109694:	ff 75 f4             	pushl  -0xc(%ebp)
80109697:	68 af c5 10 80       	push   $0x8010c5af
8010969c:	e8 6b 6d ff ff       	call   8010040c <cprintf>
801096a1:	83 c4 10             	add    $0x10,%esp
      print_ipv4(arp_table[i].ip);
801096a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801096a7:	89 d0                	mov    %edx,%eax
801096a9:	c1 e0 02             	shl    $0x2,%eax
801096ac:	01 d0                	add    %edx,%eax
801096ae:	01 c0                	add    %eax,%eax
801096b0:	01 d0                	add    %edx,%eax
801096b2:	05 80 d0 18 80       	add    $0x8018d080,%eax
801096b7:	83 ec 0c             	sub    $0xc,%esp
801096ba:	50                   	push   %eax
801096bb:	e8 5c 02 00 00       	call   8010991c <print_ipv4>
801096c0:	83 c4 10             	add    $0x10,%esp
      cprintf(" ");
801096c3:	83 ec 0c             	sub    $0xc,%esp
801096c6:	68 be c5 10 80       	push   $0x8010c5be
801096cb:	e8 3c 6d ff ff       	call   8010040c <cprintf>
801096d0:	83 c4 10             	add    $0x10,%esp
      print_mac(arp_table[i].mac);
801096d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801096d6:	89 d0                	mov    %edx,%eax
801096d8:	c1 e0 02             	shl    $0x2,%eax
801096db:	01 d0                	add    %edx,%eax
801096dd:	01 c0                	add    %eax,%eax
801096df:	01 d0                	add    %edx,%eax
801096e1:	05 80 d0 18 80       	add    $0x8018d080,%eax
801096e6:	83 c0 04             	add    $0x4,%eax
801096e9:	83 ec 0c             	sub    $0xc,%esp
801096ec:	50                   	push   %eax
801096ed:	e8 7c 02 00 00       	call   8010996e <print_mac>
801096f2:	83 c4 10             	add    $0x10,%esp
      cprintf("\n");
801096f5:	83 ec 0c             	sub    $0xc,%esp
801096f8:	68 c0 c5 10 80       	push   $0x8010c5c0
801096fd:	e8 0a 6d ff ff       	call   8010040c <cprintf>
80109702:	83 c4 10             	add    $0x10,%esp
  for(int i=0;i < ARP_TABLE_MAX;i++){
80109705:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80109709:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
8010970d:	0f 8e 64 ff ff ff    	jle    80109677 <print_arp_table+0x16>
    }
  }
}
80109713:	90                   	nop
80109714:	90                   	nop
80109715:	c9                   	leave  
80109716:	c3                   	ret    

80109717 <arp_reply_pkt_create>:


void arp_reply_pkt_create(struct arp_pkt *arp_recv,uint send,uint *send_size){
80109717:	f3 0f 1e fb          	endbr32 
8010971b:	55                   	push   %ebp
8010971c:	89 e5                	mov    %esp,%ebp
8010971e:	83 ec 18             	sub    $0x18,%esp
  *send_size = sizeof(struct eth_pkt) + sizeof(struct arp_pkt);
80109721:	8b 45 10             	mov    0x10(%ebp),%eax
80109724:	c7 00 2c 00 00 00    	movl   $0x2c,(%eax)
  
  struct eth_pkt *reply_eth = (struct eth_pkt *)send;
8010972a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010972d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct arp_pkt *reply_arp = (struct arp_pkt *)(send + sizeof(struct eth_pkt));
80109730:	8b 45 0c             	mov    0xc(%ebp),%eax
80109733:	83 c0 0e             	add    $0xe,%eax
80109736:	89 45 f0             	mov    %eax,-0x10(%ebp)

  reply_eth->type[0] = 0x08;
80109739:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010973c:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  reply_eth->type[1] = 0x06;
80109740:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109743:	c6 40 0d 06          	movb   $0x6,0xd(%eax)
  memmove(reply_eth->dst_mac,arp_recv->src_mac,6);
80109747:	8b 45 08             	mov    0x8(%ebp),%eax
8010974a:	8d 50 08             	lea    0x8(%eax),%edx
8010974d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109750:	83 ec 04             	sub    $0x4,%esp
80109753:	6a 06                	push   $0x6
80109755:	52                   	push   %edx
80109756:	50                   	push   %eax
80109757:	e8 42 b6 ff ff       	call   80104d9e <memmove>
8010975c:	83 c4 10             	add    $0x10,%esp
  memmove(reply_eth->src_mac,mac_addr,6);
8010975f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109762:	83 c0 06             	add    $0x6,%eax
80109765:	83 ec 04             	sub    $0x4,%esp
80109768:	6a 06                	push   $0x6
8010976a:	68 68 d0 18 80       	push   $0x8018d068
8010976f:	50                   	push   %eax
80109770:	e8 29 b6 ff ff       	call   80104d9e <memmove>
80109775:	83 c4 10             	add    $0x10,%esp

  reply_arp->hrd_type = ARP_HARDWARE_TYPE;
80109778:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010977b:	66 c7 00 00 01       	movw   $0x100,(%eax)
  reply_arp->pro_type = ARP_PROTOCOL_TYPE;
80109780:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109783:	66 c7 40 02 08 00    	movw   $0x8,0x2(%eax)
  reply_arp->hrd_len = 6;
80109789:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010978c:	c6 40 04 06          	movb   $0x6,0x4(%eax)
  reply_arp->pro_len = 4;
80109790:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109793:	c6 40 05 04          	movb   $0x4,0x5(%eax)
  reply_arp->op = ARP_OPS_REPLY;
80109797:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010979a:	66 c7 40 06 00 02    	movw   $0x200,0x6(%eax)
  memmove(reply_arp->dst_mac,arp_recv->src_mac,6);
801097a0:	8b 45 08             	mov    0x8(%ebp),%eax
801097a3:	8d 50 08             	lea    0x8(%eax),%edx
801097a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801097a9:	83 c0 12             	add    $0x12,%eax
801097ac:	83 ec 04             	sub    $0x4,%esp
801097af:	6a 06                	push   $0x6
801097b1:	52                   	push   %edx
801097b2:	50                   	push   %eax
801097b3:	e8 e6 b5 ff ff       	call   80104d9e <memmove>
801097b8:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->dst_ip,arp_recv->src_ip,4);
801097bb:	8b 45 08             	mov    0x8(%ebp),%eax
801097be:	8d 50 0e             	lea    0xe(%eax),%edx
801097c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801097c4:	83 c0 18             	add    $0x18,%eax
801097c7:	83 ec 04             	sub    $0x4,%esp
801097ca:	6a 04                	push   $0x4
801097cc:	52                   	push   %edx
801097cd:	50                   	push   %eax
801097ce:	e8 cb b5 ff ff       	call   80104d9e <memmove>
801097d3:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_mac,mac_addr,6);
801097d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801097d9:	83 c0 08             	add    $0x8,%eax
801097dc:	83 ec 04             	sub    $0x4,%esp
801097df:	6a 06                	push   $0x6
801097e1:	68 68 d0 18 80       	push   $0x8018d068
801097e6:	50                   	push   %eax
801097e7:	e8 b2 b5 ff ff       	call   80104d9e <memmove>
801097ec:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_ip,my_ip,4);
801097ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801097f2:	83 c0 0e             	add    $0xe,%eax
801097f5:	83 ec 04             	sub    $0x4,%esp
801097f8:	6a 04                	push   $0x4
801097fa:	68 e4 f4 10 80       	push   $0x8010f4e4
801097ff:	50                   	push   %eax
80109800:	e8 99 b5 ff ff       	call   80104d9e <memmove>
80109805:	83 c4 10             	add    $0x10,%esp
}
80109808:	90                   	nop
80109809:	c9                   	leave  
8010980a:	c3                   	ret    

8010980b <print_arp_info>:

void print_arp_info(struct arp_pkt* arp_p){
8010980b:	f3 0f 1e fb          	endbr32 
8010980f:	55                   	push   %ebp
80109810:	89 e5                	mov    %esp,%ebp
80109812:	83 ec 08             	sub    $0x8,%esp
  cprintf("--------Source-------\n");
80109815:	83 ec 0c             	sub    $0xc,%esp
80109818:	68 c2 c5 10 80       	push   $0x8010c5c2
8010981d:	e8 ea 6b ff ff       	call   8010040c <cprintf>
80109822:	83 c4 10             	add    $0x10,%esp
  print_ipv4(arp_p->src_ip);
80109825:	8b 45 08             	mov    0x8(%ebp),%eax
80109828:	83 c0 0e             	add    $0xe,%eax
8010982b:	83 ec 0c             	sub    $0xc,%esp
8010982e:	50                   	push   %eax
8010982f:	e8 e8 00 00 00       	call   8010991c <print_ipv4>
80109834:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
80109837:	83 ec 0c             	sub    $0xc,%esp
8010983a:	68 c0 c5 10 80       	push   $0x8010c5c0
8010983f:	e8 c8 6b ff ff       	call   8010040c <cprintf>
80109844:	83 c4 10             	add    $0x10,%esp
  print_mac(arp_p->src_mac);
80109847:	8b 45 08             	mov    0x8(%ebp),%eax
8010984a:	83 c0 08             	add    $0x8,%eax
8010984d:	83 ec 0c             	sub    $0xc,%esp
80109850:	50                   	push   %eax
80109851:	e8 18 01 00 00       	call   8010996e <print_mac>
80109856:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
80109859:	83 ec 0c             	sub    $0xc,%esp
8010985c:	68 c0 c5 10 80       	push   $0x8010c5c0
80109861:	e8 a6 6b ff ff       	call   8010040c <cprintf>
80109866:	83 c4 10             	add    $0x10,%esp
  cprintf("-----Destination-----\n");
80109869:	83 ec 0c             	sub    $0xc,%esp
8010986c:	68 d9 c5 10 80       	push   $0x8010c5d9
80109871:	e8 96 6b ff ff       	call   8010040c <cprintf>
80109876:	83 c4 10             	add    $0x10,%esp
  print_ipv4(arp_p->dst_ip);
80109879:	8b 45 08             	mov    0x8(%ebp),%eax
8010987c:	83 c0 18             	add    $0x18,%eax
8010987f:	83 ec 0c             	sub    $0xc,%esp
80109882:	50                   	push   %eax
80109883:	e8 94 00 00 00       	call   8010991c <print_ipv4>
80109888:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
8010988b:	83 ec 0c             	sub    $0xc,%esp
8010988e:	68 c0 c5 10 80       	push   $0x8010c5c0
80109893:	e8 74 6b ff ff       	call   8010040c <cprintf>
80109898:	83 c4 10             	add    $0x10,%esp
  print_mac(arp_p->dst_mac);
8010989b:	8b 45 08             	mov    0x8(%ebp),%eax
8010989e:	83 c0 12             	add    $0x12,%eax
801098a1:	83 ec 0c             	sub    $0xc,%esp
801098a4:	50                   	push   %eax
801098a5:	e8 c4 00 00 00       	call   8010996e <print_mac>
801098aa:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801098ad:	83 ec 0c             	sub    $0xc,%esp
801098b0:	68 c0 c5 10 80       	push   $0x8010c5c0
801098b5:	e8 52 6b ff ff       	call   8010040c <cprintf>
801098ba:	83 c4 10             	add    $0x10,%esp
  cprintf("Operation: ");
801098bd:	83 ec 0c             	sub    $0xc,%esp
801098c0:	68 f0 c5 10 80       	push   $0x8010c5f0
801098c5:	e8 42 6b ff ff       	call   8010040c <cprintf>
801098ca:	83 c4 10             	add    $0x10,%esp
  if(arp_p->op == ARP_OPS_REQUEST) cprintf("Request\n");
801098cd:	8b 45 08             	mov    0x8(%ebp),%eax
801098d0:	0f b7 40 06          	movzwl 0x6(%eax),%eax
801098d4:	66 3d 00 01          	cmp    $0x100,%ax
801098d8:	75 12                	jne    801098ec <print_arp_info+0xe1>
801098da:	83 ec 0c             	sub    $0xc,%esp
801098dd:	68 fc c5 10 80       	push   $0x8010c5fc
801098e2:	e8 25 6b ff ff       	call   8010040c <cprintf>
801098e7:	83 c4 10             	add    $0x10,%esp
801098ea:	eb 1d                	jmp    80109909 <print_arp_info+0xfe>
  else if(arp_p->op == ARP_OPS_REPLY) {
801098ec:	8b 45 08             	mov    0x8(%ebp),%eax
801098ef:	0f b7 40 06          	movzwl 0x6(%eax),%eax
801098f3:	66 3d 00 02          	cmp    $0x200,%ax
801098f7:	75 10                	jne    80109909 <print_arp_info+0xfe>
    cprintf("Reply\n");
801098f9:	83 ec 0c             	sub    $0xc,%esp
801098fc:	68 05 c6 10 80       	push   $0x8010c605
80109901:	e8 06 6b ff ff       	call   8010040c <cprintf>
80109906:	83 c4 10             	add    $0x10,%esp
  }
  cprintf("\n");
80109909:	83 ec 0c             	sub    $0xc,%esp
8010990c:	68 c0 c5 10 80       	push   $0x8010c5c0
80109911:	e8 f6 6a ff ff       	call   8010040c <cprintf>
80109916:	83 c4 10             	add    $0x10,%esp
}
80109919:	90                   	nop
8010991a:	c9                   	leave  
8010991b:	c3                   	ret    

8010991c <print_ipv4>:

void print_ipv4(uchar *ip){
8010991c:	f3 0f 1e fb          	endbr32 
80109920:	55                   	push   %ebp
80109921:	89 e5                	mov    %esp,%ebp
80109923:	53                   	push   %ebx
80109924:	83 ec 04             	sub    $0x4,%esp
  cprintf("IP address: %d.%d.%d.%d",ip[0],ip[1],ip[2],ip[3]);
80109927:	8b 45 08             	mov    0x8(%ebp),%eax
8010992a:	83 c0 03             	add    $0x3,%eax
8010992d:	0f b6 00             	movzbl (%eax),%eax
80109930:	0f b6 d8             	movzbl %al,%ebx
80109933:	8b 45 08             	mov    0x8(%ebp),%eax
80109936:	83 c0 02             	add    $0x2,%eax
80109939:	0f b6 00             	movzbl (%eax),%eax
8010993c:	0f b6 c8             	movzbl %al,%ecx
8010993f:	8b 45 08             	mov    0x8(%ebp),%eax
80109942:	83 c0 01             	add    $0x1,%eax
80109945:	0f b6 00             	movzbl (%eax),%eax
80109948:	0f b6 d0             	movzbl %al,%edx
8010994b:	8b 45 08             	mov    0x8(%ebp),%eax
8010994e:	0f b6 00             	movzbl (%eax),%eax
80109951:	0f b6 c0             	movzbl %al,%eax
80109954:	83 ec 0c             	sub    $0xc,%esp
80109957:	53                   	push   %ebx
80109958:	51                   	push   %ecx
80109959:	52                   	push   %edx
8010995a:	50                   	push   %eax
8010995b:	68 0c c6 10 80       	push   $0x8010c60c
80109960:	e8 a7 6a ff ff       	call   8010040c <cprintf>
80109965:	83 c4 20             	add    $0x20,%esp
}
80109968:	90                   	nop
80109969:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010996c:	c9                   	leave  
8010996d:	c3                   	ret    

8010996e <print_mac>:

void print_mac(uchar *mac){
8010996e:	f3 0f 1e fb          	endbr32 
80109972:	55                   	push   %ebp
80109973:	89 e5                	mov    %esp,%ebp
80109975:	57                   	push   %edi
80109976:	56                   	push   %esi
80109977:	53                   	push   %ebx
80109978:	83 ec 0c             	sub    $0xc,%esp
  cprintf("MAC address: %x:%x:%x:%x:%x:%x",mac[0],mac[1],mac[2],mac[3],mac[4],mac[5]);
8010997b:	8b 45 08             	mov    0x8(%ebp),%eax
8010997e:	83 c0 05             	add    $0x5,%eax
80109981:	0f b6 00             	movzbl (%eax),%eax
80109984:	0f b6 f8             	movzbl %al,%edi
80109987:	8b 45 08             	mov    0x8(%ebp),%eax
8010998a:	83 c0 04             	add    $0x4,%eax
8010998d:	0f b6 00             	movzbl (%eax),%eax
80109990:	0f b6 f0             	movzbl %al,%esi
80109993:	8b 45 08             	mov    0x8(%ebp),%eax
80109996:	83 c0 03             	add    $0x3,%eax
80109999:	0f b6 00             	movzbl (%eax),%eax
8010999c:	0f b6 d8             	movzbl %al,%ebx
8010999f:	8b 45 08             	mov    0x8(%ebp),%eax
801099a2:	83 c0 02             	add    $0x2,%eax
801099a5:	0f b6 00             	movzbl (%eax),%eax
801099a8:	0f b6 c8             	movzbl %al,%ecx
801099ab:	8b 45 08             	mov    0x8(%ebp),%eax
801099ae:	83 c0 01             	add    $0x1,%eax
801099b1:	0f b6 00             	movzbl (%eax),%eax
801099b4:	0f b6 d0             	movzbl %al,%edx
801099b7:	8b 45 08             	mov    0x8(%ebp),%eax
801099ba:	0f b6 00             	movzbl (%eax),%eax
801099bd:	0f b6 c0             	movzbl %al,%eax
801099c0:	83 ec 04             	sub    $0x4,%esp
801099c3:	57                   	push   %edi
801099c4:	56                   	push   %esi
801099c5:	53                   	push   %ebx
801099c6:	51                   	push   %ecx
801099c7:	52                   	push   %edx
801099c8:	50                   	push   %eax
801099c9:	68 24 c6 10 80       	push   $0x8010c624
801099ce:	e8 39 6a ff ff       	call   8010040c <cprintf>
801099d3:	83 c4 20             	add    $0x20,%esp
}
801099d6:	90                   	nop
801099d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801099da:	5b                   	pop    %ebx
801099db:	5e                   	pop    %esi
801099dc:	5f                   	pop    %edi
801099dd:	5d                   	pop    %ebp
801099de:	c3                   	ret    

801099df <eth_proc>:
#include "arp.h"
#include "types.h"
#include "eth.h"
#include "defs.h"
#include "ipv4.h"
void eth_proc(uint buffer_addr){
801099df:	f3 0f 1e fb          	endbr32 
801099e3:	55                   	push   %ebp
801099e4:	89 e5                	mov    %esp,%ebp
801099e6:	83 ec 18             	sub    $0x18,%esp
  struct eth_pkt *eth_pkt = (struct eth_pkt *)buffer_addr;
801099e9:	8b 45 08             	mov    0x8(%ebp),%eax
801099ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint pkt_addr = buffer_addr+sizeof(struct eth_pkt);
801099ef:	8b 45 08             	mov    0x8(%ebp),%eax
801099f2:	83 c0 0e             	add    $0xe,%eax
801099f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x06){
801099f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801099fb:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
801099ff:	3c 08                	cmp    $0x8,%al
80109a01:	75 1b                	jne    80109a1e <eth_proc+0x3f>
80109a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a06:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109a0a:	3c 06                	cmp    $0x6,%al
80109a0c:	75 10                	jne    80109a1e <eth_proc+0x3f>
    arp_proc(pkt_addr);
80109a0e:	83 ec 0c             	sub    $0xc,%esp
80109a11:	ff 75 f0             	pushl  -0x10(%ebp)
80109a14:	e8 d5 f7 ff ff       	call   801091ee <arp_proc>
80109a19:	83 c4 10             	add    $0x10,%esp
  }else if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x00){
    ipv4_proc(buffer_addr);
  }else{
  }
}
80109a1c:	eb 24                	jmp    80109a42 <eth_proc+0x63>
  }else if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x00){
80109a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a21:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80109a25:	3c 08                	cmp    $0x8,%al
80109a27:	75 19                	jne    80109a42 <eth_proc+0x63>
80109a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a2c:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109a30:	84 c0                	test   %al,%al
80109a32:	75 0e                	jne    80109a42 <eth_proc+0x63>
    ipv4_proc(buffer_addr);
80109a34:	83 ec 0c             	sub    $0xc,%esp
80109a37:	ff 75 08             	pushl  0x8(%ebp)
80109a3a:	e8 b3 00 00 00       	call   80109af2 <ipv4_proc>
80109a3f:	83 c4 10             	add    $0x10,%esp
}
80109a42:	90                   	nop
80109a43:	c9                   	leave  
80109a44:	c3                   	ret    

80109a45 <N2H_ushort>:

ushort N2H_ushort(ushort value){
80109a45:	f3 0f 1e fb          	endbr32 
80109a49:	55                   	push   %ebp
80109a4a:	89 e5                	mov    %esp,%ebp
80109a4c:	83 ec 04             	sub    $0x4,%esp
80109a4f:	8b 45 08             	mov    0x8(%ebp),%eax
80109a52:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  return (((value)&0xFF)<<8)+(value>>8);
80109a56:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80109a5a:	c1 e0 08             	shl    $0x8,%eax
80109a5d:	89 c2                	mov    %eax,%edx
80109a5f:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80109a63:	66 c1 e8 08          	shr    $0x8,%ax
80109a67:	01 d0                	add    %edx,%eax
}
80109a69:	c9                   	leave  
80109a6a:	c3                   	ret    

80109a6b <H2N_ushort>:

ushort H2N_ushort(ushort value){
80109a6b:	f3 0f 1e fb          	endbr32 
80109a6f:	55                   	push   %ebp
80109a70:	89 e5                	mov    %esp,%ebp
80109a72:	83 ec 04             	sub    $0x4,%esp
80109a75:	8b 45 08             	mov    0x8(%ebp),%eax
80109a78:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  return (((value)&0xFF)<<8)+(value>>8);
80109a7c:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80109a80:	c1 e0 08             	shl    $0x8,%eax
80109a83:	89 c2                	mov    %eax,%edx
80109a85:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80109a89:	66 c1 e8 08          	shr    $0x8,%ax
80109a8d:	01 d0                	add    %edx,%eax
}
80109a8f:	c9                   	leave  
80109a90:	c3                   	ret    

80109a91 <H2N_uint>:

uint H2N_uint(uint value){
80109a91:	f3 0f 1e fb          	endbr32 
80109a95:	55                   	push   %ebp
80109a96:	89 e5                	mov    %esp,%ebp
  return ((value&0xF)<<24)+((value&0xF0)<<8)+((value&0xF00)>>8)+((value&0xF000)>>24);
80109a98:	8b 45 08             	mov    0x8(%ebp),%eax
80109a9b:	c1 e0 18             	shl    $0x18,%eax
80109a9e:	25 00 00 00 0f       	and    $0xf000000,%eax
80109aa3:	89 c2                	mov    %eax,%edx
80109aa5:	8b 45 08             	mov    0x8(%ebp),%eax
80109aa8:	c1 e0 08             	shl    $0x8,%eax
80109aab:	25 00 f0 00 00       	and    $0xf000,%eax
80109ab0:	09 c2                	or     %eax,%edx
80109ab2:	8b 45 08             	mov    0x8(%ebp),%eax
80109ab5:	c1 e8 08             	shr    $0x8,%eax
80109ab8:	83 e0 0f             	and    $0xf,%eax
80109abb:	01 d0                	add    %edx,%eax
}
80109abd:	5d                   	pop    %ebp
80109abe:	c3                   	ret    

80109abf <N2H_uint>:

uint N2H_uint(uint value){
80109abf:	f3 0f 1e fb          	endbr32 
80109ac3:	55                   	push   %ebp
80109ac4:	89 e5                	mov    %esp,%ebp
  return ((value&0xFF)<<24)+((value&0xFF00)<<8)+((value&0xFF0000)>>8)+((value&0xFF000000)>>24);
80109ac6:	8b 45 08             	mov    0x8(%ebp),%eax
80109ac9:	c1 e0 18             	shl    $0x18,%eax
80109acc:	89 c2                	mov    %eax,%edx
80109ace:	8b 45 08             	mov    0x8(%ebp),%eax
80109ad1:	c1 e0 08             	shl    $0x8,%eax
80109ad4:	25 00 00 ff 00       	and    $0xff0000,%eax
80109ad9:	01 c2                	add    %eax,%edx
80109adb:	8b 45 08             	mov    0x8(%ebp),%eax
80109ade:	c1 e8 08             	shr    $0x8,%eax
80109ae1:	25 00 ff 00 00       	and    $0xff00,%eax
80109ae6:	01 c2                	add    %eax,%edx
80109ae8:	8b 45 08             	mov    0x8(%ebp),%eax
80109aeb:	c1 e8 18             	shr    $0x18,%eax
80109aee:	01 d0                	add    %edx,%eax
}
80109af0:	5d                   	pop    %ebp
80109af1:	c3                   	ret    

80109af2 <ipv4_proc>:
extern uchar mac_addr[6];
extern uchar my_ip[4];

int ip_id = -1;
ushort send_id = 0;
void ipv4_proc(uint buffer_addr){
80109af2:	f3 0f 1e fb          	endbr32 
80109af6:	55                   	push   %ebp
80109af7:	89 e5                	mov    %esp,%ebp
80109af9:	83 ec 18             	sub    $0x18,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr+14);
80109afc:	8b 45 08             	mov    0x8(%ebp),%eax
80109aff:	83 c0 0e             	add    $0xe,%eax
80109b02:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(ip_id != ipv4_p->id && memcmp(my_ip,ipv4_p->src_ip,4) != 0){
80109b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b08:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80109b0c:	0f b7 d0             	movzwl %ax,%edx
80109b0f:	a1 e8 f4 10 80       	mov    0x8010f4e8,%eax
80109b14:	39 c2                	cmp    %eax,%edx
80109b16:	74 60                	je     80109b78 <ipv4_proc+0x86>
80109b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b1b:	83 c0 0c             	add    $0xc,%eax
80109b1e:	83 ec 04             	sub    $0x4,%esp
80109b21:	6a 04                	push   $0x4
80109b23:	50                   	push   %eax
80109b24:	68 e4 f4 10 80       	push   $0x8010f4e4
80109b29:	e8 14 b2 ff ff       	call   80104d42 <memcmp>
80109b2e:	83 c4 10             	add    $0x10,%esp
80109b31:	85 c0                	test   %eax,%eax
80109b33:	74 43                	je     80109b78 <ipv4_proc+0x86>
    ip_id = ipv4_p->id;
80109b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b38:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80109b3c:	0f b7 c0             	movzwl %ax,%eax
80109b3f:	a3 e8 f4 10 80       	mov    %eax,0x8010f4e8
      if(ipv4_p->protocol == IPV4_TYPE_ICMP){
80109b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b47:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80109b4b:	3c 01                	cmp    $0x1,%al
80109b4d:	75 10                	jne    80109b5f <ipv4_proc+0x6d>
        icmp_proc(buffer_addr);
80109b4f:	83 ec 0c             	sub    $0xc,%esp
80109b52:	ff 75 08             	pushl  0x8(%ebp)
80109b55:	e8 a7 00 00 00       	call   80109c01 <icmp_proc>
80109b5a:	83 c4 10             	add    $0x10,%esp
      }else if(ipv4_p->protocol == IPV4_TYPE_TCP){
        tcp_proc(buffer_addr);
      }
  }
}
80109b5d:	eb 19                	jmp    80109b78 <ipv4_proc+0x86>
      }else if(ipv4_p->protocol == IPV4_TYPE_TCP){
80109b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b62:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80109b66:	3c 06                	cmp    $0x6,%al
80109b68:	75 0e                	jne    80109b78 <ipv4_proc+0x86>
        tcp_proc(buffer_addr);
80109b6a:	83 ec 0c             	sub    $0xc,%esp
80109b6d:	ff 75 08             	pushl  0x8(%ebp)
80109b70:	e8 c7 03 00 00       	call   80109f3c <tcp_proc>
80109b75:	83 c4 10             	add    $0x10,%esp
}
80109b78:	90                   	nop
80109b79:	c9                   	leave  
80109b7a:	c3                   	ret    

80109b7b <ipv4_chksum>:

ushort ipv4_chksum(uint ipv4_addr){
80109b7b:	f3 0f 1e fb          	endbr32 
80109b7f:	55                   	push   %ebp
80109b80:	89 e5                	mov    %esp,%ebp
80109b82:	83 ec 10             	sub    $0x10,%esp
  uchar* bin = (uchar *)ipv4_addr;
80109b85:	8b 45 08             	mov    0x8(%ebp),%eax
80109b88:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uchar len = (bin[0]&0xF)*2;
80109b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b8e:	0f b6 00             	movzbl (%eax),%eax
80109b91:	83 e0 0f             	and    $0xf,%eax
80109b94:	01 c0                	add    %eax,%eax
80109b96:	88 45 f3             	mov    %al,-0xd(%ebp)
  uint chk_sum = 0;
80109b99:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  for(int i=0;i<len;i++){
80109ba0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80109ba7:	eb 48                	jmp    80109bf1 <ipv4_chksum+0x76>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
80109ba9:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109bac:	01 c0                	add    %eax,%eax
80109bae:	89 c2                	mov    %eax,%edx
80109bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109bb3:	01 d0                	add    %edx,%eax
80109bb5:	0f b6 00             	movzbl (%eax),%eax
80109bb8:	0f b6 c0             	movzbl %al,%eax
80109bbb:	c1 e0 08             	shl    $0x8,%eax
80109bbe:	89 c2                	mov    %eax,%edx
80109bc0:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109bc3:	01 c0                	add    %eax,%eax
80109bc5:	8d 48 01             	lea    0x1(%eax),%ecx
80109bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109bcb:	01 c8                	add    %ecx,%eax
80109bcd:	0f b6 00             	movzbl (%eax),%eax
80109bd0:	0f b6 c0             	movzbl %al,%eax
80109bd3:	01 d0                	add    %edx,%eax
80109bd5:	01 45 fc             	add    %eax,-0x4(%ebp)
    if(chk_sum > 0xFFFF){
80109bd8:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%ebp)
80109bdf:	76 0c                	jbe    80109bed <ipv4_chksum+0x72>
      chk_sum = (chk_sum&0xFFFF)+1;
80109be1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109be4:	0f b7 c0             	movzwl %ax,%eax
80109be7:	83 c0 01             	add    $0x1,%eax
80109bea:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(int i=0;i<len;i++){
80109bed:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80109bf1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
80109bf5:	39 45 f8             	cmp    %eax,-0x8(%ebp)
80109bf8:	7c af                	jl     80109ba9 <ipv4_chksum+0x2e>
    }
  }
  return ~(chk_sum);
80109bfa:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109bfd:	f7 d0                	not    %eax
}
80109bff:	c9                   	leave  
80109c00:	c3                   	ret    

80109c01 <icmp_proc>:
#include "eth.h"

extern uchar mac_addr[6];
extern uchar my_ip[4];
extern ushort send_id;
void icmp_proc(uint buffer_addr){
80109c01:	f3 0f 1e fb          	endbr32 
80109c05:	55                   	push   %ebp
80109c06:	89 e5                	mov    %esp,%ebp
80109c08:	83 ec 18             	sub    $0x18,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr+sizeof(struct eth_pkt));
80109c0b:	8b 45 08             	mov    0x8(%ebp),%eax
80109c0e:	83 c0 0e             	add    $0xe,%eax
80109c11:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct icmp_echo_pkt *icmp_p = (struct icmp_echo_pkt *)((uint)ipv4_p + (ipv4_p->ver&0xF)*4);
80109c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109c17:	0f b6 00             	movzbl (%eax),%eax
80109c1a:	0f b6 c0             	movzbl %al,%eax
80109c1d:	83 e0 0f             	and    $0xf,%eax
80109c20:	c1 e0 02             	shl    $0x2,%eax
80109c23:	89 c2                	mov    %eax,%edx
80109c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109c28:	01 d0                	add    %edx,%eax
80109c2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(icmp_p->code == 0){
80109c2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109c30:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80109c34:	84 c0                	test   %al,%al
80109c36:	75 4f                	jne    80109c87 <icmp_proc+0x86>
    if(icmp_p->type == ICMP_TYPE_ECHO_REQUEST){
80109c38:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109c3b:	0f b6 00             	movzbl (%eax),%eax
80109c3e:	3c 08                	cmp    $0x8,%al
80109c40:	75 45                	jne    80109c87 <icmp_proc+0x86>
      uint send_addr = (uint)kalloc();
80109c42:	e8 4b 8c ff ff       	call   80102892 <kalloc>
80109c47:	89 45 ec             	mov    %eax,-0x14(%ebp)
      uint send_size = 0;
80109c4a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
      icmp_reply_pkt_create(buffer_addr,send_addr,&send_size);
80109c51:	83 ec 04             	sub    $0x4,%esp
80109c54:	8d 45 e8             	lea    -0x18(%ebp),%eax
80109c57:	50                   	push   %eax
80109c58:	ff 75 ec             	pushl  -0x14(%ebp)
80109c5b:	ff 75 08             	pushl  0x8(%ebp)
80109c5e:	e8 7c 00 00 00       	call   80109cdf <icmp_reply_pkt_create>
80109c63:	83 c4 10             	add    $0x10,%esp
      i8254_send(send_addr,send_size);
80109c66:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109c69:	83 ec 08             	sub    $0x8,%esp
80109c6c:	50                   	push   %eax
80109c6d:	ff 75 ec             	pushl  -0x14(%ebp)
80109c70:	e8 43 f4 ff ff       	call   801090b8 <i8254_send>
80109c75:	83 c4 10             	add    $0x10,%esp
      kfree((char *)send_addr);
80109c78:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109c7b:	83 ec 0c             	sub    $0xc,%esp
80109c7e:	50                   	push   %eax
80109c7f:	e8 70 8b ff ff       	call   801027f4 <kfree>
80109c84:	83 c4 10             	add    $0x10,%esp
    }
  }
}
80109c87:	90                   	nop
80109c88:	c9                   	leave  
80109c89:	c3                   	ret    

80109c8a <icmp_proc_req>:

void icmp_proc_req(struct icmp_echo_pkt * icmp_p){
80109c8a:	f3 0f 1e fb          	endbr32 
80109c8e:	55                   	push   %ebp
80109c8f:	89 e5                	mov    %esp,%ebp
80109c91:	53                   	push   %ebx
80109c92:	83 ec 04             	sub    $0x4,%esp
  cprintf("ICMP ID:0x%x SEQ NUM:0x%x\n",N2H_ushort(icmp_p->id),N2H_ushort(icmp_p->seq_num));
80109c95:	8b 45 08             	mov    0x8(%ebp),%eax
80109c98:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80109c9c:	0f b7 c0             	movzwl %ax,%eax
80109c9f:	83 ec 0c             	sub    $0xc,%esp
80109ca2:	50                   	push   %eax
80109ca3:	e8 9d fd ff ff       	call   80109a45 <N2H_ushort>
80109ca8:	83 c4 10             	add    $0x10,%esp
80109cab:	0f b7 d8             	movzwl %ax,%ebx
80109cae:	8b 45 08             	mov    0x8(%ebp),%eax
80109cb1:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80109cb5:	0f b7 c0             	movzwl %ax,%eax
80109cb8:	83 ec 0c             	sub    $0xc,%esp
80109cbb:	50                   	push   %eax
80109cbc:	e8 84 fd ff ff       	call   80109a45 <N2H_ushort>
80109cc1:	83 c4 10             	add    $0x10,%esp
80109cc4:	0f b7 c0             	movzwl %ax,%eax
80109cc7:	83 ec 04             	sub    $0x4,%esp
80109cca:	53                   	push   %ebx
80109ccb:	50                   	push   %eax
80109ccc:	68 43 c6 10 80       	push   $0x8010c643
80109cd1:	e8 36 67 ff ff       	call   8010040c <cprintf>
80109cd6:	83 c4 10             	add    $0x10,%esp
}
80109cd9:	90                   	nop
80109cda:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109cdd:	c9                   	leave  
80109cde:	c3                   	ret    

80109cdf <icmp_reply_pkt_create>:

void icmp_reply_pkt_create(uint recv_addr,uint send_addr,uint *send_size){
80109cdf:	f3 0f 1e fb          	endbr32 
80109ce3:	55                   	push   %ebp
80109ce4:	89 e5                	mov    %esp,%ebp
80109ce6:	83 ec 28             	sub    $0x28,%esp
  struct eth_pkt *eth_recv = (struct eth_pkt *)(recv_addr);
80109ce9:	8b 45 08             	mov    0x8(%ebp),%eax
80109cec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct ipv4_pkt *ipv4_recv = (struct ipv4_pkt *)(recv_addr+sizeof(struct eth_pkt));
80109cef:	8b 45 08             	mov    0x8(%ebp),%eax
80109cf2:	83 c0 0e             	add    $0xe,%eax
80109cf5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct icmp_echo_pkt *icmp_recv = (struct icmp_echo_pkt *)((uint)ipv4_recv+(ipv4_recv->ver&0xF)*4);
80109cf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109cfb:	0f b6 00             	movzbl (%eax),%eax
80109cfe:	0f b6 c0             	movzbl %al,%eax
80109d01:	83 e0 0f             	and    $0xf,%eax
80109d04:	c1 e0 02             	shl    $0x2,%eax
80109d07:	89 c2                	mov    %eax,%edx
80109d09:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109d0c:	01 d0                	add    %edx,%eax
80109d0e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct eth_pkt *eth_send = (struct eth_pkt *)(send_addr);
80109d11:	8b 45 0c             	mov    0xc(%ebp),%eax
80109d14:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct ipv4_pkt *ipv4_send = (struct ipv4_pkt *)(send_addr+sizeof(struct eth_pkt));
80109d17:	8b 45 0c             	mov    0xc(%ebp),%eax
80109d1a:	83 c0 0e             	add    $0xe,%eax
80109d1d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct icmp_echo_pkt *icmp_send = (struct icmp_echo_pkt *)((uint)ipv4_send+sizeof(struct ipv4_pkt));
80109d20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109d23:	83 c0 14             	add    $0x14,%eax
80109d26:	89 45 e0             	mov    %eax,-0x20(%ebp)
  
  *send_size = sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct icmp_echo_pkt);
80109d29:	8b 45 10             	mov    0x10(%ebp),%eax
80109d2c:	c7 00 62 00 00 00    	movl   $0x62,(%eax)
  memmove(eth_send->dst_mac,eth_recv->src_mac,6);
80109d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109d35:	8d 50 06             	lea    0x6(%eax),%edx
80109d38:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109d3b:	83 ec 04             	sub    $0x4,%esp
80109d3e:	6a 06                	push   $0x6
80109d40:	52                   	push   %edx
80109d41:	50                   	push   %eax
80109d42:	e8 57 b0 ff ff       	call   80104d9e <memmove>
80109d47:	83 c4 10             	add    $0x10,%esp
  memmove(eth_send->src_mac,mac_addr,6);
80109d4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109d4d:	83 c0 06             	add    $0x6,%eax
80109d50:	83 ec 04             	sub    $0x4,%esp
80109d53:	6a 06                	push   $0x6
80109d55:	68 68 d0 18 80       	push   $0x8018d068
80109d5a:	50                   	push   %eax
80109d5b:	e8 3e b0 ff ff       	call   80104d9e <memmove>
80109d60:	83 c4 10             	add    $0x10,%esp
  eth_send->type[0] = 0x08;
80109d63:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109d66:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  eth_send->type[1] = 0x00;
80109d6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109d6d:	c6 40 0d 00          	movb   $0x0,0xd(%eax)

  ipv4_send->ver = ((0x4)<<4)+((sizeof(struct ipv4_pkt)/4)&0xF);
80109d71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109d74:	c6 00 45             	movb   $0x45,(%eax)
  ipv4_send->srv_type = 0;
80109d77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109d7a:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  ipv4_send->total_len = H2N_ushort(sizeof(struct ipv4_pkt) + sizeof(struct icmp_echo_pkt));
80109d7e:	83 ec 0c             	sub    $0xc,%esp
80109d81:	6a 54                	push   $0x54
80109d83:	e8 e3 fc ff ff       	call   80109a6b <H2N_ushort>
80109d88:	83 c4 10             	add    $0x10,%esp
80109d8b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109d8e:	66 89 42 02          	mov    %ax,0x2(%edx)
  ipv4_send->id = send_id;
80109d92:	0f b7 15 40 d3 18 80 	movzwl 0x8018d340,%edx
80109d99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109d9c:	66 89 50 04          	mov    %dx,0x4(%eax)
  send_id++;
80109da0:	0f b7 05 40 d3 18 80 	movzwl 0x8018d340,%eax
80109da7:	83 c0 01             	add    $0x1,%eax
80109daa:	66 a3 40 d3 18 80    	mov    %ax,0x8018d340
  ipv4_send->fragment = H2N_ushort(0x4000);
80109db0:	83 ec 0c             	sub    $0xc,%esp
80109db3:	68 00 40 00 00       	push   $0x4000
80109db8:	e8 ae fc ff ff       	call   80109a6b <H2N_ushort>
80109dbd:	83 c4 10             	add    $0x10,%esp
80109dc0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109dc3:	66 89 42 06          	mov    %ax,0x6(%edx)
  ipv4_send->ttl = 255;
80109dc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109dca:	c6 40 08 ff          	movb   $0xff,0x8(%eax)
  ipv4_send->protocol = 0x1;
80109dce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109dd1:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  memmove(ipv4_send->src_ip,my_ip,4);
80109dd5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109dd8:	83 c0 0c             	add    $0xc,%eax
80109ddb:	83 ec 04             	sub    $0x4,%esp
80109dde:	6a 04                	push   $0x4
80109de0:	68 e4 f4 10 80       	push   $0x8010f4e4
80109de5:	50                   	push   %eax
80109de6:	e8 b3 af ff ff       	call   80104d9e <memmove>
80109deb:	83 c4 10             	add    $0x10,%esp
  memmove(ipv4_send->dst_ip,ipv4_recv->src_ip,4);
80109dee:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109df1:	8d 50 0c             	lea    0xc(%eax),%edx
80109df4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109df7:	83 c0 10             	add    $0x10,%eax
80109dfa:	83 ec 04             	sub    $0x4,%esp
80109dfd:	6a 04                	push   $0x4
80109dff:	52                   	push   %edx
80109e00:	50                   	push   %eax
80109e01:	e8 98 af ff ff       	call   80104d9e <memmove>
80109e06:	83 c4 10             	add    $0x10,%esp
  ipv4_send->chk_sum = 0;
80109e09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e0c:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
  ipv4_send->chk_sum = H2N_ushort(ipv4_chksum((uint)ipv4_send));
80109e12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e15:	83 ec 0c             	sub    $0xc,%esp
80109e18:	50                   	push   %eax
80109e19:	e8 5d fd ff ff       	call   80109b7b <ipv4_chksum>
80109e1e:	83 c4 10             	add    $0x10,%esp
80109e21:	0f b7 c0             	movzwl %ax,%eax
80109e24:	83 ec 0c             	sub    $0xc,%esp
80109e27:	50                   	push   %eax
80109e28:	e8 3e fc ff ff       	call   80109a6b <H2N_ushort>
80109e2d:	83 c4 10             	add    $0x10,%esp
80109e30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109e33:	66 89 42 0a          	mov    %ax,0xa(%edx)

  icmp_send->type = ICMP_TYPE_ECHO_REPLY;
80109e37:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109e3a:	c6 00 00             	movb   $0x0,(%eax)
  icmp_send->code = 0;
80109e3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109e40:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  icmp_send->id = icmp_recv->id;
80109e44:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109e47:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80109e4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109e4e:	66 89 50 04          	mov    %dx,0x4(%eax)
  icmp_send->seq_num = icmp_recv->seq_num;
80109e52:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109e55:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80109e59:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109e5c:	66 89 50 06          	mov    %dx,0x6(%eax)
  memmove(icmp_send->time_stamp,icmp_recv->time_stamp,8);
80109e60:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109e63:	8d 50 08             	lea    0x8(%eax),%edx
80109e66:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109e69:	83 c0 08             	add    $0x8,%eax
80109e6c:	83 ec 04             	sub    $0x4,%esp
80109e6f:	6a 08                	push   $0x8
80109e71:	52                   	push   %edx
80109e72:	50                   	push   %eax
80109e73:	e8 26 af ff ff       	call   80104d9e <memmove>
80109e78:	83 c4 10             	add    $0x10,%esp
  memmove(icmp_send->data,icmp_recv->data,48);
80109e7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109e7e:	8d 50 10             	lea    0x10(%eax),%edx
80109e81:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109e84:	83 c0 10             	add    $0x10,%eax
80109e87:	83 ec 04             	sub    $0x4,%esp
80109e8a:	6a 30                	push   $0x30
80109e8c:	52                   	push   %edx
80109e8d:	50                   	push   %eax
80109e8e:	e8 0b af ff ff       	call   80104d9e <memmove>
80109e93:	83 c4 10             	add    $0x10,%esp
  icmp_send->chk_sum = 0;
80109e96:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109e99:	66 c7 40 02 00 00    	movw   $0x0,0x2(%eax)
  icmp_send->chk_sum = H2N_ushort(icmp_chksum((uint)icmp_send));
80109e9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109ea2:	83 ec 0c             	sub    $0xc,%esp
80109ea5:	50                   	push   %eax
80109ea6:	e8 1c 00 00 00       	call   80109ec7 <icmp_chksum>
80109eab:	83 c4 10             	add    $0x10,%esp
80109eae:	0f b7 c0             	movzwl %ax,%eax
80109eb1:	83 ec 0c             	sub    $0xc,%esp
80109eb4:	50                   	push   %eax
80109eb5:	e8 b1 fb ff ff       	call   80109a6b <H2N_ushort>
80109eba:	83 c4 10             	add    $0x10,%esp
80109ebd:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109ec0:	66 89 42 02          	mov    %ax,0x2(%edx)
}
80109ec4:	90                   	nop
80109ec5:	c9                   	leave  
80109ec6:	c3                   	ret    

80109ec7 <icmp_chksum>:

ushort icmp_chksum(uint icmp_addr){
80109ec7:	f3 0f 1e fb          	endbr32 
80109ecb:	55                   	push   %ebp
80109ecc:	89 e5                	mov    %esp,%ebp
80109ece:	83 ec 10             	sub    $0x10,%esp
  uchar* bin = (uchar *)icmp_addr;
80109ed1:	8b 45 08             	mov    0x8(%ebp),%eax
80109ed4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint chk_sum = 0;
80109ed7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  for(int i=0;i<32;i++){
80109ede:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80109ee5:	eb 48                	jmp    80109f2f <icmp_chksum+0x68>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
80109ee7:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109eea:	01 c0                	add    %eax,%eax
80109eec:	89 c2                	mov    %eax,%edx
80109eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ef1:	01 d0                	add    %edx,%eax
80109ef3:	0f b6 00             	movzbl (%eax),%eax
80109ef6:	0f b6 c0             	movzbl %al,%eax
80109ef9:	c1 e0 08             	shl    $0x8,%eax
80109efc:	89 c2                	mov    %eax,%edx
80109efe:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109f01:	01 c0                	add    %eax,%eax
80109f03:	8d 48 01             	lea    0x1(%eax),%ecx
80109f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109f09:	01 c8                	add    %ecx,%eax
80109f0b:	0f b6 00             	movzbl (%eax),%eax
80109f0e:	0f b6 c0             	movzbl %al,%eax
80109f11:	01 d0                	add    %edx,%eax
80109f13:	01 45 fc             	add    %eax,-0x4(%ebp)
    if(chk_sum > 0xFFFF){
80109f16:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%ebp)
80109f1d:	76 0c                	jbe    80109f2b <icmp_chksum+0x64>
      chk_sum = (chk_sum&0xFFFF)+1;
80109f1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109f22:	0f b7 c0             	movzwl %ax,%eax
80109f25:	83 c0 01             	add    $0x1,%eax
80109f28:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(int i=0;i<32;i++){
80109f2b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80109f2f:	83 7d f8 1f          	cmpl   $0x1f,-0x8(%ebp)
80109f33:	7e b2                	jle    80109ee7 <icmp_chksum+0x20>
    }
  }
  return ~(chk_sum);
80109f35:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109f38:	f7 d0                	not    %eax
}
80109f3a:	c9                   	leave  
80109f3b:	c3                   	ret    

80109f3c <tcp_proc>:
extern ushort send_id;
extern uchar mac_addr[6];
extern uchar my_ip[4];
int fin_flag = 0;

void tcp_proc(uint buffer_addr){
80109f3c:	f3 0f 1e fb          	endbr32 
80109f40:	55                   	push   %ebp
80109f41:	89 e5                	mov    %esp,%ebp
80109f43:	83 ec 38             	sub    $0x38,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr + sizeof(struct eth_pkt));
80109f46:	8b 45 08             	mov    0x8(%ebp),%eax
80109f49:	83 c0 0e             	add    $0xe,%eax
80109f4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct tcp_pkt *tcp_p = (struct tcp_pkt *)((uint)ipv4_p + (ipv4_p->ver&0xF)*4);
80109f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109f52:	0f b6 00             	movzbl (%eax),%eax
80109f55:	0f b6 c0             	movzbl %al,%eax
80109f58:	83 e0 0f             	and    $0xf,%eax
80109f5b:	c1 e0 02             	shl    $0x2,%eax
80109f5e:	89 c2                	mov    %eax,%edx
80109f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109f63:	01 d0                	add    %edx,%eax
80109f65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  char *payload = (char *)((uint)tcp_p + 20);
80109f68:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109f6b:	83 c0 14             	add    $0x14,%eax
80109f6e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  uint send_addr = (uint)kalloc();
80109f71:	e8 1c 89 ff ff       	call   80102892 <kalloc>
80109f76:	89 45 e8             	mov    %eax,-0x18(%ebp)
  uint send_size = 0;
80109f79:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  if(tcp_p->code_bits[1]&TCP_CODEBITS_SYN){
80109f80:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109f83:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109f87:	0f b6 c0             	movzbl %al,%eax
80109f8a:	83 e0 02             	and    $0x2,%eax
80109f8d:	85 c0                	test   %eax,%eax
80109f8f:	74 3d                	je     80109fce <tcp_proc+0x92>
    tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK | TCP_CODEBITS_SYN,0);
80109f91:	83 ec 0c             	sub    $0xc,%esp
80109f94:	6a 00                	push   $0x0
80109f96:	6a 12                	push   $0x12
80109f98:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109f9b:	50                   	push   %eax
80109f9c:	ff 75 e8             	pushl  -0x18(%ebp)
80109f9f:	ff 75 08             	pushl  0x8(%ebp)
80109fa2:	e8 a2 01 00 00       	call   8010a149 <tcp_pkt_create>
80109fa7:	83 c4 20             	add    $0x20,%esp
    i8254_send(send_addr,send_size);
80109faa:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109fad:	83 ec 08             	sub    $0x8,%esp
80109fb0:	50                   	push   %eax
80109fb1:	ff 75 e8             	pushl  -0x18(%ebp)
80109fb4:	e8 ff f0 ff ff       	call   801090b8 <i8254_send>
80109fb9:	83 c4 10             	add    $0x10,%esp
    seq_num++;
80109fbc:	a1 44 d3 18 80       	mov    0x8018d344,%eax
80109fc1:	83 c0 01             	add    $0x1,%eax
80109fc4:	a3 44 d3 18 80       	mov    %eax,0x8018d344
80109fc9:	e9 69 01 00 00       	jmp    8010a137 <tcp_proc+0x1fb>
  }else if(tcp_p->code_bits[1] == (TCP_CODEBITS_PSH | TCP_CODEBITS_ACK)){
80109fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109fd1:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109fd5:	3c 18                	cmp    $0x18,%al
80109fd7:	0f 85 10 01 00 00    	jne    8010a0ed <tcp_proc+0x1b1>
    if(memcmp(payload,"GET",3)){
80109fdd:	83 ec 04             	sub    $0x4,%esp
80109fe0:	6a 03                	push   $0x3
80109fe2:	68 5e c6 10 80       	push   $0x8010c65e
80109fe7:	ff 75 ec             	pushl  -0x14(%ebp)
80109fea:	e8 53 ad ff ff       	call   80104d42 <memcmp>
80109fef:	83 c4 10             	add    $0x10,%esp
80109ff2:	85 c0                	test   %eax,%eax
80109ff4:	74 74                	je     8010a06a <tcp_proc+0x12e>
      cprintf("ACK PSH\n");
80109ff6:	83 ec 0c             	sub    $0xc,%esp
80109ff9:	68 62 c6 10 80       	push   $0x8010c662
80109ffe:	e8 09 64 ff ff       	call   8010040c <cprintf>
8010a003:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK,0);
8010a006:	83 ec 0c             	sub    $0xc,%esp
8010a009:	6a 00                	push   $0x0
8010a00b:	6a 10                	push   $0x10
8010a00d:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010a010:	50                   	push   %eax
8010a011:	ff 75 e8             	pushl  -0x18(%ebp)
8010a014:	ff 75 08             	pushl  0x8(%ebp)
8010a017:	e8 2d 01 00 00       	call   8010a149 <tcp_pkt_create>
8010a01c:	83 c4 20             	add    $0x20,%esp
      i8254_send(send_addr,send_size);
8010a01f:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010a022:	83 ec 08             	sub    $0x8,%esp
8010a025:	50                   	push   %eax
8010a026:	ff 75 e8             	pushl  -0x18(%ebp)
8010a029:	e8 8a f0 ff ff       	call   801090b8 <i8254_send>
8010a02e:	83 c4 10             	add    $0x10,%esp
      uint send_payload = (send_addr + sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt));
8010a031:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a034:	83 c0 36             	add    $0x36,%eax
8010a037:	89 45 e0             	mov    %eax,-0x20(%ebp)
      uint payload_size;
      http_proc(0,0,send_payload,&payload_size);
8010a03a:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010a03d:	50                   	push   %eax
8010a03e:	ff 75 e0             	pushl  -0x20(%ebp)
8010a041:	6a 00                	push   $0x0
8010a043:	6a 00                	push   $0x0
8010a045:	e8 66 04 00 00       	call   8010a4b0 <http_proc>
8010a04a:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,(TCP_CODEBITS_ACK|TCP_CODEBITS_PSH),payload_size);
8010a04d:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010a050:	83 ec 0c             	sub    $0xc,%esp
8010a053:	50                   	push   %eax
8010a054:	6a 18                	push   $0x18
8010a056:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010a059:	50                   	push   %eax
8010a05a:	ff 75 e8             	pushl  -0x18(%ebp)
8010a05d:	ff 75 08             	pushl  0x8(%ebp)
8010a060:	e8 e4 00 00 00       	call   8010a149 <tcp_pkt_create>
8010a065:	83 c4 20             	add    $0x20,%esp
8010a068:	eb 62                	jmp    8010a0cc <tcp_proc+0x190>
    }else{
     tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK,0);
8010a06a:	83 ec 0c             	sub    $0xc,%esp
8010a06d:	6a 00                	push   $0x0
8010a06f:	6a 10                	push   $0x10
8010a071:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010a074:	50                   	push   %eax
8010a075:	ff 75 e8             	pushl  -0x18(%ebp)
8010a078:	ff 75 08             	pushl  0x8(%ebp)
8010a07b:	e8 c9 00 00 00       	call   8010a149 <tcp_pkt_create>
8010a080:	83 c4 20             	add    $0x20,%esp
     i8254_send(send_addr,send_size);
8010a083:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010a086:	83 ec 08             	sub    $0x8,%esp
8010a089:	50                   	push   %eax
8010a08a:	ff 75 e8             	pushl  -0x18(%ebp)
8010a08d:	e8 26 f0 ff ff       	call   801090b8 <i8254_send>
8010a092:	83 c4 10             	add    $0x10,%esp
      uint send_payload = (send_addr + sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt));
8010a095:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a098:	83 c0 36             	add    $0x36,%eax
8010a09b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      uint payload_size;
      http_proc(0,0,send_payload,&payload_size);
8010a09e:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010a0a1:	50                   	push   %eax
8010a0a2:	ff 75 e4             	pushl  -0x1c(%ebp)
8010a0a5:	6a 00                	push   $0x0
8010a0a7:	6a 00                	push   $0x0
8010a0a9:	e8 02 04 00 00       	call   8010a4b0 <http_proc>
8010a0ae:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,(TCP_CODEBITS_ACK|TCP_CODEBITS_PSH),payload_size);
8010a0b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010a0b4:	83 ec 0c             	sub    $0xc,%esp
8010a0b7:	50                   	push   %eax
8010a0b8:	6a 18                	push   $0x18
8010a0ba:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010a0bd:	50                   	push   %eax
8010a0be:	ff 75 e8             	pushl  -0x18(%ebp)
8010a0c1:	ff 75 08             	pushl  0x8(%ebp)
8010a0c4:	e8 80 00 00 00       	call   8010a149 <tcp_pkt_create>
8010a0c9:	83 c4 20             	add    $0x20,%esp
    }
    i8254_send(send_addr,send_size);
8010a0cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010a0cf:	83 ec 08             	sub    $0x8,%esp
8010a0d2:	50                   	push   %eax
8010a0d3:	ff 75 e8             	pushl  -0x18(%ebp)
8010a0d6:	e8 dd ef ff ff       	call   801090b8 <i8254_send>
8010a0db:	83 c4 10             	add    $0x10,%esp
    seq_num++;
8010a0de:	a1 44 d3 18 80       	mov    0x8018d344,%eax
8010a0e3:	83 c0 01             	add    $0x1,%eax
8010a0e6:	a3 44 d3 18 80       	mov    %eax,0x8018d344
8010a0eb:	eb 4a                	jmp    8010a137 <tcp_proc+0x1fb>
  }else if(tcp_p->code_bits[1] == TCP_CODEBITS_ACK){
8010a0ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a0f0:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
8010a0f4:	3c 10                	cmp    $0x10,%al
8010a0f6:	75 3f                	jne    8010a137 <tcp_proc+0x1fb>
    if(fin_flag == 1){
8010a0f8:	a1 48 d3 18 80       	mov    0x8018d348,%eax
8010a0fd:	83 f8 01             	cmp    $0x1,%eax
8010a100:	75 35                	jne    8010a137 <tcp_proc+0x1fb>
      tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_FIN,0);
8010a102:	83 ec 0c             	sub    $0xc,%esp
8010a105:	6a 00                	push   $0x0
8010a107:	6a 01                	push   $0x1
8010a109:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010a10c:	50                   	push   %eax
8010a10d:	ff 75 e8             	pushl  -0x18(%ebp)
8010a110:	ff 75 08             	pushl  0x8(%ebp)
8010a113:	e8 31 00 00 00       	call   8010a149 <tcp_pkt_create>
8010a118:	83 c4 20             	add    $0x20,%esp
      i8254_send(send_addr,send_size);
8010a11b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010a11e:	83 ec 08             	sub    $0x8,%esp
8010a121:	50                   	push   %eax
8010a122:	ff 75 e8             	pushl  -0x18(%ebp)
8010a125:	e8 8e ef ff ff       	call   801090b8 <i8254_send>
8010a12a:	83 c4 10             	add    $0x10,%esp
      fin_flag = 0;
8010a12d:	c7 05 48 d3 18 80 00 	movl   $0x0,0x8018d348
8010a134:	00 00 00 
    }
  }
  kfree((char *)send_addr);
8010a137:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a13a:	83 ec 0c             	sub    $0xc,%esp
8010a13d:	50                   	push   %eax
8010a13e:	e8 b1 86 ff ff       	call   801027f4 <kfree>
8010a143:	83 c4 10             	add    $0x10,%esp
}
8010a146:	90                   	nop
8010a147:	c9                   	leave  
8010a148:	c3                   	ret    

8010a149 <tcp_pkt_create>:

void tcp_pkt_create(uint recv_addr,uint send_addr,uint *send_size,uint pkt_type,uint payload_size){
8010a149:	f3 0f 1e fb          	endbr32 
8010a14d:	55                   	push   %ebp
8010a14e:	89 e5                	mov    %esp,%ebp
8010a150:	83 ec 28             	sub    $0x28,%esp
  struct eth_pkt *eth_recv = (struct eth_pkt *)(recv_addr);
8010a153:	8b 45 08             	mov    0x8(%ebp),%eax
8010a156:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct ipv4_pkt *ipv4_recv = (struct ipv4_pkt *)(recv_addr+sizeof(struct eth_pkt));
8010a159:	8b 45 08             	mov    0x8(%ebp),%eax
8010a15c:	83 c0 0e             	add    $0xe,%eax
8010a15f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct tcp_pkt *tcp_recv = (struct tcp_pkt *)((uint)ipv4_recv + (ipv4_recv->ver&0xF)*4);
8010a162:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a165:	0f b6 00             	movzbl (%eax),%eax
8010a168:	0f b6 c0             	movzbl %al,%eax
8010a16b:	83 e0 0f             	and    $0xf,%eax
8010a16e:	c1 e0 02             	shl    $0x2,%eax
8010a171:	89 c2                	mov    %eax,%edx
8010a173:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a176:	01 d0                	add    %edx,%eax
8010a178:	89 45 ec             	mov    %eax,-0x14(%ebp)

  struct eth_pkt *eth_send = (struct eth_pkt *)(send_addr);
8010a17b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a17e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct ipv4_pkt *ipv4_send = (struct ipv4_pkt *)(send_addr + sizeof(struct eth_pkt));
8010a181:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a184:	83 c0 0e             	add    $0xe,%eax
8010a187:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct tcp_pkt *tcp_send = (struct tcp_pkt *)((uint)ipv4_send + sizeof(struct ipv4_pkt));
8010a18a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a18d:	83 c0 14             	add    $0x14,%eax
8010a190:	89 45 e0             	mov    %eax,-0x20(%ebp)

  *send_size = sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt) + payload_size;
8010a193:	8b 45 18             	mov    0x18(%ebp),%eax
8010a196:	8d 50 36             	lea    0x36(%eax),%edx
8010a199:	8b 45 10             	mov    0x10(%ebp),%eax
8010a19c:	89 10                	mov    %edx,(%eax)

  memmove(eth_send->dst_mac,eth_recv->src_mac,6);
8010a19e:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a1a1:	8d 50 06             	lea    0x6(%eax),%edx
8010a1a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a1a7:	83 ec 04             	sub    $0x4,%esp
8010a1aa:	6a 06                	push   $0x6
8010a1ac:	52                   	push   %edx
8010a1ad:	50                   	push   %eax
8010a1ae:	e8 eb ab ff ff       	call   80104d9e <memmove>
8010a1b3:	83 c4 10             	add    $0x10,%esp
  memmove(eth_send->src_mac,mac_addr,6);
8010a1b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a1b9:	83 c0 06             	add    $0x6,%eax
8010a1bc:	83 ec 04             	sub    $0x4,%esp
8010a1bf:	6a 06                	push   $0x6
8010a1c1:	68 68 d0 18 80       	push   $0x8018d068
8010a1c6:	50                   	push   %eax
8010a1c7:	e8 d2 ab ff ff       	call   80104d9e <memmove>
8010a1cc:	83 c4 10             	add    $0x10,%esp
  eth_send->type[0] = 0x08;
8010a1cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a1d2:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  eth_send->type[1] = 0x00;
8010a1d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a1d9:	c6 40 0d 00          	movb   $0x0,0xd(%eax)

  ipv4_send->ver = ((0x4)<<4)+((sizeof(struct ipv4_pkt)/4)&0xF);
8010a1dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a1e0:	c6 00 45             	movb   $0x45,(%eax)
  ipv4_send->srv_type = 0;
8010a1e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a1e6:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  ipv4_send->total_len = H2N_ushort(sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt) + payload_size);
8010a1ea:	8b 45 18             	mov    0x18(%ebp),%eax
8010a1ed:	83 c0 28             	add    $0x28,%eax
8010a1f0:	0f b7 c0             	movzwl %ax,%eax
8010a1f3:	83 ec 0c             	sub    $0xc,%esp
8010a1f6:	50                   	push   %eax
8010a1f7:	e8 6f f8 ff ff       	call   80109a6b <H2N_ushort>
8010a1fc:	83 c4 10             	add    $0x10,%esp
8010a1ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010a202:	66 89 42 02          	mov    %ax,0x2(%edx)
  ipv4_send->id = send_id;
8010a206:	0f b7 15 40 d3 18 80 	movzwl 0x8018d340,%edx
8010a20d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a210:	66 89 50 04          	mov    %dx,0x4(%eax)
  send_id++;
8010a214:	0f b7 05 40 d3 18 80 	movzwl 0x8018d340,%eax
8010a21b:	83 c0 01             	add    $0x1,%eax
8010a21e:	66 a3 40 d3 18 80    	mov    %ax,0x8018d340
  ipv4_send->fragment = H2N_ushort(0x0000);
8010a224:	83 ec 0c             	sub    $0xc,%esp
8010a227:	6a 00                	push   $0x0
8010a229:	e8 3d f8 ff ff       	call   80109a6b <H2N_ushort>
8010a22e:	83 c4 10             	add    $0x10,%esp
8010a231:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010a234:	66 89 42 06          	mov    %ax,0x6(%edx)
  ipv4_send->ttl = 255;
8010a238:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a23b:	c6 40 08 ff          	movb   $0xff,0x8(%eax)
  ipv4_send->protocol = IPV4_TYPE_TCP;
8010a23f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a242:	c6 40 09 06          	movb   $0x6,0x9(%eax)
  memmove(ipv4_send->src_ip,my_ip,4);
8010a246:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a249:	83 c0 0c             	add    $0xc,%eax
8010a24c:	83 ec 04             	sub    $0x4,%esp
8010a24f:	6a 04                	push   $0x4
8010a251:	68 e4 f4 10 80       	push   $0x8010f4e4
8010a256:	50                   	push   %eax
8010a257:	e8 42 ab ff ff       	call   80104d9e <memmove>
8010a25c:	83 c4 10             	add    $0x10,%esp
  memmove(ipv4_send->dst_ip,ipv4_recv->src_ip,4);
8010a25f:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a262:	8d 50 0c             	lea    0xc(%eax),%edx
8010a265:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a268:	83 c0 10             	add    $0x10,%eax
8010a26b:	83 ec 04             	sub    $0x4,%esp
8010a26e:	6a 04                	push   $0x4
8010a270:	52                   	push   %edx
8010a271:	50                   	push   %eax
8010a272:	e8 27 ab ff ff       	call   80104d9e <memmove>
8010a277:	83 c4 10             	add    $0x10,%esp
  ipv4_send->chk_sum = 0;
8010a27a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a27d:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
  ipv4_send->chk_sum = H2N_ushort(ipv4_chksum((uint)ipv4_send));
8010a283:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a286:	83 ec 0c             	sub    $0xc,%esp
8010a289:	50                   	push   %eax
8010a28a:	e8 ec f8 ff ff       	call   80109b7b <ipv4_chksum>
8010a28f:	83 c4 10             	add    $0x10,%esp
8010a292:	0f b7 c0             	movzwl %ax,%eax
8010a295:	83 ec 0c             	sub    $0xc,%esp
8010a298:	50                   	push   %eax
8010a299:	e8 cd f7 ff ff       	call   80109a6b <H2N_ushort>
8010a29e:	83 c4 10             	add    $0x10,%esp
8010a2a1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010a2a4:	66 89 42 0a          	mov    %ax,0xa(%edx)
  

  tcp_send->src_port = tcp_recv->dst_port;
8010a2a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a2ab:	0f b7 50 02          	movzwl 0x2(%eax),%edx
8010a2af:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a2b2:	66 89 10             	mov    %dx,(%eax)
  tcp_send->dst_port = tcp_recv->src_port;
8010a2b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a2b8:	0f b7 10             	movzwl (%eax),%edx
8010a2bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a2be:	66 89 50 02          	mov    %dx,0x2(%eax)
  tcp_send->seq_num = H2N_uint(seq_num);
8010a2c2:	a1 44 d3 18 80       	mov    0x8018d344,%eax
8010a2c7:	83 ec 0c             	sub    $0xc,%esp
8010a2ca:	50                   	push   %eax
8010a2cb:	e8 c1 f7 ff ff       	call   80109a91 <H2N_uint>
8010a2d0:	83 c4 10             	add    $0x10,%esp
8010a2d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010a2d6:	89 42 04             	mov    %eax,0x4(%edx)
  tcp_send->ack_num = tcp_recv->seq_num + (1<<(8*3));
8010a2d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a2dc:	8b 40 04             	mov    0x4(%eax),%eax
8010a2df:	8d 90 00 00 00 01    	lea    0x1000000(%eax),%edx
8010a2e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a2e8:	89 50 08             	mov    %edx,0x8(%eax)

  tcp_send->code_bits[0] = 0;
8010a2eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a2ee:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
  tcp_send->code_bits[1] = 0;
8010a2f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a2f5:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
  tcp_send->code_bits[0] = 5<<4;
8010a2f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a2fc:	c6 40 0c 50          	movb   $0x50,0xc(%eax)
  tcp_send->code_bits[1] = pkt_type;
8010a300:	8b 45 14             	mov    0x14(%ebp),%eax
8010a303:	89 c2                	mov    %eax,%edx
8010a305:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a308:	88 50 0d             	mov    %dl,0xd(%eax)

  tcp_send->window = H2N_ushort(14480);
8010a30b:	83 ec 0c             	sub    $0xc,%esp
8010a30e:	68 90 38 00 00       	push   $0x3890
8010a313:	e8 53 f7 ff ff       	call   80109a6b <H2N_ushort>
8010a318:	83 c4 10             	add    $0x10,%esp
8010a31b:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010a31e:	66 89 42 0e          	mov    %ax,0xe(%edx)
  tcp_send->urgent_ptr = 0;
8010a322:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a325:	66 c7 40 12 00 00    	movw   $0x0,0x12(%eax)
  tcp_send->chk_sum = 0;
8010a32b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a32e:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)

  tcp_send->chk_sum = H2N_ushort(tcp_chksum((uint)(ipv4_send))+8);
8010a334:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a337:	83 ec 0c             	sub    $0xc,%esp
8010a33a:	50                   	push   %eax
8010a33b:	e8 1f 00 00 00       	call   8010a35f <tcp_chksum>
8010a340:	83 c4 10             	add    $0x10,%esp
8010a343:	83 c0 08             	add    $0x8,%eax
8010a346:	0f b7 c0             	movzwl %ax,%eax
8010a349:	83 ec 0c             	sub    $0xc,%esp
8010a34c:	50                   	push   %eax
8010a34d:	e8 19 f7 ff ff       	call   80109a6b <H2N_ushort>
8010a352:	83 c4 10             	add    $0x10,%esp
8010a355:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010a358:	66 89 42 10          	mov    %ax,0x10(%edx)


}
8010a35c:	90                   	nop
8010a35d:	c9                   	leave  
8010a35e:	c3                   	ret    

8010a35f <tcp_chksum>:

ushort tcp_chksum(uint tcp_addr){
8010a35f:	f3 0f 1e fb          	endbr32 
8010a363:	55                   	push   %ebp
8010a364:	89 e5                	mov    %esp,%ebp
8010a366:	83 ec 38             	sub    $0x38,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(tcp_addr);
8010a369:	8b 45 08             	mov    0x8(%ebp),%eax
8010a36c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct tcp_pkt *tcp_p = (struct tcp_pkt *)((uint)ipv4_p + sizeof(struct ipv4_pkt));
8010a36f:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a372:	83 c0 14             	add    $0x14,%eax
8010a375:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct tcp_dummy tcp_dummy;
  
  memmove(tcp_dummy.src_ip,my_ip,4);
8010a378:	83 ec 04             	sub    $0x4,%esp
8010a37b:	6a 04                	push   $0x4
8010a37d:	68 e4 f4 10 80       	push   $0x8010f4e4
8010a382:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010a385:	50                   	push   %eax
8010a386:	e8 13 aa ff ff       	call   80104d9e <memmove>
8010a38b:	83 c4 10             	add    $0x10,%esp
  memmove(tcp_dummy.dst_ip,ipv4_p->src_ip,4);
8010a38e:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a391:	83 c0 0c             	add    $0xc,%eax
8010a394:	83 ec 04             	sub    $0x4,%esp
8010a397:	6a 04                	push   $0x4
8010a399:	50                   	push   %eax
8010a39a:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010a39d:	83 c0 04             	add    $0x4,%eax
8010a3a0:	50                   	push   %eax
8010a3a1:	e8 f8 a9 ff ff       	call   80104d9e <memmove>
8010a3a6:	83 c4 10             	add    $0x10,%esp
  tcp_dummy.padding = 0;
8010a3a9:	c6 45 dc 00          	movb   $0x0,-0x24(%ebp)
  tcp_dummy.protocol = IPV4_TYPE_TCP;
8010a3ad:	c6 45 dd 06          	movb   $0x6,-0x23(%ebp)
  tcp_dummy.tcp_len = H2N_ushort(N2H_ushort(ipv4_p->total_len) - sizeof(struct ipv4_pkt));
8010a3b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a3b4:	0f b7 40 02          	movzwl 0x2(%eax),%eax
8010a3b8:	0f b7 c0             	movzwl %ax,%eax
8010a3bb:	83 ec 0c             	sub    $0xc,%esp
8010a3be:	50                   	push   %eax
8010a3bf:	e8 81 f6 ff ff       	call   80109a45 <N2H_ushort>
8010a3c4:	83 c4 10             	add    $0x10,%esp
8010a3c7:	83 e8 14             	sub    $0x14,%eax
8010a3ca:	0f b7 c0             	movzwl %ax,%eax
8010a3cd:	83 ec 0c             	sub    $0xc,%esp
8010a3d0:	50                   	push   %eax
8010a3d1:	e8 95 f6 ff ff       	call   80109a6b <H2N_ushort>
8010a3d6:	83 c4 10             	add    $0x10,%esp
8010a3d9:	66 89 45 de          	mov    %ax,-0x22(%ebp)
  uint chk_sum = 0;
8010a3dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  uchar *bin = (uchar *)(&tcp_dummy);
8010a3e4:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010a3e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(int i=0;i<6;i++){
8010a3ea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010a3f1:	eb 33                	jmp    8010a426 <tcp_chksum+0xc7>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
8010a3f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a3f6:	01 c0                	add    %eax,%eax
8010a3f8:	89 c2                	mov    %eax,%edx
8010a3fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a3fd:	01 d0                	add    %edx,%eax
8010a3ff:	0f b6 00             	movzbl (%eax),%eax
8010a402:	0f b6 c0             	movzbl %al,%eax
8010a405:	c1 e0 08             	shl    $0x8,%eax
8010a408:	89 c2                	mov    %eax,%edx
8010a40a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a40d:	01 c0                	add    %eax,%eax
8010a40f:	8d 48 01             	lea    0x1(%eax),%ecx
8010a412:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a415:	01 c8                	add    %ecx,%eax
8010a417:	0f b6 00             	movzbl (%eax),%eax
8010a41a:	0f b6 c0             	movzbl %al,%eax
8010a41d:	01 d0                	add    %edx,%eax
8010a41f:	01 45 f4             	add    %eax,-0xc(%ebp)
  for(int i=0;i<6;i++){
8010a422:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010a426:	83 7d f0 05          	cmpl   $0x5,-0x10(%ebp)
8010a42a:	7e c7                	jle    8010a3f3 <tcp_chksum+0x94>
  }

  bin = (uchar *)(tcp_p);
8010a42c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a42f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(int i=0;i<(N2H_ushort(tcp_dummy.tcp_len)/2);i++){
8010a432:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
8010a439:	eb 33                	jmp    8010a46e <tcp_chksum+0x10f>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
8010a43b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a43e:	01 c0                	add    %eax,%eax
8010a440:	89 c2                	mov    %eax,%edx
8010a442:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a445:	01 d0                	add    %edx,%eax
8010a447:	0f b6 00             	movzbl (%eax),%eax
8010a44a:	0f b6 c0             	movzbl %al,%eax
8010a44d:	c1 e0 08             	shl    $0x8,%eax
8010a450:	89 c2                	mov    %eax,%edx
8010a452:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a455:	01 c0                	add    %eax,%eax
8010a457:	8d 48 01             	lea    0x1(%eax),%ecx
8010a45a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a45d:	01 c8                	add    %ecx,%eax
8010a45f:	0f b6 00             	movzbl (%eax),%eax
8010a462:	0f b6 c0             	movzbl %al,%eax
8010a465:	01 d0                	add    %edx,%eax
8010a467:	01 45 f4             	add    %eax,-0xc(%ebp)
  for(int i=0;i<(N2H_ushort(tcp_dummy.tcp_len)/2);i++){
8010a46a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010a46e:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
8010a472:	0f b7 c0             	movzwl %ax,%eax
8010a475:	83 ec 0c             	sub    $0xc,%esp
8010a478:	50                   	push   %eax
8010a479:	e8 c7 f5 ff ff       	call   80109a45 <N2H_ushort>
8010a47e:	83 c4 10             	add    $0x10,%esp
8010a481:	66 d1 e8             	shr    %ax
8010a484:	0f b7 c0             	movzwl %ax,%eax
8010a487:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010a48a:	7c af                	jl     8010a43b <tcp_chksum+0xdc>
  }
  chk_sum += (chk_sum>>8*2);
8010a48c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a48f:	c1 e8 10             	shr    $0x10,%eax
8010a492:	01 45 f4             	add    %eax,-0xc(%ebp)
  return ~(chk_sum);
8010a495:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a498:	f7 d0                	not    %eax
}
8010a49a:	c9                   	leave  
8010a49b:	c3                   	ret    

8010a49c <tcp_fin>:

void tcp_fin(){
8010a49c:	f3 0f 1e fb          	endbr32 
8010a4a0:	55                   	push   %ebp
8010a4a1:	89 e5                	mov    %esp,%ebp
  fin_flag =1;
8010a4a3:	c7 05 48 d3 18 80 01 	movl   $0x1,0x8018d348
8010a4aa:	00 00 00 
}
8010a4ad:	90                   	nop
8010a4ae:	5d                   	pop    %ebp
8010a4af:	c3                   	ret    

8010a4b0 <http_proc>:
#include "defs.h"
#include "types.h"
#include "tcp.h"


void http_proc(uint recv, uint recv_size, uint send, uint *send_size){
8010a4b0:	f3 0f 1e fb          	endbr32 
8010a4b4:	55                   	push   %ebp
8010a4b5:	89 e5                	mov    %esp,%ebp
8010a4b7:	83 ec 18             	sub    $0x18,%esp
  int len;
  len = http_strcpy((char *)send,"HTTP/1.0 200 OK \r\n",0);
8010a4ba:	8b 45 10             	mov    0x10(%ebp),%eax
8010a4bd:	83 ec 04             	sub    $0x4,%esp
8010a4c0:	6a 00                	push   $0x0
8010a4c2:	68 6b c6 10 80       	push   $0x8010c66b
8010a4c7:	50                   	push   %eax
8010a4c8:	e8 65 00 00 00       	call   8010a532 <http_strcpy>
8010a4cd:	83 c4 10             	add    $0x10,%esp
8010a4d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  len += http_strcpy((char *)send,"Content-Type: text/html \r\n",len);
8010a4d3:	8b 45 10             	mov    0x10(%ebp),%eax
8010a4d6:	83 ec 04             	sub    $0x4,%esp
8010a4d9:	ff 75 f4             	pushl  -0xc(%ebp)
8010a4dc:	68 7e c6 10 80       	push   $0x8010c67e
8010a4e1:	50                   	push   %eax
8010a4e2:	e8 4b 00 00 00       	call   8010a532 <http_strcpy>
8010a4e7:	83 c4 10             	add    $0x10,%esp
8010a4ea:	01 45 f4             	add    %eax,-0xc(%ebp)
  len += http_strcpy((char *)send,"\r\nHello World!\r\n",len);
8010a4ed:	8b 45 10             	mov    0x10(%ebp),%eax
8010a4f0:	83 ec 04             	sub    $0x4,%esp
8010a4f3:	ff 75 f4             	pushl  -0xc(%ebp)
8010a4f6:	68 99 c6 10 80       	push   $0x8010c699
8010a4fb:	50                   	push   %eax
8010a4fc:	e8 31 00 00 00       	call   8010a532 <http_strcpy>
8010a501:	83 c4 10             	add    $0x10,%esp
8010a504:	01 45 f4             	add    %eax,-0xc(%ebp)
  if(len%2 != 0){
8010a507:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a50a:	83 e0 01             	and    $0x1,%eax
8010a50d:	85 c0                	test   %eax,%eax
8010a50f:	74 11                	je     8010a522 <http_proc+0x72>
    char *payload = (char *)send;
8010a511:	8b 45 10             	mov    0x10(%ebp),%eax
8010a514:	89 45 f0             	mov    %eax,-0x10(%ebp)
    payload[len] = 0;
8010a517:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010a51a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a51d:	01 d0                	add    %edx,%eax
8010a51f:	c6 00 00             	movb   $0x0,(%eax)
  }
  *send_size = len;
8010a522:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010a525:	8b 45 14             	mov    0x14(%ebp),%eax
8010a528:	89 10                	mov    %edx,(%eax)
  tcp_fin();
8010a52a:	e8 6d ff ff ff       	call   8010a49c <tcp_fin>
}
8010a52f:	90                   	nop
8010a530:	c9                   	leave  
8010a531:	c3                   	ret    

8010a532 <http_strcpy>:

int http_strcpy(char *dst,const char *src,int start_index){
8010a532:	f3 0f 1e fb          	endbr32 
8010a536:	55                   	push   %ebp
8010a537:	89 e5                	mov    %esp,%ebp
8010a539:	83 ec 10             	sub    $0x10,%esp
  int i = 0;
8010a53c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while(src[i]){
8010a543:	eb 20                	jmp    8010a565 <http_strcpy+0x33>
    dst[start_index+i] = src[i];
8010a545:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a548:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a54b:	01 d0                	add    %edx,%eax
8010a54d:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010a550:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a553:	01 ca                	add    %ecx,%edx
8010a555:	89 d1                	mov    %edx,%ecx
8010a557:	8b 55 08             	mov    0x8(%ebp),%edx
8010a55a:	01 ca                	add    %ecx,%edx
8010a55c:	0f b6 00             	movzbl (%eax),%eax
8010a55f:	88 02                	mov    %al,(%edx)
    i++;
8010a561:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  while(src[i]){
8010a565:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a568:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a56b:	01 d0                	add    %edx,%eax
8010a56d:	0f b6 00             	movzbl (%eax),%eax
8010a570:	84 c0                	test   %al,%al
8010a572:	75 d1                	jne    8010a545 <http_strcpy+0x13>
  }
  return i;
8010a574:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010a577:	c9                   	leave  
8010a578:	c3                   	ret    

8010a579 <ideinit>:
static int disksize;
static uchar *memdisk;

void
ideinit(void)
{
8010a579:	f3 0f 1e fb          	endbr32 
8010a57d:	55                   	push   %ebp
8010a57e:	89 e5                	mov    %esp,%ebp
  memdisk = _binary_fs_img_start;
8010a580:	c7 05 50 d3 18 80 a2 	movl   $0x8010f5a2,0x8018d350
8010a587:	f5 10 80 
  disksize = (uint)_binary_fs_img_size/BSIZE;
8010a58a:	b8 00 d0 07 00       	mov    $0x7d000,%eax
8010a58f:	c1 e8 09             	shr    $0x9,%eax
8010a592:	a3 4c d3 18 80       	mov    %eax,0x8018d34c
}
8010a597:	90                   	nop
8010a598:	5d                   	pop    %ebp
8010a599:	c3                   	ret    

8010a59a <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
8010a59a:	f3 0f 1e fb          	endbr32 
8010a59e:	55                   	push   %ebp
8010a59f:	89 e5                	mov    %esp,%ebp
  // no-op
}
8010a5a1:	90                   	nop
8010a5a2:	5d                   	pop    %ebp
8010a5a3:	c3                   	ret    

8010a5a4 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
8010a5a4:	f3 0f 1e fb          	endbr32 
8010a5a8:	55                   	push   %ebp
8010a5a9:	89 e5                	mov    %esp,%ebp
8010a5ab:	83 ec 18             	sub    $0x18,%esp
  uchar *p;

  if(!holdingsleep(&b->lock))
8010a5ae:	8b 45 08             	mov    0x8(%ebp),%eax
8010a5b1:	83 c0 0c             	add    $0xc,%eax
8010a5b4:	83 ec 0c             	sub    $0xc,%esp
8010a5b7:	50                   	push   %eax
8010a5b8:	e8 f2 a3 ff ff       	call   801049af <holdingsleep>
8010a5bd:	83 c4 10             	add    $0x10,%esp
8010a5c0:	85 c0                	test   %eax,%eax
8010a5c2:	75 0d                	jne    8010a5d1 <iderw+0x2d>
    panic("iderw: buf not locked");
8010a5c4:	83 ec 0c             	sub    $0xc,%esp
8010a5c7:	68 aa c6 10 80       	push   $0x8010c6aa
8010a5cc:	e8 f4 5f ff ff       	call   801005c5 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010a5d1:	8b 45 08             	mov    0x8(%ebp),%eax
8010a5d4:	8b 00                	mov    (%eax),%eax
8010a5d6:	83 e0 06             	and    $0x6,%eax
8010a5d9:	83 f8 02             	cmp    $0x2,%eax
8010a5dc:	75 0d                	jne    8010a5eb <iderw+0x47>
    panic("iderw: nothing to do");
8010a5de:	83 ec 0c             	sub    $0xc,%esp
8010a5e1:	68 c0 c6 10 80       	push   $0x8010c6c0
8010a5e6:	e8 da 5f ff ff       	call   801005c5 <panic>
  if(b->dev != 1)
8010a5eb:	8b 45 08             	mov    0x8(%ebp),%eax
8010a5ee:	8b 40 04             	mov    0x4(%eax),%eax
8010a5f1:	83 f8 01             	cmp    $0x1,%eax
8010a5f4:	74 0d                	je     8010a603 <iderw+0x5f>
    panic("iderw: request not for disk 1");
8010a5f6:	83 ec 0c             	sub    $0xc,%esp
8010a5f9:	68 d5 c6 10 80       	push   $0x8010c6d5
8010a5fe:	e8 c2 5f ff ff       	call   801005c5 <panic>
  if(b->blockno >= disksize)
8010a603:	8b 45 08             	mov    0x8(%ebp),%eax
8010a606:	8b 40 08             	mov    0x8(%eax),%eax
8010a609:	8b 15 4c d3 18 80    	mov    0x8018d34c,%edx
8010a60f:	39 d0                	cmp    %edx,%eax
8010a611:	72 0d                	jb     8010a620 <iderw+0x7c>
    panic("iderw: block out of range");
8010a613:	83 ec 0c             	sub    $0xc,%esp
8010a616:	68 f3 c6 10 80       	push   $0x8010c6f3
8010a61b:	e8 a5 5f ff ff       	call   801005c5 <panic>

  p = memdisk + b->blockno*BSIZE;
8010a620:	8b 15 50 d3 18 80    	mov    0x8018d350,%edx
8010a626:	8b 45 08             	mov    0x8(%ebp),%eax
8010a629:	8b 40 08             	mov    0x8(%eax),%eax
8010a62c:	c1 e0 09             	shl    $0x9,%eax
8010a62f:	01 d0                	add    %edx,%eax
8010a631:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(b->flags & B_DIRTY){
8010a634:	8b 45 08             	mov    0x8(%ebp),%eax
8010a637:	8b 00                	mov    (%eax),%eax
8010a639:	83 e0 04             	and    $0x4,%eax
8010a63c:	85 c0                	test   %eax,%eax
8010a63e:	74 2b                	je     8010a66b <iderw+0xc7>
    b->flags &= ~B_DIRTY;
8010a640:	8b 45 08             	mov    0x8(%ebp),%eax
8010a643:	8b 00                	mov    (%eax),%eax
8010a645:	83 e0 fb             	and    $0xfffffffb,%eax
8010a648:	89 c2                	mov    %eax,%edx
8010a64a:	8b 45 08             	mov    0x8(%ebp),%eax
8010a64d:	89 10                	mov    %edx,(%eax)
    memmove(p, b->data, BSIZE);
8010a64f:	8b 45 08             	mov    0x8(%ebp),%eax
8010a652:	83 c0 5c             	add    $0x5c,%eax
8010a655:	83 ec 04             	sub    $0x4,%esp
8010a658:	68 00 02 00 00       	push   $0x200
8010a65d:	50                   	push   %eax
8010a65e:	ff 75 f4             	pushl  -0xc(%ebp)
8010a661:	e8 38 a7 ff ff       	call   80104d9e <memmove>
8010a666:	83 c4 10             	add    $0x10,%esp
8010a669:	eb 1a                	jmp    8010a685 <iderw+0xe1>
  } else
    memmove(b->data, p, BSIZE);
8010a66b:	8b 45 08             	mov    0x8(%ebp),%eax
8010a66e:	83 c0 5c             	add    $0x5c,%eax
8010a671:	83 ec 04             	sub    $0x4,%esp
8010a674:	68 00 02 00 00       	push   $0x200
8010a679:	ff 75 f4             	pushl  -0xc(%ebp)
8010a67c:	50                   	push   %eax
8010a67d:	e8 1c a7 ff ff       	call   80104d9e <memmove>
8010a682:	83 c4 10             	add    $0x10,%esp
  b->flags |= B_VALID;
8010a685:	8b 45 08             	mov    0x8(%ebp),%eax
8010a688:	8b 00                	mov    (%eax),%eax
8010a68a:	83 c8 02             	or     $0x2,%eax
8010a68d:	89 c2                	mov    %eax,%edx
8010a68f:	8b 45 08             	mov    0x8(%ebp),%eax
8010a692:	89 10                	mov    %edx,(%eax)
}
8010a694:	90                   	nop
8010a695:	c9                   	leave  
8010a696:	c3                   	ret    
