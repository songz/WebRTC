navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia
window.URL = window.URL || window.webkitURL

# Initialize Peer Connection
iceCallback1 = ->
  console.log "iceCallback"
pc1 = new webkitPeerConnection00("STUN stun.l.google.com:19302", iceCallback1)

onRemoteStreamAdded = (event) ->
  url = webkitURL.createObjectURL(event.stream)
  $('#otherVid').attr('src', url)
  console.log "======"
  console.log url
  console.log "======"
pc1.onaddstream = onRemoteStreamAdded

offer = ""

# get Video Media
videoSuccess = (localMediaStream) ->
  $('#myVid').attr( 'src', window.URL.createObjectURL(localMediaStream) )
  pc1.addStream(localMediaStream)
videoFail = (error) ->
  console.log error
navigator.getUserMedia {video: true}, videoSuccess, videoFail

# Pusher set up for client events
Pusher.log = (message) ->
  console.log message
Pusher.channel_auth_transport = 'jsonp'
Pusher.channel_auth_endpoint = 'http://pusherpresence.herokuapp.com/pusher/auth'
pusher = new Pusher('9e96f2d1617cc3aa954f')
channel = pusher.subscribe('presence-test')
channel.bind "client-offer", (data)->
  # When I receive offer, I can now set my local/remote description
  answer = pc1.createAnswer( data.offer, {has_audio:true, has_video:true})
  console.log answer
  pc1.setRemoteDescription( pc1.SDP_OFFER, new SessionDescription(data.offer) )
  console.log "remote description has been set"
  pc1.setLocalDescription( pc1.SDP_ANSWER, answer )
  console.log "Local Description answer has been set"
  channel.trigger("client-answer", {answer: answer.toSdp()})
  pc1.startIce()
