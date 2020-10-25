# backup-flarum
 This is a script to push a backup of your Flarum Instance to Cloud Storage using rclone

BUT you can use this even for Wordpress and all other forums

[Click Here] to see the list of Cloud Storages we can upload our Backups to

# Make Sure to Create a Backup of your Server before trying
*2nd last line in script is dangerous if you don't point it to correct directory*

## Screenshots

![backup-flarum-server](images/backup-flarum-server.png)

![backup-flarum-google-drive](images/backup-flarum-google-drive.png)

```sh
# #!/usr/bin/env bash
NAMEDATE=`date +%F_%H-%M_%s`_`whoami` && echo $NAMEDATE
mkdir ~/flarum_backup/$NAMEDATE -m 0755 && echo "Directory Created"
mysqldump -u <DATABASEUSERNAME> -p"<DATABASEPASSWORD>" <DATABASENAME> | gzip > ~/flarum_backup/$NAMEDATE/db.sql.gz && echo "Database Dumped"
tar czf ~/flarum_backup/$NAMEDATE/files.tar.gz ~/<PATH_TO_FLARUM> && echo "Server Files Dumped"
chmod -R 0644 ~/flarum_backup/$NAMEDATE/* && echo "Directory Permission Restored"
/home/<HOSTINGUSERNAME>/flarum_backup/rclone copy ~/flarum_backup/$NAMEDATE "mycloud:Flarum Backup/$NAMEDATE"
cd ~/flarum_backup; find . -type d -mtime +2 -exec rm -rf {} \; 2>&1 && echo "Directory older than 2 days Deleted !!"
exit 0 
```

## Configuration

Create a Directory `flarum_backup` in your server
(e.g /home/HOSTINGUSERNAME/flarum_backup)

Download [rclone](https://rclone.org/downloads/) . (For most it would be rclone Linux x64)

unzip the contents of [rclone-v1.xx.x-linux-amd64.zip]

copy `rclone` [12 Megabytes] file to our `flarum_backup` directory

`<DATABASEUSERNAME>` - database username

`<DATABASEPASSWORD>` - database password

`<DATABASENAME>` - database name

`<HOSTINGUSERNAME>` - run `pwd` in your terminal to get the server username

`<PATH_TO_FLARUM>` - Location of your root flarum (This will even backup vendor dir since it takes less than 50 megabytes)


## Auto Backup

If you have "Cron Jobs" service in your c-panel then 

```
0 0 * * * /bin/bash ~/flarum_backup/update_backup.sh >> /home/learjrbj/flarum_backup/update_log 2>&1;
```

The above cronjob will run the `update_backup.sh` everyday and backup everything to your configured cloud using rclone

*You can also create a python OR nodejs script to automate incase you don't have Cron in your C-PANEL*


## Backup Manually

You can simply open SSH and Run

```sh
bash update_backup.sh
```



## Cons

- once While using google drive in rclone, new "Flarum Backup" folders were being created each time a new upload was made (however I couldn't reproduce it later)

- For few cloud storages, your email and password may float around in the .config/rclone/rclone.conf