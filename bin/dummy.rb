# To change this template, choose Tools | Templates
# and open the template in the editor.
	require 'net/http'
	require 'uri'
	$KCODE = 'UTF-8'
  #	 wget --post-data 'username=2ca3' http://192.168.0.4:3000/hatebu2timelines/hook
  Net::HTTP.version_1_2   # おまじない
  # http://hatebuta.heroku.com/hatebutas/hook/
  Net::HTTP.start('localhost', 3000) do |http|
  #Net::HTTP.start('hatebuta.heroku.com', 80) do |http|
  #Net::HTTP.start('2ca3.dyndns.org', 80) do |http|
			response = http.post('/hatebutas/hook','username=k2ca3&title='+URI.encode('hoooooooge')+'&url='+URI.encode('http://teiki.saiyo.jp/canon-mj2011/contents/dm_2/index.html')+'&count=300&status=favorite:add&comment='+URI.encode('よく頑張った')+'&is_private=0&key=hoge&timestamp='+URI.encode('2009-12-27T00:48:53 09:00'))
      #response = http.get('/hatebu2timelines/hook')
      #response = http.post('/hatebu2timelines/create/1','')
      puts response.body
      #res.read_body do |str|
      #  @hoge += str
      #end
   end
