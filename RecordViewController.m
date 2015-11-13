//
//  RecordViewController.m
//  NoiseInfo
//
//  Created by apple on 11/4/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "RecordViewController.h"
#import <MapKit/MapKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD+HM.h"
#define NOISE_RECOGNIZER_DEFAULT_REFERENCE_LEVEL 5
#define NOISE_RECOGNIZER_DEFAULT_RANGE 160
#define NOISE_RECOGNIZER_DEFAULT_OFFSET 50

@interface RecordViewController ()
{
    NSMutableArray *_testArr;
}
@property (weak, nonatomic) IBOutlet UILabel *seconds;
@property (weak, nonatomic) IBOutlet UITextField *longtitude;
@property (weak, nonatomic) IBOutlet UITextField *latitude;
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *db;

@property(nonatomic,strong) AVAudioRecorder *recorder;


//@property(nonatomic,strong) CADisplayLink *timer;

- (IBAction)upload:(id)sender;

@end

@implementation RecordViewController
//-(NSMutableArray *)testArr
//{
//    if (_testArr) {
//        _testArr = [NSMutableArray array];
//    }
//    return _testArr;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view endEditing:YES];

    self.longtitude.text = self.lon;
    self.latitude.text = self.lat;
    //self.user = self.userTextField.text;
    self.offset = NOISE_RECOGNIZER_DEFAULT_OFFSET;
    self.range = NOISE_RECOGNIZER_DEFAULT_RANGE;
    self.referenceLevel = NOISE_RECOGNIZER_DEFAULT_REFERENCE_LEVEL;
    if (_testArr == nil) {
        _testArr = [NSMutableArray array];
    }
    
//    NSTimer *t = [NSTimer scheduledTimerWithTimeInterval: 2.0
//                                                  target: self
//                                                selector:@selector(record)
//                                                userInfo: nil repeats:NO];
}

- (IBAction)cancel:(id)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)upload:(id)sender {
    self.user = self.userTextField.text;
  NSLog(@"%@,%@,%@,%@",self.lat,self.lon,self.db1,self.user);
//    if (self.user.length == 0) {
//        [MBProgressHUD showError:@"please input user name"];
//        return;
//    }
//    if (self.db1.length == 0) {
//        [MBProgressHUD showError:@"please record first"];
//    }
     [MBProgressHUD showMessage:@"upload to server..."];
      NSURL *url = [NSURL URLWithString:@"http://128.235.40.165:8080/ReceiveData"];  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
       request.timeoutInterval = 5;
       request.HTTPMethod = @"POST";
   
     NSString *param = [NSString stringWithFormat:@"lon=%f&lat=%f&dB=%d&user=%@",[self.lon floatValue],[self.lat floatValue],[self.db1 intValue],self.user];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [MBProgressHUD hideHUD];
        
        if (data) {
            NSLog(@"success");
           NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
          [self dismissViewControllerAnimated:YES completion:nil];
        }
        
        
    }];
    
    
    
}

- (IBAction)record:(id)sender {
   
    
    //音频文件名
    NSString *audioName = @"test.caf";
    
    //doc目录
    
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *fileURL = [doc stringByAppendingPathComponent:audioName];
    
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                              [NSNumber numberWithInt: 2],                         AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
                              nil];

    self.recorder = [[AVAudioRecorder alloc]initWithURL:[NSURL fileURLWithPath:fileURL] settings:settings error:nil];
    AVAudioSession * session = [AVAudioSession sharedInstance];
    NSError * sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    [session setActive:YES error:nil];
    [self.recorder prepareToRecord];
    self.recorder.meteringEnabled = YES;
    [self.recorder record];
    self.mainInt = 30;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(stop) userInfo:nil repeats:YES];
    
    
    
}
-(void)stop{
    [self.recorder updateMeters];
    self.mainInt -= 1;
    self.seconds.text = [NSString stringWithFormat:@"%i",self.mainInt];
   // NSLog(@"%d",self.offset);
    float averagePower = [self.recorder averagePowerForChannel:0];

    int SPL = [self SPL:averagePower];
    NSLog(@"%d",SPL);
    [_testArr addObject:[NSNumber numberWithInt:SPL]];
    
    if (self.mainInt == 0) {
        self.seconds.text = [NSString stringWithFormat:@"30"];
       //NSLog(@"%@",_testArr);
    //self.db.text = @"10.0";
       NSString *db =[_testArr valueForKeyPath:@"@max.self"];
        self.db1 = db;
        NSLog(@"max is %@",db);
        self.db.text = [NSString stringWithFormat:@"%@",db];
        [self.recorder stop];
        [self.timer invalidate];
        [MBProgressHUD showSuccess:@"record success"];
    
        
    }
    
}

-(int)SPL:(float)decibelsPower {
    int SPL = 20 * log10(self.referenceLevel * powf(10, (decibelsPower/20)) * self.range + self.offset);
    return SPL;
}
//- (IBAction)stop:(id)sender {
//    [self.recorder stop];
//    //[self.recorder deleteRecording];
//}


@end
