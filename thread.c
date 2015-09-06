#include <pthread.h>

int pthread_create(pthread_t *thread, const pthread_attr_t *attr,
                   void *(*start_routine) (void *), void *arg)
{
	// typedef unsigned long pthread_t;
	*thread = start_routine(arg);
	return 0;
}

int pthread_join(pthread_t thread, void **retval)
{
	*retval = thread;
	return 0;
}

int pthread_condattr_getclock(const pthread_condattr_t *attr,
        clockid_t *clock_id)
{
    return 0;
}

int pthread_condattr_setclock(pthread_condattr_t *attr,
        clockid_t clock_id)
{
    return 0;
}

int pthread_cond_timedwait(pthread_cond_t   *cond,    pthread_mutex_t
        *mutex, const struct timespec *abstime)
{
    return 0;
}
