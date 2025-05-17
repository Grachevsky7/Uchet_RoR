class ObrasheniesController < ApplicationController
  require 'axlsx'
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

  # GET /obrashenies/export_to_excel
  def export_to_excel
    items = filtered_obrasheniya

    p = Axlsx::Package.new
    wb = p.workbook

    # стили
    title_style  = wb.styles.add_style(sz: 16, b: true, alignment: { horizontal: :center })
    header_style = wb.styles.add_style(bg_color: "F2F2F2", fg_color: "000000", sz: 12, b: true,
                                       alignment: { horizontal: :left }, border: { style: :thin, color: "000000" })
    date_style   = wb.styles.add_style(format_code: "DD.MM.YYYY",
                                       alignment: { horizontal: :left },
                                       border: { style: :thin, color: "000000" })
    cell_style   = wb.styles.add_style(alignment: { horizontal: :left },
                                       border: { style: :thin, color: "000000" })

    wb.add_worksheet(name: "Список обращений") do |sheet|
      # Уместить на 1 страницу
      sheet.page_setup.fit_to_width  = 1
      sheet.page_setup.fit_to_height = 1

      sheet.add_row ["Список обращений в организации"], style: title_style
      sheet.merge_cells("A1:I1")
      sheet.add_row []

      # Заголовки
      sheet.add_row [
        "Id обращения",
        "Наименование ПО",
        "Наименование клиента",
        "ФИО специалиста",
        "Дата обращения",
        "Тема обращения",
        "Статус обращения",
        "Дата выполнения",
        "Документ выполнения"
      ], style: header_style

      # Данные
      items.each do |o|
        sheet.add_row [
          o.id,
          o.po.name_po,
          o.klient.name_komp,
          o.specialist.fio_spec,
          o.data_obr,
          o.tema_obr,
          o.status_obr,
          o.data_vypoln_obr,
          o.dok_vypoln_obr_path
        ], style: [
          cell_style,      # id
          cell_style,      # name_po
          cell_style,      # name_komp
          cell_style,      # fio_spec
          date_style,      # data_obr
          cell_style,      # tema_obr
          cell_style,      # status_obr
          date_style,      # data_vypoln_obr
          cell_style       # dok path
        ]
      end

      # Жёсткие ширины столбцов (пример)
      sheet.column_widths 6, 25, 25, 20, 12, 30, 15, 14, 30
    end

    send_data p.to_stream.read,
              filename: "obrashenies_report.xlsx",
              type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  end

  # GET /obrashenies/export_to_word
  def export_to_word
    items = filtered_obrasheniya
    if items.empty?
      redirect_to obrashenies_path, alert: "Нет данных для экспорта."
      return
    end

    html = "\xEF\xBB\xBF"
    html << "<html><head><meta charset='UTF-8'/>"
    html << "<style>
      @page { size: A4 landscape; margin: 0.7cm 1.5cm 0.7cm 0.5cm; }
      body { margin: 0; padding: 0; }
      h1    { font-size: 14pt; margin-bottom: 5px; }
      table { width: 100%; border-collapse: collapse; font-size: 8pt; }
      th, td {
        padding: 2px 3px;
        border: 1px solid #000;
        word-wrap: break-word;
      }
      th { background-color: #f2f2f2; }
    </style>"
    html << "</head><body>"
    html << "<h1>Список обращений в организации</h1>"
    html << "<table>"

    headers = [
      "Id обращения", "Наименование ПО", "Наименование клиента",
      "ФИО специалиста", "Дата обращения", "Тема обращения",
      "Статус обращения", "Дата выполнения", "Документ выполнения"
    ]
    html << "<tr>" + headers.map { |h| "<th>#{h}</th>" }.join + "</tr>"

    items.each do |o|
      cells = [
        o.id,
        o.po.name_po,
        o.klient.name_komp,
        o.specialist.fio_spec,
        o.data_obr,
        o.tema_obr,
        o.status_obr,
        o.data_vypoln_obr,
        o.dok_vypoln_obr_path
      ]
      html << "<tr>" + cells.map { |c| "<td>#{c}</td>" }.join + "</tr>"
    end

    html << "</table></body></html>"

    send_data html,
              filename: "obrashenies_report.doc",
              type: "application/msword",
              disposition: 'attachment'
  end


  private

  # объединяем фильтры/сортировку и связи
  def filtered_obrasheniya
    items = Obrashenie.includes(:po, :klient, :specialist).all
    items = items.where("klient_id = ?", params[:search_klient_id])           if params[:search_klient_id].present?
    items = items.where("po_id = ?", params[:search_po_id])                   if params[:search_po_id].present?
    items = items.where("status_obr LIKE ?", "%#{params[:search_stat_obr]}%")  if params[:search_stat_obr].present?
    items = items.where("data_obr = ?", params[:search_data_obr])             if params[:search_data_obr].present?
    items = items.where("data_vypoln_obr = ?", params[:search_data_vypoln_obr]) if params[:search_data_vypoln_obr].present?
    items = items.where("tema_obr ILIKE ?", "%#{params[:search_tema_obr]}%")   if params[:search_tema_obr].present?
    items = items.where("specialist_id = ?", params[:search_specialist_id])   if params[:search_specialist_id].present?

    allowed = %w[id klient_id po_id status_obr data_obr data_vypoln_obr tema_obr specialist_id dok_vypoln_obr_path]
    if params[:sort_by].present? && params[:sort_order].present? && allowed.include?(params[:sort_by])
      items = items.order("#{params[:sort_by]} #{params[:sort_order]}")
    else
      items = items.order("id ASC")
    end
    items
  end


  # Используется для установки обращения перед некоторыми действиями
  def set_obrashenie
    @obrashenie = Obrashenie.find(params[:id])
  end

  # Разрешенные параметры
  def obrashenie_params
    params.require(:obrashenie).permit(:klient_id, :po_id, :specialist_id, :tema_obr, :status_obr, :data_obr, :data_vypoln_obr, :dok_vypoln_obr_path, :status, :s_delete)
  end
end
