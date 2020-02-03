//
//  YHBounceRefreshHeader.m
//  TestRefresh
//
//  Created by 颜欢 on 2020/1/31.
//  Copyright © 2020 颜欢. All rights reserved.
//

#import "YHBounceRefreshHeader.h"
#import <math.h>
#import <CoreText/CoreText.h>
#import <Masonry/Masonry.h>
#import "UIView+Categories.h"
#define Min_Height  80.0
#define kMaxTopPadding      20.0
#define kMaxTopRadius       20.0
#define kMinBottomRadius    5.0
#define kMaxBottomRadius    15.0
#define kMinBottomPadding   5.0
#define kMaxBottomPadding   10.0
#define kMaxDistance        200.0
@interface YHBounceRefreshHeader ()

@property (nonatomic,strong) UIView *cuteView;

@property (nonatomic, strong) CAShapeLayer *bounceLayer;

@property(nonatomic,assign)YHFreshResult resultType;

@property(nonatomic,copy)NSString*refreshingStr;

@property(nonatomic,strong)UIImageView*successImgView;

@property(nonatomic,strong)UIImageView*failImgView;

@property(nonatomic,strong)UIButton*freshBtn;

@property(nonatomic,strong)UIView*containerView;

@property(nonatomic,assign)CGFloat lastY;

@property(nonatomic,strong)CAShapeLayer*freshLayer;

@property(nonatomic,assign)CGFloat newPointy;

@property(nonatomic,assign)BOOL isNotNeedFreshLayer;

@property(nonatomic,strong)NSMutableDictionary*states;


@end


@implementation YHBounceRefreshHeader

//内联函数
/// 获取控制点
/// @param a 起点
/// @param b 终点
/// @param p 曲率
static inline CGFloat lerp(CGFloat a, CGFloat b, CGFloat p)
{
    return a + (b - a) * p;
}

- (void)prepare
{
 
    [super prepare];
    //获取私有属性stateTitles
    self.states = [self valueForKeyPath:@"stateTitles"];
//    NSLog(@"%@",self.states);
    self.layer.zPosition = -1.0;
   
    self.mj_h = Min_Height;
    self.cuteView = [[UIView alloc]init];
    self.cuteView.backgroundColor = self.cuteBackColor;
    [self addSubview:self.cuteView];
    [self sendSubviewToBack:self.cuteView];
    
    self.containerView = [[UIView alloc]init];
    self.containerView.backgroundColor = UIColor.clearColor;
    [self addSubview:self.containerView];
    [self bringSubviewToFront:self.containerView];
    
     [self setShapeLayer];
    
     self.freshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  
     self.freshBtn.imageView.contentMode = UIViewContentModeScaleToFill;
    
    self.freshBtn.clipsToBounds = YES;
    self.freshBtn.layer.cornerRadius = 20.0;
    
    self.freshBtn.hidden = YES;
     self.freshLayer.hidden = YES;
    [self.containerView addSubview:self.freshBtn];
    
    self.successImgView = [[UIImageView alloc]initWithFrame:self.loadingView.frame];
    self.successImgView.clipsToBounds = YES;
    self.successImgView.contentMode = UIViewContentModeScaleToFill;
    [self insertSubview:self.successImgView aboveSubview:self.stateLabel];
   
    self.successImgView.hidden = YES;
    
    self.failImgView = [[UIImageView alloc]initWithFrame:self.loadingView.frame];
    self.failImgView.clipsToBounds = YES;
    self.failImgView.contentMode = UIViewContentModeScaleToFill;
    [self insertSubview:self.failImgView aboveSubview:self.stateLabel];
    self.failImgView .hidden = YES;
    
    [self setUpInitUI];
    
    self.arrowView.hidden = YES;
    self.arrowView.alpha = 0.0;
  
    self.lastUpdatedTimeLabel.hidden = YES;
    self.lastUpdatedTimeLabel.alpha = 0.0;
    self.stateLabel.textColor = self.stateSuccessColor;
    self.loadingView.hidesWhenStopped = YES;
    self.stateLabel.textColor = self.stateNomalColor;
    
    [self setTitle:self.prepareStr forState:MJRefreshStateIdle];
    [self setTitle:@"即将刷新数据" forState:MJRefreshStatePulling];
    [self setTitle:@"正在刷新数据中" forState:MJRefreshStateRefreshing];
    
     self.lastY = -Min_Height;
   
   
  
}

