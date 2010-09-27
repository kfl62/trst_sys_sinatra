# encoding: utf-8
=begin
# Users model#
Defined fields and default values:
    field :login_name
    field :email
    field :hashed_password
    field :salt
    field :permission_lvl,  :type => Integer,   :default => 10
    field :permission_grp,  :type => Array,     :default => ["public"]
    field :settings,        :type => Hash,      :default => {}
    field :task_ids,        :type => Hash,      :default => {'daily_tasks' => [], 'other_tasks' => []}
Validations
    validates_uniqueness_of :login_name
    validates_uniqueness_of :email
    validates_format_of :email, :with => /(\A(\s*)\Z)|(\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z)/i
    validates_confirmation_of :password
=end
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
  field :task_ids,          :type => Hash,        :default => {'daily_tasks' => [], 'other_tasks' => []}

  # Validations
  validates_uniqueness_of :login_name
  validates_uniqueness_of :email
  validates_format_of :email, :with => /(\A(\s*)\Z)|(\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z)/i
  validates_confirmation_of :password

  attr_accessor :password, :password_confirmation

  class << self
    # @todo Document this method
    def get(hash)
      if user = first(:conditions => hash)
        user
      else
        nil
      end
    end
    # @todo Document this method
    def set(attributes)
      user = new attributes
      user.save
      user
    end
    # @todo Document this method
    def set!(attributes)
      user = new attributes
      user.save(:validate => false)
      user
    end
    # @todo Document this method
    def delete(pk)
      user = find(pk)
      user.destroy
      user.destroyed?
    end
    # @todo Document this method
   def authenticate(login_name, pass)
      current_user = get(:login_name => login_name)
      return nil if current_user.nil?
      return current_user if encrypt(pass, current_user.salt) == current_user.hashed_password
      nil
    end
    # @todo Document this method
    def encrypt(pass, salt)
      Digest::SHA1.hexdigest(pass+salt)
    end
    # @todo Document this method
    def user_related_to
      all.collect{|user| [user.id.to_s, user.login_name]}
    end

  end
  # @todo Document this method
  def name
    login_name
  end
  # @todo Document this method
  def password=(pass)
    @password = pass
    self.salt = random_string(10) if !self.salt
    self.hashed_password = TrstUser.encrypt(@password, self.salt)
  end
  # @todo Document this method
  def admin?
    self.permission_lvl == -1 || self.permission_grp.include?("admin")
  end
  # @todo Document this method
  def site_admin?
    self.id ==  -1 || (self.permission_grp & ["admin","web"]).length >= 1
  end
  # @todo Document this method
  def tasks
    task_ids.values.flatten.uniq
  end
  # @todo Document this method
  def daily_tasks
    task_ids['daily_tasks']
  end
  # @todo Document this method
  def daily_tasks_name
    daily_tasks.collect{|id| TrstTask.find(id).name}
  end
  # @todo Document this method
  def other_tasks
    task_ids['other_tasks']
  end
  # @todo Document this method
  def other_tasks_name
    other_tasks.collect{|id| TrstTask.find(id).name}
  end
  # @todo Document this method
  def table_data
    [{:css => "normal",:name => "login_name",:label => I18n.t("trst_user.login_name"),:value => login_name},
     {:css => "normal",:name => "email",:label => I18n.t("trst_user.email"),:value => email},
     {:css => "integer",:name => "permission_lvl",:label => I18n.t("trst_user.permission_lvl"),:value => permission_lvl},
     {:css => "array",:name => "permission_grp",:label => I18n.t("trst_user.permission_grp"),:value => permission_grp},
     {:css => "hash",:name => "settings",:label => I18n.t("trst_user.settings.header"),:value => settings},
     {:css => "relations",:name => "task_ids,daily_tasks",:label => I18n.t("trst_user.daily_tasks"),:value => [daily_tasks_name,daily_tasks]},
     {:css => "relations",:name => "task_ids,other_tasks",:label => I18n.t("trst_user.other_tasks"),:value => [other_tasks_name,other_tasks]},
     {:css => "datetime",:name => "created_at",:label => I18n.t("trst_task.created_at"),:value => created_at},
     {:css => "datetime",:name => "updated_at",:label => I18n.t("trst_task.updated_at"),:value => updated_at}]
  end

  protected
  # @todo Document this method
  def random_string(len)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end
  # @todo Document this method
  def method_missing(m, *args)
    return false
  end
end

