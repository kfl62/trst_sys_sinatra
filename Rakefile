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
  task :storekeeper_stats, :unit, :u1, :u2, :y, :m do |t, args|
    require './config/boot'
    u1 = Wstm::User.find_by(login_name: /#{args[:u1]}/)
    u2 = Wstm::User.find_by(login_name: /#{args[:u2]}/)
    sum_out1 = Wstm::Expenditure.pos(args[:unit]).monthly(args[:y].to_i,args[:m].to_i).where(signed_by: u1).sum(:sum_out).round(2)
    sum_out2 = Wstm::Expenditure.pos(args[:unit]).monthly(args[:y].to_i,args[:m].to_i).where(signed_by: u2).sum(:sum_out).round(2)
    wd1 = 0; (1..Date.new(args[:y].to_i,args[:m].to_i,-1).day).each{|d| app = (Wstm::Expenditure.pos(args[:unit]).daily(args[:y].to_i,args[:m].to_i,d).where(signed_by: u1).count rescue 0);wd1 += 1 if app  >0}
    wd2 = 0; (1..Date.new(args[:y].to_i,args[:m].to_i,-1).day).each{|d| app = (Wstm::Expenditure.pos(args[:unit]).daily(args[:y].to_i,args[:m].to_i,d).where(signed_by: u2).count rescue 0);wd2 += 1 if app  >0}
    puts "\nSituația lunară #{args[:y]}-#{args[:m]}, Punct de colectare: #{Wstm::PartnerFirm.pos(args[:unit]).name}"
    puts "\n"
    puts "#{u1.name} - Achiziții #{sum_out1} - Zile lucrate #{wd1} - Media #{(sum_out1/wd1).round(2)}"
    puts "#{u2.name} - Achiziții #{sum_out2} - Zile lucrate #{wd2} - Media #{(sum_out2/wd2).round(2)}"
    puts "\n"
  end
end
