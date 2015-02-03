require 'twitter'
require 'json'
require 'open3'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV['CONSUMER_KEY']
  config.consumer_secret     = ENV['CONSUMER_SECRET']
  config.access_token        = ENV['ACCESS_TOKEN']
  config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
end

last_tweets = client.user_timeline('phoet')
last_tweet  = client.user('idontgiveaphoet').status

last_tweets.select! {|twit| twit.created_at > last_tweet.created_at }.reverse!
last_tweets.each do |tweet|
  clear_tweet = tweet.text.gsub(/@/, '❤️')
  escaped_tweet = URI.escape(clear_tweet)

  from  = "de"
  to    = "en"
  url   = "http://translate.google.com/translate_a/t?client=json&text=#{escaped_tweet}&sl=#{from}&tl=#{to}&multires=1&ssel=0&tsel=0&sc=1"
  agent = "Mozilla/5.0"

  json, _ = Open3.capture2('curl', '-s', '-A', agent, url)
  trans   = JSON.parse(json)['sentences'].map { |sentence| sentence['trans'] }.join(' ')
  puts "from: #{clear_tweet} to: #{trans}"

  client.update(trans)
end
