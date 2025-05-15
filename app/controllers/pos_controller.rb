class PosController < ApplicationController
  
  before_action :set_po, only: %i[ show edit update destroy ]

  # GET /pos or /pos.json
def index
  @pos = Po.all

  # Обработка поиска
  if params[:search].present?
    @pos = @pos.where("name_po ILIKE ?", "%#{params[:search]}%")
  end

  if params[:release_date].present?
    @pos = @pos.where(data_vypuska_po: params[:release_date])
  end

  # Обработка сортировки
  if params[:sort_by].present? && params[:sort_order].present?
    @pos = @pos.order("#{params[:sort_by]} #{params[:sort_order]}")
  else
    @pos = @pos.order("id ASC") # Сортировка по ID по умолчанию
  end
end


  # GET /pos/1 or /pos/1.json
  def show
  end

  # GET /pos/new
  def new
    @po = Po.new
  end

  # GET /pos/1/edit
  def edit
  end

  # POST /pos or /pos.json
  def create
    @po = Po.new(po_params)

    respond_to do |format|
      if @po.save
        format.html { redirect_to @po, notice: "Новое ПО было успешно добавлено." }
        format.json { render :show, status: :created, location: @po }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @po.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pos/1 or /pos/1.json
  def update
    respond_to do |format|
      if @po.update(po_params)
        format.html { redirect_to @po, notice: "Данные ПО были успешно обновлены." }
        format.json { render :show, status: :ok, location: @po }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @po.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pos/1 or /pos/1.json
def destroy
  @po = Po.find(params[:id])
  @po.destroy

  # Добавляем flash-уведомление
  flash[:notice] = "Данные ПО было успешно удалено."

  respond_to do |format|
    format.html { redirect_to pos_path, notice: flash[:notice] }
    format.json { head :no_content }
  end
end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_po
      @po = Po.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def po_params
      params.require(:po).permit(:name_po, :vers_po, :data_vypuska_po, :stoimost_v_god_po, :status, :s_delete)
    end
end
