module.exports = (grunt) ->
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  grunt.initConfig
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
          src: "build/*"
          dest: ""
        ]

  grunt.registerTask 'build', (target) ->
    grunt.task.run ['coffee:build']

  grunt.registerTask 'default', ['build']
