class Album < ActiveRecord::Base
	has_attached_file :photo, :styles => { :display => "240x240" }

	validates_attachment_presence :photo
	validates_attachment_size :photo, :less_than => 2.megabytes
	validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
	validate :aspect_ratio

	attr_accessible :title, :info, :fblink, :photo
	validates_presence_of :title, :info, :fblink

	def aspect_ratio
	  	tempfile = photo.queued_for_write[:original]
	  	unless tempfile.nil?
		    if Paperclip::Geometry.from_file(tempfile).width != Paperclip::Geometry.from_file(tempfile).height
		    	self.errors.add(:photo, " must be square!")
		    end
		end
	end
end
