class SearchService

  def self.get_products_by_params(params)
    prepare_filter_from_params(params)

    Product.by_brands(@filter[:brands]).with_property_values(@filter[:properties_values])
  end

  def self.search_products_with_params(params)
    prepare_filter_from_params(params)
    ids = Product.search @filter[:query], :with=> {:brand_id => @filter[:brands]}, :with_all => {:value_ids => @filter[:properties_values].map{ |v| v.to_i} }

    Product.where(:id => ids)
  end

  def self.search_orders_with_params(params)
    prepare_filter_from_params(params)
    ids = Order.search @filter[:query]

    Order.where(:id => ids)
  end

  private

  def self.prepare_filter_from_params(params)
    @filter ||= {}
    @filter[:query] = params[:query]
    @filter[:brands] = params[:brands] || []
    @filter[:properties] = params[:properties].to_h || {}
    @filter[:properties_values] = []
    @filter[:properties].values.map{ |v| v }.each { |i|  @filter[:properties_values].concat(i) } || []
  end
end
