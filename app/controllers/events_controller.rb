class EventsController < ApplicationController

  before_filter :authenticate, :except => [:index, :list, :photos, :show, :more]

  # GET /events
  # GET /events.json
  def index
    newsdate = Date.today;
    @events = Event.find(:all, :conditions => ["newsuntil >= ?", newsdate], :order => "priority DESC")
    @slides = Slide.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  def list
    categories = ["All", "News", "Social", "Cultural", "Community", "Political"]
    @events = {}
    @totals = {}
    categories.each do |c|
      if c == "All"
        @totals[c] = Event.all.count
      else
        @totals[c] = Event.where(category: c).count
      end
    end
    categories.each do |c|
      if c == "All"
        @events[c] = @totals[c] > 5 ? Event.all(order: 'created_at DESC')[0...5] : Event.all(order: 'created_at DESC')
      else
        @events[c] = @totals[c] > 5 ? Event.where(category: c).order('created_at DESC')[0...5] : Event.where(category: c).order('created_at DESC')
      end
    end

    respond_to do |format|
      format.html # list.html.erb
      format.json { render json: @events }
    end
  end

  def more
    pos = Integer(params[:pos])
    category = params[:category]
    if category == "All"
      total = Event.all.count
      events = pos + 5 >= total ? Event.all(:order => 'created_at DESC')[pos...total] : Event.all(:order => 'created_at DESC')[pos...(pos + 5)]
    else
      total = Event.where(category: category).count
      events = pos + 5 >= total ? Event.where(category: category).order('created_at DESC')[pos...total] : Event.where(category: category).order('created_at DESC')[pos...(pos + 5)]
    end
    dates = events.map do |event|
      temp = {}
      temp["month"] = event.day.strftime("%b").upcase
      temp["day"] = event.day.strftime("%d")
      if !event.hassub
        temp["date"] = event.day.strftime("%A, %B %e, %Y. ")
        temp["time"] = event.addend? ? event.starttime.strftime("%l:%M%p").downcase + " - " + event.endtime.strftime("%l:%M%p.").downcase : event.starttime.strftime("%l:%M%p.").downcase
      end
      temp
    end
    photos = events.map do |event|
      temp = {}
      temp["has"] = event.photo?
      if event.photo?
        temp["full"] = event.photo.url
        temp["display"] = event.photo.url(:display)
      end
      temp
    end

    respond_to do |format|
      format.json { render layout: false, json: { events: events, total: total, dates: dates, photos: photos } }
    end
  end

  def admin
    @events = Event.all

    respond_to do |format|
      format.html # admin.html.erb
      format.json { render json: @events }
    end
  end

  def manage
    @events = Event.paginate(:page => params[:page], :per_page => 5).order('created_at DESC')

    respond_to do |format|
      format.html # manage.html.erb
      format.json { render json: @events }
    end
  end

  def newsform
    @events = Event.all

    respond_to do |format|
      format.html # newsform.html.erb
      format.json { render json: @events }
    end
  end

  def newsletter
    newsdate = Date.civil(params[:newsdate][:year].to_i, params[:newsdate][:month].to_i, params[:newsdate][:day].to_i)
    @events = Event.find(:all, :conditions => ["newsuntil >= ?", newsdate], :order => "priority DESC")
    @message = params[:addendum] ? params[:message] : "This is your weekly newsletter for the week of #{newsdate.strftime("%B %e, %Y")}. " + params[:message]
    if params[:commit] == "Send"
      Newsletter.weekly(@events, @message, newsdate, params[:addendum]).deliver
    end
    render :layout => false
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        if params[:event][:fb] == "1"
          @event.create_fb(session[:member_id])
        end
        format.html { redirect_to '/admin/manage', notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        if params[:event][:fb] == "1" && params[:fb_prev] == "false"
          @event.create_fb(session[:member_id])
        elsif params[:event][:fb] == "1" && params[:fb_prev] == "true"
          @event.update_fb(session[:member_id])
        elsif params[:event][:fb] == "0" && params[:fb_prev] == "true"
          @event.destroy_fb(session[:member_id])
        end
        format.html { redirect_to '/admin/manage', notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    if @event.fbid
      @event.destroy_fb(session[:member_id])
    end
    @event.destroy

    respond_to do |format|
      format.html { redirect_to '/admin/manage' }
      format.json { head :no_content }
    end
  end
end
