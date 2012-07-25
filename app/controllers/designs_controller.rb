class DesignsController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:index, :show]
  before_filter :authenticate_admin!, :only => [:edit, :update]
  
  def constrvct
    @textures = Texture.find(:all, :limit => 21, :order=> 'created_at desc')
    @designs = Design.find(:all, :limit => 20, :order=> 'created_at desc')
  end
  
  # GET /designs
  # GET /designs.json
  def index
    #@designs = Design.all
    @designs = Design.find(:all, :limit => 100, :order=> 'created_at desc')
    
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @designs }
    end
  end

  # GET /designs/1
  # GET /designs/1.json
  def show
    @design = Design.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @design }
    end
  end

  # GET /designs/new
  # GET /designs/new.json
  def new
    #@textures = Texture.find(:all, :limit => 21, :order=> 'created_at desc')
    @user = current_user
    @textures = Texture.find(:all, :conditions => ['user_id=?', 11], :limit => 21, :order=> 'created_at desc')
    @designs = Design.find(:all, :limit => 20, :order=> 'created_at desc')
    
    @design = Design.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @design }
    end
  end

  # GET /designs/1/edit
  def edit
    @design = Design.find(params[:id])
  end

  # POST /designs
  # POST /designs.json
  def create
    @design = Design.new(params[:design])
    @design.user = current_user
    
    temp_file_name = Rails.root.join('tmp', "preview#{@design.texture_id}.png")
    temp_front_file_name = Rails.root.join('tmp', "front_texture_#{@design.texture_id}.png")
    temp_back_file_name = Rails.root.join('tmp', "back_texture_#{@design.texture_id}.png")
    
    
    File.open(temp_file_name, 'wb') do |f|
      f.write Base64.decode64 @design.image_data.gsub(/^data:image\/(png|jpg)\;base64,/, "")
    end
    
    File.open(temp_front_file_name, 'wb') do |f|
      f.write Base64.decode64 @design.front_texture_data.gsub(/^data:image\/(png|jpg)\;base64,/, "")
    end
    
    File.open(temp_back_file_name, 'wb') do |f|
      f.write Base64.decode64 @design.back_texture_data.gsub(/^data:image\/(png|jpg)\;base64,/, "")
    end
    
    @design.preview = File.open(temp_file_name)
    @design.front_texture = File.open(temp_front_file_name)
    @design.back_texture = File.open(temp_back_file_name)

    respond_to do |format|
      if @design.save
        format.html { redirect_to @design, :notice => 'Design was successfully created.' }
        format.json { render :json => @design, :status => :created, :location => @design }
      else
        format.html { render :action => "new" }
        format.json { render :json => @design.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /designs/1
  # PUT /designs/1.json
  def update
    @design = Design.find(params[:id])

    respond_to do |format|
      if @design.update_attributes(params[:design])
        format.html { redirect_to @design, :notice => 'Design was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @design.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /designs/1
  # DELETE /designs/1.json
  def destroy
    @design = Design.find(params[:id])
    @design.destroy

    respond_to do |format|
      format.html { redirect_to current_user }
      format.json { head :no_content }
    end
  end
end
