//
//  GoodsVC.m
//  mov_demo
//
//  Created by Mountain on 04/04/2024.
//

#import "GoodsVC.h"
#import "ProductCell.h"

@interface GoodsVC ()<UITableViewDelegate, UITableViewDataSource, CustomCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *products;
@end

@implementation GoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 隐藏导航栏
    //    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    // 创建 Product 对象数组
    NSMutableArray<Product *> *products = [NSMutableArray array];
    
    // 获取当前时间
    NSDate *now = [NSDate date];
    // 将当前时间转换为 NSTimeInterval 类型的时间戳
    NSTimeInterval timestamp = [now timeIntervalSinceReferenceDate];
    // 打印时间戳
    NSLog(@"当前时间的时间戳：%f", timestamp);
    
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
@end
