# Oracle FSFO Database Client on Docker

The following article provides a description of the 12cR1 version of this Dockerfile. The process is pretty similar.

Directory contents when software is included. Download 12cR1 Database Client software from https://edelivery.oracle.com/ 

```
$ tree
.
├── Dockerfile
├── README.md
├── scripts
│   ├── healthcheck.sh
│   └── start.sh
└── software
    ├── linuxamd64_12102_client.zip
    └── put_software_here.txt

$
```
Build:
```
Go to docker directory:

$ cd dockerfiles/database/ol7_121
$ docker build --no-cache -t ol7_121:latest .


```

Run:

```

$ docker run -dit --rm --name ol7_121_con \
--shm-size="1G" \
-e "PRIMARY_HOST=<Primary Database Host IP>" \
-e "PRIMARY_DB_PORT=<DB Port>" \
-e "PRIMARY_DB_SVC=<Primary Database service name>" \
-e "STANDBY_HOST=<Standby Datababe Host IP>" \
-e "STANDBY_DB_PORT=<DB Port>" \
-e "STANDBY_DB_SVC=<Standby Database service name>" \
-e "SYS_PASSWORD=<Sys Password>" \
ol7_121:latest
 
```
    
Check Logs:
```
$ docker logs --follow ol7_121_con
```
