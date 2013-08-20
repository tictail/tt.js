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

  grunt.registerTask 'build', (target) ->
    grunt.task.run ['coffee:build']

  grunt.registerTask 'default', ['build']
