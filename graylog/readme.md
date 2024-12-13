# Graylog

### Source
- https://www.virtualizationhowto.com/2023/09/graylog-docker-compose-setup-an-open-source-syslog-server-for-home-labs/

## Installation
### Generate GRAYLOG_PASSWORD_SECRET and GRAYLOG_ROOT_PASSWORD_SHA2 and setup in .env file :
-  GRAYLOG_PASSWORD_SECRET : ```pwgen -N 1 -s 96```
-  GRAYLOG_ROOT_PASSWORD_SHA2 : ```echo -n YOURPASSWORD | shasum -a 256```

### Start the stack
- Run command : ```docker compose up -d```
