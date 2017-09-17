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
  pending "add some examples to (or delete) #{__FILE__}"
end
