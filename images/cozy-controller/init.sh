#!/bin/bash
while ! curl -s $COUCH_HOST:$COUCH_PORT; do sleep 5 && echo "waiting for couchdb"; done

if [ ! -f /etc/cozy/couchdb.login ]; then
	echo "###################################"
	echo "Init couchdb admin user"
	if [[ -z "$COUCH_USER" || -z "$COUCH_PASS" ]]; then
		echo "No couchdb user/password defined"
		exit 10
	fi
	echo $COUCH_USER > /etc/cozy/couchdb.login
	echo $COUCH_PASS >> /etc/cozy/couchdb.login
	chmod 640 /etc/cozy/couchdb.login
	
	curl -X PUT $COUCH_HOST:$COUCH_PORT/_config/admins/$COUCH_USER -d "\"$COUCH_PASS\""
fi

chown -hR cozy /etc/cozy
chown cozy-data-system /etc/cozy/couchdb.login

if [ ! -d /usr/local/cozy/apps/ ]; then
	echo "###################################"
	echo "installing base apps ..."
	cozy-controller & 
	pid=$!

	# Waiting for local controller to be up and running
	while ! curl -s 127.0.0.1:9002; do sleep 5 && echo "waiting for controller"; done


	cozy-monitor install data-system
	cozy-monitor install home
	cozy-monitor install proxy
	for app in calendar contacts photos emails files sync; do
		cozy-monitor install $app
	done
	kill $pid
fi


cozy-controller
