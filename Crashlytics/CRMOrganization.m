#import "CRMOrganization.h"

#import "CRMApplication.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>

@interface CRMOrganization ()

// Private interface goes here.

@end


@implementation CRMOrganization

+ (instancetype)organizationWithContentsOfDictionary:(NSDictionary *)dictionary
										   inContext:(NSManagedObjectContext *)context {
	NSString *organizationID = dictionary[@"id"];
	if (![organizationID isKindOfClass:[NSString class]]) {
		return nil;
	}
	
	CRMOrganization *organization = [CRMOrganization MR_findFirstByAttribute:CRMOrganizationAttributes.organizationID
																   withValue:organizationID
																   inContext:context];
	if (!organization) {
		organization = [CRMOrganization MR_createInContext:context];
		organization.organizationID = organizationID;
	}
	
	[organization updateWithContentsOfDictionary:dictionary];

	return organization;
}

- (void)updateWithContentsOfDictionary:(NSDictionary *)dictionary {
	self.organizationID = dictionary[@"id"];
	self.alias = dictionary[@"alias"];
	self.name = dictionary[@"name"];
	self.apiKey = dictionary[@"api_key"];
	self.accountsCount = dictionary[@"accounts_count"];
	self.organizationID = dictionary[@"id"];
	NSDictionary *appsCountDictionary = dictionary[@"apps_counts"];
	if ([appsCountDictionary isKindOfClass:[NSDictionary class]]) {
		__block NSUInteger appsCount = 0;
		[appsCountDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *type, NSNumber *count, BOOL *stop) {
			appsCount += [count unsignedIntegerValue];
		}];
		self.appsCountValue = appsCount;
	}
}

- (void)updateApplicationsWithContentsOfArray:(NSArray *)array {
	NSMutableSet *applicationsSet = [NSMutableSet setWithCapacity:[array count]];
	for (NSDictionary *applicationDictionary in array) {
		CRMApplication *application = [CRMApplication applicationWithContentsOfDictionary:applicationDictionary
																				inContext:self.managedObjectContext];
		if (application) {
			[applicationsSet addObject:application];
		}
	}
	self.applications = [applicationsSet copy];
}

@end
