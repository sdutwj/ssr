FROM centos:latest
MAINTAINER wangjian

RUN apt-get update
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:root' |chpasswd
RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
EXPOSE 22
EXPOSE 8989
RUN apt-get install -y git
RUN git clone https://github.com/shadowsocksr/shadowsocksr.git
RUN cd /shadowsocksr && ./initcfg.sh
RUN echo "python /shadowsocksr/shadowsocks/server.py -p 8989 -k wangjian -m aes-128-cfb -O auth_aes128_md5 -o tls1.2_ticket_auth_compatible -d start" >> run0.sh
RUN echo "python /shadowsocksr/shadowsocks/server.py -p 8989 -k wangjian -m aes-128-cfb -O auth_aes128_md5 -o tls1.2_ticket_auth_compatible" >> run1.sh
CMD python /shadowsocksr/shadowsocks/server.py -p 8989 -k wangjian -m aes-128-cfb -O auth_aes128_md5 -o tls1.2_ticket_auth_compatible -d start; /usr/sbin/sshd -D
