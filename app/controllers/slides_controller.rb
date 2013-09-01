class SlidesController < ApplicationController
  before_filter :authenticate

  # GET /slides/new
  # GET /slides/new.json
  def new
    @slide = slide.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @slide }
    end
  end

  # POST /slides
  # POST /slides.json
  def create
    @slide = slide.new(params[:slide])

    respond_to do |format|
      if @slide.save
        format.html { redirect_to "/slides", notice: 'slide was successfully created.' }
        format.json { render json: @slide, status: :created, location: @slide }
      else
        format.html { render action: "new" }
        format.json { render json: @slide.errors, status: :unprocessable_entity }
      end
    end
  end

  def index
    @slides = Slide.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @slides }
    end
  end

  # GET /slides/1/edit
  def edit
    @slide = Slide.find(params[:id])
  end

  # PUT /slides/1
  # PUT /slides/1.json
  def update
    @slide = Slide.find(params[:id])

    respond_to do |format|
      if @slide.update_attributes(params[:slide])
        format.html { redirect_to "/slides", notice: 'slide was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @slide.errors, status: :unprocessable_entity }
      end
    end
  end
end
