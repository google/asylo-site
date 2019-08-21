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

`closedir`, `opendir` , `readdir`, `rewinddir`, `seekdir`, and `telldir` all not
implemented and will call abort().

### fnmatch.h

#### `fnmatch`

`fnmatch` is not implemented and will `abort()`

### grp

#### `getgrgid_r` and `getgrnam_r`

`getgrgid_r` and `getgrnam_r` are not implemented and will `abort()`

### ifaddrs.h

#### `getifaddrs(struct ifaddrs **ifap)`

When `getifaddrs` is called from inside an enclave, it is invoked on the host.
The resulting linked list is serialized and then copied into the enclave and
deserialized there. It is important to note that Asylo only supports IPv4 and
IPv6 address families. Consequently, all ifaddrs entries that don't have these
formats are filtered out when they are passed to the enclave from the host.

### netdb.h

#### `getservbyname` and `getservbyport`

These calls are not implemented and calls to them will result in `abort()`.

### poll.h

#### `poll`

`poll` converts the provided fds from enclave fds to host fds, exits the enclave
and waits on the host poll.

Upon error, the return value and errono are set by the host.

### pthread.h

#### `pthread_cancel(pthread_t thread_id)`

`pthread_cancel` is not implemented and will always return `ENOSYS`.

#### `pthread_cleanup_push` and `pthread_cleanup_pop`

The process and parent process identification numbers are obtained from the host
operating system to make sure the value is consistent with the host.

If the host `getpid()` call returns 0, the enclave will abort. Zero is not a
valid return value for `getpid()` under POSIX, but it is used as a marker in
other system calls that operate with PIDs (e.g. `fork()`). Forwarding a returned
PID of 0 could cause user code to take unexpected code paths, which could create
a security vulnerability, so the enclave aborts as a precaution.

#### `int pthread_cond_timedwait(pthread_cond_t *cond, pthread_mutex_t *mutex, const struct timespec *abstime)`

`pthread_cond_timedwait()` is similar to `pthread_cond_wait()`. Instead of
blocking indefinitely, the `timedwait` variant takes an extra argument,
`abstime`, that specifies a deadline (in absolute UNIX time) after which the
function should return `ETIMEDOUT`. However, as Asylo enclaves do not have a
source of secure time, these semantics can not be guaranteed. A hostile host
could cause `pthread_cond_timedwait()` to either return `ETIMEDOUT` immediately,
or never time out, acting like `pthread_cond_wait()`.

#### `pthread_key_create`

`pthread_key_create` maintains a `static` count of provided pthreads. When this
count reaches `PTHREAD_KEYS_MAX` no more keys will be issued, and
`pthread_key_create` will only return `EAGAIN`.

`pthread_key_create` does not provide support for supplied destructors. Any
destructors supplied will be ignored.

#### `pthread_key_delete`

`pthread_key_delete` is not implemented and will return 0.

### pwd.h

#### `getpwuid`

The enclave stores a global `passwd` struct. When `getpwuid` is called, it exits
the enclave, calls host `getpwuid`, copies the buffers into the enclave global
buffers, directs the pointers in the global `passwd` struct to the global
buffers, and returns a pointer to that global struct. The size of each buffer is
limited to 1024 bytes. And this call is not thread safe, same as the host
`getpwuid`.

#### `getpwuid_r` and `getpwnam_r`

`getpwuid_r` and `getpwnam_r` are not implemented and will call `abort()`.

### sched.h

#### `sched_getaffinity(pid_t pid, size_t cpusetsize, cpu_set_t *mask)`

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

### semaphore.h

#### `sem_init(sem_t *sem, const int pshared, const unsigned int value)`

Shared (named) semaphores are not supported in Asylo. `sem_init()` must be
called with `pshared=0`. Any other value will cause `sem_init` to fail with
`ENOSYS`.

#### `sem_timedwait(sem_t *sem, const timespec *abstime)`

