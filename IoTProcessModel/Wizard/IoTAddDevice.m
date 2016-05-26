/**
 * IoTAddDevice.m
 *
 * Copyright (c) 2014~2015 Xtreme Programming Group, Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "IoTAddDevice.h"
#import "IoTWifiUtil.h"
#import "IoTConfigure.h"

@interface IoTAddDevice () <UITextFieldDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UILabel *textWifiName;

@property (strong, nonatomic) NSString *ssid;
@property (weak, nonatomic) IBOutlet IoTPasswordField *textPass;

@property (assign, nonatomic) NSInteger wifiType;
@property (weak, nonatomic) IBOutlet UIButton *wifiSelectBtn;
@property (strong, nonatomic) NSArray *wifiTypeArray;
@property (strong, nonatomic) UIActionSheet *actionSheet;


//@property (weak, nonatomic) IBOutlet UITableViewCell *wifiType;

@end

@implementation IoTAddDevice

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.wifiType.textLabel.text = @"请选择Wifi类型";
//    self.wifiType.detailTextLabel.text = @"庆科";
    
    [self didBecomeActive];
    self.wifiTypeArray = [NSArray arrayWithObjects:@"庆科",@"汉枫",@"RealTek",@"联盛德",@"乐鑫",@"高通",@"TI", nil];
    self.wifiType = 0;
    [self.wifiSelectBtn setTitle:[self.wifiTypeArray objectAtIndex:self.wifiType] forState:UIControlStateNormal];
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"庆科",@"汉枫",@"RealTek",@"联盛德",@"乐鑫",@"高通",@"TI",nil];
    [self.textPass becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    self.stepFrame.currentStepIndex = 2;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.textPass.text = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)didBecomeActive
{
    self.ssid = [[IoTWifiUtil SSIDInfo] valueForKey:@"SSID"];
    if(nil == self.ssid)
    {
        self.ssid = @"";
    }
    self.textWifiName.text = [NSString stringWithFormat:@"WiFi 名称：%@", self.ssid];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onNext:(id)sender {
    if(self.ssid.length > 0)
    {
        IoTConfigure *configure = [[IoTConfigure alloc] initWithAirLink:self.ssid password:self.textPass.text wifiType:self.wifiType];
        [self.navigationController pushViewController:configure animated:YES];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请保持 Wi-Fi 连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }
}

- (IBAction)onTap:(id)sender {
    [self.textPass resignFirstResponder];
}

- (IBAction)selectWifiType:(id)sender {
    [self.textPass resignFirstResponder];
    [self.actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex < self.wifiTypeArray.count) {
        self.wifiType = buttonIndex;
        [self.wifiSelectBtn setTitle:[self.wifiTypeArray objectAtIndex:self.wifiType] forState:UIControlStateNormal];
    }
    [self.textPass becomeFirstResponder];
}

- (BOOL)IoTStepFrameShouldCancelStep {
    [self.navigationController popViewControllerAnimated:YES];
    return YES;
}

#pragma mark - Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self onNext:textField];
    return YES;
}

@end
