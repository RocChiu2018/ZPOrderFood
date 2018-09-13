//
//  ViewController.m
//  点餐系统
//
//  Created by apple on 16/6/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSArray *foods;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *fruitLabel;  //水果
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;  //主食
@property (weak, nonatomic) IBOutlet UILabel *drinkLabel;  //饮料

@end

@implementation ViewController

#pragma mark ————— 懒加载 —————
-(NSArray *)foods
{
    if (_foods == nil)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"foods" ofType:@"plist"];
        
        _foods = [NSArray arrayWithContentsOfFile:path];
    }
    
    return _foods;
}

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /**
     在程序刚开始运行，用户还没有拨动UIPickerView控件的时候，就要给UILabel控件填充默认的文字。
     */
    for (int i = 0; i<self.foods.count; i++)
    {
        [self pickerView:nil didSelectRow:0 inComponent:i];
    }
}

#pragma mark ————— 点击“随机”按钮 —————
- (IBAction)random:(id)sender
{
    for (int i = 0; i < self.foods.count; i++)
    {
        //每一列里面的总数
        NSInteger count = [[self.foods objectAtIndex:i] count];
        
        //获取随机数
        int random = arc4random_uniform((u_int32_t)count);
        
        /**
         调用UIPickerView控件的选择方法；
         这个方法不会主动调用代理协议里面的pickerView:didSelectRow:inComponent:方法。
         */
        [self.pickerView selectRow:random inComponent:i animated:YES];
        
        /**
         主动调用代理协议里面的pickerView:didSelectRow:inComponent:方法给UILabel控件赋值。
         */
        [self pickerView:nil didSelectRow:random inComponent:i];
    }
}

#pragma mark ————— UIPickerViewDataSource —————
/**
 设置UIPickerView控件的列数
 */
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.foods.count;
}

/**
 设置UIPickerView控件每列有几行
 */
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[self.foods objectAtIndex:component] count];
}

#pragma mark ————— UIPickerViewDelegate —————
/**
 设置UIPickerView控件的每行显示什么文字
 */
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = [[self.foods objectAtIndex:component] objectAtIndex:row];
    
    return title;
}

/**
 用来修饰UIPickerView控件的每行文字，把每行文字修饰成富文本的样式。
 */
-(NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = [[self.foods objectAtIndex:component] objectAtIndex:row];
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:title];
    NSRange range = [title rangeOfString:title];
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];

    return mutableAttributedString;
}

/**
 UIPickerView控件的每行不仅可以显示文字，还可以显示视图，用如下的方法来定制每行所要显示的视图；
 当代码中既有titleForRow:方法又有viewForRow:方法，则每行优先显示视图，而不会显示文字，但两个方法都会被调用。
 */
//-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    UIView *rowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
//    rowView.backgroundColor = [UIColor redColor];
//
//    return rowView;
//}

/**
 设置UIPickerView控件每行的高度。
 */
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 45;
}

/**
 当用户主动拖动UIPickerView控件的时候会调用这个方法。
 */
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            //设置水果
            self.fruitLabel.text = [[self.foods objectAtIndex:component] objectAtIndex:row];
            break;
        case 1:
            //设置主食
            self.mainLabel.text = [[self.foods objectAtIndex:component] objectAtIndex:row];
            break;
            
        case 2:
            //设置饮料
            self.drinkLabel.text = [[self.foods objectAtIndex:component] objectAtIndex:row];
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
