# frozen_string_literal: true

class Admin::ProductsController < Admin::BaseController
  def index
    @products = Product.all
  end

  def show; end

  def update; end

  def create
    @product = Product.new(product_params)
    @brands = Brand.all
    return unless (@product_saved = @product.save)

    @new_product = Product.new
    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = t('.sucessful_created') }
      format.html { redirect_to admin_products_path, notice: t('.sucessful_created') }
    end
  end

  def new_product
    @product = Product.new
    @brands = Brand.all
    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  private

  def product_params
    params.require(:product).permit(:title, :brand_id, :description, :price, pictures: [])
  end
end
