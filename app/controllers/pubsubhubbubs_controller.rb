# frozen_string_literal: true

# Pubsubhubbub
class PubsubhubbubsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def show
    # 各パラメータの取得
    mode = params['hub.mode']

    # hub.mode チェック
    case mode
    when 'subscribe', 'unsubscribe'
      subscribe
    else
      logger.warn "[PUBSUBHUBBUB] Subscribe rejected by unknown mode #{params.to_json}"
      head :not_found
    end
  end

  def create
    req_body = request.body.read
    signature = request.env['HTTP_X_HUB_SIGNATURE']
    sha1 = OpenSSL::HMAC.hexdigest(
      OpenSSL::Digest::SHA1.new,
      ENV['VERIFY_TOKEN'],
      req_body
    )

    if !signature || signature == sha1
      logger.info "[PUBSUBHUBBUB] Published: #{req_body}"
      Publish.create(content: req_body)
      head :ok
    else
      logger.warn "[PUBSUBHUBBUB] Publish rejected by not matched SIGNATURE: #{signature}"
      request.headers.sort.map { |k, v| logger.warn "HEADER: #{k}:#{v}" }
      head :bad_request
    end
  end

  private

  def subscribe
    mode = params['hub.mode']
    topic = params['hub.topic']
    challenge = params['hub.challenge']
    verify_token = params['hub.verify_token']

    if verify_token == ENV['VERIFY_TOKEN']
      logger.info "[PUBSUBHUBBUB] #{mode} succeeded topic: #{topic}"
      render plain: challenge.chomp, status: 200
    else
      logger.warn "[PUBSUBHUBBUB] #{mode} failed by not matched VERIFY_TOKEN: #{verify_token}"
      head :not_found
    end
  end
end
