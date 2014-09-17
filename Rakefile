# encoding: utf-8
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
    Trst::Book.delete_all
    Trst::Task.delete_all
    Trst::User.delete_all
    books = YAML.load_file File.join(Trst.root,'config','seed',"books.yml")
    chapters = YAML.load_file File.join(Trst.root,'config','seed',"chapters.yml")
    pages = YAML.load_file File.join(Trst.root,'config','seed',"pages.yml")
    tasks = YAML.load_file File.join(Trst.root,'config','seed',"tasks.yml")
    users = YAML.load_file File.join(Trst.root,'config','seed',"users.yml")
    users.each_pair do |login,attributes|
      Trst::User.find_or_create_by(login_name: login).update_attributes(attributes)
    end
    admin = Trst::User.find_by(login_name: 'admin')
    tasks.each_pair do |goal,attributes|
      goal = goal.gsub "Mdl::", "#{Trst.firm.models_path[1].titleize}::"
      task = Trst::Task.find_or_create_by(goal: goal)
      task.update_attributes(attributes)
      task.users << admin
      task.save
    end
    task_edit_page = Trst::Task.find_by(goal: 'Trst::Page.page')
    books.each_pair do |slug,attributes|
      book = Trst::Book.find_or_create_by(slug: slug)
      book.update_attributes(attributes)
      chapters[book.slug].each_pair do |slug,attributes|
        chapter = book.chapters.find_or_create_by(slug: slug)
        chapter.update_attributes(attributes)
        pages[book.slug][chapter.slug].each_pair do |slug,attributes|
          page = chapter.pages.find_or_initialize_by(slug: slug)
          page.tasks << task_edit_page
          page.update_attributes(attributes)
        end if pages[book.slug] && pages[book.slug][chapter.slug]
      end
    end
  end
end
