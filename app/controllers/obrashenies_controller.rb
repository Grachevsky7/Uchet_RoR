class ObrasheniesController < ApplicationController
  before_action :set_obrashenie, only: %i[show edit update destroy]

  # GET /obrashenies or /obrashenies.json
  def index
    @obrashenies = Obrashenie.all

    # Фильтрация
    if params[:search_klient_id].present?
      @obrashenies = @obrashenies.where("klient_id = ?", params[:search_klient_id])
    end
    if params[:search_po_id].present?
      @obrashenies = @obrashenies.where("po_id = ?", params[:search_po_id])
    end
    if params[:search_stat_obr].present?
      @obrashenies = @obrashenies.where("status LIKE ?", "%#{params[:search_stat_obr]}%")
    end
    if params[:search_data_obr].present?
      @obrashenies = @obrashenies.where("data_obr = ?", params[:search_data_obr])
    end
    if params[:search_data_vypoln_obr].present?
      @obrashenies = @obrashenies.where("data_vypoln_obr = ?", params[:search_data_vypoln_obr])
    end
    if params[:search_tema_obr].present?
      @obrashenies = @obrashenies.where("tema_obr ILIKE ?", "%#{params[:search_tema_obr]}%")
    end
    if params[:search_specialist_id].present?
      @obrashenies = @obrashenies.where("specialist_id = ?", params[:search_specialist_id])
    end

    # Сортировка
    allowed_sort_fields = %w[id klient_id po_id status data_obr data_vypoln_obr tema_obr specialist_id dok_vypoln_obr_path]
    
    if params[:sort_by].present? && params[:sort_order].present? && allowed_sort_fields.include?(params[:sort_by])
      @obrashenies = @obrashenies.order("#{params[:sort_by]} #{params[:sort_order]}")
    else
      @obrashenies = @obrashenies.order("id ASC") # По умолчанию сортируем по ID
    end
  end

  # GET /obrashenies/1 or /obrashenies/1.json
  def show
  end

  # GET /obrashenies/new
  def new
    @obrashenie = Obrashenie.new
  end

  # GET /obrashenies/1/edit
  def edit
  end

  # POST /obrashenies or /obrashenies.json
  def create
    @obrashenie = Obrashenie.new(obrashenie_params)

    respond_to do |format|
      if @obrashenie.save
        format.html { redirect_to @obrashenie, notice: "Новое обращение успешно добавлено." }
        format.json { render :show, status: :created, location: @obrashenie }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @obrashenie.errors, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /obrashenies/1 or /obrashenies/1.json
  def update
    respond_to do |format|
      if @obrashenie.update(obrashenie_params)
        format.html { redirect_to @obrashenie, notice: "Данные обращения успешно обновлены." }
        format.json { render :show, status: :ok, location: @obrashenie }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @obrashenie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /obrashenies/1 or /obrashenies/1.json
  def destroy
    @obrashenie.destroy

    respond_to do |format|
      format.html { redirect_to obrashenies_url, notice: "Данные обращения успешно удалены." }
      format.json { head :no_content }
    end
  end

  private

  # Используется для установки обращения перед некоторыми действиями
  def set_obrashenie
    @obrashenie = Obrashenie.find(params[:id])
  end

  # Разрешенные параметры
  def obrashenie_params
    params.require(:obrashenie).permit(:klient_id, :po_id, :specialist_id, :tema_obr, :status_obr, :data_obr, :data_vypoln_obr, :dok_vypoln_obr_path, :status, :s_delete)
  end
end
