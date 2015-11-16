//
//  RegisterViewController.m
//  NoiseInfo
//
//  Created by apple on 11/16/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "RegisterViewController.h"
#import "MBProgressHUD+HM.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *reguserTextField;
@property (weak, nonatomic) IBOutlet UITextField *regPwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
- (IBAction)register:(id)sender;




@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.reguserTextField];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.regPwdTextField];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


-(void)textChange
{
    self.registerBtn.enabled = (self.reguserTextField.text.length && self.regPwdTextField.text.length);
}



- (IBAction)register:(id)sender {
    NSString *regUser = self.reguserTextField.text;
    NSString *regPwd = self.regPwdTextField.text;
    //http://128.235.40.165:8080/Register
    [MBProgressHUD showMessage:@"register....."];
    NSURL *url = [NSURL URLWithString:@"http://128.235.40.165:8080/Register"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 5;
    request.HTTPMethod = @"POST";
    NSString *param = [NSString stringWithFormat:@"username=%@&password=%@",regUser,regPwd];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [MBProgressHUD hideHUD];
        NSString *str =  [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        if([str intValue] == 1){
            
            //[MBProgressHUD showSuccess:@"register success!"];
           [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [MBProgressHUD showError:@"register error!"];
            
        
        
        }
            
        
        
    }];
    
    
}

@end
