# Docker Setup
 
Update the default configuration and restart
Required to build with gpu supprot
```
pushd $(mktemp -d)
(sudo cat /etc/docker/daemon.json 2>/dev/null || echo '{}') | \
    jq '. + {"default-runtime": "nvidia"}' | \
    tee tmp.json
sudo mv tmp.json /etc/docker/daemon.json
popd
sudo systemctl restart docker
```

No need for nvidia-docker or --engine=nvidia

```
docker run --rm -it nvidia/cuda nvidia-smi
```

### Start Container
```
docker start -a -i `docker ps -q -l`
```
##### Explanation:

docker start start a container (requires name or ID)
* a - attach to container
* i - interactive mode

docker ps List containers 
* q - list only container IDs
* l - list only last created container.

### Remane Container
```
docker rename `docker ps -q -l` terrain
```
#### Explanation:

docker rename my_container my_new_container

### Basic Commands
 ```
docker stop `terrain`
docker start `terrain`
docker restart `terrain`
```
### To Connect to a Running Container.
```
docker attach `terrain`
```
### Remove Container
 ```     
docker rm `terrain`
 ```    
