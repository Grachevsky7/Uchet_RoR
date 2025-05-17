class ObrSpecController < ApplicationController
  require 'axlsx'
  include ActionView::Helpers::NumberHelper # Для number_to_currency в контроллере
  before_action :load_specialists, only: [:index]

  # GET /obr_spec
  # params[:specialist_id], params[:start_date], params[:end_date]
  def index
    @specialist = Specialist.find_by(id: params[:specialist_id])

    start_date = params[:start_date].presence || Date.today.beginning_of_month
    end_date   = params[:end_date].presence   || Date.today

    scope = Obrashenie.where(data_obr: start_date..end_date)
    scope = scope.where(specialist_id: @specialist.id) if @specialist

    @obr_specs = scope.order(:data_obr)
  end

  def export_to_excel
    @specialist = Specialist.find_by(id: params[:specialist_id])
    start_date = params[:start_date].presence || Date.today.beginning_of_month
    end_date = params[:end_date].presence || Date.today

    scope = Obrashenie.where(data_obr: start_date..end_date)
    scope = scope.where(specialist_id: @specialist.id) if @specialist
    obr_specs = scope.order(:data_obr)

    p = Axlsx::Package.new
    wb = p.workbook

    title_style = wb.styles.add_style(sz: 16, b: true, alignment: { horizontal: :center })
    header_style = wb.styles.add_style(bg_color: "F2F2F2", fg_color: "000000", sz: 12, b: true, alignment: { horizontal: :left }, border: { style: :thin, color: "000000" })
    cell_style = wb.styles.add_style(alignment: { horizontal: :left }, border: { style: :thin, color: "000000" })

    wb.add_worksheet(name: "Отчет") do |sheet|
      sheet.add_row ["Отчет о обращениях, выполненных специалистом #{@specialist&.fio_spec} за период #{start_date} - #{end_date}"], style: title_style
      sheet.merge_cells("A1:H1")
      sheet.add_row [""]
      sheet.add_row ["ПО", "Версия ПО", "Наименование клиента", "Специалист", "Дата обращения", "Тема обращения", "Дата выполнения обращения", "Документ о выполнении обращения"], style: header_style
      obr_specs.each do |o|
        po_name = o.po.try(:name_po) || '-'
        po_vers = o.po.try(:vers_po) || '-'
        klient_name = o.klient.try(:name_komp) || '-'
        specialist_name = o.specialist.try(:fio_spec) || '-'
        data_obr = o.data_obr
        tema_obr = o.tema_obr || '-'
        data_vypoln_obr = o.data_vypoln_obr || '-'
        dok_path = o.dok_vypoln_obr_path.present? ? File.basename(o.dok_vypoln_obr_path) : '-'
        sheet.add_row [po_name, po_vers, klient_name, specialist_name, data_obr, tema_obr, data_vypoln_obr, dok_path], style: cell_style
      end
      sheet.add_row [""]
      sheet.add_row ["", "", "", "", "", "", "Общее число обращений:", obr_specs.size], style: cell_style

      # Установка ширины столбцов для равномерности
      sheet.column_widths(20, 10, 25, 20, 15, 30, 15, 20)

      # Установка параметров страницы для размещения на одной странице
      sheet.page_setup.fit_to_width = 1
      sheet.page_setup.fit_to_height = 1
    end

    send_data p.to_stream.read, filename: "obr_specs_report.xlsx", type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  end

  def export_to_word
    @specialist = Specialist.find_by(id: params[:specialist_id])
    start_date = params[:start_date].presence || Date.today.beginning_of_month
    end_date = params[:end_date].presence || Date.today

    scope = Obrashenie.where(data_obr: start_date..end_date)
    scope = scope.where(specialist_id: @specialist.id) if @specialist
    obr_specs = scope.order(:data_obr)

    if obr_specs.empty?
      redirect_to obr_spec_index_path, alert: "Нет данных для выбранного периода."
      return
    end

    html_content = "\xEF\xBB\xBF"
    html_content += "<html><head><meta charset='UTF-8'></head><body>"
    html_content += "<h1>Отчет о обращениях, выполненных специалистом #{@specialist&.fio_spec} за период #{start_date} - #{end_date}</h1>"
    html_content += "<table border='1' cellpadding='5' cellspacing='0' width='100%'>"
    html_content += "<colgroup>"
    html_content += "<col width='60'>" # ПО
    html_content += "<col width='30'>" # Версия ПО
    html_content += "<col width='100'>" # Наименование клиента
    html_content += "<col width='60'>" # Специалист
    html_content += "<col width='50'>" # Дата обращения
    html_content += "<col width='120'>" # Тема обращения
    html_content += "<col width='50'>" # Дата выполнения обращения
    html_content += "<col width='80'>" # Документ о выполнении обращения
    html_content += "</colgroup>"
    html_content += "<tr>"
    ["ПО", "Версия ПО", "Наименование клиента", "Специалист", "Дата обращения", "Тема обращения", "Дата выполнения обращения", "Документ о выполнении обращения"].each do |header|
      html_content += "<th style='font-size:8pt; word-break:break-all; overflow-wrap:break-word;'>#{header}</th>"
    end
    html_content += "</tr>"
    obr_specs.each do |o|
      po_name = o.po.try(:name_po) || '-'
      po_vers = o.po.try(:vers_po) || '-'
      klient_name = o.klient.try(:name_komp) || '-'
      specialist_name = o.specialist.try(:fio_spec) || '-'
      data_obr = o.data_obr
      tema_obr = o.tema_obr || '-'
      data_vypoln_obr = o.data_vypoln_obr || '-'
      dok_path = o.dok_vypoln_obr_path.present? ? File.basename(o.dok_vypoln_obr_path) : '-'
      html_content += "<tr>"
      [po_name, po_vers, klient_name, specialist_name, data_obr, tema_obr, data_vypoln_obr, dok_path].each do |cell|
        html_content += "<td style='font-size:8pt; word-break:break-all; overflow-wrap:break-word;'>#{cell}</td>"
      end
      html_content += "</tr>"
    end
    html_content += "</table>"
    html_content += "<p><strong>Общее число обращений: #{obr_specs.size}</strong></p>"
    html_content += "</body></html>"

    send_data html_content, filename: "obr_specs_report.doc", type: "application/msword", disposition: 'attachment'
  end

  private

  def load_specialists
    @specialists = Specialist.order(:fio_spec)
  end
end