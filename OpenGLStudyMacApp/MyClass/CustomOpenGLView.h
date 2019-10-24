//
//  CustomOpenGLView.h
//  OpenGLStudyMacApp
//
//  Created by zjj on 2019/10/21.
//  Copyright © 2019 zjj. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class NSOpenGLContext, NSOpenGLPixelFormat;
 
@interface CustomOpenGLView : NSView
{
  @private
    NSOpenGLContext*     _openGLContext;
    NSOpenGLPixelFormat* _pixelFormat;
}

@property (nonatomic, strong) NSOpenGLContext *openGLContext;
@property (nonatomic, strong) NSOpenGLPixelFormat *pixelFormat;

+ (NSOpenGLPixelFormat*)defaultPixelFormat;
- (id)initWithFrame:(NSRect)frameRect pixelFormat:(NSOpenGLPixelFormat*)format;

- (void)clearGLContext;
- (void)prepareOpenGL;
- (void)update;
@end
