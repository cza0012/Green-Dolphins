# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  content    :text
#  line       :integer
#  code       :text
#  anonymous  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Comment < ActiveRecord::Base
  attr_accessible :anonymous, :code, :content, :line
  
  has_many :usefuls, :as => :usefulable
  
end
