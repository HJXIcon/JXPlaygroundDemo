

#import "PersonDetailViewController.h"
#import "UIImage+Image.h"

#define oriOffsetY -244

#define oriH 200

@interface PersonDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightconst;

@end

@implementation PersonDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    //在导航控制器下的scollView,会默认有一个向下的滚动区域,64
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //让导航条隐藏
    //self.navigationController.navigationBar.hidden = YES;
    //导航条以及自己添加子控件是没有办法设置透明度.
    //self.navigationController.navigationBar.alpha = 0;
    
    //设置导航条背景图片,(设置背景图片必须得是UIBarMetricsDefault)
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBar64"] forBarMetrics:UIBarMetricsDefault];
    
    //设置一张空的图片
    //如果没有指定图片(nil),会自动设置一张半透明图片
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    
    //设置tableView偏移量
    self.tableView.contentInset = UIEdgeInsetsMake(244, 0, 0, 0);
    

    //设置数据源,代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    UILabel *titleL = [[UILabel alloc] init];
    titleL.text = @"个人详情页";
    [titleL sizeToFit];
    titleL.alpha = 0;
    titleL.textColor = [UIColor colorWithWhite:0 alpha:0];
    
    self.navigationItem.titleView = titleL;
    
    
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%s",__func__);
    
    //NSLog(@"%f",scrollView.contentOffset.y);
    //移动的偏移量
    CGFloat offset = scrollView.contentOffset.y - oriOffsetY;
    NSLog(@"%f",offset);
    CGFloat h = oriH - offset;
    NSLog(@"h=======%f",h);
    if (h <= 64 ) {
        h  = 64;
    }
    self.heightconst.constant = h;
    
    //最大值.
    CGFloat alpha = offset * 1 / 136.0;
    if (alpha >= 1) {
        alpha = 0.99;
    }
    
    UILabel *titlL = (UILabel *)self.navigationItem.titleView;
    titlL.textColor = [UIColor colorWithWhite:0 alpha:alpha];
    
    UIColor *color = [UIColor colorWithWhite:1 alpha:alpha];
    //根据颜色生成一张图片
    UIImage *image = [UIImage imageWithColor:color];
    //要设置导航条的背景图片
    //如果没有指定图片(nil),会自动设置一张半透明图片
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"个人信息 index == %ld",indexPath.row];
    
    return cell;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
