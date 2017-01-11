# Docker-Container for FHEM

This is a dockerized FHEM service. See http://www.fhem.de/ for more information.

## Starting the container

Depending on the configuration of your fhem.cfg you usually want to expose tcp port 8083 as the web port.

To make the configuration and logs persistent the volume /opt/fhem is exposed.

```
docker run -d -p 8083:8083 -v /data/fhem:/opt/fhem rockyhb/fhem
```

