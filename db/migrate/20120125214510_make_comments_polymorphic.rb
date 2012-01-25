class MakeCommentsPolymorphic < ActiveRecord::Migration
  def self.up
    change_table :comments do |t|
      t.remove :article_id
      t.references :commentable, :polymorphic => false
    end
  end

  def self.down
    change_table :comments do |t|
      t.integer :article_id
      t.remove :commentable_type, :commentable_id
    end
  end
end
