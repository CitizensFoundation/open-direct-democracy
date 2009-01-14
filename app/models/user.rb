# Copyright (C) 2008,2009 Róbert Viðar Bjarnason
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
class User < ActiveRecord::Base
  has_and_belongs_to_many :roles
  has_many :line_items
  has_many :orders
  has_one :company

  validates_presence_of     :email, 
                            :password,
                            :first_name,
                            :last_name,
                            :citizen_id
  validates_uniqueness_of   :email
  validates_uniqueness_of   :citizen_id
  validates_length_of       :citizen_id, 
                            :minimum => 10
  validates_length_of       :citizen_id, 
                            :maximum => 10
  validates_length_of       :password, 
                            :minimum => 6
  attr_accessor :password_confirmation
  attr_accessor :citizen_id_confirmation
  validates_confirmation_of :password
  
  before_save :add_admin_role
  
  def self.authenticate(email, password)
    user = self.find_by_email(email)
    if user and password
      expected_password = encrypted_password(password, user.salt)
      if user.hashed_password != expected_password
        user = nil
      end
    elsif user
      user = nil
    end
    user
  end

  # 'password' is a virtual attribute  
  def password
    @password
  end
  
  def password=(pwd)
    if pwd
      @password = pwd
      create_new_salt
      self.hashed_password = User.encrypted_password(self.password, self.salt)
    end
  end

  def safe_delete
    transaction do
      destroy
      if User.count.zero?
        raise "Can't delete last user"
      end
    end
  end  

  def has_role?(role_name)
    self.roles.detect{|role| role.name == role_name }
  end  
  
  def name_with_initial_and_citizen_id
    "#{self.first_name} #{self.last_name} : #{self.citizen_id}"
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
  
  private

  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end

  def self.encrypted_password(password, salt)
    string_to_hash = password + "wibble" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end

  def add_customer_role
    unless self.has_role?("Customer")
      role = Role.find_by_name("Customer")
      self.roles << role
    end
  end

  def add_admin_role
    unless self.has_role?("Admin")
      role = Role.find_by_name("Admin")
      self.roles << role
    end
  end
end
