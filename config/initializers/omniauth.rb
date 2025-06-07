Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :twitter, ENV['TWITTER_API_KEY'], ENV['TWITTER_API_SECRET']
  # OAuth 2.0 版を使うなら：
   provider :twitter2, ENV['TWITTER_CLIENT_ID'], ENV['TWITTER_CLIENT_SECRET']
end