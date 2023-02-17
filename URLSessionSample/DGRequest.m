#import "DGRequest.h"

@interface DGRequest () <NSURLSessionDataDelegate>

typedef void (^DGRequestCompletionHandler)(BOOL success, NSError *error, NSString *result);

@property (strong) DGRequestCompletionHandler completionHandler;
@property (strong) NSMutableData *responseData;

@end

@implementation DGRequest

- (instancetype)init
{
	// Minimal initializer, working with a default request to Google (for testing only)

	return [self initWithURL:[NSURL URLWithString:@"https://www.google.com"] completionHandler:nil];
}

- (instancetype)initWithString:(NSString *)urlString completionHandler:(void (^)(BOOL success, NSError *error, NSString *result))completionHandler
{
	// Convenience initializer, working with a URL string

	return [self initWithURL:[NSURL URLWithString:urlString] completionHandler:completionHandler];
}

- (instancetype)initWithURL:(NSURL *)url completionHandler:(void (^)(BOOL success, NSError *error, NSString *result))completionHandler
{
	// Designated initializer; remember the completionHandler, to be called once the reponse has been finished

	if (self = [super init])
	{
		self.completionHandler = completionHandler;

		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	    request.HTTPMethod = @"GET";
		NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
	    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
		NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
		[task resume];
	}
	return self;
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
	// First reponse, initialize the data object to hold chunks

	self.responseData = [NSMutableData data];
	completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
	// Repetitive response, add chunk to data property

	[self.responseData appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
	// Response has been finished, use the completionHandler property to loop back to the caller with results

	if (error)
	{
		self.responseData = nil;
		if (self.completionHandler) self.completionHandler(FALSE, error, nil);
    }
    else
    {
    	NSString *responseString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
		if (self.completionHandler) self.completionHandler(TRUE, nil, responseString);
    }
}

@end
