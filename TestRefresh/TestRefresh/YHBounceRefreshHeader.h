//
//  YHBounceRefreshHeader.h
//  TestRefresh
//
//  Created by 颜欢 on 2020/1/31.
//  Copyright © 2020 颜欢. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>



NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, YHFreshResult){
    YHFreshNothing,
    YHFreshSuccess,
    YHFreshFail
};

@interface YHBounceRefreshHeader : MJRefreshNormalHeader

/// 圆弧背景颜色
@property(nonatomic,strong)UIColor*cuteBackColor;


/// 常态下状态文字颜色
@property(nonatomic,strong)UIColor*stateNomalColor;

/// 刷新成功文字颜色
@property(nonatomic,strong)UIColor*stateSuccessColor;

/// 刷新失败文字颜色
@property(nonatomic,strong)UIColor*stateFailColor;


/// 是否显示刷新完成后的结果图片
@property(nonatomic,assign)BOOL isShowResultImage;

/// 刷新成功的图片,（仅限本地）
@property(nonatomic,copy)NSString*successImage;

/// 刷新失败的图片,（仅限本地）
@property(nonatomic,copy)NSString*failImage;

/// 状态文字字体size，不得超过13.0
@property(nonatomic,assign)CGFloat stateFont;


/// 刷新成功时的文字，不得超过8个字
@property(nonatomic,copy)NSString*successStr;

/// 刷新失败的文字，不得超过8个字
@property(nonatomic,copy)NSString*failStr;

/// 刷新准备时的文字，不得超过8个字
@property(nonatomic,copy)NSString*prepareStr;

/// 是否显示弧边
@property(nonatomic,assign)BOOL isShowLine;

/// 弧边的颜色
@property(nonatomic,strong)UIColor*lineColor;


/// 刷新图片
@property(nonatomic,copy)NSString*freshImage;


/// 刷新控件背景颜色
@property(nonatomic,strong)UIColor*freshBackColor;


@end




@interface MJRefreshHeader (YHCategory)


//
-(void)endRefreshingWithResult:(YHFreshResult)result;

-(void)endRefreshingWithResult:(YHFreshResult)result WithCompletionBlock:(void (^)(void))completionBlock;

@end


NS_ASSUME_NONNULL_END
