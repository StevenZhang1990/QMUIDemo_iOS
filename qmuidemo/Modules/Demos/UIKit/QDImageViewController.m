//
//  QDImageViewController.m
//  qmui
//
//  Created by MoLice on 14-7-13.
//  Copyright (c) 2014年 QMUI Team. All rights reserved.
//

#import "QDImageViewController.h"

@interface QDImageViewController ()

@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UIScrollView *contentScrollView;
@property(nonatomic, strong) UILabel *methodNameLabel;
@end

@implementation QDImageViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        self.tableViewInitialContentInset = UIEdgeInsetsMake(NavigationContentStaticTop, 0, 0, 0);
    }
    return self;
}

- (void)initDataSource {
    self.dataSourceWithDetailText = [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                     @"- averageColor", @"获取整张图片的平均颜色",
                                     @"- grayImage", @"将图片置灰",
                                     @"- imageWithAlpha:", @"调整图片的alpha值，返回一张新图片",
                                     @"- imageWithTintColor:", @"更改图片的颜色，只支持按路径来渲染图片",
                                     @"- imageWithImageAbove:atPoint:", @"将一张图片叠在当前图片上方的指定位置",
                                     @"- imageWithSpacingExtensionInsets:", @"拓展当前图片外部边距，拓展的区域填充透明",
                                     @"- imageWithClippedRect:", @"将图片内指定区域的矩形裁剪出来，返回裁剪出来的区域",
                                     @"- imageWithScaleToSize:contentMode:", @"将当前图片缩放到指定的大小，缩放策略可以指定不同的contentMode，经过缩放后的图片倍数保持不变",
                                     @"- imageWithScaleToSize:contentMode:scale:", @"同上，只是可以指定倍数",
                                     @"- imageWithOrientation:", @"将图片旋转到指定方向，支持上下左右、水平&垂直翻转",
                                     @"- imageWithBorderColor:path:", @"在当前图片上叠加绘制一条路径",
                                     @"- imageWithBorderColor:borderWidth:cornerRadius:", @"在当前图片上加上一条外边框，可指定边框大小和圆角",
                                     @"- imageWithBorderColor:borderWidth:cornerRadius:dashedLengths:", @"同上，但可额外指定边框为虚线",
                                     @"- imageWithBorderColor:borderWidth:borderPosition:", @"在当前图片上加上一条边框，可指定边框的位置，支持上下左右",
                                     @"- imageWithMaskImage:usingMaskImageMode:", @"用一张图片作为当前图片的遮罩，并返回遮罩后的图片",
                                     @"+ imageWithColor:", @"生成一张纯色的矩形图片，默认大小为(4, 4)",
                                     @"+ imageWithColor:size:cornerRadius:", @"生成一张纯色的矩形图片，可指定图片的大小和圆角",
                                     @"+ imageWithColor:size:cornerRadiusArray:", @"同上，但四个角的圆角值允许不相等",
                                     @"+ imageWithStrokeColor:size:path:addClip:", @"将一条路径绘制到指定大小的画图里，并返回生成的图片",
                                     @"+ imageWithStrokeColor:size:lineWidth:cornerRadius:", @"生成一张指定大小的矩形图片，背景透明，带描边和圆角",
                                     @"+ imageWithStrokeColor:size:lineWidth:borderPosition:", @"生成一张指定大小的矩形图片，允许在各个方向选择添加边框",
                                     @"+ imageWithShape:size:tintColor:", @"用预先提供的若干种形状生成一张图片，可选择大小和颜色",
                                     @"+ imageWithShape:size:lineWidth:tintColor:", @"同上，但可指定图片内的线条粗细",
                                     @"+ imageWithAttributedString:", @"将给定的NSAttributedString渲染为图片（单行）",
                                     @"+ imageWithView:", @"生成给定View的截图",
                                     @"+ imageWithView:afterScreenUpdates:", @"在当前runloop更新后再生成给定View的截图",
                                     nil];
}

- (void)initSubviews {
    [super initSubviews];
    CGFloat maximumContentViewWidth = fminf(CGRectGetWidth(self.view.bounds), [QMUIHelper screenSizeFor47Inch].width) - 20 * 2;
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, maximumContentViewWidth, 0)];
    self.contentView.backgroundColor = UIColorWhite;
    self.contentView.layer.cornerRadius = 6;
    
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
    self.contentScrollView.contentInset = UIEdgeInsetsMake(20, 20, 20, 20);
    self.contentScrollView.alwaysBounceHorizontal = NO;
    self.contentScrollView.alwaysBounceVertical = NO;
    self.contentScrollView.scrollsToTop = NO;
    [self.contentView addSubview:self.contentScrollView];
    
    self.methodNameLabel = [[UILabel alloc] initWithFont:[UIFont fontWithName:@"Menlo" size:16] textColor:UIColorBlue];
    self.methodNameLabel.numberOfLines = 0;
    self.methodNameLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentScrollView addSubview:self.methodNameLabel];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.contentScrollView.frame = self.contentView.bounds;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QMUITableViewCell *cell = (QMUITableViewCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.font = CodeFontMake(14);
    cell.textLabel.textColor = UIColorBlue;
    cell.detailTextLabel.font = UIFontMake(12);
    cell.detailTextLabel.textColor = UIColorGray;
    cell.detailTextLabelEdgeInsets = UIEdgeInsetsMake(2, 0, 0, 0);
    return cell;
}

