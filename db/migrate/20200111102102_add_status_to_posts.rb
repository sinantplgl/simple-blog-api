class AddStatusToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :status, :integer, default: 1
  end
end
