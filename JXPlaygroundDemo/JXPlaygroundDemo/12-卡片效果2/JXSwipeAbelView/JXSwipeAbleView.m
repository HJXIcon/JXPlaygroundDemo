//
//  JXSwipeAbleView.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/6.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXSwipeAbleView.h"
#import "JXViewManager.h"
#import "JXScheduler.h"
#import "JXSwipeAbleSwipeOptions.h"
#import "DefaultDirectionInterpretor.h"
#import "DefaultShouldSwipeDeterminator.h"
#import "DefaultViewAnimator.h"
#import "Utils.h"

@interface JXSwipeAbleView ()

@property (nonatomic) NSMutableArray<UIView *> *mutableHistory;

@property (strong, nonatomic) UIView *containerView;

@property (strong, nonatomic) UIView *miscContainerView;

@property (strong, nonatomic) UIDynamicAnimator *animator;

@property (strong, nonatomic) NSMutableDictionary<NSValue *, JXViewManager *> *viewManagers;

@property (strong, nonatomic) JXScheduler *scheduler;


@end
@implementation JXSwipeAbleView

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.numberOfActiveViews = 4;
    self.mutableHistory = [NSMutableArray array];
    self.numberOfHistoryItem = 10;
    
    self.allowedDirection = JXSwipeAbleViewDirectionAll;
    self.minTranslationInPercent = 0.25;
    self.minVelocityInPointPerSecond = 750;
    
    self.containerView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.containerView];
    
    self.miscContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.miscContainerView];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    
    self.viewManagers = [NSMutableDictionary dictionary];
    
    self.scheduler = [[JXScheduler alloc] init];
    
    self.viewAnimator = [[DefaultViewAnimator alloc] init];
    self.swipingDeterminator = [[DefaultShouldSwipeDeterminator alloc] init];
    self.directionInterpretor = [[DefaultDirectionInterpretor alloc] init];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.containerView.frame = self.bounds;
}

#pragma mark - Properties

- (NSArray<UIView *> *)history {
    return [_mutableHistory mutableCopy];
}

#pragma mark - Public APIs

- (UIView *)topView {
    return [self activeViews].firstObject;
}

- (NSArray<UIView *> *)activeViews {
    NSPredicate *notSwipingViews =
    [NSPredicate predicateWithBlock:^BOOL(UIView *view, NSDictionary *bindings) {
        JXViewManager *manager = [self managerForView:view];
        if (!manager) {
            return false;
        }
        return manager.state != ViewManagerStateSwiping;
    }];
    return [[[[self allViews]
              filteredArrayUsingPredicate:notSwipingViews] reverseObjectEnumerator] allObjects];
}

- (void)loadViewsIfNeeded {
    for (NSInteger i = [self activeViews].count; i < self.numberOfActiveViews; i++) {
        UIView *nextView = [self nextView];
        if (nextView) {
            [self insert:nextView atIndex:0];
        }
    }
    [self updateViews];
}

- (void)rewind {
    UIView *viewToBeRewinded;
    
    if (_mutableHistory.lastObject) {
        viewToBeRewinded = _mutableHistory.lastObject;
        [_mutableHistory removeLastObject];
    } else {
        viewToBeRewinded = [self previousView];
    }
    
    if (!viewToBeRewinded) {
        return;
    }
    
    [self insert:viewToBeRewinded atIndex:[self allViews].count];
    [self updateViews];
}

- (void)discardAllViews {
    for (UIView *view in [self allViews]) {
        [self remove:view];
    }
}

- (void)swipeTopViewToLeft {
    [self swipeTopViewInDirection:JXSwipeAbleViewDirectionLeft];
}

- (void)swipeTopViewToRight {
    [self swipeTopViewInDirection:JXSwipeAbleViewDirectionRight];
}

- (void)swipeTopViewToUp {
    [self swipeTopViewInDirection:JXSwipeAbleViewDirectionUp];
}

- (void)swipeTopViewToDown {
    [self swipeTopViewInDirection:JXSwipeAbleViewDirectionDown];
}

- (void)swipeTopViewInDirection:(JXSwipeAbleViewDirection)direction {
    UIView *topView = [self topView];
    if (!topView) {
        return;
    }
    
    JXSwipeAbleSwipeOptions *swipeOptions =
    [_directionInterpretor interpretDirection:direction
                                         view:topView
                                        index:0
                                        views:[self activeViews]
                                swipeableView:self];
    [self swipeTopViewFromPoint:swipeOptions.location inDirection:swipeOptions.direction];
}

- (void)swipeTopViewFromPoint:(CGPoint)point inDirection:(CGVector)directionVector {
    UIView *topView = [self topView];
    if (!topView) {
        return;
    }
    JXViewManager *topViewManager = [self managerForView:topView];
    if (!topViewManager) {
        return;
    }
    [self swipeView:topView location:point directionVector:directionVector];
}