`sem_timedwait()` has a similar issue to `pthread_cond_timedwait()`. The lack of
a secure time source in an enclave means that timeout semantics can not be
guaranteed. A hostile host could cause `sem_timedwait()` to either return
immediately with `errno` set to `ETIMEDOUT`, or wait indefinitely as
`sem_wait()` would.

### signal.h

#### `sigaction(int signum, const struct sigaction *act, struct sigaction *oldact)`

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
ignored. `sa_mask` is ignored.

For intel sgx, `SIGILL` is registered and handled by sgx exception handler.
`sigaction` returns error if it is called to register a signal handler for
`SIGILL`.

#### `sigprocmask(int how, const sigset_t *set, sigset_t *oldset)`

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

#### `raise(int sig)`

When a signal is raised inside an enclave, it is sent to the host to be raised
on the host side. If a handler has been registered for this signal in the
enclave, the signal handler on the host enters the enclave to invoke the
registered handler.

### stdlib.h

#### `abort()`

In the general case, the runtime cannot guarantee that `abort()` will destroy
the enclave or terminate the client. These resources are controlled by the host
operating system which must be assumed to behave in an adversarial fashion. The
runtime is only able to provide for abnormal termination on a best-effort basis.

The enclave implementation of `abort()` will prevent any further calls into the
enclave through an enclave entry point, and it will prevent any thread from
leaving the enclave by returning from an entry point handler. The mechanism used
to prevent unsafe exits from an aborted enclave does not accommodate running
untrusted code for signal handlers or `atexit()` callbacks. It is not guaranteed
to raise `SIGABRT`, flush buffered I/O streams, or interrupt threads running in
the enclave.

#### `realpath(const char *pathname, char *resolved_path)`

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

Since we do not yet support `fork()` `epoll_create1` forwards requests to
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

In current Asylo implementation of `fcntl()`, only the `cmd`s `F_GETFD`,
`F_SETFD`, `F_GETFL`, `F_SETFL`, `F_GETPIPE_SZ`, `F_SETPIPE_SZ` and `F_DUPFD`
are implemented. -1 is returned if `fcntl()` is called with any other `cmd`, and
`errno` will be set to `EINVAL`.

### sys/ioctl

#### `ioctl`

`ioctl` is implemented for secure path file descriptors. Currently `ioctl` only
accepts the `ENCLAVE_STORAGE_SET_KEY` request.

If called on a file descriptor for anything other than a secure path, or given
an invalid request, `ioctl` will error, set errno to `ENOSYS` and return -1.

### sys/inotify.h

The current implementation of `inotify` for Asylo forwards calls to
`inotify_add_watch` and `inotify_rm_watch` directly to the host. In order to
accommodate for differences of struct layouts/sizes between the host and
enclave, any events that are received from the host that cannot fit into the
buffer supplied to `read` are queued and returned in a subsequent `read`. Only
the IN_NONBLOCK flag is supported for `inotify_init1`.

#### `F_SETFL`

When `fcntl()` is called inside an enclave with `cmd` `F_SETFL` on an `fd`
backed by a file on the host, the file status flags will be set to `arg` on the
host after exiting enclave. If it is called on a secure `fd`, -1 is returned and
`errno` is set to `ENOSYS`.

#### `F_GETFL`

When `fcntl()` is called inside an enclave with `cmd` `F_GETFL` on an `fd`
backed by a file on the host, the file status flags will be obtained from the
host. If it is called on a secure `fd`, -1 is returned and `errno` is set to
`ENOSYS`.

#### `F_SETFD`

When `fcntl()` is called inside an enclave with `cmd` `F_SETFD` on an `fd`
backed by a file on the host, the file descriptor flags will be set to `arg` on
the host after exiting enclave. If it is called on a secure `fd`, -1 is returned
and `errno` is set to `ENOSYS`.

#### `F_GETFL`

