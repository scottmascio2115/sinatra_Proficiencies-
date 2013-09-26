class CreateProficiency < ActiveRecord::Migration
  def change
    create_table :proficiencies do |t|
      t.belongs_to :user
      t.belongs_to :skill
      t.integer :experience
      t.timestamps
    end
  end
end
