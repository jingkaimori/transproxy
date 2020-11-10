#!/usr/bin/sh

#此处为nginx配置文件目录
#注意：此脚本必须有权限来修改该目录下内容
nginxdir="$HOME/debug/nginx";
#请在此处填入你的反代站点的域名
website="example.org"
#镜像站的acme.sh配置
authmethod="--dns dns_ali"
helpmsg=
locale="en"

updatelink () {
  #test ! -e $2
  #echo $?
  #test -L $2
  #echo $?
  if [ ! -e $2 -o -L $2 ]; then
    rm $2
  fi;
  ln -s "$1" "$2";
}

while getopts 'n::w::a?l::h' opt; do
    #echo $opt $OPTARG;
    case $opt in
      (a)   authmethod=$OPTARG;;
      (h)   helpmsg=1;;
      (l)   locale=$OPTARG;;
      (n)   nginxdir=$OPTARG;;
      (w)   website=$OPTARG;;
      (:)   # "optional arguments" (missing option-argument handling)
            case $OPTARG in
              (a) exit 1;; # error, according to our syntax
              (l) :;;      # acceptable but does nothing
            esac;;
    esac
done

if [ $helpmsg ]; then
  if [ [!$authmethod] -a ["--dns dns_ali"!=$authmethod] ]; then
    $PWD/acme.sh/acme.sh --help $authmethod;
  else
    case $locale in
      ("zh"|"zh-CN")  cat ./doc/bash/zh-CN.txt;;
      (*)             cat ./doc/bash/en-US.txt;;
    esac
  fi
  exit 0;
fi

#将文件提取至nginx配置目录中
if [ -w $nginxdir ];then 
  cp -ir ./nginx/* ${nginxdir}
else
  echo "Don't have permission to write nginx config , abort."
  exit 1;
fi

#签发证书
#`acme.sh`和本脚本安装于同一目录下，取消acmedir参数，不需要尾随斜杠。
./acme.sh/acme.sh --issue --force \
${authmethod} \
 -d wm.${website}\
 -d *.wp.${website}\
 -d *.ws.${website}\
 -d *.wn.${website}\
 -d *.wb.${website}\
 -d *.wt.${website}\
 -d *.wd.${website}\
 -d *.wq.${website}\
 -d *.wm.${website}\
 -d *.wvoy.${website}\
 -d *.wver.${website} \
 -d *.m.wp.${website}\
 -d *.m.ws.${website}\
 -d *.m.wn.${website}\
 -d *.m.wb.${website}\
 -d *.m.wt.${website}\
 -d *.m.wd.${website}\
 -d *.m.wq.${website}\
 -d *.m.wm.${website}\
 -d *.m.wvoy.${website}\
 -d *.m.wver.${website}\
;

#全局变量`HOME`为执行脚本的用户的主目录

cd ${nginxdir}/ca/wikimedia;
updatelink $HOME/.acme.sh/wm.${website}/wm.${website}.key $PWD/rsa.key;
updatelink $HOME/.acme.sh/wm.${website}/wm.${website}.cer $PWD/cert.crt;

#启用配置文件
if [ ! -d ${nginxdir}/sites-enabled ]; then
  mkdir -p ${nginxdir}/sites-enabled;
fi
updatelink ${nginxdir}/sites-available/wikipedia.conf ${nginxdir}/sites-enabled/wikipedia.conf

#载入配置，启动镜像站
sudo systemctl stop nginx.service;
sudo systemctl start nginx.service;
sudo -k ;
