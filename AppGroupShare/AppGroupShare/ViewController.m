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
    
    self.title = @"主App共享File";
    [self writeFirstFileToShare];
    [self loadData];
}

- (void)writeFirstFileToShare
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isOpened = [[defaults objectForKey:@"isOpened"] boolValue];
    if(!isOpened){
        [defaults setObject:@(YES) forKey:@"isOpened"];

        NSString *file1Cont = @"Hello every one. I'm M0nk1y. My site: http://mkapple.cn";
        NSString *file2Cont = @"new File2:";

        [file1Cont writeToFile:[self.storagePath stringByAppendingPathComponent:@"File1.text"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
        [file2Cont writeToFile:[self.storagePath stringByAppendingPathComponent:@"File2.text"] atomically:YES encoding:NSUTF8StringEncoding error:nil];

        NSString *file3Path = [[NSBundle mainBundle] pathForResource:@"battery" ofType:@"sqlite"];
        NSString *file3ToPath = [self.storagePath stringByAppendingPathComponent:@"battery.sqlite"];
        NSError *error;
        BOOL success = [[NSFileManager defaultManager] copyItemAtPath:file3Path toPath:file3ToPath error:&error];
        NSLog(@"success:%d==error:%@", success, error);

    }
}

- (void)loadData
{
//    self.fileNamesArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.storagePath error:nil];
//    for (NSString *fileName in self.fileNamesArray) {
//        NSString *path = [self.storagePath stringByAppendingPathComponent:fileName];
//        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
//        NSLog(@"success:%d", success);
//    }
//    NSLog(@"self.fileNamesArray:%@", self.fileNamesArray);
    
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
