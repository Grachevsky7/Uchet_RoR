class ObshSummaZakController < ApplicationController
  require 'axlsx'
  include ActionView::Helpers::NumberHelper # Для number_to_currency в контроллере

  def index
    @start_date = params[:start_date]
    @end_date = params[:end_date]

    if @start_date.present? && @end_date.present?
      @zakazs = NewZakaz.joins(:po, :klient)
                        .where(data_zak: @start_date..@end_date)
                        .select('new_zakazs.id, pos.name_po, pos.vers_po, new_zakazs.klient_id, klients.name_komp, new_zakazs.stoimost_zak')
      @total_sum = @zakazs.sum(:stoimost_zak)
    else
      @zakazs = []
      @total_sum = 0
    end
  end

  def export_to_excel
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    zakazs = get_zakazs(@start_date, @end_date)

    p = Axlsx::Package.new
    wb = p.workbook

    # Определяем стили
    title_style = wb.styles.add_style(sz: 16, b: true, alignment: { horizontal: :center })
    header_style = wb.styles.add_style(bg_color: "F2F2F2", fg_color: "000000", sz: 12, b: true, alignment: { horizontal: :left }, border: { style: :thin, color: "000000" })
    cell_style = wb.styles.add_style(alignment: { horizontal: :left }, border: { style: :thin, color: "000000" })

    wb.add_worksheet(name: "Отчет") do |sheet|
      sheet.add_row ["Отчет об общей сумме заказов за период #{@start_date} - #{@end_date}"], style: title_style
      sheet.merge_cells("A1:F1")
      sheet.add_row [""]
      sheet.add_row ["ID заказа", "Наименование ПО", "Версия ПО", "ID клиента", "Компания клиента", "Стоимость заказа"], style: header_style
      zakazs.each do |zakaz|
        sheet.add_row [zakaz.id, zakaz.name_po, zakaz.vers_po, zakaz.klient_id, zakaz.name_komp, "#{number_to_currency(zakaz.stoimost_zak, unit: '', separator: ',', delimiter: ' ')}₽"], style: cell_style
      end
      sheet.add_row [""]
      sheet.add_row ["", "", "", "", "Общая сумма:", "#{number_to_currency(zakazs.sum(:stoimost_zak), unit: '', separator: ',', delimiter: ' ')}₽"], style: cell_style
      sheet.column_widths nil, nil, nil, nil, nil, nil
    end

    send_data p.to_stream.read, filename: "zakazs_report.xlsx", type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  end

  def export_to_word
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    zakazs = get_zakazs(@start_date, @end_date)

    if zakazs.empty?
      redirect_to obsh_summa_zak_index_path, alert: "Нет данных для выбранного периода."
      return
    end

    html_content = "\xEF\xBB\xBF"
    html_content += "<html><head><meta charset='UTF-8'></head><body>"
    html_content += "<h1>Отчет об общей сумме заказов за период #{@start_date} - #{@end_date}</h1>"
    html_content += "<table border='1' cellpadding='5' cellspacing='0'>"
    html_content += "<tr><th>ID заказа</th><th>Наименование ПО</th><th>Версия ПО</th><th>ID клиента</th><th>Компания клиента</th><th>Стоимость заказа</th></tr>"
    zakazs.each do |zakaz|
      html_content += "<tr>"
      html_content += "<td>#{zakaz.id}</td>"
      html_content += "<td>#{zakaz.name_po}</td>"
      html_content += "<td>#{zakaz.vers_po}</td>"
      html_content += "<td>#{zakaz.klient_id}</td>"
      html_content += "<td>#{zakaz.name_komp}</td>"
      html_content += "<td>#{number_to_currency(zakaz.stoimost_zak, unit: '', separator: ',', delimiter: ' ')}₽</td>"
      html_content += "</tr>"
    end
    html_content += "</table>"
    html_content += "<p><strong>Общая сумма: #{number_to_currency(zakazs.sum(:stoimost_zak), unit: '', separator: ',', delimiter: ' ')}₽</strong></p>"
    html_content += "</body></html>"

    send_data html_content, filename: "zakazs_report.doc", type: "application/msword", disposition: 'attachment'
  end

  private

  def get_zakazs(start_date, end_date)
    return [] unless start_date.present? && end_date.present?
    NewZakaz.joins(:po, :klient)
            .where(data_zak: start_date..end_date)
            .select('new_zakazs.id, pos.name_po, pos.vers_po, new_zakazs.klient_id, klients.name_komp, new_zakazs.stoimost_zak')
  end
end