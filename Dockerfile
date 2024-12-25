FROM centos:7.6.1810

RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
COPY Centos-7.repo /etc/yum.repos.d/
RUN yum clean all && yum makecache

RUN yum install -y \
        openssh-server \
        cronie \
        httpd \
        php \
        net-tools \
        wget \
        gcc \
        automake \
        autoconf \
        libtool \
        make \
        initscripts && \
    yum clean all && \
    rm -rf /var/cache/yum
    
COPY redis-3.2.11.tar.gz ./
RUN tar xzf redis-3.2.11.tar.gz &&\
    cd redis-3.2.11 && \
    make && cd src && cp redis-server /usr/bin &&  cp redis-cli /usr/bin && \
    rm -f redis-3.2.11.tar.gz

ADD redis.conf /etc/redis.conf
ADD sshd_config /etc/ssh/sshd_config

RUN ssh-keygen -q -P "" -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -q -P "" -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -q -P "" -t ed25519 -f /etc/ssh/ssh_host_ed25519_key

RUN mkdir /var/run/sshd && \
    mkdir /root/.ssh
ADD run.sh /run.sh 
RUN chmod u+x /run.sh
EXPOSE 80 22 6379

CMD ["bash", "/run.sh"]