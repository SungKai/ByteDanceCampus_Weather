//
//  ForecastDailyTableView.m
//  ByteDanceCampus_Weather
//
//  Created by atom on 2022/8/13.
//
#import "ForecastDailyTableViewHeader.h"
#import "ForecastDailyTableViewCell.h"
#import "ForecastDailyTableView.h"
@interface ForecastDailyTableView()<UITableViewDataSource, UITableViewDelegate>

@end
@implementation ForecastDailyTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if(self){
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor clearColor];
        [self setSeparatorColor:[[UIColor whiteColor] colorWithAlphaComponent:0.4]];
    }
    return self;
}


#pragma mark - UITableViewDelegate

/// MARK: cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

/// MARK: cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@", @(indexPath.row));
}

#pragma mark - UITableViewDataSource

/// MARK: 创建Header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ForecastDailyTableViewHeader * header = [[ForecastDailyTableViewHeader alloc] init];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
/// MARK: 创建Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 从复用池中获取cell,复用池中没有cell，新建cell
    ForecastDailyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ForecastDailyTableViewCell"];
    if (!cell) {
        cell = [[ForecastDailyTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ForecastDailyTableViewCell"];
    }
    return cell;
}

/// MARK: Cell数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

@end
