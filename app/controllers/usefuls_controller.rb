class UsefulsController < ApplicationController
  # GET /usefuls
  # GET /usefuls.json
  def index
    @usefuls = Useful.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @usefuls }
    end
  end

  # GET /usefuls/1
  # GET /usefuls/1.json
  def show
    @useful = Useful.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @useful }
    end
  end

  # GET /usefuls/new
  # GET /usefuls/new.json
  def new
    @useful = Useful.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @useful }
    end
  end

  # GET /usefuls/1/edit
  def edit
    @useful = Useful.find(params[:id])
  end

  # POST /usefuls
  # POST /usefuls.json
  def create
    @usefulable_obj = Useful.create_useful(params)
    @useful = @usefulable_obj.usefuls.build(params[:useful])
    current_user.add_points(2)
    respond_to do |format|
      if @useful.save
        format.html { redirect_to @useful, notice: 'Useful was successfully created.' }
        format.json { render json: @useful, status: :created, location: @useful }
      else
        format.html { render action: "new" }
        format.json { render json: @useful.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /usefuls/1
  # PUT /usefuls/1.json
  def update
    @useful = Useful.find(params[:id])

    respond_to do |format|
      if @useful.update_attributes(params[:useful])
        format.html { redirect_to @useful, notice: 'Useful was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @useful.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /usefuls/1
  # DELETE /usefuls/1.json
  def destroy
    @useful = Useful.find(params[:id])
    @useful.destroy

    respond_to do |format|
      format.html { redirect_to usefuls_url }
      format.json { head :no_content }
    end
  end
end
