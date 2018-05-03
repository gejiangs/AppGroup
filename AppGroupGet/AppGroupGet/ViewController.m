//
//  ViewController.m
//  AppGroupShare
//
//  Created by gejiangs on 2018/5/3.
//  Copyright © 2018年 gejiangs. All rights reserved.
//

#import "ViewController.h"

#define APP_GROUP_ID        @"group.com.dacheng.AppGroupFileShare"
#define APP_FOLDER_NAME     @"DachengShareFile"


@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)       NSString *storagePath;
@property (nonatomic, strong)       NSArray *fileNamesArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"App从共享目录读取文件";
    [self loadData];
}


- (void)loadData
{
    self.fileNamesArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.storagePath error:nil];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView reloadData];
    
    NSLog(@"self.fileNamesArray:%@", self.fileNamesArray);
}


#pragma mark - 获取共享容器文件夹路径
- (NSString *)storagePath
{
    if (_storagePath) {
        return _storagePath;
    }
    NSURL *groupURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:APP_GROUP_ID];
    NSString *groupPath = [groupURL path];
    self.storagePath = [groupPath stringByAppendingPathComponent:APP_FOLDER_NAME];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:_storagePath]) {
        [fileManager createDirectoryAtPath:_storagePath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return _storagePath;
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fileNamesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.fileNamesArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *filePath = [self.storagePath stringByAppendingPathComponent:self.fileNamesArray[indexPath.row]];
    
    NSLog(@"filePath:%@", filePath);
    
    if (indexPath.row < 2) {
        NSString *fileContent = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"content:%@", fileContent);
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
