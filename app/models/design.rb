class Design < ActiveRecord::Base
  belongs_to :form
  belongs_to :texture
  belongs_to :user
  attr_accessible :form_id, :texture_id, :image_data, :title, :description, :preview
  attr_accessor :image_data
  mount_uploader :preview, ImageUploader
  
=begin
  has_attached_file :preview, :styles => { :thumb => "200x200>", :thumb => "100x100#" },
  :storage => :filesystem,
  :path => "public/designs/:id/:design_preview_:id.:extension",
  :url => "/designs/:id/:basename_:id.:extension"
=end
end
