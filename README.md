# Dockerized cozy application

For more information about cozy, see [official web site](https://cozy.io) and [official github](https://github.com/cozy)

## Quickstart
```
git clone https://github.com/nanori/docker-cozy
docker-compose up -d
```

## Docker compose example
```
version: '2'
services:
    controller:
        image: nanori/cozy-controller
        build: ./images/cozy-controller
        restart: always
        environment:
            - COUCH_HOST=couchdb
            - COUCH_PORT=5984
            - COUCH_USER=cozyadmin
            - COUCH_PASS=MyStr0ngP@ssworD
        volumes:
            - cozy-conf:/etc/cozy
            - cozy-var:/usr/local/var/cozy/
            - cozy-data:/usr/local/cozy/
        networks:
            - reverseproxy
            - backend
        links:
            - couchdb
  couchdb:
      image: nanori/cozy-couchdb
      build: ./images/cozy-couchdb
      restart: always
      networks:
         - backend
      volumes:
         - couchdb-data:/var/lib/couchdb/

volumes:
  cozy-conf:
    driver: local
  cozy-var:
    driver: local
  cozy-data:
    driver: local
  couchdb-data:
      driver: local

networks:
  backend:
  reverseproxy:
    external:
      name: reverseproxy_default
```


## Thanks:
This is mainly based on the work of [spiroid](https://github.com/spiroid/cozy)

