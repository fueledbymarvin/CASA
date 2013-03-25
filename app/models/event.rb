class Event < ActiveRecord::Base
	has_attached_file :photo, :styles => { :newsletter => "400>", :display => Proc.new { |a| a.dimensions } }
	before_save :destroy_photo?

	validates_attachment_size :photo, :less_than => 2.megabytes
	validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']

	attr_accessible :title, :category, :day, :starttime, :endtime, :location, :subtitle, :info, :priority, :newsuntil, :hassub, :addend, :newsletter, :photo, :photo_delete
	validates_presence_of :title, :info, :category
	validates_presence_of :priority, :newsuntil, :if => :newsletter?
	validates_presence_of :day, :starttime, :location, :unless => :hassub
	validates_presence_of :endtime, :if => :addend
	validates_presence_of :subtitle, :if => :hassub
	validates :title, :length => { :maximum => 25 }
	after_initialize :init

	def init
		self.day ||= Date.today
	end

	def dimensions
	  tempfile = photo.queued_for_write[:original]
	  unless tempfile.nil?
	    if Paperclip::Geometry.from_file(tempfile).horizontal?
	    	"640x480>"
	    else
	    	"480x640>"
	    end
	  end
	end

  def photo_delete
    @photo_delete ||= "0"
  end

  def photo_delete=(value)
    @photo_delete = value
  end

  def destroy_photo?
    self.photo.clear if @photo_delete == "1"
  end

end