# README
## Introducing
* Subscribe RSS from DMHY or BANGUMI.MOE and playable via HLS.

## Set up
### Requirements
* Ruby
* Bundler
* Redis
* FFMPEG
* Transmission

### What it does

### Configuration
* `bundle install`
* Change transmission RPC information in `lib/update_tasks.rb`
* Change transmission RPC information in `lib/perform_slice.rb`
* Change web server hls path information in `lib/update_tasks.rb`
* Set up cron jobs for tasks

### TODO
* Move all configuration into config/environments
* Add Skip option for epsoide
* Add M3U8 link for portable devices' player
* Find someone to do front-end job for me
* Add user and subscribe information
* Add general torrent RSS support
* ...
