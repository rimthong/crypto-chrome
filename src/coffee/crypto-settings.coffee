$ ->
  console.log "Loaded settings page"

  $('#add-public-key').click ()->
    console.log 'Clicked add public key'

  $('#add-private-key').click ()->
    console.log 'Clicked add private key'

  $('.remove-private-key').click ()->
    console.log 'Clicked remove private key'

  $('.remove-public-key').click ()->
    console.log 'Clicked remove public key'
