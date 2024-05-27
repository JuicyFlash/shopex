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
  CartProduct.destroy_all
  OrderProduct.destroy_all
  OrderDetail.destroy_all
  Cart.destroy_all
  Order.destroy_all
  Brand.destroy_all
  Product.destroy_all
  ActiveStorage::Attachment.all.each { |attachment| attachment.purge }
  FileUtils.rm_rf("#{Rails.root}/storage/")
end

def load_data
  destroy_data
  @brands = [
    { title: 'Rolex' },
    { title: 'Patek Philippe' },
    { title: 'Omega' },
    { title: 'Tissot' },
    { title: 'Panerai' },
    { title: 'Garmin' }
  ]
  @products = [
    { brand: 'Rolex',
      title: 'Oyster Perpetual',
      description: 'Швейцарские часы Rolex Oyster Perpetual 41 124300',
      price: '878850.0',
      images: ['rolex_oyster_erpetual.webp'] },
    { brand: 'Rolex',
      title: 'Datejust Black Roman',
      description: 'Швейцарские часы Rolex Datejust Black Roman Dial 116334',
      price: '878850.0',
      images: ['black_roman1.jpg', 'black_roman2.jpg'] },
    { brand: 'Patek Philippe',
      title: 'Calatrava Platinum',
      description: 'Швейцарские часы PATEK PHILIPPE Calatrava Platinum 5196P-001',
      price: '3954825.0',
      images: ['calatrava1.png', 'calatrava2.png', 'calatrava3.jpg'] },
    { brand: 'Patek Philippe',
      title: 'Grand Complications',
      description: 'Швейцарские часы PATEK PHILIPPE Grand Complications 5496P-001',
      price: '4443075.0',
      images: ['grand_complication.jpg'] },
    { brand: 'Panerai',
      title: 'Luminor Power',
      description: 'Швейцарские часы Panerai Luminor Power Reserve PAM00123',
      price: '927675.0',
      images: ['luminor_power.jpg', 'luminor_power.png'] },
    { brand: 'Panerai',
      title: 'Ferrari Granturismo',
      description: 'Швейцарские часы Panerai Ferrari Granturismo Chronograph FER00006',
      price: '1432200.0',
      images: ['ferrari_gt1.png', 'ferrari_gt2.png'] },
    { brand: 'Omega',
      title: 'Seamaster Diver 300 M',
      description: 'Швейцарские часы Omega Seamaster Diver 300 M Chrono 2599.80.00',
      price: '224595.0',
      images: ['seamaster.jpg'] },
    { brand: 'Omega',
      title: 'Seamaster Aqua Terra',
      description: 'Швейцарские часы Omega Seamaster Aqua Terra Co-Axial 41mm 220.12.41.21.02.001',
      price: '302715.0',
      images: ['seamaster_aqua1.png', 'seamaster_aqua2.png'] },
    { brand: 'Omega',
      title: 'Speedmaster Professional',
      description: 'Швейцарские часы Omega Speedmaster Professional Moonwatch Moonphase 304.33.44.52.01.001',
      price: '927675.0',
      images: ['speedmaster1.png', 'speedmaster2.png'] },
    { brand: 'Omega',
      title: 'De Ville Prestige',
      description: 'Швейцарские часы Omega De Ville Prestige 424.53.40.20.04.001',
      price: '673785.0',
      images: ['ville_prestige1.png', 'ville_prestige2.png'] },
    { brand: 'Omega',
      title: 'De Ville Prestige',
      description: 'Швейцарские часы Omega De Ville Prestige 424.10.40.20.03.004',
      price: '269700.0',
      images: ['ville_prestige1_4431.png', 'ville_prestige2_4431.png'] },
    { brand: 'Omega',
      title: 'De Ville Hour',
      description: 'Швейцарские часы Omega De Ville Hour Vision Co-Axial Master 433.53.41.21.13.001',
      price: '1220625.0',
      images: ['ville_hour.webp'] }
  ]
  load_brands
  load_products
end

def load_brands
  Brand.delete_all
  @brands.each do |brand|
    Brand.new(brand).save
  end
end

def load_products
  @products.each do |product|
    @brand = Brand.find_by(title: product[:brand])
    @product = @brand.products.create(title: product[:title],
                                      description: product[:description],
                                      price: product[:price])
    product[:images].each do |image|
      @product.images.attach(
        io: File.open(File.join(Rails.root, 'db/seeds/watches_images/', image)),
        filename: image
      )
    end
  end
end
load_data
