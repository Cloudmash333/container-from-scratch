Please use a Virtual Ubuntu or any other linux for this tutorial, as leaving steps midway can cause issues in your system

 Watch video below for assisted hands on 

🎥 [Watch the YouTube video explanation here](https://www.youtube.com/watch?v=FNfNxoOIZJs)

# To run container 

sudo bash create_network.sh
# create your own server.js file or any application , and run it inside the newly created container
sudo bash make_container.sh

Get process id of the 2nd network namespce process my ps aux | grep "mynetworkns"  , and run below command

sudo bash attach_cgroup.sh
# To revert 
sudo bash revert.sh  
sudo bash delete_networkns.sh

Warning:
Adding cgroup and network changes listed here can cause unwanted changes in your system so do follow steps for reverting your changes
