UUID=`blkid /dev/nvme0n1p2 | grep -ow 'UUID="[a-f0-9\-]*"' | sed 's?"??g'`
LINUM=`grep -n GRUB_CMDLINE_LINUX= /etc/default/grub | cut -d ":" -f 1`
HEAD=`head -$((${LINUM} - 1)) /etc/default/grub`
LENGTH=`wc -l /etc/default/grub | awk '{ print $1 }'`
TAIL=`tail -$((${LENGTH} - ${LINUM})) /etc/default/grub`
CMDLINE='GRUB_CMDLINE_LINUX="resume=/dev/arch/swap cryptdevice='
CMDLINE+=${UUID}
CMDLINE+=':crytplvm root=/dev/arch/root"'
echo "${HEAD}" > prep/grub
echo "${CMDLINE}" >> prep/grub
echo "${TAIL}" >> prep/grub
