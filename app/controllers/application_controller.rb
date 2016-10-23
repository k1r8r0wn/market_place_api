class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  include Authenticable

  protected

  def pagination(paginated_array, per_page)
    { pagination: { per_page: per_page.to_i,
                    total_pages: paginated_array.total_pages,
                    total_objects: paginated_array.total_count } 
                  }
  end
end
