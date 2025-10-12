# 1. Create a new network namespace
sudo ip netns add mynetworkns

# 2. Create the veth pair in the default namespace
sudo ip link add systemeth type veth peer name containereth

# 3. Move one end of the veth pair (containereth) into the new namespace
sudo ip link set containereth netns mynetworkns

# 4. Assign an IP and bring up the interface on the host (systemeth)
sudo ip addr add 10.0.0.1/24 dev systemeth
sudo ip link set systemeth up

# 5. Assign an IP and bring up the interface inside the new namespace (containereth)
sudo ip netns exec mynetworkns ip addr add 10.0.0.2/24 dev containereth
sudo ip netns exec mynetworkns ip link set containereth up

# 6. Bring up the loopback interface in the new namespace
sudo ip netns exec mynetworkns ip link set lo up

# 7. Enable IP forwarding on the host
sudo sysctl -w net.ipv4.ip_forward=1

# 8. Add a NAT rule so the namespace can access the internet
sudo iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -j MASQUERADE

# 9. Add a default route inside the namespace, pointing to the host's veth end
sudo ip netns exec mynetworkns ip route add default via 10.0.0.1

# 10. Test connectivity from inside the new namespace
sudo ip netns exec mynetworkns ping -c 3 8.8.8.8
