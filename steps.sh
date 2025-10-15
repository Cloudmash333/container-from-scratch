### Container Setup Using `debootstrap`

```bash
sudo apt install debootstrap
mkdir containers
debootstrap --variant=minbase stable ./containers http://deb.debian.org/debian/
# Setup Network Namespace
# Copy or create your server.js file
# Start the network namespace
bash create_network.sh
# Enter the Container Namespace
sudo unshare --mount --pid --uts --net --cgroup --fork /bin/bash

sudo ip netns exec mynetworkns chroot ./containers /bin/bash
# Fix DNS and Hostname
# Try ping (it won’t work yet)
ping -c 3 8.8.8.8

# Add DNS resolver
echo 'nameserver 8.8.8.8' > /etc/resolv.conf

# Set container hostname
hostname cloudmash-container
Install Utilities Inside the Container
apt-get install iputils-ping procps nano nodejs iproute2 -y
# Mount Required Filesystems
mount -t proc proc /proc
mount -t sysfs sys /sys
mount -t tmpfs tmpfs /tmp
# Setup Cgroups
# Go to HOST system (your main system,outside container), this setting you have to do in host system
cd /sys/fs/cgroup
sudo mkdir mycgroup
echo "+cpu" | sudo tee /sys/fs/cgroup/cgroup.subtree_control
echo "50000 100000" | sudo tee /sys/fs/cgroup/mycgroup/cpu.max
echo "500000000" | sudo tee /sys/fs/cgroup/mycgroup/memory.max

ps aux | grep "mynetworkns"  #Get process id of 2nd networkns process , because first is sudo process and last one is grep itself
sudo nano /sys/fs/cgroup/mycgroup/cgroup.procs   # Add process ID of network namespace process here
#verify whether cgroup changed to mycgroup for mynetworkns process
cat /proc/<id of process>/cgroup # this should show something like 0::mycgroup
# Revert Cgroup Changes
# On your host(outside container)
echo "-cpu" | sudo tee /sys/fs/cgroup/cgroup.subtree_control

sudo rmdir /sys/fs/cgroup/mycgroup
# Stop Network Namespace
bash delete_networkns.sh
