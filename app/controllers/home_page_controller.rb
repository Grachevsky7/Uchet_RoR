class HomePageController < ApplicationController
  def index
    @current_user_role = current_user_role
    @backup_file = Rails.root.join('db', 'backup.sql')
    @message = flash[:notice]
  end

  def backup
    return redirect_to root_path, alert: "Доступ запрещен." unless current_user_role == "Администратор"

    cfg = Rails.configuration.database_configuration[Rails.env]
    timestamp = Time.now.strftime("%Y%m%d_%H%M%S")
    backup_dir = Rails.root.join('db', 'backups')
    FileUtils.mkdir_p(backup_dir)
    backup_path = backup_dir.join("backup_#{timestamp}.sql")

    pg_dump_exe = 'C:\\Program Files\\PostgreSQL\\16\\bin\\pg_dump.exe'

    dump_cmd = [
      pg_dump_exe,
      "-h", cfg['host'],
      "-p", cfg['port'].to_s,
      "-U", cfg['username'],
      "-F", "p",
      "-c", # очищает перед созданием
      "-f", backup_path.to_s,
      cfg['database']
    ]

    env = { 'PGPASSWORD' => cfg['password'].to_s }

    if system(env, *dump_cmd)
      redirect_to root_path, notice: "Резервная копия успешно создана: #{backup_path.basename}"
    else
      redirect_to root_path, alert: "Ошибка при создании резервной копии. Проверьте путь к pg_dump и параметры database.yml."
    end
  end

  def restore
    return redirect_to root_path, alert: "Доступ запрещен." unless current_user_role == "Администратор"

    cfg = Rails.configuration.database_configuration[Rails.env]

    unless params[:backup_file].present?
      return redirect_to root_path, alert: "Пожалуйста, выберите файл резервной копии для восстановления."
    end

    uploaded_file = params[:backup_file]
    backup_path = Rails.root.join('tmp', "restore_#{Time.now.strftime('%Y%m%d_%H%M%S')}.sql")
    File.open(backup_path, 'wb') { |f| f.write uploaded_file.read }

    # Безопасно пересоздаем схему public
    begin
      ActiveRecord::Base.connection.execute("DROP SCHEMA public CASCADE; CREATE SCHEMA public;")
    rescue => e
      return redirect_to root_path, alert: "Ошибка при очистке схемы: #{e.message}"
    end

    psql_exe = 'C:\\Program Files\\PostgreSQL\\16\\bin\\psql.exe'

    restore_cmd = [
      psql_exe,
      "-h", cfg['host'],
      "-p", cfg['port'].to_s,
      "-U", cfg['username'],
      "-d", cfg['database'],
      "-f", backup_path.to_s
    ]

    env = { 'PGPASSWORD' => cfg['password'].to_s }

    if system(env, *restore_cmd)
      redirect_to root_path, notice: "База данных успешно восстановлена из файла: #{uploaded_file.original_filename}"
    else
      redirect_to root_path, alert: "Ошибка восстановления. Убедитесь, что файл корректный и база доступна."
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