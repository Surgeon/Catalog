class CreateNewsItems < ActiveRecord::Migration
  def change
    create_table :news_items do |t|
      t.string :title
      t.text :preview
      t.text :body

      t.timestamps
    end
  end
end