When `fcntl()` is called inside an enclave with `cmd` `F_GETFL` on an `fd`
backed by a file on the host, the file descriptor flags will be obtained from
the host. If it is called on a secure `fd`, -1 is returned and `errno` is set to
`ENOSYS`.

#### `F_DUPFD`

When `fcntl()` is called inside an enclave with `cmd` `F_DUPFD`, Asylo will
duplicate the file descriptor `fd` using the lowest-numbered available file
descriptor greater than or equal to `arg`. Since Asylo keeps track of all Asylo
file descriptors, the process happens all inside an enclave.

### sys/mman.h

#### `mmap(void *addr, size_t length, int prot, int flags, int fd, off_t offset)`

`mmap()` only supports simple `MAP_ANONYMOUS` mappings to allocate 4k-aligned
blocks of memory; these are translated internally to `memalign()` calls. In
particular, the mapping of files is not supported.

Specifically, `addr` must be NULL, `prot` must be `PROT_READ | PROT_WRITE`,
`flags` must be `MAP_ANONYMOUS | MAP_PRIVATE`, `fd` must be `-1`, and offset
must be `0`. If not, this call will return `MAP_FAILED` and will set `errno` to
`ENOSYS`.

#### `int munmap(void *addr, size_t length)`

Because `mmap()` can only return pointers to heap-allocated memory, calls to
`munmap(addr, length)` are translated to `free(addr)`, and this function will
always return 0. If passed a pointer not returned by `mmap()`, behavior is
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

#### `mkdir`

`mkdir` exits the enclave and creates the directory on the host.

#### `rename`

`rename` exits the enclave and changes a file/directory name on the host.

#### `umask(mode_t mask)`

When `umask()` is called inside enclave, the mask on the host side will be
changed, and the old value is returned. Everytime `open()` or `mkdir()` is
called, the mask will be checked on the host side. Since the mask is kept on the
host side, it may be different from expected if the operating system is
compromised.

### sys/termios.h

#### `tcgetattr` and `tcsetattr`

`tcgetatter` and `tcsetattr` are not implemented and will `abort()`.

### sys/time.h

#### `getitimer` and `setitimer`

When `getitimer` or `setitimer` are called inside an enclave, they exit the
enclave and get or set the timers on the host. Therefore, the events generated
by the timers and the timing information received from them are not trustworthy.
Supported timer types are `ITIMER_REAL`, `ITIMER_VIRTUAL` and `ITIMER_PROF`.

#### `times()`

When `times()` is called inside an enclave, it exits the enclave, and returns
the current process times from the host.

### sys/utsname.h

#### `uname(struct utsname *buf)`

`uname()` retrieves the system information from the host.

In glibc, `struct utsname` is defined to have fields of length 65 on Linux.
However, according to IETF RFC 1035, fully qualified domain names, such as those
held in the `nodename` field of `struct utsname`, may contain up to 255
characters. Therefore, in Asylo, the fields of `struct utsname` are defined to
have length 256 in order to hold 255 characters and a null byte.

The `domainname` field of `struct utsname` is a GNU extension of POSIX. It is
included in glibc if `_GNU_SOURCE` is defined. It is included unconditionally in
Asylo for maximum compatibility.

### sys/wait.h

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

#### `writev(int fd, const struct iovec *iov, int iovcnt)`

Writev writes `iovcnt` buffers of data described by `iov` to the file specified
by file descriptor `fd`. Inside an enclave, if `fd` is backed by a file on the
host, a buffer is allocated in untrusted memory that is large enough to hold the
content of all the `iov` buffers, and all the `iov` buffers are copied into this
buffer. Then this single buffer in untrusted memory is written to the file.

### syslog.h

#### `openlog`

When `openlog` is called inside an enclave, the `ident`, `option`, and
`facility` arguments are passed to the host to call `openlog` there.

#### `syslog`

When `syslog` is called inside an enclave, the format is converted to a single
string, passed to the host, and `syslog` on the host is called with that message
string.