-(void)setUpInitUI{
//    self.stateLabel.backgroundColor = UIColor.clearColor;
    @autoreleasepool {
         self.cuteBackColor = [UIColor colorWithWhite:0.9 alpha:0.9];
           self.stateNomalColor = UIColor.darkGrayColor;
           self.stateSuccessColor = UIColor.greenColor;
           self.stateFailColor = UIColor.redColor;
           self.isShowResultImage = YES;
           NSString *strPath = [[NSBundle mainBundle] pathForResource:@"Resouces" ofType:@"bundle"];
            self.successImage =  [[NSBundle bundleWithPath:strPath] pathForResource:@"chenggong" ofType:@"png" inDirectory:@"images"];
          self.failImage =  [[NSBundle bundleWithPath:strPath] pathForResource:@"shibai" ofType:@"png" inDirectory:@"images"];
           self.freshImage = [[NSBundle bundleWithPath:strPath] pathForResource:@"shuaxin" ofType:@"png" inDirectory:@"images"];
           self.stateFont = 12.0;
           self.successStr = @"刷新成功";
          self.prepareStr = @"准备开始刷新";
           self.failStr = @"刷新失败";
           self.isShowLine = NO;
           self.lineColor = UIColor.clearColor;
        self.freshBackColor = [UIColor lightGrayColor];

        self.freshLayer.lineWidth = 1.0;
//
        self.freshLayer.shadowOffset = CGSizeMake(5.0, 5.0);
        self.freshLayer.shadowOpacity = 0.7;
        self.freshLayer.shadowRadius = 5.0;
    }
   
}

-(void)setShapeLayer{
    self.bounceLayer = [CAShapeLayer layer];
    self.bounceLayer.fillColor = self.cuteBackColor.CGColor;
    [self.cuteView.layer addSublayer:self.bounceLayer];
  
    self.freshLayer = [CAShapeLayer layer];
   
    [self.containerView.layer addSublayer:self.freshLayer];
    
}

- (void)placeSubviews
{
    [super placeSubviews];
    self.cuteView.frame = CGRectMake(0.0, 0.0, self.mj_w, Min_Height);
     self.successImgView.center = self.loadingView.center;
    self.failImgView.center = self.loadingView.center;
    self.containerView.frame = CGRectMake(0.0, 0.0, self.mj_w, Min_Height);
    
    self.freshBtn.frame = CGRectMake((self.mj_w - 40.0)/2.0, 20.0, 40.0, 40.0);
//    self.freshBtn.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, 35.0);
    
}


//更新layer形状
- (void)updateShapeLayerPath:(CGFloat)offsetY
{
    @autoreleasepool {
       
      
//        NSLog(@"%lf",self.cuteView.frame.origin.y);
        
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0.0, 0.0)];
        [path addLineToPoint:CGPointMake(self.cuteView.frame.size.width, 0.0)];
        [path addLineToPoint:CGPointMake(self.cuteView.frame.size.width, Min_Height)];
        if (offsetY<-Min_Height) {
          
//            X = (1 - t)^2 * X0 + 2 * t * (1 - t) * X1 + t^2 * X2
//            X为h弧线上的点,t为控制系数，X0为起始点x坐标(此处为0.0)，X1为控制点x坐标(X2/2.0)，X2为终点x坐标
//            换算后，t = (X - X0) / (2 * (X1 - X0))，因为X恒在屏幕中央，此处t=0.5
//            Y = (1 - t)^2 * Y0 + 2 * t *(1 - t) * Y1 + t^2 * Y2
//            Y即为-offsetY，Y0起始点y坐标(Min_Height)，Y1为控制点坐标，也是所求目标，Y2终点y坐标(Min_Height)
//            变换后可得Y1:Y*2.0-Y0-Y2
            [path addQuadCurveToPoint:CGPointMake(0.0, Min_Height) controlPoint:CGPointMake(self.cuteView.frame.size.width/2.0,(-offsetY*2.0) - Min_Height)];
         
            if (self.isShowLine==YES) {
                self.bounceLayer.strokeColor = self.lineColor.CGColor;
                self.bounceLayer.lineWidth = 0.5;
            }
            self.freshBtn.hidden = NO;
            self.freshLayer.hidden = NO;
         
        }else{
            [path addLineToPoint:CGPointMake(0.0, Min_Height)];
            self.bounceLayer.strokeColor = [UIColor clearColor].CGColor;
                        self.bounceLayer.lineWidth = 0.0;
          self.freshBtn.hidden = YES;
            self.freshLayer.hidden =YES;
            self.freshBtn.transform = CGAffineTransformIdentity;
        }
      
        [path closePath];
        self.bounceLayer.path = path.CGPath;
     
    }

}

