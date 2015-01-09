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
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 100)];
        label.backgroundColor = [UIColor whiteColor];
        label.layer.cornerRadius = 10;
        label.clipsToBounds = YES;
        label.numberOfLines = 0;
        label.text = [NSString stringWithFormat:@"%@",((MKUserLocation *)self.annotation).title];
        label.textAlignment = NSTextAlignmentCenter;
        
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(-label.frame.size.width/2+ self.image.size.width/4, -label.frame.size.height - 10, label.frame.size.width, label.frame.size.height)];
        
        [rightView addSubview:label];
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
