describe 'In the options page', ->

  it 'should not be able to read keys before being authenticated', ->
    expect(getPublicKeys()).toBeFalsy()

  describe 'Once authenticated', ->

    beforeEach ->
      decryptStore()

    afterEach ->
      deletePublicKeys()
      deletePrivateKeys()
    
    it 'should be able to store and retrieve a public key', ->
      key = 'something'
      importPublicKey 'somedude@somemail.com', key
      expect(getPublicKey('somedude@somemail.com')).toEqual key

    it 'should be able to wipe all your public keys', ->
      key = 'something'
      importPublicKey 'somedude@somemail.com', key
      deletePublicKeys()
      expect(getPublicKeys()).toEqual []

    it 'should be able to delete a public key', ->
      key = 'something'
      importPublicKey 'somedude@somemail.com', key
      expect(key).toEqual getPublicKey('somedude@somemail.com')
      deletePublicKey 'somedude@someemail.com'
      expect(getPublicKey('somedude@somemail.com')).toBeFalsy()

    it 'should be able to list all public keys', ->
      importPublicKey 'somedude@somemail.com', 'something'
      importPublicKey 'somedude2@somemail.com', 'someotherthing'
      expected = [
        'somedude@somemail.com'
        'somedude2@somemail.com'
      ]
      expect(getPublicKeys()).toEqual(expected)

    it 'should be able to store and retrieve a private key', ->
      key = 'something'
      importPrivateKey 'me@somemail.com', key
      expect(getPrivateKey('me@somemail.com')).toEqual key
    
    it 'should be able to delete a private key', ->
      key = 'something'
      importPrivateKey 'me@somemail.com', key
      expect(getPrivateKey('me@somemail.com')).toEqual key
      deletePrivateKey 'me@somemail.com'
      expect(getPrivateKey('me@somemail.com')).toBeFalsy()
