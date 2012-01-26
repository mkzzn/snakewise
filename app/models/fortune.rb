class Fortune < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :fortune, :allow_blank => false

  scope :published, where(:published => true)

  # thinking sphinx index
  define_index do
    indexes fortune, :sortable => true
    indexes lucky_numbers
    indexes learn_chinese
    has user_id, created_at, updated_at
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
