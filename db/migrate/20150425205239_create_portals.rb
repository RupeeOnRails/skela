class CreatePortals < ActiveRecord::Migration
  def change
    create_table :portals do |t|
      t.integer :origin_world_id
      t.integer :destination_world_id
    end
  end
end
