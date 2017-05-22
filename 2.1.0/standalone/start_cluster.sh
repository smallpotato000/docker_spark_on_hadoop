#!/bin/bash

docker run -ti --rm --name=namenode -h namenode.dockerspark.dev.docker --env-file ./master.env -p 8080:8080 -p 4040:4040 -p 50070:50070 -p 8088:8088 -p 19888:19888 geostar/dockerspark /etc/bootstrap.sh -nd

docker run -ti --rm --name=datanode1 -h datanode1.dockerspark.dev.docker --link namenode:namenode.dockerspark.dev.docker --env SPARK_LOCAL_IP=datanode1.dockerspark.dev.docker geostar/dockerspark /etc/bootstrap.sh -dd

docker run -ti --rm --name=datanode2 -h datanode2.dockerspark.dev.docker --link namenode:namenode.dockerspark.dev.docker --env SPARK_LOCAL_IP=datanode2.dockerspark.dev.docker geostar/dockerspark /etc/bootstrap.sh -dd
