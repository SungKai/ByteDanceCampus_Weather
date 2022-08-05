//
//  CityChosenViewController.m
//  ByteDanceCampus_Weather
//
//  Created by 宋开开 on 2022/8/4.
//

#import "CityChosenViewController.h"

// Model
#import "CitiesModel.h"

@interface CityChosenViewController () <
    UITableViewDataSource,
    UITableViewDelegate
>

/// 所有城市名字的数组
@property (nonatomic, strong) NSArray<CitiesModel *> *cityGroupArray;

/// 取消返回按钮
@property (nonatomic, strong) UIBarButtonItem *cancelItem;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CityChosenViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"请选择城市";
//    self.view.backgroundColor = UIColor.whiteColor;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cityChosenBg"]];
    
    [self.view addSubview:self.tableView];
    self.navigationItem.leftBarButtonItem = self.cancelItem;
}

#pragma mark - Method

/// 点击取消返回
- (void)clickCancelAndBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cityGroupArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CitiesModel *citis = self.cityGroupArray[section];
    return citis.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    CitiesModel *citiesModel = self.cityGroupArray[indexPath.section];
    cell.textLabel.text = citiesModel.cities[indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#1D2126" alpha:0.8];
    cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.2];
    //设置cell无法点击
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark - UITableViewDelegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    CitiesModel *cities = self.cityGroupArray[section];
    return cities.title;
}

// 返回tableViewIndex数组
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.cityGroupArray valueForKeyPath:@"title"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CitiesModel *cityModel = self.cityGroupArray[indexPath.section];
    NSString *cityName = cityModel.cities[indexPath.row];
    
    // 选择好城市后用block回调
    if (self.cityNameBlock) {
        self.cityNameBlock(cityName);
    }
//    // 用UserDefaults来存储当前选择的城市
//    [NSUserDefaults.standardUserDefaults setObject:cityName forKey:@"chosenCity"];
}


#pragma mark - Getter

- (NSArray *)cityGroupArray {
    if (_cityGroupArray == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"cityGroups.plist" ofType:nil];
        NSArray *cityGroupArray = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *ma = [NSMutableArray array];
        for (NSDictionary *dic in cityGroupArray) {
            CitiesModel *citiesModel = [[CitiesModel alloc] init];
            // KVC绑定模型对象属性和字典key的关系
            [citiesModel setValuesForKeysWithDictionary:dic];
            [ma addObject:citiesModel];
        }
        _cityGroupArray = ma;
    }
    return _cityGroupArray;
}

- (UIBarButtonItem *)cancelItem {
    if (_cancelItem == nil) {
        _cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(clickCancelAndBack)];

        UIColor *color = [UIColor
            dm_colorWithLightColor:[UIColor
                colorWithHexString:@"#2D2D2D" alpha:1]
                         darkColor:[UIColor
                colorWithHexString:@"#F2F3F9" alpha:1]];
        _cancelItem.tintColor = color;
    }
    return _cancelItem;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleInsetGrouped];
        _tableView.separatorColor = [UIColor colorWithHexString:@"#515569" alpha:0.5];;
        _tableView.separatorInset = UIEdgeInsetsMake(-2, 20, 2, 20);
        //separatorInset
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
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
