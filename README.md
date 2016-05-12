# Docker container based on alpine

* Image size for web server  ~181MB
* Image size for mysql server ~80MB


## Usage example

* Prepare files

**this does not work with latest versions it neeeds to run composer install**

```bash

git clone --branch 8.1.x --single-branch https://git.drupal.org/project/drupal.git .
git tag #see what is latest tag e.g 8.1.1
git checkout -b drupal-site 8.1.1

```
_Note_ the `.` after git clone it tells to clone in current folder not in drupal

`--single-branch` clones history only for this branch

	If you don't plan to update core with git use instead:

```bash

git clone --branch 8.1.1 --depth 1 https://git.drupal.org/project/drupal.git .

```

This clones just 8.1.1 tag

Also it is good to change remote to something telling just in case

```bash

git remote rename orign drupal
git remote -v

```

* create images

```bash

docker build --tag=websrv .
docker pull imega/mysql

```

* run MySQL container

```bash

docker run -d --name "mysqlsrv" -v /tmp/empty/db:/var/lib/mysql imega/mysql

```

* run Web Server container

```bash

docker run -d --name "drupal" --link mysqlsrv:mysqlsrv -p 8080:80 -v ~/workspace/drupal-site:/workspace/public_html -t websrv

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

 - [ ] Using drush and drupal console to install and manage modules
 - [ ] Add more thorough documentation
 - [x] guest /workspace/public_html doest not receive proper owner:group
 - [x] apache2 mod_rewrite does not get enabled

