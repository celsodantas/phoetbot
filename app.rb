require 'twitter'
require 'byebug'
require 'json'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV['CONSUMER_KEY']
  config.consumer_secret     = ENV['CONSUMER_SECRET']
  config.access_token        = ENV['ACCESS_TOKEN']
  config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
end

last_tweets = client.user_timeline('celsodantas')
last_tweet  = client.user('phoet_engrish').status

# temp_last = Time.parse('2015-02-02 00:51:10 +0000')
last_tweets.select! {|twit| twit.created_at > last_tweet.created_at }.reverse!
last_tweets.each do |tweet|
  clear_tweet = tweet.text.gsub(/@/, '❤️')
  escaped_tweet = URI.escape(clear_tweet)

  from = "de"
  to   = "en"

  json = `curl -s -A "Mozilla/5.0" "http://translate.google.com/translate_a/t?client=json&text=#{escaped_tweet}&sl=#{from}&tl=#{to}&multires=1&ssel=0&tsel=0&sc=1"`
  trans = JSON.parse(json)['sentences'][0]['trans']
  puts "from: #{clear_tweet} to: #{trans}"

  client.update(trans)
end
