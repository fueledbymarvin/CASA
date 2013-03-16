class Member < ActiveRecord::Base
	has_attached_file :photo, :styles => { :display => Proc.new { |a| a.dimensions } }

	validates_attachment_presence :photo
	validates_attachment_size :photo, :less_than => 2.megabytes
	validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
	validate :aspect_ratio

	attr_accessible :name, :position, :college, :gradyear, :major, :email, :blurb, :collegeshort, :photo
	validates_presence_of :name, :position, :college, :gradyear, :major, :email, :blurb

	def collegeshort
		case self.college
		when "Berkeley"
			"BK"
		when "Branford"
			"BR"
		when "Calhoun"
			"CC"
		when "Davenport"
			"DC"
		when "Ezra Stiles"
			"ES"
		when "Jonathan Edwards"
			"JE"
		when "Morse"
			"MC"
		when "Pierson"
			"PC"
		when "Saybrook"
			"SY"
		when "Silliman"
			"SM"
		when "Timothy Dwight"
			"TD"
		when "Trumbull"
			"TC"
		end
	end

	def dimensions
	    if self.position == "Co-President"
	    	"410x410"
	    else
	    	"190x190"
	    end
	end

	def aspect_ratio
	  	tempfile = photo.queued_for_write[:original]
	  	unless tempfile.nil?
		    if Paperclip::Geometry.from_file(tempfile).width != Paperclip::Geometry.from_file(tempfile).height
		    	self.errors.add(:photo, " must be square!")
		    end
		end
	end
end
