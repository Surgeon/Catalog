class AddCaseToPhrases < ActiveRecord::Migration
  def up
    add_column :phrases, :case, :integer
  end

  def down
    remove_column :phrases, :case
  end
end
