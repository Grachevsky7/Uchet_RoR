User.find_or_create_by!(email: 'admin@example.com') do |u|
  u.password = 'admin123'
  u.role     = :admin
end

User.find_or_create_by!(email: 'manager@example.com') do |u|
  u.password = 'manager123'
  u.role     = :client_manager
end

User.find_or_create_by!(email: 'head@example.com') do |u|
  u.password = 'head123'
  u.role     = :department_head
end