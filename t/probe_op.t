use strict;
use warnings;

use Test::More;
use Data::Dumper;

use FFI::Liburing qw/io_uring_get_probe io_uring_opcode_supported IORING_OP_NOP IORING_OP_READV IORING_OP_WRITEV/;

my $probe = io_uring_get_probe();

# Check if there's a minimum set of operations supported
ok(io_uring_opcode_supported($probe, IORING_OP_NOP), "NOP supported");
ok(io_uring_opcode_supported($probe, IORING_OP_READV), "READV supported");
ok(io_uring_opcode_supported($probe, IORING_OP_WRITEV), "WRITEV supported");

done_testing;