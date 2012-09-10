class Comment < ActiveRecord::Base
  attr_accessible :anonymous, :code, :content, :line
end
