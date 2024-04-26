# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
def destroy_data
  Brand.destroy_all
  Product.destroy_all
end

def load_data
  destroy_data
  load_brands
  load_products
end
def load_brands
  Brand.delete_all
  Brand.new(title:"Cassio").save
  Brand.new(title:"Rolex").save
  Brand.new(title:"Patek Philippe").save
  Brand.new(title:"Rado").save
  Brand.new(title:"Tissot").save
  Brand.new(title:"Garmin").save
end
def load_products
  @brand = Brand.find_by(title: "Tissot")
  @brand.products.new(title: "TISSOT LE LOCLE POWERMATIC 80",
                      description: "Швейцарский автоматический механизм Powermatic 80.111").save
  @brand.products.new(title: "TISSOT V8 Quartz Cronograph",
                      description: "МужскиеК варцевые Нержав").save
  @brand.products.new(title: "TISSOT T048.417.27.057.03 (T0484172705703)",
                      description: "Мужские наручные швейцарские часы").save
  @brand = Brand.find_by(title: "Garmin")
  @brand.products.new(title: "Garmin Instinct 2",
                      description: "Часы").save
  @brand.products.new(title: "Garmin Vivoactive 5",
                      description: "Garmin Vivoative 5 Slate Aluminum Bezel with Black Case and Silicone Band Безель из сланцевого алюминия с черным корпусом").save
  @brand = Brand.find_by(title: "Patek Philippe")
  @brand.products.new(title: "Patek Philippe Calatrava Vintage",
                      description: "Швейцарские часы Patek Philippe Calatrava Vintage").save
end

load_data
