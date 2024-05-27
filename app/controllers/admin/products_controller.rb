# frozen_string_literal: true

class Admin::ProductsController < Admin::BaseController
  before_action :find_product, only: %i[edit update purge_image]
  before_action :load_brands, only: %i[edit new create update]
  def index
    @products = Product.all
  end

  def show; end

  def purge_image
    image = @product.images.find_by(id: params[:image_id])
    message = if image.nil?
                t('.image_not_found')
              else
                image.purge
                t('.sucessful_purged')
              end

    @product.images.reload
    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = message }
      format.html { redirect_to admin_products_path, notice: message }
    end
  end

  def new
    @product = Product.new
    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  def update
    @product.title = product_params[:title]
    @product.description = product_params[:description]
    @product.brand_id = product_params[:brand_id]
    @product.price = product_params[:price]
    @product.images.attach(product_params[:images])

    return unless (@product_updated = @product.save)

    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = t('.sucessful_updated') }
      format.html { redirect_to admin_products_path, notice: t('.sucessful_updated') }
    end
  end

  def create
    @product = Product.new(product_params)
    return unless (@product_saved = @product.save)

    @new_product = Product.new
    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = t('.sucessful_created') }
      format.html { redirect_to admin_products_path, notice: t('.sucessful_created') }
    end
  end

  def edit; end

  private

  def find_product
    @product = Product.with_attached_images.find_by(id: params[:id])
  end

  def load_brands
    @brands = Brand.all
  end

  def product_params
    params.require(:product).permit(:title, :brand_id, :description, :price, images: [])
  end
end