- (void)didSelectCellWithTitle:(NSString *)title {
    CGFloat contentViewLimitWidth = [self contentViewLimitWidth];
    
    self.methodNameLabel.text = title;
    CGSize methodLabelSize = [self.methodNameLabel sizeThatFits:CGSizeMake(contentViewLimitWidth, CGFLOAT_MAX)];
    self.methodNameLabel.frame = CGRectMake(0, 0, contentViewLimitWidth, methodLabelSize.height);
    
    CGFloat contentSizeHeight = 0;
    if ([title isEqualToString:@"- averageColor"]) {
        contentSizeHeight = [self generateExampleViewForAverageColor];
    } else if ([title isEqualToString:@"- grayImage"]) {
        contentSizeHeight = [self generateExampleViewForGrayImage];
    } else if ([title isEqualToString:@"- imageWithAlpha:"]) {
        contentSizeHeight = [self generateExampleViewForImageWithAlpha];
    } else if ([title isEqualToString:@"- imageWithTintColor:"]) {
        contentSizeHeight = [self generateExampleViewForImageWithTintColor];
    } else if ([title isEqualToString:@"- imageWithImageAbove:atPoint:"]) {
        contentSizeHeight = [self generateExampleViewForImageWithImageAbove];
    } else if ([title isEqualToString:@"- imageWithSpacingExtensionInsets:"]) {
        contentSizeHeight = [self generateExampleViewForImageWithSpacingExtensionInsets];
    } else if ([title isEqualToString:@"- imageWithClippedRect:"]) {
        contentSizeHeight = [self generateExampleViewForImageWithClippedRect];
    } else if ([title isEqualToString:@"- imageWithScaleToSize:contentMode:"] || [title isEqualToString:@"- imageWithScaleToSize:contentMode:scale:"]) {
        contentSizeHeight = [self generateExampleViewForImageWithScaleToSize];
    } else if ([title isEqualToString:@"- imageWithOrientation:"]) {
        contentSizeHeight = [self generateExampleViewForImageWithDirection];
    } else if ([title isEqualToString:@"- imageWithBorderColor:path:"]) {
        contentSizeHeight = [self generateExampleViewForImageWithBorder];
    } else if ([title isEqualToString:@"- imageWithBorderColor:borderWidth:cornerRadius:"] || [title isEqualToString:@"- imageWithBorderColor:borderWidth:cornerRadius:dashedLengths:"]) {
        contentSizeHeight = [self generateExampleViewForImageWithBorderColorAndCornerRadius];
    } else if ([title isEqualToString:@"- imageWithBorderColor:borderWidth:borderPosition:"]) {
        contentSizeHeight = [self generateExampleViewForImageWithBorderColorAndCornerRadiusAndPosition];
    } else if ([title isEqualToString:@"- imageWithMaskImage:usingMaskImageMode:"]) {
        contentSizeHeight = [self generateExampleViewForImageWithMaskImage];
    } else if ([title isEqualToString:@"+ imageWithColor:"] || [title isEqualToString:@"+ imageWithColor:size:cornerRadius:"]) {
        contentSizeHeight = [self generateExampleViewForImageWithColor];
    } else if ([title isEqualToString:@"+ imageWithColor:size:cornerRadiusArray:"]) {
        contentSizeHeight = [self generateExampleViewForImageWithColorAndCornerRadiusArray];
    } else if ([title isEqualToString:@"+ imageWithStrokeColor:size:path:addClip:"]) {
        contentSizeHeight = [self generateExampleViewForImageWithStrokeColorAndPath];
    } else if ([title isEqualToString:@"+ imageWithStrokeColor:size:lineWidth:cornerRadius:"]) {
        contentSizeHeight = [self generateExampleViewForImageWithStrokeColorAndCornerRadius];
    } else if ([title isEqualToString:@"+ imageWithStrokeColor:size:lineWidth:borderPosition:"]) {
        contentSizeHeight = [self generateExampleViewForImageWithStrokeColorAndBorderPosition];
    } else if ([title isEqualToString:@"+ imageWithShape:size:tintColor:"] || [title isEqualToString:@"+ imageWithShape:size:lineWidth:tintColor:"]) {
        contentSizeHeight = [self generateExampleViewForImageWithShape];
    } else if ([title isEqualToString:@"+ imageWithAttributedString:"]) {
        contentSizeHeight = [self generateExampleViewForImageWithAttributedString];
    } else if ([title isEqualToString:@"+ imageWithView:"] || [title isEqualToString:@"+ imageWithView:afterScreenUpdates:"]) {
        contentSizeHeight = [self generateExampleViewForImageWithView];
    }
    self.contentScrollView.contentSize = CGSizeMake(contentViewLimitWidth, contentSizeHeight);
    
    CGFloat contentViewPreferHeight = UIEdgeInsetsGetVerticalValue(self.contentScrollView.contentInset) + self.contentScrollView.contentSize.height;
    CGFloat contentViewLimitHeight = CGRectGetHeight(self.view.bounds) - 40 * 2;
    self.contentView.frame = CGRectSetHeight(self.contentView.frame, fminf(contentViewLimitHeight, contentViewPreferHeight));
    self.contentScrollView.frame = self.contentView.bounds;
    
    __weak QDImageViewController *weakSelf = self;
    QMUIModalPresentationViewController *modalPresentationViewController = [[QMUIModalPresentationViewController alloc] init];
    modalPresentationViewController.maximumContentViewWidth = CGFLOAT_MAX;
    modalPresentationViewController.contentView = self.contentView;
    modalPresentationViewController.didHideByDimmingViewTappedBlock = ^{
        for (UIView *subview in weakSelf.contentScrollView.subviews) {
            if (subview != weakSelf.methodNameLabel) {
                [subview removeFromSuperview];
            }
        }
    };
    [modalPresentationViewController showWithAnimated:YES completion:nil];
    
    [self.tableView clearsSelection];
}

- (CGFloat)contentViewLimitWidth {
    return CGRectGetWidth(self.contentScrollView.bounds) - UIEdgeInsetsGetHorizontalValue(self.contentScrollView.contentInset);
}

- (CGFloat)contentViewLayoutStartingMinY {
    return CGRectGetMaxY(self.methodNameLabel.frame) + 16;
}

#pragma mark - Example

- (CGFloat)generateExampleViewForAverageColor {
    CGFloat contentWidth = [self contentViewLimitWidth];
    CGFloat minY = [self contentViewLayoutStartingMinY];
    
    UILabel *originImageLabel = [[UILabel alloc] initWithFont:UIFontMake(14) textColor:UIColorBlack];
    originImageLabel.text = @"处理前的原图";
    [originImageLabel sizeToFit];
    originImageLabel.frame = CGRectSetY(originImageLabel.frame, minY);
    [self.contentScrollView addSubview:originImageLabel];
    minY = CGRectGetMaxY(originImageLabel.frame) + 6;
    
    UIImageView *originImageView = [[UIImageView alloc] initWithImage:UIImageMake(@"image0")];
    originImageView.contentMode = UIViewContentModeScaleAspectFit;
    originImageView.frame = CGRectMake(0, minY, contentWidth, flatf(contentWidth * originImageView.image.size.height / originImageView.image.size.width));
    [self.contentScrollView addSubview:originImageView];
    minY = CGRectGetMaxY(originImageView.frame) + 16;
    
    UIColor *averageColor = [originImageView.image averageColor];
    
    UILabel *afterLabel = [[UILabel alloc] init];
    [afterLabel setTheSameAppearanceAsLabel:originImageLabel];
    afterLabel.text = [NSString stringWithFormat:@"计算出的平均色：RGB(%d, %d, %d)", (int)(averageColor.red * 255), (int)(averageColor.green * 255), (int)(averageColor.blue * 255)];
    [afterLabel sizeToFit];
    afterLabel.frame = CGRectSetY(afterLabel.frame, minY);
    [self.contentScrollView addSubview:afterLabel];
    minY = CGRectGetMaxY(afterLabel.frame) + 6;
    
    UIView *averageColorView = [[UIView alloc] initWithFrame:CGRectMake(0, minY, contentWidth, 100)];
    averageColorView.backgroundColor = [originImageView.image averageColor];
    [self.contentScrollView addSubview:averageColorView];
    minY = CGRectGetMaxY(averageColorView.frame);
    
    return minY;
}

