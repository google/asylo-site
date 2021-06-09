---

title: Asylo Runtime

overview: The Asylo environment and runtime behavior expectations.

location: /_docs/reference/runtime.md

order: 10

layout: docs

type: markdown

---


## Overview

This document describes the Asylo environment and the runtime behavior expected
of the implementation.

## POSIX

Asylo implements a system interface layer and exposes it to application programs
via a small subset of POSIX. In some cases, Asylo does not fully support the
semantics required by POSIX as they may be impossible or undesirable to
implement in the context of a secure enclave. This section gives a brief
description of the features provided by the runtime and how they deviate from
POSIX.

### dirent.h

`closedir`, `opendir`, `readdir`, `rewinddir`, `seekdir`, and `telldir` are all
not implemented and will call `abort`.

### dlfcn.h

`dlopen`, `dlsym`, `dlclose`, `dlerror` are not implemented and will call
`abort`, as they may cause security issues.

### fcntl.h

#### `fcntl`

In current Asylo implementation of `fcntl`, only the `cmd`s `F_GETFD`,
`F_SETFD`, `F_GETFL`, `F_SETFL`, and `F_DUPFD` are implemented. -1 is returned
if `fcntl` is called with any other `cmd`, and `errno` will be set to `EINVAL`.

##### `F_SETFL`

When `fcntl` is called inside an enclave with `cmd` `F_SETFL` on an `fd` backed
by a file on the host, the file status flags will be set to `arg` on the host
after exiting enclave. If it is called on a secure `fd`, -1 is returned and
`errno` is set to `ENOSYS`.

##### `F_GETFL`

When `fcntl` is called inside an enclave with `cmd` `F_GETFL` on an `fd` backed
by a file on the host, the file status flags will be obtained from the host. If
it is called on a secure `fd`, -1 is returned and `errno` is set to `ENOSYS`.

##### `F_SETFD`

When `fcntl` is called inside an enclave with `cmd` `F_SETFD` on an `fd` backed
by a file on the host, the file descriptor flags will be set to `arg` on the
host after exiting enclave. If it is called on a secure `fd`, -1 is returned and
`errno` is set to `ENOSYS`.

##### `F_GETFL`

When `fcntl` is called inside an enclave with `cmd` `F_GETFL` on an `fd` backed
by a file on the host, the file descriptor flags will be obtained from the host.
If it is called on a secure `fd`, -1 is returned and `errno` is set to `ENOSYS`.

##### `F_DUPFD`

When `fcntl` is called inside an enclave with `cmd` `F_DUPFD`, Asylo will
duplicate the file descriptor `fd` using the lowest-numbered available file
descriptor greater than or equal to `arg`. Since Asylo keeps track of all Asylo
file descriptors, the process happens all inside an enclave.

### `open`

`open` generally exits the enclave and opens a file on the host. The host `fd`
returned is stored inside the enclave, and an enclave specific `fd` is assigned
and returned. However, if `open` is called on `/dev/random` or `/dev/urandom`,
it assigns an enclave specific `fd` directly without exiting the enclave.

### fnmatch.h

#### `fnmatch`

`fnmatch` is not implemented and will `abort`

### grp

#### `getgrgid_r` and `getgrnam_r`

`getgrgid_r` and `getgrnam_r` are not implemented and will `abort`

### ifaddrs.h

#### `getifaddrs`

When `getifaddrs` is called from inside an enclave, it is invoked on the host.
The resulting linked list is serialized and then copied into the enclave and
deserialized there. It is important to note that Asylo only supports IPv4 and
IPv6 address families. Consequently, all ifaddrs entries that don't have these
formats are filtered out when they are passed to the enclave from the host.

### net/if.h

#### `if_nametoindex`

When `if_nametoindex` is called from inside an enclave, it exits the enclave and
gets the index on the host, which is passed back into the enclave. It is not
causing security issues as it only gets corresponding |ifindex| from the host.
The index is obtained on the host though and is untrusted.

#### `if_indextoname`

When `if_indextoname` is called from inside an enclave, it exits the enclave and
gets the name on the host, which is passed back into the enclave. It is not
causing security issues as it only gets corresponding |ifname| from the host.
The name is obtained on the host though and is untrusted.

### netdb.h

#### `getservbyname` and `getservbyport`

These calls are not implemented and calls to them will result in `abort`.

### nl_types.h

#### `catclose`, `catgets` and `catopen` are not implemented and return error.

### poll.h

#### `poll`

`poll` converts the provided fds from enclave fds to host fds, exits the enclave
and waits on the host poll.

Upon error, the return value and errono are set by the host.

### pthread.h

