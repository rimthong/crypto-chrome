$ ->
  console.log "I'm in GMail, and I have JQuery ho ho ho."

  chrome.runtime.sendMessage {status: 'ready'}, (response) ->
    console.log "Server replied with response: #{response.message}"
