class VoucherInfo
  include Mongoid::Document
  belongs_to :voucher

  field :start_date, type: Date, :default => DateTime.now
  field :end_date, type: Date, :default => DateTime.now
end
