class NewZakaz < ApplicationRecord
  belongs_to :po
  belongs_to :klient
  belongs_to :specialist
end
