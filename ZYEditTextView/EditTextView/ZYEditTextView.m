//
//  ZYEditTextView.m
//
//  Created by zxq on 16/5/3.
//  Copyright © 2016年 zxq. All rights reserved.
//

#import "ZYEditTextView.h"

static CGFloat kMinTextViewWidth = 50;
static CGFloat kMinTextViewHeight = 40;
static CGFloat kToolButtonWidth = 23;

typedef NS_ENUM(NSInteger, DIYBorderStyle){
    kDIYBorderStyleNormal = 0,      //正常状态
    kDIYBorderStyleInGesture        //手势操作中
};


@interface ZYEditTextView ()

@property (nonatomic, strong) UIImageView *rotateView;
@property (nonatomic, strong) UIImageView *sizeView;
@property (nonatomic, strong, readwrite) UILabel *textLabel;

@end

@implementation ZYEditTextView

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)layoutSubviews
{
    self.textLabel.frame = CGRectMake(self.bounds.origin.x + 10, self.bounds.origin.y + 10, self.bounds.size.width - 20, self.bounds.size.height - 20);
    self.rotateView.frame = CGRectMake(0, self.bounds.size.height - kToolButtonWidth, kToolButtonWidth, kToolButtonWidth);
    self.sizeView.frame = CGRectMake(self.bounds.size.width - kToolButtonWidth, self.bounds.size.height - kToolButtonWidth, kToolButtonWidth, kToolButtonWidth);
}

#pragma mark - public

- (void)isShowHelpToolButton:(BOOL)isShow
{
    self.rotateView.hidden = !isShow;
    self.sizeView.hidden = !isShow;
    if (isShow) {
        self.textLabel.layer.borderWidth = 1;
    }else{
        self.textLabel.layer.borderWidth = 0;
    }
}

- (void)updateTextLableString:(NSString*)text
{
    self.textLabel.text = text;
}

- (void)updateTextColor:(UIColor*)color
{
    self.textLabel.textColor = color;
}


#pragma mark - private

- (void)createUI
{

    self.textLabel.layer.borderWidth = 1;
    self.textLabel.layer.borderColor = [UIColor colorWithRed:135.0f/255 green:211.0f/255 blue:1 alpha:1].CGColor;
    self.textLabel.clipsToBounds = YES;
    
    [self updateTextLableString:@"文字框旋转缩放"];
    
    [self addSubview:self.textLabel];
    [self addSubview:self.rotateView];
    [self addSubview:self.sizeView];
    
    self.userInteractionEnabled = YES;
    self.rotateView.userInteractionEnabled = YES;
    self.sizeView.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer *moveGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanGesture:)];
    [self addGestureRecognizer:moveGesture];
    
    UIPanGestureRecognizer *rotatePanGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rotateViewPanGesture:)];
    [self.rotateView addGestureRecognizer:rotatePanGes];
    UIPanGestureRecognizer *sizePanGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(sizeViewPanGesture:)];
    [self.sizeView addGestureRecognizer:sizePanGes];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
    UIRotationGestureRecognizer *rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateGesture:)];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    
    [self addGestureRecognizer:pinchGesture];
    [self addGestureRecognizer:rotateGesture];
    [self addGestureRecognizer:tapGes];
}

- (void)updateBorderStyle:(DIYBorderStyle)style
{
    if (style == kDIYBorderStyleNormal) {
        self.sizeView.hidden = NO;
        self.rotateView.hidden = NO;
        self.textLabel.layer.borderColor = [UIColor colorWithRed:135.0f/255 green:211.0f/255 blue:1 alpha:1].CGColor;
    }else{
        self.sizeView.hidden = YES;
        self.rotateView.hidden = YES;
        self.textLabel.layer.borderColor = [UIColor colorWithRed:135.0f/255 green:211.0f/255 blue:1 alpha:0.6].CGColor;
    }
}

#pragma mark - response action

