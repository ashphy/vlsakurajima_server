# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Jobs', type: :routing do
it 'POST /jobs to Jobs#create' do
    expect(post: '/jobs').to route_to(
      controller: 'jobs',
      action: 'create'
    )
  end
end
