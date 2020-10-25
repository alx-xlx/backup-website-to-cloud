# #!/usr/bin/env bash
NAMEDATE=`date +%F_%H-%M_%s`_`whoami` && echo $NAMEDATE
mkdir ~/flarum_backup/$NAMEDATE -m 0755 && echo "Directory Created"
mysqldump -u <DATABASEUSERNAME> -p"<DATABASEPASSWORD>" <DATABASENAME> | gzip > ~/flarum_backup/$NAMEDATE/db.sql.gz && echo "Database Dumped"
tar czf ~/flarum_backup/$NAMEDATE/files.tar.gz ~/<PATH_TO_FLARUM> && echo "Server Files Dumped"
chmod -R 0644 ~/flarum_backup/$NAMEDATE/* && echo "Directory Permission Restored"
/home/<HOSTINGUSERNAME>/flarum_backup/rclone copy ~/flarum_backup/$NAMEDATE "mycloud:Flarum Backup/$NAMEDATE"
cd ~/flarum_backup; find . -type d -mtime +2 -exec rm -rf {} \; 2>&1 && echo "Directory older than 2 days Deleted !!"
exit 0 