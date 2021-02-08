#!/bin/bash
# 生成CA证书
cfssl gencert -initca ca-csr.json | cfssljson -bare ca
# 生成server证书
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=www server-csr.json | cfssljson -bare server

# 拷贝证书到对应files目录
ansible_dir=$(pwd |sed 's:ssl/etcd::')
apiserver_cert_dir=${ansible_dir}/roles/master/files/etcd_cert
etcd_cert_dir=${ansible_dir}/roles/etcd/files/etcd_cert

mkdir -p ${apiserver_cert_dir} ${etcd_cert_dir}
for dir in ${apiserver_cert_dir} ${etcd_cert_dir}
do
	cp -rf ca.pem server.pem server-key.pem $dir
done
