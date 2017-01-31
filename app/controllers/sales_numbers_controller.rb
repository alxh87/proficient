class SalesNumbersController < ApplicationController
  before_action :set_sales_number, only: [:show, :edit, :update, :destroy]
  before_action :require_login

  # GET /sales_numbers
  def index
    @sales_numbers = SalesNumber.all
  end

  # GET /sales_numbers/1
  def show
  end

  # GET /sales_numbers/new
  def new
    @sales_number = SalesNumber.new
  end

  # GET /sales_numbers/1/edit
  def edit
  end

  # POST /sales_numbers
  def create
    @sales_number = SalesNumber.new(sales_number_params)

    if @sales_number.save
      redirect_to @sales_number, notice: 'Sales number was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /sales_numbers/1
  def update
    if @sales_number.update(sales_number_params)
      redirect_to @sales_number, notice: 'Sales number was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /sales_numbers/1
  def destroy
    @sales_number.destroy
    redirect_to callforward_index_path, notice: 'Sales number was successfully deleted.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sales_number
      @sales_number = SalesNumber.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def sales_number_params
      params.require(:sales_number).permit(:name, :number)
    end
end
