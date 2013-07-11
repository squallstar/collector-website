'use strict';

var mount = function (connect, dir) {
  return connect.static(require('path').resolve(dir));
};

module.exports = function(grunt) {
  
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-sass');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-replace');
  
  grunt.initConfig({

    clean: {
      all: ['.sass-cache', 'build'],
      post_build: ['.sass-cache', 'npm-debug.log', 'build/.tmp']
    },

    coffee: {      
      compileJoined: {
        options: {
          join: true
        },
        files: {
          'build/js/app.js': [
            'src/coffee/*.coffee'
          ]
        }
      },
    },

    concat: {      
      js: {
        src: [
          'src/vendor/js/jquery.js',
          'build/js/app.js'
        ],
        dest: 'build/js/app.js'
      },
      css: {
        src: [
          'src/vendor/css/reset.css',
          'src/vendor/css/lemonade.css',
          'build/.tmp/main.css'
        ],
        dest: 'build/css/app.css'
      }
    },
    
    copy: {
      build: {
        files: [
          {expand: true, cwd: 'src/', src: ['.htaccess', 'favicon.ico'], dest: 'build/'},
          {expand: true, cwd: 'src/fonts/', src: ['**'], dest: 'build/css/fonts/'},
          {expand: true, cwd: 'src/img/', src: ['**'], dest: 'build/img/'}
        ]
      },

      /* Of course this is just temporary stuff */
      deploy: {
        files: [
          {expand: true, cwd: 'build/', src: ['**'], dest: '<%= deployPath %>'}
        ]
      }
    },

    replace: {
      dist: {
        options: {
          variables: {
            'timestamp': '<%= new Date().getTime() %>'
          }
        },
        files: [
          {src: ['src/index.html'], dest: 'build/index.html'}
        ]
      }
    },

    sass: {
      development: {
        files: {
          'build/.tmp/main.css' : [
            'src/sass/main.scss'
          ]
        },
        options: {
          style: 'expanded'
        }
      },
      release: {
        files: {
          'build/.tmp/main.css' : [
            'src/sass/main.scss'
          ]
        },
        options: {
          style: 'compressed'
        }
      }
    },

    uglify: {
      release: {
        preserveComments : false,
        files: {
          'build/js/app.js': ['build/js/app.js']
        }
      }
    },

    watch : {
      src: {
        files: ['Gruntfile.js', 'src/**'],
        tasks: ['build'],
      },
    }
    
  });
  
  grunt.registerTask('build', [
    'clean:all',
    'copy:build',
    'sass:development',
    'coffee',
    'concat',
    'replace',
    'clean:post_build'
  ]);

  grunt.registerTask('build:release', [
    'clean:all',
    'copy:build',
    'sass:release',
    'coffee',
    'concat',
    'replace',
    'clean:post_build',
    'uglify:release'
  ]);

  grunt.registerTask('deploy', 'Builds the app for release and deploys it to the provided destination path',
    function(where) {
      if (!where) {
        grunt.log.writeln('Please provide the deploy path: grunt deploy:/path/to/dir');
        return false;
      }
      grunt.config.set('deployPath', where);
      grunt.task.run(['build:release', 'copy:deploy']);
    }
  );

  grunt.registerTask('default', ['build']);
}
