class VoucherPdf < Prawn::Document
	def initialize(voucher)
		super()
		@voucher = voucher
		text_content
	end

	def text_content
		y_position = cursor - 50
		bounding_box([100, y_position], :width => 270, :height => 300) do
			text "Voucher code:", size: 15, style: :bold
			text @voucher.code
		end

		bounding_box([300, y_position], :width => 270, :height => 300) do
			text "Expiration date:", size: 15, style: :bold
			text @voucher.info.start_date.strftime("%F")
		end

		y_position = y_position - 50
		bounding_box([100, y_position], :width => 270, :height => 300) do
			text "Note:", size: 15, style: :bold
			text @voucher.note
		end
	end
end
