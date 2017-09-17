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

class Message < ApplicationRecord
  validates :message, presence: true
  validates :message, length: { in: 1..80, message: 'メッセージは80文字以下にしてください' }
  validates :message, uniqueness: { message: '同じメッセージが既に登録されています' }
  validates :message, format: { with: /\A(?!.*爆発).+\z/, message: '「爆発」が含まれている発言は登録できません' }
end
