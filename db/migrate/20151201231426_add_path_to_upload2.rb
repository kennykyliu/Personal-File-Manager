class AddPathToUpload2 < ActiveRecord::Migration
  def change
    add_column :uploads, :path, :string
  end
end