- (CGFloat)generateExampleViewForGrayImage {
    CGFloat contentWidth = [self contentViewLimitWidth];
    CGFloat minY = [self contentViewLayoutStartingMinY];
    
    UILabel *originImageLabel = [[UILabel alloc] initWithFont:UIFontMake(14) textColor:UIColorBlack];
    originImageLabel.text = @"处理前的原图";
    [originImageLabel sizeToFit];
    originImageLabel.frame = CGRectSetY(originImageLabel.frame, minY);
    [self.contentScrollView addSubview:originImageLabel];
    minY = CGRectGetMaxY(originImageLabel.frame) + 6;
    
    UIImageView *originImageView = [[UIImageView alloc] initWithImage:UIImageMake(@"image0")];
    originImageView.contentMode = UIViewContentModeScaleAspectFit;
    [originImageView sizeToFitKeepingImageAspectRatioInSize:CGSizeMake(contentWidth, CGFLOAT_MAX)];
    originImageView.frame = CGRectSetY(originImageView.frame, minY);
    [self.contentScrollView addSubview:originImageView];
    minY = CGRectGetMaxY(originImageView.frame) + 16;
    
    UILabel *afterLabel = [[UILabel alloc] init];
    [afterLabel setTheSameAppearanceAsLabel:originImageLabel];
    afterLabel.text = @"置灰后的图片";
    [afterLabel sizeToFit];
    afterLabel.frame = CGRectSetY(afterLabel.frame, minY);
    [self.contentScrollView addSubview:afterLabel];
    minY = CGRectGetMaxY(afterLabel.frame) + 6;
    
    UIImageView *afterImageView = [[UIImageView alloc] initWithFrame:CGRectSetY(originImageView.frame, minY)];
    afterImageView.contentMode = originImageView.contentMode;
    afterImageView.image = [originImageView.image grayImage];
    [self.contentScrollView addSubview:afterImageView];
    minY = CGRectGetMaxY(afterImageView.frame);
    
    return minY;
}

- (CGFloat)generateExampleViewForImageWithAlpha {
    CGFloat contentWidth = [self contentViewLimitWidth];
    CGFloat minY = [self contentViewLayoutStartingMinY];
    
    UILabel *originImageLabel = [[UILabel alloc] initWithFont:UIFontMake(14) textColor:UIColorBlack];
    originImageLabel.text = @"处理前的原图";
    [originImageLabel sizeToFit];
    originImageLabel.frame = CGRectSetY(originImageLabel.frame, minY);
    [self.contentScrollView addSubview:originImageLabel];
    minY = CGRectGetMaxY(originImageLabel.frame) + 6;
    
    UIImageView *originImageView = [[UIImageView alloc] initWithImage:UIImageMake(@"image0")];
    originImageView.contentMode = UIViewContentModeScaleAspectFit;
    [originImageView sizeToFitKeepingImageAspectRatioInSize:CGSizeMake(contentWidth, CGFLOAT_MAX)];
    originImageView.frame = CGRectSetY(originImageView.frame, minY);
    [self.contentScrollView addSubview:originImageView];
    minY = CGRectGetMaxY(originImageView.frame) + 16;
    
    UILabel *afterLabel = [[UILabel alloc] init];
    [afterLabel setTheSameAppearanceAsLabel:originImageLabel];
    afterLabel.text = @"叠加0.5的apha之后";
    [afterLabel sizeToFit];
    afterLabel.frame = CGRectSetY(afterLabel.frame, minY);
    [self.contentScrollView addSubview:afterLabel];
    minY = CGRectGetMaxY(afterLabel.frame) + 6;
    
    UIImage *imageAddedAlpha = [originImageView.image imageWithAlpha:.5];
    CGSize imageViewSize = CGSizeMake(CGRectGetWidth(originImageView.frame) - 20, 0);
    imageViewSize.height = flatf(imageViewSize.width * CGRectGetHeight(originImageView.frame) / CGRectGetWidth(originImageView.frame));
    
    UIImageView *afterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, minY, imageViewSize.width, imageViewSize.height)];
    afterImageView.contentMode = originImageView.contentMode;
    afterImageView.image = imageAddedAlpha;
    [self.contentScrollView addSubview:afterImageView];
    
    UIImageView *afterImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMinY(afterImageView.frame) + 20, imageViewSize.width, imageViewSize.height)];
    afterImageView2.contentMode = afterImageView.contentMode;
    afterImageView2.image = imageAddedAlpha;
    [self.contentScrollView addSubview:afterImageView2];
    
    minY = CGRectGetMaxY(afterImageView2.frame);
    
    return minY;
}

- (CGFloat)generateExampleViewForImageWithTintColor {
    CGFloat minY = [self contentViewLayoutStartingMinY];
    
    UILabel *originImageLabel = [[UILabel alloc] initWithFont:UIFontMake(14) textColor:UIColorBlack];
    originImageLabel.text = @"处理前的原图";
    [originImageLabel sizeToFit];
    originImageLabel.frame = CGRectSetY(originImageLabel.frame, minY);
    [self.contentScrollView addSubview:originImageLabel];
    minY = CGRectGetMaxY(originImageLabel.frame) + 6;
    
    UIImageView *originImageView = [[UIImageView alloc] initWithImage:UIImageMake(@"icon_emotion")];
    originImageView.contentMode = UIViewContentModeScaleAspectFit;
    originImageView.frame = CGRectSetY(originImageView.frame, minY);
    [self.contentScrollView addSubview:originImageView];
    minY = CGRectGetMaxY(originImageView.frame) + 16;
    
    UILabel *afterLabel = [[UILabel alloc] init];
    [afterLabel setTheSameAppearanceAsLabel:originImageLabel];
    afterLabel.text = @"将图片换个颜色";
    [afterLabel sizeToFit];
    afterLabel.frame = CGRectSetY(afterLabel.frame, minY);
    [self.contentScrollView addSubview:afterLabel];
    minY = CGRectGetMaxY(afterLabel.frame) + 6;
    
    UIImage *afterImage = [originImageView.image imageWithTintColor:[QDCommonUI randomThemeColor]];
    UIImageView *afterImageView = [[UIImageView alloc] initWithImage:afterImage];
    afterImageView.contentMode = originImageView.contentMode;
    afterImageView.frame = CGRectSetY(afterImageView.frame, minY);
    [self.contentScrollView addSubview:afterImageView];
    minY = CGRectGetMaxY(afterImageView.frame);
    
    return minY;
}

