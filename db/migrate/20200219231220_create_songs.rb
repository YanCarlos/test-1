class CreateSongs < ActiveRecord::Migration[5.2]
  def change
    create_table :songs do |t|
      t.references :album, fireign_key: true, index: true, on_delete: :cascade
      t.string :name
      t.string :preview_url
      t.integer :duration_ms
      t.boolean :explicit
      t.string :spotify_id
      t.string :spotify_url
    end
  end
end
