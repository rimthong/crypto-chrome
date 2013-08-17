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
          'dist/js/background.js' : ['src/coffee/background.coffee']
          'dist/js/cs-gmail.js' : ['src/coffee/cs-gmail.coffee']
        options:
          bare: true

    concat:
      js:
        src: ['bower_components/jquery/jquery.js']
        dest: 'dist/js/vendor.js'

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
  grunt.registerTask 'copy-resources',  ['concat', 'copy:img', 'copy:manifest']
  grunt.registerTask 'test', ['karma:unit']
