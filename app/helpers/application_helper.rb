module ApplicationHelper
  def title 
  	base_title = "Sample Application"
  	if @title.nil?
  		base_title
  	else
  		"#{@title} | #{base_title} "
  	end
  end

  def logo
  	image_tag("rails.png", :alt => "Sample App", :class => "round")
  end
end
