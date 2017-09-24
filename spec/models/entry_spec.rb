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

require 'rails_helper'

RSpec.describe Entry, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
