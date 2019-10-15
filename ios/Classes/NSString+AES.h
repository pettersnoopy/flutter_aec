//
//  NSString+AES.h
//  HZPurse
//
//  Created by GGJ on 30/8/2017.
//  Copyright © 2017 huazhuan. All rights reserved.
//

#ifndef NSString_AES_h
#define NSString_AES_h

@interface NSString (AES)
- (NSString *)encryptWithHexKey:(NSString*)hexKey hexIV:(NSString *)hexIV;
- (NSString *)decryptWithHexKey:(NSString*)hexKey hexIV:(NSString *)hexIV;
@end

#endif /* NSString_AES_h */
