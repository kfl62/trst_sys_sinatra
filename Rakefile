desc "Initialize bundle"
task :init do
  `bundle install --path .bundle --binstubs .bundle/bin`
end
desc "Irb with DB environment loaded"
task :console do
  require './config/boot'
  require "irb"
  ARGV.clear
  IRB.start
end
namespace :db do
  desc "Seed data for Trst"
  task :seed do
    require './config/boot'
    Trst::Book.destroy_all
    Trst::Task.destroy_all
    Trst::User.destroy_all
    %w{ro en hu}.each do |lang|
      I18n.locale = lang.to_sym
      books = YAML.load_file File.join(Trst.root,'tmp','seed',"books.yml")
      chapters = YAML.load_file File.join(Trst.root,'tmp','seed',"chapters.yml")
      pages = YAML.load_file File.join(Trst.root,'tmp','seed',"pages.yml")
      tasks = YAML.load_file File.join(Trst.root,'tmp','seed',"tasks.yml")
      users = YAML.load_file File.join(Trst.root,'tmp','seed',"users.yml")
      books[lang].each_pair do |slug,attributes|
        book = Trst::Book.find_or_create_by(slug: slug)
        book.update_attributes(attributes)
        chapters[lang][book.slug].each_pair do |slug,attributes|
          chapter = book.chapters.find_or_create_by(slug: slug)
          chapter.update_attributes(attributes)
          pages[lang][book.slug][chapter.slug].each_pair do |slug,attributes|
            chapter.pages.find_or_create_by(slug: slug).update_attributes(attributes)
          end if pages[lang][book.slug] && pages[lang][book.slug][chapter.slug]
        end
      end
      tasks[lang].each_pair do |goal,attributes|
        Trst::Task.find_or_create_by(goal: goal).update_attributes(attributes)
      end
      users.each_pair do |login,attributes|
        Trst::User.find_or_create_by(login_name: login).update_attributes(attributes)
      end
      admin = Trst::User.find_by(login_name: 'kfl62')
      Trst::Task.each{|t| t.users << admin; t.save}
      sys_admin = Trst::Book.find_by(slug: 'trst_system').chapters.find_by(slug: 'sys_admin')
      edit_page = Trst::Task.find_by(goal: 'Trst::Page.page')
      sys_admin.pages.each{|p| p.tasks << edit_page; p.save}
    end
  end
end
