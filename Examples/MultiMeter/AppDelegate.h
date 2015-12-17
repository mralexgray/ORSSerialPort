
@import AppKit;
@import WebKit;

@class MM2200087;


@interface RickshawGraph : WebView
@end


IB_DESIGNABLE @interface MMAppDelegate : NSObject <NSApplicationDelegate>
@property (weak) IBOutlet RickshawGraph *graph;
@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet WebView *webView;

@property MM2200087 *m;
@end
