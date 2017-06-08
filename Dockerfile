FROM centos:latest
MAINTAINER wangjian
RUN yum install -y openssh-server net-tools
RUN mkdir /var/run/sshd
#set password for root 
RUN echo 'root:wangjian' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
#set history record 
ENV HISTTIMEFORMAT "%F %T  " 
#Fix sshd service:Read from socket failed: Connection reset by peer? 
RUN ssh-keygen -A
#Open 22 port 
EXPOSE 22 
#Auto running sshd service 
CMD ["/usr/sbin/sshd","-D"]
EXPOSE 8989
RUN yum install -y git
RUN git clone https://github.com/shadowsocksr/shadowsocksr.git
RUN cd /shadowsocksr && ./initcfg.sh
RUN echo "python /shadowsocksr/shadowsocks/server.py -p 8989 -k wangjian -m aes-128-cfb -O auth_aes128_md5 -o tls1.2_ticket_auth_compatible -d start" >> run.sh
CMD ["python"," /shadowsocksr/shadowsocks/server.py","-p","8989","-k","wangjian","-m","aes-128-cfb","-O","auth_aes128_md5","-o","tls1.2_ticket_auth_compatible","-d","start"]
