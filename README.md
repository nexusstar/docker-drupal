# Docker container based on alpine

* Image size for web server  ~181MB
* Image size for mysql server ~80MB


## Usage example

* Prepare files

```bash

git clone --branch 8.0.x https://git.drupal.org/project/drupal.git .
git tag #see what is latest tag e.g 8.0.5
git checkout -b drupal-site 8.0.5

```
Note the `.` after git clone it tells to clone in current folder not in drupal
Also it is good to change remote to something telling just in case

```bash

git remote rename orign drupal
git remote -v

```

* create images

```bash

docker build --tag=drupal
docker pull imega/mysql

```

* run MySQL container

```bash

docker run -d --name "mysqlsrv" -v /tmp/empty/db:/var/lib/mysql imega/mysql

```

* run Web Server container

```bash

docker run -d --name "drupal-site" --link mysqlsrv:mysqlsrv -p 8080:80 -v ~/workspace/drupal-site:/workspace/public_html -t drupal

```

* prepare empty data base

```bash

docker exec -it drupal-site /bin/sh
mysql -h mysqlsrv
create database drupal;
quit;
exit

```

* Install website

First check TODO

Go to http://localhost:8080 and install

## TODO tasks

 - [ ] guest /workspace/public_html doest not recieve proper owner:group
 - [ ] apache2 mod_rewrite does not get enabled


