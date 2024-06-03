Diski Umount edilir

    umount /dev/sdc1


fdisk ile disk açılır

    fdisk -u /dev/sdc

p ile partition açılır

~~~
Command (m for help): p

Disk /dev/sdc: 12.9 GB, 12884901888 bytes
255 heads, 63 sectors/track, 1566 cylinders, total 25165824 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x47c0b2bc

   Device Boot      Start         End      Blocks   Id   System
/dev/sdc1              63     4192964     2096451   83   Linux
~~~

d ile silinir

~~~
Command (m for help): d
Selected partition 1
~~~

n ile tekrar partition oluşturulur

~~~
Command (m for help): n
~~~


p ile partition seçilir ve numarası verilir

~~~
Command action
   e   extended
   p   primary partition (1-4)
p

Partition number (1-4): 1
~~~

First sector numarası verilir, bu numarayı önceden not edilmiş olması gerekmetedir

~~~
First sector (63-25165823, default 63): 63
~~~

Last Sector verilir bu sayede disk extend olur

~~~
Last sector, +sectors or _size{K,M,G} (63-25165823, default 25165823): 25165823
~~~

p ile bakılır 

~~~
Command (m for help): p

Disk /dev/sdc: 12.9 GB, 12884901888 bytes
255 heads, 63 sectors/track, 1566 cylinders, total 25165824 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x47c0b2bc

   Device Boot      Start         End      Blocks   Id   System
/dev/sdc1              63    25165823    12582880+  83   Linux
~~~

w ile kaydedilir

~~~
Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
~~~

e2fsck ile disk hata olup olmadığı kontrol edilir

~~~
-bash-4.1# e2fsck -f /dev/sdc1
e2fsck 1.41.12 (17-May-2010)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/sdc1: 2997/131072 files (0.5% non-contiguos), 164355/524112 blocks
~~~

extend etmek için resize2fs komutu çalıştırılır

~~~
-bash-4.1# resize2fs /dev/sdc1
resize2fs 1.41.12 (17-May-2010)
Resizing the file system on /dev/sdc1 to 3145720 (4k) blocks.
The file system on /dev/sdc1 is now 3145720 blocks long.
~~~

sonrasında mount edilir

~~~
-bash-4.1# mount /dev/sdc1 /data
~~~








