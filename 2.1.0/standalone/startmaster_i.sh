docker run -ti --rm --dns=172.17.100.1 --name=namenode -h namenode.docker --env SPARK_LOCAL_IP=namenode.docker -p 8080:8080 -p 4040:4040 -p 50070:50070 -p 8088:8088 -p 19888:19888 geostar/dockerspark /etc/bootstrap.sh -ni
