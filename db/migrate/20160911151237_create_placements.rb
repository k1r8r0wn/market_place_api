class CreatePlacements < ActiveRecord::Migration[5.0]
  def change
    create_table :placements do |t|
      t.references :order, foreign_key: true
      t.references :product, foreign_key: true

      t.timestamps
    end
  end
end
