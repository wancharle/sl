module.exports = (grunt) ->
  grunt.initConfig
    bower_concat:
      all:
        dest: "build/dependencias.js"

    coffee:
      compileJoined:
        options:
          join: true
        files:
          'build/searchlight-core.js':
            [
              'js/*.coffee'
#             'otherdirectory/*.coffee'
            ]
    concat:
      dist:
        src:[
          'build/dependencias.js',
          'js/getUrlParam.js',
          'js/spin.js',
          'js/leaflet.spin.js',
          'js/markercluster/leaflet.markercluster-src.js',
          'build/searchlight-core.js',
           
          ],
        dest: 'build/searchlight.js'
          
    watch:
      files: 'js/*.coffee'
      tasks:
        [
          'coffee','bower_concat','concat'
#         'other-task'
        ]

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-bower-concat'
  grunt.registerTask 'default', ['coffee','bower_concat','concat']

# vim: set ts=2 sw=2 sts=2 expandtab:
