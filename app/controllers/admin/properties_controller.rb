class Admin::PropertiesController < Admin::BaseController
  before_action :find_property, only: %i[edit update destroy]

  def index
    load_properties
  end

  def create
    @property = Property.new(property_params)
    return unless (@property_saved = @property.save)

    @new_property = Property.new
    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = t('.sucessful_created') }
      format.html { redirect_to admin_properties_path, notice: t('.sucessful_created') }
    end
  end

  def update
    return if @property.nil?

    return unless (@property_updated = @property.update(property_params))

    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = t('.sucessful_updated') }
      format.html { redirect_to admin_products_path, notice: t('.sucessful_updated') }
    end
  end

  def destroy
    @property.destroy

    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = t('.sucessful_deleted') }
      format.html { redirect_to admin_products_path, notice: t('.sucessful_deleted') }
    end
  end

  def edit
  end

  def new
    @property = Property.new
  end

  private

  def find_property
    @property = Property.find_by(id: params[:id])
  end

  def load_properties
    @properties = Property.all
  end

  def property_params
    params.require(:property).permit(:name, :unique, property_values_attributes: %i[id value _destroy])
  end
end
