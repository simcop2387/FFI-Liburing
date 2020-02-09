#include <ffi_platypus_bundle.h>
#include "liburing.h"

int      MY_io_uring_opcode_supported(struct io_uring_probe *p, int op) { 
    return io_uring_opcode_supported(p, op);
 }
int      MY_io_uring_wait_cqe_nr(struct io_uring *ring, struct io_uring_cqe **cqe_ptr, unsigned wait_nr) { 
    return io_uring_wait_cqe_nr(ring, cqe_ptr, wait_nr);
 }
int      MY_io_uring_peek_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_ptr) { 
    return io_uring_peek_cqe(ring, cqe_ptr);
 }
int      MY_io_uring_wait_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_ptr) { 
    return io_uring_wait_cqe(ring, cqe_ptr);
 }
void     MY_io_uring_cq_advance(struct io_uring *ring,unsigned nr) { io_uring_cq_advance(ring, nr); }
void     MY_io_uring_cqe_seen(struct io_uring *ring,struct io_uring_cqe *cqe) { io_uring_cqe_seen(ring, cqe); }
void     MY_io_uring_sqe_set_data(struct io_uring_sqe *sqe, void *data) { io_uring_sqe_set_data(sqe, data); }
void    *MY_io_uring_cqe_get_data(struct io_uring_cqe *cqe) { io_uring_cqe_get_data(cqe); }
void     MY_io_uring_sqe_set_flags(struct io_uring_sqe *sqe,unsigned flags) { io_uring_sqe_set_flags(sqe, flags); }
void     MY_io_uring_prep_rw(int op, struct io_uring_sqe *sqe, int fd, const void *addr, unsigned len, __u64 offset) { io_uring_prep_rw(op, sqe, int, addr, len, offset); }
void     MY_io_uring_prep_readv(struct io_uring_sqe *sqe, int fd, const struct iovec *iovecs, unsigned nr_vecs, off_t offset) {  }
void     MY_io_uring_prep_read_fixed(struct io_uring_sqe *sqe, int fd, void *buf, unsigned nbytes, off_t offset, int buf_index) {  }
void     MY_io_uring_prep_writev(struct io_uring_sqe *sqe, int fd, const struct iovec *iovecs, unsigned nr_vecs, off_t offset) {  }
void     MY_io_uring_prep_write_fixed(struct io_uring_sqe *sqe, int fd, const void *buf, unsigned nbytes, off_t offset, int buf_index) {  }
void     MY_io_uring_prep_recvmsg(struct io_uring_sqe *sqe, int fd, struct msghdr *msg, unsigned flags) {  }
void     MY_io_uring_prep_sendmsg(struct io_uring_sqe *sqe, int fd, const struct msghdr *msg, unsigned flags) {  }
void     MY_io_uring_prep_poll_add(struct io_uring_sqe *sqe, int fd, short poll_mask) {  }
void     MY_io_uring_prep_poll_remove(struct io_uring_sqe *sqe, void *user_data) {  }
void     MY_io_uring_prep_fsync(struct io_uring_sqe *sqe, int fd, unsigned fsync_flags) {  }
void     MY_io_uring_prep_nop(struct io_uring_sqe *sqe) {  }
void     MY_io_uring_prep_timeout(struct io_uring_sqe *sqe, struct __kernel_timespec *ts, unsigned count, unsigned flags) {  }
void     MY_io_uring_prep_timeout_remove(struct io_uring_sqe *sqe, __u64 user_data, unsigned flags) {  }
void     MY_io_uring_prep_accept(struct io_uring_sqe *sqe, int fd, struct sockaddr *addr, socklen_t *addrlen, int flags) {  }
void     MY_io_uring_prep_cancel(struct io_uring_sqe *sqe, void *user_data, int flags) {  }
void     MY_io_uring_prep_link_timeout(struct io_uring_sqe *sqe, struct __kernel_timespec *ts, unsigned flags) {  }
void     MY_io_uring_prep_connect(struct io_uring_sqe *sqe, int fd, struct sockaddr *addr, socklen_t addrlen) {  }
void     MY_io_uring_prep_files_update(struct io_uring_sqe *sqe, int *fds, unsigned nr_fds, int offset) {  }
void     MY_io_uring_prep_fallocate(struct io_uring_sqe *sqe, int fd, int mode, off_t offset, off_t len) {  }
void     MY_io_uring_prep_openat(struct io_uring_sqe *sqe, int dfd, const char *path, int flags, mode_t mode) {  }
void     MY_io_uring_prep_close(struct io_uring_sqe *sqe, int fd) {  }
void     MY_io_uring_prep_read(struct io_uring_sqe *sqe, int fd, void *buf, unsigned nbytes, off_t offset) {  }
void     MY_io_uring_prep_write(struct io_uring_sqe *sqe, int fd, void *buf, unsigned nbytes, off_t offset) {  }
void     MY_io_uring_prep_statx(struct io_uring_sqe *sqe, int dfd, const char *path, int flags, unsigned mask, struct statx *statxbuf) {  }
void     MY_io_uring_prep_fadvise(struct io_uring_sqe *sqe, int fd, off_t offset, off_t len, int advice) {  }
void     MY_io_uring_prep_madvise(struct io_uring_sqe *sqe, void *addr, off_t length, int advice) {  }
void     MY_io_uring_prep_send(struct io_uring_sqe *sqe, int sockfd, const void *buf, size_t len, int flags) {  }
void     MY_io_uring_prep_recv(struct io_uring_sqe *sqe, int sockfd, void *buf, size_t len, int flags) {  }
void     MY_io_uring_prep_openat2(struct io_uring_sqe *sqe, int dfd, const char *path, struct open_how *how) {  }
unsigned MY_io_uring_sq_ready(struct io_uring *ring) { return io_uring_sq_ready(ring); }
unsigned MY_io_uring_sq_space_left(struct io_uring *ring) { return io_uring_sq_space_left(ring); }
unsigned MY_io_uring_cq_ready(struct io_uring *ring) { return io_uring_cq_ready(ring); }
