package Sys::Linux::Liburing;

# ABSTRACT: No Abstract

use strict;
use warnings;
use Carp qw/croak/;

our $VERSION="0.001";

use POSIX 'uname';

use FFI::Platypus;
use parent 'Exporter';

{
  my $ffi = FFI::Platypus->new( api => 1 );
 
  $ffi->mangler(sub {
    my $name = shift;
    $name =~ s/^/MY_/;
    $name;
  });
 
  $ffi->type('struct io_uring_probe' => 'io_uring_probe');
  $ffi->type('struct io_uring_cqe' => 'io_uring_cqe');
  $ffi->type('struct io_uring_sqe' => 'io_uring_sqe');
  $ffi->type('struct io_uring' => 'io_uring');
  $ffi->type('struct statx' => 'statx');
  $ffi->type('struct mode_t' => 'mode_t');
  $ffi->type('struct sockaddr' => 'sockaddr');
  $ffi->type('struct __kernel_timespec' => '__kernel_timespec');
  $ffi->type('stuct socklen_t' => 'socklen_t');
  $ffi->type('struct msghdr' => 'msghdr');
  $ffi->type('struct open_how' => 'open_how');

  $ffi->bundle;
 
  my $api_list = [
    [io_uring_opcode_supported => ['io_uring_probe *', 'int'] => 'int'],
    [io_uring_wait_cqe_nr => ['io_uring *', 'io_uring_cqe **', 'unsigned'] => 'int'],
    [io_uring_peek_cqe => ['io_uring *', 'io_uring_cqe **'] => 'int'],
    [io_uring_wait_cqe => ['io_uring *', 'io_uring_cqe **'] => 'int'],
    [io_uring_cq_advance => ['io_uring *', 'unsigned'] => 'void'],
    [io_uring_cqe_seen => ['io_uring *', 'io_uring_cqe *'] => 'void'],
    [io_uring_sqe_set_data => ['io_uring_sqe *', 'void *'] => 'void'],
    [io_uring_cqe_get_data => ['io_uring_cqe *'] => 'void*'],
    [io_uring_sqe_set_flags => ['io_uring_sqe *', 'unsigned'] => 'void'],
    [io_uring_prep_rw => ['int', 'io_uring_sqe *', 'int', 'const void *', 'unsigned', '__u64'] => 'void'],
    [io_uring_prep_readv => ['io_uring_sqe *', 'int', 'const iovec *', 'unsigned', 'off_t'] => 'void'],
    [io_uring_prep_read_fixed => ['io_uring_sqe *', 'int', 'void *', 'unsigned', 'off_t', 'int'] => 'void'],
    [io_uring_prep_writev => ['io_uring_sqe *', 'int', 'const iovec *', 'unsigned', 'off_t'] => 'void'],
    [io_uring_prep_write_fixed => ['io_uring_sqe *', 'int', 'const void *', 'unsigned', 'off_t', 'int'] => 'void'],
    [io_uring_prep_recvmsg => ['io_uring_sqe *', 'int', 'msghdr *', 'unsigned'] => 'void'],
    [io_uring_prep_sendmsg => ['io_uring_sqe *', 'int', 'const msghdr *', 'unsigned'] => 'void'],
    [io_uring_prep_poll_add => ['io_uring_sqe *', 'int', 'short'] => 'void'],
    [io_uring_prep_poll_remove => ['io_uring_sqe *', 'void *'] => 'void'],
    [io_uring_prep_fsync => ['io_uring_sqe *', 'int', 'unsigned'] => 'void'],
    [io_uring_prep_nop => ['io_uring_sqe *'] => 'void'],
    [io_uring_prep_timeout => ['io_uring_sqe *', '__kernel_timespec *', 'unsigned', 'unsigned'] => 'void'],
    # this u64 is ACTUALLY a pointer, kernel code needs to disguise them sometimes
    # to prevent platform differences in padding, alignment, etc.
    [io_uring_prep_timeout_remove => ['io_uring_sqe *', '__u64', 'unsigned'] => 'void'],
    [io_uring_prep_accept => ['io_uring_sqe *', 'int', 'sockaddr *', 'socklen_t *', 'int'] => 'void'],
    [io_uring_prep_cancel => ['io_uring_sqe *', 'void *', 'int'] => 'void'],
    [io_uring_prep_link_timeout => ['io_uring_sqe *', '__kernel_timespec *', 'unsigned'] => 'void'],
    [io_uring_prep_connect => ['io_uring_sqe *', 'int', 'sockaddr *', 'socklen_t'] => 'void'],
    [io_uring_prep_files_update => ['io_uring_sqe *', 'int *', 'unsigned', 'int'] => 'void'],
    [io_uring_prep_fallocate => ['io_uring_sqe *', 'int', 'int', 'off_t', 'off_t'] => 'void'],
    [io_uring_prep_openat => ['io_uring_sqe *', 'int', 'const char *', 'int', 'mode_t'] => 'void'],
    [io_uring_prep_close => ['io_uring_sqe *', 'int'] => 'void'],
    [io_uring_prep_read => ['io_uring_sqe *', 'int', 'void *', 'unsigned', 'off_t'] => 'void'],
    [io_uring_prep_write => ['io_uring_sqe *', 'int', 'void *', 'unsigned', 'off_t'] => 'void'],
    [io_uring_prep_statx => ['io_uring_sqe *', 'int', 'const char *', 'int', 'unsigned', 'statx *'] => 'void'],
    [io_uring_prep_fadvise => ['io_uring_sqe *', 'int', 'off_t', 'off_t', 'int'] => 'void'],
    [io_uring_prep_madvise => ['io_uring_sqe *', 'void *', 'off_t', 'int'] => 'void'],
    [io_uring_prep_send => ['io_uring_sqe *', 'int', 'const void *', 'size_t', 'int'] => 'void'],
    [io_uring_prep_recv => ['io_uring_sqe *', 'int', 'void *', 'size_t', 'flags'] => 'void'],
    [io_uring_prep_openat2 => ['io_uring_sqe *', 'int', 'const char *', 'open_how *'] => 'void'],
    [io_uring_sq_ready => ['io_uring *'] => 'unsigned'],
    [io_uring_sq_space_left => ['io_uring *'] => 'unsigned'],
    [io_uring_cq_ready => ['io_uring *'] => 'unsigned'],
  ];

  for my $func (@$api_list) {
    $ffi->attach(@$func);
  }

};

