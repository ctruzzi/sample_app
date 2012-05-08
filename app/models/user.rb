require 'digest'

class User < ActiveRecord::Base
	attr_accessor :password
	attr_accessible :name, :email, :password, :password_confirmation

	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	#validates(:name, :presence => true)
	validates :name,	:presence => true,
						:length => { :maximum => 50 }
	validates :email,	:presence => true,
						:format => { :with => email_regex },
						:uniqueness => { :case_sensitive => false }
	validates :password, :presence => true,
						:confirmation => true,
						:length => { :within => 6..40 }					
								
	#Call encrypt_password method prior to saving in active record
	before_save :encrypt_password

	#is self. so we can invoke directly on User
	def self.authenticate(email, submitted_password)
		user = find_by_email(email)
		return nil if user.nil? #return nil if we cannot find user
		return user if user.has_password?(submitted_password)
		#returns nil if doesn't meet either
	end

	# Return true if the user's password matches the submitted password.
	def has_password?(submitted_password)
		# Compare encrypted_password with the encrypted version of submitted_password.
		encrypted_password == encrypt(submitted_password)
	end

	private

		def encrypt_password
			self.salt = make_salt if new_record?
			self.encrypted_password = encrypt(password)
		end

		def encrypt(string)
			secure_hash("#{salt}--#{string}")
		end

		def make_salt
			secure_hash("#{Time.now.utc}--#{password}")
		end

		def secure_hash(string)
			Digest::SHA2.hexdigest(string)
		end
end
