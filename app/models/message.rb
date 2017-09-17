# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  message    :string
#  user_name  :string
#  user_id    :string
#  count      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Message < ApplicationRecord
  validates :message, length: { in: 1..80 }
end
