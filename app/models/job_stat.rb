# == Schema Information
#
# Table name: job_stats
#
#  id         :integer          not null, primary key
#  since_id   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class JobStat < ApplicationRecord
end
