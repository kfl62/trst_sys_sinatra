# encoding: utf-8
# ## Scope
#   A module wich includes four {http://www.sinatrarb.com/ Sinatra::Base} sub classes
#   {Trst::Public}, {Trst::System}, {Trst::SystemTsk}  and {Trst::Utils}
#   ...
# @todo document this model
module Trst
  VERSION = "0.1.0"
  @@opt = OpenStruct.new
  class << self
    # @todo
    def opt
      @@opt
    end
    # @todo
    def opt=(v)
      @@opt = v
    end
    # @todo
    def root
      opt.root || TRST_ROOT
    end
    # @todo
    def env
      opt.env || TRST_ENV
    end
    # @todo
    def views
      opt.views || File.join(TRST_ROOT,'trst','views')
    end
    # @todo
    def assets
      opt.assets || File.join(TRST_ROOT,'trst','assets')
    end
    # @todo
    def firm
      file = YAML.load_file File.join(TRST_ROOT,'config','firm.yml')
      OpenStruct.new file['firm']
    end
  end
  # @todo document this method
  def self.server
    Rack::Builder.new do
      use Rack::Session::Cookie, secret: '14743354a2e77700a28a2d0aa8bebee57c42452713d115232b9abafc5dae9a12'
      use Rack::Rewrite do
        rewrite %r{^/\w{2}/utils}, '/utils'
        rewrite %r{^/\w{2}/sys},  '/sys'
        rewrite %r{^/\w{2}/},      '/'
      end

      map '/utils' do
        run Utils
      end
      map '/sys' do
        run System
      end
      map '/' do
        run Public
      end
    end
  end
  autoload :System,               'system'
  autoload :Public,               'public'
  autoload :Utils,                'utils'
  autoload :Assets,               'assets'
end
