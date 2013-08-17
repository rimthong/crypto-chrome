describe 'In the browser popup', ->

  it 'should allow you to encrypt a text area', ->
    message = 'This is a secret.'
    publicKey = 'Some Key'
    cipher = textEncrypt(message, publicKey)
    expect(cipher).toNotEqual(message)

  it 'should allow you to decrypt a text area', ->
    message = 'This is a secret.'
    publicKey = 'Some Key'
    privateKey = 'My Key'
    cipher = textEncrypt(message, publicKey)
    expect(cipher).toNotEqual(message)
    expect(textDecrypt(cipher, privateKey)),toEqual(message)

  it 'should allow you to sign a message and verify the signature', ->
    message = 'This is a secret.'
    publicKey = 'Some Key'
    privateKey = 'My Key'
    signature = textSign(message, privateKey)
    expect(signature).toBeTruthy()
    expect(verifySignature(signature, publicKey)),toBeTruthy()

