class JobsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    options = {}
    options[:since_id] = stat.since_id if stat.since_id.present?
    client.mentions(options).each do |tweet|
      logger.info "[TWITTER] JOBS #{tweet.id}, #{tweet.text}, #{tweet.user.screen_name}, #{tweet.user.id}"

      if tweet.text =~ /^@ashphy_dev[  ]add[  ](.+)/
        message_text = Regexp.last_match(1)
        message = Message.new(
          message: message_text,
          tweet_id: tweet.id,
          user_id: tweet.user.id,
          screen_name: tweet.user.screen_name
        )

        if message.save
          logger.info "[TWITTER] JOBS CREATE MESSAGE ##{message.id}"
          client.create_direct_message(
            tweet.user,
            "メッセージ追加ありがとう！「#{message_text}」を追加したよ。"
          )
        else
          logger.info "[TWITTER] JOBS CREATE FAILED twitter_id: #{tweet.id}, error: #{message.errors[:message].join(' ')}"
          client.create_direct_message(
            tweet.user,
            message.errors[:message].join(' ')
          )
        end

        if stat.since_id.to_i < tweet.id.to_i
          stat.update(since_id: tweet.id)
        end
      end
    end

    head :no_content
  end

  private

  def client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
    end
  end

  def stat
    @stat ||= JobStat.first
  end
end
