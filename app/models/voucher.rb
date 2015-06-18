require "date"

class Voucher
  include Mongoid::Document
  store_in collection: "voucher", database: "ace", client: "unifi"

  has_one :info, :class_name => "VoucherInfo", :dependent => :destroy
  accepts_nested_attributes_for :info

  field :code, type: String
  field :create_time, type: Integer, :default => DateTime.now
  field :duration, type: Integer, :default => 1440  # default value is 1 day in minutes
  field :note, type: String
  field :qos_overwrite, type: Mongoid::Boolean, :default => false
  field :quota, type: Integer, :default => 0
  field :used, type: Integer, :default => 0
  field :admin_id, type: String
  field :site_id, type: String

  attr_accessor :create_time, :duration
  after_initialize :generate_token, :voucher_info_initialize
  before_save :update_settings, :validate_voucher, :set_duration

  def is_expired
    self.used == 1
  end

  def create_time=(create_time)
    write_attribute(:create_time, create_time.to_time.to_i)
  end

  def create_time
    Time.at(read_attribute(:create_time))
  end

  def duration=(duration)
    duration = duration.to_i * 24 * 60
    puts "duration:",duration
    write_attribute(:duration, duration)
  end

  def duration
    read_attribute(:duration) / 60 / 24
  end

  def validate_voucher
    now = DateTime.now
    if self.info.start_date and self.info.end_date
      if self.info.start_date <= now and self.info.end_date >= now
        puts "*** Voucher is valid"
        self.used = 0
      else
        puts "now:", now
        puts "start_date:", self.info.start_date
        puts "end_date:", self.info.end_date
        puts "*** Voucher is not valid"
        self.used = 1
      end
    else
      puts "*** Voucher is not valid. Dates are not defined"
      self.used = 1
    end
  end

  private
    def generate_token
      if self.code == nil
        id = self.id.to_s[0..9]
        self.code = "%s-%s" % [id[0..4], id[5..-1]]
      end
    end

    def voucher_info_initialize
      if self.info == nil
        self.info = VoucherInfo.new
      end

      if self.admin_id == nil and self.site_id == nil
        setting = Setting.first
        if setting and setting.admin_id and setting.site_id
          self.admin_id = setting.admin_id
          self.site_id = setting.site_id
        end
      end
    end

    def update_settings
      setting = Setting.first
      if setting and setting.admin_id and setting.site_id
        self.admin_id = setting.admin_id
        self.site_id = setting.site_id
      end
    end

    def set_duration
      self.duration = self.info.end_date - self.info.start_date
    end
end
