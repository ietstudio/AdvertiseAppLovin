//
//  ALAdvertiseHelper.h
//  Pods
//
//  Created by geekgy on 16/6/16.
//
//

#import <Foundation/Foundation.h>
#import "Macros.h"
#import "AdvertiseDelegate.h"

#define AppLovin_Name @"AppLovin"

@interface ALAdvertiseHelper : NSObject <AdvertiseDelegate>

SINGLETON_DECLARE(ALAdvertiseHelper)

@end
