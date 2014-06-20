# this will generate the password hash
require 'bcrypt'

class User

	include DataMapper::Resource

	property :id, Serial
	property :email, String
	# this will store both the password and the salt
  # It's Text and not String because String holds 
  # 50 characters by default
  # and it's not enough for the hash and salt
	property :password_digest, Text

	attr_reader :password
	attr_accessor :password_confirmation

# this is datamapper's method of validating the model.
# The model will not be saved unless both password
# and password_confirmation are the same
# read more about it in the documentation
# http://datamapper.org/docs/validations.html
	validates_confirmation_of :password

	def password=(password)
		@password = password
		self.password_digest = BCrypt::Password.create(password)
	end

end