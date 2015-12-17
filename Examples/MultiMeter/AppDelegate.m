
#import "AppDelegate.h"

#import <ORSSerial/ORSSerial.h>


@implementation MMAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {



	NSString *path1 = [NSBundle.mainBundle pathForResource:@"example-resize" ofType:@"html" inDirectory:@"canv-gauge"];
	NSString *html = [NSString fromFile:path1];
	NSAssert(html.length && path1.length, @"need this shit");
	[path1 log];
	[html log];
	[_webView.mainFrame.frameView setAllowsScrolling:NO];
	[_webView.mainFrame loadHTMLString:html baseURL:[NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"canv-gauge"]];

	id oc = ^(id<MultiMeter> thing){
		id x = [thing display][kLCD];

		NSLog(@"%@", x);
		[_webView stringByEvaluatingJavaScriptFromString:
			[NSString stringWithFormat:@"gauge.setValue(%f);",[x floatValue]]];

	};
	_m = MM2200087.new;
	_m.port = SERIALPORTS[1];
	_m.onChange = oc;

	//    [_webView setDrawsBackground:NO];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}


@end


@implementation WebView (inject)

// inject JS string into document
- (void) injectJS:(NSString*) jsString
{
    DOMDocument* domDocument = [self mainFrameDocument];
    DOMElement* jsElement = [domDocument createElement:@"script"];
    [jsElement setAttribute:@"type" value:@"text/javascript"];
    DOMText* jsText = [domDocument createTextNode:jsString];
    [jsElement appendChild:jsText];
    DOMElement* bodyElement = (DOMElement*)[[domDocument getElementsByTagName:@"body"] item: 0];
    [bodyElement appendChild:jsElement];
}

// inject CSS string into document
- (void) injectCSS:(NSString*) cssString
{
    DOMElement* jsElement = [self.mainFrameDocument createElement:@"style"];
    [jsElement setAttribute:@"type" value:@"text/css"];
    DOMText* jsText = [self.mainFrameDocument createTextNode:cssString];
    [jsElement appendChild:jsText];
    DOMElement* bodyElement = (DOMElement*)[[self.mainFrameDocument getElementsByTagName:@"head"] item: 0];
    [bodyElement appendChild:jsElement];
}

@end



@implementation RickshawGraph


- (void) awakeFromNib {

// @"../src/css/.css", @"../src/css/detail.css", @"../src/css/legend.css">
//	for css in @[@"graph", @"detail", @"legend"]
//	<link type="text/css" rel="stylesheet" href="css/extensions.css">
/*
	<script src="../vendor/d3.v3.js"></script>
	<script src="../rickshaw.js"></script>
</head>
<body>

<div id="content">
	<div id="chart"></div>
</div>

<script>

// add some data every so often

var i = 0;
var iv = setInterval( function() {

	var data = { one: Math.floor(Math.random() * 40) + 120 };

	var randInt = Math.floor(Math.random()*100);
	data.two = (Math.sin(i++ / 40) + 4) * (randInt + 400);
	data.three = randInt + 300;

	graph.series.addData(data);
	graph.render();

}, tv );

</script>

</body>
*/
	NSBundle* bundle = [NSBundle bundleForClass:self.class];

	[self.mainFrame loadHTMLString: @"<div id='content'><div id='chart'></div></div>" baseURL:nil];


//	for (id css in @[@"graph", @"detail", @"legend"]) {
//	<link type="text/css" rel="stylesheet" href="css/extensions.css">

	[self injectCSS:[NSString fromFile:[bundle pathForResource:@"rickshaw" ofType:@"css" inDirectory:@"rickshaw"]]];
	for (id z in @[
		[bundle pathForResource:@"rickshaw" ofType:@"js" inDirectory:@"rickshaw"],
		[bundle pathForResource:@"d3.v3" ofType:@"js" inDirectory:@"rickshaw/vendor"]
		]) {
				id j = [NSString fromFile:z];
				NSAssert([j length],@"Uh oh");
				[self stringByEvaluatingJavaScriptFromString:j];
//				[self injectJS:z];
		}
		[self stringByEvaluatingJavaScriptFromString:@"console.log('whatever');"];
		[self stringByEvaluatingJavaScriptFromString:@" \
\
	var tv = 250;\
	var graph = new Rickshaw.Graph( {\
	element: document.getElementById(\"chart\"),\
	width: 900,\
	height: 500,\
	renderer: 'line',\
	series: new Rickshaw.Series.FixedDuration([{ name: 'one' }], undefined, {\
			timeInterval: tv,\
			maxDataPoints: 100,\
			timeBase: new Date().getTime() / 1000\
		}) \
	});\
	\
	graph.render();"];

}


@end



int main(int argc, const char * argv[]) {
	return NSApplicationMain(argc, argv);
}