- (void)pinchGesture:(UIPinchGestureRecognizer*)ges
{
    static CGRect originRect;
 
    if ([ges state] == UIGestureRecognizerStateBegan) {
        originRect = self.bounds;
        [self updateBorderStyle:kDIYBorderStyleInGesture];
    }else if ([ges state] == UIGestureRecognizerStateChanged){
        CGFloat width = originRect.size.width * ges.scale;
        CGFloat height = originRect.size.height * ges.scale;
        if (width < kMinTextViewWidth) {
            width = kMinTextViewWidth;
        }
        if (height < kMinTextViewHeight) {
            height = kMinTextViewHeight;
        }
        self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, width, height);
    }else if ([ges state] == UIGestureRecognizerStateEnded){
        [self updateBorderStyle:kDIYBorderStyleNormal];
    }else{
        [self updateBorderStyle:kDIYBorderStyleNormal];
    }
}

- (void)rotateGesture:(UIRotationGestureRecognizer*)ges
{
    if (ges.state == UIGestureRecognizerStateBegan) {
        [self updateBorderStyle:kDIYBorderStyleInGesture];
    }else if (ges.state == UIGestureRecognizerStateEnded){
        [self updateBorderStyle:kDIYBorderStyleNormal];
    }else{
        [self updateBorderStyle:kDIYBorderStyleNormal];
    }
    
    CGFloat rotation = [ ges rotation];
    self.layer.affineTransform = CGAffineTransformRotate(self.layer.affineTransform, rotation);
    [ges setRotation:0];
}

- (void)tapAction:(UITapGestureRecognizer*)ges{
    if (self.tapActionBlock) {
        self.tapActionBlock(self);
    }
    
}

- (void)movePanGesture:(UIPanGestureRecognizer*)ges
{
    static CGPoint originCenterPoint;
    if (ges.state == UIGestureRecognizerStateBegan) {
        originCenterPoint = self.center;
        
    }else if (ges.state == UIGestureRecognizerStateChanged){

        if (self.superview) {   //self的坐标系统可能被旋转，因此取superview
            CGPoint locationPoint = [ges locationInView:self.superview];
            //超出边界
            if (locationPoint.y < 0 || locationPoint.y > self.superview.frame.size.height || locationPoint.x < 0 || locationPoint.x > self.superview.frame.size.width) {
                return;
            }
            
            CGPoint transPoint = [ges translationInView:self.superview];
            CGPoint finalCenter = CGPointMake(originCenterPoint.x + transPoint.x, originCenterPoint.y + transPoint.y);
            self.center = finalCenter;
        }
    }else if (ges.state == UIGestureRecognizerStateEnded){

    }
}

