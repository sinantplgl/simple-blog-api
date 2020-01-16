class AddUrlSlugToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :url_slug, :string
  end
end
