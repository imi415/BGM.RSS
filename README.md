# README
## Introducing
* Subscribe RSS from DMHY or BANGUMI.MOE and playable via HLS.

## Set up
### Requirements
* Ruby
* Bundler
* Redis
* FFMPEG
* Nginx
* Transmission(One of Daemon/CLI/Qt/Gtk versions)

### What it does

### Configuration
* Clone or download from github and extract to someplace
* Call `bundle install` from project directory
* Copy `.env.example` to `.env`
* Modify `.env` file to meet your needs
* run `start_server.sh` to start web server
* Configure nginx to be a reverse proxy for anything except `/hls`, `/assets`
* Set up cron jobs for tasks(see below)

### Notice
We use ffmpeg to slice bgms, by default we don't transcode them,
however some subbers just use some *magic* encodings such as HEVC which
do not meet with HLS standards, so a script called `slice_convert.sh` is prepared
and if Non-AVC codec detected, we will transcode by calling this. Modify ffmpeg params if
needed. ~~Enjoy your CPU time!~~

We need *all* torrents downloaded accessible from web(by our nginx), which will be downloaded
by our transmission instance. As we need to update RSS from `bangumi.moe`, which provides torrent
links, cache is needed for making both us and their admins happy.

For scheduled update, we use a simple but efficent way, a.k.a. CRON. Most time it just works well,
but on some device with less RAM and CPU(such as a RaspberryPi), you need to schedule them
yourself to avoid two or more jobs executed together as they will consume *all* resources which will make it inaccessable
or killed by Linux's OOMKiller.  
Basically, this is because rails runner load rails framework and initialize all of them,
I planned to use sidekiq for them. *TODO*

Generally, we only need to call rails' runner and scripts inside `lib` directory,
but it's difficult to provide necessary environment variables without global settings,
so I added another nasty script called `cron_task.sh`, you may call cron jobs from it.
It takes the second parameter as the installation directory, and automatically set variables and paths.  
Example: `*/5 * * * * /path/to/cron_task.sh /path/of/installation perform_slice`
The above cronjob will check if a bgm is downloaded and ready for HLS slicing.  
At least three jobs need to be set, they are `perform_slice` `update_rss` `update_tasks`  
The latter jobs update feeds from BT sites, poll torrent information from transmission and check all the torrents' status.



### TODO
* Move all configuration into config/environments
* Add Skip option for epsoide
* Add M3U8 link for portable devices' player
* Find someone to do front-end job for me
* Add user and subscribe information
* Add general torrent RSS support
* ...
