

#将文件提取至nginx配置目录中
#此处为nginx配置文件目录
#注意：此脚本必须有权限来修改该目录下内容
nginxdir=/etc/nginx
cp -ir ./nginx/* ${nginxdir}

#签发证书
#请在此处填入你的反代站的域名
website=example.org
#并将`\`一行替换为适合
#你的镜像站的认证方式，详见
#<https://github.com/acmesh-official/acme.sh/wiki/How-to-issue-a-cert>
authmethod="--dns dns_ali"
#`acme.sh`安装路径，默认值如下，不需要尾随斜杠。
acmedir=~/.acme.sh
${acmedir}/acme.sh --issue --force \
${authmethod}\
-d wm.${website}\
, *.wp.${website}\
, *.ws.${website}\
, *.wn.${website}\
, *.wb.${website}\
, *.wt.${website}\
, *.wd.${website}\
, *.wq.${website}\
, *.wm.${website}\
, *.wvoy.${website}\
, *.wver.${website} \
, *.m.wp.${website}\
, *.m.ws.${website}\
, *.m.wn.${website}\
, *.m.wb.${website}\
, *.m.wt.${website}\
, *.m.wd.${website}\
, *.m.wq.${website}\
, *.m.wm.${website}\
, *.m.wvoy.${website}\
, *.m.wver.${website}\
;

#此处`~`为执行脚本的用户的主目录
cd ${nginxdir}/ca/wikimedia;
ln -s ~/.acme.sh/wm.${website}/wm.${website}.key ./rsa.key;
ln -s ~/.acme.sh/wm.${website}/wm.${website}.cer ./cert.crt;

#启用配置文件
ln -s ${nginxdir}/sites-avaliable/wikipedia.conf ${nginxdir}/sites-enabled/wikipedia.conf;

#载入配置，启动镜像站
sudo systemctl stop nginx.service;
sudo systemctl start nginx.service;
sudo -k;