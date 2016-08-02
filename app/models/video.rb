class Video < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  index_name ["myflix", Rails.env].join('_')

  belongs_to :category
  has_many :reviews, -> { order "created_at desc" }
  has_many :queue_items
  validates_presence_of :title, :description

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  def rating
    avg = reviews.inject(0.0){ |sum, review| sum + review.rating} / reviews.count
    avg.round 1
  end

  def self.search_by_title(title)
    return [] if title.blank?
    where("title LIKE ?", "%#{title}%").order("created_at DESC")
  end

  def self.search(query, options={})
    search_definition = {
      query: {
        multi_match: {
          query: query,
          fields: ["title^100", "description^50"],
          operator: 'and'
        }
      }
    }
    if query.present? and options[:reviews].present?
      search_definition[:query][:multi_match][:fields] << "reviews.body"
    end

    if options[:rating_from].present? or options[:rating_to].present?
      search_definition[:filter] = {
        range: {
          rating: {
            gte: (options[:rating_from] if options[:rating_from].present?),
            lte: (options[:rating_to] if options[:rating_to].present?)
          }
        }
      }
    end
    __elasticsearch__.search(search_definition)
  end

  def as_indexed_json(options={})
    as_json(
      methods: [:rating],
      only: [:title, :description],
      include: {
        reviews: {
          only: [:body]
        }
      }
    )
  end
end
