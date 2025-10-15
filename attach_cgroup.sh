# Setup Cgroups
# Go to HOST system (your main system,outside container), this setting you have to do in host system
cd /sys/fs/cgroup
sudo mkdir mycgroup
echo "+cpu" | sudo tee /sys/fs/cgroup/cgroup.subtree_control
echo "50000 100000" | sudo tee /sys/fs/cgroup/mycgroup/cpu.max
echo "500000000" | sudo tee /sys/fs/cgroup/mycgroup/memory.max

ps aux | grep "mynetworkns"  #Get process id of 2nd networkns process , because first is sudo process and last one is grep itself
echo '<your process id here>' > cgroup.procs # Add process ID of network namespace process here
#verify whether cgroup changed to mycgroup for mynetworkns process
cat /proc/<id of process>/cgroup # this should show something like 0::mycgroup
