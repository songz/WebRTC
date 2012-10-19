The WebRTC P2P sample app
===========================

## Demo
[http://testwebrtc.herokuapp.com/1350652235]()

## Requirements
Chrome 22.0
Enable PeerConnection
> To Enable PeerConnection, go to browser and type `chrome://flags/`
> Find PeerConnection and enable it, then restart browser

## To Run
Simply to go terminal and run the ruby file. 
`ruby app.rb` or `sinatra app.rb`

## File Description
`Gemfile`, `Gemfile.lock`, and `Procfile` are used to deploy to [heroku](http://heroku.com).  
`resource` folder contains the javascript code written in coffeescript  
`app.rb` is the server code. The only thing it does is generate new rooms and set room_ids  
`views/index.erb` contains the view as well as JavaScript code to get this app working. Documentation is written within the file.  

