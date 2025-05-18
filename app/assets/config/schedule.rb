# config/schedule.rb
set :environment, Rails.env
set :output, "log/cron.log"

# Ежедневный бэкап в 02:30
every 1.day, at: '2:30 am' do
  rake "db:backup"
end

# (Опционально) Восстановление — только для ручного запуска через cron
# every 7.days, at: '3:00 am' do
#   rake "db:restore"
# end
