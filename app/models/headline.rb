class Headline < ActiveRecord::Base
  mount_uploader :image, HeadlineImageUploader

  belongs_to :user

  validates_presence_of :headline, :allow_blank => false
  validates_presence_of :image, :allow_blank => false

  scope :published, where(:published => true)

  # thinking sphinx index
  define_index do
    indexes headline, :sortable => true
    has user_id, created_at, updated_at
  end

  def author_name
    user.full_name rescue nil
  end

  def display_name
    user.display_name || user.author_name rescue nil
  end

  def created_date
    created_at.strftime("%Y-%m-%d") rescue nil
  end

  def published_state
    published ? "Published" : "Unpublished"
  end
end
