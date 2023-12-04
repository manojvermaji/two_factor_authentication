require 'rotp'


class User < ApplicationRecord
require "securerandom"


has_secure_password

validates :email, presence: true
validates :password, presence: true

validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }

  
end
