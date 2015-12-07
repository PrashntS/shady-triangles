ALL_TASKS = [
  'jst:all'
  'coffee:all'
  'concat:all'
  'sass:all'
]

module.exports = (grunt) ->
  path = require('path')
  exec = require('child_process').exec

  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-concat')
  grunt.loadNpmTasks('grunt-contrib-jst')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-contrib-sass')

  grunt.initConfig

    pkg: '<json:package.json>'
    build: 'client/static'
    src:   'client/src'

    coffee:
      all:
        files:
          '<%= build %>/js/shady.js': [
            '<%= src %>/coffee/shady.coffee'
          ]

    jst:
      all:
        options:
          namespace: 'Shady.Templates'
          processName: (filename) ->
            signalStr = '<%= src %>/templates/'
            pivot = filename.indexOf(signalStr) + signalStr.length
            filename.slice pivot, filename.indexOf('.html')

        files:
          '<%= build %>/js/templates.js': '<%= src %>/templates/*.html'

    concat:
      all:
        sourceMap: true
        files:
          '<%= build %>/js/shady.vendor.js': [
            'bower_components/three.js/build/three.js'
            'bower_components/three.js/examples/js/loaders/OBJLoader.js'
            'bower_components/three.js/examples/js/Detector.js'
            'bower_components/three.js/examples/js/libs/stats.min.js'
            'bower_components/three.js/examples/js/controls/TrackballControls.js'
            'bower_components/dat-gui/build/dat.gui.js'
            'bower_components/jquery/dist/jquery.js'
          ]
          '<%= build %>/js/shady.dist.js': [
            '<%= build %>/js/templates.js'
            '<%= build %>/js/shady.vendor.js'
            '<%= build %>/js/shady.js'
          ]

    sass:
      all:
        options:
          quiet: false
          trace:true
          style: 'expanded'

        files:
          '<%= build %>/css/shady.css': [
            '<%= src %>/sass/shady.sass'
          ]

    watch:
      all:
        files: [
          '<%= src %>/sass/*.sass'
          '<%= src %>/coffee/*.coffee'
          '<%= src %>/templates/*.html'
        ]
        tasks: ALL_TASKS
        options:
          livereload:
            host: 'localhost'
            port: 35729

  grunt.registerTask 'default', ALL_TASKS
