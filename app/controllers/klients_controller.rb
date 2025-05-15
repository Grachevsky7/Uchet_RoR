class KlientsController < ApplicationController
  before_action :set_klient, only: %i[show edit update destroy]

  # GET /klients or /klients.json
  def index
    @klients = Klient.all

    # Поиск
    if params[:search].present?
      @klients = @klients.where("name_komp ILIKE ?", "%#{params[:search]}%")
    end

    if params[:contact].present?
      @klients = @klients.where("kontakt_lico ILIKE ?", "%#{params[:contact]}%")
    end

    if params[:email].present?
      @klients = @klients.where("pochta_kl ILIKE ?", "%#{params[:email]}%")
    end

    if params[:phone].present?
      @klients = @klients.where("telef_kl ILIKE ?", "%#{params[:phone]}%")
    end

    # Сортировка
    if params[:sort_by].present? && params[:sort_order].present?
      @klients = @klients.order("#{params[:sort_by]} #{params[:sort_order]}")
    else
      @klients = @klients.order("id ASC") # Сортировка по ID по умолчанию
    end
  end

  # GET /klients/1 or /klients/1.json
  def show
  end

  # GET /klients/new
  def new
    @klient = Klient.new
  end

  # GET /klients/1/edit
  def edit
  end

  # POST /klients or /klients.json
  def create
    @klient = Klient.new(klient_params)

    if @klient.save
      redirect_to @klient, notice: "Новый клиент успешно добавлен."
    else
      render :new
    end
  end

  # PATCH/PUT /klients/1 or /klients/1.json
  def update
    if @klient.update(klient_params)
      redirect_to @klient, notice: "Данные клиента успешно обновлены."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /klients/1 or /klients/1.json
  def destroy
    @klient.destroy!
    redirect_to klients_path, status: :see_other, notice: "Данные клиента успешно удалены."
  end

  private

  # Используем коллбек для поиска клиента
  def set_klient
    @klient = Klient.find(params[:id])
  end

  # Разрешенные параметры
  def klient_params
    params.require(:klient).permit(:name_komp, :kontakt_lico, :telef_kl, :pochta_kl, :adres_kl, :status, :s_delete)
  end
end
