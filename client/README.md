# smo-o1
Here we use SDNR as O1 client, following steps will bringup the SDNR through docker-compose.

prerequisite: docker, docker-compose

$ docker-compose up -d

Once the deployment is successful, verify the deployment

```
ubuntu@nodez01b03:~/oran-sc-oam/o1/client$ docker-compose ps
 Name               Command               State                                         Ports
------------------------------------------------------------------------------------------------------------------------------------
sdnr     /bin/sh -c /opt/onap/sdnc/ ...   Up      0.0.0.0:8101->8101/tcp,:::8101->8101/tcp, 0.0.0.0:8181->8181/tcp,:::8181->8181/tcp
sdnrdb   /tini -- /usr/local/bin/do ...   Up      9200/tcp, 9300/tcp
```

SDNR GUI is accessible at http://<host_ip>:8181/odlux/index.html

username/password: admin/Kp8bJ4SXszM0WXlhak3eHlcse2gAw84vaoGGmJvUy2U

Note: password is configurable through .env file
