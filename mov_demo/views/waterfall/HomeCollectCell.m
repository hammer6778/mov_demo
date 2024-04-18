//
//  HomeCollectCell.m
//  mov_demo
//
//  Created by Mountain on 17/04/2024.
//

#import "HomeCollectCell.h"
#import <UIKit/UIKit.h>
#import <SDWebImage/SDWebImage.h>
@implementation HomeCollectCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        
//        self.layer.borderColor = [UIColor redColor].CGColor;
//        self.layer.borderWidth = 1.0;
        self.clipsToBounds = true;
    }
    return self;
}

- (void)setupViews {
    // 在需要添加骨架屏的地方
//    UIView *skeletonView = [[UIView alloc] initWithFrame:self.contentView.bounds];
//    skeletonView.isSkeletonable = YES; // 启用骨架屏功能
//    skeletonView.skeletonCornerRadius = 8.0; // 设置圆角
//    self.skeletonView = skeletonView;
//    [skeletonView showSkeleton]; // 显示骨架屏
//    [self.contentView addSubview:skeletonView];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    //注意一定是self.contentView，不是self addSubview
    [self.contentView addSubview:self.imageView];

    self.label = [[UILabel alloc] init];
    self.label.font = [UIFont systemFontOfSize:14];
    self.label.textAlignment = NSTextAlignmentLeft;
    self.label.numberOfLines = 3;
    self.label.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:self.label];

    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(100);
    }];

    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(10);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
//        make.bottom.equalTo(self.contentView);
    }];
}

- (void)configureWithPhotoModel:(UnsplashPhotoModel *)photoModel {
    [self.imageView sd_cancelCurrentImageLoad]; // 取消之前的加载请求
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:photoModel.urls.regular]
                      placeholderImage:[UIImage imageWithColor:[UIColor lightGrayColor] size:self.contentView.frame.size]];
    self.label.text = photoModel.altDescription;
    
}







@end

