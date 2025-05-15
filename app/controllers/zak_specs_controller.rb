class ZakSpecsController < ApplicationController
  before_action :set_zak_specs, only: %i[ show edit update destroy ]

  # GET /zak_specs or /zak_specs.json
  def index
      @specialist_id = params[:specialist_id]
      @start_date = params[:start_date]
      @end_date = params[:end_date]

      if @specialist_id.blank? || @start_date.blank? || @end_date.blank?
        redirect_to root_path, alert: "Пожалуйста, укажите все параметры"
        return
      end

      begin
        @specialist = Specialist.find(@specialist_id)
        @start_date = Date.parse(@start_date)
        @end_date = Date.parse(@end_date)
      rescue ActiveRecord::RecordNotFound
        redirect_to root_path, alert: "Специалист не найден"
        return
      rescue ArgumentError
        redirect_to root_path, alert: "Неверный формат даты"
        return
      end

      @orders = Order.where(
        responsible_specialist_id: @specialist_id,
        completed_at: @start_date..@end_date
      )
    end
end
