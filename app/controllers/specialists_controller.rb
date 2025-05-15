class SpecialistsController < ApplicationController
  before_action :set_specialist, only: %i[show edit update destroy]

  # GET /specialists or /specialists.json
  def index
    @specialists = Specialist.all

    # Поиск
    if params[:search_fio].present?
      @specialists = @specialists.where("fio_spec LIKE ?", "%#{params[:search_fio]}%")
    end
    if params[:search_phone].present?
      @specialists = @specialists.where("telef_spec LIKE ?", "%#{params[:search_phone]}%")
    end
    if params[:search_email].present?
      @specialists = @specialists.where("pochta_spec LIKE ?", "%#{params[:search_email]}%")
    end
    if params[:search_position].present?
      @specialists = @specialists.where("dlzhnst_spec LIKE ?", "%#{params[:search_position]}%")
    end
    if params[:search_status].present?
      @specialists = @specialists.where("status_spec LIKE ?", "%#{params[:search_status]}%")
    end

    # Сортировка
    if params[:sort_by].present? && params[:sort_order].present?
      @specialists = @specialists.order("#{params[:sort_by]} #{params[:sort_order]}")
    else
      @specialists = @specialists.order("id asc") # по умолчанию сортировка по ID по возрастанию
    end
  end

  # GET /specialists/1 or /specialists/1.json
  def show
  end

  # GET /specialists/new
  def new
    @specialist = Specialist.new
  end

  # GET /specialists/1/edit
  def edit
  end

  # POST /specialists or /specialists.json
  def create
    @specialist = Specialist.new(specialist_params)

    respond_to do |format|
      if @specialist.save
        format.html { redirect_to @specialist, notice: "Новый специалист успешно добавлен." }
        format.json { render :show, status: :created, location: @specialist }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @specialist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /specialists/1 or /specialists/1.json
  def update
    respond_to do |format|
      if @specialist.update(specialist_params)
        format.html { redirect_to @specialist, notice: "Данные специалиста успешно обновлены." }
        format.json { render :show, status: :ok, location: @specialist }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @specialist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /specialists/1 or /specialists/1.json
  def destroy
    @specialist.destroy!

    respond_to do |format|
      format.html { redirect_to specialists_path, status: :see_other, notice: "Данные специалиста успешно удалены." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_specialist
      @specialist = Specialist.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def specialist_params
      params.require(:specialist).permit(:fio_spec, :telef_spec, :pochta_spec, :dlzhnst_spec, :status_spec, :status, :s_delete)
    end
end
