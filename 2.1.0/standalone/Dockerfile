FROM centos:7
MAINTAINER smallpotato000 <smallpotato000@163.com>

###GLOBAL###
ENV USER root
###INSTALL###
# caching
RUN yum makecache fast
### SSH
RUN yum install -y which openssh-server openssh-clients rsync bind-utils net-tools
# fix ssh problem by using ubuntu's sshd
COPY openssh_ubuntu_tgz /tmp/openssh.tgz
RUN tar -zxf /tmp/openssh.tgz -C / --overwrite && mkdir /var/run/sshd
### JRE
COPY jre-8u131-linux-x64.tar.gz /tmp/jre-8u131-linux-x64.tar.gz
RUN tar -zxf /tmp/jre-8u131-linux-x64.tar.gz -C /opt/ && cd /opt && ln -s ./jre1.8.0_131 jre && rm /tmp/jre-8u131-linux-x64.tar.gz 
### Hadoop
COPY hadoop-2.7.3.tar.gz /tmp/hadoop-2.7.3.tar.gz
RUN tar -zxf /tmp/hadoop-2.7.3.tar.gz -C /opt/ && cd /opt && ln -s ./hadoop-2.7.3 hadoop && rm /tmp/hadoop-2.7.3.tar.gz
### HBase
COPY hbase-1.3.1-bin.tar.gz /tmp/hbase-1.3.1-bin.tar.gz 
RUN tar -zxf /tmp/hbase-1.3.1-bin.tar.gz -C /opt/ && cd /opt && ln -s ./hbase-1.3.1 hbase && rm /tmp/hbase-1.3.1-bin.tar.gz
### Spark
COPY spark-2.1.0-bin-hadoop2.7.tgz /tmp/spark-2.1.0-bin-hadoop2.7.tgz
RUN tar -zxf /tmp/spark-2.1.0-bin-hadoop2.7.tgz -C /opt/ && cd /opt && ln -s ./spark-2.1.0-bin-hadoop2.7 spark && rm /tmp/spark-2.1.0-bin-hadoop2.7.tgz 
###CONFIG###
### JRE config
ENV JAVA_HOME /opt/jre
ENV PATH $PATH:$JAVA_HOME/bin
### SSH config
ADD ssh-config /root/.ssh/config
RUN chmod 600 /root/.ssh/config && chown root:root /root/.ssh/config
RUN sed  -i "/^[^#]*UsePAM/ s/.*/#&/"  /etc/ssh/sshd_config && echo "UsePAM no" >> /etc/ssh/sshd_config && echo "Port 2122" >> /etc/ssh/sshd_config 
### Hadoop config
ENV HADOOP_HOME /opt/hadoop
COPY core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
COPY hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
COPY mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
COPY yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml
RUN mkdir -p /var/hadoopdata/hdfs/nn && mkdir -p /var/hadoopdata/hdfs/dn
RUN chmod +x $HADOOP_HOME/etc/hadoop/*-env.sh
### HBase config
ENV HBASE_HOME /opt/hbase
COPY hbase-site.xml /opt/hbase/conf/hbase-site.xml
RUN mkdir -p /var/hadoopdata/hbasetmp && mkdir -p /var/hadoopdata/zk
### Spark config
ENV SPARK_HOME /opt/spark
### Bootstrap config
ADD bootstrap.sh /etc/
RUN chown root:root /etc/bootstrap.sh && chmod 700 /etc/bootstrap.sh
ENV BOOTSTRAP /etc/bootstrap.sh
###FIX###
### SSH fix
RUN /usr/bin/ssh-keygen -A
# insted of running ssh-keygen we use existing keys so we can ssh into the container
# so remember to copy id_dsa and id_dsa.pub to /root
# RUN cd /root && ssh-keygen -t dsa -P '' -f "/root/.ssh/id_dsa"
RUN mkdir -p /root/.ssh && chmod 755 /root/.ssh
COPY id_dsa /root/.ssh/id_dsa
COPY id_dsa.pub /root/.ssh/id_dsa.pub
RUN chmod 600 /root/.ssh/id_dsa && chmod 644 /root/.ssh/id_dsa.pub 
RUN cat /root/.ssh/id_dsa.pub >> /root/.ssh/authorized_keys && chmod 644 /root/.ssh/authorized_keys
RUN cp /root/.ssh/id_dsa /etc/ssh/ssh_host_dsa_key && chown root:ssh_keys /etc/ssh/ssh_host_dsa_key && chmod 640 /etc/ssh/ssh_host_dsa_key
RUN cp /root/.ssh/id_dsa.pub /etc/ssh/ssh_host_dsa_key.pub && chmod 644 /etc/ssh/ssh_host_dsa_key.pub
###SETTINGS###
### Container Settings
WORKDIR /
EXPOSE 22 2122 2181 4040 4044 7077 8030 8031 8032 8033 8040 8042 8080 8081 8088 9000 16000 16010 49707 50010 50020 50070 50075 50090

