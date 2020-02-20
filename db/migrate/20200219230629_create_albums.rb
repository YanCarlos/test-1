class CreateAlbums < ActiveRecord::Migration[5.2]
  def change
    create_table :albums do |t|
      t.references :artist, foreign_key: true, index: true
      t.string :name
      t.string :image
      t.integer :total_tracks
      t.string :spotify_url
      t.string :spotify_id
    end
  end
end
