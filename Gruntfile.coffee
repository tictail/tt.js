module.exports = (grunt) ->
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    config:
      build: 'build'

    coffee:
      build:
        expand: true,
        cwd: 'src',
        src: '{,*/}*.coffee',
        dest: 'build',
        ext: '.js'

    s3:
      options:
        bucket: 'com.tictail.cdn.apps.assets'
        region: 'eu-west-1'
      build:
        upload: [
          src: "<%= config.build %>/*"
          dest: ""
        ]

    bump:
      options:
        pushTo: "origin"

    clean:
      build:
        files: [{
          dot: true
          src: [
            '<%= config.build %>/*'
          ]
        }]
  grunt.registerTask 'build', ->
    grunt.task.run [
      'clean:build'
      'coffee:build'
    ]

  grunt.registerTask 'default', ['build']
