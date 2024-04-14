#import "ADScrollView.h"

@interface ADScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation ADScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _itemHeight = 32.0; // 默认行高
        _currentIndex = 0; // 初始化索引
        [self setupScrollView];
        [self startTimer];
    }
    return self;
}

- (void)dealloc {
    [self.timer invalidate];
}

- (void)setupScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollView];
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    [self loadViews];
}

- (void)loadViews {
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)]; // 移除之前的视图
    
    CGFloat contentHeight = 0;
    NSInteger itemCount = ceil(self.scrollView.bounds.size.height / (self.itemHeight * 3)) + 1; // 计算可见的三行标题数及额外一组三行标题
    for (NSInteger i = 0; i < itemCount; i++) {
        NSInteger index = (self.currentIndex + i * 3) % self.titles.count; // 循环获取标题
        UIView *view = [self createViewWithTitles:self.titles fromIndex:index];
        view.frame = CGRectMake(0, contentHeight, self.scrollView.bounds.size.width, self.itemHeight * 3); // 设置视图的高度为三行高度
        [self.scrollView addSubview:view];
        contentHeight += self.itemHeight * 3; // 累加高度
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, contentHeight);
}

- (UIView *)createViewWithTitles:(NSArray *)titles fromIndex:(NSInteger)index {
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectZero];
    
    CGFloat lineHeight = 1.0 / [UIScreen mainScreen].scale; // 获取屏幕的分辨率，并计算出 1 个像素的高度
    
    for (NSInteger i = 0; i < 3; i++) {
        NSInteger currentIndex = (index + i) % self.titles.count;
        NSString *title = titles[currentIndex];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, i * self.itemHeight, self.scrollView.bounds.size.width - 20, self.itemHeight)];
        label.text = title;
        label.font = [UIFont systemFontOfSize:14];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        [containerView addSubview:label];
        
        
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, (i + 1) * self.itemHeight - lineHeight, self.scrollView.bounds.size.width, lineHeight)];
        separator.backgroundColor = [UIColor lightGrayColor];
        [containerView addSubview:separator];
    }
    
    return containerView;
}


- (UIView *)createViewWithTitle:(NSString *)title {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = UIColor.redColor;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.scrollView.bounds.size.width - 20, self.itemHeight)];
    label.text = title;
    label.font = [UIFont systemFontOfSize:14];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    [view addSubview:label];
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, self.itemHeight - 2, self.scrollView.bounds.size.width, 1)];
    separator.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:separator];
    
    return view;
}

- (void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(scrollToNextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)scrollToNextPage {
    CGFloat nextOffset = self.scrollView.contentOffset.y + self.itemHeight;
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollView.contentOffset = CGPointMake(0, nextOffset);
    } completion:^(BOOL finished) {
        if (nextOffset >= self.scrollView.contentSize.height - self.scrollView.bounds.size.height && nextOffset > 0) {
            // 滚动到底部，且不是刚开始滚动时，才重置到顶部并重新加载数据
            self.scrollView.contentOffset = CGPointMake(0, 0);
            self.currentIndex = (self.currentIndex + 1) % self.titles.count; // 更新索引
            [self loadViews];
        }
    }];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

@end
