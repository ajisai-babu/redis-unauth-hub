# redis-unauth-hub
基于docker的redis未授权访问漏洞复现环境，用于复现 redis写计划任务、redis写webshell、redis写ssh公钥

你是否遇到过这样的烦恼：
1. redis未授权访问漏洞复现困难，dockerhub中的redis镜像仅有redis服务
2. 因为ubuntu的限制，redis无法写计划任务反弹shell
3. 复现redis写计划任务、redis写webshell、redis写ssh公钥需要分别搭建虚拟机，并安装相应服务

`redis-unauth-hub` 帮你解决

### 使用方法

#### 方法一：自行构建docker镜像

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

#### 方法二：下载镜像并导入

