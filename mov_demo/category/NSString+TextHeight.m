//
//  NSString+TextHeight.m
//  mov_demo
//
//  Created by Mountain on 17/04/2024.
//

#import "NSString+TextHeight.h"

@implementation NSString (TextHeight)

+(CGFloat)heightForText:(NSString *)text maxWidth:(CGFloat)maxWidth font:(UIFont *)font maxLines:(NSUInteger)maxLines {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.maximumLineHeight = font.lineHeight * maxLines;

    NSDictionary *attributes = @{
        NSFontAttributeName: font,
        NSParagraphStyleAttributeName: paragraphStyle
    };

    CGRect boundingRect = [text boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];

    return ceil(MIN(boundingRect.size.height, font.lineHeight * maxLines));
}

@end
