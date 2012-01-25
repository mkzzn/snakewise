class Comment < ActiveRecord::Base
  belongs_to :commentable
  validates :body, :presence => true
  validates :commentable_type, :presence => true
  validates :commentable_id, :presence => true
end