- (CGFloat)generateExampleViewForImageWithImageAbove {
    CGFloat minY = [self contentViewLayoutStartingMinY];

    UILabel *originImageLabel = [[UILabel alloc] initWithFont:UIFontMake(14) textColor:UIColorBlack];
    originImageLabel.text = @"处理前的原图";
    [originImageLabel sizeToFit];
    originImageLabel.frame = CGRectSetY(originImageLabel.frame, minY);
    [self.contentScrollView addSubview:originImageLabel];
    minY = CGRectGetMaxY(originImageLabel.frame) + 6;
    
    UIImageView *originImageView = [[UIImageView alloc] initWithImage:[UIImageMake(@"icon_emotion") imageWithTintColor:UIColorBlue]];
    originImageView.contentMode = UIViewContentModeScaleAspectFit;
    originImageView.frame = CGRectSetY(originImageView.frame, minY);
    [self.contentScrollView addSubview:originImageView];
    minY = CGRectGetMaxY(originImageView.frame) + 16;
    
    UILabel *afterLabel = [[UILabel alloc] init];
    [afterLabel setTheSameAppearanceAsLabel:originImageLabel];
    afterLabel.text = @"在图片上叠加一张未读红点的图片";
    [afterLabel sizeToFit];
    afterLabel.frame = CGRectSetY(afterLabel.frame, minY);
    [self.contentScrollView addSubview:afterLabel];
    minY = CGRectGetMaxY(afterLabel.frame) + 6;
    
    UIImage *redDotImage = [UIImage imageWithColor:UIColorRed size:CGSizeMake(6, 6) cornerRadius:6.0 / 2.0];
    UIImage *afterImage = [originImageView.image imageWithImageAbove:redDotImage atPoint:CGPointMake(originImageView.image.size.width - redDotImage.size.width - 1, 1)];
    UIImageView *afterImageView = [[UIImageView alloc] initWithImage:afterImage];
    afterImageView.contentMode = originImageView.contentMode;
    afterImageView.frame = CGRectSetY(afterImageView.frame, minY);
    [self.contentScrollView addSubview:afterImageView];
    minY = CGRectGetMaxY(afterImageView.frame);
    
    return minY;
}

