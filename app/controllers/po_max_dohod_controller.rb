class PoMaxDohodController < ApplicationController
  require 'axlsx'

  def index
    start_date = params[:start_date]
    end_date = params[:end_date]

    if start_date.present? && end_date.present?
      @max_income_pos = Po.joins(:new_zakazs)
                          .where('new_zakazs.data_zak BETWEEN ? AND ?', start_date, end_date)
                          .select('pos.id, pos.name_po, SUM(new_zakazs.stoimost_zak) AS total_income')
                          .group('pos.id, pos.name_po')
                          .order('total_income DESC')
                          .limit(1)
    else
      @max_income_pos = []
    end
  end

  def export_to_excel
    start_date = params[:start_date]
    end_date = params[:end_date]
    max_income_pos = get_max_income_pos(start_date, end_date)

    p = Axlsx::Package.new
    wb = p.workbook

    # Определяем стили
    title_style = wb.styles.add_style(sz: 16, b: true, alignment: { horizontal: :center })
    header_style = wb.styles.add_style(bg_color: "F2F2F2", fg_color: "000000", sz: 12, b: true, alignment: { horizontal: :left }, border: { style: :thin, color: "000000" })
    cell_style = wb.styles.add_style(alignment: { horizontal: :left }, border: { style: :thin, color: "000000" })

    wb.add_worksheet(name: "Отчет") do |sheet|
      # Добавляем заголовок с объединением ячеек
      sheet.add_row ["Отчет о ПО с максимальным доходом"], style: title_style
      sheet.merge_cells("A1:B1") # Объединяем первые две ячейки первой строки
      sheet.add_row [""] # Пустая строка для отступа

      # Добавляем таблицу
      sheet.add_row ["ПО", "Общий доход"], style: header_style
      max_income_pos.each do |record|
        sheet.add_row [record.name_po, "#{record.total_income} ₽"], style: cell_style
      end

      # Устанавливаем ширину столбцов для читаемости
      sheet.column_widths nil, nil # Автоматическая ширина
    end

    send_data p.to_stream.read, filename: "report.xlsx", type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  end

  def export_to_word
    start_date = params[:start_date]
    end_date = params[:end_date]
    max_income_pos = get_max_income_pos(start_date, end_date)

    if max_income_pos.empty?
      redirect_to po_max_dohod_index_path, alert: "Нет данных для выбранного периода."
      return
    end

    # Создаем HTML с кодировкой UTF-8 и BOM
    html_content = "\xEF\xBB\xBF" # BOM для UTF-8
    html_content += "<html><head><meta charset='UTF-8'></head><body>"
    html_content += "<h1>Отчет  о ПО с максимальным доходом</h1>"

    # Добавляем таблицу
    html_content += "<table border='1' cellpadding='5' cellspacing='0'>"
    html_content += "<tr><th>ПО</th><th>Доход, ₽</th></tr>" # Заголовки таблицы
    max_income_pos.each do |record|
      html_content += "<tr>"
      html_content += "<td>#{record.name_po}</td>"
      html_content += "<td>#{record.total_income}</td>"
      html_content += "</tr>"
    end
    html_content += "</table>"

    html_content += "</body></html>"

    # Отправляем файл
    send_data(
      html_content,
      filename: "report.doc",
      type: "application/msword",
      disposition: 'attachment'
    )
  end

  private

  def get_max_income_pos(start_date, end_date)
    return [] unless start_date.present? && end_date.present?

    Po.joins(:new_zakazs)
      .where('new_zakazs.data_zak BETWEEN ? AND ?', start_date, end_date)
      .select('pos.id, pos.name_po, SUM(new_zakazs.stoimost_zak) AS total_income')
      .group('pos.id, pos.name_po')
      .order('total_income DESC')
      .limit(1)
  end
end