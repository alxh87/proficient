class SupportNumbersController < ApplicationController
  before_action :set_support_number, only: [:show, :edit, :update, :destroy]
  before_action :require_login
  # GET /support_numbers
  def index
    @support_numbers = SupportNumber.all
  end

  # GET /support_numbers/1
  def show
  end

  # GET /support_numbers/new
  def new
    @support_number = SupportNumber.new
  end

  # GET /support_numbers/1/edit
  def edit
  end

  # POST /support_numbers
  def create
    @support_number = SupportNumber.new(support_number_params)

    if @support_number.save
      redirect_to @support_number, notice: 'Support number was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /support_numbers/1
  def update
    if @support_number.update(support_number_params)
      redirect_to @support_number, notice: 'Support number was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /support_numbers/1
  def destroy
    @support_number.destroy
    redirect_to callforward_index_path, notice: 'Support number was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_support_number
      @support_number = SupportNumber.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def support_number_params
      params.require(:support_number).permit(:name, :number)
    end
end
