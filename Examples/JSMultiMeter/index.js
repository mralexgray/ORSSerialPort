
// require('coffee-script')
// require('coffee-cache').setCacheDir('/tmp/atom-coffee-cache')	
// require('module').globalPaths.push('/usr/local/lib/node_modules')

require('coffee-script').register
// coffee = require('./start')
// var $ = require('nodobjc')

var menub = require('menubar');

var	z;


var mb = menub({'preloadWindow' : true,
				'index' : 'http://localhost:55281',
				'width' : 1360,
				'height' : 400,
				'zoom-factor' : 1.3
				// 'y': -200,
				// 'x': -15 
});




mb.on('ready', function ready(){

	console.log('app is ready');
	
	require('/node/atoz').console();
	
	// $.import('Cocoa')
	// var pool = $.NSAutoreleasePool('alloc')('init')
	// $.NSLog($('test'))
})

	// #$.NSBeep()
	// #$.NSLog 'whatveHELLL!'

// console.log('done')

// z.console()

