# encoding: utf-8
module Trst
  class User
    include Mongoid::Document
    include Mongoid::Timestamps
    include ViewHelpers

    attr_accessor :password, :password_confirmation

    field :login_name,      type: String
    field :name,            type: String
    field :email,           type: String
    field :hashed_password, type: String
    field :last_login,      type: Time
    field :access_lvl,      type: Integer,       default: 3
    field :access_grp,      type: Array,         default: ['public']

    has_and_belongs_to_many :tasks,     class_name: 'Trst::Task', inverse_of: :users

    # Validations
    validates_uniqueness_of :login_name
    validates_length_of     :email,     :within => 10..100
    validates_uniqueness_of :email,     :case_sensitive => false
    validates_format_of     :email,     :with => /(\A(\s*)\Z)|(\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z)/i
    validates_length_of     :password,  :within => 4..40, :if => :password_required

    before_save :encrypt_password, :if => :password_required

    class << self
      # Authentication based on name and password
      # @param [String] login_name User name
      # @param [String] password User password
      # @return [User] returns nil if no user with `login_name`, or password
      #   doesn't match
      def authenticate(login_name, password)
        current_user = find_by(login_name: login_name) if login_name.present?
        current_user && current_user.has_password?(password) ? current_user : nil
      end
      # @todo
      def task_ids(id)
        find(id).task_ids
      end
    end # Class methods
    # Verify `hashed_password`
    # @return [Boolean]
    def has_password?(password)
      ::BCrypt::Password.new(hashed_password) == password
    end
    # `true` if `#user` has admin rights
    # @return [Boolean]
    def admin?
      self.access_lvl == -1 || self.access_grp.include?('admin')
    end
    # @todo
    def view_tasks
      task_ids.each_with_object([]){|id,a| t = tasks.find(id); a << [t.id, t.name]}
    end
    protected
    # Generate encrypted password
    # @return [String] random string for `#user.salt`
    def encrypt_password
      self.hashed_password = ::BCrypt::Password.create(self.password)
    end
    # @todo
    # Document this method
    def password_required
      hashed_password.blank? || self.password.present?
    end
    # @return [Boolean] `false` just for safety :)
    def method_missing(m, *args)
      return false
    end
  end
end