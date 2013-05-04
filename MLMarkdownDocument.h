/*******************************************************************************
	MyDocument.h - <http://github.com/rentzsch/MarkdownLive>
		Copyright (c) 2006-2011 Jonathan 'Wolf' Rentzsch: <http://rentzsch.com>
		Some rights reserved: <http://opensource.org/licenses/mit-license.php>

	***************************************************************************/

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@class MLEditPaneTextView;
@class MLEditPaneLayoutManager;

@interface MLMarkdownDocument : NSDocument {
	IBOutlet	MLEditPaneTextView			*markdownSourceTextView;
	IBOutlet	WebView						*htmlPreviewWebView;
	
				NSTextStorage				*markdownSource;
	
				NSTimeInterval				whenToUpdatePreview;
				NSTimer						*htmlPreviewTimer;
				
				BOOL						hasSavedOrigin;
				NSPoint						savedOrigin;
				BOOL						savedAtBottom;
}

- (IBAction)copyGeneratedHTMLAction:(id)sender;

- (IBAction)boldItalic:(id)sender;
- (IBAction)bold:(id)sender;
- (IBAction)italic:(id)sender;
- (IBAction)header1:(id)sender;
- (IBAction)header2:(id)sender;
- (IBAction)header3:(id)sender;
- (IBAction)blockQuote:(id)sender;
- (IBAction)codeSection:(id)sender;
- (IBAction)unorderedList:(id)sender;
- (IBAction)numberedList:(id)sender;
- (IBAction)link:(id)sender;
- (IBAction)image:(id)sender;

@end
