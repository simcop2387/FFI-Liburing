package Sys::Linux::Liburing::Types::UringParams;

use strict;
use warnings;
use FFI::Platypus::Record;
use Sys::Linux::Liburing::Types::SqringOffsets;
use Sys::Linux::Liburing::Types::CqringOffsets;

record_layout_1(qw(
  	uint32 sq_entries
	uint32 cq_entries
	uint32 flags
	uint32 sq_thread_cpu
	uint32 sq_thread_idle
	uint32 features
	uint32 wq_fd
	uint32(3) resv
	record(Sys::Linux::Liburing::Types::SqringOffsets) sq_off
	record(Sys::Linux::Liburing::Types::CqringOffsets) cq_off
)); 

1;