//
//  YUMergeUnfoldTextView.m
//  YUMergeUnfoldTextView
//
//  Created by 捋忆 on 2020/11/19.
//

#import "YUMergeUnfoldTextView.h"

@interface YUMergeUnfoldTextView ()
/// 内容视图
@property (nonatomic, strong) UIView *content_view;
/// 文本显示
@property (nonatomic, strong) YYLabel *label;
/// 展开 任务类
@property (nonatomic, strong) YYTextHighlight *unfold_hl;
/// 合并 任务类
@property (nonatomic, strong) YYTextHighlight *merge_hl;
/// 当前状态
@property (nonatomic, assign) YUMergeUnfoldStatus status;
/// 高度约束
@property (nonatomic, strong) MASConstraint *height_constraint;

@end

@implementation YUMergeUnfoldTextView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _init];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)_init{
    /// 初始值
    self.mergeNumberOfLines = 2;
    [self addSubview:self.content_view];
    [self.content_view addSubview:self.label];
    self.label.numberOfLines = self.mergeNumberOfLines;
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
    }];
    [self.content_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.width.mas_equalTo(self);
        make.bottom.mas_equalTo(self.label.mas_bottom);
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.label.preferredMaxLayoutWidth = self.frame.size.width;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    [self resetHeight];
}

/// 高度重设
- (void)resetHeight{
    // 先删除高度约束
    [self.height_constraint uninstall];
    CGFloat content_height = [self.content_view systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    // 更新高度约束
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.max_height && self.status == YUMergeUnfoldUnfold && self.max_height < content_height) {
            self.height_constraint = make.height.mas_equalTo(self.max_height);
        }else{
            self.height_constraint = make.height.mas_equalTo(self.content_view.mas_height);
        }
    }];
}

/// 设置展开任务相关
- (void)setUnfoldTask{
    NSMutableAttributedString *unfold_atts = [self.unfoldAttributedText mutableCopy];
    [unfold_atts yy_setTextHighlight:self.unfold_hl range:NSMakeRange(0, unfold_atts.length)];
    YYLabel *unfold_label = [[YYLabel alloc] init];
    unfold_label.attributedText = unfold_atts;
    [unfold_label sizeToFit];
    self.label.truncationToken = [NSAttributedString yy_attachmentStringWithContent:unfold_label contentMode:UIViewContentModeCenter attachmentSize:unfold_label.frame.size alignToFont:unfold_atts.yy_font alignment:YYTextVerticalAlignmentTop];
}

/// 设置合并任务相关
- (void)setMergeTask{
    NSMutableAttributedString *merge_atts = [self.mergeAttributedText mutableCopy];
    [merge_atts yy_setTextHighlight:self.merge_hl range:NSMakeRange(0, merge_atts.length)];
    NSMutableAttributedString *atts = [self.attributedText mutableCopy];
    [atts appendAttributedString:merge_atts];
    self.attributedText = atts;
}

/// 删除合并任务相关
- (void)deleteMergeTask{
    NSMutableAttributedString *atts = [self.attributedText mutableCopy];
    NSRange range = [atts.string rangeOfString:self.mergeAttributedText.string options:NSBackwardsSearch];
    if (range.location != NSNotFound) {
        [atts deleteCharactersInRange:range];
    }
    self.attributedText = atts;
}

#pragma mark set方法
/// 添加展开更多的任务
- (void)setUnfoldAttributedText:(NSAttributedString *)unfoldAttributedText{
    if (_unfoldAttributedText == unfoldAttributedText) return;
    _unfoldAttributedText = unfoldAttributedText;
    [self setUnfoldTask];
}
/// 状态改变
- (void)setStatus:(YUMergeUnfoldStatus)status{
    if (_status == status) return;
    _status = status;
    // 设置高度
    [self resetHeight];
    if (self.stateChanged) {
        self.stateChanged(status);
    }
}

/// setMax_height
- (void)setMax_height:(CGFloat)max_height{
    if (!max_height && _max_height == max_height) return;
    _max_height = max_height;
}

/// 文本内容赋值
- (void)setAttributedText:(NSAttributedString *)attributedText{
    self.label.attributedText = attributedText;
}

#pragma mark get方法
- (NSAttributedString *)attributedText{
    return self.label.attributedText;
}

#pragma mark 懒加载
- (UIView *)content_view{
    if (!_content_view) {
        _content_view = [[UIView alloc] init];
    }
    return _content_view;
}

- (YYLabel *)label{
    if (!_label) {
        _label = [[YYLabel alloc] init];
    }
    return _label;
}

- (YYTextHighlight *)unfold_hl{
    if (!_unfold_hl) {
        _unfold_hl = [[YYTextHighlight alloc] init];
        __weak __typeof(self)weakSelf = self;
        _unfold_hl.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            // 打开行数
            weakSelf.label.numberOfLines = 0;
            // 状态改变
            weakSelf.status = YUMergeUnfoldUnfold;
            // 设置合并任务
            [weakSelf setMergeTask];
        };
    }
    return _unfold_hl;
}

- (YYTextHighlight *)merge_hl{
    if (!_merge_hl) {
        _merge_hl = [[YYTextHighlight alloc] init];
        __weak __typeof(self)weakSelf = self;
        _merge_hl.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            // 关闭行数
            weakSelf.label.numberOfLines = weakSelf.mergeNumberOfLines;
            // 状态改变
            weakSelf.status = YUMergeUnfoldMerge;
            // 删除合并任务
            [weakSelf deleteMergeTask];
        };
    }
    return _merge_hl;
}

@end
