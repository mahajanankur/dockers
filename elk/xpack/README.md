### First time installation:
```sh
bash install.sh <single-node|multi-node>
```
### To uninstall whole setup:
It will remove the running containers and volumes.
```sh
bash uninstall.sh 
```
### To up/down container without removing volumes:
```sh
bash start-stop.sh stop
bash start-stop.sh start-single-node
bash start-stop.sh start-multi-node
```
