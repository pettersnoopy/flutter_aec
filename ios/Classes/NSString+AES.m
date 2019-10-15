//
//  NSString+AES.m
//  HZPurse
//
//  Created by GGJ on 30/8/2017.
//  Copyright © 2017 huazhuan. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

NSString *HEX_IV = @"00000000000000000000000000000000";

@implementation NSString (AES)

+ (NSData *)dataFromHexString:(NSString *)string
{
    string = string.lowercaseString;
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:string.length / 2];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i = 0;
    NSUInteger length = string.length;
    while (i < length-1) {
        char c = [string characterAtIndex:i++];
        if (c < '0' || (c > '9' && c < 'a') || c > 'f')
            continue;
        byte_chars[0] = c;
        byte_chars[1] = [string characterAtIndex:i++];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    return data;
}

+ (void)fillDataArray:(char **)dataPtr length:(NSUInteger)length usingHexString:(NSString *)hexString
{
    NSData *data = [NSString dataFromHexString:hexString];
    NSAssert((data.length + 1) == length, @"The hex provided didn't decode to match length");
    
    *dataPtr = malloc(length * sizeof(char));
    bzero(*dataPtr, length * sizeof(char));
    memcpy(*dataPtr, data.bytes, data.length);
}

- (NSString *)encryptWithHexKey:(NSString*)hexKey hexIV:(NSString *)hexIV
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    // Fetch key data and put into C string array padded with \0
    char *keyPtr;
    [NSString fillDataArray:&keyPtr length:kCCKeySizeAES128 + 1 usingHexString:hexKey];
    
    // Fetch iv data and put into C string array padded with \0
    if (hexIV.length == 0) {
        hexIV = HEX_IV;
    }
    char *ivPtr;
    [NSString fillDataArray:&ivPtr length:kCCKeySizeAES128 + 1 usingHexString:hexIV];
    
    // For block ciphers, the output size will always be less than or equal to the input size plus the size of one block because we add padding.
    // That's why we need to add the size of one block here
    NSUInteger dataLength = data.length;
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc( bufferSize );
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES128,
                                          ivPtr /* initialization vector */,
                                          [data bytes], [data length], /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    free(keyPtr);
    free(ivPtr);
    
    if(cryptStatus == kCCSuccess) {
        NSData *encrypted =  [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        return [encrypted base64EncodedStringWithOptions:0];
    }
    
    free(buffer);
    return nil;
}

- (NSString *)decryptWithHexKey:(NSString*)hexKey hexIV:(NSString *)hexIV
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    if (data == nil) {
        return nil;
    }
    
    // Fetch key data and put into C string array padded with \0
    char *keyPtr;
    [NSString fillDataArray:&keyPtr length:kCCKeySizeAES128 + 1 usingHexString:hexKey];
    
    // Fetch iv data and put into C string array padded with \0
    if (hexIV.length == 0) {
        hexIV = HEX_IV;
    }
    char *ivPtr;
    [NSString fillDataArray:&ivPtr length:kCCKeySizeAES128 + 1 usingHexString:hexIV];
    
    // For block ciphers, the output size will always be less than or equal to the input size plus the size of one block because we add padding.
    // That's why we need to add the size of one block here
    NSUInteger dataLength = data.length;
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc( bufferSize );
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt( kCCDecrypt, kCCAlgorithmAES, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES128,
                                          ivPtr,
                                          [data bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted );
    free(keyPtr);
    free(ivPtr);
    
    if (cryptStatus == kCCSuccess)
    {
        // The returned NSData takes ownership of the buffer and will free it on deallocation
        NSData *decrypted = [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
        return [[NSString alloc] initWithData:decrypted encoding:NSUTF8StringEncoding];
    }
    
    free(buffer);
    return nil;
}
@end
