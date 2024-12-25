#!/bin/bash

# 启动 SSH 服务
/usr/sbin/sshd

# 启动 Crond 服务
/usr/sbin/crond

# 启动 Redis 服务
redis-server /etc/redis.conf &

# 启动 Apache
LOCKFILE=/run/httpd/httpd.pid

# 如果LOCKFILE存在，先删除它
if [ -f $LOCKFILE ]; then
  rm -f $LOCKFILE
fi

# 执行apachectl
/usr/sbin/apachectl -D FOREGROUND

tail -f /dev/null