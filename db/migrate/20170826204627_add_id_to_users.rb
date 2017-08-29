class AddIdToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :synapse_id, :string
  end
end
