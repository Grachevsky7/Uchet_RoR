class CreateZakazs < ActiveRecord::Migration[7.1]
  def change
    create_table :zakazs do |t|
      t.belongs_to :po, null: false, foreign_key: true
      t.belongs_to :klient, null: false, foreign_key: true
      t.date :data_zak
      t.string :stat_zak
      t.belongs_to :specialist, null: false, foreign_key: true
      t.date :data_vypoln_zak
      t.decimal :stoimost_zak
      t.string :dok_vypoln_zak_path
      t.string :chek_opl_zak_path
      t.boolean :status
      t.boolean :s_delete

      t.timestamps
    end
  end
end
