//
//  EditPaneTextView.m
//  MarkdownLive
//
//  Created by Akihiro Noguchi on 9/05/11.
//  Copyright 2011 Aki. All rights reserved.
//

#import "MLEditPaneTextView.h"
#import "MLEditPaneLayoutManager.h"
#import "MLPreferencesManager.h"
#import "MLPreferencesController.h"

NSString * const	kEditPaneTextViewChangedNotification		= @"EditPaneTextViewChangedNotification";
void *kEditPaneColorChangedNotification = &kEditPaneColorChangedNotification;

@implementation MLEditPaneTextView

- (void)awakeFromNib {
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(updateFont)
												 name:kEditPaneFontNameChangedNotification
											   object:nil];
	
	NSUserDefaultsController *defaultsController = [NSUserDefaultsController sharedUserDefaultsController];
	
	[defaultsController addObserver:self
						 forKeyPath:[NSString stringWithFormat:@"values.%@", kEditPaneForegroundColor]
							options:0
							context:kEditPaneColorChangedNotification];
	[defaultsController addObserver:self
						 forKeyPath:[NSString stringWithFormat:@"values.%@", kEditPaneBackgroundColor]
							options:0
							context:kEditPaneColorChangedNotification];
	[defaultsController addObserver:self
						 forKeyPath:[NSString stringWithFormat:@"values.%@", kEditPaneSelectionColor]
							options:0
							context:kEditPaneColorChangedNotification];
	[defaultsController addObserver:self
						 forKeyPath:[NSString stringWithFormat:@"values.%@", kEditPaneCaretColor]
							options:0
							context:kEditPaneColorChangedNotification];
	
	[self setUsesFontPanel:NO];
	
	NSTextContainer *textContainer = [[NSTextContainer alloc] init];
	[textContainer setContainerSize:[[self textContainer] containerSize]];
	[textContainer setWidthTracksTextView:YES];
	layoutMan = [[MLEditPaneLayoutManager alloc] init];
	[self replaceTextContainer:textContainer];
	[textContainer replaceLayoutManager:layoutMan];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[[NSUserDefaultsController sharedUserDefaultsController] removeObserver:self];
}

- (void)keyDown:(NSEvent *)aEvent {
	[super keyDown:aEvent];
	[[NSNotificationCenter defaultCenter] postNotificationName:kEditPaneTextViewChangedNotification
														object:self];
}

- (void)setMarkedText:(id)aString
		selectedRange:(NSRange)selectedRange replacementRange:(NSRange)replacementRange {
	id resultString;
	if ([aString isKindOfClass:[NSAttributedString class]]) {
		resultString = [aString mutableCopy];
		selectedRange = NSMakeRange(0, [resultString length]);
		NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
							   [NSNumber numberWithInt:NSUnderlineStyleSingle], NSUnderlineStyleAttributeName,
							   [MLPreferencesManager editPaneForegroundColor], NSUnderlineColorAttributeName,
							   nil];
		[resultString setAttributes:attrs range:selectedRange];
	} else {
		resultString = aString;
	}
	
	[super setMarkedText:resultString
		   selectedRange:selectedRange replacementRange:replacementRange];
}

- (void)updateColors {
	[[self enclosingScrollView] setBackgroundColor:[MLPreferencesManager editPaneBackgroundColor]];
	[self setTextColor:[MLPreferencesManager editPaneForegroundColor]];
	[self setInsertionPointColor:[MLPreferencesManager editPaneCaretColor]];
	NSDictionary *selectedAttr = [NSDictionary dictionaryWithObject:[MLPreferencesManager editPaneSelectionColor]
															 forKey:NSBackgroundColorAttributeName];
	[self setSelectedTextAttributes:selectedAttr];
}

- (void)updateFont {
	layoutMan.font = [MLPreferencesManager editPaneFont];
	[self setFont:layoutMan.font];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context {
	
#pragma unused(keyPath)
#pragma unused(object)
#pragma unused(change)
	
	if (context == kEditPaneColorChangedNotification) {
		[self updateColors];
	} else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
