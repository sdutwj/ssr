FROM centos:latest
MAINTAINER wangjian
RUN yum install -y openssh-server openssh-clients
RUN echo 'root:wangjian' | chpasswd
RUN sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN /sbin/service sshd start && /sbin/service sshd stop
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
EXPOSE 8989
RUN yum install -y git
RUN git clone https://github.com/shadowsocksr/shadowsocksr.git
RUN cd ~/shadowsocksr/shadowsocks && ./initcfg.sh
RUN echo "python ~/shadowsocksr/shadowsocks/server.py -p 8989 -k wangjian -m aes-128-cfb -O auth_aes128_md5 -o tls1.2_ticket_auth_compatible -d start" >> ~/run.sh
ENTRYPOINT ["~/run.sh"]
