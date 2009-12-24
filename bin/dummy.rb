# To change this template, choose Tools | Templates
# and open the template in the editor.
	require 'net/http'
	require 'uri'
	$KCODE = 'UTF-8'
  #	 wget --post-data 'username=2ca3' http://192.168.0.4:3000/hatebu2timelines/hook
  Net::HTTP.version_1_2   # おまじない
  Net::HTTP.start('localhost', 3000) do |http|
  #Net::HTTP.start('2ca3.dyndns.org', 80) do |http|
			response = http.post('/hatebutas/hook','username=k2ca3&title='+URI.encode('タイトル2')+'&url='+URI.encode('http://2ca3.dyndns.org')+'&count=300&status=favorite:add&comment='+URI.encode('[これはすごい]よく頑張った')+'&is_private=0&key=ab9d61168a8ce9c8269ea6258d3eee70')
      #response = http.get('/hatebu2timelines/hook')
      #response = http.post('/hatebu2timelines/create/1','')
      puts response.body
      #res.read_body do |str|
      #  @hoge += str
      #end
   end
