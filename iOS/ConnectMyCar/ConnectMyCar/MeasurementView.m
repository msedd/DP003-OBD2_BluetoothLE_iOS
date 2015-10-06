//
//  MeasurementView.m
//  ConnectMyCar
//
//  Created by Marko Seifert on 05.10.15.
//  Copyright (c) 2015 Developer Podcast. All rights reserved.
//

#import "MeasurementView.h"

@implementation MeasurementView


- (void)_drawSpeed:(NSString*) value {
    
    CGSize size = [value sizeWithAttributes:
                   @{NSFontAttributeName: [UIFont systemFontOfSize:52.0f]}];
    
    // Values are fractional -- you should take the ceilf to get equivalent values
    CGSize adjustedSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    
    [self _drawText:value size:52 drawAtPoint:CGPointMake(100.f-(adjustedSize.width/2), 60.f) textColor:[UIColor whiteColor]];
}
- (void)_drawLable:(NSString*) lable {
    
    [self _drawText:lable size:32 drawAtPoint:CGPointMake(70.f, 150.f) textColor:[UIColor grayColor]];
}

- (void)_drawText:(NSString*) text size:(CGFloat)fontSize drawAtPoint:(CGPoint)point textColor:(UIColor*)color{
    UIFont* font = [UIFont fontWithName:@"Arial" size:fontSize];
    
    NSDictionary* stringAttrs = @{
                                  NSFontAttributeName : font,
                                  NSForegroundColorAttributeName : color };
    

    NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:text attributes:stringAttrs];
    
    [attrStr drawAtPoint:point];
}


- (void)_drawCircleFrom:(CGFloat)startAngle to:(CGFloat)endAngle color:(UIColor *)color {
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat radius = 70;
    CGFloat arcWidth = 46;
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:true];
    path.lineWidth = arcWidth;
    
    
    [color setStroke];
    [[UIColor blackColor] setFill];
    [path stroke];
    [path fill];
}

- (void)drawRect:(CGRect)rect {
    
    
    CGFloat startAngle = 3 * M_PI / 4;
    CGFloat endAngle = M_PI / 4;
    UIColor* color = [UIColor greenColor];
    
    
    [self _drawCircleFrom:startAngle to:endAngle color:color];
    [self _drawSpeed:self.vehicleModel.speed];
    [self _drawLable:@"km/h"];

}
@end
