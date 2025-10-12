# Remove the default route in the network namespace
sudo ip netns exec mynetworkns ip route del default via 10.0.0.1

# Delete the masquerade rule from iptables
sudo iptables -t nat -D POSTROUTING -s 10.0.0.0/24 -j MASQUERADE

# Reset IP forwarding (if it was originally disabled)
# If you are unsure, it's safer to leave it as is or check its initial state.
sudo sysctl -w net.ipv4.ip_forward=0

#remove ip addr from the host systemeth interface
sudo ip addr del 10.0.0.1/24 dev systemeth

# Bring down and delete the systemeth veth interface
sudo ip link set systemeth down
sudo ip link del systemeth

# Delete the network namespace
sudo ip netns del mynetworkns
