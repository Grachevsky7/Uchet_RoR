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


  def export_to_excel
    zakazs = filtered_new_zakazs

    p = Axlsx::Package.new
    wb = p.workbook

    # Стили
    title_style  = wb.styles.add_style(sz: 16, b: true, alignment: { horizontal: :center })
    header_style = wb.styles.add_style(bg_color: "F2F2F2", fg_color: "000000", sz: 12, b: true,
                                       alignment: { horizontal: :left }, border: { style: :thin, color: "000000" })
    date_style   = wb.styles.add_style(format_code: "DD.MM.YYYY", alignment: { horizontal: :left }, border: { style: :thin, color: "000000" })
    cell_style   = wb.styles.add_style(alignment: { horizontal: :left }, border: { style: :thin, color: "000000" })

    wb.add_worksheet(name: "Список заказов") do |sheet|
      # Уместить на одну страницу
      sheet.page_setup.fit_to_width  = 1
      sheet.page_setup.fit_to_height = 1

      # Заголовок
      sheet.add_row ["Список заказов в организации"], style: title_style
      sheet.merge_cells("A1:L1")
      sheet.add_row []

      # Шапка с понятными названиями столбцов
      sheet.add_row [
        "Id заказа",
        "Наименование ПО",
        "Наименование клиента",
        "ФИО специалиста",
        "Дата заказа",
        "Статус заказа",
        "Дата выполнения заказа",
        "Стоимость ПО в год, ₽",
        "Срок аренды, в годах",
        "Стоимость заказа, ₽"
      ], style: header_style

      # Данные
      zakazs.each do |z|
        sheet.add_row [
          z.id,
          z.po.name_po,
          z.klient.name_komp,
          z.specialist.fio_spec,
          z.data_zak,
          z.stat_zak,
          z.data_vypoln_zak,
          z.stoimost_v_god,
          z.srok_arendy,
          z.stoimost_zak
        ],
        style: [
          cell_style,   # id
          cell_style,   # name_po
          cell_style,   # name_komp
          cell_style,   # fio_spec
          date_style,   # data_zak
          cell_style,   # stat_zak
          date_style,   # data_vypoln_zak
          cell_style,   # stoimost_v_god
          cell_style,   # srok_arendy
          cell_style    # stoimost_zak
        ]
      end

      sheet.column_widths 6, 20, 25, 20, 12, 15, 14, 18, 14, 16
    end

    send_data p.to_stream.read,
              filename: "orders_report.xlsx",
              type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  end

  def export_to_word
    zakazs = filtered_new_zakazs
    if zakazs.empty?
      redirect_to new_zakazs_path, alert: "Нет данных для экспорта."
      return
    end

    html = "\xEF\xBB\xBF"
    html << "<html><head><meta charset='UTF-8'/>"
    html << "<style>
      @page { size: A4 landscape; margin: 0.7cm 1.5cm 0.7cm 0.5cm; }
      body { margin: 0; padding: 0; }
      h1 { font-size: 14pt; margin-bottom: 5px; }
      table { width: 100%; border-collapse: collapse; font-size: 8pt; }
      th, td {
        padding: 2px 3px;
        border: 1px solid #000;
        word-wrap: break-word;
      }
      th { background-color: #f2f2f2; }
    </style>"
    html << "</head><body>"
    html << "<h1>Список заказов в организации</h1>"
    html << "<table>"

    # Шапка
    headers = [
      "Id заказа", "Наименование ПО", "Наименование клиента",
      "ФИО специалиста", "Дата заказа", "Статус заказа",
      "Дата выполнения заказа", "Стоимость ПО в год, ₽",
      "Срок аренды, в годах", "Стоимость заказа, ₽"
    ]
    html << "<tr>" + headers.map { |h| "<th>#{h}</th>" }.join + "</tr>"

    # Данные
    zakazs.each do |z|
      cells = [
        z.id,
        z.po.name_po,
        z.klient.name_komp,
        z.specialist.fio_spec,
        z.data_zak,
        z.stat_zak,
        z.data_vypoln_zak,
        z.stoimost_v_god,
        z.srok_arendy,
        z.stoimost_zak
      ]
      html << "<tr>" + cells.map { |c| "<td>#{c}</td>" }.join + "</tr>"
    end

    html << "</table></body></html>"

    send_data html,
              filename: "orders_report.doc",
              type: "application/msword",
              disposition: 'attachment'
  end



  private

   def filtered_new_zakazs
      items = NewZakaz.includes(:po, :klient, :specialist).all
      items = items.where("po_id = ?", params[:search_po_id])                   if params[:search_po_id].present?
      items = items.where("klient_id = ?", params[:search_klient_id])           if params[:search_klient_id].present?
      items = items.where("specialist_id = ?", params[:search_specialist_id])   if params[:search_specialist_id].present?
      items = items.where("data_zak = ?", params[:search_data_zak])             if params[:search_data_zak].present?
      items = items.where("stat_zak LIKE ?", "%#{params[:search_stat_zak]}%")    if params[:search_stat_zak].present?
      items = items.where("data_vypoln_zak = ?", params[:search_data_vypoln_zak]) if params[:search_data_vypoln_zak].present?

      allowed = %w[id po_id klient_id specialist_id data_zak stat_zak data_vypoln_zak stoimost_v_god srok_arendy stoimost_zak]
      if params[:sort_by].present? && params[:sort_order].present? && allowed.include?(params[:sort_by])
        items = items.order("#{params[:sort_by]} #{params[:sort_order]}")
      else
        items = items.order("id ASC")
      end

      items
    end

  # Используется для установки заказа перед некоторыми действиями
  def set_new_zakaz
    @new_zakaz = NewZakaz.find(params[:id])
  end

  # Разрешенные параметры
  def new_zakaz_params
    params.require(:new_zakaz).permit(:po_id, :klient_id, :specialist_id, :data_zak, :stat_zak, :data_vypoln_zak, :stoimost_v_god, :srok_arendy, :stoimost_zak, :dok_vypoln_zak_path, :chek_opl_zak_path, :status, :s_delete)
  end
end
