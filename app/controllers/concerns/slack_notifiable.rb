module SlackNotifiable
  extend ActiveSupport::Concern

  private

  def slack
    @slack ||= Slack::Notifier.new(
      ENV['SLACK_WEBHOOK_URL'],
      channel: ENV['SLACK_CHANNEL']
    )
  end
end
