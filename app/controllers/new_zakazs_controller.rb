class NewZakazsController < ApplicationController
  before_action :set_new_zakaz, only: %i[show edit update destroy]

  # GET /new_zakazs or /new_zakazs.json
  def index
    @new_zakazs = NewZakaz.all

    # Поиск
    if params[:search_po_id].present?
      @new_zakazs = @new_zakazs.where("po_id = ?", params[:search_po_id])
    end
    if params[:search_klient_id].present?
      @new_zakazs = @new_zakazs.where("klient_id = ?", params[:search_klient_id])
    end
    if params[:search_specialist_id].present?
      @new_zakazs = @new_zakazs.where("specialist_id = ?", params[:search_specialist_id])
    end
    if params[:search_data_zak].present?
      @new_zakazs = @new_zakazs.where("data_zak = ?", params[:search_data_zak])
    end
    if params[:search_stat_zak].present?
      @new_zakazs = @new_zakazs.where("stat_zak LIKE ?", "%#{params[:search_stat_zak]}%")
    end
    if params[:search_data_vypoln_zak].present?
      @new_zakazs = @new_zakazs.where("data_vypoln_zak = ?", params[:search_data_vypoln_zak])
    end

    # Сортировка
    allowed_sort_fields = %w[id po_id klient_id specialist_id data_zak stat_zak data_vypoln_zak stoimost_v_god srok_arendy stoimost_zak]
    
    if params[:sort_by].present? && params[:sort_order].present? && allowed_sort_fields.include?(params[:sort_by])
      @new_zakazs = @new_zakazs.order("#{params[:sort_by]} #{params[:sort_order]}")
    else
      @new_zakazs = @new_zakazs.order("id ASC") # Сортировка по ID по умолчанию
    end
  end

  # GET /new_zakazs/1 or /new_zakazs/1.json
  def show
  end

  # GET /new_zakazs/new
  def new
    @new_zakaz = NewZakaz.new
  end

  # GET /new_zakazs/1/edit
  def edit
  end

  # POST /new_zakazs or /new_zakazs.json
  def create
    @new_zakaz = NewZakaz.new(new_zakaz_params)

    respond_to do |format|
      if @new_zakaz.save
        format.html { redirect_to @new_zakaz, notice: "Новый заказ успешно добавлен." }
        format.json { render :show, status: :created, location: @new_zakaz }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @new_zakaz.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /new_zakazs/1 or /new_zakazs/1.json
  def update
    respond_to do |format|
      if @new_zakaz.update(new_zakaz_params)
        format.html { redirect_to @new_zakaz, notice: "Данные заказа успешно обновлены." }
        format.json { render :show, status: :ok, location: @new_zakaz }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @new_zakaz.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /new_zakazs/1 or /new_zakazs/1.json
  def destroy
    @new_zakaz.destroy

    respond_to do |format|
      format.html { redirect_to new_zakazs_url, notice: "Данные заказа успешно удалены." }
      format.json { head :no_content }
    end
  end

  private

  # Используется для установки заказа перед некоторыми действиями
  def set_new_zakaz
    @new_zakaz = NewZakaz.find(params[:id])
  end

  # Разрешенные параметры
  def new_zakaz_params
    params.require(:new_zakaz).permit(:po_id, :klient_id, :specialist_id, :data_zak, :stat_zak, :data_vypoln_zak, :stoimost_v_god, :srok_arendy, :stoimost_zak, :dok_vypoln_zak_path, :chek_opl_zak_path, :status, :s_delete)
  end
end