#pragma mark - Private APIs

- (NSArray<UIView *> *)allViews {
    return self.containerView.subviews;
}

- (NSArray<UIView *> *)inactiveViews {
    NSArray<UIView *> *activeViews = [self activeViews];
    return [[[[self allViews]
              filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIView *view,
                                                                                NSDictionary *bindings) {
        return ![activeViews containsObject:view];
    }]] reverseObjectEnumerator] allObjects];
}

- (void)insert:(UIView *_Nonnull)view atIndex:(NSUInteger)index {
    if ([[self allViews] containsObject:view]) {
        JXViewManager *viewManager = [self managerForView:view];
        if (!viewManager) {
            return;
        }
        [viewManager setStateSnappingAtContainerViewCenter];
        return;
    }
    
    JXViewManager *viewManager = [[JXViewManager alloc] initWithView:view
                                                   containerView:self.containerView
                                                           index:index
                                               miscContainerView:self.miscContainerView
                                                        animator:self.animator
                                                   swipeableView:self];
    [self setManagerForView:view viewManager:viewManager];
}

- (void)remove:(UIView *)view {
    if (![[self allViews] containsObject:view]) {
        return;
    }
    
    [self removeManagerForView:view];
}

- (void)updateViews {
    NSArray<UIView *> *activeViews = [self activeViews];
    NSArray<UIView *> *inactiveViews = [self inactiveViews];
    
    for (UIView *view in inactiveViews) {
        view.userInteractionEnabled = false;
    }
    
    UIView *topView = [self topView];
    if (!topView) {
        return;
    }
    for (UIGestureRecognizer *recognizer in topView.gestureRecognizers) {
        if (recognizer.state != UIGestureRecognizerStatePossible) {
            return;
        }
    }
    
    for (NSUInteger i = 0; i < activeViews.count; i++) {
        UIView *view = activeViews[i];
        view.userInteractionEnabled = true;
        BOOL shouldBeHidden = i >= self.numberOfActiveViews;
        view.hidden = shouldBeHidden;
        if (shouldBeHidden) {
            continue;
        }
        [self.viewAnimator animateView:view index:i views:activeViews swipeableView:self];
    }
}

- (void)swipeView:(UIView *)view
         location:(CGPoint)location
  directionVector:(CGVector)directionVector {
    
    [[self managerForView:view] setStateSwiping:location direction:directionVector];
    
    JXSwipeAbleViewDirection direction = JXSwipeAbleViewDirectionFromVector(directionVector);
    
    NSPredicate *outOfBoundViews =
    [NSPredicate predicateWithBlock:^BOOL(UIView *view, NSDictionary *bindings) {
        return !CGRectIntersectsRect([_containerView convertRect:view.frame toView:nil],
                                     [UIScreen mainScreen].bounds);
    }];
    [self scheduleToBeRemoved:view withPredicate:outOfBoundViews];
    
    if (_delegate &&
        [_delegate respondsToSelector:@selector(swipeableView:didSwipeView:inDirection:)]) {
        [_delegate swipeableView:self didSwipeView:view inDirection:direction];
    }
    [self loadViewsIfNeeded];
}

- (void)scheduleToBeRemoved:(UIView *)view withPredicate:(NSPredicate *)predicate {
    if (![[self allViews] containsObject:view]) {
        return;
    }
    
    [_mutableHistory addObject:view];
    if (_mutableHistory.count > _numberOfHistoryItem) {
        [_mutableHistory removeObjectAtIndex:0];
    }
    
    [_scheduler scheduleActionRepeatedly:^{
        NSArray *matchedViews = [[self inactiveViews] filteredArrayUsingPredicate:predicate];
        for (UIView *view in matchedViews) {
            [self remove:view];
        }
    } interval:0.3
                            endCondition:^BOOL {
                                return [self activeViews].count == [self allViews].count;
                            }];
}

#pragma mark - ()

- (UIView *)nextView {
    if ([self.dataSource respondsToSelector:@selector(nextViewForSwipeableView:)]) {
        return [self.dataSource nextViewForSwipeableView:self];
    }
    return nil;
}

- (UIView *)previousView {
    if ([self.dataSource respondsToSelector:@selector(previousViewForSwipeableView:)]) {
        return [self.dataSource previousViewForSwipeableView:self];
    }
    return nil;
}

- (JXViewManager *)managerForView:(UIView *)view {
    return [_viewManagers objectForKey:[NSValue valueWithNonretainedObject:view]];
}

- (void)setManagerForView:(UIView *)view viewManager:(JXViewManager *)viewManager {
    _viewManagers[[NSValue valueWithNonretainedObject:view]] = viewManager;
}

- (void)removeManagerForView:(UIView *)view {
    [_viewManagers removeObjectForKey:[NSValue valueWithNonretainedObject:view]];
}


@end
