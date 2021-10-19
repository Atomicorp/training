#!/bin/sh
VERSION=0.1

echo
echo "Opensearch installer version ($VERSION)"
echo

if [ ! "$UID" ]; then
        UID=`id -u`
fi

if [ "$UID" -ne 0 ] ; then
        echo "ERROR: You must be root to run this program."
        exit 1
fi


# Dependencies
setenforce 0
if grep -q Enforcing /etc/selinux/config; then
	sed -i "s/Enforcing/disabled/g" /etc/selinux/config
fi

sysctl -w vm.max_map_count=262144
# TODO: vm.max_map_count=262144 into /etc/sysctl.conf
if ! grep -q vm.max_map_count=262144 /etc/sysctl.conf >/dev/null ; then
	echo vm.max_map_count=262144 >> /etc/sysctl.conf
fi

systemctl stop firewalld
systemctl disable firewalld

# Dependencies
yum -y install tar  java vim net-tools

# Users/Groups
if  ! getent group opensearch > /dev/null 2>&1 ; then
	groupadd -r opensearch
fi

if ! getent passwd opensearch >/dev/null 2>&1 ; then

	useradd \
		--system \
        	--home-dir /nonexisting \
        	--gid opensearch \
                --shell /sbin/nologin \
                --comment "OpenSearch" \
                opensearch
fi


# Directories
DIRS="/usr/share/OpenSearch"
for i in $DIRS; do
	if [ ! -d $i ]; then
		mkdir -p $i
	fi
	chown -R opensearch.opensearch $i
done


# package
if [ ! -f opensearch-1.1.0-linux-x64.tar.gz ]; then
	curl https://artifacts.opensearch.org/releases/bundle/opensearch/1.1.0/opensearch-1.1.0-linux-x64.tar.gz -o opensearch-1.1.0-linux-x64.tar.gz
fi
tar xf opensearch-1.1.0-linux-x64.tar.gz
pushd opensearch-1.1.0
	mv * /usr/share/OpenSearch/
popd
chown -R opensearch.opensearch /usr/share/OpenSearch/ 

# %install
su -s /bin/bash opensearch -c "/usr/share/OpenSearch/opensearch-tar-install.sh -d"  
echo "Bootstrapping, please be patient..."
sleep 120
sed -i "s/^#node.name/node.name/g" /usr/share/OpenSearch/config/opensearch.yml
sed -i "s/^#network.host.*/network.host: 0.0.0.0/g" /usr/share/OpenSearch/config/opensearch.yml
sed -i "s/^#discovery.seed_hosts.*/discovery.seed_hosts: [\"localhost\"]/g" /usr/share/OpenSearch/config/opensearch.yml
kill `ps ax |grep java |egrep -v grep |awk '{print $1}'`

cp systemd/opensearch.service /usr/lib/systemd/system/
systemctl daemon-reload
systemctl start opensearch