All `pthread_foo` calls that contain a `mutex` parameter, `attr` parameter or a
conditional vairable `cond` parameter first check whether the `mutex`, `attr`,
or `cond` parameters point to a valid enclave address, and return `EFAULT` if
not.

#### `pthread_attr_destroy`

`pthread_attr_destroy` returns 0 after verifying `attr` is a valid enclave
address.

#### `pthread_attr_init`

`pthread_attr_init` sets `detach_state` of `attr` to `PTHREAD_CREAT_JOINABLE`.

#### `pthread_attr_setdetachstate`

`pthread_attr_setdetachstate` sets `detach_state` of `attr` to `type`, unless
`type` is `PTHREAD_CREATE_JOINABLE` or `PTHREAD_CREATE_DETACHED`.

\#### `pthread_attr_getschedpolicy`/`pthread_attr_setschedpolicy`
/`pthread_attr_getscope`/`pthread_attr_setscope`/`pthread_attr_getschedparam`
/`pthread_attr_setschedparam`/`pthread_attr_getstacksize`
/`pthread_attr_setstacksize`

`pthread_attr_getschedpolicy`, `pthread_attr_setschedpolicy`,
`pthread_attr_getscope`, `pthread_attr_setscope`, `pthread_attr_getschedparam`,
`pthread_attr_setschedparam`, `pthread_attr_getstacksize`, and
`pthread_attr_setstacksize` are not implemented and returns `ENOSYS`.

#### `pthread_cancel`/`pthread_setcancelstate`/`pthread_setcanceltype`

`pthread_cancel`, `pthread_setcancelstate` and `pthread_setcanceltype` are not
implemented and will always return `ENOSYS`.

#### `pthread_cleanup_push` and `pthread_cleanup_pop`

The process and parent process identification numbers are obtained from the host
operating system to make sure the value is consistent with the host.

#### `pthread_cond_broadcast`

`pthread_cond_broadcast` checks the list waiting on `cond`, and wakes all
threads in the list.

#### `pthread_cond_destroy`

`pthread_cond_destroy` checks the list waiting on the conditional variable
`cond`, and returns `EBUSY` if so. It returns 0 on success.

#### `pthread_cond_init`

`pthread_cond_init` always initializes `cond` to `PTHREAD_COND_INITIALIZER`.
`attr` is ignored.

#### `pthread_cond_signal`

`pthread_cond_signal` checks the list waiting on `cond`, and wakes the first
waiting thread.

#### `pthread_cond_timedwait`

`pthread_cond_timedwait` is similar to `pthread_cond_wait`. Instead of blocking
indefinitely, the `timedwait` variant takes an extra argument, `abstime`, that
specifies a deadline (in absolute UNIX time) after which the function should
return `ETIMEDOUT`. However, as Asylo enclaves do not have a source of secure
time, these semantics can not be guaranteed. A hostile host could cause
`pthread_cond_timedwait` to either return `ETIMEDOUT` immediately, or never time
out, acting like `pthread_cond_wait`.

#### `pthread_cond_wait`

`pthread_cond_wait` invokes `pthread_cond_timedwait` directly, with `deadline`
parameter of `pthread_cond_timedwait` set as `nullptr`.

#### `pthread_condattr_init`/`pthread_condattr_destroy`

`pthread_condattr_init` and `pthread_condattr_destroy` are not implemented and
returns 0 directly.

#### `pthread_create`

`pthread_create` exits the enclave, creates an untrusted thread, which invokes
an EnterAndDonateThread entry point to enter the enclave in a bound trusted
thread, and executes the user code for the thread.

#### `pthread_detach`

`pthread_detach` invokes `pthread_cond_broadcast` on a `state_change_cond`
variable maintained by the `Thread` object corresponding to the thread id
parameter to unblock threads currently waiting for a state change from the
target thread, and marks the thread as detached.

#### `pthread_getspecific`/`pthread_setspecific`

A thread-local array of size 64 is stored inside the enclave.
`pthread_setspecific` sets the values corresponding to the key, and
`pthread_getspecific` returns value from the array. The key can not be larger
than 64 and should be obtained through `pthread_key_create`.

#### `pthread_join`

`pthread_join` waits for the corresponding trusted thread to finish executing
the job.

#### `pthread_key_create`

`pthread_key_create` maintains a `static` count of provided pthreads. When this
count reaches `PTHREAD_KEYS_MAX` no more keys will be issued, and
`pthread_key_create` will only return `EAGAIN`.

`pthread_key_create` does not provide support for supplied destructors. Any
destructors supplied will be ignored.

#### `pthread_key_delete`

`pthread_key_delete` removes the key from the `used_thread_key` list and makes
it available to be assigned again.

\####
`pthread_mutexattr_init`/`pthread_mutexattr_destroy`/`pthread_mutexattr_settype`

