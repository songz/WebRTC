navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia
window.URL = window.URL || window.webkitURL

offer = ""
count = 0

iceCallback1 = (candidate, b)->
  if (candidate)
    channel.trigger("client-signal", {label:candidate.label, candidate:candidate.toSdp()})
pc1 = new webkitPeerConnection00 "STUN stun.l.google.com:19302", iceCallback1

onRemoteStreamAdded = (event) ->
  url = webkitURL.createObjectURL(event.stream)
  $('#otherVid').attr('src', url)
pc1.onaddstream = onRemoteStreamAdded

videoSuccess = (localMediaStream) ->
  $('#myVid').attr( 'src', window.URL.createObjectURL(localMediaStream) )
  pc1.addStream(localMediaStream)
  if count > 1
    console.log count
    console.log "I'm last guy in the house"
    offer = pc1.createOffer({video:true, audio:true})
    pc1.setLocalDescription(pc1.SDP_OFFER, offer)
    channel.trigger("client-offer", {offer: offer.toSdp()})
videoFail = (error) ->
  console.log error

navigator.getUserMedia {video: true, audio:true}, videoSuccess, videoFail

startStreaming = () ->
  pc1.startIce()

Pusher.channel_auth_transport = 'jsonp'
Pusher.channel_auth_endpoint = 'http://pusherpresence.herokuapp.com/pusher/auth'
pusher = new Pusher('9e96f2d1617cc3aa954f')
channel = pusher.subscribe('presence-test')
channel.bind 'pusher:subscription_succeeded', ->
  count = channel.members.count

channel.bind "client-answer", (data)->
  console.log "answer received"
  pc1.setRemoteDescription( pc1.SDP_ANSWER, new SessionDescription(data.answer) )
  pc1.startIce()
channel.bind "client-offer", (data)->
  # When I receive offer, I can now set my local/remote description
  console.log "offer received"
  answer = pc1.createAnswer( data.offer, {has_audio:true, has_video:true})
  pc1.setRemoteDescription( pc1.SDP_OFFER, new SessionDescription(data.offer) )
  pc1.setLocalDescription( pc1.SDP_ANSWER, answer )
  channel.trigger("client-answer", {answer: answer.toSdp()})
  pc1.startIce()
channel.bind "client-signal", (data)->
  candidate = new IceCandidate( data.label, data.candidate )
  pc1.processIceMessage( candidate )
