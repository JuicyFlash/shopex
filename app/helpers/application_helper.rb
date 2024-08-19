module ApplicationHelper
  include Pagy::Frontend

  def format_price(price)
    "#{price} ₽"
  end

  def nav_cart_price(cart)
    format_price(cart.total)
  end

  def nav_cart_products(cart)
    "#{t('helpers.nav_cart_products')}: #{cart.products_count}"
  end

  def current_params
    @current_params ||= {}
  end

  def current_params2
    @current_params2 ||= {}
  end

  def current_params_brands
    current_params[:brands] ||= []
  end

  def current_params_properties
    current_params[:properties] ||= {}
  end

  def current_params_properties_values(property)
    current_params_properties[property] ||= []
  end

  def make_params_for_brand(brand_id)
    if current_params_brands.include?(brand_id.to_s)
      current_params.except(:brands).merge(brands: current_params_brands - [brand_id.to_s])
    else
      current_params.except(:brands).merge(brands: current_params_brands + [brand_id])
    end
  end

  def make_params_for_property(property_id, value_id)
    if current_params_properties_values(property_id.to_s).include?(value_id.to_s)
      current_params.except(:properties).merge( {properties: current_params_properties.except(property_id.to_s).merge({ property_id =>  current_params_properties_values(property_id.to_s) - [value_id.to_s] } )})
    else
      current_params.except(:properties).merge( {properties: current_params_properties.except(property_id.to_s).merge({ property_id =>  current_params_properties_values(property_id.to_s) + [value_id] }) })
    end
  end
end
