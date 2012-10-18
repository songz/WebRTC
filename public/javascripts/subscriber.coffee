navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia
window.URL = window.URL || window.webkitURL

offer = ""

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

videoSuccess = (localMediaStream) ->
  $('#myVid').attr( 'src', window.URL.createObjectURL(localMediaStream) )
  pc1.addStream(localMediaStream)
  offer = pc1.createOffer({audio:true, video:true})
  pc1.setLocalDescription(pc1.SDP_OFFER, offer)
  channel.trigger("client-offer", {offer: offer.toSdp()})
videoFail = (error) ->
  console.log error

navigator.getUserMedia {video: true}, videoSuccess, videoFail

startStreaming = () ->
  pc1.startIce()

Pusher.log = (message) ->
  console.log message

Pusher.channel_auth_transport = 'jsonp'
Pusher.channel_auth_endpoint = 'http://pusherpresence.herokuapp.com/pusher/auth'
pusher = new Pusher('9e96f2d1617cc3aa954f')
channel = pusher.subscribe('presence-test')
channel.bind 'pusher:subscription_succeeded', ->
  count = channel.members.count

channel.bind "client-answer", (data)->
  pc1.setRemoteDescription( pc1.SDP_ANSWER, new SessionDescription(data.answer) )
  pc1.startIce()
channel.bind "client-offer", (data)->
  console.log "offer triggered"
