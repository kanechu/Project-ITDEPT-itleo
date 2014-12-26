//
//  BarCodeViewController.m
//  itleo
//
//  Created by itdept on 14-12-15.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "BarCodeViewController.h"

#define LINE_SPACE 40

@interface BarCodeViewController ()
{
    int num;
    BOOL upOrdown;
    NSTimer *timer;
}

@property (strong,nonatomic)AVCaptureSession *session;

@property (retain,nonatomic)UIImageView *lineImgView;

@end

@implementation BarCodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fn_set_property];
    
    upOrdown=NO;
    num=0;
    _lineImgView=[[UIImageView alloc]initWithFrame:CGRectMake(LINE_SPACE, _imgView_pickBg.frame.origin.y, _imgView_pickBg.frame.size.width-LINE_SPACE*2, 2)];
    _lineImgView.image=[UIImage imageNamed:@"pick_line"];
    [self.view addSubview:_lineImgView];
    timer=[NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(fn_move_animation) userInfo:nil repeats:YES];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [self fn_setupCamera];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)fn_set_property{
    _ilb_alert_title.text=MY_LocalizedString(@"lbl_barcode_prompt", nil);
    
    _ibtn_cancel.layer.borderColor=COLOR_light_BLUE.CGColor;
    _ibtn_cancel.layer.borderWidth=1;
    [_ibtn_cancel setTitle:MY_LocalizedString(@"lbl_cancel", nil) forState:UIControlStateNormal];
}
#pragma makr -event action

- (void)fn_move_animation{
    if (upOrdown == NO) {
        num ++;
        _lineImgView.frame = CGRectMake(LINE_SPACE,  _imgView_pickBg.frame.origin.y+2*num, _imgView_pickBg.frame.size.width-LINE_SPACE*2, 2);
        if (2*num == 280) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _lineImgView.frame = CGRectMake(LINE_SPACE, _imgView_pickBg.frame.origin.y+2*num, _imgView_pickBg.frame.size.width-LINE_SPACE*2, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
}
- (void)fn_setupCamera{
    NSError *error;
    // Capture Device
    AVCaptureDevice *device=[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // Input
    AVCaptureDeviceInput *input=[AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        NSLog(@"%@",[error localizedDescription]);
        return ;
    }
    // Output
    AVCaptureMetadataOutput *output=[[AVCaptureMetadataOutput alloc]init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
   
    // Session
    _session=[[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:input])
    {
        [_session addInput:input];
    }
    
    if ([_session canAddOutput:output])
    {
        [_session addOutput:output];
    }
     // 条码支持类型
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeUPCECode]];
    
    // Preview
    AVCaptureVideoPreviewLayer *preview=[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    preview.frame=_imgView_pickBg.frame;
    preview.frame=CGRectMake(preview.frame.origin.x+5, preview.frame.origin.y+5, preview.frame.size.width-10, preview.frame.size.height-10);
    [self.view.layer insertSublayer:preview atIndex:0];
    // Start
    [_session startRunning];
}

- (IBAction)fn_cancel_scanning:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [timer invalidate];
        timer=nil;
    }];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    [_session stopRunning];
    [self dismissViewControllerAnimated:NO completion:^
     {
         [timer invalidate];
         timer=nil;
         if (_callback) {
             _callback(stringValue);
         }
     }];
}


@end
