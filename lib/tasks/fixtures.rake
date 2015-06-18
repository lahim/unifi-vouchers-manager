
namespace :db do 
  namespace :fixtures do 
    desc 'Creates a init Setting model in database' 
    task :create_settings => :environment do 
    	setting = Setting.first
    	if setting == nil
    		puts '*** Settings is going to be created...'
    		setting = Setting.new
      		setting.save
      		puts '*** Settings were created successfully.'
      	else
      		puts '*** Settigns already exist in database.'
      	end
    end 
  end 
end
