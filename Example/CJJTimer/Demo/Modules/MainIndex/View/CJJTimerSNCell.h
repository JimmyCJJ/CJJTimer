//
//  CJJTimerSNCell.h
//  CJJTimer
//
//  Created by CJJ on 2020/7/23.
//  Copyright © 2020 CAOJIANJIN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJJTimerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CJJTimerSNCell : UITableViewCell

+ (instancetype)makeCellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) CJJTimerModel *model;

@end

NS_ASSUME_NONNULL_END
