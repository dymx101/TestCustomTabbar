// RDVTabBar.m
//
// Copyright (c) 2013 Robert Dimitrov
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "RDVTabBar.h"
#import "RDVTabBarItem.h"

@interface RDVTabBar ()

@property (nonatomic) CGFloat itemWidth;

@end

@implementation RDVTabBar
{
    UIImageView *_backgroundView;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self _doInit];
    }
    
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self _doInit];
    }
    
    return self;
}

-(void)_doInit
{
    _backgroundView = [[UIImageView alloc] init];
    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _backgroundView.contentMode = UIViewContentModeScaleToFill;
    //_backgroundView.opaque = NO;
    [self addSubview:_backgroundView];
}

-(void)setBackgroundImage:(UIImage *)aBackgroundImage
{
    _backgroundView.image = aBackgroundImage;
}

- (void)layoutSubviews {
    if ([self edgeContentInset]) {
        [self setItemWidth:(CGRectGetWidth(self.frame) - 2 * [self edgeContentInset]) / [[self items] count]];
    } else {
        [self setItemWidth:CGRectGetWidth(self.frame) / [[self items] count]];
        [self setEdgeContentInset:CGRectGetWidth(self.frame) - [[self items] count] * [self itemWidth]];
    }
    
    for (NSInteger i = 0; i < [[self items] count]; i++) {
        RDVTabBarItem *item = [[self items] objectAtIndex:i];
        [item setFrame:CGRectMake(self.edgeContentInset + (i * self.itemWidth), 0, self.itemWidth, CGRectGetHeight(self.frame))];
    }
}

#pragma mark - Methods

- (void)setItemWidth:(CGFloat)itemWidth {
    if (itemWidth > 0) {
        _itemWidth = itemWidth;
    }
}

- (void)setItems:(NSArray *)items {
    for (RDVTabBarItem *item in items) {
        [item removeFromSuperview]; 
    }
    
    _items = [items copy];
    for (RDVTabBarItem *item in items) {
        [item addTarget:self action:@selector(tabBarItemWasSelected:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:item];
    }
}

- (void)tabBarItemWasSelected:(id)sender {
    if ([[self delegate] respondsToSelector:@selector(tabBar:shouldSelectItemAtIndex:)]) {
        NSInteger index = [self.items indexOfObject:sender];
        if (![[self delegate] tabBar:self shouldSelectItemAtIndex:index]) {
            return;
        }
    }
    
    [self setSelectedItem:sender];
    
    if ([[self delegate] respondsToSelector:@selector(tabBar:didSelectItemAtIndex:)]) {
        NSInteger index = [self.items indexOfObject:self.selectedItem];
        [[self delegate] tabBar:self didSelectItemAtIndex:index];
    }
}

- (void)setSelectedItem:(RDVTabBarItem *)selectedItem {
    if (selectedItem == _selectedItem) {
        return;
    }
    [_selectedItem setSelected:NO];
    
    _selectedItem = selectedItem;
    [_selectedItem setSelected:YES];
}

@end
