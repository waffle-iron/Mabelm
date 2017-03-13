var gulp = require('gulp');
var util = require("gulp-util");
var exec = require('child_process').exec;
var sass = require('gulp-sass');
var browserSync = require('browser-sync').create();

gulp.task('buildElm', function (cb) {
	var gotoElmDir = 'cd ./development/elm';
	var and = "&&";
	//var makeElmJS = 'elm-make src/Main.elm --output=elm.js --debug';
	var makeElmJS = 'elm-make src/Main.elm --output=elm.js';
	var moveFile = 'mv elm.js ../../public/js/'

	exec(gotoElmDir + and + makeElmJS + and + moveFile, function (err, stdout, stderr) {
		cb(err);
	});
})

gulp.task('serve', function() {

    browserSync.init({
        server: "./public",
		notify: false
    });

    gulp.watch("./development/elm/src/**/*.elm", ['buildElm', 'lineCount']);
    gulp.watch("./development/scss/**/*.scss", ['sass', 'lineCount']);
    gulp.watch("public/*.html").on('change', browserSync.reload);
    gulp.watch("public/js/*.js").on('change', browserSync.reload);
});

function swollow(error) {
	console.log(error);
	this.emit('end');
}

gulp.task('sass', function() {
	return gulp.src("development/scss/*.scss")
		.pipe(sass())
		.on('error', swollow)
		.pipe(gulp.dest("public/css"))
		.pipe(browserSync.stream());
});


gulp.task('lineCount', function (cb) {
	// var command = "wc -l ./development/elm/src/**/*.elm";
	var command = "find ./development/elm/src -name '*.elm' | xargs wc -l"

	exec(command, function (err, stdout, stderr) {
		cb(err);
		util.log("\n" + stdout);
	});
})


gulp.task('default', ['buildElm', 'serve', 'lineCount']);