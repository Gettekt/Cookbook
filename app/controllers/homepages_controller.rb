class HomepagesController < ApplicationController
 require 'open-uri'
 before_action :require_user, only: [:homepage,:search]

 def homepage
   @user ||= User.find(session[:user_id]) if session[:user_id]
   render :homepage
 end
 def search
   @user ||= User.find(session[:user_id]) if session[:user_id]

     query = params["query"].downcase.strip.gsub(" ", "%20")
     app_id = "6a884e5c"
     app_key = "9d871bcdbaed8221c46499cdd13f6cf5"
     search_path = "https://api.edamam.com/search?q=#{query}&app_id=#{app_id}&app_key=#{app_key}"


     @current_user ||= User.find(session[:user_id]) if session[:user_id]
     @current_user.allergens.each do |allergen|
        if ['peanut','tree-nut','fish','shellfish','dairy','egg','wheat','gluten','soy'].include? allergen.name.downcase
          search_path += ("&health=" + allergen.name.downcase + "-free")
        end
      end

     result = JSON.load(open(search_path))
     @recipes = result["hits"]
     render :homepage
 end
 def newlocalsearch
    render :newlocalsearch
 end
 def conductlocalsearch
    results = []
    Recipe.all.each do |recipe|
      results << recipe
    end 
    Recipe.all.each do |recipe|
      if Levenshtein.distance("#{recipe.name}", "params['query']") > 2 and !recipe.name.include? params['query']
        results.delete(recipe)
      end
      tag_names = []
      recipe.tags.each do |tag|
        tag_names << tag.name
      end
      if params["tags"] != nil
        params["tags"].each do |tag|
          if !tag_names.include? tag and results.include? recipe
            results.delete(recipe)
          end
        end 
      end
      if params["rating"] != nil and recipe.rating.to_i < params["rating"].to_i and results.include? recipe
        results.delete(recipe)
      end
      current_user.allergens.each do |allergen|
        recipe.ingredients.each do |ingredient|
          if (Levenshtein.distance("#{allergen.name}", "#{ingredient.name}") < 2 or ingredient.name.include? allergen.name or allergen.name.include? ingredient.name) and results.include? recipe
            results.delete(recipe)
          end
        end
      end
    end
    @recipes = results
    render :'/recipes/index'
  end

end