`pthread_mutexattr_init`, `pthread_mutexattr_destroy`, and
`pthread_mutexattr_settype` are not implemented and return 0.

#### `pthread_mutex_init`

`pthread_mutex_init` initializes `mutex` to `PTHREAD_MUTEX_INITIALIZER`. `attr`
parameter is ignored.

#### `pthread_mutex_destroy`

`pthread_mutex_destroy` checks if there are threads waiting on `mutex`, and
returns `EBUSY` if so.

#### `pthread_mutex_lock`

`pthread_mutex_lock` adds the calling thread to the list waiting for `mutex`. It
then continuously checks whether mutex is available and the calling thread is in
the front of the queue. If not, it calls `sched_yield` to lower the priority of
the calling thread, until it checks the mutex list again. It removes the calling
thread from the waiting list once it owns the mutex.

#### `pthread_mutex_trylock`

`pthread_mutex_trylock` checks whether `mutex` is taken, returns `EBUSY` if so,
or 0 if the mutex is available.

#### `pthread_mutex_unlock`

`pthread_mutex_unlock` changes the state of `mutex` back to available. It
returns `EINVAL` if the mutex is already available, or `EPERM` if `mutex` is not
owned by the calling thread.

#### `pthread_once`

`pthread_once` checks the state of `once` and calls `init_routine` exactly once.

#### `pthread_rwlock_destroy`

`pthread_rwlock_destroy` returns 0 if `rwlock` has no writer owners and the
waiting list is empty. Otherwise returns `EBUSY`.

#### `pthread_equal`

`pthread_equal` compares `thread_one` and `thread_two` directly, returns 0 if
they are equal, and -1 if not.

#### `pthread_rwlock_init`

`pthread_rwlock_init` initializes `rwlock` to `PTHREAD_RWLOCK_INITIALIZER`.
`attr` is ignored.

#### `pthread_rwlock_tryrdlock`

`pthread_rwlock_tryrdlock` checks if `rwlock` is owned by a write owner, and
returns EBUSY if so. It then checks if the waiting queue is empty or the calling
thread is in the front of the queue. If so, it increments the reader counter and
removes the calling thread from the waiting queue, and returns 0.

#### `pthread_rwlock_trywrlock`

`pthread_rwlock_trywrlock` returns `EBUSY` if `rwlock` has either non-zero
readers or a write owner. It returns `EDEADLK` if `rwlock` is owned by the
current thread already. Otherwise, it checks whether the waiting queue is empty
or the calling thread is in the front of the queue. If so, it takes write
ownership of `rwlock` and returns 0.

#### `pthread_rwlock_rdlock`

`pthread_rwlock_rdlock` adds the calling thread to the waiting list on `rwlock`.
It then keeps calling `pthread_rwlock_tryrdlock`, and invokes `sched_yield` to
lower the priority of the calling thread, until `pthread_rwlock_tryrdlock`
returns a result other than `EBUSY`.

#### `pthread_rwlock_wrlock`

`pthread_rwlock_wrlock` adds the calling thread to the waiting list on `rwlock`.
It then keeps calling `pthread_rwlock_trywrlock`, and invokes `sched_yield` to
lower the priority of the calling thread, until `pthread_rwlock_trywrlock`
returns a result other than `EBUSY`.

#### `pthread_rwlock_unlock`

`pthread_rwlock_unlock` makes `rwlock` write lock available if the calling
thread is the owner of the write lock. Otherwise, it decreases the reader
reference of `rwlock` by 1.

#### `pthread_self`

`pthread_self` returns the address of a static thread-local variable. Since each
thread is allocated a distinct instance of this variable, and all instances are
in the same address space, this guarantees a distinct non-zero value is
provisioned to each thread.

### pwd.h

#### `getpwuid`

The enclave stores a global `passwd` struct. When `getpwuid` is called, it exits
the enclave, calls host `getpwuid`, copies the buffers into the enclave global
buffers, directs the pointers in the global `passwd` struct to the global
buffers, and returns a pointer to that global struct. The size of each buffer is
limited to 1024 bytes. And this call is not thread safe, same as the host
`getpwuid`.

#### `getpwuid_r` and `getpwnam_r`

`getpwuid_r` and `getpwnam_r` are not implemented and will call `abort`.

### sched.h

#### `sched_getaffinity`

When `sched_getaffinity` is called inside an enclave, the enclave passes control
to the host to make this call and then transmit mask back inside the enclave.
The enclave implements its own `cpu_set_t` type that supports up to 1,024 CPUs.

If `cpusetsize` is less than `sizeof(/*enclave-native*/ cpu_set_t)`, then
`sched_getaffinity` returns -1 and sets `errno` to `EINVAL`. If the number of
CPUs supported by the host is different from 1,024, then all calls to
`sched_getaffinity` return -1 and set `errno` to `ENOSYS`.

