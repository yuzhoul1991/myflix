module ApplicationHelper
  def options_for_video_reviews(selected=nil)
    options_for_select((1..5).to_a.reverse.map{|r| [pluralize(r, "Star"), r]}, selected)
  end
end
