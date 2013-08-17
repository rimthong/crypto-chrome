$ ->
  engine = cryptochrome()
  console.log "Loaded settings page"

  keys = read_storage null

  $('#add-public-key').click ()->
    key = $('#public-key-to-add').val()
    master_password = prompt "Master password to add private key"
    engine.add_public_key_from_armored master_password, key, (err) ->
      console.log err

    console.log "Adding pubkey #{key}"
    yes

  $('#add-private-key').click ()->
    key = $('#private-key-to-add').val()
    master_password = prompt "Master password to add private key"
    engine.add_private_key_from_armored master_password, key, (err) ->
      console.log err
    console.log "Adding private #{key}"
    yes

  $('.remove-private-key').click ()->
    console.log 'Clicked remove private key'
    yes

  $('.remove-public-key').click ()->
    console.log 'Clicked remove public key'
    yes

read_storage = (master_password) ->
  storage = window.localStorage

  if not (storage['crypto-chrome-pub'] or storage['crypto-chrome-priv'])
    if not master_password
      master_password = prompt "Master password to initialize the storage"
    if not storage['crypto-chrome-pub']
      storage['crypto-chrome-pub'] = sjcl.encrypt(master_password, JSON.stringify([]))
    if not storage['crypto-chrome-priv']
      storage['crypto-chrome-priv'] = sjcl.encrypt(master_password, JSON.stringify([]))
  else
    if not master_password
      master_password = prompt "Master password to retrieve keys"
    try
      pub_keys = JSON.parse(sjcl.decrypt master_password, storage['crypto-chrome-pub'])
      priv_keys = JSON.parse(sjcl.decrypt master_password, storage['crypto-chrome-priv'])
    catch e
      alert "Failed to decrypt storage"
      throw e

  return [pub_keys, priv_keys]
