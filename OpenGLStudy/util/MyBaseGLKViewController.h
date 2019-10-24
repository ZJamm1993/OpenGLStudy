//
//  MyBaseGLKViewController.h
//  OpenGLStudy
//
//  Created by zjj on 2019/10/24.
//  Copyright © 2019 zjj. All rights reserved.
//

#import <GLKit/GLKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyBaseGLKViewController : GLKViewController

@property (nonatomic, readonly) GLKView *glView;

@property (nonatomic, strong) EAGLContext *glContext;
@property (nonatomic, strong) GLKBaseEffect *glBaseEffect;

@end

NS_ASSUME_NONNULL_END
