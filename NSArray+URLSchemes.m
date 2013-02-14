#import "NSArray+URLSchemes.h"

@implementation NSArray (URLSchemes)
+(NSArray *)urlSchemes {
    NSDictionary *cacheDict;
    NSDictionary *user;
    NSDictionary *system;
    NSMutableArray *testArray = [[NSMutableArray alloc] init];
    NSString *bundle = NULL;
    
    static NSString *const cacheFileName = @"com.apple.mobile.installation.plist";
    NSString *relativeCachePath = [[@"Library" stringByAppendingPathComponent: @"Caches"] stringByAppendingPathComponent: cacheFileName];
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent: @"../.."] stringByAppendingPathComponent: relativeCachePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath: path isDirectory:NO]) {
        
        cacheDict = [NSDictionary dictionaryWithContentsOfFile: path];
        user = [cacheDict objectForKey:@"User"];
        
        for (NSString *appIdentifier in [user allKeys]) {
            for (NSDictionary *m in [[user objectForKey:appIdentifier] objectForKey:@"CFBundleURLTypes"]) {
                if (![[[m objectForKey:@"CFBundleURLSchemes"] objectAtIndex:0] hasPrefix:@"fb"] || [[[m objectForKey:@"CFBundleURLSchemes"] objectAtIndex:0] hasPrefix:@"fbauth"] ) {
                    //NSLog(@"%@",m);
                    if ([[[user objectForKey:appIdentifier] objectForKey:@"CFBundleURLTypes"] count]) {
                        if ([[user objectForKey:appIdentifier] objectForKey:@"CFBundleIconFile"]) {
                            bundle = [NSString stringWithFormat:@"%@/%@",[[user objectForKey:appIdentifier] objectForKey:@"Path"],[[user objectForKey:appIdentifier] objectForKey:@"CFBundleIconFile"]];  
                        }
                        else if ([[[user objectForKey:appIdentifier] objectForKey:@"CFBundleIconFiles"] count]) {
                            bundle = [NSString stringWithFormat:@"%@/%@",[[user objectForKey:appIdentifier] objectForKey:@"Path"],[[[user objectForKey:appIdentifier] objectForKey:@"CFBundleIconFiles"] objectAtIndex:0]];   
                        }
                        else {
                            NSArray *DC = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[user objectForKey:appIdentifier] objectForKey:@"Path"] error:nil];
                            
                            if ([DC containsObject:@"icon.png"]) bundle = [NSString stringWithFormat:@"%@/icon.png",[[user objectForKey:appIdentifier] objectForKey:@"Path"]];
                            
                            else if ([DC containsObject:@"Icon.png"]) bundle = [NSString stringWithFormat:@"%@/Icon.png",[[user objectForKey:appIdentifier] objectForKey:@"Path"]];
                            
                            else if ([DC containsObject:@"AppIcon.png"])
                                bundle = [NSString stringWithFormat:@"%@/AppIcon.png",[[user objectForKey:appIdentifier] objectForKey:@"Path"]];
                            
                            else if ([DC containsObject:@"Icon-iPhone.png"]) bundle = [NSString stringWithFormat:@"%@/Icon-iPhone.png",[[user objectForKey:appIdentifier] objectForKey:@"Path"]];
                            
                            else if ([DC containsObject:@"App-Icon-iPhone.png"]) bundle = [NSString stringWithFormat:@"%@/App-Icon-iPhone.png",[[user objectForKey:appIdentifier] objectForKey:@"Path"]];
                        }
                        [testArray addObject:[NSArray arrayWithObjects:[[user objectForKey:appIdentifier] objectForKey:@"CFBundleDisplayName"], [[m objectForKey:@"CFBundleURLSchemes"] objectAtIndex:0],bundle, nil]];

                    }
                    break;
                }
            }
        }
        
        system = [cacheDict objectForKey:@"System"];
        
        for (NSString *appIdentifier in [system allKeys]) {
            if ([[[system objectForKey:appIdentifier] objectForKey:@"CFBundleURLTypes"] count]) {
                NSArray *DC = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[system objectForKey:appIdentifier] objectForKey:@"Path"] error:nil];
                NSArray *onlyIcons = [DC filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self beginswith[cd] %@",[@"icon" lowercaseString]]];
                
                if ([onlyIcons containsObject:@"icon.png"]) bundle = [NSString stringWithFormat:@"%@/icon.png",[[system objectForKey:appIdentifier] objectForKey:@"Path"]];
                
                else if ([onlyIcons containsObject:@"Icon.png"]) bundle = [NSString stringWithFormat:@"%@/Icon.png",[[system objectForKey:appIdentifier] objectForKey:@"Path"]];
                
                else if ([onlyIcons containsObject:@"icon@2x.png"]) bundle = [NSString stringWithFormat:@"%@/icon@2x.png",[[system objectForKey:appIdentifier] objectForKey:@"Path"]];
                
                else if ([onlyIcons containsObject:@"Icon@2x.png"]) bundle = [NSString stringWithFormat:@"%@/Icon@2x.png",[[system objectForKey:appIdentifier] objectForKey:@"Path"]];
                
                else if ([onlyIcons containsObject:@"icon~iphone.png"]) bundle = [NSString stringWithFormat:@"%@/icon~iphone.png",[[system objectForKey:appIdentifier] objectForKey:@"Path"]];
                
                else if ([onlyIcons containsObject:@"icon@2x~iphone.png"]) bundle = [NSString stringWithFormat:@"%@/icon@2x~iphone.png",[[system objectForKey:appIdentifier] objectForKey:@"Path"]];
                
                
                
                if ([[system objectForKey:appIdentifier] objectForKey:@"CFBundleDisplayName"]) 
                    [testArray addObject:[NSArray arrayWithObjects:[[system objectForKey:appIdentifier] objectForKey:@"CFBundleDisplayName"], [[[[[system objectForKey:appIdentifier] objectForKey:@"CFBundleURLTypes"] objectAtIndex:0] objectForKey:@"CFBundleURLSchemes"] objectAtIndex:0],bundle, nil]];
                else if ([[system objectForKey:appIdentifier] objectForKey:@"CFBundleName"])
                    [testArray addObject:[NSArray arrayWithObjects:[[system objectForKey:appIdentifier] objectForKey:@"CFBundleName"], [[[[[system objectForKey:appIdentifier] objectForKey:@"CFBundleURLTypes"] objectAtIndex:0] objectForKey:@"CFBundleURLSchemes"] objectAtIndex:0],bundle, nil]];
                
            }
            else if ([[[system objectForKey:appIdentifier] objectForKey:@"CFBundleURLTypes~iphone"] count]) {
                
            }
        }
    }
    
    return [testArray autorelease];
    
}
@end
