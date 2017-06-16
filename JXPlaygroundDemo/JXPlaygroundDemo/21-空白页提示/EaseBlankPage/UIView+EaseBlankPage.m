//
//  UIView+EaseBlankPage.m
//  Blossom
//
//  Created by wujunyang on 15/9/21.
//  Copyright © 2015年 wujunyang. All rights reserved.
//

#import "UIView+EaseBlankPage.h"

static char BlankPageViewKey;

@implementation UIView(EaseBlankPage)
/**!
 需要手动实现属性的 setter 方法，并在设置操作的前后分别调用 willChangeValueForKey: 和 didChangeValueForKey方法，这两个方法用于通知系统该 key 的属性值即将和已经变更了；
 其次，要实现类方法 automaticallyNotifiesObserversForKey，并在其中设置对该 key 不自动发送通知（返回 NO 即可）。这里要注意，对其它非手动实现的 key，要转交给 super 来处理。
 */

- (void)setBlankPageView:(EaseBlankPageView *)blankPageView{
    [self willChangeValueForKey:@"BlankPageViewKey"];
    objc_setAssociatedObject(self, &BlankPageViewKey,
                             blankPageView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"BlankPageViewKey"];
}

- (EaseBlankPageView *)blankPageView{
    return objc_getAssociatedObject(self, &BlankPageViewKey);
}

- (void)configBlankPage:(EaseBlankPageType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void (^)(id))block{
    if (hasData) {
        if (self.blankPageView) {
            self.blankPageView.hidden = YES;
            [self.blankPageView removeFromSuperview];
        }
    }else{
        if (!self.blankPageView) {
            self.blankPageView = [[EaseBlankPageView alloc] initWithFrame:self.bounds];
        }
        self.blankPageView.hidden = NO;
        [self.blankPageContainer addSubview:self.blankPageView];
        
        [self.blankPageView configWithType:blankPageType hasData:hasData hasError:hasError reloadButtonBlock:block];
    }
}

- (UIView *)blankPageContainer{
    UIView *blankPageContainer = self;
    for (UIView *aView in [self subviews]) {
        if ([aView isKindOfClass:[UITableView class]]) {
            blankPageContainer = aView;
        }
    }
    return blankPageContainer;
}
@end
