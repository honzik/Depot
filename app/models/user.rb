class User < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true
  
  validates :password, :confirmation => true
  attr_accessor  :password_confirmation
  attr_reader   :password
  
  # custom validator of password presence
  validate  :password_must_be_present
  
  # protection against remove of last admin - transaction
  after_destroy :ensure_ad_admin_remains
  
  def ensure_ad_admin_remains
    if User.count.zero?
      raise "Can't delete last user!"
    end
  end
    
  # authenticator
  # @return user object
  def User.authenticate(name, password)
    if user = find_by_name(name)
      if user.hashed_password == encrypt_password(password, user.salt)
        user
      end
    end
  end
    
  # encryption routine
  # @return SHA2 hashed string
  def User.encrypt_password(password, salt)
    Digest::SHA2.hexdigest(password + "jenik" + salt)
  end
 
  # virtual attribute password
  def password=(password)
    @password = password
    
    if password.present?
      generate_salt
      self.hashed_password = self.class.encrypt_password(password, salt)
    end
  end
  
  private
    # presence of password check
    def password_must_be_present
      errors.add(:password, "Missing password") unless hashed_password.present?
    end
    
    # custom salt generator
    def generate_salt
      self.salt = self.object_id.to_s + rand.to_s
    end    
      
end
