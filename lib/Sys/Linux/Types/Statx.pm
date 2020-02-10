package 
  Sys::Linux::Liburing::Types::StatxTime;

use strict;
use warnings;
use FFI::Platypus::Record;

record_layout_1(qw(
	int64 tv_sec
	uint32 tv_nsec
	int32 reserved
));

package Sys::Linux::Liburing::Types::Statx;

use strict;
use warnings;
use FFI::Platypus::Record;

record_layout_1(qw(
	uint32 stx_mask
	uint32 stx_blksize
	uint64 stx_attributes
	uint32 stx_nlink
	uint32 stx_uid
	unit32 stx_gid
	uint16 stx_mode
	uint16(1) _spare0
	uint64 stx_ino
	uint64 stx_size
	uint64 stx_blocks
	uint64 stx_attributes_mask
	record(Sys::Linux::Liburing::Types::StatxTime) stx_atime
	record(Sys::Linux::Liburing::Types::StatxTime) stx_btime
	record(Sys::Linux::Liburing::Types::StatxTime) stx_ctime
	record(Sys::Linux::Liburing::Types::StatxTime) stx_mtime
	uint32 stx_rdev_major
	uint32 stx_rdev_minor
	uint32 stx_dev_major
	uint32 stx_dev_minor
	uint64(14) _spare1
)); 

# good chance i'll split this out to another module and consume it here later

1;