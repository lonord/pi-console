//
//  DataPackHandlerDelegate.h
//  piconsoleclient
//
//  Created by lonord on 2016/11/17.
//  Copyright © 2016年 lonord. All rights reserved.
//

#ifndef DataPackHandlerDelegate_h
#define DataPackHandlerDelegate_h

@protocol DataPackHandlerDelegate <NSObject>

- (BOOL)acceptTag:(unsigned char)tag;

- (void)putData:(unsigned char)tag data:(NSData*)data;

@optional

- (void)setDataCallback:(void(^)(unsigned char tag, NSData* data))cb;

- (void)notifyBTConnected;

- (void)notifyBTDisconnected;

@end

#endif /* DataPackHandlerDelegate_h */