- (void)sizeViewPanGesture:(UIPanGestureRecognizer*)ges
{
    static CGRect originBounds;
    static CGPoint originCenterPoint;
    static CGRect originFrame;
    
    if (ges.state == UIGestureRecognizerStateBegan) {
        originBounds = self.bounds;
        originCenterPoint = self.center;
        originFrame = self.frame;

        [self updateBorderStyle:kDIYBorderStyleInGesture];

    }else if (ges.state == UIGestureRecognizerStateChanged){
        
        CGPoint transPoint = [ges translationInView:self.superview];
        
        //旋转角度 顺时针方向为正，逆为负
        CGFloat radians = atan2f(self.transform.b, self.transform.a);
        CGFloat postiveRadians = ABS(radians);
        
        //未旋转坐标系，移动终点和起点形成的角度。
        CGFloat moveAngleInOriginCoordinate = atan(transPoint.y / transPoint.x);
        //旋转后坐标系，移动终点和起点形成的角度
        CGFloat moveAngleInRotateCoordinate = moveAngleInOriginCoordinate - radians;
        //移动距离
        CGFloat moveDistance = sqrt(transPoint.x * transPoint.x + transPoint.y * transPoint.y);
        //旋转后坐标系，x、y方向移动的距离
        CGFloat addWidth = ABS(moveDistance * cos(moveAngleInRotateCoordinate));
        CGFloat addHeight = ABS(moveDistance * sin(moveAngleInRotateCoordinate));
        
        //判断是增大还是减小。缩放方向。 经过坐标系旋转后，缩放方向可能会发生变化。画出原坐标系和旋转后坐标系，重叠后，会有八个区域，分别可看出每个区域的缩放方向的变化情况。
        if (radians < 0) {      //坐标系顺时针旋转。逆时针和顺时针情况不一样。
            if (transPoint.x < 0 && transPoint.y < 0) {
                if (moveAngleInRotateCoordinate<M_PI/2.0) {
                    addWidth *= -1;
                    addHeight *= -1;
                }else{
                    addHeight *= -1;
                }
            }else if(transPoint.x < 0 && transPoint.y > 0){
                if (moveAngleInRotateCoordinate>0) {
                    addWidth *= -1;
                    addHeight *= -1;
                }else{
                    addWidth *= -1;
                }
            }else if (transPoint.x > 0 && transPoint.y < 0){
                if (moveAngleInRotateCoordinate < 0) {
                    addHeight *= -1;
                }
            }else if (transPoint.x > 0 && transPoint.y > 0){
                if (moveAngleInRotateCoordinate > M_PI / 2.0) {
                    addWidth *= -1;
                }
            }
        }else{  //坐标系逆时针旋转
            if (transPoint.x < 0 && transPoint.y < 0) {
                if (moveAngleInRotateCoordinate < 0) {
                    addWidth *= -1;
                }else{
                    addWidth *= -1;
                    addHeight *= -1;
                }
            }else if(transPoint.x < 0 && transPoint.y > 0){
                if (moveAngleInRotateCoordinate > -M_PI/2.0f) {
                    addWidth *= -1;
                }
            }else if (transPoint.x > 0 && transPoint.y < 0){
                if (moveAngleInRotateCoordinate > -M_PI/2.0f) {
                    addHeight *= -1;
                }else{
                    addWidth *= -1;
                    addHeight *= -1;
                }
            }else if (transPoint.x > 0 && transPoint.y > 0){
                if (moveAngleInRotateCoordinate < 0) {
                    addHeight *= -1;
                }
            }
        }
        //x、y轴方向的增大或缩小值
        CGFloat width =  originBounds.size.width + addWidth;
        CGFloat height = originBounds.size.height + addHeight;

        
        //设置缩放的最小值
        if (width < kMinTextViewWidth) {
            width = kMinTextViewWidth;
        }
        if (height < kMinTextViewHeight) {
            height = kMinTextViewHeight;
        }
        
        //顺时针旋转后缩放会改变frame.origin.x的值，逆时针旋转后缩放会改变frame.origin.y的值。 这两个为所改变的值。
        CGFloat yDistance = 0;
        CGFloat xDistance = 0;
        
        if (radians > 0) {
            xDistance = -(height - originBounds.size.height) * sin(radians);
        }else{
            yDistance = (width - originBounds.size.width) * sin(radians);
        }
        
        //旋转情况下，缩放后的self.frame
        CGFloat frameWidth = width * cos(postiveRadians) + height * sin(postiveRadians);
        CGFloat frameHeight = width * sin(postiveRadians) + height * cos(postiveRadians);
        
        //warning:用CATransform变换过的，再去设置frame，会出现不可预料情况。只能用bounds和center
        //原始frame.origin 加上偏移，加上宽高一半的值，为新的center
        self.center = CGPointMake(originFrame.origin.x + xDistance + frameWidth / 2.0f, originFrame.origin.y + yDistance + frameHeight / 2.0f);
        self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, width, height);

    }else if (ges.state == UIGestureRecognizerStateEnded){
        [self updateBorderStyle:kDIYBorderStyleNormal];
    }else{
        [self updateBorderStyle:kDIYBorderStyleNormal];
    }
}

