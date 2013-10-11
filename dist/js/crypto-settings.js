var read_storage;

$(function() {
  var addPrivateKey, addPublicKey, engine, read_keys, removePrivateKey, removePublicKey;
  engine = cryptochrome();
  $('#button-submit-add-public-key').click(function() {
    var key, password;
    $('#modal-add-public-key').modal('hide');
    password = $('#input-add-public-key-password').val();
    key = $('#input-add-public-key-key').val();
    $('#input-add-public-key-password').val('');
    $('#input-add-public-key-key').val('');
    return addPublicKey(password, key);
  });
  $('.button-close-add-public-key').click(function() {
    return $('#modal-add-public-key').modal('hide');
  });
  $('#button-submit-add-private-key').click(function() {
    var key, password;
    $('#modal-add-private-key').modal('hide');
    password = $('#input-add-private-key-password').val();
    key = $('#input-add-private-key-key').val();
    $('#input-add-private-key-password').val('');
    $('#input-add-private-key-key').val('');
    return addPrivateKey(password, key);
  });
  $('.button-close-add-private-key').click(function() {
    return $('#modal-add-private-key').modal('hide');
  });
  $('#button-remove-private-key').click(function() {
    var index, password;
    $('#modal-remove-private-key').modal('hide');
    password = $('#input-remove-private-key-password').val();
    index = $('#private-key-to-remove-index').val();
    $('#input-remove-private-key-password').val('');
    $('#private-key-to-remove-index').val('');
    return removePrivateKey(password, index);
  });
  $('.button-close-remove-private-key').click(function() {
    return $('#modal-remove-private-key').modal('hide');
  });
  $('#button-remove-public-key').click(function() {
    var index, password;
    $('#modal-remove-public-key').modal('hide');
    password = $('#input-remove-public-key-password').val();
    index = $('#public-key-to-remove-index').val();
    $('#input-remove-public-key-password').val();
    $('#public-key-to-remove-index').val();
    return removePublicKey(password, index);
  });
  $('.button-close-remove-public-key').click(function() {
    return $('#modal-remove-public-key').modal('hide');
  });
  $('#button-confirm-enter-master-password').click(function() {
    var password;
    password = $('#input-entered-master-password').val();
    $('#modal-enter-master-password').modal('hide');
    return read_keys(password);
  });
  $('.button-close-enter-master-password').click(function() {
    return $('#modal-enter-master-password').modal('hide');
  });
  $('#button-confirm-initialize-master-password').click(function() {
    var password;
    password = $('#input-initialized-master-password').val();
    $('#modal-initialize-master-password').modal('hide');
    return read_keys(password);
  });
  $('.button-close-enter-master-password').click(function() {
    return $('#modal-initialize-master-password').modal('hide');
  });
  read_keys = function(master_password) {
    var hash, i, key, keys, name, priv_keys, pub_keys, storage, _i, _j, _len, _len1, _results;
    if (!master_password) {
      storage = window.localStorage;
      if (!(storage['crypto-chrome-pub'] || storage['crypto-chrome-priv'])) {
        return $('#modal-initialize-master-password').modal();
      } else {
        return $('#modal-enter-master-password').modal();
      }
    } else {
      keys = read_storage(master_password, engine);
      pub_keys = keys[0];
      priv_keys = keys[1];
      $("#public tbody, #private tbody").empty();
      if (pub_keys && pub_keys.length > 0) {
        i = 0;
        for (_i = 0, _len = pub_keys.length; _i < _len; _i++) {
          key = pub_keys[_i];
          name = openpgp_encoding_html_encode(key[0].userIds[0].text);
          hash = CryptoJS.MD5(key[0].data);
          $("#public tbody").append("<tr>\n  <td>" + i + "</td>\n  <td><img src='http://www.gravatar.com/avatar/" + hash + "?d=identicon&s=40' /></td>\n  <td>" + name + "</td>\n  <td>\n    <button class='btn btn-danger btn-small remove-public-key' data-index='" + i + "' data-name='" + name + "'>\n      <i class='icon-minus'></i> Remove\n    </button>\n  </td>\n</tr>");
          i++;
        }
      }
      if (priv_keys && priv_keys.length > 0) {
        i = 0;
        _results = [];
        for (_j = 0, _len1 = priv_keys.length; _j < _len1; _j++) {
          key = priv_keys[_j];
          name = openpgp_encoding_html_encode(key[0].userIds[0].text);
          hash = CryptoJS.MD5(key[0].data);
          $("#private tbody").append("<tr>\n  <td>" + i + "</td>\n  <td><img src='http://www.gravatar.com/avatar/" + hash + "?d=identicon&s=40' /></td>\n  <td>" + name + "</td>\n  <td>\n    <button class='btn btn-danger btn-small remove-private-key' data-index='" + i + "' data-name='" + name + "'>\n      <i class='icon-minus'></i> Remove\n    </button>\n  </td>\n</tr>\"");
          _results.push(i++);
        }
        return _results;
      }
    }
  };
  read_keys();
  $('#add-public-key').click(function() {
    return $('#modal-add-public-key').modal('show');
  });
  addPublicKey = function(master_password, key) {
    engine.add_public_key_from_armored(master_password, key, function(err) {
      if (err) {
        return console.log(err);
      } else {
        return read_keys(master_password);
      }
    });
    return true;
  };
  $('#add-private-key').click(function() {
    return $('#modal-add-private-key').modal('show');
  });
  addPrivateKey = function(master_password, key) {
    engine.add_private_key_from_armored(master_password, key, function(err) {
      if (err) {
        return console.log(err);
      } else {
        return read_keys(master_password);
      }
    });
    return true;
  };
  $('#private').on('click', '.remove-private-key', function() {
    var index, name;
    index = parseInt($(this).data('index'));
    name = $(this).data('name');
    $('#private-key-to-remove').text(name);
    $('#private-key-to-remove-index').val(index);
    return $('#modal-remove-private-key').modal('show');
  });
  removePrivateKey = function(master_password, keyIndex) {
    return engine.delete_private_key_by_index(master_password, keyIndex, function(err) {
      if (err) {
        return console.log(err);
      } else {
        return read_keys(master_password);
      }
    });
  };
  $('#public').on('click', '.remove-public-key', function() {
    var index, name;
    index = parseInt($(this).data('index'));
    name = $(this).data('name');
    $('#public-key-to-remove').text(name);
    $('#public-key-to-remove-index').val(index);
    return $('#modal-remove-public-key').modal('show');
  });
  return removePublicKey = function(master_password, keyIndex) {
    return engine.delete_public_key_by_index(master_password, keyIndex, function(err) {
      if (err) {
        return console.log(err);
      } else {
        return read_keys(master_password);
      }
    });
  };
});

read_storage = function(master_password, engine) {
  var e, priv_keys, pub_keys, storage;
  storage = window.localStorage;
  if (!(storage['crypto-chrome-pub'] || storage['crypto-chrome-priv'])) {
    if (!master_password) {
      master_password = prompt("Master password to initialize the storage");
    }
    if (!storage['crypto-chrome-pub']) {
      storage['crypto-chrome-pub'] = sjcl.encrypt(master_password, JSON.stringify([]));
    }
    if (!storage['crypto-chrome-priv']) {
      storage['crypto-chrome-priv'] = sjcl.encrypt(master_password, JSON.stringify([]));
    }
  } else {
    if (!master_password) {
      master_password = prompt("Master password to retrieve keys");
    }
    try {
      pub_keys = null;
      priv_keys = null;
      engine.list_public_keys(master_password, function(err, keys) {
        return pub_keys = keys;
      });
      engine.list_private_keys(master_password, function(err, keys) {
        return priv_keys = keys;
      });
    } catch (_error) {
      e = _error;
      alert("Failed to decrypt storage");
      throw e;
    }
  }
  return [pub_keys, priv_keys];
};
