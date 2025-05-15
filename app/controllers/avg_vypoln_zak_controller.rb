class AvgVypolnZakController < ApplicationController
  require 'axlsx'
  include ActionView::Helpers::NumberHelper # Для number_to_currency, хотя здесь не используется, оставлено для единообразия

  def index
    @avg_vypolnenie_zakazov = NewZakaz
      .where.not(data_vypoln_zak: nil)
      .group(:specialist_id)
      .select('specialist_id, AVG(DATE_PART(\'day\', data_vypoln_zak::timestamp - data_zak::timestamp)) AS avg_duration')
      .order('avg_duration ASC')
      .includes(:specialist)
  end

  def export_to_excel
    avg_vypolnenie_zakazov = get_avg_vypolnenie_zakazov

    p = Axlsx::Package.new
    wb = p.workbook

    # Определяем стили
    title_style = wb.styles.add_style(sz: 16, b: true, alignment: { horizontal: :center })
    header_style = wb.styles.add_style(bg_color: "F2F2F2", fg_color: "000000", sz: 12, b: true, alignment: { horizontal: :left }, border: { style: :thin, color: "000000" })
    cell_style = wb.styles.add_style(alignment: { horizontal: :left }, border: { style: :thin, color: "000000" })

    wb.add_worksheet(name: "Отчет") do |sheet|
      sheet.add_row ["Отчет о средней продолжительности выполнения заказов"], style: title_style
      sheet.merge_cells("A1:B1")
      sheet.add_row [""]
      sheet.add_row ["Специалист", "Средняя продолжительность (дни)"], style: header_style
      avg_vypolnenie_zakazov.each do |record|
        sheet.add_row [record.specialist.fio_spec, record.avg_duration.to_f.round(2)], style: cell_style
      end
      sheet.column_widths nil, nil
    end

    send_data p.to_stream.read, filename: "avg_vypoln_zak_report.xlsx", type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  end

  def export_to_word
    avg_vypolnenie_zakazov = get_avg_vypolnenie_zakazov

    if avg_vypolnenie_zakazov.empty?
      redirect_to avg_vypoln_zak_index_path, alert: "Нет данных для отчета."
      return
    end

    html_content = "\xEF\xBB\xBF"
    html_content += "<html><head><meta charset='UTF-8'></head><body>"
    html_content += "<h1>Отчет о средней продолжительности выполнения заказов</h1>"
    html_content += "<table border='1' cellpadding='5' cellspacing='0'>"
    html_content += "<tr><th>Специалист</th><th>Средняя продолжительность (дни)</th></tr>"
    avg_vypolnenie_zakazov.each do |record|
      html_content += "<tr>"
      html_content += "<td>#{record.specialist.fio_spec}</td>"
      html_content += "<td>#{record.avg_duration.to_f.round(2)}</td>"
      html_content += "</tr>"
    end
    html_content += "</table>"
    html_content += "</body></html>"

    send_data html_content, filename: "avg_vypoln_zak_report.doc", type: "application/msword", disposition: 'attachment'
  end

  private

  def get_avg_vypolnenie_zakazov
    NewZakaz
      .where.not(data_vypoln_zak: nil)
      .group(:specialist_id)
      .select('specialist_id, AVG(DATE_PART(\'day\', data_vypoln_zak::timestamp - data_zak::timestamp)) AS avg_duration')
      .order('avg_duration ASC')
      .includes(:specialist)
  end
end