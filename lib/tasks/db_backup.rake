# encoding: UTF-8

namespace :db do
  desc "Создать резервную копию PostgreSQL"
  task backup: :environment do
    config   = Rails.configuration.database_configuration[Rails.env]
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    filename  = Rails.root.join("db", "backups", "backup_#{config['database']}_#{timestamp}.sql.gz")
    FileUtils.mkdir_p(File.dirname(filename))

    # Команда pg_dump -> gzip
    cmd = [
      "pg_dump",
      "-h", config['host'] || "localhost",
      "-U", config['username'],
      "-F", "c",              # custom формат (сжатый)
      config['database'],
      "| gzip > #{filename}"
    ].join(" ")

    puts "Running: #{cmd}"
    system({ "PGPASSWORD" => config['password'] }, cmd) or abort("Backup failed")  # :contentReference[oaicite:0]{index=0}
    puts "Backup saved to #{filename}"
  end

  desc "Восстановить базу данных из последней резервной копии"
  task restore: :environment do
    config   = Rails.configuration.database_configuration[Rails.env]
    pattern  = Rails.root.join("db", "backups", "backup_#{config['database']}_*.sql.gz")
    latest   = Dir.glob(pattern).max
    abort("No backup found") unless latest

    # gunzip -> pg_restore
    cmd = "gunzip -c #{latest} | pg_restore -h #{config['host'] || 'localhost'} -U #{config['username']} -d #{config['database']} -c"
    puts "Running: #{cmd}"
    system({ "PGPASSWORD" => config['password'] }, cmd) or abort("Restore failed")  # :contentReference[oaicite:1]{index=1}
    puts "Restored from #{latest}"
  end
end

