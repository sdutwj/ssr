service crond start
/usr/sbin/sshd -D
yum update
yum install -y git
cd ~
git clone https://github.com/shadowsocksr/shadowsocksr.git
cd shadowsocksr && ./initcfg.sh
echo "python ~/shadowsocksr/shadowsocks/server.py -p 8989 -k wangjian -m aes-128-cfb -O auth_aes128_md5 -o tls1.2_ticket_auth_compatible -d start" >> ~/run0.sh
echo "python ~/shadowsocksr/shadowsocks/server.py -p 8989 -k wangjian -m aes-128-cfb -O auth_aes128_md5 -o tls1.2_ticket_auth_compatible" >> ~/run1.sh
python ~/shadowsocksr/shadowsocks/server.py -p 8989 -k wangjian -m aes-128-cfb -O auth_aes128_md5 -o tls1.2_ticket_auth_compatible -d start