To accommodate CPU set manipulations inside the enclave, we provide
implementations of the following macros from CPU_SET(3) for use with in-enclave
`cpu_set_t`s:

*   `void CPU_ZERO(cpu_set_t *set)`
*   `void CPU_SET(int cpu, cpu_set_t *set)`
*   `void CPU_CLR(int cpu, cpu_set_t *set)`
*   `int CPU_ISSET(int cpu, cpu_set_t *set)`
*   `int CPU_COUNT(cpu_set_t *set)`
*   `int CPU_EQUAL(cpu_set_t *set1, cpu_set_t *set2)`

### `sched_yield`

`sched_yield` exits the enclave and invokes the corresponding syscall on the
host.

### semaphore.h

For all `sem_foo` calls inside an enclave, the address of `sem` is first checked
to ensure it is a valid enclave address. `EFAULT` is returned if not.

#### `sem_destroy`

`sem_destroy` destroys `sem` inside the enclave after verifying `sem` is in a
valid enclave address space.

#### `sem_getvalue`

`sem_getvalue` places the value of `sem` inside an enclave to `sval`.

#### `sem_init`

Shared (named) semaphores are not supported in Asylo. `sem_init` must be called
with `pshared=0`. Any other value will cause `sem_init` to fail with `ENOSYS`.

#### `sem_post`

`sem_post` unlocks `sem` and unblocks a thread inside an enclave that might be
waiting for it.

#### `sem_timedwait`

`sem_timedwait` has a similar issue to `pthread_cond_timedwait`. The lack of a
secure time source in an enclave means that timeout semantics can not be
guaranteed. A hostile host could cause `sem_timedwait` to either return
immediately with `errno` set to `ETIMEDOUT`, or wait indefinitely as `sem_wait`
would.

#### `sem_trywait` invokes `sem_timedwait` with `abs_timeout` parameter passed

as 0.

#### `sem_wait`

`sem_wait` invokes `sem_timedwait` with `abs_timeout` parameter passed as a
`nullptr`.

### signal.h

#### `sigaction`

The User may register their own signal handlers inside an enclave. When a signal
is registered inside an enclave, the signal-handling struct `sigaction` is
subsequently registered inside the enclave. Additionally, a host-side signal
handler (signal dispatcher) is registered that delegates handling of raised
signals to the enclave. Once a registered signal is raised, the signal
dispatcher identifies which enclave last registered the signal[^1], enters it,
and calls the corresponding registered signal handler. Enclaves ignore
unregistered signals.

In the signal handling struct `act`, registering a signal handler with either
`sa_handler(int)` or `sa_sigaction(int, siginfo_t *, void *)` is supported. To
use the latter, set `sa_flags` in `act` to `SA_SIGINFO`. Other flags are
ignored. `sa_mask` is ignored. The `ucontext` parameter in `sa_sigaction` is
also ignored while handling the signal.

For intel sgx, `SIGILL` is registered and handled by sgx exception handler.
`sigaction` returns error if it is called to register a signal handler for
`SIGILL`.

#### `sigprocmask`

A thread-local signal mask is stored inside an enclave. When `sigprocmask` is
called, both the mask inside the enclave and the mask on the host are set
accordingly. If a blocked signal enters an enclave, an error will be logged with
a message that says the signal mask inside/outside the enclave is out of sync.
The order to block/unblock the signals inside the enclave and on the host
depends on the argument `how`:

*   `SIG_BLOCK`: the specified signals are blocked on the host first, then
    inside the enclave.
*   `SIG_UNBLOCK`: the specified signals are unblocked inside the enclave first,
    then on the host.
*   `SIG_SETMASK`, the mask is separated into two sets: which signals to block,
    and which ones to unblock. The signals to be unblocked are processed inside
    the enclave first, then both signals to block and unblock are processed on
    the host, finally signals to block are processed inside the enclave.

#### `pthread_sigmask`

`pthread_sigmask` is implemented by invoking `sigprocmask` directly.

#### `raise`

When a signal is raised inside an enclave, it is sent to the host to be raised
on the host side. If a handler has been registered for this signal in the
enclave, the signal handler on the host enters the enclave to invoke the
registered handler.

### stdlib.h

#### `abort`

In the general case, the runtime cannot guarantee that `abort` will destroy the
enclave or the client. These resources are controlled by the host operating
system which must be assumed to behave in an adversarial fashion. The runtime is
only able to provide for abnormal termination on a best-effort basis.

