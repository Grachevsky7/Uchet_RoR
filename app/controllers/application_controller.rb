class ApplicationController < ActionController::Base
  before_action :set_locale

  before_action :authenticate_user!

  helper_method :current_user_role_name

  # Метод для отображения после логина
  def after_sign_in_path_for(resource)
    authenticated_root_path
  end

  # Помощник, возвращающий читаемое имя роли
  def current_user_role_name
    case current_user.role
    when "admin"           then "Администратор"
    when "client_manager"  then "Менеджер"
    when "department_head" then "Руководитель отдела"
    else nil
    end
  end

  # Проверка ролей
  def authorize_admin_or_client_manager!
    unless current_user&.role.in?(%w[admin client_manager])
      redirect_to authenticated_root_path, alert: "Доступ запрещён."
    end
  end

  def authorize_any_role!
    # Любая из трёх: admin, client_manager, department_head
    unless current_user&.role.in?(%w[admin client_manager department_head])
      redirect_to authenticated_root_path, alert: "Доступ запрещён."
    end
  end
end

  private

  def set_locale
    I18n.locale = :ru
  end




=begin
  def after_sign_in_path_for(resource)
    authenticated_root_path  # перенаправление после входа
  end

  # Методы авторизации ролей можно оставить без изменений
  def authorize_admin_or_client_manager!
    unless current_user&.admin? || current_user&.client_manager?
      redirect_to authenticated_root_path, alert: "Доступ запрещен."
    end
  end
end

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
=end