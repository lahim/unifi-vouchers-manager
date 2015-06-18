class VouchersController < ApplicationController
	def index
		@vouchers = Voucher.all
	end

	def show
		@voucher = Voucher.find(params[:id])
	end

	def print
		@voucher = Voucher.find(params[:voucher_id])

		respond_to do |format|
			format.pdf do
				pdf = VoucherPdf.new(@voucher)
				send_data pdf.render, filename: 'voucher.pdf', type: 'application/pdf'
			end
		end
	end

	def new
		@voucher = Voucher.new
	end

	def edit
		@voucher = Voucher.find(params[:id])
	end

	def create
		@voucher = Voucher.new(voucher_params)
		
		if @voucher.save
			redirect_to vouchers_path
		else
			render "new"
		end
	end

	def update
		@voucher = Voucher.find(params[:id])
		
		if @voucher.update(voucher_params)
			redirect_to @voucher
		else
			render "edit"
		end
	end

	def destroy
		@voucher = Voucher.find(params[:id])
		@voucher.destroy

		redirect_to vouchers_path
	end

	private
		def voucher_params
			params.require(:voucher).permit(:code, :note, :used, :info_attributes => [:start_date, :end_date])
		end
end
