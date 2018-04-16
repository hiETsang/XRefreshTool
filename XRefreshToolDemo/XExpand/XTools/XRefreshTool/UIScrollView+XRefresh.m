//
//  UIScrollView+XRefresh.m
//  LEVE
//
//  Created by canoe on 2018/4/13.
//  Copyright © 2018年 dashuju. All rights reserved.
//

#import "UIScrollView+XRefresh.h"

static int headerRefreshModeKey;
static int footerRefreshModeKey;

@implementation UIScrollView (XRefresh)
/**
 设置上下拉视图的样式
 */
- (void)setHeaderRefreshMode:(XHeaderRefreshMode)mode
{
    objc_setAssociatedObject(self, &headerRefreshModeKey, [NSNumber numberWithInteger:mode],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(XHeaderRefreshMode)headerRefreshMode
{
    return [objc_getAssociatedObject(self, &headerRefreshModeKey) integerValue];
}


- (void)setFooterRefreshMode:(XFooterRefreshMode)mode
{
    objc_setAssociatedObject(self, &footerRefreshModeKey, [NSNumber numberWithInteger:mode],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(XFooterRefreshMode)footerRefreshMode
{
    return [objc_getAssociatedObject(self, &footerRefreshModeKey) integerValue];
}

/**
 添加上下拉刷新效果
 */
- (void)addRefreshWithHeaderBlock:(void (^)(void))headerBlock
{
    switch (self.headerRefreshMode) {
        case XHeaderRefreshModeNormal:
            {
                MJRefreshNormalHeader *header = [[MJRefreshNormalHeader alloc] init];
                [header setTitle:@"释放更新" forState:MJRefreshStatePulling];
                [header setTitle:@"正在更新" forState:MJRefreshStateRefreshing];
                [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
                header.stateLabel.font = [UIFont systemFontOfSize:13];
                header.stateLabel.textColor = RGB(69, 74, 95);
                header.lastUpdatedTimeLabel.hidden = YES;
                self.mj_header = header;
            }
            break;
        default:
            break;
    }
    __weak __typeof(self)weakSelf = self;
    self.mj_header.refreshingBlock = ^{
        if (weakSelf.mj_footer && weakSelf.mj_footer.state == MJRefreshStateNoMoreData) {
            [weakSelf.mj_footer resetNoMoreData];
        }
        if (headerBlock) {
            headerBlock();
        }
    };
}

- (void)addRefreshWithFooterBlock:(void (^)(void))footerBlock
{
    switch (self.footerRefreshMode) {
        case XFooterRefreshModeNormal:
        {
            MJRefreshBackNormalFooter *footer = [[MJRefreshBackNormalFooter alloc] init];
            [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
            [footer setTitle:@"松开立即加载" forState:MJRefreshStatePulling];
            [footer setTitle:@"正在为您加载数据" forState:MJRefreshStateRefreshing];
            [footer setTitle:@"没有更多了~" forState:MJRefreshStateNoMoreData];
            footer.stateLabel.textColor = [UIColor whiteColor];//kRGBColor(90, 90, 90);
            footer.stateLabel.font = [UIFont systemFontOfSize:13.0];
            footer.backgroundColor = [UIColor clearColor];
            self.mj_footer = footer;
        }
            break;
            
        default:
            break;
    }
    
    self.mj_footer.refreshingBlock = ^{
        if (footerBlock) {
            footerBlock();
        }
    };
}

- (void)addRefreshWithHeaderBlock:(void (^)(void))headerBlock footerBlock:(void (^)(void))footerBlock
{
    [self addRefreshWithHeaderBlock:headerBlock];
    [self addRefreshWithFooterBlock:footerBlock];
}

/**
 手动调用下拉刷新
 */
- (void)headerBeginRefreshing
{
    [self.mj_header beginRefreshing];
}

/**
 没有更多数据
 */
- (void)footerNoMoreData
{
    [self.mj_footer endRefreshingWithNoMoreData];
}

/**
 结束刷新状态
 */
- (void)headerEndRefreshing
{
    [self.mj_header endRefreshing];
}

- (void)footerEndRefreshing
{
    [self.mj_footer endRefreshing];
}

- (void)endRefreshing
{
    [self headerEndRefreshing];
    [self footerEndRefreshing];
}

@end
