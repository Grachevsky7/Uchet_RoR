class PoController < ApplicationController
  def index
    @most_expensive_po = nil
    @least_expensive_po = nil
    @same_po = false

    if params[:start_date].present? || params[:end_date].present?
      po_scope = Po.all

      if params[:start_date].present? && params[:end_date].present?
        po_scope = po_scope.where("data_vypuska_po BETWEEN ? AND ?", params[:start_date], params[:end_date])
      elsif params[:start_date].present?
        po_scope = po_scope.where("data_vypuska_po >= ?", params[:start_date])
      elsif params[:end_date].present?
        po_scope = po_scope.where("data_vypuska_po <= ?", params[:end_date])
      end

      @most_expensive_po = po_scope.order(stoimost_v_god_po: :desc).first
      @least_expensive_po = po_scope.order(stoimost_v_god_po: :asc).first

      # Проверка на совпадение самой дорогой и самой дешевой записи
      @same_po = @most_expensive_po == @least_expensive_po
    end
  end
end