//监听contentOffset
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{

    @autoreleasepool {
    [super scrollViewContentOffsetDidChange:change];
 
//         if (self.arrowView.hidden == NO) {
//                 self.arrowView.hidden = YES;
//            }
           
    
            CGPoint newPoint = [[change objectForKey:@"new"] CGPointValue];
        
                CGRect frame = self.cuteView.frame;
               
                frame.origin.y = newPoint.y + Min_Height ;
                self.cuteView.frame = frame;
          
            self.containerView.frame = frame;
       
        
         self.newPointy = newPoint.y;
        
  
        
         [self setNeedsDisplay];
       
    }
  
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    [self updateShapeLayerPath:self.newPointy];
          
          if (self.newPointy<-Min_Height) {
            
              CGFloat p = self.lastY < self.newPointy ? (M_PI_2) : (-M_PI_2);
            
              
                              [UIView animateWithDuration:0.3 animations:^{
                                  self.freshBtn.transform = CGAffineTransformRotate(self.freshBtn.transform, p);
                                    [self.freshBtn layoutIfNeeded];
                              }completion:^(BOOL finished) {
                                     self.lastY = self.newPointy;
                                  [self renewPathWithPointy:self.newPointy];
                                 
                              }];
              
          }else{
              UIBezierPath*bp = [UIBezierPath bezierPathWithArcCenter:self.freshBtn.center radius:15.0 startAngle:0.0 endAngle:M_PI * 2 clockwise:YES];
              self.freshLayer.path = bp.CGPath;
           self.freshBtn.transform = CGAffineTransformIdentity;
          }
    
}

