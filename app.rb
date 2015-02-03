require 'twitter'
require 'json'
require 'google_translate'

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
  unescaped_tweet = CGI.unescapeHTML(tweet.text)
  tweet_with_love = unescaped_tweet.gsub(/@/, '❤️')

  from = "de"
  to   = "en"

  translation = GoogleTranslate.new.translate(from, to, tweet_with_love)[0][0][0]
  puts "from: #{tweet_with_love} to: #{translation}"

  client.update(translation)
end
