module ApplicationHelper
  def full_title page_title = ""
    base_title = page_title.empty? ? "" : "" + page_title + " | "
    base_title << (t "static_pages.home.title")
  end
end