The enclave implementation of `abort` will prevent any further calls into the
enclave through an enclave entry point, and it will prevent any thread from
leaving the enclave by returning from an entry point handler. The mechanism used
to prevent unsafe exits from an aborted enclave does not accommodate running
untrusted code for signal handlers or `atexit` callbacks. It is not guaranteed
to raise `SIGABRT`, flush buffered I/O streams, or interrupt threads running in
the enclave.

#### `realpath`

`realpath` normalized the form of the path, but it does not resolve symbolic
links present on the host for path components referring to items on the host.
Calls to `realpath` get handled completely within the enclave.

### sys/epoll.h

#### `epoll_create`

A call to `epoll_create` forwards the call to the host to create a new epoll
isntance and returns a file descriptor to that instance. `epoll_create` expects
a positive value for the size, if it receives a 0 or negative value, it will
return -1 and set errno to `EINVAL`.

#### `epoll_create1`

Since we do not yet support `fork`, `epoll_create1` forwards requests to
`epoll_create`.

#### `epoll_ctl`

A call to `epoll_ctl` is forwarded to the host. `epoll_ctl` supports
`EPOLL_CTL_ADD`, `EPOLL_CTL_MOD`, and `EPOLL_CTL_DEL`. It forwards the event to
the host. If an unknown file descriptor is provided, the function returns -1 and
sets `errno` to `EBADF`.

#### `epoll_wait`

A call to `epoll_wait` is forwarded to the host. If maxevents is less than or
equal to zero, `epoll_wait` returns -1 and sets errno to `EINVAL`.

### sys/eventfd.h

#### `eventfd`

`eventfd` provides a semaphore-like interface via a file descriptor. This
functionality is implemented entirely within the enclave and not delegated to
the host.

### sys/file.h

#### `flock`

When `flock` is called inside an enclave with an `fd` backed by a file on the
host, it will be invoked on the corresponding file on the host.

### sys/ioctl

#### `ioctl`

`ioctl` is implemented for secure path file descriptors. Currently `ioctl` only
accepts the `ENCLAVE_STORAGE_SET_KEY` request defined in
`asylo/secure_storage.h`.

If called on a file descriptor for anything other than a secure path, or given
an invalid request, `ioctl` will error, set errno to `ENOSYS` and return -1.

### sys/inotify.h

The current implementation of `inotify` for Asylo forwards calls to
`inotify_add_watch` and `inotify_rm_watch` directly to the host. In order to
accommodate for differences of struct layouts/sizes between the host and
enclave, any events that are received from the host that cannot fit into the
buffer supplied to `read` are queued and returned in a subsequent `read`. Only
the IN_NONBLOCK flag is supported for `inotify_init1`.

### sys/mman.h

#### `mmap`

`mmap` only supports simple `MAP_ANONYMOUS` mappings to allocate 4k-aligned
blocks of memory; these are translated internally to `memalign` calls. In
particular, the mapping of files is not supported.

Specifically, `addr` must be NULL, `prot` must be `PROT_READ | PROT_WRITE`,
`flags` must be `MAP_ANONYMOUS | MAP_PRIVATE`, `fd` must be `-1`, and offset
must be `0`. If not, this call will return `MAP_FAILED` and will set `errno` to
`ENOSYS`.

#### `int munmap`

Because `mmap` can only return pointers to heap-allocated memory, calls to
`munmap(addr, length)` are translated to `free(addr)`, and this function will
always return 0. If passed a pointer not returned by `mmap`, behavior is
undefined.

### sys/resource.h

#### `getrlimit/setrlimit`

`getrlimit` and `setrlimit` are implemented with resource `RLIMIT_NOFILE` only.
The enclave maintains a soft limit and a hard limit for maximum file descriptor
numbers. When getrlimit is called with `RLIMIT_NOFILE`, these values are
returned. When setrlimit is called with `RLIMIT_NOFILE` with valid limits, these
values will be set accordingly. All enclaves are treated as unprivileged
processes, so they are not allowed to increase the hard limit, but are allowed
to decrease it (irreversibly). The valid range of `RLIMIT_NOFILE` limits is
between 0 and the maximum allowed file descriptors inside the enclave.
`setrlimit` also fails with `EINVAL` if the limit passed is lower than the
highest currently open file descriptor.

#### `getrusage`

`getrusage` is implemented with target as `RUSAGE_SELF` or `RUSAGE_CHILDREN`.
And only `ru_utime` and `ru_stime` in the `rusage` struct is supported. It gets
the resource usage info directly from the host.

### sys/select.h

#### `select`

`select` converts the supplied read, write, and except file descriptors from
enclave file descriptors to host file descriptors. It then exits the enclave and
executes `select` on the host.

Upon returning to the enclave `select` converts the changed read, write, and
except file descriptors back to enclave file descriptors and returns.

