//
//  ViewController.m
//  FileManagerUi
//
//  Created by mt010 on 2020/7/1.
//  Copyright © 2020 FileManager. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getFirstData];
    [self setUI];
    // Do any additional setup after loading the view.
}
- (void)getFirstData{
    // 获取沙盒主目录路径
    NSString *documentDir = NSHomeDirectory();
    
    // 获取Documents目录路径 一般需要持久的数据都放在此目录中，可以在当中添加子文件夹，iTunes备份和恢复的时候，会包括此目录。
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    // 获取Cache目录路径 用于存放应用程序运行时生成的数据，也就是缓存，不会被自动清除，该目录不参与备份
    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    // 获取tmp目录路径 用于存放临时文件的目录，当应用程序退出运行时，该目录下的文件会被自动清除
    NSString *tmpDir =  NSTemporaryDirectory();
}
- (void)setUI{
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.tableView];
    self.title = NSLocalizedString(@"AppTitle", nil);
}
- (void)getData{
    
}
- (NSMutableArray *)dataSource{
    if (_dataSource == nil){
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}
- (UITableView *)tableView{
    if (_tableView == nil){
        _tableView = [[UITableView alloc] initWithFrame:UIScreen.mainScreen.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

// tableView 中 Section 的个数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
// 每个 Section 中的 Cell 个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
}
// 设置每个 Cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建一个cellID，用于cell的重用
    NSString *cellID = @"cellID";
    // 从tableview的重用池里通过cellID取一个cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
     if (cell == nil) {
             // 如果tableview的重用池中没有取到，就创建一个新的cell，style为Value2，并用cellID对其进行标记。
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellID];
        }
    cell.textLabel.text = @"dd";
    return cell;
}
@end
