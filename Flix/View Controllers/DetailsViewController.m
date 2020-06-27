//
//  DetailsViewController.m
//  Flix
//
//  Created by Benjamin Charles Hora on 6/24/20.
//  Copyright © 2020 Ben Hora. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "WebViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Get poster image
    [self makePoster];
    
    // Get backdrop image
    [self makeBackdrop];
    
    // Set movie title
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"overview"];
    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
    
}

- (void)makePoster {
    // Get poster image
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:posterURL];
    __weak DetailsViewController *weakSelf = self;
    [self.posterView setImageWithURLRequest:request placeholderImage:nil
                                    success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
                                            
                                            // imageResponse will be nil if the image is cached
                                            if (imageResponse) {
                                                NSLog(@"Image was NOT cached, fade in image");
                                                weakSelf.posterView.alpha = 0.0;
                                                weakSelf.posterView.image = image;
                                                
                                                //Animate UIImageView back to alpha 1 over 0.3sec
                                                [UIView animateWithDuration:0.3 animations:^{
                                                    weakSelf.posterView.alpha = 1.0;
                                                }];
                                            }
                                            else {
                                                NSLog(@"Image was cached so just update the image");
                                                weakSelf.posterView.image = image;
                                            }
                                        }
                                        failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {}];
}

- (void)makeBackdrop {
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *backdropURLString = self.movie[@"backdrop_path"];
    NSString *fullBackgropURLString = [baseURLString stringByAppendingString:backdropURLString];
    NSURL *backdropURL = [NSURL URLWithString:fullBackgropURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:backdropURL];
    __weak DetailsViewController *weakSelf = self;
    [self.backdropView setImageWithURLRequest:request placeholderImage:nil
                                    success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
                                            
                                            // imageResponse will be nil if the image is cached
                                            if (imageResponse) {
                                                NSLog(@"Image was NOT cached, fade in image");
                                                weakSelf.backdropView.alpha = 0.0;
                                                weakSelf.backdropView.image = image;
                                                
                                                //Animate UIImageView back to alpha 1 over 0.3sec
                                                [UIView animateWithDuration:0.3 animations:^{
                                                    weakSelf.backdropView.alpha = 1.0;
                                                }];
                                            }
                                            else {
                                                NSLog(@"Image was cached so just update the image");
                                                weakSelf.backdropView.image = image;
                                            }
                                        }
                                        failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {}];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    WebViewController *webViewController = [segue destinationViewController];
    webViewController.movie = self.movie;
}

@end
