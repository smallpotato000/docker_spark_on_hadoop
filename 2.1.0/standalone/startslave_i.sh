docker run -ti --rm --dns=172.17.100.1 --name=$1 -h=$1.spark.dev.docker geostar/docker_spark_on_hadoop /etc/bootstrap.sh -bashd
