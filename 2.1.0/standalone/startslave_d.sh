docker run --name=$1 -d -h=$1.spark.dev.docker --dns=172.17.100.1 geostar/docker_spark_on_hadoop /etc/bootstrap.sh -dd