On error, -1 is returned, and `errno` is set. The file descriptor sets are
returned unmodified.

### sys/socket.h

#### `getpeername`

When `getpeername` is called inside an enclave on a `sockfd` backed by a file on
the host, the address of the peer will be obtained from the host.

#### `socket`

The `domain` and `type` arguments are translated to a bridge type transparently
across the enclave boundary. This is to ensure that each implementation-defined
symbol such as `AF_UNIX` has its connotation forwarded to the host system, where
`AF_UNIX` might be a different value.

### sys/stat.h

#### `chmod`/`fchmod`

When `chmod` is called inside an enclave on a path or `fd` backed by a file on
the host, the mode of the corresponding file mode on the host is changed.

#### `lstat`

`lstat` exits the enclave and gathers the stats from the host.

If `lstat` is called on path `/dev/random` or `/udev/random`, it sets the values
in the stat according to the values used in Linux random
files(Documentation/admin-guide/devices.txt).

#### `mkdir`

`mkdir` exits the enclave and creates the directory on the host.

#### `stat`/`fstat`

When `stat` and `fstat` called inside an enclave on a directory or an `fd`
backed by a file on the host, they exit the enclave and gathers the stats from
the host.

If `stat` or `fstat` is called on path `/dev/random` or `/udev/random`, or an
`fd` representing these paths, it sets the stat inside the enclave according to
the values used in Linux random files(Documentation/admin-guide/devices.txt).

#### `umask`

When `umask` is called inside enclave, the mask on the host side will be
changed, and the old value is returned. Everytime `open` or `mkdir` is called,
the mask will be checked on the host side. Since the mask is kept on the host
side, it may be different from expected if the operating system is compromised.

### sys/statfs.h

#### `statfs` and `fstatfs`

`statfs` and `fstatfs` exit the enclave and gathers the stats from the host.

### sys/statvfs.h

#### `statvfs` and `fstatvfs`

`statvfs` and `fstatvfs` exit the enclave and gathers the stats from the host.

### stdio.h

#### `rename`

`rename` exits the enclave and changes a file/directory name on the host.

### sys/termios.h

#### `tcgetattr` and `tcsetattr`

`tcgetatter` and `tcsetattr` are not implemented and will `abort`.

### sys/time.h

#### `gettimeofday`

`gettimeofday` exits the enclave and gets the time on the host.

#### `getitimer` and `setitimer`

When `getitimer` or `setitimer` are called inside an enclave, they exit the
enclave and get or set the timers on the host. Therefore, the events generated
by the timers and the timing information received from them are not trustworthy.
Supported timer types are `ITIMER_REAL`, `ITIMER_VIRTUAL` and `ITIMER_PROF`.

#### `times`

When `times` is called inside an enclave, it exits the enclave, and returns the
current process times from the host.

### sys/utsname.h

#### `uname`

`uname` retrieves the system information from the host.

In glibc, `struct utsname` is defined to have fields of length 65 on Linux.
However, according to IETF RFC 1035, fully qualified domain names, such as those
held in the `nodename` field of `struct utsname`, may contain up to 255
characters. Therefore, in Asylo, the fields of `struct utsname` are defined to
have length 256 in order to hold 255 characters and a null byte.

The `domainname` field of `struct utsname` is a GNU extension of POSIX. It is
included in glibc if `_GNU_SOURCE` is defined. It is included unconditionally in
Asylo for maximum compatibility.

### sys/wait.h

#### `wait`

When `wait` is called inside an enclave, it exits the enclave and waits on the
host.

#### `wait3`

When `wait3` is called inside an enclave, it exits enclave, waits on the host,
and returns the resource usage from the host.

#### `waitpid`

When `waitpid` is called inside an enclave, it exits enclave and waits on the
host. The result is returned back into the enclave after it finishes waiting.
Since `waitpid` is returned from the untrusted side, a malicious `terminated`
result may be returned from `waitpid` even when the forked child enclave is
still running.

### sys/uio.h

#### `readv`

`readv` calculates the total size of all the buffers in |iov|, and invokes a
`read` on the host with the total buffer size. It is then copied into each
buffer in |iov|.

#### `writev`

`writev` writes `iovcnt` buffers of data described by `iov` to the file
specified by file descriptor `fd`. Inside an enclave, if `fd` is backed by a
file on the host, a buffer is allocated that is large enough to hold the content
of all the `iov` buffers, and all the `iov` buffers are copied into this buffer.
This buffer is serialized and copied to untrusted memory, which is wirtten to
the file.

### syslog.h

#### `openlog`

When `openlog` is called inside an enclave, the `ident`, `option`, and
`facility` arguments are passed to the host to call `openlog` there.

#### `syslog`

