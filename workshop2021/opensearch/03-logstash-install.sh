#!/bin/sh


if  ! getent group logstash > /dev/null 2>&1 ; then
        groupadd -r logstash
fi


if ! getent passwd logstash >/dev/null 2>&1 ; then
	useradd --system --home-dir /nonexisting --gid logstash --shell /sbin/nologin --comment "Logstash OSS" logstash

fi




DIRS="/usr/share/logstash /var/log/logstash /etc/logstash"

for i in $DIRS; do
	if [ ! -d $i ]; then
		mkdir -p $i
	fi
	chown logstash.logstash $i
done

if [ ! -f logstash-oss-with-opensearch-output-plugin-7.13.2-linux-x64.tar.gz ]; then
	curl https://artifacts.opensearch.org/logstash/logstash-oss-with-opensearch-output-plugin-7.13.2-linux-x64.tar.gz -o logstash-oss-with-opensearch-output-plugin-7.13.2-linux-x64.tar.gz
fi

tar xf logstash-oss-with-opensearch-output-plugin-7.13.2-linux-x64.tar.gz
mv logstash-7.13.2/* /usr/share/logstash/

pushd /usr/share/logstash
	./bin/system-install
	./bin/logstash-plugin uninstall logstash-output-opensearch
	./bin/logstash-plugin install logstash-output-opensearch
	chown -R logstash.logstash /usr/share/logstash
popd
cp /usr/share/logstash/config/* /etc/logstash/

# TODO: fix pipelines.yml


# TODO: 

# TODO: fixes

systemctl daemon-reload

