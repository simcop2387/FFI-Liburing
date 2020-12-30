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

package Sys::Linux::Liburing::Types::Probe;

use strict;
use warnings;
use FFI::Platypus::Record;

record_layout_1(qw(
  uint8 last_op
	uint8 ops_len
	uint16 resv
	uint32 resv2_1
	uint32 resv2_2
	uint32 resv2_3
)); # Not sure what the [0] on the ops there REALLY does.  Think it's just a pointer thing?
  #record(Sys::Linux::Liburing::Types::ProbeOp)* ops

1;

package main;

use strict;
use warnings;

use FFI::Platypus;
 
my $ffi = FFI::Platypus->new( api => 1 );
$ffi->type("record(Sys::Linux::Liburing::Types::ProbeOp)" => 'io_uring_probeop');

1;
