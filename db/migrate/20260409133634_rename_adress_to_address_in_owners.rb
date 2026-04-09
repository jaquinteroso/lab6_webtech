class RenameAdressToAddressInOwners < ActiveRecord::Migration[8.1]
  def change
    rename_column :owners, :adress, :address
  end
end
