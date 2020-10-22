//
//  WordBackUpScene.m
//  Wallet
//
//  Created by 钱伟成 on 2019/9/9.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "WordBackUpScene.h"
#import "BackUpConfirmScene.h"
#import "NSString+AES.h"
#import "NSString+COD.h"
@interface WordBackUpScene ()
@property (strong, nonatomic) UIView *wordsView;
@property (assign, nonatomic) CGFloat wordsHeight;
@property (strong, nonatomic) UIButton *nextStepButton;
@property (weak, nonatomic) IBOutlet UILabel *briefLabel;


@property(nonatomic,strong) NSArray *wordsArr;
@end

@implementation WordBackUpScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleViewWithWhiteTitle:GetStringWithKeyFromTable(@"备份助记词_title", LOCALIZABE, nil)];

    self.briefLabel.text = GetStringWithKeyFromTable(@"请正确抄写_brief", LOCALIZABE, nil);
    
    __weak WordBackUpScene *weakSelf = self;
[self showProgressHUDWithString:GetStringWithKeyFromTable(@"正在生成中_message", LOCALIZABE, nil)];
    self.generateMasterKeyWithSecret = ^(id  _Nullable responseObject) {
        [weakSelf hideProgressHUDString];
        weakSelf.wordsArr = [responseObject componentsSeparatedByString:@" "];
        [weakSelf setupLayoutViews];
        [weakSelf.view addSubview:weakSelf.wordsView];
        [weakSelf.view addSubview:weakSelf.nextStepButton];
    };
    NSString *secret = [self.type isEqualToString:@"1"]?[self.wallet.secret AES128DecryptWithkey:self.words]:self.words;
    [self generateMasterKeyWithSecretAction:secret];
    
    

    // Do any additional setup after loading the view from its nib.
}

-(void)setupLayoutViews{
    
    CGFloat x = 15;
    CGFloat y = 10;
    
    for (int i = 0; i < self.wordsArr.count; i++) {
        
        UIButton *label = [self buttonWithTitle:self.wordsArr[i]];
        CGFloat width = [self widthForString:self.wordsArr[i] fontSize:13] + 30;
        
        if (x + width + 15 > WIDTH) {
            y += 34;//换行
            x = 15; //15位置开始
        }
        
        label.frame = CGRectMake(x, y, width, 24);
        label.tag = i;
        [self.wordsView addSubview:label];
        x += width + 10;//宽度+间隙
    }
    self.wordsHeight = y+34;
}

- (UIButton *)buttonWithTitle:(NSString *)title{
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button sizeToFit];
    button.layer.cornerRadius = 12;
    button.userInteractionEnabled = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
    button.backgroundColor = RGB(230, 233, 235);
    return button;
}

-(float)widthForString:(NSString *)value fontSize:(float)fontSize
{
    UIColor  *backgroundColor=[UIColor blackColor];
    UIFont *font=[UIFont boldSystemFontOfSize:13];
    CGRect sizeToFit = [value boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 27) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{
                                                                                                                                          NSForegroundColorAttributeName:backgroundColor,
                                                                                                                                          NSFontAttributeName:font
                                                                                                                                          } context:nil];
    
    return sizeToFit.size.width;
}

- (void)nextStepAction{
    if(self.type){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        BackUpConfirmScene *scene = [[BackUpConfirmScene alloc] init];
        scene.wallet = self.wallet;
        scene.words = self.wordsArr;
        [self.navigationController pushViewController:scene animated:YES];
    }

}

-(UIView *)wordsView{
    if(!_wordsView){
        _wordsView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, WIDTH, self.wordsHeight)];
        _wordsView.backgroundColor = BACKAREACOLOR;
    }
    return _wordsView;
}



-(UIButton *)nextStepButton{
    if(!_nextStepButton){
        _nextStepButton = [[UIButton alloc] initWithFrame:CGRectMake(45, self.wordsHeight+95, WIDTH-90, 40)];
        [_nextStepButton setTitle:self.type?GetStringWithKeyFromTable(@"完成_button", LOCALIZABE, nil):GetStringWithKeyFromTable(@"下一步_button", LOCALIZABE, nil) forState:UIControlStateNormal];
        [_nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextStepButton.backgroundColor = CLICKABLE_COLOR;
        _nextStepButton.layer.cornerRadius = 20;
        _nextStepButton.layer.masksToBounds = YES;
        [_nextStepButton addTarget:self action:@selector(nextStepAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextStepButton;
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