When `syslog` is called inside an enclave, the format is converted to a single
string, passed to the host, and `syslog` on the host is called with that message
string.

### time.h

#### `clock_gettime`

`clock_gettime` exits the enclave and gets the time on the host.

#### `nanosleep`

`nanosleep` exits the enclave and wait on the host.

### unistd.h

#### `access`

When `access` is called inside an enclave on a `fd` backed by a file on the
host, it exits the enclave and checks the file on the host.

#### `chdir`

The host name is set when enclave is initialized, and stored inside the
enclave(see `gethostname`). `chdir` changes the current working directory stored
inside the enclave.

#### `chown` and `fchown`

When `chown` or `fchown` is called inside an enclave on a path or `fd` backed by
a file on the host, the owner/group of the corresponding file will be changed on
the host. If it is called on a secure `fd`, -1 is returned and `errno` is set to
`ENOSYS`.

If `chown` is called on an `fd` representing `/dev/random` or `/udev/random`, it
sets errno to `ENOSYS` and returns -1.

#### `close`

When `close` is called inside an enclave on an `fd` backed by a file on the
host, it exits the enclave and closes the file on the host.

if `close` is called on an `fd` representing `/dev/random` or `/udev/random`, it
returns 0 directly.

#### `dup` and `dup2`

`dup` and `dup2` creates a new file descriptor in `IOManager`, and make the new
fd point to the same `IOContext`, without exiting the enclave.

#### `fork`

`fork` is implemented in Asylo with security features added. When `fork` is
requested from inside an enclave, it takes a snapshot of the enclave, creates a
child process, loads a new enclave in the child, and restores the child enclave
from the snapshot. The following security features for `fork` are provided:

1.  Only the enclavized portion of the application can request a fork.
2.  At most one snapshot can be created per fork request.
3.  `fork` is thread-safe. The thread that requests `fork` blocks enclave
    entries and waits till all other threads are blocked before proceeding to
    take a snapshot.
4.  The cloned enclave has exactly the same identity as the parent enclave.
5.  The cloned enclave's state is the same as that of the parent enclave when it
    called `fork`.
6.  The snapshot is encrypted by a randomly generated AES256-GCM-SIV key.
7.  The parent enclave will send the snapshot key to the child enclave only
    after verifying the child enclave has exactly the same identity.
8.  The key is encrypted while the parent sends it to the child, by a key
    generated from a Diffie-Hellman key exchange.
9.  The parent will only send the key to one child enclave.
10. If there are other threads running in the child enclave while restoring,
    restore stops and rejects all entries into the enclave.
11. If the encrypted snapshot is modified, the child enclave does not restore,
    and rejects all entries.

#### `fsync`/`fdatasync`

When `fsync` or `fdatasync` is called inside an enclave with an `fd` backed by a
file on the host, it will be invoked on the corresponding file on the host.
`fdatasync` inside the enclave is implemented through `fsync` so they do exactly
the same thing.

If `fsync` is called on an `fd` representing `/dev/random` or `/udev/random`, it
returns 0 directly.

#### `getcwd`

A current working directory can be set by the user through `EnclaveConfig` when
the enclave is created. If it's not set by the user, it's default to be the
current working directory on the host. It is then stored inside the enclave.
`getcwd` returns that working directory without exiting the enclave. If `getcwd`
is called prior to enclave is initialized, it returns a placeholder value.

#### `gethostname`

A host name can be set by the user through `EnclaveConfig` when the enclave is
created. If it's not set by the user, it's default to be the host name on the
host. It is then stored inside the enclave. `gethostname` returns that host name
without exiting the enclave.

#### `getpagesize`

`getpagesize` returns a constant representing the simulated page size (4096).

#### `getpid`/`getppid`

The process and parent process identification numbers are obtained from the host
operating system to make sure the value is consistent with the host.

If the host `getpid` call returns 0, the enclave will abort. Zero is not a valid
return value for `getpid` under POSIX, but it is used as a marker in other
system calls that operate with PIDs (e.g. `fork`). Forwarding a returned PID of
0 could cause user code to take unexpected code paths, which could create a
security vulnerability, so the enclave aborts as a precaution.

#### `getuid`/`geteuid`/`getgid`/`getegid`

The user and group identification numbers are obtained from the host operating
system to make sure the value is consistent with the host, in case they change
after enclave is initialized.

The user and group ID values are provided by the untrusted host operating
system. This means their values are potentially controlled by an attacker and
the enclave must assume an adversarial implementation.

In general, this is only a potential vulnerability if the enclave application
uses operating system concepts like user ID to guard resources within the
enclave itself. For instance, if a database application were to restrict access
to a column on the basis of user ID then it must anticipate the case where the
operating system has been compromised and `getuid` returns an insecure value.

#### `isatty`

