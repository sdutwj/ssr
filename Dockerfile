FROM kinogmt/centos-ssh
MAINTAINER wangjian
EXPOSE 8989
RUN yum install -y git && git clone https://github.com/shadowsocksr/shadowsocksr.git && bash ~/shadowsocksr/shadowsocks/initcfg.sh
RUM echo "python ~/shadowsocksr/shadowsocks/server.py -p 8989 -k wangjian -m aes-128-cfb -O auth_aes128_md5 -o tls1.2_ticket_auth_compatible -d start" >> ~/run.sh
ENTRYPOINT ["~/run.sh"]
Source Repository
  jianjian1012/ssr