### unistd.h

#### `rmdir(const char *pathname)`

`rmdir` exits the enclave and deletes the directory on the host.

#### `chown`/`fchown`

When `chown` or `fchown` is called inside an enclave on a path or `fd` backed by
a file on the host, the owner/group of the corresponding file will be changed on
the host. If it is called on a secure `fd`, -1 is returned and `errno` is set to
`ENOSYS`.

#### `fsync(int fd)`/`fdatasync(int fd)`

When `fsync` or `fdatasync` is called inside an enclave with an `fd` backed by a
file on the host, it will be invoked on the corresponding file on the host.
`fdatasync` inside the enclave is implemented through `fsync` so they do exactly
the same thing.

#### `fcntl(int fd, int cmd, ... /* arg */)`

In current Asylo implementation of `fcntl()`, only the `cmd`s `F_GETFD`,
`F_SETFD`, `F_GETFL`, `F_SETFL`, and `F_DUPFD` are implemented. -1 is returned
if `fcntl()` is called with any other `cmd`, and `errno` will be set to
`EINVAL`.

#### `fork()`

`fork()` is implemented in Asylo with security features added. When `fork()` is
requested from inside an enclave, it takes a snapshot of the enclave, creates a
child process, loads a new enclave in the child, and restores the child enclave
from the snapshot. The following security features for `fork()` are provided:

1.  Only the enclavized portion of the application can request a fork.
2.  At most one snapshot can be created per fork request.
3.  The cloned enclave has exactly the same identity as the parent enclave.
4.  If no other threads were running inside the parent enclave when it called
    `fork()`, the cloned enclave's state is the same as that of the parent
    enclave when it called `fork()`.
5.  The snapshot is encrypted by a randomly generated AES256-GCM-SIV key.
6.  THe parent enclave will send the snapshot key to the child enclave only
    after verifying the child enclave has exactly the same identity.
7.  The key is encrypted while the parent sends it to the child, by a key
    generated from a Diffie-Hellman key exchange.
8.  The parent will only send the key to one child enclave.
9.  If the encrypted snapshot is modified, the child enclave does not restore,
    and will block all entries.

WARNING: `fork()` in multithreaded applications may cause undefined behavior or
potential security issues.

#### `vfork()`

`vfork()` is implemented through `fork()` in Asylo. When `vfork()` is requested
from inside an enclave, `fork()` is invoked to create the child enclave. The
parent thread then waits till the child exits before returning. Therefore,
`vfork()` in an enclave does not have better performance than `fork()`.

#### `getpid()`/`getppid()`

The process and parent process identification numbers are obtained from the host
operating system to make sure the value is consistent with the host.

If the host `getpid()` call returns 0, the enclave will abort. Zero is not a
valid return value for `getpid()` under POSIX, but it is used as a marker in
other system calls that operate with PIDs (e.g. `fork()`). Forwarding a returned
PID of 0 could cause user code to take unexpected code paths, which could create
a security vulnerability, so the enclave aborts as a precaution.

#### `getuid()`/`geteuid()`/`getgid()`/`getegid()`

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
operating system has been compromised and `getuid()` returns an insecure value.

#### `pipe()`/`pipe2()`

Pipe reads and writes go through the host. In the enclave, `O_CLOEXEC` is a
meaningless flag, since enclaves do not support `exec()`. However, users may
still specify it as a flag to `pipe2()`, and subsequent calls to `fcntl()` to
check the file descriptor flags on the pipe's file descriptors will show the
`FD_CLOEXEC` flag as being set.

#### `sysconf(int name)`

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

### utime.h

#### `utime`

When `utime` is called inside an enclave it makes the call on the host passing
the filename and times variable directly.

#### `utimes`

When `utimes` is called inside an enclave it makes the call on the host passing
the filename and times variable directly.

[^1]: The current implementation does not support multiple enclaves registering
    the same signal. If that happens, the latter will overwrite the former.
