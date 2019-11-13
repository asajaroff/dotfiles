# Storage related Linux commands
fdisk
lsblk
du
mount -l

## LVM
pvs
vgs 
lvs # Display logical volumes

### Find and stop all processes using that mountpoint
lsof | grep '/var' 
lsof +f -- /dev/mapper/Arch-var | awk 'NR==1 || $4~/[0-9]+[uw -]/'
fuser -kim /var  # kill any processes accessing files

### Try mounting it as RO first
mount -o remount,ro /dev/mapper/Arch-var # Doesn't work so we kill all processes

### Check integrity for the original lvs
e2fsck -fy /dev/mapper/Arch-var

### Extend 
lvextend -L 75G /dev/mapper/Arch-var # Extending /var partition
