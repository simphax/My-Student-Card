//
//  SHXChalmersLProvider.m
//  My Student Card
//
//  Created by Simon on 2013-11-05.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXChalmersLProvider.h"
#import "SHXLunchRow.h"

@implementation SHXChalmersLProvider

-(void)getLunchListWithCompletionHandler:(void(^)(NSArray *lunchlist, NSError *error))handler
{
    NSString *restaurant = @"Kårrestaurangen";
    NSString *languageHandle = @"Sv";
    
    NSString *urlString = @"http://screens.lskitchen.se/rest1";
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:10.0];
    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               NSMutableArray *allLunchRows = [[NSMutableArray alloc] init];
                               
                               if(!error)
                               {
                                   id object = [NSJSONSerialization
                                                JSONObjectWithData:data
                                                options:0
                                                error:&error];
                                   if(!error)
                                   {
                                       //Traversing step by step through the JSON result.
                                       if([object isKindOfClass:[NSDictionary class]])
                                       {
                                           id items = [object objectForKey:@"Items"];
                                           if([items isKindOfClass:[NSArray class]])
                                           {
                                               for(id item in items)
                                               {
                                                   NSString *type = nil;
                                                   NSString *meal = nil;
                                                   
                                                   
                                                   if([item isKindOfClass:[NSDictionary class]])
                                                   {
                                                       NSDictionary *lunchItem = item;
                                                       
                                                       id name = [lunchItem objectForKey:@"Name"];
                                                       if([name isKindOfClass:[NSString class]])
                                                       {
                                                           type = name;
                                                       }
                                                       
                                                       id values = [lunchItem objectForKey:@"Values"];
                                                       if([values isKindOfClass:[NSArray class]])
                                                       {
                                                           NSArray *mealInfos = values;
                                                           
                                                           for(id mealInfo in mealInfos)
                                                           {
                                                               if([mealInfo isKindOfClass:[NSDictionary class]])
                                                               {
                                                                   id language = [mealInfo objectForKey:@"LanguageName"];
                                                                   
                                                                   if([languageHandle isEqual:language])
                                                                   {
                                                                       id mealDescription = [mealInfo objectForKey:@"Value"];
                                                                       if([mealDescription isKindOfClass:[NSString class]])
                                                                       {
                                                                           meal = mealDescription;
                                                                       }
                                                                   }
                                                               }
                                                           }
                                                       }
                                                   }
                                                   
                                                   if(type != nil && meal != nil)
                                                   {
                                                       SHXLunchRow *lunchRow = [[SHXLunchRow alloc] init];
                                                       [lunchRow setRestaurant:restaurant];
                                                       [lunchRow setType:type];
                                                       [lunchRow setMeal:meal];
                                                       [allLunchRows addObject:lunchRow];
                                                   }
                                               }
                                           }
                                       }
                                   }
                               }
                               
                               if([allLunchRows count] == 0 && !error)
                               {
                                   NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:@"Could not get balance. Unknown reason."
                                                                                         forKey:@"error"];
                                   error = [[NSError alloc] initWithDomain:@"com.simphax.MyStudentCard" code:1001 userInfo:errorInfo];
                               }
                               
                               handler(allLunchRows, error);
                           }];
}

@end