- (void)rotateViewPanGesture:(UIPanGestureRecognizer*)ges
{

    if (ges.state == UIGestureRecognizerStateBegan) {
        [self updateBorderStyle:kDIYBorderStyleInGesture];
        
    }else if (ges.state == UIGestureRecognizerStateChanged){
        
        CGPoint locatioPoint = [ges locationInView:self];
        
        //三角形边长
        CGFloat triangle_a = sqrt((locatioPoint.x - self.center.x) * (locatioPoint.x - self.center.x) + (locatioPoint.y - self.center.y) * (locatioPoint.y - self.center.y));
        CGFloat triangle_b = sqrt((self.rotateView.center.x - self.center.x) * (self.rotateView.center.x - self.center.x) + (self.rotateView.center.y - self.center.y) * (self.rotateView.center.y - self.center.y));
        CGFloat triangle_c = sqrt((locatioPoint.x - self.rotateView.center.x) * (locatioPoint.x - self.rotateView.center.x) + (locatioPoint.y - self.rotateView.center.y) * (locatioPoint.y - self.rotateView.center.y));

        //余弦定理求旋转角度
        CGFloat temp = (triangle_a * triangle_a + triangle_b * triangle_b - triangle_c * triangle_c ) / (2 * triangle_a * triangle_b);
        CGFloat rotateAngle = acos(temp);
        
        //手势所在点和中心点的直线函数
        CGFloat kRate = (locatioPoint.y - self.center.y) / (locatioPoint.x - self.center.x); //斜率
        CGFloat bDistance = (locatioPoint.y * self.center.x - self.center.y * locatioPoint.x) / (self.center.x - locatioPoint.x);//截距
        
        CGFloat yOffset = kRate * self.rotateView.center.x + bDistance;
        if (yOffset > self.rotateView.center.y) {   // 判断旋转方向
            rotateAngle = -rotateAngle;
        }
        //抗锯齿
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        //旋转
        self.layer.affineTransform = CGAffineTransformRotate(self.layer.affineTransform, rotateAngle);   //CATransform3DGetAffineTransform(CATransform3DRotate(self.layer.transform, rotateAngle, 0, 0, 1));

    }else if (ges.state == UIGestureRecognizerStateEnded){
        [self updateBorderStyle:kDIYBorderStyleNormal];
    }else{
        [self updateBorderStyle:kDIYBorderStyleNormal];
    }
}

#pragma mark - setters

- (void)setState:(ZYEditTextViewState)state{
    _state = state;
    switch (state) {
        case kZYEditTextViewStateEdit:{
            self.rotateView.hidden = YES;
            self.sizeView.hidden = YES;
            self.userInteractionEnabled = NO;
            self.textLabel.layer.borderWidth = 1;
            self.textLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];// HEX_RGBA(0xffffff, 0.5);
            break;
        }
        case kZYEditTextViewStateSelected:{
            self.rotateView.hidden = NO;
            self.sizeView.hidden = NO;
            self.userInteractionEnabled = YES;
            self.textLabel.layer.borderWidth = 1;
            self.textLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
            break;
        }
        case kZYEditTextViewStateDisable:{
            self.rotateView.hidden = YES;
            self.sizeView.hidden = YES;
            self.userInteractionEnabled = NO;
            self.textLabel.layer.borderWidth = 0;
            self.textLabel.backgroundColor = [UIColor clearColor];
            break;
        }
        case kZYEditTextViewStateNormal:{
            self.rotateView.hidden = YES;
            self.sizeView.hidden = YES;
            self.userInteractionEnabled = YES;
            self.textLabel.layer.borderWidth = 1;
            self.textLabel.backgroundColor = [UIColor clearColor];
            break;
        }

        default:
            break;
    }
}

- (void)setFontWeight:(CGFloat)fontWeight{
    _fontWeight = fontWeight;
    self.textLabel.font = [UIFont systemFontOfSize:100 weight:fontWeight];
}

#pragma mark - getters

- (UIImageView*)rotateView
{
    if (!_rotateView) {
        _rotateView = [[UIImageView alloc] init];
        _rotateView.image = [UIImage imageNamed:@"zy_rotate"];
    }
    return _rotateView;
}

- (UIImageView*)sizeView
{
    if (!_sizeView) {
        _sizeView = [[UIImageView alloc] init];
        _sizeView.image = [UIImage imageNamed:@"zy_scale"];
    }
    return _sizeView;
}

- (UILabel*)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.numberOfLines = 0;
        _textLabel.opaque = NO;
        _textLabel.font = [UIFont systemFontOfSize:100 weight:kEditTextViewFontBold];
        _fontWeight = kEditTextViewFontBold;
        _textLabel.adjustsFontSizeToFitWidth = YES;
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}


@end
