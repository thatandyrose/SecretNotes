class Note < ActiveRecord::Base
  attr_accessor :password

  attr_encrypted :title, :body, key: proc { |note| note.password }

  before_save :encrypt_password

  validates_presence_of :password, message: 'Password required', on: :create

  def self.authenticate(id, password)
    note = find id
    
    if note && note.password_hash == BCrypt::Engine.hash_secret(password, note.password_salt)
      note.password = password
      note
    else
      nil
    end

  end
  
  private

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end
