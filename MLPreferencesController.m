//
//  PreferencesController.m
//  MarkdownLive
//
//  Created by Akihiro Noguchi on 7/05/11.
//  Copyright 2011 Aki. All rights reserved.
//

#import "MLPreferencesController.h"
#import "MLPreferencesManager.h"

NSString * const	kEditPaneFontNameChangedNotification		= @"EditPaneFontNameChangedNotification";

NSString * const	kFontDisplayFormat							= @"%@ %g pt.";

@interface MLPreferencesController (Private)

- (void)updateFontDisplay;

@end

@implementation MLPreferencesController

- (void)awakeFromNib {
	[self updateFontDisplay];
}

- (IBAction)showFonts:(id)sender {
	NSFontManager *fontMan = [NSFontManager sharedFontManager];
	NSFont *currentFont = [MLPreferencesManager editPaneFont];
	[prefWindow makeFirstResponder:prefWindow];
	[fontMan setSelectedFont:currentFont isMultiple:NO];
	[fontMan orderFrontFontPanel:sender];
}

- (void)updateFontDisplay {
	NSString *fontName = [MLPreferencesManager editPaneFontName];
	float fontSize = [MLPreferencesManager editPaneFontSize];
	[fontPreviewField setStringValue:[NSString stringWithFormat:kFontDisplayFormat, fontName, fontSize]];
}

- (IBAction)resetEditPanePreferences:(id)sender {
	
#pragma unused(sender)
	
	[MLPreferencesManager resetEditPanePreferences];
	[self updateFontDisplay];
	[[NSNotificationCenter defaultCenter] postNotificationName:kEditPaneFontNameChangedNotification
														object:nil];
}

- (void)changeFont:(id)sender {
	NSFont *newFont = [sender convertFont:[NSFont systemFontOfSize:0]];
	NSString *fontName = [newFont fontName];
	float fontSize = [newFont pointSize];
	
	if (newFont && fontName) {
		[MLPreferencesManager setEditPaneFontName:fontName];
		[MLPreferencesManager setEditPaneFontSize:fontSize];
		[fontPreviewField setStringValue:[NSString stringWithFormat:kFontDisplayFormat, fontName, fontSize]];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:kEditPaneFontNameChangedNotification
															object:nil];
	}
}

- (NSUInteger)validModesForFontPanel:(NSFontPanel *)fontPanel {
	
#pragma unused(fontPanel)
	
	return (NSFontPanelFaceModeMask |
			NSFontPanelSizeModeMask |
			NSFontPanelCollectionModeMask);
	
}

@end
