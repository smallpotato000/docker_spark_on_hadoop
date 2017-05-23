docker run -d --dns=172.17.100.1 --name=$1 -h $1.docker --link namenode:namenode.docker --env SPARK_LOCAL_IP=$1.docker geostar/dockerspark /etc/bootstrap.sh -dd
