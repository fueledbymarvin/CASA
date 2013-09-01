class SlidesController < ApplicationController
  before_filter :authenticate

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
