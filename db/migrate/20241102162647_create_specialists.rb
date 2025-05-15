class CreateSpecialists < ActiveRecord::Migration[7.1]
  def change
    create_table :specialists do |t|
      t.string :fio_spec
      t.string :telef_spec
      t.string :pochta_spec
      t.string :dlzhnst_spec
      t.string :status_spec
      t.boolean :status
      t.boolean :s_delete

      t.timestamps
    end
  end
end
