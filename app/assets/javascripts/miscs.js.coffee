# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/



# afterLoad = ->
$ ->
    games_table = document.getElementById("misc_table")
    window.setInterval load_misc, 5000 if games_table
    console.log "loaded!"
#     auto_update_miscs()



load_misc = ->
  #$j("#right_scroll img").click()
  # console.log "Hey guy!"
  $.getJSON "miscs.json", (data) ->
    # console.log data
    console.log data["babble"]
    $("#misc_table").prepend("<tr><td>#{data['babble']}</td></tr>")
  return


# window.setInterval load_misc, 5000

# window.auto_update_miscs = () ->
#     $.getJSON "/misc.json", (data) ->




# window.show_book_action_view = (div, height, dialog) ->
#   width = window.innerWidth
#   if typeof






# handler for the 'ready' event

# handler for 'senderconnected' event

# handler for 'senderdisconnected' event

# handler for 'systemvolumechanged' event

# create a CastMessageBus to handle messages for a custom namespace

# handler for the CastMessageBus message event

# display the message from the sender

# inform all senders on the CastMessageBus of the incoming message event
# sender message listener will be invoked

# initialize the CastReceiverManager with an application status message

# utility function to display the text message in the input field
displayText = (text) ->
  console.log text
  document.getElementById("message").innerHTML = text
  window.castReceiverManager.setApplicationState text
  return
window.onload = ->
  cast.receiver.logger.setLevelValue 0
  window.castReceiverManager = cast.receiver.CastReceiverManager.getInstance()
  console.log "Starting Receiver Manager"
  castReceiverManager.onReady = (event) ->
    console.log "Received Ready event: " + JSON.stringify(event.data)
    window.castReceiverManager.setApplicationState "Application status is ready..."
    return

  castReceiverManager.onSenderConnected = (event) ->
    console.log "Received Sender Connected event: " + event.data
    console.log window.castReceiverManager.getSender(event.data).userAgent
    return

  castReceiverManager.onSenderDisconnected = (event) ->
    console.log "Received Sender Disconnected event: " + event.data
    window.close()  if window.castReceiverManager.getSenders().length is 0
    return

  castReceiverManager.onSystemVolumeChanged = (event) ->
    console.log "Received System Volume Changed event: " + event.data["level"] + " " + event.data["muted"]
    return

  window.messageBus = window.castReceiverManager.getCastMessageBus("urn:x-cast:com.google.cast.sample.helloworld")
  window.messageBus.onMessage = (event) ->
    console.log "Message [" + event.senderId + "]: " + event.data
    displayText event.data
    window.messageBus.send event.senderId, event.data
    return

  window.castReceiverManager.start statusText: "Application is starting"
  console.log "Receiver Manager started"
  return