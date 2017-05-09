//
//  Macros.h
//  DragonflyParking
//
//  Created by Neo on 2017/5/9.
//  Copyright © 2017年 GOGenius. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

    #ifdef DEBUG

        #define JLog(...)  NSLog(__VA_ARGS__)
    #else

        #define JLog(...)
    #endif

#endif /* Macros_h */
