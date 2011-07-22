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
Note:<br>
`#user` will be used to represent an instance of {TrstUser}
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

  belongs_to :unit, :class_name => "TrstFirmUnit", :inverse_of => :user
  # Validations
  validates_uniqueness_of :login_name
  validates_uniqueness_of :email
  validates_format_of :email, :with => /(\A(\s*)\Z)|(\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z)/i
  validates_confirmation_of :password

  attr_accessor :password, :password_confirmation

  class << self
    # Authentication based on name and password
    # @param [String] login_name User name
    # @param [String] pass User password
    # @return [TrstUser] returns nil if no user with `login_name`, or password
    #   doesn't match
    def authenticate(login_name, pass)
      current_user = where(:login_name => login_name).first
      return nil if current_user.nil?
      return current_user if encrypt(pass, current_user.salt) == current_user.hashed_password
      nil
    end
    # Compare provided password with `hashed_password` using `Digest::SHA1.hexdigest`
    # @param [String] pass Provided password
    # @param [String] salt `#user.salt`
    # @return [String] to compare with User's `hashed_password`
    def encrypt(pass, salt)
      Digest::SHA1.hexdigest(pass+salt)
    end
    # Used in handling relations, for matching ids with names
    # @return [Array] A collection of [#user.id.to_s, #user.login_name]
    def user_related_to
      all.collect{|user| [user.id.to_s, user.login_name]}
    end
  end
  # Shortcut for `login_name`. Just for avoid errors like `TrstUser.first.name`
  # => `false` caused by {#method_missing}
  # @return [String] shortcut for `login_name`
  def name
    login_name
  end
  # @todo
  def unit
    TrstFirm.unit_by_unit_id(self.unit_id) rescue nil
  end
  # Generate `hashed_password`
  # @return [String] `hashed_password`
  def password=(pass)
    @password = pass
    self.salt = random_string(10) if !self.salt
    self.hashed_password = TrstUser.encrypt(@password, self.salt)
  end
  # `true` if `#user` has admin rights
  # @return [Boolean]
  def admin?
    self.permission_lvl == -1 || self.permission_grp.include?("admin")
  end
  # `true` if `#user` has site admin rights
  # @return [Boolean]
  def site_admin?
    self.id ==  -1 || (self.permission_grp & ["admin","web"]).length >= 1
  end
  # A flattened list for unique task ids
  # @return [Array] ids for all accessible tasks
  def tasks
    task_ids.values.flatten.uniq
  end
  #
  # @see #table_data
  # @return [Array] daily todo - ids
  def daily_tasks
    tsks = []
    pdfs = []
    qrs  = []
    task_ids['daily_tasks'].each do |t|
      begin
        if TrstTask.find(t).is_pdf?
          pdfs << t
        elsif TrstTask.find(t).is_query?
          qrs  << t
        else
          tsks << t
        end
      rescue
        nil
      end
    end
    return [tsks,pdfs,qrs]
  end
  #
  # @see #table_data
  # @return [Array] daily todo - names
  def daily_tasks_name
    retval = []
    daily_tasks.each{|t| retval << t.collect{|id| TrstTask.find(id).name}}
    return retval.flatten
  end
  #
  # @see #table_data
  # @return [Array] other accessible tasks - ids
  def other_tasks
    task_ids['other_tasks']
  end
  #
  # @see #table_data
  # @return [Array] other accessible tasks - names
  def other_tasks_name
    other_tasks.collect{|id| TrstTask.find(id).name}
  end
  # Convenience method for `MVC`'s View part. The returned `Array` contains a `Hash`
  # for each `field`, with the following informations:
  #
  # - `:css`   => info about type of field (`normal,integer,array,relations,localized` etc.);
  # - `:name`  => name of field used when generating the `input` tags `name` attribute;
  # - `:label` => translated label;
  # - `:value` => :) the value of field.
  #
  # More about using provided data **`See Also:`**
  # @see Trst::Haml::Helpers#td_label Helper for labels
  # @see Trst::Haml::Helpers#td_get_value Helper for show values
  # @see Trst::Haml::Helpers#td_put_value Helper for edit values
  # @return [Array] an `Array` of `Hash`-es
  def table_data
    [{:css => "normal",:name => "login_name",:label => I18n.t("trst_user.login_name"),:value => login_name},
     {:css => "normal",:name => "email",:label => I18n.t("trst_user.email"),:value => email},
     {:css => "integer",:name => "permission_lvl",:label => I18n.t("trst_user.permission_lvl"),:value => permission_lvl},
     {:css => "array",:name => "permission_grp",:label => I18n.t("trst_user.permission_grp"),:value => permission_grp},
     {:css => "hash",:name => "settings",:label => I18n.t("trst_user.settings.header"),:value => settings},
     {:css => "relations",:name => "task_ids,daily_tasks",:label => I18n.t("trst_user.daily_tasks"),:value => [daily_tasks_name,daily_tasks.flatten]},
     {:css => "relations",:name => "task_ids,other_tasks",:label => I18n.t("trst_user.other_tasks"),:value => [other_tasks_name,other_tasks]},
     {:css => "datetime",:name => "created_at",:label => I18n.t("trst_task.created_at"),:value => created_at},
     {:css => "datetime",:name => "updated_at",:label => I18n.t("trst_task.updated_at"),:value => updated_at}]
  end

  protected
  # Generate `#user.salt` for new `#user`
  # @return [String] random string for `#user.salt`
  def random_string(len)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newsalt = ""
    1.upto(len) { |i| newsalt << chars[rand(chars.size-1)] }
    return newsalt
  end
  # @return [Boolean] `false` just for safety :)
  def method_missing(m, *args)
    return false
  end
end

