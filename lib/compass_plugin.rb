# encoding: utf-8

# Enables support for Compass, a stylesheet authoring framework based on SASS.
# See http://compass-style.org/ for more details.
module CompassInitializer
  def self.registered(app)
    require 'sass/plugin/rack'

    Compass.configuration do |config|
      config.project_path = Trst.root
      config.sass_dir = "trst/assets/stylesheets"
      config.project_type = :stand_alone
      config.http_path = "/"
      config.css_dir = "public/stylesheets"
      config.images_dir = "public/images"
      config.javascripts_dir = "public/javascripts"
      config.output_style = :normal # compressed
      config.sass_options = {cache_location: "./tmp/sass-cache"}
    end

    Compass.configure_sass_plugin!
    Compass.handle_configuration_change!

    app.use Sass::Plugin::Rack
  end
end
