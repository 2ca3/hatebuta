class HatebutasController < ApplicationController
	require 'net/http'
	require 'uri'
  require 'open-uri'
  require 'base64'
  require 'digest/md5'
  require "rexml/document"

	$KCODE = 'UTF-8'
	Net::HTTP.version_1_2   # おまじない
  skip_before_filter :verify_authenticity_token ,:only=>[:hook]

  # GET /hatebutas
  # GET /hatebutas.xml
  def index
    @hatebutas = Hatebuta.all
    @bookmarks = Bookmark.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @hatebutas }
    end
  end

  # GET /hatebutas/1
  # GET /hatebutas/1.xml
  def show
    @hatebuta = Hatebuta.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @hatebuta }
    end
  end

  # GET /hatebutas/new
  # GET /hatebutas/new.xml
  def new
    @hatebuta = Hatebuta.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @hatebuta }
    end
  end

  # GET /hatebutas/1/edit
#  def edit
#    @hatebuta = Hatebuta.find(params[:id])
#  end

  # POST /hatebutas
  # POST /hatebutas.xml
  def create
    @hatebuta = Hatebuta.new(params[:hatebuta])
    @hatebuta.hatebuta_key = Digest::MD5.hexdigest(@hatebuta.timeline_id.to_s + Time.now.to_s)
    respond_to do |format|
      open_level = 1
      open_level = 0 if @hatebuta.open_level
   		Net::HTTP.start('api.timeline.nifty.com', 80) do |http|
  			response = http.post('/api/v1/timelines/create','timeline_key='+@hatebuta.timeline_key+'&title='+URI.encode(@hatebuta.title)+'&description='+URI.encode(@hatebuta.description)+'&open_level='+open_level.to_s+'&label_for_vaxis='+URI.encode('ブックマーク数'))
        puts response.body
        @hatebuta.timeline_id = REXML::Document.new(response.body).elements['/response/result/timeline/id'].text
      end

      if @hatebuta.save
        flash[:notice] = 'Hatebuta was successfully created.'
        format.html { redirect_to(@hatebuta) }
        format.xml  { render :xml => @hatebuta, :status => :created, :location => @hatebuta }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @hatebuta.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /hatebutas/1
  # PUT /hatebutas/1.xml
#  def update
#    @hatebuta = Hatebuta.find(params[:id])
#    respond_to do |format|
#      if @hatebuta.update_attributes(params[:hatebuta])
#        flash[:notice] = 'Hatebuta was successfully updated.'
#        format.html { redirect_to(@hatebuta) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @hatebuta.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # DELETE /hatebutas/1
  # DELETE /hatebutas/1.xml
  def destroy
    @hatebuta = Hatebuta.find(params[:id])
    @hatebuta.destroy

    respond_to do |format|
      format.html { redirect_to(hatebutas_url) }
      format.xml  { head :ok }
    end
  end

    # HOOK /favorite2timelines/1
  # HOOK /favorite2timelines/1.xml
  def hook
    if params[:status] == 'add' || params[:status] == 'favorite:add'
  #	   p params[:username]
  #    p params[:title]
  #    p params[:url]
  #    p params[:count]
  #    p params[:status]
  #    p params[:comment]
  #    p params[:is_private]
  #    p params[:timestamp]
  #    p params[:key]
      @bookmark = Bookmark.new
      @bookmark.username =  params[:username]
      @bookmark.title =  params[:title]
      @bookmark.url =  params[:url]
      @bookmark.count =  params[:count]
      @bookmark.status =  params[:status]
      @bookmark.comment =  params[:comment]
      @bookmark.is_private =  params[:is_private]
      @bookmark.timestamp =  params[:timestamp]
      @bookmark.key =  params[:key]
      @bookmark.save

      if params[:is_private].to_i == 0
        @hatebuta = Hatebuta.find(:first, :conditions => ['hatebuta_key = ?', params[:key]])
        #open('http://www.hatena.ne.jp/users/k2/k2ca3/profile.gif', 'rb') do |f|
          #profile = Base64.encode64(f.binmode.read)
          #puts profile
          Net::HTTP.start('api.timeline.nifty.com', 80) do |http|
            http.post('/api/v1/articles/create/','timeline_key='+@hatebuta.timeline_key+'&timeline_id='+@hatebuta.timeline_id.to_s+'&title='+params[:title]+' bookmark by '+params[:username]+params[:comment][params[:comment].index('['),params[:comment].rindex(']')+1]+'&description='+params[:comment]+'&link='+params[:url]+'&grade='+params[:count]+'&start_time='+Time.now.to_s+'&end_time='+Time.now.to_s)
          end
        #end
        #render response.body
      end
    end
  end
end
