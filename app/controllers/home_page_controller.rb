class HomePageController < ApplicationController
  def index
    @current_user_role = current_user_role
    @backup_file = Rails.root.join('db', 'backup.sql')
    @message = flash[:notice]
  end

  def backup
    return redirect_to root_path, alert: "Доступ запрещен." unless current_user_role == "Администратор"
    db_config = Rails.configuration.database_configuration[Rails.env]
    backup_file = Rails.root.join('db', 'backup.sql')
    password = db_config['password'] ? "-w #{db_config['password']}" : ""
    command = "pg_dump -U #{db_config['username']} #{password} -h #{db_config['host'] || 'localhost'} #{db_config['database']} > #{backup_file}"
    if system(command)
      redirect_to root_path, notice: "Резервная копия создана успешно"
    else
      redirect_to root_path, alert: "Ошибка при создании резервной копии: проверьте наличие pg_dump и настройки database.yml"
    end
  end

  def restore
    return redirect_to root_path, alert: "Доступ запрещен." unless current_user_role == "Администратор"
    db_config = Rails.configuration.database_configuration[Rails.env]
    backup_file = Rails.root.join('db', 'backup.sql')
    password = db_config['password'] ? "-w #{db_config['password']}" : ""
    if File.exist?(backup_file)
      drop_success = system("psql -U #{db_config['username']} #{password} -h #{db_config['host'] || 'localhost'} -d #{db_config['database']} -c 'DROP SCHEMA public CASCADE; CREATE SCHEMA public;'")
      restore_success = system("psql -U #{db_config['username']} #{password} -h #{db_config['host'] || 'localhost'} -d #{db_config['database']} < #{backup_file}")
      
      if drop_success && restore_success
        redirect_to root_path, notice: "Резервная копия восстановлена успешно"
      else
        error_message = "Ошибка при восстановлении: "
        error_message += "очистка базы не удалась" unless drop_success
        error_message += "; восстановление не удалось" unless restore_success
        redirect_to root_path, alert: error_message
      end
    else
      redirect_to root_path, alert: "Файл резервной копии не найден!"
    end
  end

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

  USERS = {
    "admin" => { password: "admin123", role: :admin },
    "manager" => { password: "manager123", role: :client_manager },
    "head" => { password: "head123", role: :department_head }
  }.freeze
end