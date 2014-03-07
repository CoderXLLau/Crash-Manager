//
//  CLSAboutViewController.m
//  CrashManager
//
//  Created by Sasha Zats on 3/1/14.
//  Copyright (c) 2014 Sasha Zats. All rights reserved.
//

#import "CLSAboutViewController.h"

#import "ADNActivityCollection.h"
#import "CRMConfiguration.h"
#import "UIViewController+OpenSource.h"

typedef NS_ENUM(NSInteger, CLSSections) {
	CLSVersionSection = 0,
	CLSVersionShareSection = 1,
	CLSVersionOpenGithubSection = 2
};


@interface CLSAboutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *appTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *shareLabel;
@property (weak, nonatomic) IBOutlet UILabel *openGitHubPageLabel;
@end

@implementation CLSAboutViewController

- (void)_configureVersion {
	NSMutableString *versionString = [NSMutableString string];
	NSString *marketingVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
	if (marketingVersionString) {
		[versionString appendString:marketingVersionString];
	}
	NSString *shortVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
	if (shortVersionString) {
		if ([versionString length]) {
			[versionString appendFormat:@" (%@)", shortVersionString];
		} else {
			[versionString appendString:shortVersionString];
		}
	}
	if (!versionString) {
		[versionString appendString:@"Unknown"];
	}
	
	self.versionLabel.text = versionString;
}

- (void)_configureAppName {
	self.appTitleLabel.text = [[CRMConfiguration sharedInstance] appDisplayName];
}

- (void)_configureCells {
	[self _configureVersion];
	[self _configureAppName];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self crm_exposeSource];
	
	[self _configureCells];
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView
shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == CLSVersionShareSection ||
		indexPath.section == CLSVersionOpenGithubSection) {
		return YES;
	}
	return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	switch ((CLSSections)indexPath.section) {
		case CLSVersionOpenGithubSection: {
			[[UIApplication sharedApplication] openURL:[[CRMConfiguration sharedInstance] gitHubPageURL]];
			break;
		}
			
		case CLSVersionShareSection: {
			NSString *shareString = [NSString stringWithFormat:NSLocalizedString(@"CLSSharingFormatString", nil), [[CRMConfiguration sharedInstance] appDisplayName]];
			NSArray *activityItems = @[ shareString, [[CRMConfiguration sharedInstance] marketingURL] ];
			UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems
																								 applicationActivities:[ADNActivityCollection allActivities]];
			[self presentViewController:activityViewController
							   animated:YES
							 completion:nil];
			
			break;
		}
			
		default:
			break;
	}
}

@end
