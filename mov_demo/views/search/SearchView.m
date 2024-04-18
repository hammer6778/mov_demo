//
//  SearchView.m
//  mov_demo
//
//  Created by Mountain on 13/04/2024.
//

#import "SearchView.h"

@implementation SearchView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        [self setNav];
    }
    return  self;
}



-(void)setNav{
    UIColor *brightOrangeColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0];
    UIColor *brightGreenColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.5 alpha:1.0];


    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, kStatusBarHeight+kNavigationBarHeight)];
    backView.backgroundColor = brightGreenColor;
    [self addSubview:backView];
    //城市
    UIButton *cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cityBtn.frame = CGRectMake(10, kStatusBarHeight+8, 40, 25);
    cityBtn.font = [UIFont systemFontOfSize:15];
    [cityBtn setTitle:@"广东" forState:UIControlStateNormal];
    [backView addSubview:cityBtn];
    //
    UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cityBtn.frame), kStatusBarHeight+14, 13, 10)];
    [arrowImage setImage:[UIImage imageNamed:@"icon_homepage_downArrow"]];
    [backView addSubview:arrowImage];
    //地图
    UIButton *mapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mapBtn.frame = CGRectMake(DeviceWidth-52, kStatusBarHeight+8, 42, 30);
    [mapBtn setImage:[UIImage imageNamed:@"map"] forState:UIControlStateNormal];
    [mapBtn addTarget:self action:@selector(OnMapBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:mapBtn];
    
    //搜索框
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(arrowImage.frame)+10, kStatusBarHeight+8, 220, 25)];
    //    searchView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_home_searchBar"]];
    searchView.backgroundColor = UIColor.lightGrayColor;
    searchView.layer.masksToBounds = YES;
    searchView.layer.cornerRadius = 12;
    [backView addSubview:searchView];
    
    //
    UIImageView *searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 15, 15)];
    [searchImage setImage:[UIImage imageNamed:@"icon_homepage_search"]];
    [searchView addSubview:searchImage];
    
    UILabel *placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 150, 25)];
    placeHolderLabel.font = [UIFont boldSystemFontOfSize:13];
    //    placeHolderLabel.text = @"请输入商家、品类、商圈";
    placeHolderLabel.text = @"鲁总专享版";
    placeHolderLabel.textColor = [UIColor whiteColor];
    [searchView addSubview:placeHolderLabel];
}

-(void)OnMapBtnTap:(UIButton *)sender{
    if (self.onMapTapBlock) {
        self.onMapTapBlock();
    }
}

@end
