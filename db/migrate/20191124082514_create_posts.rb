class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.bigint :user_id
      t.string :title
      t.text :content
      t.string :banner_pic

      t.timestamps
    end
  end
end
