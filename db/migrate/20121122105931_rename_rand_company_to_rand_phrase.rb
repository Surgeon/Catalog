class RenameRandCompanyToRandPhrase < ActiveRecord::Migration
  def up
    rename_column :companies, :rand_company, :rand_phrase
    rename_column :regions, :rand_company, :rand_phrase
  end

  def down
    rename_column :companies, :rand_phrase, :rand_company
    rename_column :regions, :rand_phrase, :rand_company
  end
end
