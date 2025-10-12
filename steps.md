sudo apt install debootstrap
debootstrap --variant=minbase stable ./containers http://deb.debian.org/debian/

#copy or make server.js
#start networknamespace by bash create_network.sh 

sudo unshare --mount --pid --uts --net --cgroup --fork /bin/bash 
sudo ip netns exec mynetworkns chroot ./containers /bin/bash
#try ping but it will not work
echo 'nameserver 8.8.8.8' > /etc/resolv.conf
hostname cloudmash-container

#Now install all utils
apt-get install iputils-ping procps nano nodejs iproute2 -y 

mount -t proc proc /proc
mount -t sysfs sys /sys
mount -t tmpfs tmpfs /tmp



Cgroup
sudo mkdir mycgroup
echo "+cpu" | sudo tee /sys/fs/cgroup/cgroup.subtree_control
echo "50000 100000" | sudo tee /sys/fs/cgroup/mycgroup/cpu.max
echo "500000000" | sudo tee /sys/fs/cgroup/mycgroup/memory.max
sudo nano cgroup.procs give process id

Revert cgroup changes
echo "-cpu" | sudo tee /sys/fs/cgroup/cgroup.subtree_control
sudo rmdir /sys/fs/cgroup/mycgroup

#stop network namespace by bash delete_networkns.sh