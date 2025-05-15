class ApplicationController < ActionController::Base
  USERS = {
    "admin" => { password: "admin123", role: :admin },
    "manager" => { password: "manager123", role: :client_manager },
    "head" => { password: "head123", role: :department_head }
  }.freeze

  before_action :basic_auth

  private

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      user = USERS[username]
      if user && user[:password] == password
        request.env['REMOTE_USER'] = username
        true
      else
        false
      end
    end
  end

  def current_user_role
    role = request.env['REMOTE_USER'] ? USERS[request.env['REMOTE_USER']][:role].to_s : nil
    case role
    when "admin" then "Администратор"
    when "client_manager" then "Менеджер"
    when "department_head" then "Руководитель отдела"
    else nil
    end
  end

  def authorize_admin_or_client_manager!
    redirect_to root_path, alert: "Доступ запрещен." unless current_user_role.in?(%w[Администратор Менеджер])
  end

  def authorize_any_role!
    redirect_to root_path, alert: "Доступ запрещен." unless current_user_role.in?(%w[Администратор Менеджер Начальник])
  end
end