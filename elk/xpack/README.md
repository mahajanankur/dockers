1) First time installation:
    a. bash install.sh <single-node|multi-node>

2) To delete whole setup:
    It will remove the running container, delete volume.
    a. bash uninstall.sh 

2) To down/up container without deleting volumes:
    a. bash start-stop.sh stop
    b. bash start-stop.sh start-single-node
    c. bash start-stop.sh start-multi-node
