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
#define AppLovin_Key  @"AppLovin_Key"
#define AppLovin_Placement @"AppLovin_Placement"

@interface ALAdvertiseHelper : NSObject <AdvertiseDelegate>

SINGLETON_DECLARE(ALAdvertiseHelper)

@end
