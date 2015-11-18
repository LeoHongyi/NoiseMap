//
//  loginViewController.m
//  NoiseInfo
//
//  Created by apple on 11/16/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "loginViewController.h"
#import "MBProgressHUD+HM.h"
#import "ViewController.h"

@interface loginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)login:(id)sender;
- (IBAction)register;



@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.usernameField];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.passwordField];
    
    
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    
}

-(void)textChange
{
    self.loginBtn.enabled = (self.usernameField.text.length && self.passwordField.text.length);
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (IBAction)login:(id)sender {
    NSString *user = self.usernameField.text;
    NSString *password = self.passwordField.text;
    [MBProgressHUD showMessage:@"login....."];
    NSURL *url = [NSURL URLWithString:@"http://128.235.40.165:8080/Verify"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 5;
    request.HTTPMethod = @"POST";
    NSString *param = [NSString stringWithFormat:@"username=%@&password=%@",user,password];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //if (data) {
            //NSLog(@"success");
            NSString *str =  [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
           // NSLog(@"%@",str);
        [MBProgressHUD hideHUD];
       
        if ([str intValue] == 1) {
            [self performSegueWithIdentifier:@"login2map" sender:nil];
        }else{
            
            [MBProgressHUD showError:@"username or password error!"];
            
            
           
        }
    }];
    
    
}

- (IBAction)register {
    [self performSegueWithIdentifier:@"login2Reg" sender:nil];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"login2map"]){
        UIViewController *descV = segue.destinationViewController;
        ViewController *map = (ViewController *)descV;
        descV.title = [NSString stringWithFormat:@"%@'s map",self.usernameField.text];
        map.username  = self.usernameField.text;
    }
}
@end
