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
      edit_page = Trst::Task.find_by(goal: 'Trst::Page.page')
      sys_admin = Trst::Book.find_by(slug: 'trst_system').chapters.find_by(slug: 'sys_admin')
      sys_admin.pages.each{|p| p.tasks << edit_page; p.save}
      my_page  = Trst::Book.find_by(slug: 'trst_system').chapters.find_by(slug: 'my_page')
      daily_tp  = my_page.pages.find_by(slug: 'daily_tasks')
      daily_tp.tasks << edit_page; daily_tp.save
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
