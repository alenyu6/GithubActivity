#/bin/bash

#function to kill docker process
function kill {
    docker ps -a  > /tmp/yy_xx$$
    if grep --quiet $1 /tmp/yy_xx$$
     then
     echo "killing older version of $1"
     docker rm -f `docker ps -a | grep $1  | sed -e 's: .*$::'`
   fi
}

#build the files
#build new site
cd ../activity2
docker build -t activity2 .
#rebuild proxy server
cd ../hw4
#cd ../hw4/nginx-rev
#docker build -t ng .
#return back to hw4 directory
#cd ..

#must build before doing compose to make sure files are up to date
#/bin/bash dorun.sh

# run the appropriate files, dont care which internal port
# only care that the exposed port matches the multidocker (8080 by default)

network_id=$(docker network ls | grep ecs189 | sed -e 's/ .*$//')
echo $network_name

docker run -d --network $network_id -P --name web2 activity2

#run swap shell script to change conf file and reload
# - run command to find ecs189 proxy
# - run correct swap image based on image
proxy_id=$(docker ps -a | grep ecs189_proxy | sed -e 's/ .*$//')
docker exec $proxy_id /bin/bash /bin/swap2.sh

#kill correct container
kill web1