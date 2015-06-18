class SettingsController < ApplicationController
	def index
		@setting = Setting.first
	end

	def edit
		@setting = Setting.find(params[:id])
	end

	def update
		@setting = Setting.find(params[:id])

		if @setting.update(setting_params)
			redirect_to settings_path
		else
			render 'edit'
		end
	end

	private
		def setting_params
			params.require(:setting).permit(:admin_id, :site_id)
		end
end
