class ZakSpecsController < ApplicationController
  require 'axlsx'
  include ActionView::Helpers::NumberHelper # Для number_to_currency в контроллере
  before_action :load_specialists, only: [:index]

  # GET /zak_specs
  # params[:specialist_id], params[:start_date], params[:end_date]
  def index
    @specialist = Specialist.find_by(id: params[:specialist_id])

    start_date = params[:start_date].presence || Date.today.beginning_of_month
    end_date   = params[:end_date].presence   || Date.today

    scope = NewZakaz.where(data_zak: start_date..end_date)
    scope = scope.where(specialist_id: @specialist.id) if @specialist

    @zak_specs = scope.order(:data_zak)
  end

  def export_to_excel
    @specialist = Specialist.find_by(id: params[:specialist_id])
    start_date = params[:start_date].presence || Date.today.beginning_of_month
    end_date = params[:end_date].presence || Date.today

    scope = NewZakaz.where(data_zak: start_date..end_date)
    scope = scope.where(specialist_id: @specialist.id) if @specialist
    zak_specs = scope.order(:data_zak)

    p = Axlsx::Package.new
    wb = p.workbook

    title_style = wb.styles.add_style(sz: 16, b: true, alignment: { horizontal: :center })
    header_style = wb.styles.add_style(bg_color: "F2F2F2", fg_color: "000000", sz: 12, b: true, alignment: { horizontal: :left }, border: { style: :thin, color: "000000" })
    cell_style = wb.styles.add_style(alignment: { horizontal: :left }, border: { style: :thin, color: "000000" })

    wb.add_worksheet(name: "Отчет") do |sheet|
      sheet.add_row ["Отчет о заказах, выполненных специалистом #{@specialist&.fio_spec} за период #{start_date} - #{end_date}"], style: title_style
      sheet.merge_cells("A1:J1")
      sheet.add_row [""]
      sheet.add_row ["ПО", "Версия ПО", "Наименование клиента", "Специалист", "Дата заказа", "Дата выполнения", "Стоимость ПО в год, ₽", "Срок аренды", "Стоимость заказа, ₽", "Документ установки"], style: header_style
      zak_specs.each do |z|
        po_name = z.po.try(:name_po) || '-'
        po_vers = z.po.try(:vers_po) || '-'
        klient_name = z.klient.try(:name_komp) || '-'
        specialist_name = z.specialist.try(:fio_spec) || '-'
        data_zak = z.data_zak
        data_vypoln = z.data_vypoln_zak
        stoimost_v_god = number_to_currency(z.stoimost_v_god, unit: '', separator: ',', delimiter: ' ')
        srok_arendy = z.srok_arendy
        stoimost_zak = number_to_currency(z.stoimost_zak, unit: '', separator: ',', delimiter: ' ')
        dok_path = z.dok_vypoln_zak_path.present? ? File.basename(z.dok_vypoln_zak_path) : '-'
        sheet.add_row [po_name, po_vers, klient_name, specialist_name, data_zak, data_vypoln, "#{stoimost_v_god}₽", srok_arendy, "#{stoimost_zak}₽", dok_path], style: cell_style
      end
      sheet.add_row [""]
      sheet.add_row ["", "", "", "", "", "", "", "", "Общее число выполненных заказов:", zak_specs.size], style: cell_style

      # Установка ширины столбцов для равномерности
      sheet.column_widths(20, 10, 25, 20, 10, 10, 15, 10, 15, 20)

      # Установка параметров страницы для размещения на одной странице
      sheet.page_setup.fit_to_width = 1
      sheet.page_setup.fit_to_height = 1
    end

    send_data p.to_stream.read, filename: "zak_specs_report.xlsx", type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  end

  def export_to_word
    @specialist = Specialist.find_by(id: params[:specialist_id])
    start_date = params[:start_date].presence || Date.today.beginning_of_month
    end_date = params[:end_date].presence || Date.today

    scope = NewZakaz.where(data_zak: start_date..end_date)
    scope = scope.where(specialist_id: @specialist.id) if @specialist
    zak_specs = scope.order(:data_zak)

    if zak_specs.empty?
      redirect_to zak_specs_path, alert: "Нет данных для выбранного периода."
      return
    end

    html_content = "\xEF\xBB\xBF"
    html_content += "<html><head><meta charset='UTF-8'></head><body>"
    html_content += "<h1>Отчет о заказах, выполненных специалистом #{@specialist&.fio_spec} за период #{start_date} - #{end_date}</h1>"
    html_content += "<table border='1' cellpadding='5' cellspacing='0' width='100%'>"
    html_content += "<colgroup>"
    html_content += "<col width='60'>" # ПО
    html_content += "<col width='30'>" # Версия ПО
    html_content += "<col width='100'>" # Наименование клиента
    html_content += "<col width='60'>" # Специалист
    html_content += "<col width='50'>" # Дата заказа
    html_content += "<col width='50'>" # Дата выполнения
    html_content += "<col width='60'>" # Стоимость ПО в год, ₽
    html_content += "<col width='40'>" # Срок аренды
    html_content += "<col width='60'>" # Стоимость заказа, ₽
    html_content += "<col width='80'>" # Документ установки
    html_content += "</colgroup>"
    html_content += "<tr>"
    ["ПО", "Версия ПО", "Наименование клиента", "Специалист", "Дата заказа", "Дата выполнения", "Стоимость ПО в год, ₽", "Срок аренды", "Стоимость заказа, ₽", "Документ установки"].each do |header|
      html_content += "<th style='font-size:8pt; word-break:break-all; overflow-wrap:break-word;'>#{header}</th>"
    end
    html_content += "</tr>"
    zak_specs.each do |z|
      po_name = z.po.try(:name_po) || '-'
      po_vers = z.po.try(:vers_po) || '-'
      klient_name = z.klient.try(:name_komp) || '-'
      specialist_name = z.specialist.try(:fio_spec) || '-'
      data_zak = z.data_zak
      data_vypoln = z.data_vypoln_zak
      stoimost_v_god = number_to_currency(z.stoimost_v_god, unit: '', separator: ',', delimiter: ' ')
      srok_arendy = z.srok_arendy
      stoimost_zak = number_to_currency(z.stoimost_zak, unit: '', separator: ',', delimiter: ' ')
      dok_path = z.dok_vypoln_zak_path.present? ? File.basename(z.dok_vypoln_zak_path) : '-'
      html_content += "<tr>"
      [po_name, po_vers, klient_name, specialist_name, data_zak, data_vypoln, "#{stoimost_v_god}₽", srok_arendy, "#{stoimost_zak}₽", dok_path].each do |cell|
        html_content += "<td style='font-size:8pt; word-break:break-all; overflow-wrap:break-word;'>#{cell}</td>"
      end
      html_content += "</tr>"
    end
    html_content += "</table>"
    html_content += "<p><strong>Общее число выполненных заказов: #{zak_specs.size}</strong></p>"
    html_content += "</body></html>"

    send_data html_content, filename: "zak_specs_report.doc", type: "application/msword", disposition: 'attachment'
  end

  private

  def load_specialists
    @specialists = Specialist.order(:fio_spec)
  end
end