- (CGFloat)generateExampleViewForImageWithSpacingExtensionInsets {
    CGFloat minY = [self contentViewLayoutStartingMinY];

    UILabel *originImageLabel = [[UILabel alloc] initWithFont:UIFontMake(14) textColor:UIColorBlack];
    originImageLabel.text = @"处理前的原图（UIImageView带边框）";
    [originImageLabel sizeToFit];
    originImageLabel.frame = CGRectSetY(originImageLabel.frame, minY);
    [self.contentScrollView addSubview:originImageLabel];
    minY = CGRectGetMaxY(originImageLabel.frame) + 6;
    
    UIImageView *originImageView = [[UIImageView alloc] initWithImage:UIImageMake(@"icon_emotion")];
    originImageView.layer.borderWidth = PixelOne;
    originImageView.layer.borderColor = [QDCommonUI randomThemeColor].CGColor;
    originImageView.frame = CGRectSetY(originImageView.frame, minY);
    [self.contentScrollView addSubview:originImageView];
    minY = CGRectGetMaxY(originImageView.frame) + 16;
    
    UILabel *afterLabel = [[UILabel alloc] init];
    [afterLabel setTheSameAppearanceAsLabel:originImageLabel];
    afterLabel.text = @"在图片右边加了padding之后";
    [afterLabel sizeToFit];
    afterLabel.frame = CGRectSetY(afterLabel.frame, minY);
    [self.contentScrollView addSubview:afterLabel];
    minY = CGRectGetMaxY(afterLabel.frame) + 6;
    
    UIImage *afterImage = [originImageView.image imageWithSpacingExtensionInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    UIImageView *afterImageView = [[UIImageView alloc] initWithImage:afterImage];
    afterImageView.layer.borderWidth = originImageView.layer.borderWidth;
    afterImageView.layer.borderColor = originImageView.layer.borderColor;
    afterImageView.frame = CGRectSetY(afterImageView.frame, minY);
    [self.contentScrollView addSubview:afterImageView];
    minY = CGRectGetMaxY(afterImageView.frame);
    
    return minY;
}

- (CGFloat)generateExampleViewForImageWithClippedRect {
    CGFloat contentWidth = [self contentViewLimitWidth];
    CGFloat minY = [self contentViewLayoutStartingMinY];

    UILabel *originImageLabel = [[UILabel alloc] initWithFont:UIFontMake(14) textColor:UIColorBlack];
    originImageLabel.text = @"处理前的原图";
    [originImageLabel sizeToFit];
    originImageLabel.frame = CGRectSetY(originImageLabel.frame, minY);
    [self.contentScrollView addSubview:originImageLabel];
    minY = CGRectGetMaxY(originImageLabel.frame) + 6;
    
    UIImageView *originImageView = [[UIImageView alloc] initWithImage:UIImageMake(@"image0")];
    originImageView.contentMode = UIViewContentModeScaleAspectFit;
    [originImageView sizeToFitKeepingImageAspectRatioInSize:CGSizeMake(contentWidth, CGFLOAT_MAX)];
    originImageView.frame = CGRectSetY(originImageView.frame, minY);
    originImageView.clipsToBounds = YES;
    [self.contentScrollView addSubview:originImageView];
    minY = CGRectGetMaxY(originImageView.frame) + 16;
    
    UILabel *afterLabel = [[UILabel alloc] init];
    [afterLabel setTheSameAppearanceAsLabel:originImageLabel];
    afterLabel.text = @"裁剪出中间的区域";
    [afterLabel sizeToFit];
    afterLabel.frame = CGRectSetY(afterLabel.frame, minY);
    [self.contentScrollView addSubview:afterLabel];
    minY = CGRectGetMaxY(afterLabel.frame) + 6;
    
    UIImage *afterImage = [originImageView.image imageWithClippedRect:CGRectMake(originImageView.image.size.width / 4, originImageView.image.size.height / 4, originImageView.image.size.width / 2, originImageView.image.size.height / 2)];
    UIImageView *afterImageView = [[UIImageView alloc] initWithImage:afterImage];
    afterImageView.contentMode = originImageView.contentMode;
    afterImageView.frame = CGRectSetY(afterImageView.frame, minY);
    [self.contentScrollView addSubview:afterImageView];
    minY = CGRectGetMaxY(afterImageView.frame);
    
    return minY;
}

- (CGFloat)generateExampleViewForImageWithScaleToSize {
    CGFloat contentWidth = [self contentViewLimitWidth];
    CGFloat minY = [self contentViewLayoutStartingMinY];

    UILabel *originImageLabel = [[UILabel alloc] initWithFont:UIFontMake(14) textColor:UIColorBlack];
    originImageLabel.text = @"处理前的原图";
    [originImageLabel sizeToFit];
    originImageLabel.frame = CGRectSetY(originImageLabel.frame, minY);
    [self.contentScrollView addSubview:originImageLabel];
    minY = CGRectGetMaxY(originImageLabel.frame) + 6;
    
    UIImageView *originImageView = [[UIImageView alloc] initWithImage:UIImageMake(@"image0")];
    originImageView.contentMode = UIViewContentModeScaleAspectFit;
    [originImageView sizeToFitKeepingImageAspectRatioInSize:CGSizeMake(contentWidth, CGFLOAT_MAX)];
    originImageView.frame = CGRectSetY(originImageView.frame, minY);
    originImageView.clipsToBounds = YES;
    [self.contentScrollView addSubview:originImageView];
    minY = CGRectGetMaxY(originImageView.frame) + 16;
    
    UILabel *afterLabel = [[UILabel alloc] init];
    [afterLabel setTheSameAppearanceAsLabel:originImageLabel];
    afterLabel.text = @"缩小之后的图";
    [afterLabel sizeToFit];
    afterLabel.frame = CGRectSetY(afterLabel.frame, minY);
    [self.contentScrollView addSubview:afterLabel];
    minY = CGRectGetMaxY(afterLabel.frame) + 6;
    
    UIImage *afterImage = [originImageView.image imageWithScaleToSize:CGSizeMake(80, 80) contentMode:UIViewContentModeScaleAspectFit];
    UIImageView *afterImageView = [[UIImageView alloc] initWithImage:afterImage];
    afterImageView.contentMode = originImageView.contentMode;
    afterImageView.frame = CGRectSetY(afterImageView.frame, minY);
    [self.contentScrollView addSubview:afterImageView];
    minY = CGRectGetMaxY(afterImageView.frame);
    
    return minY;
}

- (CGFloat)generateExampleViewForImageWithDirection {
    CGFloat minY = [self contentViewLayoutStartingMinY];

    UILabel *originImageLabel = [[UILabel alloc] initWithFont:UIFontMake(14) textColor:UIColorBlack];
    originImageLabel.text = @"处理前的原图";
    [originImageLabel sizeToFit];
    originImageLabel.frame = CGRectSetY(originImageLabel.frame, minY);
    [self.contentScrollView addSubview:originImageLabel];
    minY = CGRectGetMaxY(originImageLabel.frame) + 6;
    
    UIImageView *originImageView = [[UIImageView alloc] initWithImage:UIImageMake(@"icon_emotion")];
    originImageView.contentMode = UIViewContentModeCenter;
    originImageView.frame = CGRectSetY(originImageView.frame, minY);
    originImageView.clipsToBounds = YES;
    [self.contentScrollView addSubview:originImageView];
    minY = CGRectGetMaxY(originImageView.frame) + 16;
    
    UILabel *afterLabel = [[UILabel alloc] init];
    [afterLabel setTheSameAppearanceAsLabel:originImageLabel];
    afterLabel.text = @"吓得我旋转了360°图";
    [afterLabel sizeToFit];
    afterLabel.frame = CGRectSetY(afterLabel.frame, minY);
    [self.contentScrollView addSubview:afterLabel];
    minY = CGRectGetMaxY(afterLabel.frame) + 6;
    
    UIImage *rightImge = [originImageView.image imageWithOrientation:UIImageOrientationRight];
    UIImage *bottomImage = [originImageView.image imageWithOrientation:UIImageOrientationDown];
    UIImage *leftImage = [originImageView.image imageWithOrientation:UIImageOrientationLeft];
    
    UIImageView *afterImageView = [[UIImageView alloc] initWithFrame:CGRectSetY(originImageView.frame, minY)];
    afterImageView.contentMode = UIViewContentModeCenter;
    afterImageView.animationImages = @[originImageView.image, rightImge, bottomImage, leftImage];
    afterImageView.animationDuration = 2;
    [self.contentScrollView addSubview:afterImageView];
    [afterImageView startAnimating];
    minY = CGRectGetMaxY(afterImageView.frame);
    
    return minY;
}

- (CGFloat)generateExampleViewForImageWithBorder {
    CGFloat minY = [self contentViewLayoutStartingMinY];

    UILabel *originImageLabel = [[UILabel alloc] initWithFont:UIFontMake(14) textColor:UIColorBlack];
    originImageLabel.text = @"处理前的原图";
    [originImageLabel sizeToFit];
    originImageLabel.frame = CGRectSetY(originImageLabel.frame, minY);
    [self.contentScrollView addSubview:originImageLabel];
    minY = CGRectGetMaxY(originImageLabel.frame) + 6;
    
    UIImageView *originImageView = [[UIImageView alloc] initWithImage:UIImageMake(@"icon_emotion")];
    originImageView.frame = CGRectSetY(originImageView.frame, minY);
    [self.contentScrollView addSubview:originImageView];
    minY = CGRectGetMaxY(originImageView.frame) + 16;
    
    UILabel *afterLabel = [[UILabel alloc] init];
    [afterLabel setTheSameAppearanceAsLabel:originImageLabel];
    afterLabel.text = @"加了边框之后的图（边框路径要考虑像素对齐）";
    [afterLabel sizeToFit];
    afterLabel.frame = CGRectSetY(afterLabel.frame, minY);
    [self.contentScrollView addSubview:afterLabel];
    minY = CGRectGetMaxY(afterLabel.frame) + 6;
    
    CGFloat lineWidth = PixelOne;
    UIBezierPath *roundedBorderPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(CGRectMakeWithSize(originImageView.image.size), lineWidth / 2.0, lineWidth / 2.0) cornerRadius:4];
    roundedBorderPath.lineWidth = lineWidth;
    UIImage *afterImage = [originImageView.image imageWithBorderColor:[QDCommonUI randomThemeColor] path:roundedBorderPath];
    
    UIImageView *afterImageView = [[UIImageView alloc] initWithImage:afterImage];
    afterImageView.frame = CGRectSetY(afterImageView.frame, minY);
    [self.contentScrollView addSubview:afterImageView];
    minY = CGRectGetMaxY(afterImageView.frame);
    
    return minY;
}

- (CGFloat)generateExampleViewForImageWithBorderColorAndCornerRadius {
    CGFloat minY = [self contentViewLayoutStartingMinY];

    UILabel *originImageLabel = [[UILabel alloc] initWithFont:UIFontMake(14) textColor:UIColorBlack];
    originImageLabel.text = @"处理前的原图";
    [originImageLabel sizeToFit];
    originImageLabel.frame = CGRectSetY(originImageLabel.frame, minY);
    [self.contentScrollView addSubview:originImageLabel];
    minY = CGRectGetMaxY(originImageLabel.frame) + 6;
    
    UIImageView *originImageView = [[UIImageView alloc] initWithImage:UIImageMake(@"icon_emotion")];
    originImageView.frame = CGRectSetY(originImageView.frame, minY);
    [self.contentScrollView addSubview:originImageView];
    minY = CGRectGetMaxY(originImageView.frame) + 16;
    
    UILabel *afterLabel = [[UILabel alloc] init];
    [afterLabel setTheSameAppearanceAsLabel:originImageLabel];
    afterLabel.text = @"加了边框之后的图";
    [afterLabel sizeToFit];
    afterLabel.frame = CGRectSetY(afterLabel.frame, minY);
    [self.contentScrollView addSubview:afterLabel];
    minY = CGRectGetMaxY(afterLabel.frame) + 6;
    
    CGFloat dashedLengths[] = {2,4};
    UIImage *afterImage = [originImageView.image imageWithBorderColor:[QDCommonUI randomThemeColor] borderWidth:PixelOne cornerRadius:4 dashedLengths:dashedLengths];
    
    UIImageView *afterImageView = [[UIImageView alloc] initWithImage:afterImage];
    afterImageView.frame = CGRectSetY(afterImageView.frame, minY);
    [self.contentScrollView addSubview:afterImageView];
    minY = CGRectGetMaxY(afterImageView.frame);
    
    return minY;
}

