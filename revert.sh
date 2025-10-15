#Cgroup
mkdir mycgroup
echo "+cpu" | sudo tee /sys/fs/cgroup/cgroup.subtree_control
echo "50000 100000" | sudo tee /sys/fs/cgroup/mycgroup/cpu.max
echo "500000000" | sudo tee /sys/fs/cgroup/mycgroup/memory.max
echo '<your process id here>' > cgroup.procs

#Revert cgroup changes
echo "-cpu" | sudo tee /sys/fs/cgroup/cgroup.subtree_control
sudo rmdir /sys/fs/cgroup/mycgroup

bash delete_networkns.sh