//
//  NSURL+GR.h
//  PlayerModule_Example
//
//  Created by 冉东军 on 2020/3/15.
//  Copyright © 2020 18578216982@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (GR)


/**
 获取streaming协议的url地址
 */
- (NSURL *)streamingURL;


- (NSURL *)httpURL;

@end

NS_ASSUME_NONNULL_END
