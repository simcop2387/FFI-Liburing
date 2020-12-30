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
	uint32 flags
	uint32 dropped
	uint32 array
	uint32 resv1
	uint64 resv2
)); 

1;