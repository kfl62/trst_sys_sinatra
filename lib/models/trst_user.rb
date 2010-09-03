class TrstUser 
  include Mongoid::Document
  include Mongoid::Timestamps
  field :login_name
  field :email
  field :hashed_password
  field :salt
  field :permission_level,  :type => Integer,     :default => 1
  field :settings,          :type => Hash,        :default => {}

  class << self

    def all
      result = all
      result.collect {|instance| new instance}
    end

    def get(hash)
      if user = first(:conditions => hash)
        new user
      else
        nil
      end
    end

    def set(attributes)
      user = new attributes
      user.save
      new user
    end

    def set!(attributes)
      user = new attributes
      user.save(:validate => false)
      new user
    end

    def delete(pk)
      user = find(pk)
      user.destroy
      user.destroyed?
    end

  end
  # Validations
  validates_uniqueness_of :login_name
  validates_uniqueness_of :email
  validates_format_of :email, :with => /(\A(\s*)\Z)|(\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z)/i
  validates_presence_of :password
  validates_confirmation_of :password

  attr_accessor :password, :password_confirmation

  def password=(pass)
    @password = pass
    self.salt = random_string(10) if !self.salt
    self.hashed_password = encrypt(@password, self.salt)
  end

  def admin?
    self.permission_level == -1 || self.id == 1
  end

  def site_admin?
    self.id == 1
  end

  protected

  def encrypt(pass, salt)
    Digest::SHA1.hexdigest(pass+salt)
  end

  def random_string(len)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end

  def method_missing(m, *args)
    return false
  end
end

