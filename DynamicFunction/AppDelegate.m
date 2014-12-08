//
//  AppDelegate.m
//  DynamicFunction
//
//  Created by organlounge on 2014/12/08.
//  Copyright (c) 2014年 KAMEDAkyosuke. All rights reserved.
//

#import "AppDelegate.h"

#include <unistd.h>
#include <stdlib.h>
#include <sys/mman.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    uint32_t code[] = {
        0xe0800001,    // add r0, r0, #1
        0xe12fff1e,    // br  lr
    };
    
    uint32_t *p;
    long pagesize = sysconf(_SC_PAGE_SIZE);
    NSLog(@"pagesize %@", @(pagesize));
    int r = posix_memalign((void **)&p, pagesize, pagesize);
    if(r != 0){
        int err = errno;
        NSCAssert(NO, @"posix_memalign failed %s(%d) ", strerror(err), err);
    }
    int len = sizeof(code)/sizeof(code[0]);
    for(int i=0; i<len; ++i){
        p[i] = code[i];
    }
    
    int errcode = mprotect(p, pagesize, PROT_READ | PROT_EXEC);
    if (errcode != 0) {
        int err = errno;
        NSCAssert(NO, @"mprotect failed %s(%d) ", strerror(err), err);
    }
    
    NSLog(@"inc(10) = %d", ((int(*)(int))p)(10));
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
