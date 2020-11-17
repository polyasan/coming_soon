# https://github.com/DigitallySeamless/nodejs-bower-grunt-runtime/blob/master/Dockerfile

# <--- STARTS HERE ---->
#
# Node.js w/ Bower & Grunt runtime Dockerfile
#
# https://github.com/dockerfile/nodejs-bower-grunt-runtime
#

# Pull base image.
FROM mhart/alpine-node:8

# Define working directory.
WORKDIR /app

# Set instructions on build.
ADD package.json /app/
ADD ./dist /app/
#ADD . /app

WORKDIR /app/dist
ENV NODE_ENV production
RUN npm install --production

# Define default command.
CMD ["npm", "start"]

# Expose ports.
EXPOSE 8080

# <--- ENDS HERE --->

# http://stackoverflow.com/questions/24482822/how-to-share-my-docker-image-without-using-the-docker-hub

# TODO:
# 1) remove .git/ directory
# 2) remove /root/ directory
# 3) do not build with devDependencies
#    npm install --production,  (npm install insalls devdependencies too)
#    also see bug: https://github.com/npm/npm/issues/2369


## Current build log:
# npm run build:production
#
# export SERVER="lxxa@muyyyyyak.myyyz.hu"
# export REMOTE_HOME="/home/lxxa";
# export NAME="agegap.`date +%Y%m%d-%H%M%S`"; echo $NAME
# echo $SERVER:$REMOTE_HOME
# sudo docker build -t="$NAME" .

# sudo docker save -o ../$NAME.tar `sudo docker images -q |head -n 1`; sudo chmod 644 ../$NAME.tar; gzip ../$NAME.tar;
# read -p "Upload to the server" -s; \
# scp ../$NAME.tar.gz $SERVER:$REMOTE_HOME;

## export REMOTE_VAR=$LOCAL_VAR
# ssh -t $SERVER 'export NAME='"'$NAME'"'; /bin/bash'
# gunzip $NAME.tar.gz
# sudo docker load < $NAME.tar
#
# sudo docker tag `sudo docker images -q |head -n 1` $NAME
# sudo docker run --restart=always \
# -d \
# --name agegap_`date +%Y%m%d-%H%M%S` \
# --link some-mongo:mongo -e "MONGO_DB=agegap" \
# -e "VIRTUAL_HOST=agegap.gyosz.hu,agegap.eu,www.agegap.eu" \
# -e "VIRTUAL_PORT=8086" -e "PORT=8086" -p 8086:8086 \
# $NAME ;

##Howto build:
# if no mongodb is running:
# sudo docker run --restart=always --name some-mongo -d mongo
#
# export USER="la"; export SERVER="kegysz..hu"; \
# export NAME="mgyosz.kegysz.`date +%Y%m%d-%H%M%S`"; \
# sudo docker build -t="$NAME" .; \
# sudo docker save -o ../$NAME.tar `sudo docker images -q |head -n 1`; sudo chmod 644 ../$NAME.tar; gzip ../$NAME.tar; \
# echo "BUILD FINISHED, PLEASE CHECK THE CHECKSuMS:"; \
# docker images; ls -lh ..; \
# read -p "Upload to the server" -s; \
# scp ../$NAME.tar.gz $USER\@$SERVER:/home/$USER; \
# read -p "SSH to the server" -s; \
# ssh $USER\@$SERVER

## # read -p "Upload to the server" -n1 -s; \, the -n1 makes it work to a single
## character, without the need to press enter. Makes too many false positive.

#
##On the server:
# gunzip $NAME.tar.gz
# sudo docker load < $NAME.tar
# docker images # check if it loaded fine
##tag if necessary:
# docker tag fda56de88fff mgyosz.kegysz.20150206-103303
# echo "Launch the image:"
# sudo docker run --restart=always \
# --name kemmgye_`date +%Y%m%d-%H%M%S` \
# --link some-mongo:mongo -d -e "MONGO_DB=kemmgye" \
# -e "VIRTUAL_HOST=kemmgye.gyosz.hu,kemmgye.hu,www.kemmgye.hu" \
# -e "VIRTUAL_PORT=8086" -e "PORT=8086" -p 8086:8086 \
# $NAME
#
##docker commands on the server
##list containers:
#docker ps
#
##stop container (id):
#docker stop 2d308a2c7cb7
#
##remove container (id)
#docker rm 2d308a2c7cb7
#
##list docker images:
#docker images
#
##remove image (id/tag):
#docker rmi mgyosz.kegysz.20150202-105858
#
##view error log of an image (id)
#docker logs 466731924b7b
#
# Modifying an image (correcting a mistake):
# sudo docker run --name mgy_`date +%Y%m%d-%H%M%S` \
# -ti mgyosz.kegysz.20150223-154052 /bin/bash
## vi the necessary files, then 'exit'
# docker ps -a
## we obtain the id of the just exited container: d7558d5ae2fc
#  docker commit -m "Corrected express.js" -a "Kis jakab" d7558d5ae2fc mgyosz.kegysz.20150223-154052:v2
## start a new container:
#
# sudo docker run --restart=always \
# --name mgy_`date +%Y%m%d-%H%M%S` \
# --link some-mongo:mongo -d -e "MONGO_DB=kegysz" \
# -e "VIRTUAL_HOST=kegysz.gyosz.hu" \
# -e "VIRTUAL_PORT=8086" -e "PORT=8086" -p 8086:8086 \
# mgyosz.kegysz.20150309-194936:kegysz \
# npm start
#
## notice the 'npm start' at the end. Otherwise it will start with /bin/bash
##############################################################
# 1) Run an automatic reverse proxy.
# It recognize containers started with VIRTUAL_HOST, VIRTUAL_PORT variables.
# link: http://jasonwilder.com/blog/2014/03/25/automated-nginx-reverse-proxy-for-docker/
#
# sudo docker run --restart=always \
# -d -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock jwilder/nginx-proxy
##
# 2) Start dockerui
#    to monitor docker containers via browser.
#
# sudo docker run --restart=always \
# -d -p 9000:9000 -e VIRTUAL_HOST=yyy.gyosz.hu \
# --privileged -v /var/run/docker.sock:/var/run/docker.sock dockerui/dockerui
##
# 3) Start the 4 webpages.
#    for multiple domains: -e VIRTUAL_HOST="xxx.gyosz.hu,xxx.hu,www.xxx.hu"
#
##############################################################
# If container is started without restart=always option:
# 1. stop docker (sudo service docker stop)
# 2. modify the /var/lib/docker/container/CONTAINER_ID/hostconfig.json -> RestartPolicy
# http://stackoverflow.com/questions/26852321/docker-add-a-restart-policy-to-a-container-that-was-already-created
#
##############################################################
# Some docker stats:
#
# ! /bin/bash
#
# for d in `docker ps | awk '{print $1}' | tail -n +2`; do
#     d_name=`docker inspect -f {{.Name}} $d`
#     echo "========================================================="
#     echo "$d_name ($d) container size:"
#     sudo du -d 2 -h /var/lib/docker/aufs | grep `docker inspect -f "{{.Id}}" $d`
#     echo "$d_name ($d) volumes:"
#     for mount in `docker inspect -f "{{range .Mounts}} {{.Source}}:{{.Destination}}
#     {{end}}" $d`; do
#         size=`echo $mount | cut -d':' -f1 | sudo xargs du -d 0 -h`
#         mnt=`echo $mount | cut -d':' -f2`
#         echo "$size mounted on $mnt"
#     done
# done
##############################################################
#
# If docker daemon do not start automatically at boot time (ubuntu 15.10)
# $ sudo systemctl enable docker
#
