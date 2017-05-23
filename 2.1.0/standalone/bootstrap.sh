#!/bin/bash

export HADOOP_HOME=/opt/hadoop
export HADOOP_CONF_DIR=/opt/hadoop/etc/hadoop
export SPARK_HOME=/opt/spark
export SPARK_MASTER_IP=namenode.docker
#export SPARK_LOCAL_IP=localhost

$HADOOP_HOME/etc/hadoop/hadoop-env.sh

rm /tmp/*.pid

# installing libraries if any - (resource urls added comma separated to the ACP system variable)
cd $HADOOP_HOME/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -

#start ssh
#systemctl enable sshd
systemctl start sshd

if [[ $1 == "-nd" ]]; then
  cd $HADOOP_HOME
  $HADOOP_HOME/bin/hdfs namenode -format
  $HADOOP_HOME/sbin/hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start namenode
  $HADOOP_HOME/sbin/yarn-daemon.sh --config $HADOOP_CONF_DIR start resourcemanager
  $HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver --config $HADOOP_CONF_DIR
  cd $SPARK_HOME
  $SPARK_HOME/sbin/start-master.sh
  while true; do sleep 1000; done
fi

if [[ $1 == "-ni" ]]; then
  cd $HADOOP_HOME
  $HADOOP_HOME/bin/hdfs namenode -format
  $HADOOP_HOME/sbin/hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start namenode
  $HADOOP_HOME/sbin/yarn-daemon.sh --config $HADOOP_CONF_DIR start resourcemanager
  $HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver --config $HADOOP_CONF_DIR
  cd $SPARK_HOME
  $SPARK_HOME/sbin/start-master.sh
  /bin/bash
fi

if [[ $1 == "-dd" ]]; then
  cd $HADOOP_HOME
  $HADOOP_HOME/sbin/hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start datanode
  $HADOOP_HOME/sbin/yarn-daemon.sh --config $HADOOP_CONF_DIR start nodemanager
  echo "starting spark worker"
  cd $SPARK_HOME
  $SPARK_HOME/bin/spark-class org.apache.spark.deploy.worker.Worker spark://$SPARK_MASTER_IP:7077 -c 2 -m 1024M
  while true; do sleep 1000; done
fi

if [[ $1 == "-di" ]]; then
  cd $HADOOP_HOME
  $HADOOP_HOME/sbin/hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start datanode
  $HADOOP_HOME/sbin/yarn-daemon.sh --config $HADOOP_CONF_DIR start nodemanager
  cd $SPARK_HOME
  $SPARK_HOME/bin/spark-class org.apache.spark.deploy.worker.Worker spark://$SPARK_MASTER_IP:7077 -c 2 -m 1024M
  /bin/bash
fi

