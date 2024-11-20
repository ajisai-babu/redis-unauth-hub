FROM centos:7.6.1810

RUN mv /usr/bin/systemctl /usr/bin/systemctl.old
COPY systemctl.py /usr/bin/systemctl
RUN chmod +x /usr/bin/systemctl
RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
COPY Centos-7.repo /etc/yum.repos.d/
RUN yum clean all && yum makecache

RUN yum install -y openssh-server
RUN yum install -y cronie
RUN yum install -y httpd php
RUN yum install -y net-tools
RUN yum install -y wget 
RUN yum -y install gcc automake autoconf libtool make
RUN yum -y install initscripts 
COPY redis-3.2.11.tar.gz ./
RUN tar xzf redis-3.2.11.tar.gz &&\
    cd redis-3.2.11 && \
    make && cd src && cp redis-server /usr/bin &&  cp redis-cli /usr/bin

ADD redis.conf /etc/redis.conf
ADD sshd_config /etc/ssh/sshd_config
RUN ssh-keygen -q -P "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -q -P "" -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key
RUN ssh-keygen -q -P "" -t ed25519 -f /etc/ssh/ssh_host_ed25519_key
RUN mkdir /var/run/sshd
ADD run.sh /run.sh 
RUN chmod u+x /run.sh
RUN mkdir /root/.ssh
EXPOSE 80 22 6379

CMD ["bash", "/run.sh"]
