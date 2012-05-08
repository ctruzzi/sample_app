class PagesController < ApplicationController
  def home
  	@title = "Home Page"
  end

  def contact
  	@title = "Contact Page"
  end

  def about
  	@title = "About Page"
  end

end
