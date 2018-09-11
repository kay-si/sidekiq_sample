class CreateSnippets < ActiveRecord::Migration[5.2]
  def change
    create_table :snippets do |t|
      t.string :language
      t.text :plain_code
      t.text :highlighted_code

      t.timestamps
    end
  end
end
