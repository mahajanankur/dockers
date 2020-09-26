# xpack
X-Pack is an Elastic Stack extension that bundles security, alerting, monitoring, reporting, and graph capabilities into one easy-to-install package. While the X-Pack components are designed to work together seamlessly, you can easily enable or disable the features you want to use.

## First time installation:
```sh
bash install.sh <single-node|multi-node>
```
## To uninstall whole setup:
It will remove the running containers and volumes.
```sh
bash uninstall.sh 
```
## To up/down container without removing volumes:
```sh
bash start-stop.sh stop
bash start-stop.sh start-single-node
bash start-stop.sh start-multi-node
```
