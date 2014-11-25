//
//  AllDefines.h
//  MTBCCharts
//
//  Created by waris on 3/25/14.
//  Copyright (c) 2014 MTBC. All rights reserved.
//

#ifndef MTBCCharts_AllDefines_h
#define MTBCCharts_AllDefines_h

#define SPACE_BETWEEN_XAXIS_VALUES 30 //x轴标识之间的距离
#define XAXIS_BAR_HEIGHT 30 //x轴标识与bar之间的距离
#define YAXIS_BAR_WIDTH 30 //y轴标识与bar之间的距离

#define NUMBER_OF_YAXIS_VALUES 5 //背景线的数目

#define BAR_WIDTH 15 //bar的宽度

#define SPACE_BETWEEN_BARS 18
#define SPACE_BETWEEN_BARGROUPS 20 //组之间的距离

typedef enum : NSUInteger
{
    kShadowOfSegments_Hide,
    kShadowOfSegments_Show,
} SegmentShadow;

typedef enum : NSUInteger
{
    kSideValueBar_Hide,
    kSideValueBar_Show,
} SideValueBar;

typedef enum : NSUInteger
{
    kSegmentSelection_On,
    kSegmentSelection_Off,
} SegmentSelection;

#endif
