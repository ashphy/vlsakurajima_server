# == Schema Information
#
# Table name: messages
#
#  id          :integer          not null, primary key
#  message     :string
#  tweet_id    :string
#  screen_name :string
#  user_id     :string
#  count       :integer          default(0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Message, type: :model do
  describe '#pick' do
    context 'when the message registered' do
      let!(:message1) { create(:message, count: 0) }
      let!(:message2) { create(:message, count: 1) }

      it 'picks from minimum count of messages' do
        expect(Message.pick).to eq(message1)
      end
    end
  end
end
