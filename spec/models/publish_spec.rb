# == Schema Information
#
# Table name: publishes
#
#  id         :integer          not null, primary key
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Publish, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