-(void)renewPathWithPointy:(CGFloat)pointy{
    @autoreleasepool {

//        NSLog(@"ffff:%lf",self.bounds.size.height);
       
          CGMutablePathRef path = CGPathCreateMutable();
        

//        间距
        CGFloat verticalShift = MAX(0.0, -((kMaxTopRadius + kMaxBottomRadius + kMaxTopPadding + kMaxBottomPadding) + pointy));
//        规定距离
        CGFloat distance = MIN(kMaxDistance, fabs(verticalShift));
//        下球大小百分比
        CGFloat percentage = 1.0 - (distance / kMaxDistance);
        
        CGFloat currentTopPadding = kMaxTopPadding;
        CGFloat currentTopRadius = kMaxTopRadius;
        CGFloat currentBottomRadius = lerp(kMinBottomRadius, kMaxBottomRadius, percentage);
        CGFloat currentBottomPadding =  lerp(kMinBottomPadding, kMaxBottomPadding, percentage);
        
        CGPoint bottomOrigin = CGPointMake(floor(self.bounds.size.width / 2), -pointy - currentBottomPadding -currentBottomRadius);
        CGPoint topOrigin = CGPointZero;
        if (distance == 0) {
            topOrigin = CGPointMake(floor(self.bounds.size.width / 2.0), bottomOrigin.y);
        } else {
            topOrigin = CGPointMake(floor(self.bounds.size.width / 2.0), currentTopPadding + currentTopRadius);
            if (percentage == 0) {
                bottomOrigin.y -= (fabs(verticalShift) - kMaxDistance);

            }
        }
        if (self.isNotNeedFreshLayer==YES) {
             CGPathAddArc(path, NULL, topOrigin.x, currentTopPadding + currentTopRadius, currentTopRadius, 0.0, M_PI*2.0, YES);
            self.freshLayer.path = path;
           self.freshLayer.shadowPath = path;
            
             CGPathRelease(path);
            return;
        }
        if (-pointy > kMaxDistance ) {
         
              CGPathAddArc(path, NULL, topOrigin.x, topOrigin.y, currentTopRadius, 0.0, M_PI*2.0, YES);
            [UIView animateWithDuration:0.3 animations:^{
                 self.freshLayer.path = path;
                       self.freshLayer.shadowPath = path;
            } completion:^(BOOL finished) {
                self.isNotNeedFreshLayer = YES;
               
              
                  CGPathRelease(path);
            }];
            
            return;
        }
      
   
        CGPathAddArc(path, NULL, topOrigin.x, topOrigin.y, currentTopRadius, 0.0, M_PI, YES);
        
        //左边弧
        CGPoint leftCp1 = CGPointMake(lerp((topOrigin.x - currentTopRadius), (bottomOrigin.x - currentBottomRadius), 0.1), lerp(topOrigin.y, bottomOrigin.y, 0.1));
        CGPoint leftCp2 = CGPointMake(lerp((topOrigin.x - currentTopRadius), (bottomOrigin.x - currentBottomRadius), 0.9), lerp(topOrigin.y, bottomOrigin.y, 0.1));
        CGPoint leftDestination = CGPointMake(bottomOrigin.x - currentBottomRadius, bottomOrigin.y);
        
        CGPathAddCurveToPoint(path, NULL, leftCp1.x, leftCp1.y, leftCp2.x, leftCp2.y, leftDestination.x, leftDestination.y);
        
       
        CGPathAddArc(path, NULL, bottomOrigin.x, bottomOrigin.y, currentBottomRadius, M_PI, 0.0, YES);
        
        //右边弧
        CGPoint rightCp2 = CGPointMake(lerp((topOrigin.x + currentTopRadius), (bottomOrigin.x + currentBottomRadius), 0.1), lerp(topOrigin.y, bottomOrigin.y, 0.1));
        CGPoint rightCp1 = CGPointMake(lerp((topOrigin.x + currentTopRadius), (bottomOrigin.x + currentBottomRadius), 0.9), lerp(topOrigin.y, bottomOrigin.y, 0.1));
        CGPoint rightDestination = CGPointMake(topOrigin.x + currentTopRadius, topOrigin.y);
        
        CGPathAddCurveToPoint(path, NULL, rightCp1.x, rightCp1.y, rightCp2.x, rightCp2.y, rightDestination.x, rightDestination.y);
        CGPathCloseSubpath(path);
        
        self.freshLayer.path = path;
        self.freshLayer.shadowPath = path;
        
         CGPathRelease(path);
    }

    
}


- (void)scrollViewContentSizeDidChange:(NSDictionary *)change

{

    [super scrollViewContentSizeDidChange:change];

}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change

{

    [super scrollViewPanStateDidChange:change];


}

- (void)setPullingPercent:(CGFloat)pullingPercent
{
 
    [super setPullingPercent:pullingPercent];
//    NSLog(@"ttt:%lf",pullingPercent);
}