- (CGFloat)generateExampleViewForImageWithBorderColorAndCornerRadiusAndPosition {
    CGFloat minY = [self contentViewLayoutStartingMinY];

    UILabel *originImageLabel = [[UILabel alloc] initWithFont:UIFontMake(14) textColor:UIColorBlack];
    originImageLabel.text = @"处理前的原图";
    [originImageLabel sizeToFit];
    originImageLabel.frame = CGRectSetY(originImageLabel.frame, minY);
    [self.contentScrollView addSubview:originImageLabel];
    minY = CGRectGetMaxY(originImageLabel.frame) + 6;
    
    UIImageView *originImageView = [[UIImageView alloc] initWithImage:UIImageMake(@"icon_emotion")];
    originImageView.frame = CGRectSetY(originImageView.frame, minY);
    [self.contentScrollView addSubview:originImageView];
    minY = CGRectGetMaxY(originImageView.frame) + 16;
    
    UILabel *afterLabel = [[UILabel alloc] init];
    [afterLabel setTheSameAppearanceAsLabel:originImageLabel];
    afterLabel.text = @"加了下边框之后的图";
    [afterLabel sizeToFit];
    afterLabel.frame = CGRectSetY(afterLabel.frame, minY);
    [self.contentScrollView addSubview:afterLabel];
    minY = CGRectGetMaxY(afterLabel.frame) + 6;
    
    UIImage *afterImage = [originImageView.image imageWithBorderColor:[QDCommonUI randomThemeColor] borderWidth:PixelOne borderPosition:QMUIImageBorderPositionBottom];
    
    UIImageView *afterImageView = [[UIImageView alloc] initWithImage:afterImage];
    afterImageView.frame = CGRectSetY(afterImageView.frame, minY);
    [self.contentScrollView addSubview:afterImageView];
    minY = CGRectGetMaxY(afterImageView.frame);
    
    return minY;
}

- (CGFloat)generateExampleViewForImageWithMaskImage {
    CGFloat contentWidth = [self contentViewLimitWidth];
    CGFloat minY = [self contentViewLayoutStartingMinY];

    UILabel *originImageLabel = [[UILabel alloc] initWithFont:UIFontMake(14) textColor:UIColorBlack];
    originImageLabel.text = @"处理前的原图";
    [originImageLabel sizeToFit];
    originImageLabel.frame = CGRectSetY(originImageLabel.frame, minY);
    [self.contentScrollView addSubview:originImageLabel];
    minY = CGRectGetMaxY(originImageLabel.frame) + 6;
    
    UIImageView *originImageView = [[UIImageView alloc] initWithImage:UIImageMake(@"image0")];
    originImageView.contentMode = UIViewContentModeScaleAspectFit;
    [originImageView sizeToFitKeepingImageAspectRatioInSize:CGSizeMake(contentWidth, CGFLOAT_MAX)];
    originImageView.frame = CGRectSetY(originImageView.frame, minY);
    originImageView.clipsToBounds = YES;
    [self.contentScrollView addSubview:originImageView];
    minY = CGRectGetMaxY(originImageView.frame) + 16;
    
    UILabel *maskImageLabel = [[UILabel alloc] initWithFont:UIFontMake(14) textColor:UIColorBlack];
    maskImageLabel.text = @"A.用来做遮罩的图片";
    [maskImageLabel sizeToFit];
    maskImageLabel.frame = CGRectSetY(maskImageLabel.frame, minY);
    [self.contentScrollView addSubview:maskImageLabel];
    minY = CGRectGetMaxY(maskImageLabel.frame) + 6;
    
    UIImageView *maskImageView = [[UIImageView alloc] initWithImage:UIImageMake(@"image1")];
    maskImageView.contentMode = UIViewContentModeScaleAspectFit;
    [maskImageView sizeToFitKeepingImageAspectRatioInSize:CGSizeMake(contentWidth, CGFLOAT_MAX)];
    maskImageView.frame = CGRectSetY(originImageView.frame, minY);
    maskImageView.clipsToBounds = YES;
    [self.contentScrollView addSubview:maskImageView];
    minY = CGRectGetMaxY(maskImageView.frame) + 16;
    
    UILabel *afterLabel = [[UILabel alloc] init];
    [afterLabel setTheSameAppearanceAsLabel:originImageLabel];
    afterLabel.text = @"A.加了遮罩后的图片";
    [afterLabel sizeToFit];
    afterLabel.frame = CGRectSetY(afterLabel.frame, minY);
    [self.contentScrollView addSubview:afterLabel];
    minY = CGRectGetMaxY(afterLabel.frame) + 6;
    
    UIImage *afterImage = [originImageView.image imageWithMaskImage:maskImageView.image usingMaskImageMode:YES];
    UIImageView *afterImageView = [[UIImageView alloc] initWithFrame:CGRectSetY(originImageView.frame, minY)];
    afterImageView.image = afterImage;
    [self.contentScrollView addSubview:afterImageView];
    minY = CGRectGetMaxY(afterImageView.frame) + 16;
    
    UILabel *maskImageLabel2 = [[UILabel alloc] initWithFont:UIFontMake(14) textColor:UIColorBlack];
    maskImageLabel2.text = @"B.用来做遮罩的图片";
    [maskImageLabel2 sizeToFit];
    maskImageLabel2.frame = CGRectSetY(maskImageLabel2.frame, minY);
    [self.contentScrollView addSubview:maskImageLabel2];
    minY = CGRectGetMaxY(maskImageLabel2.frame) + 6;
    
    UIImageView *maskImageView2 = [[UIImageView alloc] initWithImage:[UIImageMake(@"image1") grayImage]];
    maskImageView2.contentMode = UIViewContentModeScaleAspectFit;
    [maskImageView2 sizeToFitKeepingImageAspectRatioInSize:CGSizeMake(contentWidth, CGFLOAT_MAX)];
    maskImageView2.frame = CGRectSetY(maskImageView2.frame, minY);
    maskImageView2.clipsToBounds = YES;
    [self.contentScrollView addSubview:maskImageView2];
    minY = CGRectGetMaxY(maskImageView2.frame) + 16;
    
    UILabel *afterLabel2 = [[UILabel alloc] init];
    [afterLabel2 setTheSameAppearanceAsLabel:originImageLabel];
    afterLabel2.text = @"B.加了遮罩后的图片";
    [afterLabel2 sizeToFit];
    afterLabel2.frame = CGRectSetY(afterLabel2.frame, minY);
    [self.contentScrollView addSubview:afterLabel2];
    minY = CGRectGetMaxY(afterLabel2.frame) + 6;
    
    UIImage *afterImage2 = [originImageView.image imageWithMaskImage:maskImageView2.image usingMaskImageMode:NO];
    
    UIImageView *afterImageView2 = [[UIImageView alloc] initWithFrame:CGRectSetY(originImageView.frame, minY)];
    afterImageView2.image = afterImage2;
    [self.contentScrollView addSubview:afterImageView2];
    minY = CGRectGetMaxY(afterImageView2.frame);
    
    return minY;
}

