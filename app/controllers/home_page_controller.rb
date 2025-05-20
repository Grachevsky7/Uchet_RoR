class HomePageController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin, only: [:backup, :restore]

  def index
    # здесь можно устанавливать @message, если нужно
  end

  def backup
    cfg       = Rails.configuration.database_configuration[Rails.env]
    timestamp = Time.current.strftime("%Y%m%d_%H%M%S")
    dirname   = Rails.root.join("db", "backups")
    FileUtils.mkdir_p(dirname)
    path      = dirname.join("backup_#{timestamp}.sql")

    pg_dump = 'C:\Program Files\PostgreSQL\16\bin\pg_dump.exe'
    cmd = [ pg_dump, "-h", cfg["host"], "-p", cfg["port"].to_s,
            "-U", cfg["username"], "-F", "p", "-c", "-f", path.to_s, cfg["database"] ]
    env = { "PGPASSWORD" => cfg["password"].to_s }

    if system(env, *cmd)
      redirect_to authenticated_root_path, notice: "Копия БД сохранена: #{path.basename}"
    else
      redirect_to authenticated_root_path, alert: "Ошибка при создании копии БД"
    end
  end

  def restore
    unless params[:backup_file].present?
      return redirect_to authenticated_root_path,
                         alert: "Выберите файл резервной копии."
    end

    cfg      = Rails.configuration.database_configuration[Rails.env]
    tmp_path = Rails.root.join("tmp", "restore_#{Time.current.strftime('%Y%m%d_%H%M%S')}.sql")
    File.binwrite(tmp_path, params[:backup_file].read)

    # очищаем схему public
    begin
      ActiveRecord::Base.connection.execute("DROP SCHEMA public CASCADE; CREATE SCHEMA public;")
    rescue => e
      return redirect_to authenticated_root_path,
                         alert: "Ошибка очистки схемы: #{e.message}"
    end

    psql = 'C:\Program Files\PostgreSQL\16\bin\psql.exe'
    cmd  = [ psql, "-h", cfg["host"], "-p", cfg["port"].to_s,
             "-U", cfg["username"], "-d", cfg["database"], "-f", tmp_path.to_s ]
    env  = { "PGPASSWORD" => cfg["password"].to_s }

    if system(env, *cmd)
      redirect_to authenticated_root_path, notice: "БД восстановлена из #{params[:backup_file].original_filename}"
    else
      redirect_to authenticated_root_path, alert: "Ошибка восстановления БД."
    end
  end

  private

  def ensure_admin
    redirect_to authenticated_root_path, alert: "Доступ запрещён." unless current_user.admin?
  end
end
