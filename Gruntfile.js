'use strict';

var mount = function (connect, dir) {
  return connect.static(require('path').resolve(dir));
};

module.exports = function(grunt) {
  
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-sass');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-watch');
  
  grunt.initConfig({

    clean: {
      all: ['.sass-cache', 'build'],
      post_build: ['.sass-cache', 'npm-debug.log', 'build/.tsmp']
    },

    concat: {      
      libjs: {
        src: [
          'src/vendor/js/jquery.js',
          'src/js/main.js'
        ],
        dest: 'build/js/app.js'
      },
      libcss: {
        src: [
          'src/vendor/css/bootstrap.css'
        ],
        dest: 'build/.tmp/vendor.css'
      }
    },
    
    copy: {
      build: {
        files: [
          {expand: true, cwd: 'src/', src: ['index.html', 'favicon.ico'], dest: 'build/'},
          {expand: true, cwd: 'src/fonts/', src: ['**'], dest: 'build/css/fonts/'},
          {expand: true, cwd: 'src/img/', src: ['**'], dest: 'build/img/'}
        ]
      },

      /* Of course this is just temporary stuff */
      deploy: {
        files: [
          {expand: true, cwd: 'build/', src: ['**'], dest: '/some/path/'}
        ]
      }
    },

    sass: {
      development: {
        files: {
          'build/css/app.css' : [
            'build/.tmp/vendor.css',
            'src/sass/main.scss'
          ]
        },
        options: {
          style: 'expanded'
        }
      },
      release: {
        files: {
          'build/css/app.css' : [
            'build/.tmp/vendor.css',
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
    'concat',
    'sass:development',
    'clean:post_build'
  ]);

  grunt.registerTask('build:release', [
    'clean:all',
    'copy:build',
    'concat',
    'sass:release',
    'clean:post_build',
    'uglify:release'
  ]);

  grunt.registerTask('deploy', [
    'build:release',
    'copy:deploy'
  ]);

  grunt.registerTask('default', ['build']);
}
