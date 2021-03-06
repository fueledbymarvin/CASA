class Event < ActiveRecord::Base
	include ActionView::Helpers
	require 'open-uri'

	has_attached_file :photo, :styles => { :newsletter => "500>", :display => Proc.new { |a| a.dimensions } }
	before_save :destroy_photo?

	validates_attachment_size :photo, :less_than => 2.megabytes
	validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']

	attr_accessible :title, :category, :day, :starttime, :endtime, :location, :subtitle, :info, :priority, :newsuntil, :hassub, :addend, :newsletter, :photo, :photo_delete, :fb, :fbid
	validates_presence_of :title, :info, :category
	validates_presence_of :priority, :newsuntil, :if => :newsletter?
	validates_presence_of :day, :starttime, :location, :unless => :hassub
	validates_presence_of :endtime, :if => :addend
	validates_presence_of :subtitle, :if => :hassub
	validates :title, :length => { :maximum => 50 }
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

	def create_fb(member)
		if self.fbid.nil?
			m = Member.find(member)
			self.fbid = m.facebook.put_connections("me", "events", self.fb_params)["id"]
			self.save

			groups = m.facebook.get_connections("me", "groups")
			casa_id = ""
			groups.each do |group|
				if group["name"] == "Chinese American Students Association (CASA) of Yale"
					casa_id = group["id"]
				end
			end
			members = m.facebook.get_connections(casa_id, "members")
			member_ids = []
			members.each { |member| member_ids << member["id"] }
			m.facebook.put_connections(self.fbid, "invited", users: member_ids.join(","))
		end
	end

	def update_fb(member)
		if self.fbid
			m = Member.find(member)
			m.facebook.graph_call("/#{self.fbid}", self.fb_params, "post")
		end
	end

	def destroy_fb(member)
		if self.fbid
			m = Member.find(member)
			m.facebook.delete_object self.fbid
			self.fbid = nil
			self.save
		end
	end

	def fb_params
		params = { name: self.title, description: self.info }
		if self.hassub
			params[:start_time] = merge_date_time(self.day, Time.new.midnight).to_s.gsub(/(-|\+)\d{2}:\d{2}/, "-04:00")
		else
			params[:start_time] = merge_date_time(self.day, self.starttime).to_s.gsub(/(-|\+)\d{2}:\d{2}/, "-04:00")
			params[:location] = self.location
			if self.addend
				params[:end_time] = merge_date_time(self.day, self.endtime).to_s.gsub(/(-|\+)\d{2}:\d{2}/, "-04:00")
			end
		end
		params.each { |k, v| params[k] = strip_tags(v).gsub(/&nbsp;/, " ") }
		if self.photo.exists?
			img_host = ""
			if Rails.env == "development"
				img_host = "http://localhost:3000"
			end
			picture = Koala::UploadableIO.new(open(img_host + self.photo.url(:display)).path, 'image')
			params[:picture] = picture
		end
		params
	end

	def merge_date_time(date_to_merge, time_to_merge)
		merged_datetime = DateTime.new(date_to_merge.year, date_to_merge.month, date_to_merge.day, time_to_merge.hour, time_to_merge.min, time_to_merge.sec)
	end

	def self.news(date)
		events = []
		self.find(:all, :conditions => ["newsuntil >= ?", date]).map { |event| event.priority }.uniq.sort.reverse.each do |pr| # iterate through all possible priorities
			events = events + self.find(:all, :conditions => ["newsuntil >= ? AND priority = ?", date, pr]).sort_by { |event| event.newsuntil }
		end
		events
	end
end
