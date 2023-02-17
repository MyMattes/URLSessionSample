#import <Foundation/Foundation.h>
#import "DGRequest.h"

int main(int argc, const char * argv[])
{
	@autoreleasepool
	{
		NSString *urlString = @"https://www.stitchbuddy.de";
		DGRequest *request = [[DGRequest alloc] initWithString:urlString completionHandler:^(BOOL success, NSError *error, NSString *result)
		{
			NSLog(@"Request to \"%@\" completed: %i", urlString, success);
			if (success)
			{
				NSLog(@"Result: %@", result);
			}
			else
			{
				NSLog(@"Error: %@", error.localizedDescription);
			}
		}];

		[[NSRunLoop mainRunLoop] run];
	}
	return 0;
}
