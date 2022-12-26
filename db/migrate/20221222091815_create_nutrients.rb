class CreateNutrients < ActiveRecord::Migration[6.0]
  def change
    create_table :nutrients do |t|
      t.string     :name,         null: false
      t.float      :calorie,      null: false
      t.float      :protein,      null: false
      t.float      :lipid,        null: false
      t.float      :carbohydrate, null: false
      t.float      :sugar,        null: false
      t.float      :fiber,        null: false
      t.float      :number,       null: false
      t.datetime   :start_time
      t.references :user,         null: false, foreign_key: true
      t.timestamps
    end
  end
end
