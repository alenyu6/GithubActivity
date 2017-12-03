#/bin/bash

#Notes: should work for something like activity3

# must build before doing compose to make sure files are up to date
# run dorun.sh to setup the initial site and nginx proxy

#function to kill docker process
function kill {
    docker ps -a  > /tmp/yy_xx$$
    if grep --quiet $1 /tmp/yy_xx$$
     then
     echo "killing older version of $1"
     docker rm -f `docker ps -a | grep $1  | sed -e 's: .*$::'`
   fi
}

# read command line args, $1 - name of docker image to swap to

# variables for swapping below
# name of swap script [swap1.sh, swap2.sh]
# image name - any image name
# container name  - get current web container name
# process to kill [web1, web2]
swap_script=""
image_name=$1
container_name=$(docker ps --format '{{.Names}}' | grep web)
to_kill=""

echo $container_name

# Switch between activity and activity2
# If neither the script echos a warning message and exits
if [[ $container_name == *"web1"* ]]; then #swap to web2

    swap_script="/bin/swap2.sh"
    container_name="web2"
    to_kill="web1"

elif [[ $container_name == *"web2"* ]]; then #swap to web1

    swap_script="/bin/swap1.sh"
    container_name="web1"
    to_kill="web2"

else
    echo "No sites are running to swap to"
    exit 1
fi

# run the appropriate files, dont care which internal port
# only care that the exposed port matches the multidocker (8080 by default)

echo "Begin Swapping!"
echo "Linking $container_name to $network_name"

network_id=$(docker network ls | grep ecs189 | sed -e 's/ .*$//')
docker run -d --network $network_id -P --name $container_name $image_name

# run swap shell script to change conf file and reload
# run command to find ecs189 proxy
# run correct swap image based on image
echo "Executing swap script to update nginx config file on nginx container"
proxy_id=$(docker ps -a | grep ecs189_proxy | sed -e 's/ .*$//')
sleep 2 && docker exec $proxy_id /bin/bash $swap_script

#kill the container that has been swapped
echo "Killing process $to_kill"
kill $to_kill

echo "Finished"