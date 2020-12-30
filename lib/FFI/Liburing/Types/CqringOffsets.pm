package Sys::Linux::Liburing::Types::SqringOffsets;

use strict;
use warnings;
use FFI::Platypus::Record;
use Sys::Linux::Liburing::Types::SqringOffsets;
use Sys::Linux::Liburing::Types::CqringOffsets;

record_layout_1(qw(
  uint32 head
	uint32 tail
	uint32 ring_mask
	uint32 ring_entries
	uint32 overflow
	uint32 cqes
	uint64 resv_1
	uint64 resv_2
)); 

1;