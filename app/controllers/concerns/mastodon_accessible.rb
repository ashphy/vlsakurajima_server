module MastodonAccessible
  extend ActiveSupport::Concern

  private

  def mastodon
    @mastodon ||= Mastodon::REST::Client.new(
      base_url: ENV['MASTODON_URL'],
      bearer_token: ENV['MASTODON_ACCESS_TOKEN']
    )
  end
end
