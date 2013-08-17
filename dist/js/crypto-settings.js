var read_storage;

$(function() {
  var engine, read_keys;
  engine = cryptochrome();
  read_keys = function(master_password) {
    var hash, i, key, keys, name, priv_keys, pub_keys, _i, _j, _len, _len1, _results;
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
        $("#public tbody").append("<tr><td>" + i + ("</td><td><img src='http://www.gravatar.com/avatar/" + hash + "?d=identicon&s=40' /></td><td>") + name + "</td><td><button class='btn btn-danger btn-small remove-public-key' data-index='" + i + "'><i class='icon-minus'></i> Remove</button></td></tr>");
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
        $("#private tbody").append("<tr><td>" + i + ("</td><td><img src='http://www.gravatar.com/avatar/" + hash + "?d=identicon&s=40' /></td><td>") + name + "</td><td><button class='btn btn-danger btn-small remove-private-key' data-index='" + i + "'><i class='icon-minus'></i> Remove</button></td></tr>");
        _results.push(i++);
      }
      return _results;
    }
  };
  read_keys();
  $('#add-public-key').click(function() {
    var key, master_password;
    key = $('#public-key-to-add').val();
    master_password = prompt("Master password to add private key");
    engine.add_public_key_from_armored(master_password, key, function(err) {
      if (err) {
        return console.log(err);
      } else {
        return read_keys(master_password);
      }
    });
    console.log("Adding pubkey " + key);
    return true;
  });
  $('#add-private-key').click(function() {
    var key, master_password;
    key = $('#private-key-to-add').val();
    master_password = prompt("Master password to add private key");
    engine.add_private_key_from_armored(master_password, key, function(err) {
      if (err) {
        return console.log(err);
      } else {
        return read_keys(master_password);
      }
    });
    console.log("Adding private " + key);
    return true;
  });
  $('#private').on('click', '.remove-private-key', function() {
    var master_password;
    master_password = prompt("Master password to delete public key");
    return engine.delete_private_key_by_index(master_password, parseInt($(this).data('index')), function(err) {
      if (err) {
        return console.log(err);
      } else {
        return read_keys(master_password);
      }
    });
  });
  return $('#public').on('click', '.remove-public-key', function() {
    var master_password;
    master_password = prompt("Master password to delete public key");
    return engine.delete_public_key_by_index(master_password, parseInt($(this).data('index')), function(err) {
      if (err) {
        return console.log(err);
      } else {
        return read_keys(master_password);
      }
    });
  });
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
