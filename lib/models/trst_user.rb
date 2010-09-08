class TrstUser 
  include Mongoid::Document
  include Mongoid::Timestamps

  field :login_name
  field :email
  field :hashed_password
  field :salt
  field :permission_lvl,    :type => Integer,     :default => 10
  field :permission_grp,    :type => Array,       :default => ["public"]
  field :settings,          :type => Hash,        :default => {}
  field :task_ids,          :type => Array,       :default => []    

  # Validations
  validates_uniqueness_of :login_name
  validates_uniqueness_of :email
  validates_format_of :email, :with => /(\A(\s*)\Z)|(\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z)/i
  #validates_presence_of :password
  validates_confirmation_of :password

  attr_accessor :password, :password_confirmation

  class << self

    def get(hash)
      if user = first(:conditions => hash)
        user
      else
        nil
      end
    end

    def set(attributes)
      user = new attributes
      user.save
      user
    end

    def set!(attributes)
      user = new attributes
      user.save(:validate => false)
      user
    end

    def delete(pk)
      user = find(pk)
      user.destroy
      user.destroyed?
    end

   def authenticate(login_name, pass)
      current_user = get(:login_name => login_name)
      return nil if current_user.nil?
      return current_user if encrypt(pass, current_user.salt) == current_user.hashed_password
      nil
    end

    def encrypt(pass, salt)
      Digest::SHA1.hexdigest(pass+salt)
    end

  end

  def password=(pass)
    @password = pass
    self.salt = random_string(10) if !self.salt
    self.hashed_password = TrstUser.encrypt(@password, self.salt)
  end

  def admin?
    self.permission_lvl == -1 || self.permission_grp.include?("admin")
  end

  def site_admin?
    self.id == 1
  end

  def tasks
    task_ids
  end
  
  protected

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

