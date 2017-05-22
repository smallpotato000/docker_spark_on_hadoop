FROM centos:7
MAINTAINER smallpotato000 <smallpotato000@163.com>

COPY jre-8u131-linux-x64.tar.gz /tmp/jre-8u131-linux-x64.tar.gz
RUN tar -zxf /tmp/jre-8u131-linux-x64.tar.gz -C /opt/
RUN rm /tmp/jre-8u131-linux-x64.tar.gz
RUN cd /opt && ln -s ./jre1.8.0_131 jre
COPY hadoop-2.7.3.tar.gz /tmp/hadoop-2.7.3.tar.gz
RUN tar -zxf /tmp/hadoop-2.7.3.tar.gz -C /opt/
RUN rm /tmp/hadoop-2.7.3.tar.gz
RUN cd /opt && ln -s ./hadoop-2.7.3 hadoop
COPY spark-2.1.0-bin-hadoop2.7.tgz /tmp/spark-2.1.0-bin-hadoop2.7.tgz
RUN tar -zxf /tmp/spark-2.1.0-bin-hadoop2.7.tgz -C /opt/
RUN rm /tmp/spark-2.1.0-bin-hadoop2.7.tgz
RUN cd /opt && ln -s ./spark-2.1.0-bin-hadoop2.7 spark
RUN yum install -y which openssh-server openssh-clients rsync
RUN cd /root && ssh-keygen -t dsa -P '' -f "/root/.ssh/id_dsa" \
&& cat /root/.ssh/id_dsa.pub >> /root/.ssh/authorized_keys && chmod 644 /root/.ssh/authorized_keys
ENV JAVA_HOME /opt/jre
ENV PATH $PATH:$JAVA_HOME/bin
ENV USER root
ENV HADOOP_PREFIX /opt/hadoop
RUN mkdir /var/run/sshd
ADD ssh-config /root/.ssh/config
RUN chmod 600 /root/.ssh/config
RUN chown root:root /root/.ssh/config

# fix the 254 error code
RUN sed  -i "/^[^#]*UsePAM/ s/.*/#&/"  /etc/ssh/sshd_config
RUN echo "UsePAM no" >> /etc/ssh/sshd_config
RUN echo "Port 2122" >> /etc/ssh/sshd_config

RUN mkdir -p /var/hadoopdata/hdfs/nn
RUN mkdir -p /var/hadoopdata/hdfs/dn
COPY core-site.xml $HADOOP_PREFIX/etc/hadoop/core-site.xml
COPY core-site.xml $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
COPY core-site.xml $HADOOP_PREFIX/etc/hadoop/mapred-site.xml
COPY core-site.xml $HADOOP_PREFIX/etc/hadoop/yarn-site.xml
ADD bootstrap.sh /etc/
ADD orders.csv /tmp/
RUN chown root:root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh
ENV BOOTSTRAP /etc/bootstrap.sh
# workingaround docker.io build error
RUN ls -la /opt/hadoop/etc/hadoop/*-env.sh
RUN chmod +x /opt/hadoop/etc/hadoop/*-env.sh
RUN ls -la /opt/hadoop/etc/hadoop/*-env.sh

# for debug
RUN yum install -y bind-utils net-tools

WORKDIR /

EXPOSE 22 4040 4044 7077 8030 8031 8032 8033 8040 8042 8080 8081 8088 9000 49707 50010 50020 50070 50075 50090
