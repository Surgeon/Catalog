class AddFriendlyUrlToCategories < ActiveRecord::Migration
  def up
    add_column :categories, :region_id, :integer
  end

  def down
    remove_column :categories, :region_id
  end
end
