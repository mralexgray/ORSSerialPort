
emitter = module.exports = (callback) ->

	$ = require 'nodobjc'
	EventLoop = require 'nodobjc/examples/EventLoop'

	EventLoop.initObjC $

	$.import 'Foundation'

	evtLoop = new EventLoop()
	pool = $.NSAutoreleasePool 'new'

	$.import '~/Library/Frameworks/ORSSerial.framework'

	# console.error($.MM2200087.getClass().methods())

	p = $.ORSSerialPortManager('sharedSerialPortManager')('availablePorts')('firstObject')


	signature = ['v',['?', '@']]
	blockDecl = ((self, obj) -> callback(obj))

	m = $.MM2200087 'meterOnPort', p, 'onChange', $ blockDecl, signature

	evtLoop.start()


# m 'setPort', p


# m 'setOnChange',

#console.log p.methods()
#console.log p

# m.port = p
# m.onChange = (x) -> console.log x


# $.CFRunLoopRun()
