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

    set_property :field_weights => {
      :title => 5,
      :body    => 2,
      :teaser => 1
    }
  end

  def author_name
    user.full_name rescue nil
  end

  def created_date
    created_at.strftime("%Y-%m-%d") rescue nil
  end

  def published_state
    published ? "Published" : "Unpublished"
  end
end
