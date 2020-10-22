//
//  AboutUsScene.m
//  Wallet
//
//  Created by 钱伟成 on 2019/9/14.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "AboutUsScene.h"
#import "AboutUsCell.h"
#import "WKWebScene.h"
@interface AboutUsScene ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AboutUsScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleViewWithWhiteTitle:GetStringWithKeyFromTable(@"关于我们_cell", LOCALIZABE, nil)];
    [self.tableView registerNib:[UINib nibWithNibName:@"AboutUsCell" bundle:nil] forCellReuseIdentifier:@"AboutUsCell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.001)];
    self.tableView.scrollEnabled = NO;
    // Do any additional setup after loading the view from its nib.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AboutUsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AboutUsCell" forIndexPath:indexPath];
    cell.detail.text = GetStringWithKeyFromTable(@"已是最新版本_text", LOCALIZABE, nil);
    if(indexPath.row == 0){
        cell.title.text = GetStringWithKeyFromTable(@"服务条款_cell", LOCALIZABE, nil);
        cell.arrowImageView.hidden = NO;
        cell.detail.hidden = YES;
    }else if (indexPath.row == 1){
        cell.title.text = GetStringWithKeyFromTable(@"常见问题_cell", LOCALIZABE, nil);
        cell.arrowImageView.hidden = NO;
        cell.detail.hidden = YES;
    }else if (indexPath.row == 2){
        cell.title.text = GetStringWithKeyFromTable(@"版本信息_cell", LOCALIZABE, nil);
        cell.arrowImageView.hidden = NO;
        cell.detail.hidden = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WKWebScene *scene = [[WKWebScene alloc] init];
    if(indexPath.row == 0){
        scene.url = [NSString stringWithFormat:@"%@api/custom/basic/redirect_serviceAgreement?lang=%@",BASE_URL_NORMAL,[NSString getCurrentLanguage]];
    }else if (indexPath.row == 1){
        scene.url = [NSString stringWithFormat:@"%@api/custom/basic/redirect_faq?lang=%@",BASE_URL_NORMAL,[NSString getCurrentLanguage]];
    }else if (indexPath.row == 2){
        scene.url = [NSString stringWithFormat:@"%@api/custom/basic/redirect_aboutUs?lang=%@",BASE_URL_NORMAL,[NSString getCurrentLanguage]];
    }
    [self.navigationController pushViewController:scene animated:YES];
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
