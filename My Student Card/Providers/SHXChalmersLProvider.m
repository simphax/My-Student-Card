//
//  SHXChalmersLProvider.m
//  My Student Card
//
//  Created by Simon on 2013-11-05.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXChalmersLProvider.h"
#import "SHXLunchRow.h"
#import "GDataXMLNode.h"

@implementation SHXChalmersLProvider

-(void)getLunchListWithCompletionHandler:(void(^)(NSArray *lunchlist, NSError *error))handler
{
    NSString *firstType = @"Xpress";
    
    NSString *restaurant = @"Kårrestaurangen";
    NSString *languageHandle = @"sv";
    
    NSString *urlString = [NSString stringWithFormat:@"http://cm.lskitchen.se/johanneberg/karrestaurangen/%@/2013-11-21.rss",languageHandle];
    
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
                                   GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data
                                                                                          options:0 error:&error];
                                   if(!error)
                                   {
                                       NSArray *itemXmlSearch = [doc nodesForXPath:@"//item" error:&error];
                                       
                                       if([itemXmlSearch count] > 0)
                                       {
                                           for(GDataXMLElement *itemElem in itemXmlSearch)
                                           {
                                               NSString *titleStr = @"";
                                               NSString *descStr = @"";
                                               
                                               NSArray *titleXmlSearch = [itemElem elementsForName:@"title"];
                                               if([titleXmlSearch count] > 0)
                                               {
                                                   GDataXMLNode *titleXmlObj = [titleXmlSearch objectAtIndex:0];
                                                   titleStr = [titleXmlObj stringValue];
                                               }
                                               
                                               NSArray *descXmlSearch = [itemElem elementsForName:@"description"];
                                               if([descXmlSearch count] > 0)
                                               {
                                                   GDataXMLNode *descXmlObj = [descXmlSearch objectAtIndex:0];
                                                   descStr = [descXmlObj stringValue];
                                               }
                                               
                                               if(![titleStr  isEqual: @""] && ![descStr  isEqual: @""])
                                               {
                                                   SHXLunchRow *newRow = [[SHXLunchRow alloc] init];
                                                   [newRow setRestaurant:restaurant];
                                                   [newRow setType:titleStr];
                                                   [newRow setMeal:descStr];
                                                   
                                                   [allLunchRows addObject:newRow];
                                               }
                                           }
                                       }

                                   }
                               }
                               
                               if([allLunchRows count] == 0 && !error)
                               {
                                   NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:@"Could not get any lunches. Unknown reason."
                                                                                         forKey:@"error"];
                                   error = [[NSError alloc] initWithDomain:@"com.simphax.MyStudentCard" code:1001 userInfo:errorInfo];
                               }
                               
                               //Move Xpress to first position.
                               for(SHXLunchRow *row in [allLunchRows copy])
                               {
                                   if([[row type] isEqualToString:firstType])
                                   {
                                       [allLunchRows removeObject:row];
                                       [allLunchRows insertObject:row atIndex:0];
                                   }
                               }
                               
                               handler(allLunchRows, error);
                           }];
}

@end
