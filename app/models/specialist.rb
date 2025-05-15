class Specialist < ApplicationRecord
	has_many :new_zakazs, dependent: :destroy
end
