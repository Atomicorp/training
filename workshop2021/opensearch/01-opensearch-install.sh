#!/bin/sh


if [ ! "$UID" ]; then
        UID=`id -u`
fi

if [ "$UID" -ne "$ROOT_UID" ] ; then
        echo "ERROR: You must be root to run this program."
        exit 1
fi


if [ ! -d /usr/share/OpenSearch ]; then
	echo "ERROR: opensearch not installed. Exiting..."
	exit 1
fi

if  [ ! -f opensearch-dashboards-1.1.0-linux-x64.tar.gz ] ; then
        curl https://artifacts.opensearch.org/releases/bundle/opensearch-dashboards/1.1.0/opensearch-dashboards-1.1.0-linux-x64.tar.gz -o opensearch-dashboards-1.1.0-linux-x64.tar.gz

fi

tar xf opensearch-dashboards-1.1.0-linux-x64.tar.gz
mkdir -p /usr/share/OpenSearch-Dashboards
mv opensearch-dashboards-1.1.0/* /usr/share/OpenSearch-Dashboards/
pushd /usr/share/OpenSearch-Dashboards
	# TODO: modify config/opensearch_dashboards.yml to server.host 0.0.0.0
	chown -R opensearch.opensearch /usr/share/OpenSearch-Dashboards
	# TODO: turn this into a service file
	su -s /bin/bash opensearch -c "/usr/share/OpenSearch-Dashboards/bin/opensearch-dashboards"
popd

# Echos
# connect to http://192.168.100.208:5601/
# admin / admin
# Add data -> global
# Hamburger 
