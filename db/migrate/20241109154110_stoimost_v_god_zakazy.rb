class StoimostVGodZakazy < ActiveRecord::Migration[7.1]
  def change
    drop_table :zakazs
  end
end
