#!/bin/bash
echo Yes | parted /dev/sda ---pretend-input-tty resizepart 1 100%
btrfs filesystem resize max /
