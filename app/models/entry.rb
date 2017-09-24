# == Schema Information
#
# Table name: entries
#
#  uuid       :string           not null, primary key
#  url        :string
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Entry < ApplicationRecord
  self.primary_key = 'uuid'
end
