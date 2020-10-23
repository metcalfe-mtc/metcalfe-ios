//
//  TransferDetailScene.m
//  Wallet
//
//  Created by 钱伟成 on 2019/9/27.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "TransferDetailScene.h"
#import "BVCTransferDetailModel.h"
#import "Masonry.h"
#import "RequestManager.h"
@interface TransferDetailScene ()
@property (weak, nonatomic) IBOutlet UILabel *title1;
@property (weak, nonatomic) IBOutlet UILabel *title2;
@property (weak, nonatomic) IBOutlet UILabel *title3;
@property (weak, nonatomic) IBOutlet UILabel *title4;
@property (weak, nonatomic) IBOutlet UILabel *title5;
@property (weak, nonatomic) IBOutlet UILabel *title6;
@property (weak, nonatomic) IBOutlet UILabel *title7;
@property (weak, nonatomic) IBOutlet UILabel *title8;
@property (weak, nonatomic) IBOutlet UILabel *title9;
@property (weak, nonatomic) IBOutlet UILabel *title10;

@property (weak, nonatomic) IBOutlet UILabel *detail1;
@property (weak, nonatomic) IBOutlet UILabel *detail2;
@property (weak, nonatomic) IBOutlet UILabel *detail3;
@property (weak, nonatomic) IBOutlet UILabel *detail4;
@property (weak, nonatomic) IBOutlet UILabel *detail5;
@property (weak, nonatomic) IBOutlet UILabel *detail6;
@property (weak, nonatomic) IBOutlet UILabel *detail7;
@property (weak, nonatomic) IBOutlet UILabel *detail8;
@property (weak, nonatomic) IBOutlet UILabel *detail9;
@property (weak, nonatomic) IBOutlet UILabel *detail10;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity2;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity3;

@property (nonatomic,strong) NSString *currency;
@property (nonatomic,strong) NSMutableDictionary *dataDict;
@property (nonatomic,strong) BVCTransferDetailModel *model;

@end

@implementation TransferDetailScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleViewWithWhiteTitle:GetStringWithKeyFromTable(@"交易详情_title", LOCALIZABE, nil)];
    [self requestDetailInfo];
    [self setupView];
    // Do any additional setup after loading the view from its nib.
}

-(void)requestDetailInfo{
    [RequestManager getTranscationDetailWithProgress:NO hash:self.HashStr success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        self.model = [BVCTransferDetailModel modelWithDict:responseObject];
        if(!self.model.validated){
            [self performSelector:@selector(requestDetailInfo) withObject:nil/*可传任意类型参数*/ afterDelay:1.0];
        }
        [self setupDate];
    } warn:^(NSString * _Nonnull content) {
        
    } error:^(NSString * _Nonnull content) {
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
    }];
}

-(void)setupView{
    self.title1.text = GetStringWithKeyFromTable(@"发款方_title", LOCALIZABE, nil);
    self.title2.text = GetStringWithKeyFromTable(@"收款方_title", LOCALIZABE, nil);
    self.title3.text = GetStringWithKeyFromTable(@"金额_title", LOCALIZABE, nil);
    self.title4.text = GetStringWithKeyFromTable(@"手续费_title", LOCALIZABE, nil);
    self.title5.text = GetStringWithKeyFromTable(@"交易类型_title", LOCALIZABE, nil);
    self.title6.text = GetStringWithKeyFromTable(@"状态_title", LOCALIZABE, nil);
    self.title7.text = GetStringWithKeyFromTable(@"交易哈希_title", LOCALIZABE, nil);
    self.title8.text = GetStringWithKeyFromTable(@"区块_title", LOCALIZABE, nil);
    self.title9.text = GetStringWithKeyFromTable(@"时间_title", LOCALIZABE, nil);
    self.title10.text = GetStringWithKeyFromTable(@"备注_title", LOCALIZABE, nil);
}

-(void)setupDate{
    self.detail1.text = self.model.transferAccount;
    self.detail2.text = self.model.receiverAccount;
    self.detail3.text = [NSString stringWithFormat:@"%@ %@",self.model.amount,self.model.currency];
    self.detail4.text = self.model.fee;
    self.detail5.text = self.model.transferType;
    if (self.model.validated) {
        self.activityView.hidden = YES;
        [self.activityView stopAnimating];
        self.activity2.hidden = YES;
        [self.activity2 stopAnimating];
        self.activity3.hidden = YES;
        [self.activity3 stopAnimating];
        self.detail6.text = self.model.status;
    }else{
        self.detail6.text = @"";
        self.activityView.hidden = NO;
        [self.activityView startAnimating];
        self.activity2.hidden = NO;
        [self.activity2 startAnimating];
        self.activity3.hidden = NO;
        [self.activity3 startAnimating];
    }
//    self.detail7.lineBreakMode = NSLineBreakByTruncatingMiddle;
    self.detail7.text = self.model.transferHash;
    self.detail8.text = [NSString stringWithFormat:@"%@",self.model.block];
    self.detail9.text = self.model.time;
    self.detail10.text = self.model.memo;
}

- (IBAction)copyAction1:(id)sender {
    UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.model.transferAccount;
    [self showString:GetStringWithKeyFromTable(@"发款方已复制_title", LOCALIZABE, nil) delay:1];
}

- (IBAction)copyAction2:(id)sender {
    UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.model.receiverAccount;
    [self showString:GetStringWithKeyFromTable(@"收款方已复制_title", LOCALIZABE, nil) delay:1];
}

- (IBAction)copyAction3:(id)sender {
    UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.model.transferHash;
    [self showString:GetStringWithKeyFromTable(@"交易哈希已复制_title", LOCALIZABE, nil) delay:1];
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