- (CGFloat)generateExampleViewForImageWithColor {
    CGFloat contentWidth = [self contentViewLimitWidth];
    CGFloat minY = [self contentViewLayoutStartingMinY];

    UILabel *originImageLabel = [[UILabel alloc] initWithFont:UIFontMake(14) textColor:UIColorBlack];
    originImageLabel.text = @"生成一张圆角图片";
    [originImageLabel sizeToFit];
    originImageLabel.frame = CGRectSetY(originImageLabel.frame, minY);
    [self.contentScrollView addSubview:originImageLabel];
    minY = CGRectGetMaxY(originImageLabel.frame) + 6;
    
    UIImage *originImage = [UIImage imageWithColor:[QDCommonUI randomThemeColor] size:CGSizeMake(contentWidth / 2, 40) cornerRadius:10];
    UIImageView *originImageView = [[UIImageView alloc] initWithImage:originImage];
    originImageView.frame = CGRectSetY(originImageView.frame, minY);
    [self.contentScrollView addSubview:originImageView];
    minY = CGRectGetMaxY(originImageView.frame) + 16;
    
    return minY;
}

- (CGFloat)generateExampleViewForImageWithColorAndCornerRadiusArray {
    CGFloat contentWidth = [self contentViewLimitWidth];
    CGFloat minY = [self contentViewLayoutStartingMinY];

    UILabel *originImageLabel = [[UILabel alloc] initWithFont:UIFontMake(14) textColor:UIColorBlack];
    originImageLabel.text = @"生成一张图片，右边带圆角";
    [originImageLabel sizeToFit];
    originImageLabel.frame = CGRectSetY(originImageLabel.frame, minY);
    [self.contentScrollView addSubview:originImageLabel];
    minY = CGRectGetMaxY(originImageLabel.frame) + 6;
    
    UIImage *originImage = [UIImage imageWithColor:[QDCommonUI randomThemeColor] size:CGSizeMake(contentWidth / 2, 40) cornerRadiusArray:@[@0, @0, @10, @10]];
    UIImageView *originImageView = [[UIImageView alloc] initWithImage:originImage];
    originImageView.frame = CGRectSetY(originImageView.frame, minY);
    [self.contentScrollView addSubview:originImageView];
    minY = CGRectGetMaxY(originImageView.frame) + 16;
    
    return minY;
}

- (CGFloat)generateExampleViewForImageWithStrokeColorAndPath {
    CGFloat contentWidth = [self contentViewLimitWidth];
    CGFloat minY = [self contentViewLayoutStartingMinY];

    UILabel *originImageLabel = [[UILabel alloc] initWithFont:UIFontMake(14) textColor:UIColorBlack];
    originImageLabel.text = @"用椭圆路径生成一张图";
    [originImageLabel sizeToFit];
    originImageLabel.frame = CGRectSetY(originImageLabel.frame, minY);
    [self.contentScrollView addSubview:originImageLabel];
    minY = CGRectGetMaxY(originImageLabel.frame) + 6;
    
    CGFloat lineWidth = 1.0f;
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(lineWidth / 2.0, lineWidth / 2.0, contentWidth / 2 - lineWidth, 40 - lineWidth)];
    path.lineWidth = lineWidth;
    UIImage *originImage = [UIImage imageWithStrokeColor:[QDCommonUI randomThemeColor] size:CGSizeMake(contentWidth / 2, 40) path:path addClip:NO];
    UIImageView *originImageView = [[UIImageView alloc] initWithImage:originImage];
    originImageView.frame = CGRectSetY(originImageView.frame, minY);
    [self.contentScrollView addSubview:originImageView];
    minY = CGRectGetMaxY(originImageView.frame) + 16;
    
    return minY;
}

- (CGFloat)generateExampleViewForImageWithStrokeColorAndCornerRadius {
    CGFloat contentWidth = [self contentViewLimitWidth];
    CGFloat minY = [self contentViewLayoutStartingMinY];

    UILabel *originImageLabel = [[UILabel alloc] initWithFont:UIFontMake(14) textColor:UIColorBlack];
    originImageLabel.text = @"在给定的大小里绘制一条带圆角的路径";
    [originImageLabel sizeToFit];
    originImageLabel.frame = CGRectSetY(originImageLabel.frame, minY);
    [self.contentScrollView addSubview:originImageLabel];
    minY = CGRectGetMaxY(originImageLabel.frame) + 6;
    
    UIImage *originImage = [UIImage imageWithStrokeColor:[QDCommonUI randomThemeColor] size:CGSizeMake(contentWidth / 2, 40) lineWidth:1 cornerRadius:10];
    UIImageView *originImageView = [[UIImageView alloc] initWithImage:originImage];
    originImageView.frame = CGRectSetY(originImageView.frame, minY);
    [self.contentScrollView addSubview:originImageView];
    minY = CGRectGetMaxY(originImageView.frame) + 16;
    
    return minY;
}

- (CGFloat)generateExampleViewForImageWithStrokeColorAndBorderPosition {
    CGFloat contentWidth = [self contentViewLimitWidth];
    CGFloat minY = [self contentViewLayoutStartingMinY];

    UILabel *originImageLabel = [[UILabel alloc] initWithFont:UIFontMake(14) textColor:UIColorBlack];
    originImageLabel.text = @"在左、下、右绘制一条边框";
    [originImageLabel sizeToFit];
    originImageLabel.frame = CGRectSetY(originImageLabel.frame, minY);
    [self.contentScrollView addSubview:originImageLabel];
    minY = CGRectGetMaxY(originImageLabel.frame) + 6;
    
    UIImage *originImage = [UIImage imageWithStrokeColor:[QDCommonUI randomThemeColor] size:CGSizeMake(contentWidth / 2, 40) lineWidth:1 borderPosition:QMUIImageBorderPositionLeft|QMUIImageBorderPositionRight|QMUIImageBorderPositionBottom];
    UIImageView *originImageView = [[UIImageView alloc] initWithImage:originImage];
    originImageView.frame = CGRectSetY(originImageView.frame, minY);
    [self.contentScrollView addSubview:originImageView];
    minY = CGRectGetMaxY(originImageView.frame) + 16;
    
    return minY;
}

