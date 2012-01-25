class CreateFortunes < ActiveRecord::Migration
  def self.up
    create_table :fortunes do |t|
      t.string :fortune
      t.string :lucky_numbers
      t.string :learn_chinese
      t.integer :user_id
      t.boolean :published

      t.timestamps
    end
  end

  def self.down
    drop_table :fortunes
  end
end
