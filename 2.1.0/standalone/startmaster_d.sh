docker run -d --name=namenode -h=namenode.spark.dev.docker -p 8080:8080 -p 4040:4040 -p 50070:50070 -p 8088:8088 -p 19888:19888 --dns=172.17.100.1 geostar/docker_spark_on_hadoop /etc/bootstrap.sh -nd
