//
//  WebViewController.m
//  Flix
//
//  Created by Benjamin Charles Hora on 6/26/20.
//  Copyright © 2020 Ben Hora. All rights reserved.
//

#import "WebViewController.h"
#import "DetailsViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()

@property (nonatomic, weak) NSString *idVal;
@property (weak, nonatomic) IBOutlet WKWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.idVal = [self.movie[@"id"] stringValue];
    
    [self fetchTrailer];
}

- (void)fetchTrailer {
    NSString *beforeID = @"https://api.themoviedb.org/3/movie/";
    NSString *afterID = @"/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US";
    NSString *urlString = [[beforeID stringByAppendingFormat:@"%@", self.idVal] stringByAppendingFormat:@"%@", afterID];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Load Trailer"
                                                                              message:@"The Internet connection appears to be offline."
                                                                       preferredStyle:(UIAlertControllerStyleAlert)];
               // create a cancel action
               UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Try Again"
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                        // handle cancel response here. Doing nothing will dismiss the view.
                                                                        // restart attempting to load movies when try again clicked
                   [self fetchTrailer];
                                                                 }];
               // add the cancel action to the alertController
               [alert addAction:cancelAction];
               [self presentViewController:alert animated:YES completion:^{}];
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               NSArray *results = dataDictionary[@"results"];
               // Check if no trailers are available for this movie
               if ([results count] == 0) {
                   UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Trailers Available"
                                                                                  message:@"This movie does not have any accessible trailers."
                                                                           preferredStyle:(UIAlertControllerStyleAlert)];
                   // create a cancel action
                   UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Back"
                                                                       style:UIAlertActionStyleCancel
                                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                                            // handle cancel response here. Doing nothing will dismiss the view.
                                                                            // restart attempting to load movies when try again clicked
                       [[self navigationController] popViewControllerAnimated:YES];
                                                                     }];
                   // add the cancel action to the alertController
                   [alert addAction:cancelAction];
                   [self presentViewController:alert animated:YES completion:^{}];
               }
               else {
                   NSString *trailerID = results[0][@"key"];
                   NSString *youtube = @"https://www.youtube.com/watch?v=";
                   NSString *trailerURLString = [youtube stringByAppendingString:trailerID];
                   NSURL *trailerURL = [NSURL URLWithString:trailerURLString];
                   NSURLRequest *request = [NSURLRequest requestWithURL:trailerURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
                   [self.webView loadRequest:request];
               }
           }
       }];
    [task resume];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
