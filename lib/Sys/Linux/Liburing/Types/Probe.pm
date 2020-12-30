package Sys::Linux::Liburing::Types::Probe;

use strict;
use warnings;
use FFI::Platypus::Record;
use Sys::Linux::Liburing::Types::ProbeOp;

record_layout_1(qw(
  uint8 last_op
	uint8 ops_len
	uint16 resv
	uint32 resv2_1
	uint32 resv2_2
	uint32 resv2_3
	record(Sys::Linux::Liburing::Types::ProbeOp)* ops
)); # Not sure what the [0] on the ops there REALLY does.  Think it's just a pointer thing?

1;