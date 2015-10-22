#!/bin/bash

if [ "$(whoami)" != "root" ]; then
	echo "This script needs root permissions."
	exit 1
fi

# Check sequential transfer rates
echo "* checking transfer rates:"
dd if=/dev/zero of=/iotest bs=64k count=16k conv=fdatasync
rm -rf /iotest

# Check IOPS
echo "* checking IOPS:"
if ! $(which ioping > /dev/null); then
	sudo apt-get install ioping
fi
ioping -c 10 $HOME

# Run HDparm
echo "* running hdparm tests"
if ! $(which hdparm > /dev/null); then
	sudo apt-get install hdparm
fi

drive=$(df -hP /  | tr -s ' ' | grep "/dev" | cut -f 1 -d ' ')

echo "  - cached:"
hdparm -T $drive
echo "  - uncached:"
hdparm -t $drive
