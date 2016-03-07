# Strava -> Slack

![](https://files.slack.com/files-pri/T0MRER3HR-F0QNECWMB/screen_shot_2016-03-06_at_2.46.35_pm.png?pub_secret=345fa096a7)

## About
Pop your keys into the variables below. This script is setup to pull all the athletes attached to Strava Club and post their results into your team's chat room.

## Notes
This script uses's Iron.io as a cron job process. If you want to switch out how you run the script you'll need to switch out the cache too. 

## Keys
```
ENV['IRON_TOKEN']      = ""
ENV['IRON_PROJECT_ID'] = ""
ENV['SLACK_API_TOKEN'] = ""
SLACK_TOKEN            = ""
STRAVA_CLUB_ID         = ""
```

## Run

```
ruby ./strava_slack.rb
```
