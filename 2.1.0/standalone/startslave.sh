docker run -d --dns=172.17.100.1 --name=$1 -h $1.docker --link namenode:namenode.docker geostar/dockerspark /etc/bootstrap.sh -d
