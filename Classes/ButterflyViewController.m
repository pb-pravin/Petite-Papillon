//
//  ButterflyViewController.m
//  papillon
//
//  Created by Brit Gardner on 12/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ButterflyViewController.h"


@implementation ButterflyViewController

@synthesize butterfly;
@synthesize butterflyTabBar;
@synthesize webView;
@synthesize webViewToolbar;
@synthesize photoSet;
@synthesize thumbsView;
@synthesize photoView;
@synthesize thumbsViewContainer;
@synthesize addButton;
@synthesize rowID;
@synthesize addPhotoView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	DebugLog(@"View did load");
	//self.butterflyTabBar.selectedItem = [[self.butterflyTabBar items] objectAtIndex:0];
	self.webView.hidden = YES;
	self.webViewToolbar.hidden = YES;
	self.navigationItem.title = self.butterfly;
	self.navigationItem.rightBarButtonItem = self.addButton;
	self.thumbsView = [[TTThumbsViewController alloc] init];
	self.thumbsView.delegate = self;
	[self.thumbsViewContainer addSubview:self.thumbsView.view];
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.thumbsView invalidateModel];
	[self refreshSources];
	[self.thumbsView updateView];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
	self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x5B36A0);
	
}

- (void)refreshSources {
	self.photoSet = nil;
	self.thumbsView.photoSource = nil;
	DebugLog(@"Setting photoset rowID to %i", self.rowID);
	self.photoSet = [[ButterfliesPhotoSource alloc] initWithRowID:self.rowID];


	self.thumbsView.photoSource = self.photoSet;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark UITabBarDelegate Protocol

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
	DebugLog(@"Tab bar item selected: %@", item);
	
	if ([item isEqual:[[self.butterflyTabBar items] objectAtIndex:2]]) {
		[self loadWikipedia];
		self.webView.hidden = NO;
		self.webViewToolbar.hidden = NO;
		[self.navigationController setNavigationBarHidden:YES animated:YES];
	} else if ([item isEqual:[[self.butterflyTabBar items] objectAtIndex:1]]) {
		[self loadGoogle];
		self.webView.hidden = NO;
		self.webViewToolbar.hidden = NO;
		[self.navigationController setNavigationBarHidden:YES animated:YES];
	} else {
		self.webView.hidden = YES;
		self.webViewToolbar.hidden = YES;
		[self.navigationController setNavigationBarHidden:NO animated:YES];
	}
				

}

- (void)loadWikipedia {
	NSString *path = [NSString stringWithFormat:@"http://en.wikipedia.org/wiki/%@", 
					  [self.butterfly stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	DebugLog(@"string url is %@", path);
	NSURL *url = [NSURL URLWithString:path];
	DebugLog(@"url is %@", url);
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
	DebugLog(@"Wikipedia request url is: %@", request);
	[self.webView loadRequest:request];
}

- (void)loadGoogle {
	NSString *path = [NSString stringWithFormat:@"http://www.google.com/?q=%@", 
					  [[NSString stringWithFormat:@"%@ butterfly", self.butterfly] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	DebugLog(@"string url is %@", path);
	NSURL *url = [NSURL URLWithString:path];
	DebugLog(@"url is %@", url);
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
	DebugLog(@"Wikipedia request url is: %@", request);
	[self.webView loadRequest:request];
}


- (IBAction)websiteBack {
	[self.webView goBack];
}

- (IBAction)websiteForward {
	[self.webView goForward];
}

- (IBAction)websiteRefresh {
	[self.webView reload];
}

#pragma mark -
#pragma mark Thumbs view delegate
- (void)thumbsViewController:(TTThumbsViewController*)controller 
			  didSelectPhoto:(id<TTPhoto>)photo {
	DebugLog(@"thumb touched");
	if (!self.photoView) {
		self.photoView = [[TTPhotoViewController alloc] init];
		self.photoView.photoSource = self.photoSet;
	}
	[self.navigationController pushViewController:self.photoView animated:YES];
}

#pragma mark -
#pragma mark Actions

- (IBAction)addPhoto {
	DebugLog(@"Adding a photo from butterfly %@ id: %i", self.butterfly, self.rowID);
	if (!self.addPhotoView) {
		self.addPhotoView = [[AddButterflyPhotoViewController alloc] initWithNibName:@"AddButterflyPhotoViewController" bundle:nil];
	}
	self.addPhotoView.rowID = self.rowID;
	[self.navigationController pushViewController:self.addPhotoView animated:YES];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.butterflyTabBar = nil;
	self.webView = nil;
	self.webViewToolbar = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
