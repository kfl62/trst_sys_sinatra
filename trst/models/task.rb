# encoding: utf-8
module Trst
  class Task
    include Mongoid::Document
    include Mongoid::Timestamps
    include ViewHelpers
    field  :name,       localize: true
    field  :title,      localize: true
    field  :help,       localize: true
    field  :haml_path,  type: String,      default: 'default'
    field  :goal,       type: String,      default: 'Model.method'
    field  :rels,       type: String,      default: 'none'

    has_and_belongs_to_many :users,   class_name: 'Trst::User', inverse_of: :tasks

    class << self
      # @todo
      def user_ids(id)
        find(id).user_ids
      end
    end # Class methods

    # @todo
    def action
        goal.split('_').last == 'test' ? 'test' : goal.split('.').last
    end
    # @todo
    def view_users
      user_ids.each_with_object([]){|id,a| u = users.find(id); a << [u.id, u.login_name]}
    end
  end # Task
end # Trst
