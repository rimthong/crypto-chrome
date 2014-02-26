var readStorage;

$(function() {
  var addPrivateKey, addPublicKey, engine, readKeys, removePrivateKey, removePublicKey;
  engine = cryptochrome_engine();
  $('#button-submit-add-public-key').click(function() {
    var key, password;
    $('#modal-add-public-key').modal('hide');
    password = $('#input-add-public-key-password').val();
    key = $('#input-add-public-key-key').val();
    $('#input-add-public-key-password').val('');
    $('#input-add-public-key-key').val('');
    return addPublicKey(password, key);
  });
  $('#form-add-public-key').submit(function() {
    var key, password;
    event.preventDefault();
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
  $('#form-add-private-key').submit(function() {
    var key, password;
    event.preventDefault();
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
  $('#form-remove-private-key').submit(function() {
    var index, password;
    event.preventDefault();
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
  $('#form-remove-public-key').submit(function() {
    var index, password;
    event.preventDefault();
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
    return readKeys(password);
  });
  $('#form-enter-master-password').submit(function() {
    var password;
    event.preventDefault();
    password = $('#input-entered-master-password').val();
    readKeys(password);
    return $('#modal-enter-master-password').modal('hide');
  });
  $('.button-close-enter-master-password').click(function() {
    return $('#modal-enter-master-password').modal('hide');
  });
  $('#button-confirm-initialize-master-password').click(function() {
    var password;
    password = $('#input-initialized-master-password').val();
    $('#modal-initialize-master-password').modal('hide');
    return readKeys(password);
  });
  $('#form-initialize-master-password').submit(function() {
    var password;
    event.preventDefault();
    password = $('#input-initialized-master-password').val();
    $('#modal-initialize-master-password').modal('hide');
    return readKeys(password);
  });
  $('.button-close-enter-master-password').click(function() {
    return $('#modal-initialize-master-password').modal('hide');
  });
  readKeys = function(masterPassword) {
    var hash, i, key, keys, name, priv_keys, pub_keys, storage, _i, _j, _len, _len1, _results;
    if (!masterPassword) {
      storage = window.localStorage;
      if (!(storage['crypto-chrome-pub'] || storage['crypto-chrome-priv'])) {
        return $('#modal-initialize-master-password').modal();
      } else {
        return $('#modal-enter-master-password').modal();
      }
    } else {
      keys = readStorage(masterPassword, engine);
      pub_keys = keys[0];
      priv_keys = keys[1];
      $("#public tbody, #private tbody").empty();
      if (pub_keys && pub_keys.length > 0) {
        i = 0;
        for (_i = 0, _len = pub_keys.length; _i < _len; _i++) {
          key = pub_keys[_i];
          name = key.keys[0].users[0].userId.userid;
          hash = CryptoJS.MD5(key.keys[0].primaryKey.getFingerprint());
          $("#public tbody").append("<tr>\n  <td>" + i + "</td>\n  <td><img src='http://www.gravatar.com/avatar/" + hash + "?d=identicon&s=40' /></td>\n  <td>" + name + "</td>\n  <td>\n    <button class='btn btn-danger btn-small remove-public-key' data-index='" + i + "' data-name='" + name + "'>\n      <i class='icon-minus'></i> Remove\n    </button>\n  </td>\n</tr>");
          i++;
        }
      }
      if (priv_keys && priv_keys.length > 0) {
        i = 0;
        _results = [];
        for (_j = 0, _len1 = priv_keys.length; _j < _len1; _j++) {
          key = priv_keys[_j];
          name = key.keys[0].users[0].userId.userid;
          hash = CryptoJS.MD5(key.keys[0].primaryKey.encrypted);
          $("#private tbody").append("<tr>\n  <td>" + i + "</td>\n  <td><img src='http://www.gravatar.com/avatar/" + hash + "?d=identicon&s=40' /></td>\n  <td>" + name + "</td>\n  <td>\n    <button class='btn btn-danger btn-small remove-private-key' data-index='" + i + "' data-name='" + name + "'>\n      <i class='icon-minus'></i> Remove\n    </button>\n  </td>\n</tr>\"");
          _results.push(i++);
        }
        return _results;
      }
    }
  };
  readKeys();
  $('#add-public-key').click(function() {
    return $('#modal-add-public-key').modal('show');
  });
  addPublicKey = function(masterPassword, key) {
    engine.addPublicKey(masterPassword, key, function(err) {
      if (err) {
        return console.log(err);
      } else {
        return readKeys(masterPassword);
      }
    });
    return true;
  };
  $('#add-private-key').click(function() {
    return $('#modal-add-private-key').modal('show');
  });
  addPrivateKey = function(masterPassword, key) {
    engine.addPrivateKey(masterPassword, key, function(err) {
      if (err) {
        return console.log(err);
      } else {
        return readKeys(masterPassword);
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
  removePrivateKey = function(masterPassword, keyIndex) {
    return engine.deletePrivateKeyByIndex(masterPassword, keyIndex, function(err) {
      if (err) {
        return console.log(err);
      } else {
        return readKeys(masterPassword);
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
  return removePublicKey = function(masterPassword, keyIndex) {
    return engine.deletePublicKeyByIndex(masterPassword, keyIndex, function(err) {
      if (err) {
        return console.log(err);
      } else {
        return readKeys(masterPassword);
      }
    });
  };
});

readStorage = function(masterPassword, engine) {
  var e, storage;
  storage = window.localStorage;
  if (!(storage['crypto-chrome-pub'] || storage['crypto-chrome-priv'])) {
    if (!storage['crypto-chrome-pub']) {
      storage['crypto-chrome-pub'] = sjcl.encrypt(masterPassword, JSON.stringify([]));
    }
    if (!storage['crypto-chrome-priv']) {
      return storage['crypto-chrome-priv'] = sjcl.encrypt(masterPassword, JSON.stringify([]));
    }
  } else {
    try {
      return engine.getPublicKeys(masterPassword, function(err, pubKeys) {
        return engine.getPrivateKeys(masterPassword, function(err, privKeys) {
          return [pubKeys, privKeys];
        });
      });
    } catch (_error) {
      e = _error;
      alert("Failed to decrypt storage");
      throw e;
    }
  }
};
