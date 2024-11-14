class Admin::DiscountsController < Admin::BaseController
  before_action :targets, only: %i[new create edit update]
  before_action :find_discount, only: %i[edit update]
  before_action :condition_types, only: %i[new create edit update]
  before_action :condition, only: %i[new create edit update]
  def index
    query = Discount.all
    @pagy, @discounts = pagy(query, items: 15)
  end

  def new
    @discount = Discount.new
    @discount_condition = DiscountCondition.new
    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  def create
    @discount = Discount.new(discount_params)
    @discount_saved = @discount.save
    if @discount_saved
      @new_discount = Discount.new
      @discount_condition = DiscountCondition.new
      respond_to do |format|
        format.turbo_stream { flash.now[:notice] = t('.successful_created') }
        format.html { redirect_to admin_discounts_path, notice: t('.successful_created') }
      end
    else
      respond_to do |format|
        format.turbo_stream { flash.now[:notice] = t('.wrong_created') }
        format.html { redirect_to admin_discounts_path, notice: t('.wrong_created') }
      end
    end
  end

  def edit; end

  def update
    @discount_updated = @discount.update(discount_params)
    if @discount_updated
      respond_to do |format|
        format.turbo_stream { flash.now[:notice] = t('.successful_updated') }
        format.html { redirect_to admin_discounts_path, notice: t('.successful_updated') }
      end
    else
      respond_to do |format|
        format.turbo_stream { flash.now[:notice] = t('.wrong_updated') }
        format.html { redirect_to admin_discounts_path, notice: t('.wrong_updated') }
      end
    end
  end

  private

  def find_discount
    @discount = Discount.find_by(id: params[:id])
  end

  def targets
    @discount_targets = DiscountService.targets.to_a.map{ |a| a.reverse}
  end

  def condition_types
    @condition_types = DiscountService.condition_types.map{ |key,value| [value.description, key]}
  end

  def discount_params
    params.require(:discount).permit(:value, :description, :target, :active, conditions_attributes: %i[id condition_type value _destroy])
  end

  def condition
    @condition = DiscountCondition.new
  end
end
