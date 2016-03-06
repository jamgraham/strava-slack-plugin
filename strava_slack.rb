require_relative 'bundle/bundler/setup'
require 'net/https'
require 'json'
require 'iron_cache'
require 'slack-ruby-client'

ENV['IRON_TOKEN']      = ""
ENV['IRON_PROJECT_ID'] = ""
ENV['SLACK_API_TOKEN'] = ""
SLACK_TOKEN            = ""
STRAVA_CLUB_ID         = ""

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
end

url = URI.parse("https://www.strava.com/api/v3/clubs/#{STRAVA_CLUB_ID}/activities")
req = Net::HTTP::Get.new(url.to_s)
req.add_field 'Authorization', "Bearer #{SLACK_TOKEN}"
res = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme == 'https') {|http|
  http.request(req)
}

client = IronCache::Client.new
cache = client.cache("tys_worker_cache")

activities = JSON.parse(res.body)

client = Slack::Web::Client.new
client.auth_test

activities.each do |activity|
  athlete = activity['athlete']['username']
  id = activity['id'].to_s
  cache_id = cache.get(id)

  puts "working #{id}"

  if !cache_id

    activity_url = "https://www.strava.com/api/v3/activities/#{id}"
    activity_req = Net::HTTP::Get.new(activity_url.to_s)
    activity_req.add_field 'Authorization', "Bearer #{SLACK_TOKEN}"
    activity_res = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme == 'https') {|http|
      http.request(req)
    }

    activity_detail = JSON.parse(activity_res.body)[0]
    if activity_detail['type'] == 'Run'
      time = "Pace:  #{Time.at((activity['moving_time']/(activity['distance'] * 0.000621371).round(2))).utc.strftime("%M:%S")}"
    else
      time = "Speed: Max #{activity_detail['max_speed']} mph, Avg: #{activity_detail['average_speed']} mph"
    end

    url = "https://www.strava.com/activities/#{activity_detail['id']}"
    distance_miles = (activity['distance'] * 0.000621371).round(2)
    distance_time = activity['moving_time']/60
    activity_message = "Check out #{activity['athlete']['firstname']}'s #{activity_detail['type']} <#{url}|#{activity['name']}>. Time: #{distance_time} minutes, #{time}"

    cache.put(id, id)

    client.chat_postMessage(channel: '#general', text: activity_message, as_user: false, username: "TYS Strava Bot")

  end

end
