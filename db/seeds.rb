# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
allergens =  Ingredient.create([{name: 'Peanut'}, {name: 'Dairy'}, {name: 'Egg'}, {name: 'Tree-Nut'}, {name: 'Wheat'}, {name: 'Gluten'}, {name: 'Fish'},{name: 'Shellfish'}])
tags = Tag.create([{name: 'vegetarian'},{name: 'vegan'},{name: 'breakfast'},{name: 'lunch'},{name: 'dinner'},{name: 'dessert'},{name: 'paleo'},{name: 'low-sodium'},{name: 'high-fiber'},{name: 'balanced'},{name: 'low-fat'},{name: 'low-carb'}, {name: 'high-protein'}])


allegerns = [
  'peanut',
  'dairy',
  'egg',
  'tree-nut',
  'wheat',
  'gluten',
  'fish',
  'shellfish'
]

tags = [
  'vegetarian',
  'vegan',
  'paleo',
  'low-sodium',
  'high-fiber',
  'balanced',
  'low-fat',
  'low-carb',
  'high-protein'
]
