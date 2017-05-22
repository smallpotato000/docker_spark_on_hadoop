docker run --name=$1 -d --dns=172.17.100.1 --link namenode:namenode.dockerspark.dev.docker --env-file ./slave.env geostar/dockerspark geostar/dockerspark /etc/bootstrap.sh -dd
