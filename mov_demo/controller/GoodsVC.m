//
//  GoodsVC.m
//  mov_demo
//
//  Created by Mountain on 04/04/2024.
//

#import "GoodsVC.h"
#import "ProductCell.h"
#import "GiftAnimationView.h"
@interface GoodsVC ()<UITableViewDelegate, UITableViewDataSource, CustomCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *products;

@end

@implementation GoodsVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableV];
    [self setRunloop];
}

-(void)setTableV{
    NSMutableArray<Product *> *products = [NSMutableArray array];
    
    // 获取当前时间
    NSDate *now = [NSDate date];
    NSTimeInterval timestamp = [now timeIntervalSinceReferenceDate];
    // 添加示例数据到数组中
    for (int i = 0; i < 10; i++) {
        // 每个商品的倒计时时间增加10秒
        NSTimeInterval countdownTime = timestamp + i * 10;
        Product *product = [[Product alloc] init];
        product.productImageName = @"car"; // 示例图片名称
        product.productName = [NSString stringWithFormat:@"Product %d", i + 1]; // 示例产品名称
        product.countdownTime = countdownTime;
        [products addObject:product];
    }
    self.products = products;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[ProductCell class] forCellReuseIdentifier:@"ProductCell"];
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductCell" forIndexPath:indexPath];
    [cell configureCellWithProduct:self.products[indexPath.row]];
    //    cell.delegate = self;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - ProductTableViewCellDelegate
- (void)customCell:(ProductCell *)cell didTapButton:(UIButton *)button{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath) {
        NSLog(@"Buy button tapped for product: %@", self.products[indexPath.row]);
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self runAnimate];
}

-(void)setGiftAnimationV:(NSString *)gift withrect:(CGRect)rect{
    GiftAnimationView *giftView = [[GiftAnimationView alloc] initWithFrame:rect];
    giftView.giftName = gift;
    giftView.quantity = 12;
    [giftView showAnimationWithCompletion:^{
        [giftView removeFromSuperview];
    }];
    [self.view addSubview:giftView];
    
}

-(void)runAnimate{
    dispatch_queue_t queue1 = dispatch_queue_create("com.example.queue1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue2 = dispatch_queue_create("com.example.queue2", DISPATCH_QUEUE_CONCURRENT);
    
    GiftAnimationView *giftView1 = [[GiftAnimationView alloc] initWithFrame:CGRectMake(0, 200, 120, 32)]; // 设置 queue1 的 frame
    giftView1.giftName = @"car";
    giftView1.quantity = 12;
    
    GiftAnimationView *giftView2 = [[GiftAnimationView alloc] initWithFrame:CGRectMake(0, 400, 120, 32)]; // 设置 queue2 的 frame
    giftView2.giftName = @"clound";
    giftView2.quantity = 6;
    
    dispatch_async(queue1, ^{
        // 在第一个队列中执行任务
        dispatch_async(dispatch_get_main_queue(), ^{
            // 主线程更新 UI
            [self.view addSubview:giftView1];
            [giftView1 showAnimationWithCompletion:^{
                [giftView1 removeFromSuperview];
            }];
        });
    });
    
    dispatch_async(queue2, ^{
        // 在第二个队列中执行任务
        dispatch_async(dispatch_get_main_queue(), ^{
            // 主线程更新 UI
            [self.view addSubview:giftView2];
            [giftView2 showAnimationWithCompletion:^{
                [giftView2 removeFromSuperview];
            }];
        });
    });
    
}

-(void)setRunloop{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建定时器
        NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            NSLog(@"Timer fired!");
            // 执行任务
        }];
        // 将定时器添加到当前运行循环中
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        // 运行当前运行循环
        [[NSRunLoop currentRunLoop] run];
    });

}


@end
