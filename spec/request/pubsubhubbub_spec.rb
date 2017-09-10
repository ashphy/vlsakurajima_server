# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'pubsubhubbub', type: :request do
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
  end
end
