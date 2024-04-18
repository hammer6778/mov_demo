//
//  WaterfallVC.m
//  mov_demo
//
//  Created by Mountain on 17/04/2024.
//

#import "WaterfallVC.h"
#import "PDKTCollectionViewWaterfallLayout.h"
#import "HomeCollectCell.h"
#import "CollectionViewSectionHeader.h"
#import "CollectionViewSectionFooter.h"
#import "NetWorkManager.h"
#import <MJExtension/MJExtension.h>
#import "Config.h"
@interface WaterfallVC ()<UICollectionViewDataSource,UICollectionViewDelegate,PDKTCollectionViewWaterfallLayoutDelegate>

@property (nonatomic, strong) NSMutableArray *splashList;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation WaterfallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self setCollectionV];
    [self getCollectData];
    
}

-(void)setNav{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, kStatusBarHeight+kNavigationBarHeight)];
    backView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:backView];
    //下划线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kNavigationBarHeight, DeviceWidth, 0.5)];
    lineView.backgroundColor = UIColor.lightGrayColor;
    [backView addSubview:lineView];
    
    //返回
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, kStatusBarHeight, 40, 40);
    // 调整图像的位置和大小
    CGFloat imageInset = 4; // 图像的边距
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(imageInset, imageInset, imageInset, imageInset)];

    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:backBtn];
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(DeviceWidth/2-80, kStatusBarHeight+6, 160, 30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"布瀑流";
    [backView addSubview: titleLabel];
}

-(void)OnBackBtn:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)getCollectData{
    NSString *urlString = [NSString stringWithFormat:@"https://api.unsplash.com/photos/?client_id=%@", UnplashAccessKey];
    NetWorkManager *net = [NetWorkManager sharedInstance];
    [net get:urlString parameters:nil success:^(NSDictionary *responseDict) {
        NSLog(@"plash结果=%@",responseDict);
        self.splashList = [UnsplashPhotoModel mj_objectArrayWithKeyValuesArray:responseDict];
        NSLog(@"plash数量%lu",(unsigned long)self.splashList.count);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    } failure:^(NSError *error) {
    }];
}

- (NSMutableArray *)splashList{
    return _splashList;
}


-(void)setCollectionV{
    PDKTCollectionViewWaterfallLayout *layout = [[PDKTCollectionViewWaterfallLayout alloc]init];
    layout.delegate = self;
    layout.columnCount = 2;
    layout.itemSpacing = 16;
    layout.sectionInset = UIEdgeInsetsMake(0, 20, 20, 20);
        
       // 初始化 UICollectionView
       self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kNavigationBarHeight, DeviceWidth, DeviceHeight-kStatusBarHeight-kNavigationBarHeight) collectionViewLayout:layout];
       self.collectionView.backgroundColor = [UIColor whiteColor];
       self.collectionView.delegate = self;
       self.collectionView.dataSource = self;
       [self.collectionView registerClass:[HomeCollectCell class] forCellWithReuseIdentifier:@"HomeCollectCell"];

    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewSectionHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionViewSectionHeader"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewSectionFooter" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CollectionViewSectionFooter"];
    
    [self.view addSubview:self.collectionView];
}



#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.splashList.count>0 ? 2:0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.splashList.count>0 ? self.splashList.count:0;

}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    // 获取相应的模型对象
    UnsplashPhotoModel *photoModel = self.splashList[indexPath.item];
    [cell configureWithPhotoModel:photoModel];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *supplementaryView;
    if (kind==UICollectionElementKindSectionHeader) {
        supplementaryView=[self sectionHeaderInCollectionView:collectionView atIndexPath:indexPath];
    }else if (kind==UICollectionElementKindSectionFooter){
        supplementaryView=[self sectionFooterInCollectionView:collectionView atIndexPath:indexPath];
    }
    return supplementaryView;
}

- (CollectionViewSectionHeader *)sectionHeaderInCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath{
    CollectionViewSectionHeader *sectionHeaderView;
    static NSString *viewIdentifier=@"CollectionViewSectionHeader";
    sectionHeaderView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:viewIdentifier forIndexPath:indexPath];
    sectionHeaderView.titleLabel.text=@"今日两点";
    sectionHeaderView.titleLabel.textColor=[UIColor blackColor];
    sectionHeaderView.backgroundColor=[UIColor greenColor];
    return sectionHeaderView;
}
- (CollectionViewSectionFooter *)sectionFooterInCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath{
    static NSString *viewIdentifier=@"CollectionViewSectionFooter";
    CollectionViewSectionFooter  *sectionFooterView;
    sectionFooterView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:viewIdentifier forIndexPath:indexPath];
    sectionFooterView.titleLabel.text=@"拓展模块";
    sectionFooterView.titleLabel.textColor=[UIColor blackColor];
    sectionFooterView.backgroundColor=[UIColor cyanColor];
    return sectionFooterView;
}

#pragma mark - UICollectionViewDelegate


#pragma mark - PDKTCollectionViewWaterfallLayoutDelegate
- (NSUInteger)collectionView:(UICollectionView *)collectionView layout:(PDKTCollectionViewWaterfallLayout *)collectionViewLayout numberOfColumnsInSection:(NSUInteger)section{
    return 2;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(PDKTCollectionViewWaterfallLayout *)collectionViewLayout heightItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UnsplashPhotoModel *photoModel = self.splashList[indexPath.item];
    //计算文本高度
    NSUInteger maxLines = 3;
    CGFloat maxWidth = DeviceWidth/2 - 5;
    UIFont *font = [UIFont systemFontOfSize:14];
    CGFloat labelHeight = [NSString heightForText:photoModel.altDescription maxWidth:maxWidth font:font maxLines:maxLines];
    
    return 100 + labelHeight + 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(PDKTCollectionViewWaterfallLayout *)collectionViewLayout itemSpacingInSection:(NSUInteger)section{
    return 10;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(PDKTCollectionViewWaterfallLayout *)collectionViewLayout sectionInsetForSection:(NSUInteger)section{
  
    return UIEdgeInsetsZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(PDKTCollectionViewWaterfallLayout *)collectionViewLayout sizeForSupplementaryViewInSection:(NSUInteger)section kind:(NSString *)kind{
    return CGSizeMake(self.collectionView.bounds.size.width, 60);
}
- (BOOL)shouldStickHeaderToTopInSection:(NSUInteger)section{
    return YES;
}

@end
