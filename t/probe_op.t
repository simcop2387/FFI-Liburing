use strict;
use warnings;

use Test::More;

use FFI::Liburing qw//;

my $testop = FFI::Liburing::Types::ProbeOp->new(
  op => 0, # IOURING_OP_NOP
  last_op => 1, # IOURING_OP_READV, we should be pulling in IOURING_OP_LAST but I'm not exporting it right now
  flags => 0, # no flags
);

ok($testop, "Test operation created");

done_testing;