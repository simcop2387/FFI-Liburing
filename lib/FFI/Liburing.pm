package FFI::Liburing;

# ABSTRACT: No Abstract

use strict;
use warnings;
use Carp qw/croak/;

our $VERSION="0.001";

use POSIX 'uname';

use FFI::Platypus;
use parent 'Exporter';
use Sys::Linux::KernelVersion;
use FFI::C;
use File::ShareDir qw/dist_dir/;
use Path::Tiny;
use FFI::CheckLib qw//;

{
  my $search_path = path(dist_dir('Alien-liburing'))->child('dynamic');
  my $ffi_lib = FFI::CheckLib::find_lib_or_die(lib => 'uring', libpath => $search_path);
  my $ffi_suplib = FFI::CheckLib::find_lib_or_die(lib => 'uringsup', libpath => $search_path);

  my $ffi = FFI::Platypus->new( api => 1 );
  $ffi->lib($ffi_lib, $ffi_suplib);

  $ffi->mangler(sub {
    my $name = shift;
    $name =~ s/^/MY_/;
    $name;
  });

  FFI::C->ffi($ffi);

  package FFI::Liburing::Types::StatxTime {
    FFI::C->struct(__statx_time_t => [
      tv_sec => 'sint64',
      tv_nsec => 'uint32',
      reserved => 'sint32']);
  };

  package FFI::Liburing::Types::Statx {
    FFI::C->struct(__statx_t => [
      stx_mask => 'uint32',
      stx_blksize => 'uint32',
      stx_attributes => 'uint64',
      stx_nlink => 'uint32',
      stx_uid => 'uint32',
      stx_gid => 'uint32',
      stx_mode => 'uint16',
      _spare0 => 'uint16',
      stx_ino => 'uint64',
      stx_size => 'uint64',
      stx_blocks => 'uint64',
      stx_attributes_mask => 'uint64',
      stx_atime => '__statx_time_t',
      stx_btime => '__statx_time_t',
      stx_ctime => '__statx_time_t',
      stx_mtime => '__statx_time_t',
      stx_rdev_major => 'uint32',
      stx_rdev_minor => 'uint32',
      stx_dev_major => 'uint32',
      stx_dev_minor => 'uint32',
      _spare1_1 => 'uint64',
      _spare1_2 => 'uint64',
      _spare1_3 => 'uint64',
      _spare1_4 => 'uint64',
      _spare1_5 => 'uint64',
      _spare1_6 => 'uint64',
      _spare1_7 => 'uint64',
      _spare1_8 => 'uint64',
      _spare1_9 => 'uint64',
      _spare1_10 => 'uint64',
      _spare1_11 => 'uint64',
      _spare1_12 => 'uint64',
      _spare1_13 => 'uint64',
      _spare1_14 => 'uint64',
    ]);
  };

  #package FFI::Liburing::Types::AlignedU64 {
  #  # Abuse a union type to futz with the alignment
  #  # Strictly speaking I'm not sure this is absolutely necessary
  #  # but the C code for the struct defintion forces an alignment
  #  # on this type so we should force it to be used too
  #  FFI::C::UnionDef->new($ffi, 
  #    name => '__aligned_u64',
  #
  #    )
  #};

  package FFI::Liburing::Types::FilesUpdate {
    FFI::C->struct('__files_update_t' => [
      offset => 'uint32',
      resv => 'uint32',
      fds => 'uint64', # This has a gcc alignment force attribute of 8, which looks like what we'll do here anyway.  Attempted to look at forcing it above but not sold on how to do it
    ]); 
  };

  package FFI::Liburing::Types::SqringOffsets {
    FFI::C->struct('__sqring_offsets_t' => [
      head => 'uint32',
      tail => 'uint32',
      ring_mask => 'uint32',
      ring_entries => 'uint32',
      flags => 'uint32',
      dropped => 'uint32',
      array => 'uint32',
      resv1 => 'uint32',
      resv2 => 'uint64',
    ]); 
  };

  package FFI::Liburing::Types::CqringOffsets {
    FFI::C->struct('__cqring_offsets_t' => [
      head => 'uint32',
      tail => 'uint32',
      ring_mask => 'uint32',
      ring_entries => 'uint32',
      overflow => 'uint32',
      cqes => 'uint32',
      resv_1 => 'uint64',
      resv_2 => 'uint64',
    ]);
  };

  package FFI::Liburing::Types::UringParams {
    FFI::C->struct('__uring_params_t' => [
      sq_entries => 'uint32',
      cq_entries => 'uint32',
      flags => 'uint32',
      sq_thread_cpu => 'uint32',
      sq_thread_idle => 'uint32',
      features => 'uint32',
      wq_fd => 'uint32',
      resv1 => 'uint32',
      resv2 => 'uint32',
      resv3 => 'uint32',
      sq_off => '__sqring_offsets_t',
      cq_off => '__cqring_offsets_t',
    ]);
  };

  package FFI::Liburing::Types::ProbeOp {
    FFI::C->struct('__probeop_t' => [
      op => 'uint8',
      resv => 'uint8',
      flags => 'uint16',
      resv2 => 'uint32'
    ]);
  };

  package FFI::Liburing::Types::Probe {
    FFI::C->struct('__probe_t' => [
      last_op => 'uint8',
      ops_len => 'uint8',
      resv => 'uint16',
      resv2_1 => 'uint32',
      resv2_2 => 'uint32',
      resv2_3 => 'uint32',
    	ops => '__probeop_t',  # TODO this is broken, needs to be a pointer?
    ]);
  };

  $ffi->type('opaque' => '__io_uring_p_t');
  $ffi->type('opaque' => '__io_uring_probe_pp_t');
  $ffi->type('opaque' => '__io_uring_cqe_pp_t');
  $ffi->type('opaque' => '__io_uring_cqe_p_t');
  $ffi->type('opaque' => '__io_uring_sqe_p_t');
  $ffi->type('opaque' => '__io_uring_userdata_p_t');
  $ffi->type('opaque' => '__io_uring_addr_p_t'); # const void *addr for io_uring_prep_rw
  $ffi->type('opaque' => '__io_uring_buffer_p_t'); # used for reading/writing data into/from the user process, void* since the kernel won't know or care about types.

  $ffi->type('opaque' => '__msghdr_p_t'); # TODO make this a real type
  $ffi->type('opaque' => '__kernel_timespec_p_t'); # this was a simple one, could be a record type
  #$ffi->type('struct mode_t' => 'mode_t');
  $ffi->type('opaque' => '__sockaddr_p_t');
  $ffi->type('uint32' => '__socklen_t');
  $ffi->type('__socklen_t*' => '__socklen_p_t');
  $ffi->type('opaque' => '__open_how_p_t');
  $ffi->type('opaque' => '__epoll_event_t');

  $ffi->bundle;
 
  my $api_list = [
    [io_uring_opcode_supported => ['__io_uring_probe_pp_t', 'int'] => 'int'],
    [io_uring_wait_cqe_nr => ['__io_uring_p_t', '__io_uring_cqe_pp_t', 'uint'] => 'int'],
    [io_uring_peek_cqe => ['__io_uring_p_t', '__io_uring_cqe_pp_t'] => 'int'],
    [io_uring_wait_cqe => ['__io_uring_p_t', '__io_uring_cqe_pp_t'] => 'int'],
    [io_uring_cq_advance => ['__io_uring_p_t', 'uint'] => 'void'],
    [io_uring_cqe_seen => ['__io_uring_p_t', '__io_uring_cqe_p_t'] => 'void'],
    [io_uring_sqe_set_data => ['__io_uring_sqe_p_t', '__io_uring_userdata_p_t'] => 'void'],
    [io_uring_cqe_get_data => ['__io_uring_cqe_p_t'] => '__io_uring_userdata_p_t'],
    [io_uring_sqe_set_flags => ['__io_uring_sqe_p_t', 'uint'] => 'void'],
    [io_uring_prep_rw => ['int', '__io_uring_sqe_p_t', 'int', '__io_uring_addr_p_t', 'uint', 'uint64'] => 'void'],
#    [io_uring_prep_readv => ['__io_uring_sqe_p_t', 'int', 'const iovec *', 'uint', 'off_t'] => 'void'], # TODO fix this up
    [io_uring_prep_read_fixed => ['__io_uring_sqe_p_t', 'int', '__io_uring_buffer_p_t', 'uint', 'off_t', 'int'] => 'void'],
#    [io_uring_prep_writev => ['__io_uring_sqe_p_t', 'int', 'const iovec *', 'uint', 'off_t'] => 'void'], # TODO fix this
    [io_uring_prep_write_fixed => ['__io_uring_sqe_p_t', 'int', '__io_uring_buffer_p_t', 'uint', 'off_t', 'int'] => 'void'],
    [io_uring_prep_recvmsg => ['__io_uring_sqe_p_t', 'int', '__msghdr_p_t', 'uint'] => 'void'],
    [io_uring_prep_sendmsg => ['__io_uring_sqe_p_t', 'int', '__msghdr_p_t', 'uint'] => 'void'],
    [io_uring_prep_poll_add => ['__io_uring_sqe_p_t', 'int', 'uint'] => 'void'],
    [io_uring_prep_poll_remove => ['__io_uring_sqe_p_t', '__io_uring_userdata_p_t'] => 'void'],
    [io_uring_prep_fsync => ['__io_uring_sqe_p_t', 'int', 'uint'] => 'void'],
    [io_uring_prep_nop => ['__io_uring_sqe_p_t'] => 'void'],
    [io_uring_prep_timeout => ['__io_uring_sqe_p_t', '__kernel_timespec_p_t', 'uint', 'uint'] => 'void'],
    # this u64 is ACTUALLY a pointer, kernel code needs to disguise them sometimes
    # to prevent platform differences in padding, alignment, etc.
    [io_uring_prep_timeout_remove => ['__io_uring_sqe_p_t', 'uint64', 'uint'] => 'void'],
    [io_uring_prep_accept => ['__io_uring_sqe_p_t', 'int', '__sockaddr_p_t', '__socklen_p_t', 'int'] => 'void'],
    [io_uring_prep_cancel => ['__io_uring_sqe_p_t', '__io_uring_userdata_p_t', 'int'] => 'void'],
    [io_uring_prep_link_timeout => ['__io_uring_sqe_p_t', '__kernel_timespec_p_t', 'uint'] => 'void'],
    [io_uring_prep_connect => ['__io_uring_sqe_p_t', 'int', '__sockaddr_p_t', '__socklen_t'] => 'void'],
    [io_uring_prep_files_update => ['__io_uring_sqe_p_t', 'int *', 'uint', 'int'] => 'void'],
    [io_uring_prep_fallocate => ['__io_uring_sqe_p_t', 'int', 'int', 'off_t', 'off_t'] => 'void'],
    [io_uring_prep_openat => ['__io_uring_sqe_p_t', 'int', 'string', 'int', 'mode_t'] => 'void'],
    [io_uring_prep_close => ['__io_uring_sqe_p_t', 'int'] => 'void'],
    [io_uring_prep_read => ['__io_uring_sqe_p_t', 'int', '__io_uring_buffer_p_t', 'uint', 'off_t'] => 'void'],
    [io_uring_prep_write => ['__io_uring_sqe_p_t', 'int', '__io_uring_buffer_p_t', 'uint', 'off_t'] => 'void'],
    [io_uring_prep_statx => ['__io_uring_sqe_p_t', 'int', 'string', 'int', 'uint', '__statx_t'] => 'void'],
    [io_uring_prep_fadvise => ['__io_uring_sqe_p_t', 'int', 'off_t', 'off_t', 'int'] => 'void'],
    [io_uring_prep_madvise => ['__io_uring_sqe_p_t', '__io_uring_addr_p_t', 'off_t', 'int'] => 'void'],
    [io_uring_prep_send => ['__io_uring_sqe_p_t', 'int', '__io_uring_buffer_p_t', 'size_t', 'int'] => 'void'],
    [io_uring_prep_recv => ['__io_uring_sqe_p_t', 'int', '__io_uring_buffer_p_t', 'size_t', 'int'] => 'void'],
    [io_uring_prep_openat2 => ['__io_uring_sqe_p_t', 'int', 'string', '__open_how_p_t'] => 'void'],
    [io_uring_prep_splice => ['__io_uring_sqe_p_t', 'int', 'sint64', 'int', 'sint64', 'uint', 'uint'] => 'void'], # TODO failed to find?
    [io_uring_prep_tee => ['__io_uring_sqe_p_t', 'int', 'int', 'uint', 'uint'] => 'void'],
    [io_uring_prep_timeout_update => ['__io_uring_sqe_p_t', '__kernel_timespec_p_t', 'uint64', 'uint'] => 'void'],
    [io_uring_prep_epoll_ctl => ['__io_uring_sqe_p_t', 'int', 'int', 'int', '__epoll_event_t *'] => 'void'],
    [io_uring_prep_provide_buffers => ['__io_uring_sqe_p_t', '__io_uring_addr_p_t', 'int', 'int', 'int', 'int'] => 'void'],
    [io_uring_prep_remove_buffers => ['__io_uring_sqe_p_t', 'int', 'int'] => 'void'],
    [io_uring_prep_shutdown => ['__io_uring_sqe_p_t', 'int', 'int'] => 'void'],
    [io_uring_prep_unlinkat => ['__io_uring_sqe_p_t', 'int', 'string', 'int'] => 'void'],
    [io_uring_prep_renameat => ['__io_uring_sqe_p_t', 'int', 'string', 'int', 'string', 'int'] => 'void'],
    [io_uring_sq_ready => ['__io_uring_p_t'] => 'uint'],
    [io_uring_sq_space_left => ['__io_uring_p_t'] => 'uint'],
#    [__io_uring_sqring_wait   => ['__io_uring_p_t'] => 'int'],
    [io_uring_cq_ready => ['__io_uring_p_t'] => 'uint'],
    [io_uring_cq_eventfd_enabled => ['__io_uring_p_t'] => 'bool'],
    [io_uring_cq_eventfd_toggle => ['__io_uring_p_t', 'bool'] => 'int'],
  ];

  for my $func (@$api_list) {
    $ffi->attach(@$func);
  }

};

