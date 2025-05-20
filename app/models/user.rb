class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Роли
  enum role: { admin: 0, client_manager: 1, department_head: 2 }

  # Читабельные названия ролей для отображения
  def role_name
    case role
    when "admin"           then "Администратор"
    when "client_manager"  then "Менеджер"
    when "department_head" then "Руководитель отдела"
    end
  end
end
