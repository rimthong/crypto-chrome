$(function() {
  var decrypt, decryptVerify, encrypt, encryptSign, engine, enterMasterPassword, populate_keys, sign, verify;
  engine = cryptochrome_engine();
  $('#button-confirm-verify').click(function() {
    return verify();
  });
  $('.button-close-verify').click(function() {
    return $('#modal-verify').modal('hide');
  });
  $('#form-sign').submit(function() {
    event.preventDefault();
    return sign();
  });
  $('#button-confirm-sign').click(function() {
    return sign();
  });
  verify = function() {
    var index, key, masterPassword, signedText;
    masterPassword = $('#input-verify-master-password').val();
    key = $('#select-verify-public-key').val();
    $('#modal-verify').modal('hide');
    signedText = $('#popup-textarea').val();
    index = parseInt(key);
    return engine.getPublicKeys(masterPassword, function(err, keys) {
      if (err) {
        return console.log('Error getting keys:', err);
      } else {
        return engine.verify(signedText, keys[index], function(err, result) {
          var badSignatures, signature;
          if (result && !err) {
            badSignatures = (function() {
              var _i, _len, _ref, _results;
              _ref = result.signatures;
              _results = [];
              for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                signature = _ref[_i];
                if (signature.valid === false) {
                  _results.push(signature);
                }
              }
              return _results;
            })();
            if (badSignatures.length === 0 && result.signatures.length > 0) {
              $('#verification-success').removeClass('hidden').addClass('show');
              $('#verification-failure').removeClass('show').addClass('hidden');
            } else {
              $('#verification-failure').removeClass('hidden').addClass('show');
              $('#verification-success').removeClass('show').addClass('hidden');
            }
          } else {
            console.log('Error verifying signature:', err);
          }
          return true;
        });
      }
    });
  };
  sign = function() {
    var index, key, keyPassword, masterPassword, plainText;
    masterPassword = $('#input-sign-master-password').val();
    key = $('#select-sign-private-key').val();
    keyPassword = $('#input-sign-private-password').val();
    $('#modal-sign').modal('hide');
    plainText = $('#popup-textarea').val();
    index = parseInt(key);
    return engine.getPrivateKeys(masterPassword, function(err, keys) {
      if (err) {
        return console.log('Error getting keys:', err);
      } else {
        return engine.sign(plainText, keys[index], keyPassword, function(err, signedMessage) {
          console.log("Signature errors are:", err);
          $('#popup-textarea').val(signedMessage);
          return chrome.tabs.query({
            active: true,
            currentWindow: true
          }, function(tabs) {
            return chrome.tabs.sendMessage(tabs[0].id, {
              fonction: 'inject',
              message: signedMessage
            }, function(response) {});
          });
        });
      }
    });
  };
  $('.button-close-sign').click(function() {
    return $('#modal-sign').modal('hide');
  });
  $('#form-decrypt').submit(function() {
    event.preventDefault();
    return decrypt();
  });
  $('#button-confirm-decrypt').click(function() {
    return decrypt();
  });
  decrypt = function() {
    var cipherText, index, key, keyPassword, masterPassword;
    masterPassword = $('#input-decrypt-master-password').val();
    key = $('#select-decrypt-private-key').val();
    keyPassword = $('#input-decrypt-private-password').val();
    $('#modal-decrypt').modal('hide');
    cipherText = $('#popup-textarea').val();
    index = parseInt(key);
    return engine.getPrivateKeys(masterPassword, function(err, keys) {
      if (err) {
        return console.log('Error getting keys:', err);
      } else {
        return engine.decrypt(cipherText, keys[index], keyPassword, function(err, text) {
          return $('#popup-textarea').val(text);
        });
      }
    });
  };
  $('.button-close-decrypt').click(function() {
    return $('#modal-decrypt').modal('hide');
  });
  $('#button-encrypt-sign').click(function() {
    return $('#modal-encrypt-sign').modal('show');
  });
  $('#form-encrypt-sign').submit(function() {
    event.preventDefault();
    return encryptSign();
  });
  $('#button-confirm-encrypt-sign').click(function() {
    return encryptSign();
  });
  encryptSign = function() {
    var keyPassword, masterPassword, plaintext, privateKey, privateKeyIndex, publicKey, publicKeyIndex;
    masterPassword = $('#input-encrypt-sign-master-password').val();
    privateKey = $('#select-encrypt-sign-private-key').val();
    keyPassword = $('#input-encrypt-sign-private-password').val();
    publicKey = $('#select-encrypt-sign-public-key').val();
    privateKeyIndex = parseInt(privateKey);
    publicKeyIndex = parseInt(publicKey);
    $('#modal-encrypt-sign').modal('hide');
    plaintext = $('#popup-textarea').val();
    return engine.getPublicKeys(masterPassword, function(err1, publicKeys) {
      return engine.getPrivateKeys(masterPassword, function(err2, privateKeys) {
        if (err1 || err2) {
          return console.log('Error getting keys:', err1, err2);
        } else {
          return engine.signAndEncrypt(publicKeys[publicKeyIndex], privateKeys[privateKeyIndex], keyPassword, plaintext, function(err, ciphertext) {
            console.log("Sign and encrypt, error is:", err);
            $('#popup-textarea').val(ciphertext);
            return chrome.tabs.query({
              active: true,
              currentWindow: true
            }, function(tabs) {
              return chrome.tabs.sendMessage(tabs[0].id, {
                fonction: 'inject',
                message: ciphertext
              }, function(response) {});
            });
          });
        }
      });
    });
  };
  $('.button-close-encrypt-sign').click(function() {
    return $('#modal-encrypt-sign').modal('hide');
  });
  $('#button-decrypt-verify').click(function() {
    return $('#modal-decrypt-verify').modal('show');
  });
  $('#form-decrypt-verify').submit(function() {
    event.preventDefault();
    return decryptVerify();
  });
  $('#button-confirm-decrypt-verify').click(function() {
    return decryptVerify();
  });
  decryptVerify = function() {
    var ciphertext, keyPassword, masterPassword, privateKey, privateKeyIndex, publicKey, publicKeyIndex;
    masterPassword = $('#input-decrypt-verify-master-password').val();
    privateKey = $('#select-decrypt-verify-private-key').val();
    keyPassword = $('#input-decrypt-verify-private-password').val();
    publicKey = $('#select-decrypt-verify-public-key').val();
    privateKeyIndex = parseInt(privateKey);
    publicKeyIndex = parseInt(publicKey);
    $('#modal-decrypt-verify').modal('hide');
    ciphertext = $('#popup-textarea').val();
    return engine.getPrivateKeys(masterPassword, function(err, privateKeys) {
      return engine.getPublicKeys(masterPassword, function(err, publicKeys) {
        if (err) {
          return console.log('Error getting keys:', err);
        } else {
          return engine.decryptAndVerify(privateKeys[privateKeyIndex], publicKeys[publicKeyIndex], keyPassword, ciphertext, function(err, result) {
            var badSignatures, signature;
            $('#popup-textarea').val(result.text);
            if (result && !err) {
              badSignatures = (function() {
                var _i, _len, _ref, _results;
                _ref = result.signatures;
                _results = [];
                for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                  signature = _ref[_i];
                  if (signature.valid === false) {
                    _results.push(signature);
                  }
                }
                return _results;
              })();
              if (badSignatures.length === 0 && result.signatures.length > 0) {
                $('#verification-success').removeClass('hidden').addClass('show');
                $('#verification-failure').removeClass('show').addClass('hidden');
              } else {
                $('#verification-failure').removeClass('hidden').addClass('show');
                $('#verification-success').removeClass('show').addClass('hidden');
              }
            } else {
              console.log('Error verifying signature:', err);
            }
            return true;
          });
        }
      });
    });
  };
  $('.button-close-decrypt-verify').click(function() {
    return $('#modal-decrypt-verify').modal('hide');
  });
  $('#form-encrypt').submit(function() {
    event.preventDefault();
    return encrypt();
  });
  $('#button-confirm-encrypt').click(function() {
    return encrypt();
  });
  encrypt = function() {
    var cipherText, index, key, masterPassword, plainText;
    masterPassword = $('#input-encrypt-master-password').val();
    key = $('#select-encrypt-public-key').val();
    $('#modal-encrypt').modal('hide');
    plainText = $('#popup-textarea').val();
    cipherText = null;
    index = parseInt(key);
    return engine.getPublicKeys(masterPassword, function(err, keys) {
      if (err) {
        return console.log('Error getting keys:', err);
      } else {
        return engine.encrypt(plainText, keys[index], function(err, ciphertext) {
          $('#popup-textarea').val(ciphertext);
          return chrome.tabs.query({
            active: true,
            currentWindow: true
          }, function(tabs) {
            return chrome.tabs.sendMessage(tabs[0].id, {
              fonction: 'inject',
              message: ciphertext
            }, function(response) {});
          });
        });
      }
    });
  };
  $('.button-close-encrypt').click(function() {
    return $('#modal-encrypt').modal('hide');
  });
  $('#form-enter-master-password').submit(function() {
    event.preventDefault();
    return enterMasterPassword();
  });
  $('#button-confirm-enter-master-password').click(function() {
    return enterMasterPassword();
  });
  enterMasterPassword = function() {
    var password;
    password = $('#input-entered-master-password').val();
    $('#modal-enter-master-password').modal('hide');
    return populate_keys(engine, password);
  };
  $('.button-close-enter-master-password').click(function() {
    return $('#modal-enter-master-password').modal('hide');
  });
  $('#button-import-textarea').click(function() {
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
    return $('#modal-decrypt').modal();
  });
  $('#button-sign').click(function() {
    return $('#modal-sign').modal();
  });
  $('#button-encrypt').click(function() {
    return $('#modal-encrypt').modal();
  });
  $('#button-verify').click(function() {
    return $('#modal-verify').modal();
  });
  populate_keys = function(engine, master_password) {
    var e, priv_keys, pub_keys, storage;
    if (!master_password) {
      return $('#modal-enter-master-password').modal();
    } else {
      storage = window.localStorage;
      if (!(storage['crypto-chrome-pub'] || storage['crypto-chrome-priv'])) {
        return alert("You must initiate the storage first by visiting the setting page");
      }
      try {
        pub_keys = null;
        priv_keys = null;
        $("select").empty();
        engine.getPublicKeys(master_password, function(err, keys) {
          var i, key, name, _i, _len, _results;
          pub_keys = keys;
          i = 0;
          _results = [];
          for (_i = 0, _len = keys.length; _i < _len; _i++) {
            key = keys[_i];
            name = key.keys[0].users[0].userId.userid;
            $(".select-public-key").append("<option value='" + i + "'>" + name + "</option>");
            _results.push(i++);
          }
          return _results;
        });
        return engine.getPrivateKeys(master_password, function(err, keys) {
          var i, key, name, _i, _len, _results;
          priv_keys = keys;
          i = 0;
          _results = [];
          for (_i = 0, _len = keys.length; _i < _len; _i++) {
            key = keys[_i];
            name = key.keys[0].users[0].userId.userid;
            $(".select-private-key").append("<option value='" + i + "'>" + name + "</option>");
            _results.push(i++);
          }
          return _results;
        });
      } catch (_error) {
        e = _error;
        throw e;
      }
    }
  };
  return populate_keys(engine);
});
