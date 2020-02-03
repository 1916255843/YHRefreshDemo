//
//  ViewController.m
//  TestRefresh
//
//  Created by 颜欢 on 2020/1/31.
//  Copyright © 2020 颜欢. All rights reserved.
//

#import "ViewController.h"
//#import <MyLayout/MyLayout.h>
#import "YHBounceRefreshHeader.h"

static NSString*cellStr = @"YHTestCellStr";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView*tableView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navigationController setNavigationBarHidden:YES];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
   
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    
    
        __weak typeof(self)weakself = self;
    YHBounceRefreshHeader*header  = [YHBounceRefreshHeader headerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    __strong typeof(weakself)strongself = weakself;

                    [strongself.tableView.mj_header endRefreshingWithResult:YHFreshFail];
            });


               }];

        self.tableView.mj_header = header;

   
    // Do any additional setup after loading the view.
}
//-(void)loadView
//{
//    [super loadView];
////    self.view = self.SView;
//}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
   
//        [self.SView addSubview:self.tableView];
//

        [self settabviewFrame];

}

-(void)settabviewFrame{

   CGFloat w = self.view.frame.size.width;
    if (@available(iOS 11.0, *)) {
        CGFloat y = self.view.safeAreaInsets.top;
        CGFloat h = self.view.safeAreaLayoutGuide.layoutFrame.size.height;
        self.tableView.frame = CGRectMake(0.0, y, w, h);
//        self.tableView.myTop = self.view.safeAreaInsets.top;
//        self.tableView.myHeight = self.view.safeAreaLayoutGuide.layoutFrame.size.height;
    }else{
        CGFloat h = self.view.frame.size.height;
        self.tableView.frame = CGRectMake(0.0, 0.0, w, h);
//        self.tableView.myTop = 0.0;
//        self.tableView.myHeight = self.view.frame.size.height;
    }
    
      if (self.tableView.delegate == nil || self.tableView.delegate != self) {
                self.tableView.delegate = self;
            }
      if (self.tableView.dataSource == nil || self.tableView.dataSource != self) {
          self.tableView.dataSource = self;
      }

//
}



- (void)dealloc
{
    NSLog(@"也被释放了");
    [self.tableView.mj_header removeFromSuperview];
    self.tableView.mj_header = nil;
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    
   
    [self.tableView removeFromSuperview];
    self.tableView = nil;

}

//-(void)loadData{
//
//
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.tableView.mj_header beginRefreshing];
//            });
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 18;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        cell.backgroundColor = UIColor.whiteColor;
        cell.clipsToBounds = YES;
        cell.separatorInset = UIEdgeInsetsMake(0.0, -30.0, 0.0, -30.0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    cell.textLabel.text = [NSString stringWithFormat:@"第%ld个",indexPath.row];

    return cell;
}


-(UITableView*)tableView
{
    if (!_tableView) {
        UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.clipsToBounds = YES;
        tableView.backgroundColor = UIColor.whiteColor;
        tableView.estimatedRowHeight = [UIScreen mainScreen].bounds.size.width;
        tableView.estimatedSectionFooterHeight = 0.0;
        tableView.estimatedSectionHeaderHeight = 0.0;
        UIView*headerView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, 0.00001)];
        headerView.backgroundColor = UIColor.whiteColor;
        headerView.clipsToBounds = YES;
        tableView.tableHeaderView = headerView;
        UIView*footerView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, 0.00001)];
        footerView.backgroundColor = UIColor.whiteColor;
        footerView.clipsToBounds = YES;
        tableView.tableFooterView = footerView;
        [self.view addSubview: _tableView = tableView];
    }
    return _tableView;
}
//
//- (MyLinearLayout *)SView
//{
//    if (!_SView) {
//        MyLinearLayout *SView = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
//
//        SView.backgroundColor = UIColor.whiteColor;
//        SView.clipsToBounds = YES;
//        [self.view addSubview: _SView = SView];
//    }
//    return _SView;
//}

@end
