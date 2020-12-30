package 
  Sys::Linux::Liburing::Types::StatxTime;

use strict;
use warnings;
use FFI::Platypus::Record;

record_layout_1(qw(
	sint64 tv_sec
	uint32 tv_nsec
	sint32 reserved
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
	uint16 _spare0
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
	uint64 _spare1_1
	uint64 _spare1_2
	uint64 _spare1_3
	uint64 _spare1_4
	uint64 _spare1_5
	uint64 _spare1_6
	uint64 _spare1_7
	uint64 _spare1_8
	uint64 _spare1_9
	uint64 _spare1_10
	uint64 _spare1_11
	uint64 _spare1_12
	uint64 _spare1_13
	uint64 _spare1_14
)); 

# good chance i'll split this out to another module and consume it here later

1;