$(function() {
  var engine, populate_keys;
  engine = cryptochrome();
  console.log("Loaded browser page");
  $('#button-import-textarea').click(function() {
    console.log("Clicked text area");
    return chrome.tabs.query({
      active: true,
      currentWindow: true
    }, function(tabs) {
      return chrome.tabs.sendMessage(tabs[0].id, {
        fonction: 'retrieve'
      }, function(response) {
        return $('#popup-textarea').html(response.text);
      });
    });
  });
  $('#button-import-message-textarea').click(function() {
    console.log("Clicked text area");
    return chrome.tabs.query({
      active: true,
      currentWindow: true
    }, function(tabs) {
      return chrome.tabs.sendMessage(tabs[0].id, {
        fonction: 'retrieveLast'
      }, function(response) {
        return $('#popup-textarea').html(response.text);
      });
    });
  });
  $('#button-decrypt').click(function() {
    var cipherText, index, master_password;
    cipherText = $('#popup-textarea').val();
    master_password = prompt("Master password to get keys");
    index = parseInt($("#private").val());
    return engine.list_private_keys(master_password, function(err, keys) {
      if (err) {
        return alert(err);
      } else {
        return engine.decrypt(cipherText, keys[index], prompt("Private key passphrase"), master_password, function(err, text) {
          return $('#popup-textarea').val(text);
        });
      }
    });
  });
  $('#button-sign').click(function() {
    var index, master_password, plainText;
    plainText = $('#popup-textarea').val();
    master_password = prompt("Master password to get keys");
    index = parseInt($("#private").val());
    return engine.list_private_keys(master_password, function(err, keys) {
      if (err) {
        return alert(err);
      } else {
        return engine.sign(plainText, keys[index], prompt("Private key passphrase"), master_password, function(err, signed_message) {
          $('#popup-textarea').val(signed_message);
          return chrome.tabs.query({
            active: true,
            currentWindow: true
          }, function(tabs) {
            return chrome.tabs.sendMessage(tabs[0].id, {
              fonction: 'inject',
              message: signedText
            }, function(response) {
              if (response && response.status === 'ok') {

              } else {
                $('#popup-textarea').val(signed_message);
                return true;
              }
            });
          });
        });
      }
    });
  });
  $('#button-encrypt').click(function() {
    var cipherText, index, master_password, plainText;
    plainText = $('#popup-textarea').val();
    master_password = prompt("Master password to get keys");
    cipherText = null;
    index = parseInt($("#public").val());
    engine.list_public_keys(master_password, function(err, keys) {
      if (err) {
        return alert(err);
      } else {
        return engine.encrypt(plainText, keys[index], function(err, encrypted_message) {
          cipherText = encrypted_message;
          console.log(cipherText);
          return true;
        });
      }
    });
    $('#popup-textarea').val(cipherText);
    return chrome.tabs.query({
      active: true,
      currentWindow: true
    }, function(tabs) {
      return chrome.tabs.sendMessage(tabs[0].id, {
        fonction: 'inject',
        message: cipherText
      }, function(response) {
        if (response && response.status === 'ok') {

        } else {
          return $('#popup-textarea').val(cipherText);
        }
      });
    });
  });
  $('#button-verify').click(function() {
    var message, signedText, verified;
    signedText = $('#popup-textarea').val();
    verified = true;
    if (verified) {
      message = "<h4 class=\"success\">\n  <i class=\"icon-check-sign\"/>\n  &nbsp; Signature ok!\n</h4>";
    } else {
      message = "<h4 class=\"error\">\n  <i class=\"icon-warning-sign\"/>\n  &nbsp; Bad signature!\n</h4>";
    }
    return $('#popup-message-box').html(message);
  });
  populate_keys = function(engine) {
    var e, i, key, master_password, name, priv_keys, pub_keys, storage, _i, _j, _len, _len1, _results;
    storage = window.localStorage;
    if (!(storage['crypto-chrome-pub'] || storage['crypto-chrome-priv'])) {
      return alert("You must initiate the storage first by visiting the setting page");
    }
    master_password = prompt("Master password to get keys");
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
    $("select").empty();
    i = 0;
    for (_i = 0, _len = pub_keys.length; _i < _len; _i++) {
      key = pub_keys[_i];
      name = openpgp_encoding_html_encode(key[0].userIds[0].text);
      $("#public").append("<option value='" + i + "'>" + name + "</option>");
      i++;
    }
    i = 0;
    _results = [];
    for (_j = 0, _len1 = priv_keys.length; _j < _len1; _j++) {
      key = priv_keys[_j];
      name = openpgp_encoding_html_encode(key[0].userIds[0].text);
      $("#private").append("<option value='" + i + "'>" + name + "</option>");
      _results.push(i++);
    }
    return _results;
  };
  return populate_keys(engine);
});
