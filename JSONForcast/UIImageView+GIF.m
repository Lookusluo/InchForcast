//
//  UIImageView+GIF.m
//  JSONForcast
//
//  Created by Yazhong Luo on 12/16/16.
//  Copyright © 2016 Yazhong Luo. All rights reserved.
//

#import "UIImageView+GIF.h"
#import <ImageIO/ImageIO.h>

#if __has_feature(objc_arc)
#define toCF (__bridge CFTypeRef)
#define ARCCompatibleAutorelease(object) object
#else
#define toCF (CFTypeRef)
#define ARCCompatibleAutorelease(object) [object autorelease]
#endif

@implementation UIImageView(ASGif)

- (void)animatedGIFImageSource:(CGImageSourceRef) source
                   andDuration:(NSTimeInterval) duration {
    
    
    if (!source) return;
    size_t count = CGImageSourceGetCount(source);
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:count];
    for (size_t i = 0; i < count; ++i) {
        CGImageRef cgImage = CGImageSourceCreateImageAtIndex(source, i, NULL);
        if (!cgImage)
            return;
        [images addObject:[UIImage imageWithCGImage:cgImage]];
        CGImageRelease(cgImage);
    }
    [self setAnimationImages:images];
    [self setAnimationDuration:duration];
    [self startAnimating];
}

- (NSTimeInterval)durationForGifData:(NSData *)data {
    char graphicControlExtensionStartBytes[] = {0x21,0xF9,0x04};
    double duration=0;
    NSRange dataSearchLeftRange = NSMakeRange(0, data.length);
    while(YES){
        NSRange frameDescriptorRange = [data rangeOfData:[NSData dataWithBytes:graphicControlExtensionStartBytes
                                                                        length:3]
                                                 options:NSDataSearchBackwards
                                                   range:dataSearchLeftRange];
        if(frameDescriptorRange.location!=NSNotFound){
            NSData *durationData = [data subdataWithRange:NSMakeRange(frameDescriptorRange.location+4, 2)];
            unsigned char buffer[2];
            [durationData getBytes:buffer length:20];//need a length for buffer
            double delay = (buffer[0] | buffer[1] << 8);
            duration += delay;
            dataSearchLeftRange = NSMakeRange(0, frameDescriptorRange.location);
        }else{
            break;
        }
    }
    return duration/65;
}

- (void)showGifImageWithData:(NSData *)data {
    NSTimeInterval duration = [self durationForGifData:data];
    CGImageSourceRef source = CGImageSourceCreateWithData(toCF data, NULL);
    [self animatedGIFImageSource:source andDuration:duration];
    CFRelease(source);
}

-(void)showGifImageWithData:(NSData *)data WithDuration:(NSTimeInterval)setduration{
    NSTimeInterval duration = setduration;
    CGImageSourceRef source = CGImageSourceCreateWithData(toCF data, NULL);
    [self animatedGIFImageSource:source andDuration:duration];
    CFRelease(source);
}

@end
