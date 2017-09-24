# frozen_string_literal: true

# Pubsubhubbub
class PubsubhubbubsController < ApplicationController
  include TwitterAccessible

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

    # if !signature || signature == sha1
    #   logger.info "[PUBSUBHUBBUB] Published: #{req_body}"
    #   Publish.create(content: req_body)
    #   head :ok
    # else
    #   logger.warn "[PUBSUBHUBBUB] Publish rejected by not matched SIGNATURE: #{signature}"
    #   request.headers.sort.map { |k, v| logger.warn "HEADER: #{k}:#{v}" }
    #   head :bad_request
    # end

    doc = REXML::Document.new(req_body)
    doc.get_elements('/feed/entry').each do |entry|
      uuid = entry.elements['id'].text
      title = entry.elements['title'].text
      content = entry.elements['content'].text
      url = entry.elements['link'].attribute('href').value

      if title == '噴火に関する火山観測報'
        unless Entry.exists?(uuid: uuid)
          Entry.create!(
            uuid: uuid,
            url: url,
            content: content
          )
          process_publish(url)
        end
      end
    end

    logger.info "[PUBSUBHUBBUB] Published: #{req_body} with SIGNATURE: #{signature}"
    head :ok
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
      logger.warn "[PUBSUBHUBBUB] #{mode} failed by not matched VERIFY_TOKEN: #{verify_token} to ENV: #{ENV['VERIFY_TOKEN']}"
      head :not_found
    end
  end

  SAKURAJIMA_VOLCANO_CODE = '506'.freeze

  # 51	爆発
  # 52	噴火
  # 53	噴火開始	平成26年12月から運用上使用しない
  # 54	連続噴火継続
  # 55	連続噴火停止
  # 56	噴火多発
  # 61	爆発したもよう
  # 62	噴火したもよう
  # 63	噴火開始したもよう	平成26年12月から運用上使用しない
  # 64	連続噴火が継続しているもよう
  # 65	連続噴火は停止したもよう
  # 70	降灰
  # 71	少量の降灰
  # 72	やや多量の降灰
  # 73	多量の降灰
  # 75	小さな噴石の落下
  # 91	不明
  def process_publish(url)
    response = Faraday.get(url)
    doc = REXML::Document.new(response.body)
    doc.get_elements('/Report/Body').each do |entry|
      volcano_code = entry.elements['VolcanoInfo/Item/Areas/Area/Code'].text
      event_date = entry.elements['VolcanoInfo/Item/EventTime/EventDateTime'].text.to_date
      # kind = entry.elements['VolcanoInfo/Item/Kind/Code'].text
      direction = entry.elements['VolcanoObservation/ColorPlume/jmx_eb:PlumeDirection'].text

      if volcano_code == SAKURAJIMA_VOLCANO_CODE
       client.update(message(direction, event_date))
      end
    end
  end

  def message(direction, date)
    "#{Message.pick.message} 流向:#{direction} 噴火 #{date.strftime('%Y年%m月%d日')}"
  end
end
