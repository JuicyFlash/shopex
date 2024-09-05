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
  ProductProperty.destroy_all
  PropertyValue.destroy_all
  Property.destroy_all
  Product.destroy_all
  Brand.destroy_all
  ActiveStorage::Attachment.all.each { |attachment| attachment.purge }
  FileUtils.rm_rf("#{Rails.root}/storage/")
end

def load_data
  destroy_data
  @properties = { 'Материал ремешка' => { values: %w[Кожа Сталь Золото Силикон Платина Керамика Титан] },
                  'Для кого' => { values: %w[Мужчина Женщина] },
                  'Материал корпуса' => { values: %w[Сталь Золото Платина Пластик Титан] },
                  'Водонепроницаемость' => { unique: true,
                                            values: %w[Да Нет] },
                  'Для шейхов' => { unique: true,
                                   values: %w[Да Нет] },
                  'Назаначение' => { values: %w[Повседневные Спорт Плавание] },
  }
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
      images: ['rolex_oyster_erpetual.webp'],
      properties: {
        'Материал ремешка' => %w[Сталь Золото],
        'Для кого' => %w[Мужчина Женщина],
        'Материал корпуса' => %w[Сталь Золото],
        'Водонепроницаемость' => %w[Да],
        'Для шейхов'  => %w[Нет],
        'Назаначение' => %w[Повседневные]
      }
    },
    { brand: 'Rolex',
      title: 'Datejust Black Roman',
      description: 'Швейцарские часы Rolex Datejust Black Roman Dial 116334',
      price: '878850.0',
      images: %w[black_roman1.jpg black_roman2.jpg],
      properties: {
        'Материал ремешка' => %w[Сталь],
        'Для кого' => %w[Мужчина],
        'Материал корпуса' => %w[Сталь Золото],
        'Водонепроницаемость' => %w[Да],
        'Для шейхов'  => %w[Нет],
        'Назаначение' => %w[Повседневные]
      }
    },
    { brand: 'Patek Philippe',
      title: 'Calatrava Platinum',
      description: 'Швейцарские часы PATEK PHILIPPE Calatrava Platinum 5196P-001',
      price: '3954825.0',
      images: %w[calatrava1.png calatrava2.png calatrava3.jpg],
      properties: {
        'Материал ремешка' => %w[Кожа Золото],
        'Для кого' => %w[Мужчина Женщина],
        'Материал корпуса' => %w[Золото Платина],
        'Водонепроницаемость' => %w[Да],
        'Для шейхов'  => %w[Да],
        'Назаначение' => %w[Повседневные]
      }
    },
    { brand: 'Patek Philippe',
      title: 'Grand Complications',
      description: 'Швейцарские часы PATEK PHILIPPE Grand Complications 5496P-001',
      price: '4443075.0',
      images: ['grand_complication.jpg'],
      properties: {
        'Материал ремешка' => %w[Золото Кожа],
        'Для кого' => %w[Мужчина Женщина],
        'Материал корпуса' => %w[Золото Платина],
        'Водонепроницаемость' => %w[Да],
        'Для шейхов'  => %w[Да],
        'Назаначение' => %w[Повседневные]
      }
    },
    { brand: 'Panerai',
      title: 'Luminor Power',
      description: 'Швейцарские часы Panerai Luminor Power Reserve PAM00123',
      price: '927675.0',
      images: %w[luminor_power.jpg luminor_power.png],
      properties: {
        'Материал ремешка' => %w[Кожа Золото],
        'Для кого' => %w[Мужчина],
        'Материал корпуса' => %w[Золото],
        'Водонепроницаемость' => %w[Да],
        'Для шейхов'  => %w[Нет],
        'Назаначение' => %w[Повседневные]
      }
    },
    { brand: 'Panerai',
      title: 'Ferrari Granturismo',
      description: 'Швейцарские часы Panerai Ferrari Granturismo Chronograph FER00006',
      price: '1432200.0',
      images: %w[ferrari_gt1.png ferrari_gt2.png],
      properties: {
        'Материал ремешка' => %w[Кожа Золото],
        'Для кого' => %w[Мужчина],
        'Материал корпуса' => %w[Золото],
        'Водонепроницаемость' => %w[Да],
        'Для шейхов'  => %w[Да],
        'Назаначение' => %w[Повседневные]
      }
    },
    { brand: 'Omega',
      title: 'Seamaster Diver 300 M',
      description: 'Швейцарские часы Omega Seamaster Diver 300 M Chrono 2599.80.00',
      price: '224595.0',
      images: ['seamaster.jpg'],
      properties: {
        'Материал ремешка' => %w[Титан],
        'Для кого' => %w[Мужчина],
        'Материал корпуса' => %w[Титан],
        'Водонепроницаемость' => %w[Да],
        'Для шейхов'  => %w[Нет],
        'Назаначение' => %w[Повседневные Спорт]
      }
    },
    { brand: 'Omega',
      title: 'Seamaster Aqua Terra',
      description: 'Швейцарские часы Omega Seamaster Aqua Terra Co-Axial 41mm 220.12.41.21.02.001',
      price: '302715.0',
      images: %w[seamaster_aqua1.png seamaster_aqua2.png],
      properties: {
        'Материал ремешка' => %w[Кожа],
        'Для кого' => %w[Мужчина Женщина],
        'Материал корпуса' => %w[Сталь Золото],
        'Водонепроницаемость' => %w[Да],
        'Для шейхов'  => %w[Нет],
        'Назаначение' => %w[Повседневные]
      }
    },
    { brand: 'Omega',
      title: 'Speedmaster Professional',
      description: 'Швейцарские часы Omega Speedmaster Professional Moonwatch Moonphase 304.33.44.52.01.001',
      price: '927675.0',
      images: %w[speedmaster1.png speedmaster2.png],
      properties: {
        'Материал ремешка' => %w[Кожа Титан],
        'Для кого' => %w[Мужчина],
        'Материал корпуса' => %w[Титан Платина],
        'Водонепроницаемость' => %w[Да],
        'Для шейхов'  => %w[Нет],
        'Назаначение' => %w[Повседневные Спорт]
      }
    },
    { brand: 'Omega',
      title: 'De Ville Prestige',
      description: 'Швейцарские часы Omega De Ville Prestige 424.53.40.20.04.001',
      price: '673785.0',
      images: %w[ville_prestige1.png ville_prestige2.png],
      properties: {
        'Материал ремешка' => %w[Сталь],
        'Для кого' => %w[Мужчина Женщина],
        'Материал корпуса' => %w[Сталь],
        'Водонепроницаемость' => %w[Да],
        'Для шейхов'  => %w[Нет],
        'Назаначение' => %w[Повседневные]
      }
    },
    { brand: 'Omega',
      title: 'De Ville Prestige',
      description: 'Швейцарские часы Omega De Ville Prestige 424.10.40.20.03.004',
      price: '269700.0',
      images: %w[ville_prestige1_4431.png ville_prestige2_4431.png],
      properties: {
        'Материал ремешка' => %w[Кожа],
        'Для кого' => %w[Мужчина Женщина],
        'Материал корпуса' => %w[Сталь],
        'Водонепроницаемость' => %w[Да],
        'Для шейхов'  => %w[Нет],
        'Назаначение' => %w[Повседневные]
      }
    },
    { brand: 'Omega',
      title: 'De Ville Hour',
      description: 'Швейцарские часы Omega De Ville Hour Vision Co-Axial Master 433.53.41.21.13.001',
      price: '1220625.0',
      images: ['ville_hour.webp'],
      properties: {
        'Материал ремешка' => %w[Кожа Золото],
        'Для кого' => %w[Мужчина],
        'Материал корпуса' => %w[Золото],
        'Водонепроницаемость' => %w[Да],
        'Для шейхов'  => %w[Да],
        'Назаначение' => %w[Повседневные]
      }
    },
    { brand: 'Garmin',
      title: 'FENIX 7 Sapphire Solar Titan black',
      description: 'Мультиспортивные часы с GPS-приемником fenix 7 Sapphire Solar справятся с любыми требованиями спортсмена или любителя активного отдыха. Благодаря использованию стекла Power SapphireTM с подзарядкой от солнца и защитой от образования царапин часы работают дольше, позволяя вам использовать продвинутые тренировочные функции, спортивные приложения, датчики для отслеживания параметров здоровья и велнеса и прочее.',
      price: '152000.0',
      images: %w[fenix7-pro-black-1.jpg fenix7-pro-black-2.jpg fenix7-pro-black-3.jpg],
      properties: {
        'Материал ремешка' => %w[Титан],
        'Для кого' => %w[Мужчина],
        'Материал корпуса' => %w[Титан],
        'Водонепроницаемость' => %w[Да],
        'Для шейхов'  => %w[Нет],
        'Назаначение' => %w[Повседневные Спорт]
      }
    },
    { brand: 'Garmin',
      title: 'FENIX 7 Sapphire Solar Titan white',
      description: 'Мультиспортивные часы с GPS-приемником fenix 7 Sapphire Solar справятся с любыми требованиями спортсмена или любителя активного отдыха. Благодаря использованию стекла Power SapphireTM с подзарядкой от солнца и защитой от образования царапин часы работают дольше, позволяя вам использовать продвинутые тренировочные функции, спортивные приложения, датчики для отслеживания параметров здоровья и велнеса и прочее.',
      price: '152000.0',
      images: %w[fenix7-pro-white-1.jpg fenix7-pro-white-2.jpg fenix7-pro-white-3.jpg],
      properties: {
        'Материал ремешка' => %w[Титан],
        'Для кого' => %w[Мужчина],
        'Материал корпуса' => %w[Титан],
        'Водонепроницаемость' => %w[Да],
        'Для шейхов'  => %w[Нет],
        'Назаначение' => %w[Повседневные Спорт]
      }
    },
    { brand: 'Garmin',
      title: 'MARQ ATHLETE (GEN 2)',
      description: 'Эти современные часы-инструмент, созданные для целеустремленных спортсменов, включают великолепный сенсорный дисплей AMOLED. Корпус 46 мм изготовлен из титана Класса 5. Кроме того, часы оснащены черным кольцом вокруг циферблата с DLC-покрытием. Модель характеризуется повышенной прочностью и спортивным дизайном.',
      price: '252000.0',
      images: %w[maraq-athlete-1.jpg maraq-athlete-2.jpg maraq-athlete-3.jpg],
      properties: {
        'Материал ремешка' => %w[Титан],
        'Для кого' => %w[Мужчина],
        'Материал корпуса' => %w[Титан],
        'Водонепроницаемость' => %w[Да],
        'Для шейхов'  => %w[Нет],
        'Назаначение' => %w[Повседневные Спорт Плавание]
      }
    },
    { brand: 'Garmin',
      title: 'Swim 2 black',
      description: 'Garmin Swim – это современные часы для бассейна со встроенным GPS-трекером. Гаджеты с функцией смарт предназначены для профессиональных занятий плаванием. Устройство замеряет и сохраняет дистанции. Для управления часами необходимо установить точное значение длины дорожки бассейна.',
      price: '55000.0',
      images: %w[swim2-black-1.jpg swim2-black-2.jpg swim2-black-3.jpg],
      properties: {
        'Материал ремешка' => %w[Силикон],
        'Для кого' => %w[Мужчина Женщина],
        'Материал корпуса' => %w[Пластик],
        'Водонепроницаемость' => %w[Да],
        'Для шейхов'  => %w[Нет],
        'Назаначение' => %w[Спорт Плавание]
      }
    },
    { brand: 'Garmin',
      title: 'Swim 2 white',
      description: 'Garmin Swim – это современные часы для бассейна со встроенным GPS-трекером. Гаджеты с функцией смарт предназначены для профессиональных занятий плаванием. Устройство замеряет и сохраняет дистанции. Для управления часами необходимо установить точное значение длины дорожки бассейна.',
      price: '55000.0',
      images: %w[swim2-white-1.jpg swim2-white-2.jpg swim2-white-3.jpg],
      properties: {
        'Материал ремешка' => %w[Силикон],
        'Для кого' => %w[Мужчина Женщина],
        'Материал корпуса' => %w[Пластик],
        'Водонепроницаемость' => %w[Да],
        'Для шейхов'  => %w[Нет],
        'Назаначение' => %w[Спорт Плавание]
      }
    },
    { brand: 'Garmin',
      title: 'VIVOMOVE TREND',
      description: 'Garmin Vivomove – это классические часы со встроенным фитнес-трекером из премиум сегмента. Бренду удалось создать идеальный вариант для спортсменов и поклонников лаконичного дизайна. Современные гаджеты с функцией смарт и сенсорным дисплеем.',
      price: '45000.0',
      images: %w[vivomowe-trend-black-1.jpg vivomowe-trend-black-2.jpg vivomowe-trend-black-3.jpg],
      properties: {
        'Материал ремешка' => %w[Кожа],
        'Для кого' => %w[Мужчина],
        'Материал корпуса' => %w[Сталь],
        'Водонепроницаемость' => %w[Да],
        'Для шейхов'  => %w[Нет],
        'Назаначение' => %w[Повседневные]
      }
    },
    { brand: 'Garmin',
      title: 'VIVOMOVE LUXE',
      description: 'Garmin Vivomove – это классические часы со встроенным фитнес-трекером из премиум сегмента. Бренду удалось создать идеальный вариант для спортсменов и поклонников лаконичного дизайна. Современные гаджеты с функцией смарт и сенсорным дисплеем.',
      price: '50000.0',
      images: %w[vivomowe-luxe-1.jpg vivomowe-luxe-2.jpg vivomowe-luxe-3.jpg],
      properties: {
        'Материал ремешка' => %w[Кожа],
        'Для кого' => %w[Мужчина],
        'Материал корпуса' => %w[Сталь],
        'Водонепроницаемость' => %w[Да],
        'Для шейхов'  => %w[Нет],
        'Назаначение' => %w[Повседневные]
      }
    },
    { brand: 'Garmin',
      title: 'QUATIX 7 Sapphire',
      description: 'Морские часы с функцией смарт – это «умные» устройства для подключения разных устройств на борту судна. Модели из премиум коллекции позволяют отслеживать скорость движения водного транспорта, глубину, температуру воздуха, скорость ветра.',
      price: '180000.0',
      images: %w[quatix-blue-1.jpg quatix-blue-2.jpg quatix-blue-3.jpg],
      properties: {
        'Материал ремешка' => %w[Силикон],
        'Для кого' => %w[Мужчина],
        'Материал корпуса' => %w[Титан],
        'Водонепроницаемость' => %w[Да],
        'Для шейхов'  => %w[Нет],
        'Назаначение' => %w[Повседневные Спорт Плавание]
      }
    },
    { brand: 'Garmin',
      title: 'VENU 3',
      description: 'Venu – это современные гаджеты Гармин с GPS-треккером. Популярные спортивные часы с функцией смарт станут идеальным дополнением вашего образа. Независимо от того, наденете вы спортивный костюм или строгую рубашку, Venu смотрятся стильно.',
      price: '65000.0',
      images: %w[venu3-1.jpg venu3-2.jpg venu3-3.jpg],
      properties: {
        'Материал ремешка' => %w[Кожа],
        'Для кого' => %w[Женщина],
        'Материал корпуса' => %w[Сталь],
        'Водонепроницаемость' => %w[Да],
        'Для шейхов'  => %w[Нет],
        'Назаначение' => %w[Повседневные]
      }
    }
  ]
  load_brands
  load_properties
  load_products
end

def load_properties
  @properties.each_pair do | property_name, params|
    property = Property.create(name: property_name, unique: !params[:unique].nil?)
    params[:values].each do |value|
      property.property_values.create(value: value)
    end
  end
end

def load_brands
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
    product[:properties].each_pair do |p_property, p_values|
      property = Property.find_by(name: p_property)
      p_values.each do |p_val|
        value = property.property_values.find_by(value: p_val)
        ProductProperty.create(product_id: @product.id, property_id: property.id, property_value_id: value.id)
      end
    end
  end
end
load_data
