#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

BOOL aimbotEnabled = NO;
BOOL wallhackEnabled = NO;
BOOL espEnabled = NO;
BOOL noRecoilEnabled = NO;
float aimbotStrength = 1.0f;

// Анти-бан система
%hook AntiCheatSystem
- (BOOL)isJailbroken { return NO; }
- (BOOL)isDebugged { return NO; }
- (BOOL)hasSuspiciousFiles { return NO; }
%end

// Основные функции
%hook PlayerController
- (CGPoint)getAimPoint {
    if (aimbotEnabled) {
        CGPoint original = %orig;
        // Автоматическое наведение на ближайшего врага
        CGPoint target = [self findNearestEnemy];
        return CGPointMake(
            original.x + (target.x - original.x) * aimbotStrength,
            original.y + (target.y - original.y) * aimbotStrength
        );
    }
    return %orig;
}

- (float)getRecoilFactor {
    if (noRecoilEnabled) return 0.0f;
    return %orig;
}
%end

%hook GameRenderer
- (BOOL)shouldRenderPlayer:(id)player {
    if (wallhackEnabled) return YES;
    return %orig;
}
%end

// Меню
@interface CheatMenu : UIViewController
@property (nonatomic, strong) UIWindow *menuWindow;
@end

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), 
                  dispatch_get_main_queue(), ^{
        [[CheatMenu new] setupMenu];
    });
}

@implementation CheatMenu

- (void)setupMenu {
    // Скрытая активация - встряхивание устройства
    [[NSNotificationCenter defaultCenter] 
        addObserver:self
        selector:@selector(deviceShaken)
        name:UIApplicationDidFinishLaunchingNotification
        object:nil];
}

- (void)deviceShaken {
    [self showMenu];
}

- (void)showMenu {
    if (self.menuWindow) {
        self.menuWindow.hidden = !self.menuWindow.hidden;
        return;
    }
    
    self.menuWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.menuWindow.windowLevel = UIWindowLevelAlert + 999;
    self.menuWindow.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.85];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(40, 150, 295, 380)];
    contentView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.95];
    contentView.layer.cornerRadius = 20;
    contentView.layer.borderWidth = 2;
    contentView.layer.borderColor = [UIColor systemBlueColor].CGColor;
    
    [self addMenuTitle:contentView];
    [self addToggleButtons:contentView];
    [self addSliders:contentView];
    [self addCloseButton:contentView];
    
    [self.menuWindow addSubview:contentView];
    self.menuWindow.hidden = NO;
}

- (void)addMenuTitle:(UIView *)parent {
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 295, 30)];
    title.text = @"🔫 Standoff 2 Cheat v1.0";
    title.textColor = [UIColor systemGreenColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:18];
    [parent addSubview:title];
}

- (void)addToggleButtons:(UIView *)parent {
    NSArray *features = @[
        @[@"🎯 Aimbot", @"toggleAimbot"],
        @[@"👻 Wallhack", @"toggleWallhack"], 
        @[@"🔍 ESP", @"toggleESP"],
        @[@"⚡ No Recoil", @"toggleNoRecoil"]
    ];
    
    for (int i = 0; i < features.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(25, 60 + (i * 55), 245, 45);
        btn.backgroundColor = [UIColor colorWithRed:0.2 green:0.4 blue:0.8 alpha:1.0];
        btn.layer.cornerRadius = 10;
        [btn setTitle:features[i][0] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:NSSelectorFromString(features[i][1]) 
              forControlEvents:UIControlEventTouchUpInside];
        [parent addSubview:btn];
    }
}

- (void)addSliders:(UIView *)parent {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 280, 245, 20)];
    label.text = @"Aimbot Strength";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [parent addSubview:label];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(25, 305, 245, 30)];
    slider.minimumValue = 0.1;
    slider.maximumValue = 1.0;
    slider.value = aimbotStrength;
    [slider addTarget:self action:@selector(aimbotStrengthChanged:) 
             forControlEvents:UIControlEventValueChanged];
    [parent addSubview:slider];
}

- (void)addCloseButton:(UIView *)parent {
    UIButton *close = [UIButton buttonWithType:UIButtonTypeSystem];
    close.frame = CGRectMake(25, 340, 245, 35);
    close.backgroundColor = [UIColor systemRedColor];
    close.layer.cornerRadius = 8;
    [close setTitle:@"✖ Close" forState:UIControlStateNormal];
    [close setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(hideMenu) forControlEvents:UIControlEventTouchUpInside];
    [parent addSubview:close];
}

// Обработчики кнопок
- (void)toggleAimbot { aimbotEnabled = !aimbotEnabled; }
- (void)toggleWallhack { wallhackEnabled = !wallhackEnabled; }
- (void)toggleESP { espEnabled = !espEnabled; }
- (void)toggleNoRecoil { noRecoilEnabled = !noRecoilEnabled; }
- (void)aimbotStrengthChanged:(UISlider *)slider { aimbotStrength = slider.value; }
- (void)hideMenu { self.menuWindow.hidden = YES; }

@end
