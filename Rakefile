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
    books = YAML.load_file File.join(Trst.root,'tmp','seed',"books.yml")
    chapters = YAML.load_file File.join(Trst.root,'tmp','seed',"chapters.yml")
    pages = YAML.load_file File.join(Trst.root,'tmp','seed',"pages.yml")
    tasks = YAML.load_file File.join(Trst.root,'tmp','seed',"tasks.yml")
    users = YAML.load_file File.join(Trst.root,'tmp','seed',"users.yml")
    users.each_pair do |login,attributes|
      Trst::User.find_or_create_by(login_name: login).update_attributes(attributes)
    end
    admin = Trst::User.find_by(login_name: 'kfl62')
    tasks.each_pair do |goal,attributes|
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
          page = chapter.pages.find_or_create_by(slug: slug)
          page.update_attributes(attributes)
          page.tasks << task_edit_page
          page.save
        end if pages[book.slug] && pages[book.slug][chapter.slug]
      end
    end
  end
  desc "Statistics for storekeepers"
  task :storekeeper_stats, :user, :y, :m, :daily do |t, args|
    require './config/boot'
    user = Wstm::User.find_by(login_name: /#{args[:user]}/)
    daily= args[:daily] || "false"
    data = user.work_stats(args[:y].to_i,args[:m].to_i, daily.to_bool) rescue nil
    if user
      if user.has_unit?
        puts "\nSituația lunară #{I18n.localize(Date.new(args[:y].to_i,args[:m].to_i,1), format: "%B, %Y")}, Punct de colectare: #{user.unit.name[1]}"
        puts "\n"
        puts "#{user.name} - Zile lucrate #{data[0]} - Achiziții #{data[1]} - Media #{data[2]}"
        puts "\n"
        if daily.to_bool
          puts "Achizițiile zilnice: \n#{"Data".center(10)} | #{"App".center(4)} | #{"Achitat".center(8)} | #{"Media".center(6)}"
          data[3].each_pair do |k,v|
            puts "#{k.center(10)} | #{v[0].to_s.rjust(4)} | #{("%0.2f" % v[1]).rjust(8)} | #{("%0.2f" % (v[1]/v[0])).rjust(6)}"
          end
          puts "\n"
        end
      else
        puts "\nUtilizatorul nu este gestionar la nici un Punct de lucru!"
        puts "\n"
      end
    else
      puts "\nGestionar/Utilizator inexistent!"
      puts "\n"
    end
  end
end
