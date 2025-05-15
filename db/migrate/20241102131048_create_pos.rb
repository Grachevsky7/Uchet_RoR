class CreatePos < ActiveRecord::Migration[7.1]
  def change
    create_table :pos do |t|
      t.string :name_po
      t.string :vers_po
      t.date :data_vypuska_po
      t.decimal :stoimost_v_god_po
      t.boolean :status
      t.boolean :s_delete

      t.timestamps
    end
  end
end
