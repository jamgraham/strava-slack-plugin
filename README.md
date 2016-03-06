# Strava -> Slack

## About
Pop your keys into the variables below. This script is setup to pull all the atheletes attached to Strava Club and post their results into your team's chat room.

## Notes
This script uses's Iron.io as a chron job process. If you want to switch out how you run the script you'll need to switch out the cache too. 

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

## Examples:
