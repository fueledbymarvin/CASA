class EventsController < ApplicationController

  before_filter :authenticate, :except => [:index, :list, :photos, :show]

  # GET /events
  # GET /events.json
  def index
    newsdate = Date.today;
    @events = Event.find(:all, :conditions => ["newsuntil >= ?", newsdate], :order => "priority DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  def list
    @events = Event.all(:order => 'created_at DESC')

    respond_to do |format|
      format.html # list.html.erb
      format.json { render json: @events }
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
    @events = Event.all(:order => 'created_at DESC')

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
    @message = params[:message]

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
    @event.destroy

    respond_to do |format|
      format.html { redirect_to '/admin/manage' }
      format.json { head :no_content }
    end
  end
end
