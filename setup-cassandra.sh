#!/bin/sh

export OPENSHIFT_DIY_IP=127.0.0.1
#echo $OPENSHIFT_DIY_IP
export CASSANDRA_WORKDIR=$HOME/cassandra-clean
#echo $CASSANDRA_WORKDIR

rm -rf $CASSANDRA_WORKDIR/cassandra*

curl -L http://downloads.datastax.com/community/dsc.tar.gz | tar xz
mv dsc-cassandra-2.0.* cassandra

mkdir cassandra-data
cd cassandra-data
mkdir data
mkdir saved_caches
mkdir commitlog
touch system.log

cd ../cassandra/conf/
sed -ig 's,/var/lib/cassandra,$CASSANDRA_WORKDIR/cassandra-data,' cassandra.yaml
sed -ig 's/127.0.0.1/'$OPENSHIFT_DIY_IP'/g' cassandra.yaml
sed -ig 's/localhost/'$OPENSHIFT_DIY_IP'/g' cassandra.yaml
sed -ig 's,7000,17000,' cassandra.yaml
sed -ig 's,7001,17001,' cassandra.yaml
sed -ig 's,9160,19160,' cassandra.yaml
sed -ig 's/localhost/'$OPENSHIFT_DIY_IP'/g' cassandra.yaml
sed -ig 's,/var/log/cassandra,$CASSANDRA_WORKDIR/cassandra-data,' log4j-server.properties
sed -ig 's,${max_sensible_yg_in_mb}M,256M,' cassandra-env.sh
sed -ig 's,${desired_yg_in_mb}M,256M,' cassandra-env.sh
sed -ig '/jmxremote/s/^/#/' cassandra-env.sh

$CASSANDRA_WORKDIR/cassandra/bin/cassandra -f
#$CASSANDRA_WORKDIR/cassandra/bin/cassandra