When `isatty` is called inside an enclave with an `fd` backed by a file on the
host, it exits the enclave and invokes `isatty` on the host file.

If `isatty` is called on an `fd` representing `/dev/random` or `/udev/random`,
it returns 0 directly.

#### `link`

When `link` is called inside an enclave on an `fd` backed by a file on the host,
it exits the enclave and creates the link on the host.

If `link` is called on an `fd` representing `/dev/random` or `/udev/random`, it
sets errno to `ENOSYS` and returns -1.

#### `lseek`

When `lseek` is called inside an enclave with an `fd` backed by a file on the
host, it exits the enclave and repositions the offset of the host file.

if `lseek` is called on an fd representing `/dev/random` or `/udev/random`, it
returns 0 directly.

#### `pipe`/`pipe2`

Pipe reads and writes go through the host. In the enclave, `O_CLOEXEC` is a
meaningless flag, since enclaves do not support `exec`. However, users may still
specify it as a flag to `pipe2`, and subsequent calls to `fcntl` to check the
file descriptor flags on the pipe's file descriptors will show the `FD_CLOEXEC`
flag as being set.

#### `pread`

When `pread` is called inside an enclave with an `fd` backed by a file on the
host, it exits the enclave and calls `pread` the host file.

#### `read`

When `read` is called inside an enclave on an `fd` backed by a file on the host,
it exits the enclave, reads the host file, and passes the message back into the
enclave.

In case `read` is called on an `fd` representing `/dev/random` or
`/udev/random`:

1.  If the backend is SGX hardware, it accesses SGX hardware to fill the buffer
    with random values generated with the rdrand instruction from SGX hardware.

1.  If the backend is SGX simulation mode, it fills the buffer generated by
    rand(). This is not a cryptographically strong source of randomness and
    should never be used in a secure application. It is only sufficient for the
    simulation backend because it is not intended for production use.

1.  Any other backends: `read` on random path is not supported.

#### `rmdir`

`rmdir` exits the enclave and deletes the directory on the host.

#### `setsid`

`setsid` exits the enclave and invokes `setsid` on the host.

#### `sleep` and `usleep`

`sleep` and `usleep` exits the enclave and sleeps on the host.

#### `symlink`

`symlink` exits the enclave and creates the symbolic link on the host.

#### `sysconf`

When `sysconf` is called inside the enclave, it attempts to return a reasonable
value, often from the host. Currently, the only supported arguments are:

*   `_SC_NPROCESSORS_CONF`
    *   Return value retrieved from the host. Management of CPU resources is
        fully delegated to the host.
*   `_SC_NPROCESSORS_ONLN`
    *   Return value retrieved from the host. Management of CPU resources is
        fully delegated to the host.
*   `_SC_PAGESIZE`
    *   Return value produced within the enclave. Management of the memory pool
        is implemented in the enclave and a malicious value provided by the host
        could trigger unwanted behavior.

If called with any other argument, `sysconf` returns -1 and sets `errno` to
`ENOSYS`.

#### `truncate/ftruncate`

When `truncate` or `ftruncate` is called inside an enclave on a path or `fd`
backed by a file on the host, the corresponding file will be truncated on the
host. It it is called on a secure `fd`, -1 is returned and `errno` is set to
`ENOSYS`.

#### `vfork`

`vfork` is implemented through `fork` in Asylo. When `vfork` is requested from
inside an enclave, `fork` is invoked to create the child enclave. The parent
thread then waits till the child exits before returning. Therefore, `vfork` in
an enclave does not have better performance than `fork`.

#### `unlink`

When `unlink` is called inside an enclave on an `fd` backed by a file on the
host, it exits the enclave and deletes the file on the host.

If `unlink` is called on an `fd` representing `/dev/random` or `/udev/random`,
it sets errno to `ENOSYS` and returns -1.

#### `write`

When `write` is called inside an enclave on an `fd` backed by a file on the
host, it passes the message to the host and writes to the host file.

If `write` is called on an `fd` representing `/dev/random` or `/udev/random`, it
sets errno to `EBADF` and returns -1, as they should be read-only.

### utime.h

#### `utime`

When `utime` is called inside an enclave it makes the call on the host passing
the filename and times variable directly.

#### `utimes`

When `utimes` is called inside an enclave it makes the call on the host passing
the filename and times variable directly.

### xattr.h

#### `get/set/listattr`

For all the xattr calls, including {get, set, list}attr, {get, set, list}lattr,
and {get, set, list}fxattr, when they are invoked from inside the enclave, they
are deligated to the host and the correponding extended attributes of the file
is get/set/listed.

[^1]: The current implementation does not support multiple enclaves registering
    the same signal. If that happens, the latter will overwrite the former.
