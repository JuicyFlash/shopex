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
    @product_updated = @product.update(product_params.except(:images))
    if @product_updated
      @product.images.attach(product_params[:images])
      respond_to do |format|
        format.turbo_stream { flash.now[:notice] = t('.sucessful_updated') }
        format.html { redirect_to admin_products_path, notice: t('.sucessful_updated') }
      end
    else
      respond_to do |format|
        format.turbo_stream { flash.now[:notice] = t('.wrong_updated') }
        format.html { redirect_to admin_products_path, notice: t('.wrong_updated') }
      end
    end
  end

  def create
    @product = Product.new(product_params)
    @product_saved = @product.save
    if @product_saved
      @new_product = Product.new
      respond_to do |format|
        format.turbo_stream { flash.now[:notice] = t('.sucessful_created') }
        format.html { redirect_to admin_products_path, notice: t('.sucessful_created') }
      end
    else
      respond_to do |format|
        format.turbo_stream { flash.now[:notice] = t('.wrong_created') }
        format.html { redirect_to admin_products_path, notice: t('.wrong_created') }
      end
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
