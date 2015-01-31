//
//  TabBarController.m
//  自定义TabBarController
//
//  Created by kouliang on 15/1/29.
//  Copyright (c) 2015年 kouliang. All rights reserved.
//


//1.添加子控制器
//  [vc addChildViewController:vc2];
//2.从父控制器中移除
//  [vc removeFromParentViewController];

//3.监听设备旋转的方法
// 屏幕的旋转事件：UIWindow -> rootViewController -> 通知它的子控制器 -> 通知它的子控制器
//iOS 8.0 and later
//-viewWillTransitionToSize:withTransitionCoordinator:

//ios8.0之前
//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{}


#import "TabBarController.h"
#import "OneViewController.h"
#import "TwoViewController.h"
#import "ThreeViewController.h"

@interface TabBarController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *tabBarView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btns;

//记录当前正在显示的子控制器
@property(nonatomic,weak)UIViewController *currentVC;

//按钮的白色背景
@property(nonatomic,weak)UIImageView *whiteView;
@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //按钮的白色背景
    UIImageView *whiteView=[[UIImageView alloc]init];
    whiteView.image=[UIImage imageNamed:@"toolBar_shade"];
    whiteView.userInteractionEnabled=YES;
    [self.tabBarView insertSubview:whiteView atIndex:0];
    _whiteView=whiteView;
    
    //添加子控制器
    [self addChildViewController:[[OneViewController alloc]init]];
    [self addChildViewController:[[TwoViewController alloc]init]];
    [self addChildViewController:[[ThreeViewController alloc]init]];
    
    
    //初始页面显示第一个控制器的view
    UIViewController *vc=self.childViewControllers[0];
    vc.view.frame=self.contentView.bounds;
    [self.contentView addSubview:vc.view];
}

-(void)viewDidAppear:(BOOL)animated{
    UIButton *btn=self.btns[0];
    self.whiteView.frame=btn.frame;
}



-(IBAction)btnClicked:(UIButton *)btn{
    //切换控制器view
    UIViewController *vc=self.childViewControllers[btn.tag-100];
    [self switchToVC:vc withAnimationType:@"pageCurl"];
    
    //改变按钮背景
    [UIView animateWithDuration:0.5 animations:^{
        _whiteView.frame=btn.frame;
    }];
    
    //按钮切换的动画效果
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.scale";
    anim.values=@[@0.5,@1.4];
    anim.duration=0.3;
    [btn.titleLabel.layer addAnimation:anim forKey:nil];
}

/**
 *  切换控制器
 *
 *  @param viewController 目标控制器
 *  @param type           转场动画类型
 *
 *  type可选类型： Defaults to `fade'.
 *  fade
 *  moveIn
 *  push
 *  reveal
 *  pageCurl        向上翻一页
 *  pageUnCurl      向下翻一页
 *  rippleEffect    滴水效果
 *  suckEffect      收缩效果，如一块布被抽走
 *  cube            立方体效果
 *  oglFlip         上下翻转效果
 */
-(void)switchToVC:(UIViewController *)newVC withAnimationType:(NSString *)type{
    
    if (self.currentVC==newVC) return;
    
    //1.移除当前正在显示的子控制器view
    [_currentVC.view removeFromSuperview];
    
    //2.添加新控制器的view
    newVC.view.frame=self.contentView.bounds;
    [self.contentView addSubview:newVC.view];
    
    //3.获取控制器索引
    NSInteger oldIndex=[self.childViewControllers indexOfObject:_currentVC];
    NSInteger newIndex=[self.childViewControllers indexOfObject:newVC];
    
    //4.更新_currentVC
    _currentVC=newVC;
    
    if (oldIndex == NSNotFound) return;
    //5.设置切换view的转场动画
    CATransition *animation=[CATransition animation];
    //5.1 动画类型
    animation.type=type;
    //5.2 动画时长
    animation.duration=0.6;
    //5.3 动画方向
    if (newIndex>oldIndex) {
        animation.subtype=@"fromRight";
    }else{
        animation.subtype=@"fromLeft";
    }
    //4.4 添加动画
    [self.contentView.layer addAnimation:animation forKey:nil];
    
}

@end
