# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Pubsubhubbub', type: :routing do
  it 'GET /pubsubhubbub to Pubsubhubbubs#index' do
    expect(get: '/pubsubhubbub').to route_to(
      controller: 'pubsubhubbubs',
      action: 'show'
    )
  end

  it 'POST /pubsubhubbub to Pubsubhubbubs#index' do
    expect(post: '/pubsubhubbub').to route_to(
      controller: 'pubsubhubbubs',
      action: 'create'
    )
  end
end
