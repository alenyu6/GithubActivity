#/bin/bash

#build/rebuild old site
cd ../activity
docker build -q -t activity .

#build/rebuild new website
cd ../activity2
docker build -q -t activity2 .

#build/rebuild ng proxy
cd ../hw4/nginx-rev
docker build -q -t ng .

#return us to hw4
cd ..

echo "Finished building necessary files"
