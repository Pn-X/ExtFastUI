# ExtFastUI
Fast build user interface

### Installation

Add the following line to your Podfile

```
pod 'ExtFastUI'
```

### Why use ExtFastUI?

Creating views is  verbose:

```objective-c
@interface ViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *badgeImageView;
@property (nonatomic, strong) UILabel *firstContentLabel;
@property (nonatomic, strong) UILabel *secondContentLabel;
@property (nonatomic, strong) UILabel *thirdContentLabel;
@property (nonatomic, strong) UILabel *fourthContentLabel;
@property (nonatomic, strong) UILabel *fifthContentLabel;
@property (nonatomic, strong) UIButton *doneButton;

@end
  
@implementation ViewController

- (void)viewDidLoad {
    self.titleLabel = [UILabel new];
    self.badgeImageView = [UIImageView new];
    self.firstContentLabel = [UILabel new];
    self.secondContentLabel = [UILabel new];
    self.thirdContentLabel = [UILabel new];
    self.fourthContentLabel = [UILabel new];
    self.fifthContentLabel = [UILabel new];  
    self.doneButton = [UIButton new];
  
    self.fifthContentLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.fifthContentLabel  addGestureRecognizer:tap];
  
    [self.view addSubview:self.titleLabel];
    [self.titleLabel addSubview:self.badgeImageView];
    [self.view addSubview:self.firstContentLabel];
    [self.view addSubview:self.secondContentLabel];
    [self.view addSubview:self.thirdContentLabel];
    [self.view addSubview:self.fourthContentLabel];
    [self.view addSubview:self.fifthContentLabel];
    [self.view addSubview:self.doneButton];
}

@end
```

now you can write code like this:

```objective-c
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ext_remountTemplate];
}

- (NSArray *)ext_template:(nullable id)params {
    return @[
        UILabel.extViewNode(this.nodeId = @"title").append(@[
          UIImageView.extViewNode(this.nodeId = @"badge"),
        ]),
        UILabel.extViewNode(this.nodeId = @"first"),
        UILabel.extViewNode(this.nodeId = @"second"),
        UILabel.extViewNode(this.nodeId = @"third"),
        UILabel.extViewNode(this.nodeId = @"fourth"),
        UILabel.extViewNode(this.nodeId = @"fifth"; this.event.onTap = @selector(tap:)),
        UIButton.extViewNode(this.nodeId = @"done")
    ];
}

@end
```

### Advanced Usage

You can found it in [Wiki](https://github.com/Pn-X/ExtFastUI/wiki)

### License

ExtFastUI is released under the MIT license

