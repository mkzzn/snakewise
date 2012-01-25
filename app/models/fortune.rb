class Fortune < ActiveRecord::Base
  has_many :comments, :as => :attachable, :dependent => :destroy
  belongs_to :user

  validates_presence_of :fortune, :allow_blank => false

  scope :published, where(:published => true)

  # thinking sphinx index
  define_index do
    indexes fortune, :sortable => true
    indexes lucky_numbers
    indexes learn_chinese
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

  def categorized?
    category ? true : false
  end

  def created_date
    created_at.strftime("%Y-%m-%d") rescue nil
  end

  def published_state
    published ? "Published" : "Unpublished"
  end
end
