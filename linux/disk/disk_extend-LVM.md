# Disk Extend LVM

#### Check fdisk -l /dev/sda disk size is correct

    Disk /dev/sda: 64.4 GB, 64424509440 bytes
    255 heads, 63 sectors/track, 7832 cylinders
    Units = cylinders of 16065 * 512 = 8225280 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disk identifier: 0x000d78cd

    Device Boot      Start         End      Blocks   Id  System
    /dev/sda1   *           1          64      512000   83  Linux
    Partition 1 does not end on cylinder boundary.
    /dev/sda2              64        3917    30944256   8e  Linux LVM

    Disk /dev/mapper/vg_vmware-lv_root: 29.6 GB, 29569843200 bytes
    255 heads, 63 sectors/track, 3594 cylinders
    Units = cylinders of 16065 * 512 = 8225280 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disk identifier: 0x00000000

    Disk /dev/mapper/vg_vmware-lv_swap: 2113 MB, 2113929216 bytes
    255 heads, 63 sectors/track, 257 cylinders
    Units = cylinders of 16065 * 512 = 8225280 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disk identifier: 0x00000000

#### Create new partition with n

    WARNING: DOS-compatible mode is deprecated. It's strongly recommended to
             switch off the mode (command 'c') and change display units to
             sectors (command 'u').

    Command (m for help): n
    Command action
       e   extended
       p primary partition (1-4) p
    Partition number (1-4): 3
    First cylinder (3917-7832, default 3917): 
    Using default value 3917
    Last cylinder, +cylinders or +size{K,M,G} (3917-7832, default 7832): 
    Using default value 7832

#### make it lv with command t

#### save w

    Command (m for help): w
    The partition table has been altered!

    Calling ioctl() to re-read partition table.

    WARNING: Re-reading the partition table failed with error 16: Device or resource busy.
    The kernel still uses the old table. The new table will be used at
    the next reboot or after you run partprobe(8) or kpartx(8)
    Syncing disks.

#### kpartx -s /dev/sda

#### reboot

#### pvcreate /dev/sdaX

    Physical volume "/dev/sdaX" successfully created

#### vgdisplay and take vgname

#### vgextend $vgname /dev/sdaX

    Volume group "$vg_name" successfully extended

#### lvdisplay and take LV path

#### lvextend $lvpath /dev/sdaX

    Extending logical volume $lv_path to 200 GiB
    Logical volume $lv_path successfully resized

#### resize2fs $lvpath

    resize2fs 1.41.12 (17-May-2010)
    Filesystem at /dev/vg_vmware/lv_root is mounted on /; on-line resizing required
    old desc_blocks = 2, new_desc_blocks = 4
    Performing an on-line resize of /dev/vg_vmware/lv_root to 15081472 (4k) blocks.
    The filesystem on /dev/$vg_group/$lv_pathis now 15081472 blocks long

#### df -h

not: echo "- - -" > /sys/class/scsi_host/host0-5/scan
