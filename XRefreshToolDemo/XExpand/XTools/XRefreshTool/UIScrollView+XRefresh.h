//
//  UIScrollView+XRefresh.h
//  LEVE
//
//  Created by canoe on 2018/4/13.
//  Copyright © 2018年 dashuju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefresh.h>
#import "XMacros.h"

typedef NS_ENUM(NSUInteger, XHeaderRefreshMode) {
    XHeaderRefreshModeNormal,
};

typedef NS_ENUM(NSUInteger, XFooterRefreshMode) {
    XFooterRefreshModeNormal,
};

@interface UIScrollView (XRefresh)

/**
 上下拉视图的样式
 */
@property(nonatomic, assign) XHeaderRefreshMode headerRefreshMode;
@property(nonatomic, assign) XFooterRefreshMode footerRefreshMode;

/**
 添加上下拉刷新效果
 */
- (void)addRefreshWithHeaderBlock:(void (^)(void))headerBlock;
- (void)addRefreshWithFooterBlock:(void (^)(void))footerBlock;
- (void)addRefreshWithHeaderBlock:(void (^)(void))headerBlock footerBlock:(void (^)(void))footerBlock;

/**
 手动调用下拉刷新
 */
- (void)headerBeginRefreshing;

/**
 没有更多数据
 */
- (void)footerNoMoreData;

/**
 结束刷新状态
 */
- (void)headerEndRefreshing;
- (void)footerEndRefreshing;
- (void)endRefreshing;

@end
