class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :encrypted_title
      t.string :encrypted_body
      t.string :password_hash
      t.string :password_salt

      t.timestamps
    end
  end
end
