//
//  CJJTimerVC.m
//  CJJTimer
//
//  Created by CJJ on 2020/7/23.
//  Copyright © 2020 CAOJIANJIN. All rights reserved.
//

#import "CJJTimerVC.h"
#import "CJJTimerModel.h"
#import "CJJTimerHeaderView.h"
#import "CJJTimerTBCell.h"
#import "CJJTimerJDCell.h"
#import "CJJTimerSNCell.h"
#import "CJJTimerPDDCell.h"
#import "CJJTimerSMSCell.h"

@interface CJJTimerVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *timerArr;
@end

@implementation CJJTimerVC

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    [self setUpLayout];
}

- (void)dealloc
{
    NSLog(@"CJJTimerVC销毁");
}

#pragma mark - set up

- (void)setUpView{
    self.view.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.tableView];
}

- (void)setUpLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - action


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CJJTimerHeaderView *headerView = [CJJTimerHeaderView new];
    headerView.model = self.timerArr[section];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.timerArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        CJJTimerTBCell *cell = [CJJTimerTBCell makeCellWithTableView:tableView];
        return cell;
    }else if(indexPath.section == 1){
        CJJTimerJDCell *cell = [CJJTimerJDCell makeCellWithTableView:tableView];
        return cell;
    }else if(indexPath.section == 2){
        CJJTimerSNCell* cell = [CJJTimerSNCell makeCellWithTableView:tableView];
        return cell;
    }else if(indexPath.section == 3){
        CJJTimerPDDCell *cell = [CJJTimerPDDCell makeCellWithTableView:tableView];
        return cell;
    }else{
        CJJTimerSMSCell *cell = [CJJTimerSMSCell makeCellWithTableView:tableView];
        return cell;
    }
    
}

#pragma mark - lazy

- (NSMutableArray *)timerArr{
    if(!_timerArr){
        _timerArr = [NSMutableArray array];
        CJJTimerModel *model1 = [CJJTimerModel new];
        model1.name = @"淘宝倒计时";
        
        CJJTimerModel *model2 = [CJJTimerModel new];
        model2.name = @"京东倒计时";
        
        CJJTimerModel *model3 = [CJJTimerModel new];
        model3.name = @"苏宁倒计时";
        
        CJJTimerModel *model4 = [CJJTimerModel new];
        model4.name = @"拼多多倒计时";
        
        CJJTimerModel *model5 = [CJJTimerModel new];
        model5.name = @"短信倒计时";
        
        [_timerArr addObjectsFromArray:@[model1,model2,model3,model4,model5]];
    }
    return _timerArr;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

@end
