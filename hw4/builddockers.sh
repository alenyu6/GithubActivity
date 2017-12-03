#/bin/bash

#build/rebuild new site
cd ../activity
docker build -q -t activity2 .

#build/rebuild old website
cd ../activity_old
docker build -q -t activity .

#build/rebuild ng proxy
cd ../hw4/nginx-rev
docker build -q -t ng .

#return us to hw4
cd ..

echo "Finished building necessary files"
