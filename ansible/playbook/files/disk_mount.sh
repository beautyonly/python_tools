#!/bin/env bash

if [ ! -f /mnt/swapfile1 ]
then
    dd if=/dev/zero of=/mnt/swapfile1 bs=1M count=2048
    du -ksh /mnt/swapfile1
    mkswap -f /mnt/swapfile1
    swapon /mnt/swapfile1
    free -m 
    sed -i '#/mnt/swapfile1#d' /etc/fstab
    echo "/mnt/swapfile1       swap                 swap       defaults              0 0">>/etc/fstab
fi
