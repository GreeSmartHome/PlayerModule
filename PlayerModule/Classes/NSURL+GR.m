//
//  NSURL+GR.m
//  PlayerModule_Example
//
//  Created by 冉东军 on 2020/3/15.
//  Copyright © 2020 18578216982@163.com. All rights reserved.
//

#import "NSURL+GR.h"

@implementation NSURL (GR)

- (NSURL *)streamingURL {
    
    NSURLComponents *compents = [NSURLComponents componentsWithString:self.absoluteString];
    compents.scheme = @"streaming";
    return compents.URL;
}


- (NSURL *)httpURL {
    NSURLComponents *compents = [NSURLComponents componentsWithString:self.absoluteString];
    compents.scheme = @"http";
    return compents.URL;
}

@end