our %EXPORT_TAGS;
our @EXPORT_OK;
my %minimum_kernel_version;

# This probably doesn't need to be in a begin but I fell better doing it in here for now.
BEGIN {
  my %lk_symbols = (
    # These look to have been created just before the 5.10 release, and didn't make the merge window.  liburing supports them for future use though
    "lk5.11" => [qw/IORING_OP_SHUTDOWN IORING_OP_RENAMEAT	IORING_OP_UNLINKAT 
                    io_uring_prep_shutdown io_uring_prep_unlinkat io_uring_prep_renameat/],
    
    # Nothing new that I can find in these two releases
    "lk5.10" => [],
    "lk5.9" => [],

    "lk5.8" => [qw/IORING_OP_TEE io_uring_prep_tee/],

    # Best information I can find shows IORING_OP_SPLICE being merged in 5.7
    "lk5.7" => [qw/IORING_OP_PROVIDE_BUFFERS IORING_OP_REMOVE_BUFFERS IORING_OP_SPLICE
                io_uring_prep_provide_buffers io_uring_prep_remove_buffers io_uring_prep_splice/],

    "lk5.6" => [qw/IORING_OP_FALLOCATE IORING_OP_OPENAT IORING_OP_OPENAT2 IORING_OP_CLOSE
                    IORING_OP_FILES_UPDATE IORING_OP_STATX IORING_OP_READ IORING_OP_WRITE 
                    IORING_OP_FADVISE IORING_OP_MADVISE IORING_OP_SEND IORING_OP_RECV 
                    IORING_OP_EPOLL_CTL
                    io_uring_prep_fallocate io_uring_prep_openat io_uring_prep_openat2
                    io_uring_prep_close io_uring_prep_files_update io_uring_prep_statx
                    io_uring_prep_read io_uring_prep_write io_uring_prep_fadvise
                    io_uring_prep_madvise io_uring_prep_send io_uring_prep_recv
                    io_uring_prep_epoll_ctl/],
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
                    io_uring_prep_poll_remove io_uring_prep_poll_add io_uring_opcode_supported/]
  );
  # make these all exportable as single symbols
  
  @EXPORT_TAGS{values %lk_symbols} = values %lk_symbols;

  # Do some fancy copying to make each kernel version contain the previous kernel versions
  my @all_symbols = ();
  for my $version (qw/5.1 5.2 5.3 5.4 5.5 5.6 5.7 5.8 5.9 5.10 5.11/) {
    my @symbols = @{$lk_symbols{"lk$version"}};

    my $full_ver = "$version.0";

    # setup the minimum kernel version for each symbol and import argument
    $minimum_kernel_version{":lk$version"} = $full_ver;
    @minimum_kernel_version{@symbols} = ($full_ver) x @symbols;
    
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
    io_uring_register_buffers io_uring_register_eventfd io_uring_register_eventfd_async
    io_uring_register_files io_uring_register_files_update io_uring_register_personality 
    io_uring_register_probe io_uring_ring_dontfork io_uring_submit io_uring_submit_and_wait 
    io_uring_unregister_buffers io_uring_unregister_files io_uring_unregister_personality
    io_uring_wait_cqes io_uring_wait_cqe_timeout io_uring_opcode_supported io_uring_cq_advance
    io_uring_cqe_seen io_uring_sqe_set_data io_uring_sqe_set_flags io_uring_prep_rw 
    io_uring_sq_ready io_uring_sq_space_left io_uring_cq_ready io_uring_wait_cqe_nr 
    io_uring_peek_cqe io_uring_wait_cqe io_uring_register_restrictions io_uring_enable_rings
    io_uring_prep_provide_buffers io_uring_prep_remove_buffers io_uring_prep_shutdown
    io_uring_prep_unlinkat io_uring_prep_renameat io_uring_sq_ready io_uring_sq_space_left
    __io_uring_sqring_wait io_uring_cq_ready io_uring_cq_eventfd_enabled io_uring_cq_eventfd_toggle
    /;
  $EXPORT_TAGS{"subs"} = @sublist;
  push @EXPORT_OK, @sublist;
}

sub import {
  my ($pack, @keys) = @_;

  my @symbols = map {/^:(.*)/ ? @{$EXPORT_TAGS{$1}} : $_} @keys;

  for my $symbol (@symbols) {
    if (exists $minimum_kernel_version{$symbol}) {
      unless (Sys::Linux::KernelVersion::is_at_least_kernel_version($minimum_kernel_version{$symbol})) {
        # TODO use io_uring_opcode_supported for checking things instead of just kernel vesions
        croak "Minimum kernel version for '$symbol' not met.  Needed '".$minimum_kernel_version{$symbol}."'"
      }
    }
  }

  # Fall through after we're done
  goto \&Exporter::import;
};

#die $kernel_release;

1;
