//
//  ViewController.m
//  StickyMessageView
//
//  Created by XinWeizhou on 2017/5/4.
//  Copyright © 2017年 XinWeizhou. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%@",NSHomeDirectory());
    NSLog(@"%@",NSTemporaryDirectory());
    [[NSBundle mainBundle]  bundlePath];
    
    
    NSArray *arrDownloadPaths=NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory,NSUserDomainMask,YES);
    NSString *loadPathsPath=[arrDownloadPaths objectAtIndex:0];
    NSLog(@"Downloads path: %@",loadPathsPath);
    
    
    NSArray *arrCachesPaths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString *CachesPath=[arrCachesPaths objectAtIndex:0];
    NSLog(@"Caches path: %@",CachesPath);
    
    [[NSUserDefaults standardUserDefaults] setObject:@"Hello" forKey:@"Test"];
    
}
// /Users/Boat/Library/Developer/CoreSimulator/Devices/74F47580-7663-4E47-9C52-B1D833B9C4D0/data/Containers/Data/Application/2C158787-3C47-482F-A1A7-EE71323B9709

// /Users/Boat/Library/Developer/CoreSimulator/Devices/74F47580-7663-4E47-9C52-B1D833B9C4D0/data/Containers/Data/Application/2C158787-3C47-482F-A1A7-EE71323B9709/tmp/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
