

## * * * * * /Users/lahim/Documents/BLStream/Projects/UniFiVoucher/voucherapp/bin/rake voucherapp:validate_vouchers$

namespace :voucherapp do 
	desc 'Creates a init Setting model in database' 
	task :validate_vouchers => :environment do 
		puts "*** Validating all existing vouchers..."

		now = DateTime.now
		puts "now:", now

		VoucherInfo.all.each do |info|
			voucher = info.voucher
			if info.start_date and info.end_date
				if info.start_date < now and info.end_date > now
					voucher.used = 0
				else
					voucher.used = 1
				end
			else
				voucher.used = 1
			end
			voucher.save
		end

		puts "*** Vouchers were validated."
  	end
end