- (void)setState:(MJRefreshState)state
{
    @autoreleasepool {
        [super setState:state];
             self.arrowView.hidden = YES;
        self.arrowView.alpha = 0.0;
           if (state == MJRefreshStateIdle) {
               self.isNotNeedFreshLayer = NO;
               self.scrollView.userInteractionEnabled = YES;
               self.scrollView.scrollEnabled = YES;
              
               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   self.resultType = YHFreshNothing;
                    self.stateLabel.hidden =  YES;
                     self.stateLabel.font = [UIFont systemFontOfSize:self.stateFont];
                   [self.stateLabel sizeToFit];
                    self.freshBtn.transform = CGAffineTransformIdentity;
               });
        //        NSLog(@"没事做了");
            }else if (state == MJRefreshStatePulling){
        //        NSLog(@"即将要松手");
              
                self.stateLabel.hidden = YES;
                  self.refreshingStr = self.states[@(MJRefreshStateRefreshing)];
               
            }else if (state == MJRefreshStateRefreshing){
               
                     self.scrollView.userInteractionEnabled = NO;
                    self.scrollView.scrollEnabled = NO;
                self.isNotNeedFreshLayer = NO;
                self.freshBtn.hidden = YES;
                self.freshLayer.hidden = YES;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        self.stateLabel.hidden = NO;
                        [self.stateLabel sizeToFit];
                        self.stateLabel.center = self.cuteView.center;
                    });
                   
            
        //        NSLog(@"正在刷新");
            }else if (state == MJRefreshStateWillRefresh){
        //        NSLog(@"即将刷新完成");
               
            }
    }
   
    
}

-(void)finishAction{
    if (self.loadingView.isAnimating==YES) {

        [self.loadingView stopAnimating];
            
    }
}

- (void)dealloc
{
    NSLog(@"内存释放");
    
    [self.cuteView removeFromSuperview];
    self.cuteView = nil;
    [self.bounceLayer removeFromSuperlayer];
    self.bounceLayer = nil;
    self.resultType = YHFreshNothing;
    self.refreshingStr = nil;
    [self.successImgView removeFromSuperview];
    self.successImgView = nil;
    [self.failImgView removeFromSuperview];
    self.failImgView = nil;
     self.freshBtn.transform = CGAffineTransformIdentity;
    [self.freshBtn removeFromSuperview];
    self.freshBtn = nil;
    [self.freshLayer removeFromSuperlayer];
    self.freshLayer = nil;
    [self.containerView removeFromSuperview];
    self.containerView = nil;
    [self.states removeAllObjects];
    self.states = nil;
    self.lastY = 0.0;
    

    
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
}

- (void)setCuteBackColor:(UIColor *)cuteBackColor
{
    _cuteBackColor = cuteBackColor;
    self.cuteView.backgroundColor = cuteBackColor;
    self.bounceLayer.fillColor = cuteBackColor.CGColor;
}
- (void)setIsShowLine:(BOOL)isShowLine
{
    _isShowLine = isShowLine;
    if (isShowLine==NO) {
        self.bounceLayer.lineWidth = 0.0;
        self.bounceLayer.strokeColor = UIColor.clearColor.CGColor;
    }

}


- (void)setFreshBackColor:(UIColor *)freshBackColor
{
    _freshBackColor = freshBackColor;
    self.freshBtn.backgroundColor = [freshBackColor colorWithAlphaComponent:1.0];
    self.freshLayer.backgroundColor = [freshBackColor colorWithAlphaComponent:1.0].CGColor;
    self.freshLayer.fillColor = [freshBackColor colorWithAlphaComponent:1.0].CGColor;
    self.freshLayer.strokeColor = [freshBackColor colorWithAlphaComponent:0.5].CGColor;
    self.freshLayer.shadowColor = [freshBackColor colorWithAlphaComponent:0.3].CGColor;
}

- (void)setStateNomalColor:(UIColor *)stateNomalColor
{
    _stateNomalColor = stateNomalColor;
}

- (void)setStateSuccessColor:(UIColor *)stateSuccessColor
{
    _stateSuccessColor = stateSuccessColor;
}
- (void)setStateFailColor:(UIColor *)stateFailColor
{
    _stateFailColor = stateFailColor;
}

