class Po < ApplicationRecord
	self.table_name = 'pos' # Указывает на таблицу 'pos' в базе данных
  	has_many :new_zakazs
end
