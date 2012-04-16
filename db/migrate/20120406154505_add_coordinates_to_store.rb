class AddCoordinatesToStore < ActiveRecord::Migration
  def change
    add_column :stores, :lat, :float
    add_column :stores, :lon, :float
  end
end