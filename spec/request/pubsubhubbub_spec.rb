# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'pubsubhubbub', type: :request do
  before(:each) do
    allow_any_instance_of(Slack::Notifier).to receive(:ping).and_return(nil)
  end

  describe 'subscribe' do
    subject { get "/pubsubhubbub?#{params.to_query}" }

    let(:challenge) { '9911776146281775990' }
    let(:verify_token) { 'hogehoge' }
    let(:params) do
      {
        'hub.topic' => 'https://blog.ashphy.com/feed/',
        'hub.challenge' => challenge,
        'hub.verify_token' => verify_token,
        'hub.mode' => 'subscribe',
        'hub.lease_seconds' => '432000s'
      }
    end

    it 'can subscribe' do
      subject
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('text/plain')
      expect(response.body).to eq(challenge)
    end

    context 'when invalid token given' do
      let(:verify_token) { 'foobar' }
      it 'can not subscribe' do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'publishing' do
    subject { post '/pubsubhubbub', params: content, headers: headers }

    let(:verify_token) { 'hogehoge' }
    let(:content) { 'content' }
    let(:signature) do
      OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest::SHA1.new,
        verify_token,
        content
      )
    end
    let(:headers) do
      {
        'HTTP_X_HUB_SIGNATURE' => signature
      }
    end

    it 'receive publishing' do
      subject
      expect(response).to have_http_status(:ok)
    end

    context 'when invalid token given' do
      let(:verify_token) { 'foobar' }
      it 'reject publishing' do
        pending('temporary disabled token check')
        subject
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when not signature given' do
      let(:headers) { {} }
      it 'accept publishing' do
        subject
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when jmx notification received' do
      let(:uuid) { '1e429370-86f8-3ae2-b287-dd08d26a482f' }
      let(:content) { file_fixture('jmaxml_publishing_feed.xml').read }
      let(:entry) { file_fixture('43-46_02_03_101202_VFVO51.xml').read }
      let(:expected_message) { "#{message.message} 流向:南東 噴火 2017年01月02日" }
      let!(:message) { create(:message) }

      before(:each) do
        stub_request(
          :get,
          "http://xml.kishou.go.jp/data/#{uuid}.xml"
        ).to_return(body: entry)
      end

      context 'and sakurajima volcano erupts' do
        before(:each) do
          stub_request(
            :post,
            'https://api.twitter.com/1.1/statuses/update.json'
          ).with(
            body: { status: expected_message }
          ).to_return(
            status: 200,
            body: file_fixture('twitter_update_response.json').read
          )
        end

        it 'accept publishing and tweet message' do
          expect { subject }.to change { Entry.count }.from(0).to(1)
          expect(Entry.first.uuid).to eq("urn:uuid:#{uuid}")
          expect(response).to have_http_status(:ok)
        end
      end

      context 'and another volcano erupts' do
        let(:entry) { file_fixture('43-46_01_07_101202_VFVO52.xml').read }

        it 'accept publishing and not tweet' do
          expect { subject }.to change { Entry.count }.from(0).to(1)
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end
end
