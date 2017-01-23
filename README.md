# EHLoaders

[![CI Status](http://img.shields.io/travis/Eric Huang/EHLoaders.svg?style=flat)](https://travis-ci.org/Eric Huang/EHLoaders)
[![Version](https://img.shields.io/cocoapods/v/EHLoaders.svg?style=flat)](http://cocoapods.org/pods/EHLoaders)
[![License](https://img.shields.io/cocoapods/l/EHLoaders.svg?style=flat)](http://cocoapods.org/pods/EHLoaders)
[![Platform](https://img.shields.io/cocoapods/p/EHLoaders.svg?style=flat)](http://cocoapods.org/pods/EHLoaders)

## Summary

pull to refresh & lift to load more.

## Usage

```ObjectiveC
YourCustomRefreshLoaderView *refreshView = [[YourCustomRefreshLoaderView alloc] init];
self.scrollView.eh_header = [EHHeadLoader headerWithLoaderView:refreshView target:self action:@selector(refresh:);

YourCustomLoadMoreLoaderView *loadMoreView = [[YourCustomLoadMoreLoaderView alloc] init];
self.scrollView.eh_footer = [EHFootLoader footerWithLoaderView:loadMoreView target:self action:@selector(loadMore:);
```

those custom views' class should be subclass of EHLoaderView, and you should override methods in EHLoadersStateReactionDelegate to customize your behaviors.

```ObjectiveC
@protocol EHLoadersStateReactionDelegate <NSObject>

@required
- (void)reactOnIdleStateForThresholdPercentage:(CGFloat)percentage;
- (void)reactOnTriggeredStateForThresholdPercentage:(CGFloat)percentage;
- (void)reactOnStateChangedFrom:(EHLoadersState)fromState to:(EHLoadersState)toState;

@optional
- (void)reactOnNoMoreDataFlagSetTo:(BOOL)hasNoMoreData;

@end
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS 7.0+

## Installation

EHLoaders is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "EHLoaders"
```

## Author

Eric Huang, WaterFlowsEast@gmail.com

## License

EHLoaders is available under the MIT license. See the LICENSE file for more info.