- (CGFloat)generateExampleViewForImageWithShape {
    CGFloat contentWidth = [self contentViewLimitWidth];
    CGFloat minY = [self contentViewLayoutStartingMinY];

    UILabel *titleLabel = [[UILabel alloc] initWithFont:UIFontMake(14) textColor:UIColorBlack];
    titleLabel.text = @"生成预设的形状图片";
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectSetY(titleLabel.frame, minY);
    [self.contentScrollView addSubview:titleLabel];
    minY = CGRectGetMaxY(titleLabel.frame) + 6;
    
    UIImage *ovalImage = [UIImage imageWithShape:QMUIImageShapeOval size:CGSizeMake(contentWidth / 4, 20) tintColor:UIColorBlue];
    UIImage *triangleImage = [UIImage imageWithShape:QMUIImageShapeTriangle size:CGSizeMake(6, 6) tintColor:UIColorBlue];
    UIImage *disclosureIndicatorImage = [UIImage imageWithShape:QMUIImageShapeDisclosureIndicator size:CGSizeMake(8, 13) tintColor:UIColorBlue];
    UIImage *checkmarkImage = [UIImage imageWithShape:QMUIImageShapeCheckmark size:CGSizeMake(15, 12) tintColor:UIColorBlue];
    UIImage *navBackImage = [UIImage imageWithShape:QMUIImageShapeNavBack size:CGSizeMake(12, 20) tintColor:UIColorBlue];
    UIImage *navCloseImage = [UIImage imageWithShape:QMUIImageShapeNavClose size:CGSizeMake(16, 16) tintColor:UIColorBlue];
    
    minY = [self generateExampleLabelAndImageViewWithImage:ovalImage shapeName:@"QMUIImageShapeOval" minY:minY];
    minY = [self generateExampleLabelAndImageViewWithImage:triangleImage shapeName:@"QMUIImageShapeTriangle" minY:minY];
    minY = [self generateExampleLabelAndImageViewWithImage:disclosureIndicatorImage shapeName:@"QMUIImageShapeDisclosureIndicator" minY:minY];
    minY = [self generateExampleLabelAndImageViewWithImage:checkmarkImage shapeName:@"QMUIImageShapeCheckmark" minY:minY];
    minY = [self generateExampleLabelAndImageViewWithImage:navBackImage shapeName:@"QMUIImageShapeNavBack" minY:minY];
    minY = [self generateExampleLabelAndImageViewWithImage:navCloseImage shapeName:@"QMUIImageShapeNavClose" minY:minY];
    
    return minY;
}

- (CGFloat)generateExampleLabelAndImageViewWithImage:(UIImage *)image shapeName:(NSString *)shapeName minY:(CGFloat)minY {
    UILabel *exampleLabel = [[UILabel alloc] initWithFont:UIFontMake(12) textColor:UIColorGrayDarken];
    exampleLabel.text = shapeName;
    [exampleLabel sizeToFit];
    exampleLabel.frame = CGRectSetY(exampleLabel.frame, minY);
    [self.contentScrollView addSubview:exampleLabel];
    minY = CGRectGetMaxY(exampleLabel.frame) + 6;
    
    UIImageView *exampleImageView = [[UIImageView alloc] initWithImage:image];
    [self.contentScrollView addSubview:exampleImageView];
    exampleImageView.frame = CGRectSetY(exampleImageView.frame, minY);
    minY = CGRectGetMaxY(exampleImageView.frame) + 16;
    return minY;
}

- (CGFloat)generateExampleViewForImageWithAttributedString {
    CGFloat minY = [self contentViewLayoutStartingMinY];

    UILabel *originImageLabel = [[UILabel alloc] initWithFont:UIFontMake(14) textColor:UIColorBlack];
    originImageLabel.text = @"将NSAttributedString生成为一张图";
    [originImageLabel sizeToFit];
    originImageLabel.frame = CGRectSetY(originImageLabel.frame, minY);
    [self.contentScrollView addSubview:originImageLabel];
    minY = CGRectGetMaxY(originImageLabel.frame) + 16;
    
    NSDictionary *attributes = @{NSFontAttributeName: UIFontMake(16), NSForegroundColorAttributeName: [QDCommonUI randomThemeColor]};
    NSAttributedString *attributedString1 = [[NSAttributedString alloc] initWithString:@"这是UILabel的显示效果" attributes:attributes];
    NSAttributedString *attributedString2 = [[NSAttributedString alloc] initWithString:@"这是UIImage的显示效果" attributes:attributes];
    
    UILabel *exampleLabel = [[UILabel alloc] init];
    exampleLabel.attributedText = attributedString1;
    [exampleLabel sizeToFit];
    exampleLabel.frame = CGRectSetY(exampleLabel.frame, minY);
    [self.contentScrollView addSubview:exampleLabel];
    minY = CGRectGetMaxY(exampleLabel.frame) + 16;
    
    UIImage *exampleImage = [UIImage imageWithAttributedString:attributedString2];
    UIImageView *exampleImageView = [[UIImageView alloc] initWithImage:exampleImage];
    exampleImageView.frame = CGRectSetY(exampleImageView.frame, minY);
    exampleImageView.backgroundColor = UIColorTestRed;
    [self.contentScrollView addSubview:exampleImageView];
    minY = CGRectGetMaxY(exampleImageView.frame) + 16;
    
    return minY;
}

- (CGFloat)generateExampleViewForImageWithView {
    CGFloat contentWidth = [self contentViewLimitWidth];
    CGFloat minY = [self contentViewLayoutStartingMinY];
    
    UILabel *originImageLabel = [[UILabel alloc] initWithFont:UIFontMake(14) textColor:UIColorBlack];
    originImageLabel.text = @"将当前UINavigationController.view截图";
    [originImageLabel sizeToFit];
    originImageLabel.frame = CGRectSetY(originImageLabel.frame, minY);
    [self.contentScrollView addSubview:originImageLabel];
    minY = CGRectGetMaxY(originImageLabel.frame) + 6;
    
    UIImage *originImage = [UIImage imageWithView:self.navigationController.view];
    UIImageView *originImageView = [[UIImageView alloc] initWithImage:originImage];
    originImageView.contentMode = UIViewContentModeScaleAspectFit;
    originImageView.layer.borderWidth = PixelOne;
    originImageView.layer.borderColor = UIColorGrayLighten.CGColor;
    [originImageView sizeToFitKeepingImageAspectRatioInSize:CGSizeMake(contentWidth, CGFLOAT_MAX)];
    originImageView.frame = CGRectSetY(originImageView.frame, minY);
    [self.contentScrollView addSubview:originImageView];
    minY = CGRectGetMaxY(originImageView.frame) + 16;
    
    return minY;
}

@end
