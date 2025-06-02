#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

extern void printpt(int pid);
int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int n;
  if(argint(0, &n) < 0)
    return -1;

  struct proc *p = myproc();
  uint oldsz = p->sz;           // 호출 전 힙 끝
  uint newsz = oldsz + n;       // 늘어난(또는 줄어든) 힙 끝

  /* ───── 경계 체크 ─────
     USERTOP 은 memlayout.h 에 0x80000000 으로 정의돼 있음               */
  if(newsz >= USERTOP || newsz < PGSIZE)
    return -1;

  /* ───── 크기 조정 ───── */
  if(n < 0){
    // 힙 축소 : 이미 매핑된 페이지만 언맵
    if(deallocuvm(p->pgdir, oldsz, newsz) == 0)
      return -1;                // 실패 시 -1
  }
  /* n > 0 인 경우 : lazy allocation
     ── 실제 물리 페이지를 붙이지 않고 sz 값만 늘린다                 */

  p->sz = newsz;
  return oldsz;                 // glibc sbrk 규약 : 이전 브레이크 반환
}


int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}


int
sys_printpt(void)
{
  int pid;
  if(argint(0, &pid) < 0) return -1;
  printpt(pid);
  return 0;
}
