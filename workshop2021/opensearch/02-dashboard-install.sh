#!/bin/sh

VERSION=0.1

if [ ! "$UID" ]; then
        UID=`id -u`
fi

if [ "$UID" -ne 0 ] ; then
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
	if ! grep -q server.host config/opensearch_dashboards.yml ; then
		echo "server.host: 0.0.0.0" >> config/opensearch_dashboards.yml
	fi
	chown -R opensearch.opensearch /usr/share/OpenSearch-Dashboards
popd

cp systemd/opensearch-dashboard.service /usr/lib/systemd/system/
systemctl daemon-reload
systemctl start opensearch-dashboard
