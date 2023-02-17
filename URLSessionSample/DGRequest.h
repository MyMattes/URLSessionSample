#import <Foundation/Foundation.h>

@interface DGRequest : NSObject

typedef void (^DGRequestCompletionHandler)(BOOL success, NSError *error, NSString *result);

- (instancetype)initWithString:(NSString *)urlString completionHandler:(DGRequestCompletionHandler)completionHandler;
- (instancetype)initWithURL:(NSURL *)url completionHandler:(DGRequestCompletionHandler)completionHandler;

@end
