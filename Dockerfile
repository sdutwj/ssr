FROM centos:latest
MAINTAINER wangjian
RUN yum -y install openssh-server initscripts
RUN sshd-keygen
RUN echo 'root:wangjian' | chpasswd
EXPOSE 22 
EXPOSE 8989
RUN yum install -y git
RUN git clone https://github.com/shadowsocksr/shadowsocksr.git
RUN cd /shadowsocksr && ./initcfg.sh
RUN echo "python /shadowsocksr/shadowsocks/server.py -p 8989 -k wangjian -m aes-128-cfb -O auth_aes128_md5 -o tls1.2_ticket_auth_compatible -d start" >> run.sh
CMD ["python"," /shadowsocksr/shadowsocks/server.py","-p","8989","-k","wangjian","-m","aes-128-cfb","-O","auth_aes128_md5","-o","tls1.2_ticket_auth_compatible","-d","start"]
CMD ["/usr/sbin/sshd", "-D"]
