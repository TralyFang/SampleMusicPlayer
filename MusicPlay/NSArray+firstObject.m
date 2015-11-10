//  NSArray+firstObject.m
//
//  NO COPYRIGHT AND ABSOLUTELY NO WARRANTY
//
//  DO WHAT EVER YOU WANT WITH THIS CATEGORY
#import "NSArray+firstObject.h"
@implementation NSArray (firstObject)
- (id) firstObject {
    if (self.count > 0) {
        return [self objectAtIndex:0];
    }else{
        return nil;
    }
}
@end
