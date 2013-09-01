class Slide < ActiveRecord::Base
	attr_accessible :photo

	has_attached_file :photo, :styles => { :display => "640x360" }

	validates_attachment_presence :photo
	validates_attachment_size :photo, :less_than => 2.megabytes
	validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
	validate :aspect_ratio

	def aspect_ratio
	  	tempfile = photo.queued_for_write[:original]
	  	unless tempfile.nil?
		    if Paperclip::Geometry.from_file(tempfile).width / 16 * 9 != Paperclip::Geometry.from_file(tempfile).height
		    	self.errors.add(:photo, " must be 16:9 widescreen aspect ratio!")
		    end
		end
	end
end
