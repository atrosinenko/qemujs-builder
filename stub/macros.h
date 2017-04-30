#define sigjmp_buf jmp_buf
#define sigsetjmp(env, sigs) setjmp((env))
#define siglongjmp longjmp
