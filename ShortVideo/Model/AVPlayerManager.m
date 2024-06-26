//
//  AVPlayerManager.m
//  ShortVideo
//
//  Created by 张兴栋 on 2018/7/30.
//  Copyright © 2018年 张兴栋. All rights reserved.
//

#import "AVPlayerManager.h"

@interface AVPlayerManager()

@end

@implementation AVPlayerManager

+ (AVPlayerManager *)shareManager {
    static dispatch_once_t once;
    static AVPlayerManager *manager;
    dispatch_once(&once, ^{
        manager = [AVPlayerManager new];
    });
    return manager;
}

+ (void)setAudioMode {
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance]setActive:YES error:nil];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _playerArray = [NSMutableArray array];
    }
    return self;
}

- (void)play:(AVPlayer *)player {
//    [_playerArray enumerateObjectsUsingBlock:^(AVPlayer * obj, NSUInteger idx, BOOL *stop) {
//        if (![player isEqual:obj]) {
//            [obj pause];
//        }
//    }];        
    
    if(![_playerArray containsObject:player]) {
        [_playerArray addObject:player];
    }
    [player play];
}

- (void)pause:(AVPlayer *)player {
    if([_playerArray containsObject:player]) {
        [player pause];
    }
}

- (void)pauseAll {
    [_playerArray enumerateObjectsUsingBlock:^(AVPlayer * obj, NSUInteger idx, BOOL *stop) {
        [obj pause];
    }];
}

//- (void)replay:(AVPlayer *)player {
//    [_playerArray enumerateObjectsUsingBlock:^(AVPlayer * obj, NSUInteger idx, BOOL *stop) {
//        [obj pause];
//    }];
//    if([_playerArray containsObject:player]) {
//        [player seekToTime:kCMTimeZero];
//        [self play:player];
//    } else {
//        [_playerArray addObject:player];
//        [self play:player];
//    }
//}

- (void)replay:(AVPlayer *)player isPlayCompleted:(BOOL)isPlayCompleted currentTime:(Float64)currentTime {
    [_playerArray enumerateObjectsUsingBlock:^(AVPlayer * obj, NSUInteger idx, BOOL *stop) {
        if (![player isEqual:obj]) {
            [obj pause];
        }
    }];
    
    if (!isPlayCompleted) {
        CMTime targetTime = CMTimeMakeWithSeconds(currentTime, 1 *1000);
        [player seekToTime:targetTime];
    }
    
    if([_playerArray containsObject:player]) {
        if (isPlayCompleted) {
            [player seekToTime:kCMTimeZero];
        }
        [self play:player];
    } else {
        [_playerArray addObject:player];
        [self play:player];
    }
}

- (void)removeAllPlayers {
    [_playerArray removeAllObjects];
}

@end
