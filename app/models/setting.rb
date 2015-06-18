class Setting
  include Mongoid::Document
  field :admin_id, type: String
  field :site_id, type: String
end
