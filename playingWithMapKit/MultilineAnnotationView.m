//
//  MultilineAnnotationView.m
//  playingWithMapKit
//
//  Created by Xida Zheng on 1/7/15.
//  Copyright (c) 2015 xidazheng. All rights reserved.
//

#import "MultilineAnnotationView.h"
#import "CustomAnnotationCalloutView.h"

@implementation MultilineAnnotationView



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
    
- (void) setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected)
    {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 80)];
        self.label.backgroundColor = [UIColor whiteColor];
        self.label.layer.cornerRadius = 10;
        self.label.clipsToBounds = YES;
        self.label.numberOfLines = 0;
        self.label.text = [NSString stringWithFormat:@"%@",((MKUserLocation *)self.annotation).title];
        self.label.textAlignment = NSTextAlignmentCenter;
        
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(-self.label.frame.size.width/2+ self.image.size.width/4, -self.label.frame.size.height - 10, self.label.frame.size.width, self.label.frame.size.height)];
        
        [rightView addSubview:self.label];
        [self addSubview:rightView];
        
    }
    else
    {
        for (UIView *subview in [self subviews]) {
            [subview removeFromSuperview];
        }
    }
    
}

@end
