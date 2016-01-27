# About this Repo

This is Docker image for fast [drupal](https://www.drupal.org)
and is based on oficial Doker [drupal](https://registry.hub.docker.com/_/drupal/).
The diference is that it clones Drupal repository and switches to version provided in 
`DRUPAL_VERSION` and `DRUPAL_RELEASE`.

## 8.0.x branch
Edit `Docerfile` and

Change `DRUPAL_VERSION 7` to `DRUPAL_VERSION 8.0`
Change `DRUPAL_RELEASE 41` to `DRUPAL_RELEASE 2`

See the Hub page for the full readme on how to use the Docker image and for information
regarding contributing and issues.

The full readme for oficial Docker Drupal is generated over in [docker-library/docs](https://github.com/docker-library/docs),
specificially in [docker-library/docs/drupal](https://github.com/docker-library/docs/tree/master/drupal).

