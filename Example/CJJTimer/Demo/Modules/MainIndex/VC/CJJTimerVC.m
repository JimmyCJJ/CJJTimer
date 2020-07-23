//
//  CJJTimerVC.m
//  CJJTimer
//
//  Created by wangfeng on 2020/7/23.
//  Copyright © 2020 CAOJIANJIN. All rights reserved.
//

#import "CJJTimerVC.h"
#import "CJJTimerModel.h"
#import "CJJTimerTBCell.h"
#import "CJJTimerSNCell.h"

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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.timerArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        CJJTimerTBCell *cell = [CJJTimerTBCell makeCellWithTableView:tableView];
        cell.model = self.timerArr[indexPath.row];
        return cell;
    }else{
        CJJTimerSNCell* cell = [CJJTimerSNCell makeCellWithTableView:tableView];
        cell.model = self.timerArr[indexPath.row];
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
        
        [_timerArr addObjectsFromArray:@[model1,model2,model3,model4]];
    }
    return _timerArr;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

@end
