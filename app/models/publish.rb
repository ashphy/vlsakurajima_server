# == Schema Information
#
# Table name: publishes
#
#  id         :integer          not null, primary key
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Publish < ApplicationRecord
end