- (void)setIsShowResultImage:(BOOL)isShowResultImage
{
    _isShowResultImage = isShowResultImage;
}
- (void)setSuccessImage:(NSString *)successImage
{
    @autoreleasepool {
            _successImage = successImage;
        UIImage*img = [UIImage imageWithContentsOfFile:successImage];
        if (img==nil) {
            img = [[UIImage imageNamed:successImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        self.successImgView.image = img;
    }

}
- (void)setFailImage:(NSString *)failImage
{
    @autoreleasepool {
        _failImage = failImage;
        UIImage*img = [UIImage imageWithContentsOfFile:failImage];
           if (img==nil) {
               img = [[UIImage imageNamed:failImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
           }
        self.failImgView.image = img;
    }

}

- (void)setFreshImage:(NSString *)freshImage{
 
    @autoreleasepool {
        _freshImage = freshImage;
        UIImage*img = [UIImage imageWithContentsOfFile:freshImage];
             if (img==nil) {
                 img = [[UIImage imageNamed:freshImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
             }

        [self.freshBtn setImage:img forState:UIControlStateNormal];
    }
    
}



- (void)setStateFont:(CGFloat)stateFont
{
    if (stateFont>13.0) {
        stateFont = 13.0;
    }
    _stateFont = stateFont;
    self.stateLabel.font = [UIFont systemFontOfSize:stateFont];
}
- (void)setPrepareStr:(NSString *)prepareStr
{
    
    _prepareStr = prepareStr;
    
}
- (void)setResultType:(YHFreshResult)resultType
{
    _resultType = resultType;
    
            if (resultType == YHFreshSuccess) {
                [self setTitle:self.successStr forState:MJRefreshStateIdle];
               
                    self.stateLabel.textColor = self.stateSuccessColor;
             
              [self setTitle:self.successStr forState:MJRefreshStateRefreshing];
                self.successImgView.hidden=NO;
                self.failImgView.hidden=YES;
//                self.freshImgView.hidden = YES;
                self.stateLabel.font = [UIFont systemFontOfSize:(self.stateFont+3.0) weight:UIFontWeightBold];
                [self.stateLabel sizeToFit];
            }else if (resultType == YHFreshFail){
                  [self setTitle:self.failStr forState:MJRefreshStateIdle];
              
                     self.stateLabel.textColor = self.stateFailColor;
             [self setTitle:self.failStr forState:MJRefreshStateRefreshing];
                self.successImgView.hidden=YES;
                self.failImgView.hidden=NO;
//                  self.freshImgView.hidden = YES;
                   self.stateLabel.font = [UIFont systemFontOfSize:(self.stateFont+3.0) weight:UIFontWeightBold];
                [self.stateLabel sizeToFit];
            }else{
              
                self.stateLabel.textColor = self.stateNomalColor;
                [self setTitle:self.prepareStr forState:MJRefreshStateIdle];
                 [self setTitle:self.refreshingStr forState:MJRefreshStateRefreshing];
                self.successImgView.hidden=YES;
                self.failImgView.hidden=YES;
//                  self.freshImgView.hidden = NO;
            }

    
}
- (void)setSuccessStr:(NSString *)successStr
{
    if (successStr.length>8) {
        successStr = [successStr substringToIndex:8];
    }
    _successStr = successStr;
}

- (void)setFailStr:(NSString *)failStr
{
    if (failStr.length>8) {
        failStr = [failStr substringToIndex:8];
    }
    _failStr = failStr;
}

- (void)endRefreshing{
    [super endRefreshing];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@implementation MJRefreshHeader (YHCategory)

- (void)endRefreshingWithResult:(YHFreshResult)result{
    if ([self isKindOfClass:[YHBounceRefreshHeader class]]) {
        @autoreleasepool {
            YHBounceRefreshHeader*header = (YHBounceRefreshHeader*)self;
             header.resultType = result;
             [header finishAction];
             if (header.isShowResultImage==NO) {
                 header.successImgView.hidden=YES;
                 header.failImgView.hidden=YES;
               
             }
            
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                  [header endRefreshing];
             });
        }
        
    }else{
         [self endRefreshing];
    }
   
}

- (void)endRefreshingWithResult:(YHFreshResult)result WithCompletionBlock:(void (^)(void))completionBlock
{
    if (completionBlock) {
        completionBlock();
    }
    [self endRefreshingWithResult:result];
}

@end
