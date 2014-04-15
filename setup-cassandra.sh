#!/bin/sh

OPENSHIFT_DIY_IP=127.0.0.1
BASEDIR=$(dirname .)
CASSANDRA_BASEDIR=$BASEDIR
CASSANDRA_DATADIR=$CASSANDRA_BASEDIR/cassandra-data

rm -rf $CASSANDRA_BASEDIR/cassandra*


mkdir $CASSANDRA_DATADIR
mkdir $CASSANDRA_DATADIR/data
mkdir $CASSANDRA_DATADIR/saved_caches
mkdir $CASSANDRA_DATADIR/commitlog
touch $CASSANDRA_DATADIR/system.log

curl -L http://downloads.datastax.com/community/dsc.tar.gz | tar xz
mv dsc-cassandra-2.0.* cassandra

cd cassandra/conf/
sed -ig 's,/var/lib/cassandra,$CASSANDRA_DATADIR,' cassandra.yaml
sed -ig 's/127.0.0.1/'$OPENSHIFT_DIY_IP'/g' cassandra.yaml
sed -ig 's/localhost/'$OPENSHIFT_DIY_IP'/g' cassandra.yaml
sed -ig 's,7000,17000,' cassandra.yaml
sed -ig 's,7001,17001,' cassandra.yaml
sed -ig 's,9160,19160,' cassandra.yaml
sed -ig 's/localhost/'$OPENSHIFT_DIY_IP'/g' cassandra.yaml
sed -ig 's,/var/log/cassandra,$CASSANDRA_DATADIR,' log4j-server.properties
sed -ig 's,${max_sensible_yg_in_mb}M,256M,' cassandra-env.sh
sed -ig 's,${desired_yg_in_mb}M,256M,' cassandra-env.sh
sed -ig '/jmxremote/s/^/#/' cassandra-env.sh

cd ../../
echo "run ( sh cassandra/bin/cassandra -f ) to start"
#sh cassandra/bin/cassandra -f
#sleep 2
#echo "auto deleting cassandra on exit"
#rm -rf $CASSANDRA_BASEDIR/cassandra*

