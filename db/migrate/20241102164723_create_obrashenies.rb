class CreateObrashenies < ActiveRecord::Migration[7.1]
  def change
    create_table :obrashenies do |t|
      t.belongs_to :po, null: false, foreign_key: true
      t.belongs_to :klient, null: false, foreign_key: true
      t.string :tema_obr
      t.date :data_obr
      t.string :status_obr
      t.belongs_to :specialist, null: false, foreign_key: true
      t.date :data_vypoln_obr
      t.string :dok_vypoln_obr_path
      t.boolean :status
      t.boolean :s_delete

      t.timestamps
    end
  end
end
