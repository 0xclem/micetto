gulp       = require 'gulp'
plugins    = require("gulp-load-plugins")()
runSequence = require "run-sequence"

GLOBS =
  templates: 'src/pages/**/*.jade'
  styles: 'src/styles/main.scss'
  images: 'src/images/**/*.*'

gulp.task "build-main-style", ->
  gulp.src(GLOBS.styles)
    .pipe(plugins.plumber({errorHandler: plugins.notify.onError("Error: <%= error.message %>")}))
    .pipe(plugins.sass(includePaths: ['src/bower_components'], imagePath: 'images'))
    .pipe(gulp.dest(".tmp"))

gulp.task "build-vendor-scripts", ->
  gulp.src(GLOBS.scripts.vendors)
    .pipe(plugins.plumber({errorHandler: plugins.notify.onError("Error: <%= error.message %>")}))
    .pipe(plugins.concat("vendors.js"))
    .pipe(gulp.dest(".tmp"))

gulp.task "build-main-script", ->
  gulp.src(GLOBS.scripts.main)
    .pipe(plugins.plumber({errorHandler: plugins.notify.onError("Error: <%= error.message %>")}))
    .pipe(plugins.coffee())
    .pipe(gulp.dest(".tmp"))

gulp.task "build-templates", ->
  gulp.src(GLOBS.templates)
    .pipe(plugins.plumber({errorHandler: plugins.notify.onError("Error: <%= error.message %>")}))
    .pipe(plugins.jade({pretty: true}))
    .pipe(gulp.dest(".tmp"))

gulp.task "copy-fonts", ->
  gulp.src(GLOBS.fonts)
    .pipe(gulp.dest(".tmp/fonts"))

gulp.task "copy-images", ->
  gulp.src(GLOBS.images)
    .pipe(gulp.dest(".tmp/images"))

gulp.task "copy-docs", ->
  gulp.src(GLOBS.docs)
    .pipe(gulp.dest(".tmp/docs"))

gulp.task "watch", ->
  plugins.livereload.listen()
  gulp.watch GLOBS.styles, ["build-main-style"]
  gulp.watch GLOBS.templates, ["build-templates"]
  gulp.watch GLOBS.images, ["copy-images"]
  gulp.watch(".tmp/**/*").on("change", -> plugins.livereload.changed())

gulp.task "clean-dist", -> gulp.src(".tmp/*", read: false).pipe(plugins.clean())
gulp.task "build-dist", ["build-main-style", "build-templates", "copy-images"]
gulp.task "serve-dist", plugins.serve(root: ".tmp", port: 9000)
gulp.task "dev", ["watch", "serve-dist"]
gulp.task 'default', (cb) -> runSequence "clean-dist", "build-dist", "dev", cb
gulp.task 'deploy', (cb) -> runSequence "clean-dist", "build-dist", cb





