//
//  BackUpConfirmScene.m
//  Wallet
//
//  Created by 钱伟成 on 2019/9/5.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "BackUpConfirmScene.h"
#import "TabbarController.h"
#import "WalletDetailScene.h"
@interface BackUpConfirmScene ()
@property (weak, nonatomic) IBOutlet UIView *wordsConfirmView;
@property (weak, nonatomic) IBOutlet UIView *wordsBriefView;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;

@property (weak, nonatomic) IBOutlet UILabel *briefLabel;
@property(nonatomic,strong) NSArray *showWords;
@property(nonatomic,strong) NSMutableArray *confirmWords;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wordsHeight;
@property (strong, nonatomic) UILabel *placeHolderLabel;
@end

@implementation BackUpConfirmScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTitleViewWithWhiteTitle:GetStringWithKeyFromTable(@"确认备份_title", LOCALIZABE, nil)];
    self.completeButton.layer.cornerRadius = 20;
    self.completeButton.layer.masksToBounds = YES;
    [self.completeButton setTitle:GetStringWithKeyFromTable(@"完成_button", LOCALIZABE, nil) forState:UIControlStateNormal];
    [self setupLayoutViews];
    [self.view addSubview:self.placeHolderLabel];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)completeAction:(id)sender {
    if(self.confirmWords.count > 0){
        NSString *wordsStr = [self.words componentsJoinedByString:@","];
        NSString *confirmWordsStr = [self.confirmWords componentsJoinedByString:@","];
        if([wordsStr isEqualToString:confirmWordsStr]){
            self.briefLabel.hidden = YES;
            BOOL checkWords = NO;
            for(UIViewController*temp in self.navigationController.viewControllers) {
                
                if([temp isKindOfClass:[WalletDetailScene class]]) {
                    checkWords = YES;
                    [self.navigationController popToViewController:temp animated:YES];
                    
                }
            }
            
            if(!checkWords){
                [UserManager setDefaultWalletWithWallet:self.wallet];
                TabbarController * tabBarController = [[TabbarController alloc] init];
                [[UIApplication sharedApplication] keyWindow].rootViewController = tabBarController;
            }
            
        }else{
            self.briefLabel.hidden = NO;
        }
    }
}

-(void)setupLayoutViews{
    self.showWords = [self getRandomArrFrome:self.words];
    CGFloat x = 15;
    CGFloat y = 10;
    
    for (int i = 0; i < self.showWords.count; i++) {
        
        UIButton *label = [self buttonWithTitle:self.showWords[i] color:RGB(230, 233, 235) textColor:RGB(102, 102, 102)];
        CGFloat width = [self widthForString:self.showWords[i] fontSize:13] + 30;
        
        if (x + width + 15 > WIDTH) {
            y += 34;//换行
            x = 15; //15位置开始
        }
        
        label.frame = CGRectMake(x, y, width, 24);
        label.tag = i;
        [label addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.wordsBriefView addSubview:label];
        x += width + 10;//宽度+间隙
    }
    self.wordsHeight.constant = y+34;
}

-(void)refreshView{
    CGFloat x = 15;
    CGFloat y = 10;
    [self.wordsBriefView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    for (int i = 0; i < self.showWords.count; i++) {
        
        UIButton *label = [self buttonWithTitle:self.showWords[i] color:RGB(230, 233, 235) textColor:RGB(102, 102, 102)];
        CGFloat width = [self widthForString:self.showWords[i] fontSize:13] + 30;
        if([self.confirmWords containsObject:self.showWords[i]]){
            label.backgroundColor = RGB(206, 206, 206);
            [label setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
        }
        if (x + width + 15 > WIDTH) {
            y += 34;//换行
            x = 15; //15位置开始
        }
        
        label.frame = CGRectMake(x, y, width, 24);
        label.tag = i;
        [label addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.wordsBriefView addSubview:label];
        x += width + 10;//宽度+间隙
    }
}

-(void)refreshConfirmView{
    self.placeHolderLabel.hidden = self.confirmWords.count>0?YES:NO;
    CGFloat x = 15;
    CGFloat y = 10;
    [self.wordsConfirmView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    for (int i = 0; i < self.confirmWords.count; i++) {
        
        UIButton *label = [self buttonWithTitle:self.confirmWords[i] color:RGB(230, 233, 235) textColor:RGB(102, 102, 102)];
        CGFloat width = [self widthForString:self.confirmWords[i] fontSize:13] + 30;
        
        if (x + width + 15 > WIDTH) {
            y += 34;//换行
            x = 15; //15位置开始
        }
        label.frame = CGRectMake(x, y, width, 24);
        label.tag = i;
        [label addTarget:self action:@selector(clickConfirmAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.wordsConfirmView addSubview:label];
        x += width + 10;//宽度+间隙
    }
}

-(void)clickAction:(UIButton *)sender{

    NSString *wordStr = self.showWords[sender.tag];
    if([self.confirmWords containsObject:wordStr]){
        [self.confirmWords removeObject:wordStr];
    }else{
        [self.confirmWords addObject:wordStr];
    }
    [self refreshConfirmView];
    [self refreshView];
}

-(void)clickConfirmAction:(UIButton *)sender{
    
    NSString *wordStr = self.confirmWords[sender.tag];
    [self.confirmWords removeObject:wordStr];
    [self refreshConfirmView];
    [self refreshView];
}


- (UIButton *)buttonWithTitle:(NSString *)title color:(UIColor *)color textColor:(UIColor *)textColor{
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button sizeToFit];
    button.layer.cornerRadius = 12;
    button.userInteractionEnabled = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    button.backgroundColor = color;
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


-(NSArray*)getRandomArrFrome:(NSArray*)arr
{
    NSMutableArray *newArr = [NSMutableArray new];
    while (newArr.count != arr.count) {
        //生成随机数
        int x =arc4random() % arr.count;
        id obj = arr[x];
        if (![newArr containsObject:obj]) {
            [newArr addObject:obj];
        }
    }
    NSArray *resultArr = newArr;
    return resultArr;
}

-(UILabel *)placeHolderLabel{
    if(!_placeHolderLabel){
        _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, WIDTH, 25)];
        _placeHolderLabel.text = GetStringWithKeyFromTable(@"请按照顺序选择助记词_placeHolder", LOCALIZABE, nil);
        _placeHolderLabel.textColor = RGB(220, 220, 220);
        _placeHolderLabel.font = [UIFont systemFontOfSize:14];
    }
    return _placeHolderLabel;
}

-(NSMutableArray *)confirmWords{
    if(!_confirmWords){
        _confirmWords = [NSMutableArray array];
    }
    return _confirmWords;
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
