//
//  YUMergeUnfoldTextView.h
//  YUMergeUnfoldTextView
//
//  Created by 捋忆 on 2020/11/19.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import <YYText/YYText.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(int, YUMergeUnfoldStatus){
    YUMergeUnfoldMerge,
    YUMergeUnfoldUnfold
};

@interface YUMergeUnfoldTextView : UIScrollView

/// 展开后的最大高度   默认为:0 高度无限高
@property (nonatomic, assign) CGFloat max_height;
/// 合并状态下显示的行数 默认为:2
@property (nonatomic) NSUInteger mergeNumberOfLines;
/// 文本内容
@property(nullable, nonatomic, copy) NSAttributedString *attributedText;
/// 展开功能的内容显示
@property(nullable, nonatomic, copy) NSAttributedString *unfoldAttributedText;
/// 合并功能的内容显示
@property(nullable, nonatomic, copy) NSAttributedString *mergeAttributedText;
/// 状态改变
@property (nonatomic, copy) void (^stateChanged)(YUMergeUnfoldStatus status);

@end

NS_ASSUME_NONNULL_END
