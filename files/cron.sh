*/1 * * * *  cd /workspace/htdocs/sites/all/modules/civicrm && /usr/bin/php bin/cli.php  -j -sdefault -u {DRUPAL_MAILUSER} -p {DRUPAL_USER_PASSWORD}  -e Job -a process_mailing
*/15 * * * * /usr/bin/drush --root=/workspace/public_html core-cron --yes
*/15 * * * * /usr/bin/drush -u 1 -r /workspace/htdocs civicrm-api job.execute auth=0 -y
