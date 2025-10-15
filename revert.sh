# On your host(outside container)
#Revert cgroup changes
echo "-cpu" | sudo tee /sys/fs/cgroup/cgroup.subtree_control
sudo rmdir /sys/fs/cgroup/mycgroup

#delete network namespace
bash delete_networkns.sh