our %EXPORT_TAGS;
our @EXPORT_OK;
my %minimum_kernel_version;
my $kernel_release;

# Some small subs for doing comparisons of the kernel versions
my $norm_kver = sub {
  my $q = sprintf "%03d.%03d", split(/\./,$_[0]);
  return $q;
};

my $compare_kver = sub {
  my ($left, $right) = map {$norm_kver->($_)} @_;

  return $left ge $right;
};

# This probably doesn't need to be in a begin but I fell better doing it in here for now.
BEGIN {
  ($kernel_release) = [uname]->[2] =~ /^(\d+\.\d+)/;

  my %lk_symbols = (
    # As of writing, 5.6 is unreleased and these are just queued up for it since you can test it from git
    # 5.6 not merged yet, IORING_OP_SPLICE
    "lk5.6" => [qw/IORING_OP_FALLOCATE IORING_OP_OPENAT IORING_OP_OPENAT2 IORING_OP_CLOSE
                    IORING_OP_FILES_UPDATE IORING_OP_STATX IORING_OP_READ IORING_OP_WRITE 
                    IORING_OP_FADVISE IORING_OP_MADVISE IORING_OP_SEND IORING_OP_RECV 
                    IORING_OP_EPOLL_CTL
                    io_uring_prep_fallocate io_uring_prep_openat io_uring_prep_openat2
                    io_uring_prep_close io_uring_prep_files_update io_uring_prep_statx
                    io_uring_prep_read io_uring_prep_write io_uring_prep_fadvise
                    io_uring_prep_madvise io_uring_prep_send io_uring_prep_recv
                    io_uring_prep_epoll_ctl
                    /],
    "lk5.5" => [qw/IORING_OP_TIMEOUT_REMOVE IORING_OP_ACCEPT IORING_OP_CONNECT 
                    IORING_OP_ASYNC_CANCEL IORING_OP_LINK_TIMEOUT
                    io_uring_prep_timeout_remove io_uring_prep_link_timeout
                    io_uring_prep_connect io_uring_prep_cancel io_uring_prep_accept/],
    "lk5.4" => [qw/IORING_OP_TIMEOUT io_uring_prep_timeout/],
    "lk5.3" => [qw/IORING_OP_SENDMSG IORING_OP_RECVMSG io_uring_prep_sendmsg io_uring_prep_recvmsg/],
    "lk5.2" => [qw/IORING_OP_SYNC_FILE_RANGE/], # TODO add sub for this
    "lk5.1" => [qw/IORING_OP_NOP IORING_OP_READV IORING_OP_WRITEV IORING_OP_READ_FIXED 
                    IORING_OP_WRITE_FIXED IORING_OP_FSYNC IORING_OP_POLL_ADD 
                    IORING_OP_POLL_REMOVE 
                    io_uring_prep_nop io_uring_prep_readv io_uring_prep_writev 
                    io_uring_prep_read_fixed io_uring_prep_write_fixed io_uring_prep_fsync
                    io_uring_prep_poll_remove io_uring_prep_poll_add/]
  );
  # make these all exportable as single symbols
  
  @EXPORT_TAGS{values %lk_symbols} = values %lk_symbols;

  # Do some fancy copying to make each kernel version contain the previous kernel versions
  my @all_symbols = ();
  for my $version (qw/5.1 5.2 5.3 5.4 5.5 5.6/) {
    my @symbols = @{$lk_symbols{"lk$version"}};

    # setup the minimum kernel version for each symbol and import argument
    $minimum_kernel_version{":lk$version"} = $version;
    @minimum_kernel_version{@symbols} = ($version) x @symbols;
    
    # merge the symbols from previous kernels into this one
    @all_symbols = (@all_symbols, @symbols);
    $lk_symbols{"lk$version"} = [@all_symbols];
  }
  # now let them be exported
  %EXPORT_TAGS = (%lk_symbols, %EXPORT_TAGS);
  push @EXPORT_OK, @all_symbols;

  # All the liburing subs
  my @sublist = qw/
    io_uring_get_probe io_uring_get_probe_ring io_uring_get_sqe io_uring_peek_batch_cqe 
    io_uring_queue_exit io_uring_queue_init io_uring_queue_init_params io_uring_queue_mmap
    io_uring_register_buffers io_uring_register_eventfd io_uring_register_files 
    io_uring_register_files_update io_uring_register_personality io_uring_register_probe 
    io_uring_ring_dontfork io_uring_submit io_uring_submit_and_wait io_uring_unregister_buffers 
    io_uring_unregister_files io_uring_unregister_personality io_uring_wait_cqes io_uring_wait_cqe_timeout
    io_uring_opcode_supported io_uring_cq_advance io_uring_cqe_seen io_uring_sqe_set_data
    io_uring_sqe_set_flags io_uring_prep_rw io_uring_sq_ready io_uring_sq_space_left 
    io_uring_cq_ready io_uring_wait_cqe_nr io_uring_peek_cqe io_uring_wait_cqe
    /;
  $EXPORT_TAGS{"subs"} = @sublist;
  push @EXPORT_OK, @sublist;
}

sub import {
  my ($pack, @keys) = @_;

  my @symbols = map {/^:(.*)/ ? @{$EXPORT_TAGS{$1}} : $_} @keys;

  for my $symbol (@symbols) {
    if (exists $minimum_kernel_version{$symbol}) {
      if (!$compare_kver->($kernel_release, $minimum_kernel_version{$symbol})) {
        # TODO use io_uring_opcode_supported for checking things instead of just kernel vesions
        croak "Minimum kernel version for '$symbol' not met.  Needed '".$minimum_kernel_version{$symbol}."' have '$kernel_release'"
      }
    }
  }

  # Fall through after we're done
  goto \&Exporter::import;
};

#die $kernel_release;

1;
