class HomeController < ApplicationController
  def index
  end

  def about
  end

  def contact
  end

  def privacy
  end
  
  def search
    @query = params[:query]
    @employees = Employee.search(@query)
    @stores = Store.search(@query)
    @total_hits = @employees.size + @stores.size
  end

end