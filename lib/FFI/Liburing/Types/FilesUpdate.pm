package Sys::Linux::Liburing::Types::FilesUpdate;

use strict;
use warnings;
use FFI::Platypus::Record;

record_layout_1(qw(
  uint32 offset
	uint32 resv
	uint64 fds
)); 

die "Unsupported alignment directives at the moment";

1;