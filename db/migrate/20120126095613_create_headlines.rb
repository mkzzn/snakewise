class CreateHeadlines < ActiveRecord::Migration
  def self.up
    create_table :headlines do |t|
      t.string :headline
      t.integer :user_id
      t.boolean :published
      t.string :image

      t.timestamps
    end
  end

  def self.down
    drop_table :headlines
  end
end
