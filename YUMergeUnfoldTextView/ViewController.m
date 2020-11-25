//
//  ViewController.m
//  YUMergeUnfoldTextView
//
//  Created by 捋忆 on 2020/11/19.
//

#import "ViewController.h"
#import "YUMergeUnfoldTextView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet YUMergeUnfoldTextView *text_view;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    self.text_view.backgroundColor = [UIColor yellowColor];
    
    NSString *str = @"“户藏烟浦，家具画船。”唯吴兴为然。春游之盛，西湖未能过也。己酉岁，予与萧时父载酒南郭，感遇成歌。双桨来时，有人似、旧曲桃根桃叶。歌扇轻约飞花，蛾眉正奇绝。春渐远、汀洲自绿，更添了几声啼鴂。十里扬州 ，三生杜牧，前事休说。又还是、宫烛分烟，奈愁里、匆匆换时节。都把一襟芳思，与空阶榆荚。千万缕、藏鸦细柳，为玉尊、起舞回雪。想见西出阳关，故人初别。";
    NSAttributedString *atts = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    self.text_view.attributedText = atts;
    
    
    NSAttributedString *unfold_atts = [[NSAttributedString alloc] initWithString:@"... 展开" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor redColor]}];
    self.text_view.unfoldAttributedText = unfold_atts;
    
    NSAttributedString *merge_atts = [[NSAttributedString alloc] initWithString:@" 收起 " attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor redColor]}];
    self.text_view.mergeAttributedText = merge_atts;
    
    
    self.text_view.max_height = 800;
    
}


@end
