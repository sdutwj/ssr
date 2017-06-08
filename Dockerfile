#FROM ubuntu:14.04
#MAINTAINER wangjian

#RUN apt-get update
#RUN apt-get install -y openssh-server
#RUN mkdir /var/run/sshd
#RUN echo 'root:root' |chpasswd
#RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
#RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
#EXPOSE 22
#EXPOSE 8989
#RUN apt-get install -y git
#RUN git clone https://github.com/shadowsocksr/shadowsocksr.git
#RUN cd /shadowsocksr && ./initcfg.sh
#RUN echo "python /shadowsocksr/shadowsocks/server.py -p 8989 -k wangjian -m aes-128-cfb -O auth_aes128_md5 -o tls1.2_ticket_auth_compatible -d start" >> run0.sh
#RUN echo "python /shadowsocksr/shadowsocks/server.py -p 8989 -k wangjian -m aes-128-cfb -O auth_aes128_md5 -o tls1.2_ticket_auth_compatible" >> run1.sh
#CMD python /shadowsocksr/shadowsocks/server.py -p 8989 -k wangjian -m aes-128-cfb -O auth_aes128_md5 -o tls1.2_ticket_auth_compatible -d start; /usr/sbin/sshd -D
FROM debian:latest

MAINTAINER wangjian


#Download applications
RUN apt-get update \
    && apt-get install -y libsodium-dev python git ca-certificates iptables --no-install-recommends


#Make ssr-mudb
ENV PORT="8989" \
    PASSWORD="wangjian" \
    METHOD="aes-128-cfb" \
    PROTOCOL="auth_aes128_md5" \
    OBFS="tls1.2_ticket_auth"

RUN git clone https://github.com/shadowsocksr/shadowsocksr.git \
    && cd shadowsocksr \
    && bash initcfg.sh \
    && sed -i 's/sspanelv2/mudbjson/' userapiconfig.py \
    && python mujson_mgr.py -a -u MUDB -p ${PORT} -k ${PASSWORD} -m ${METHOD} -O ${PROTOCOL} -o ${OBFS} -G "#"


#Execution environment
COPY rinetd start.sh /root/
RUN chmod a+x /root/rinetd /root/start.sh
WORKDIR /shadowsocksr
ENTRYPOINT ["/root/start.sh"]
CMD /root/start.sh
