class KlObshSumZakController < ApplicationController
  require 'axlsx'
  include ActionView::Helpers::NumberHelper # Для number_to_currency в контроллере
  before_action :set_klient, only: [:index]

  def index
    @selected_klient = Klient.find_by(id: params[:klient_id])

    if @selected_klient && params[:start_date].present? && params[:end_date].present?
      @zakazs = NewZakaz.joins(:po)
                        .where(klient_id: @selected_klient.id, data_zak: params[:start_date]..params[:end_date])
                        .select('new_zakazs.id, pos.name_po, pos.vers_po, new_zakazs.data_zak, new_zakazs.stoimost_zak')
      @total_sum = @zakazs.sum(:stoimost_zak)
    else
      @zakazs = []
      @total_sum = 0
    end

    @klients = Klient.all
  end

  def export_to_excel
    @selected_klient = Klient.find_by(id: params[:klient_id])
    zakazs = get_zakazs(@selected_klient&.id, params[:start_date], params[:end_date])

    p = Axlsx::Package.new
    wb = p.workbook

    title_style = wb.styles.add_style(sz: 16, b: true, alignment: { horizontal: :center })
    header_style = wb.styles.add_style(bg_color: "F2F2F2", fg_color: "000000", sz: 12, b: true, alignment: { horizontal: :left }, border: { style: :thin, color: "000000" })
    cell_style = wb.styles.add_style(alignment: { horizontal: :left }, border: { style: :thin, color: "000000" })

    wb.add_worksheet(name: "Отчет") do |sheet|
      sheet.add_row ["Отчет о сумме заказов клиента #{@selected_klient&.name_komp} за период #{params[:start_date]} - #{params[:end_date]}"], style: title_style
      sheet.merge_cells("A1:E1")
      sheet.add_row [""]
      sheet.add_row ["ID заказа", "Наименование ПО", "Версия ПО", "Дата заказа", "Стоимость заказа"], style: header_style
      zakazs.each do |zakaz|
        sheet.add_row [zakaz.id, zakaz.name_po, zakaz.vers_po, zakaz.data_zak, "#{number_to_currency(zakaz.stoimost_zak, unit: '', separator: ',', delimiter: ' ')}₽"], style: cell_style
      end
      sheet.add_row [""]
      sheet.add_row ["", "", "", "Общая сумма:", "#{number_to_currency(zakazs.sum(:stoimost_zak), unit: '', separator: ',', delimiter: ' ')}₽"], style: cell_style
      sheet.column_widths nil, nil, nil, nil, nil
    end

    send_data p.to_stream.read, filename: "kl_zakazs_report.xlsx", type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  end

  def export_to_word
    @selected_klient = Klient.find_by(id: params[:klient_id])
    zakazs = get_zakazs(@selected_klient&.id, params[:start_date], params[:end_date])

    if zakazs.empty?
      redirect_to kl_obsh_sum_zak_index_path, alert: "Нет данных для выбранного периода."
      return
    end

    html_content = "\xEF\xBB\xBF"
    html_content += "<html><head><meta charset='UTF-8'></head><body>"
    html_content += "<h1>Отчет о сумме заказов клиента #{@selected_klient&.name_komp} за период #{params[:start_date]} - #{params[:end_date]}</h1>"
    html_content += "<table border='1' cellpadding='5' cellspacing='0'>"
    html_content += "<tr><th>ID заказа</th><th>Наименование ПО</th><th>Версия ПО</th><th>Дата заказа</th><th>Стоимость заказа</th></tr>"
    zakazs.each do |zakaz|
      html_content += "<tr>"
      html_content += "<td>#{zakaz.id}</td>"
      html_content += "<td>#{zakaz.name_po}</td>"
      html_content += "<td>#{zakaz.vers_po}</td>"
      html_content += "<td>#{zakaz.data_zak}</td>"
      html_content += "<td>#{number_to_currency(zakaz.stoimost_zak, unit: '', separator: ',', delimiter: ' ')}₽</td>"
      html_content += "</tr>"
    end
    html_content += "</table>"
    html_content += "<p><strong>Общая сумма: #{number_to_currency(zakazs.sum(:stoimost_zak), unit: '', separator: ',', delimiter: ' ')}₽</strong></p>"
    html_content += "</body></html>"

    send_data html_content, filename: "kl_zakazs_report.doc", type: "application/msword", disposition: 'attachment'
  end

  private

  def set_klient
    @selected_klient = Klient.find_by(id: params[:klient_id])
  end

  def get_zakazs(klient_id, start_date, end_date)
    return [] unless klient_id && start_date.present? && end_date.present?
    NewZakaz.joins(:po)
            .where(klient_id: klient_id, data_zak: start_date..end_date)
            .select('new_zakazs.id, pos.name_po, pos.vers_po, new_zakazs.data_zak, new_zakazs.stoimost_zak')
  end
end