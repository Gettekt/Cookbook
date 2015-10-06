class HomepagesController < ApplicationController
 require 'open-uri'
 before_action :require_user, only: [:homepage,:search]
 
 def homepage
   @user ||= User.find(session[:user_id]) if session[:user_id]
   render :homepage
 end
 def search
     query = params["query"].downcase.strip.gsub(" ", "%20")
     app_id = "6a884e5c"
     app_key = "9d871bcdbaed8221c46499cdd13f6cf5"
     search_path = "https://api.edamam.com/search?q=#{query}&app_id=#{app_id}&app_key=#{app_key}"


     @current_user ||= User.find(session[:user_id]) if session[:user_id]
     @current_user.allergens.each do |allergen|
       search_path += ("&health=" + allergen.name.downcase + "-free")
     end

     JSON.load(open(search_path))
     binding.pry
 end
end