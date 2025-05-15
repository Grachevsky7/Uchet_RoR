class CreateKlients < ActiveRecord::Migration[7.1]
  def change
    create_table :klients do |t|
      t.string :name_komp
      t.string :kontakt_lico
      t.string :telef_kl
      t.string :pochta_kl
      t.string :adres_kl
      t.boolean :status
      t.boolean :s_delete

      t.timestamps
    end
  end
end
