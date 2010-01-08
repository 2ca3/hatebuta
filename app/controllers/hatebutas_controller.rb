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
    @hatebutas = Hatebuta.find(:all, :conditions => ['open_level = ?', true], :order => 'created_at desc', :limit => 5)
#    @bookmarks = Bookmark.find(:all, :conditions => ['is_private = ?', false], :order => 'timestamp desc', :limit => 10) 
    @bookmarks = Bookmark.find(:all, :conditions => ['is_private = ?', false], :order => 'timestamp desc') 

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @hatebutas }
    end
  end

  # GET /hatebutas/1
  # GET /hatebutas/1.xml
  #def show
  #  @hatebuta = Hatebuta.find(params[:id])
  #  respond_to do |format|
  #    format.html # show.html.erb
  #    format.xml  { render :xml => @hatebuta }
  #  end
  #end

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
        @hatebuta.timeline_id = REXML::Document.new(response.body).elements['/response/result/timeline/id'].text
      end

      if @hatebuta.save
        flash[:notice] = 'はてブタの作成が完了しました'
        format.html # create.html.erb
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
#  def destroy
#    @hatebuta = Hatebuta.find(params[:id])
#    @hatebuta.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(hatebutas_url) }
#      format.xml  { head :ok }
#    end
#  end

  # HOOK /favorite2timelines/1
  # HOOK /favorite2timelines/1.xml
  def hook
    if params[:status] == 'add' || params[:status] == 'favorite:add'
      @hatebuta = Hatebuta.find(:first, :conditions => ['hatebuta_key = ?', params[:key]])
      #open('http://www.hatena.ne.jp/users/k2/k2ca3/profile.gif', 'rb') do |f|
      #profile = Base64.encode64(f.binmode.read)
      query_hash = {"timeline_key" => @hatebuta.timeline_key,
                    "timeline_id" => @hatebuta.timeline_id.to_s,
                    "title" => params[:title],
                    "description" => "#{params[:comment]} bookmark by #{params[:username]}",
                    "link" => params[:url],
                    "grade" => params[:count],
                    "start_time" => (Time.now+8*60*60).strftime("%Y-%m-%d %H:%M:%S"),
                    "end_time" => (Time.now+8*60*60).strftime("%Y-%m-%d %H:%M:%S") 
                   }
      query_string = query_hash.map do |key,value|
        "#{key}=#{URI.encode(value)}"
      end.join("&")

      begin
        Net::HTTP.start('api.timeline.nifty.com', 80) do |http|
          http.post('/api/v1/articles/create/',query_string)
        end
      rescue
      else
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
      end
    end
    Net::HTTP.start('gaeo-tkwaves.appspot.com', 80) do |http|
      response = http.get("/guestbook/create?username=#{params[:username]}%20#{URI.encode(params[:title])}%20#{params[:url]}%20#{params[:count]}%20#{params[:status]}%20#{URI.encode(params[:comment])}%20#{params[:is_private]}%20#{params[:key]}&content=#{URI.encode(params[:timestamp])}hogehoge")
      puts response.body
    end
    redirect_to(hatebutas_url)
  end
end
