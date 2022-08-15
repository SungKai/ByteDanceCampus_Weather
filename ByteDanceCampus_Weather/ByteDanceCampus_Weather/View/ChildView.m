//
//  FlexItemChildView.m
//  ByteDanceCampus_Weather
//
//  Created by atom on 2022/8/8.
//
//

#import "ChildView.h"

@interface ChildView ()
@property(nonatomic, strong) UILabel *text;
@end

@implementation ChildView


- (instancetype)init {
    self = [super init];
    if (self) {
//        self.backgroundColor = [UIColor greenColor];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addSubview:self.text];
    [self.text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (UILabel *)text {
    if (_text == NULL) {
        _text = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 200)];
        _text.text = @"Child";
    }
    return _text;
}

@end
