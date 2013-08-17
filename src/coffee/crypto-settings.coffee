$ ->
  console.log "Loaded settings page"

  $('#add-public-key').click ()->
    key = $('#public-key-to-add').val()
    console.log "Adding pubkey #{key}"
    yes

  $('#add-private-key').click ()->
    key = $('#private-key-to-add').val()
    console.log "Adding private #{key}"
    yes

  $('.remove-private-key').click ()->
    console.log 'Clicked remove private key'
    yes

  $('.remove-public-key').click ()->
    console.log 'Clicked remove public key'
    yes
