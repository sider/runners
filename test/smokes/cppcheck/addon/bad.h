#ifndef __INC2038
#define _USE_TIME_BITS64

typedef int clockid_t;

typedef int __time_t;

typedef long int __syscall_slong_t;

extern int clock_gettime(clockid_t clk_id);

#define CLOCK_REALTIME 0

#endif