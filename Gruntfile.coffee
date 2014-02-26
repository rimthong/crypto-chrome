module.exports = (grunt)->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    bower:
      install:
        options:
          targetDir: 'bower_components'
          install: 'true'

    clean: ['dist']

    coffee:
      compile:
        files:
          'dist/js/crypto-popup.js' : ['src/coffee/crypto-popup.coffee']
          'dist/js/cs-gmail.js' : ['src/coffee/cs-gmail.coffee']
          'dist/js/crypto-chrome-engine.js' : ['src/coffee/crypto-chrome-engine.coffee']
          'dist/js/crypto-settings.js' : ['src/coffee/crypto-settings.coffee']
          'dist/js/background.js' : ['src/coffee/background.coffee']
        options:
          bare: true

    concat:
      workerproxy:
        src: ['vendor/openpgp/openpgp.worker.js']
        dest: 'dist/html/openpgp.worker.js'
      minimized:
        src: ['vendor/openpgp/openpgp.min.js']
        dest: 'dist/html/openpgp.min.js'
      js:
        src: ['bower_components/jquery/jquery.js', 'bower_components/bootstrap/dist/js/bootstrap.js']
        dest: 'dist/js/vendor.js'
      background:
        src: ['vendor/openpgp/openpgp.js', 'vendor/sjcl/sjcl.js']
        dest: 'dist/js/background.js'

    stylus:
      compile:
        files:
          'dist/css/crypto-style.css': ['src/stylus/crypto-style.styl']

    jade:
      html:
        files:
          'dist/html/crypto-settings.html': ['src/jade/crypto-settings.jade']
          'dist/html/crypto-popup.html': ['src/jade/crypto-popup.jade']
          'dist/html/background.html': ['src/jade/background.jade']
        options:
          pretty: true

    copy:
      manifest:
        files: [src: ['manifest.json'], dest: 'dist/manifest.json']
      img:
        files: [expand: true, flatten: true, src: ['src/images/*'], dest: 'dist/images/']
      js:
        files: [expand: true, flatten: true, src: ['src/js/*'], dest: 'dist/js/']
      bootstrap:
        files: [src: ['bower_components/bootstrap/dist/css/bootstrap.min.css'], dest: 'dist/css/bootstrap.min.css']
      md5:
        files: [src: ['vendor/crypto-js/md5.js'], dest: 'dist/js/md5.js']
      fontawesome:
        files: [src: ['bower_components/font-awesome/css/font-awesome.min.css'], dest: 'dist/css/font-awesome.min.css']
      font:
        files: [expand:true, flatten:true, src: ['bower_components/font-awesome/font/*'], dest: 'dist/font/']

    karma:
      unit:
        configFile: 'karma.conf.coffee'
        singleRun: true
        browsers: ['PhantomJS']

    watch:
      coffee:
        files: 'src/**/*.coffee'
        tasks: 'coffee:compile'
      jade:
        files: 'src/**/*.jade'
        tasks: 'jade:html'
      stylus:
        files: 'src/**/*.styl'
        tasks: 'stylus:compile'

  grunt.loadNpmTasks 'grunt-bower-task'
  grunt.loadNpmTasks 'grunt-karma'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-clean'

  grunt.registerTask 'default', ['bower', 'compile', 'copy-resources']
  grunt.registerTask 'compile', ['coffee:compile', 'stylus:compile', 'jade:html']
  grunt.registerTask 'build', ['compile', 'copy-resources']
  grunt.registerTask 'copy-resources',  ['concat', 'copy:img', 'copy:manifest', 'copy:bootstrap', 'copy:fontawesome', 'copy:font', 'copy:js', 'copy:md5']
  grunt.registerTask 'test', ['karma:unit']
