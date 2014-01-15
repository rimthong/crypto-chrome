$ ->
  engine = cryptochrome()

  $('#button-submit-add-public-key').click ()->
    $('#modal-add-public-key').modal('hide')
    password = $('#input-add-public-key-password').val()
    key = $('#input-add-public-key-key').val()
    $('#input-add-public-key-password').val('')
    $('#input-add-public-key-key').val('')
    addPublicKey(password, key)

  $('#form-add-public-key').submit ()->
    event.preventDefault()
    $('#modal-add-public-key').modal('hide')
    password = $('#input-add-public-key-password').val()
    key = $('#input-add-public-key-key').val()
    $('#input-add-public-key-password').val('')
    $('#input-add-public-key-key').val('')
    addPublicKey(password, key)

  $('.button-close-add-public-key').click ()->
    $('#modal-add-public-key').modal('hide')

  $('#button-submit-add-private-key').click ()->
    $('#modal-add-private-key').modal('hide')
    password = $('#input-add-private-key-password').val()
    key = $('#input-add-private-key-key').val()
    $('#input-add-private-key-password').val('')
    $('#input-add-private-key-key').val('')
    addPrivateKey(password, key)

  $('#form-add-private-key').submit ()->
    event.preventDefault()
    $('#modal-add-private-key').modal('hide')
    password = $('#input-add-private-key-password').val()
    key = $('#input-add-private-key-key').val()
    $('#input-add-private-key-password').val('')
    $('#input-add-private-key-key').val('')
    addPrivateKey(password, key)

  $('.button-close-add-private-key').click ()->
    $('#modal-add-private-key').modal('hide')

  $('#button-remove-private-key').click ()->
    $('#modal-remove-private-key').modal('hide')
    password = $('#input-remove-private-key-password').val()
    index = $('#private-key-to-remove-index').val()
    $('#input-remove-private-key-password').val('')
    $('#private-key-to-remove-index').val('')
    removePrivateKey(password, index)

  $('#form-remove-private-key').submit ()->
    event.preventDefault()
    $('#modal-remove-private-key').modal('hide')
    password = $('#input-remove-private-key-password').val()
    index = $('#private-key-to-remove-index').val()
    $('#input-remove-private-key-password').val('')
    $('#private-key-to-remove-index').val('')
    removePrivateKey(password, index)

  $('.button-close-remove-private-key').click ()->
    $('#modal-remove-private-key').modal('hide')

  $('#button-remove-public-key').click ()->
    $('#modal-remove-public-key').modal('hide')
    password = $('#input-remove-public-key-password').val()
    index = $('#public-key-to-remove-index').val()
    $('#input-remove-public-key-password').val()
    $('#public-key-to-remove-index').val()
    removePublicKey(password, index)

  $('#form-remove-public-key').submit ()->
    event.preventDefault()
    $('#modal-remove-public-key').modal('hide')
    password = $('#input-remove-public-key-password').val()
    index = $('#public-key-to-remove-index').val()
    $('#input-remove-public-key-password').val()
    $('#public-key-to-remove-index').val()
    removePublicKey(password, index)

  $('.button-close-remove-public-key').click ()->
    $('#modal-remove-public-key').modal('hide')

  $('#button-confirm-enter-master-password').click ()->
    password = $('#input-entered-master-password').val()
    $('#modal-enter-master-password').modal('hide')
    read_keys(password)

  $('#form-enter-master-password').submit ()->
    event.preventDefault()
    password = $('#input-entered-master-password').val()
    read_keys(password)
    $('#modal-enter-master-password').modal('hide')

  $('.button-close-enter-master-password').click ()->
    $('#modal-enter-master-password').modal('hide')

  $('#button-confirm-initialize-master-password').click ()->
    password = $('#input-initialized-master-password').val()
    $('#modal-initialize-master-password').modal('hide')
    read_keys(password)

  $('#form-initialize-master-password').submit ()->
    event.preventDefault()
    password = $('#input-initialized-master-password').val()
    $('#modal-initialize-master-password').modal('hide')
    read_keys(password)

  $('.button-close-enter-master-password').click ()->
    $('#modal-initialize-master-password').modal('hide')

  read_keys = (master_password) ->
    if not master_password
      storage = window.localStorage
      if not (storage['crypto-chrome-pub'] or storage['crypto-chrome-priv'])
        #Initialize popup
        $('#modal-initialize-master-password').modal()
      else
        #Master password popup
        $('#modal-enter-master-password').modal()
    else
      keys = read_storage master_password, engine
      pub_keys = keys[0]
      priv_keys = keys[1]

      $("#public tbody, #private tbody").empty()
      if pub_keys and pub_keys.length > 0
        i = 0
        for key in pub_keys
          name = openpgp_encoding_html_encode(key[0].userIds[0].text)
          hash = CryptoJS.MD5(key[0].data)
          $("#public tbody").append """
             <tr>
               <td>#{i}</td>
               <td><img src='http://www.gravatar.com/avatar/#{hash}?d=identicon&s=40' /></td>
               <td>#{name}</td>
               <td>
                 <button class='btn btn-danger btn-small remove-public-key' data-index='#{i}' data-name='#{name}'>
                   <i class='icon-minus'></i> Remove
                 </button>
               </td>
             </tr>
            """
          i++

      if priv_keys and priv_keys.length > 0
        i = 0
        for key in priv_keys
          name = openpgp_encoding_html_encode(key[0].userIds[0].text)
          hash = CryptoJS.MD5(key[0].data)
          $("#private tbody").append """
            <tr>
              <td>#{i}</td>
              <td><img src='http://www.gravatar.com/avatar/#{hash}?d=identicon&s=40' /></td>
              <td>#{name}</td>
              <td>
                <button class='btn btn-danger btn-small remove-private-key' data-index='#{i}' data-name='#{name}'>
                  <i class='icon-minus'></i> Remove
                </button>
              </td>
            </tr>"
            """
          i++

  read_keys()

  $('#add-public-key').click ->
    $('#modal-add-public-key').modal('show')

  addPublicKey = (master_password, key)->
    engine.add_public_key_from_armored master_password, key, (err) ->
      if err
        console.log err
      else
        read_keys(master_password)
    yes

  $('#add-private-key').click ->
    $('#modal-add-private-key').modal('show')

  addPrivateKey = (master_password, key)->
    engine.add_private_key_from_armored master_password, key, (err) ->
      if err
        console.log err
      else
        read_keys(master_password)
    yes

  $('#private').on 'click', '.remove-private-key', ->
    index = parseInt $(@).data('index')
    name = $(@).data('name')
    $('#private-key-to-remove').text(name)
    $('#private-key-to-remove-index').val(index)
    $('#modal-remove-private-key').modal('show')

  removePrivateKey = (master_password, keyIndex)->
    engine.delete_private_key_by_index master_password, keyIndex, (err) ->
      if err
        console.log err
      else
        read_keys(master_password)

  $('#public').on 'click', '.remove-public-key', ->
    index = parseInt $(@).data('index')
    name = $(@).data('name')
    $('#public-key-to-remove').text(name)
    $('#public-key-to-remove-index').val(index)
    $('#modal-remove-public-key').modal('show')

  removePublicKey = (master_password, keyIndex)->
    engine.delete_public_key_by_index master_password, keyIndex, (err) ->
      if err
        console.log err
      else
        read_keys(master_password)

read_storage = (master_password, engine) ->
  storage = window.localStorage

  if not (storage['crypto-chrome-pub'] or storage['crypto-chrome-priv'])
    if not storage['crypto-chrome-pub']
      storage['crypto-chrome-pub'] = sjcl.encrypt(master_password, JSON.stringify([]))
    if not storage['crypto-chrome-priv']
      storage['crypto-chrome-priv'] = sjcl.encrypt(master_password, JSON.stringify([]))
  else
    try
      pub_keys = null
      priv_keys = null
      engine.list_public_keys(master_password, (err, keys) ->
        pub_keys = keys
      )
      engine.list_private_keys(master_password, (err, keys) ->
        priv_keys = keys
      )
    catch e
      alert "Failed to decrypt storage"
      throw e

  return [pub_keys, priv_keys]

