#!/bin/bash

#env
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
.$HADOOP_HOME/etc/hadoop/hadoop-env.sh
export HBASE_CONF_DIR=$HBASE_HOME/conf
export HBASE_CLASSPATH=$HADOOP_CONF_DIR
export HBASE_MANAGES_ZK=true
export SPARK_MASTER_IP=namenode.docker
export SPARK_LOCAL_IP=$(hostname)

rm /tmp/*.pid
# fix lib issue & start ssh
ln -s /usr/lib64/libck-connector.so.0.0.0 /usr/lib64/libck-connector.so.0
/usr/sbin/sshd

# installing libraries if any - (resource urls added comma separated to the ACP system variable)
cd $HADOOP_HOME/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -

# datanode
if [[ $1 == "-d" ]]; then
  cd $HADOOP_HOME
  $HADOOP_HOME/sbin/hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start datanode
  $HADOOP_HOME/sbin/yarn-daemon.sh --config $HADOOP_CONF_DIR start nodemanager
  cd $HBASE_HOME
  . $HBASE_HOME/bin/hbase-config.sh
  $HBASE_HOME/bin/hbase-daemon.sh --config "${HBASE_CONF_DIR}" start zookeeper
  $HBASE_HOME/bin/hbase-daemon.sh --config "${HBASE_CONF_DIR}" start regionserver
  $HBASE_HOME/bin/hbase-daemon.sh --config "${HBASE_CONF_DIR}" start master-backup
  cd $SPARK_HOME
  $SPARK_HOME/bin/spark-class org.apache.spark.deploy.worker.Worker spark://$SPARK_MASTER_IP:7077 -c 2 -m 1024M
  while true; do sleep 1000; done
fi

# namenode
if [[ $1 == "-n" ]]; then
  cd $HADOOP_HOME
  $HADOOP_HOME/bin/hdfs namenode -format
  $HADOOP_HOME/sbin/hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start namenode
  $HADOOP_HOME/sbin/yarn-daemon.sh --config $HADOOP_CONF_DIR start resourcemanager
  $HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver --config $HADOOP_CONF_DIR
  cd $HBASE_HOME
  . $HBASE_HOME/bin/hbase-config.sh
  $HBASE_HOME/bin/hbase-daemon.sh --config "${HBASE_CONF_DIR}" start zookeeper
  $HBASE_HOME/bin/hbase-daemon.sh --config "${HBASE_CONF_DIR}" start master
  $HBASE_HOME/bin/hbase-daemon.sh --config "${HBASE_CONF_DIR}" start regionserver
  $HBASE_HOME/bin/hbase-daemon.sh --config "${HBASE_CONF_DIR}" start master-backup
  cd $SPARK_HOME
  $SPARK_HOME/sbin/start-master.sh
  $SPARK_HOME/bin/spark-class org.apache.spark.deploy.worker.Worker spark://$SPARK_MASTER_IP:7077 -c 2 -m 1024M
  while true; do sleep 1000; done
fi

# namenode with interactive shell for debugging (when ssh is unavaiable)
if [[ $1 == "-ni" ]]; then
  cd $HADOOP_HOME
  $HADOOP_HOME/bin/hdfs namenode -format
  $HADOOP_HOME/sbin/hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start namenode
  $HADOOP_HOME/sbin/yarn-daemon.sh --config $HADOOP_CONF_DIR start resourcemanager
  $HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver --config $HADOOP_CONF_DIR
  cd $HBASE_HOME
  . $HBASE_HOME/bin/hbase-config.sh
  $HBASE_HOME/bin/hbase-daemon.sh --config "${HBASE_CONF_DIR}" start zookeeper
  $HBASE_HOME/bin/hbase-daemon.sh --config "${HBASE_CONF_DIR}" start master
  $HBASE_HOME/bin/hbase-daemon.sh --config "${HBASE_CONF_DIR}" start regionserver
  $HBASE_HOME/bin/hbase-daemon.sh --config "${HBASE_CONF_DIR}" start master-backup
  cd $SPARK_HOME
  $SPARK_HOME/sbin/start-master.sh
  $SPARK_HOME/bin/spark-class org.apache.spark.deploy.worker.Worker spark://$SPARK_MASTER_IP:7077 -c 2 -m 1024M
  /bin/bash
fi

