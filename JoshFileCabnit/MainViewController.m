//
//  ViewController.m
//  JoshFileCabnit
//
//  Created by Charles Northup on 8/25/14.
//  Copyright (c) 2014 Contract. All rights reserved.
//

#import "MainViewController.h"
#import "CheckListViewController.h"
#import "ViewDocumentsViewController.h"
#import "UploadViewController.h"
#import "Defaults.h"

@interface MainViewController ()


@property (weak, nonatomic) IBOutlet UIView *containterView;
@property CheckListViewController* checkListViewController;
@property ViewDocumentsViewController* viewDocumentsViewController;
@property UploadViewController* uploadViewController;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segementedControl;
@property (weak, nonatomic) IBOutlet UIButton *helpFAQButton;
@property (weak, nonatomic) IBOutlet UIButton *legendButton;
@property (weak, nonatomic) IBOutlet UIButton *privacyButton;
@property NSURL* myLoginUrl;
@property NSURL* myDocumentsUrl;
@property NSUserDefaults* userDefaults;



@end

@implementation MainViewController
            
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    self.viewDocumentsViewController = [storyboard instantiateViewControllerWithIdentifier:@"ViewNavBar"];
    self.uploadViewController = [storyboard instantiateViewControllerWithIdentifier:@"UploadViewController"];
    self.checkListViewController = [storyboard instantiateViewControllerWithIdentifier:@"CheckListViewController"];
    
    
    NSString* tempEmail = @"cpa@example.com";
    
    [Defaults setUserDefault:tempEmail forkey:@"email"];


    //self.myDocumentsUrl = [NSURL URLWithString:@"http://taxzoc.herokuapp.com/api/folders?email=cpa@example.com"];
    
    [self login:[Defaults getUserDefaultForKey:@"email"] password:@"password"];
    
    //NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    

    

}

-(void)login:(NSString*)email password:(NSString*)password
{
    self.myLoginUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://taxzoc.herokuapp.com/api/authentication_tokens?email=%@&password=%@", email, password]];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:self.myLoginUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError* error = [NSError new];
        NSDictionary* myData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSLog(@"%@", [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error] class]);
        NSLog(@"%@", data.class);
        NSLog(@"%@", response.class);
        NSLog(@"%@", myData);
        
        [Defaults setUserDefaults:@[myData[@"auth_token"], [NSDate new]] forKeys:@[@"authorizationToken", @"lastTokenReceived"]];
        [MainViewController getDocuments:email];
    }];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    NSLog(@"%f",screenRect.size.height);
    if (screenRect.size.height == 548)
    {
        self.viewDocumentsViewController.view.frame = CGRectMake(self.viewDocumentsViewController.view.frame.origin.x, self.viewDocumentsViewController.view.frame.origin.y, self.viewDocumentsViewController.view.frame.size.width, 479);
        self.uploadViewController.view.frame = CGRectMake(self.uploadViewController.view.frame.origin.x, self.uploadViewController.view.frame.origin.y, self.uploadViewController.view.frame.size.width, 479);
        self.checkListViewController.view.frame = CGRectMake(self.checkListViewController.view.frame.origin.x, self.checkListViewController.view.frame.origin.y, self.checkListViewController.view.frame.size.width, 479);
        
        self.containterView.frame = CGRectMake(self.containterView.frame.origin.x, self.containterView.frame.origin.y, self.containterView.frame.size.width, (self.containterView.frame.size.height + 88));
        self.legendButton.frame = CGRectMake(self.legendButton.frame.origin.x, (self.legendButton.frame.origin.y + 88), self.legendButton.frame.size.width, self.legendButton.frame.size.height);
        self.helpFAQButton.frame = CGRectMake(self.helpFAQButton.frame.origin.x, (self.helpFAQButton.frame.origin.y + 88), self.helpFAQButton.frame.size.width, self.helpFAQButton.frame.size.height);
        self.privacyButton.frame = CGRectMake(self.privacyButton.frame.origin.x, (self.privacyButton.frame.origin.y + 88), self.privacyButton.frame.size.width, self.privacyButton.frame.size.height);
    }
    else
    {
        self.viewDocumentsViewController.view.frame = CGRectMake(self.viewDocumentsViewController.view.frame.origin.x, self.viewDocumentsViewController.view.frame.origin.y, self.viewDocumentsViewController.view.frame.size.width, 391);
        self.uploadViewController.view.frame = CGRectMake(self.uploadViewController.view.frame.origin.x, self.uploadViewController.view.frame.origin.y, self.uploadViewController.view.frame.size.width, 391);
        self.checkListViewController.view.frame = CGRectMake(self.checkListViewController.view.frame.origin.x, self.checkListViewController.view.frame.origin.y, self.checkListViewController.view.frame.size.width, 391);
    }
}

- (IBAction)pressedSegementedController:(UISegmentedControl*)sender
{
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self showUploadVC];
            break;
            
        case 1:
            [self showViewDocumentsVC];
            break;
            
        case 2:
            [self showCheckListVC];
            break;
            
        default:
            break;
    }
    NSLog(@"container %f", self.containterView.frame.size.height);
    UIView* view = self.containterView.subviews.firstObject;
    NSLog(@"subview %f", view.frame.size.height);
}


/**Documents are arranged as such
 
 *Array of folders
    *Dictionary   Folder Structure                           File Structure
                 id : 1                                          id : 1
               name : folder 1                                 name : file 1
         subfolders : [subfolder1, subfolder2]                 file : url to file
          documents : [file1, file2]
 
    *Dictionary Folder 2
**/
+(void)getDocuments:(NSString*)email
{
    NSURL* myUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://taxzoc.herokuapp.com/api/folders?email=%@",email]];

    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:myUrl];
    
    [request addValue:[NSString stringWithFormat:@"Token token=%@",[Defaults getUserDefaultForKey:@"authorizationToken"]] forHTTPHeaderField:@"Authorization"];
    //[request setHTTPMethod:@"POST"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSArray* myData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
        [Defaults setUserDefault:myData forkey:@"documents"];
        NSLog(@"the response it type %@", [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError] class]);
        NSLog(@"%@", [myData.firstObject class]);
    }];
}

-(void)showViewDocumentsVC
{
    [self removeUploadVC];
    [self removeCheckListVC];
    [self.containterView addSubview:self.viewDocumentsViewController.view];

    
}

-(void)showUploadVC
{
    [self removeCheckListVC];
    [self removeViewDocumentsVC];
    [self.containterView addSubview:self.uploadViewController.view];

}

-(void)showCheckListVC
{
    [self removeUploadVC];
    [self removeViewDocumentsVC];
    [self.containterView addSubview:self.checkListViewController.view];
}

-(void)removeUploadVC
{
    if (self.uploadViewController.view.superview != nil)
    {
        [self.uploadViewController.view removeFromSuperview];
    }
}

-(void)removeViewDocumentsVC
{
    if (self.viewDocumentsViewController.view.superview != nil)
    {
        [self.viewDocumentsViewController.view removeFromSuperview];
    }
}

-(void)removeCheckListVC
{
    if (self.checkListViewController.view.superview != nil)
    {
        [self.checkListViewController.view removeFromSuperview];
    }
    
}



@end
