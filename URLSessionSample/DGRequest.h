#import <Foundation/Foundation.h>

@interface DGRequest : NSObject

- (instancetype)initWithString:(NSString *)urlString completionHandler:(void (^)(BOOL success, NSError *error, NSString *result))completionHandler;
- (instancetype)initWithURL:(NSURL *)url completionHandler:(void (^)(BOOL success, NSError *error, NSString *result))completionHandler;

@end
