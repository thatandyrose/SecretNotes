class ChangeBodyTypeInNotes < ActiveRecord::Migration
  def change
    change_column :notes, :encrypted_body,  :text
  end
end
