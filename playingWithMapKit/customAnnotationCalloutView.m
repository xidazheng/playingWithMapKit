//
//  customAnnotationCalloutView.m
//  playingWithMapKit
//
//  Created by Xida Zheng on 1/7/15.
//  Copyright (c) 2015 xidazheng. All rights reserved.
//

#import "CustomAnnotationCalloutView.h"

@interface CustomAnnotationCalloutView ()
@property (strong, nonatomic) IBOutlet UIView *customAnnotationCalloutView;


@end

@implementation CustomAnnotationCalloutView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"CustomAnnotationCalloutView" owner:self options:nil];
        
        [self addSubview:self.customAnnotationCalloutView];
    }
    return self;
}

- (void)setAddress:



@end
