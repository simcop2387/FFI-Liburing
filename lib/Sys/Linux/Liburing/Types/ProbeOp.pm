package Sys::Linux::Liburing::Types::ProbeOp;

use strict;
use warnings;
use FFI::Platypus::Record;

record_layout_1(qw(
  uint8 op
	uint8 resv
	uint16 flags
	uint32 resv2
)); 

1;