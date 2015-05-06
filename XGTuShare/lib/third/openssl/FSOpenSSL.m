//
//  FSOpenSSL.m
//
//
//  Created by wangdaoqin on 26.08.2014.
//


/*
 填充原理是 ：就是PKCS5Padding，这个能实现的相当少，自己实现原理如下：
 
 AES一般是16个字节为一块，然后对这一整块进行加密，如果输入的字符串不够16个字节，就需要补位，
 
 PKCS5Padding：填充的原则是，如果长度少于16个字节，需要补满16个字节，补(16-len)个(16-len)例如：
 
 huguozhen这个节符串是9个字节，16-9= 7,补满后如：huguozhen+7个十进制的7
 
 如果字符串长度正好是16字节，则需要再补16个字节的十进制的16。
 */


#import "FSOpenSSL.h"
#include <openssl/md5.h>
#include <openssl/sha.h>
#import <openssl/evp.h>
#import <openssl/aes.h>
@implementation FSOpenSSL

+ (NSString *)md5FromString:(NSString *)string {
    unsigned char *inStrg = (unsigned char *) [[string dataUsingEncoding:NSASCIIStringEncoding] bytes];
    unsigned long lngth = [string length];
    unsigned char result[MD5_DIGEST_LENGTH];
    NSMutableString *outStrg = [NSMutableString string];

    MD5(inStrg, lngth, result);

    unsigned int i;
    for (i = 0; i < MD5_DIGEST_LENGTH; i++) {
        [outStrg appendFormat:@"%02x", result[i]];
    }
    return [outStrg copy];
}

+ (NSString *)sha256FromString:(NSString *)string {
    unsigned char *inStrg = (unsigned char *) [[string dataUsingEncoding:NSASCIIStringEncoding] bytes];
    unsigned long lngth = [string length];
    unsigned char result[SHA256_DIGEST_LENGTH];
    NSMutableString *outStrg = [NSMutableString string];

    SHA256_CTX sha256;
    SHA256_Init(&sha256);
    SHA256_Update(&sha256, inStrg, lngth);
    SHA256_Final(result, &sha256);

    unsigned int i;
    for (i = 0; i < SHA256_DIGEST_LENGTH; i++) {
        [outStrg appendFormat:@"%02x", result[i]];
    }
    return [outStrg copy];
}

+ (NSString *)base64FromString:(NSString *)string encodeWithNewlines:(BOOL)encodeWithNewlines {
    BIO *mem = BIO_new(BIO_s_mem());
    BIO *b64 = BIO_new(BIO_f_base64());

    if (!encodeWithNewlines) {
        BIO_set_flags(b64, BIO_FLAGS_BASE64_NO_NL);
    }
    mem = BIO_push(b64, mem);

    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger length = stringData.length;
    void *buffer = (void *) [stringData bytes];
    NSUInteger bufferSize = (NSUInteger) (long) MIN(length, (NSUInteger) INT_MAX);

    NSUInteger count = 0;

    BOOL error = NO;

    // Encode the data
    while (!error && count < length) {
        int result = BIO_write(mem, buffer, (int)bufferSize);
        if (result <= 0) {
            error = YES;
        }
        else {
            count += result;
            buffer = (void *) [stringData bytes] + count;
            bufferSize = (NSUInteger) MIN((length - count), (NSUInteger) INT_MAX);
        }
    }

    int flush_result = BIO_flush(mem);
    if (flush_result != 1) {
        return nil;
    }

    char *base64Pointer;
    NSUInteger base64Length = (NSUInteger) BIO_get_mem_data(mem, &base64Pointer);

    NSData *base64data = [NSData dataWithBytesNoCopy:base64Pointer length:base64Length freeWhenDone:NO];
    NSString *base64String = [[NSString alloc] initWithData:base64data encoding:NSUTF8StringEncoding];

    BIO_free_all(mem);
    return base64String;
}
+(NSString *)AES_CBC_PCKCS5Padding:(NSString *)string
{//加密
    AES_KEY aes;
    unsigned char key[17] = "3e3acd08bb05bb1d";//密匙
    unsigned char iv[17] = "bb05bb1d3e3acd08";//向量
    unsigned char* input_string; //要加密的数据
    unsigned char* encrypt_string;//加密后的数据
    unsigned char* decrypt_string;//解密后的数据
    unsigned long len;        // encrypt length (in multiple of AES_BLOCK_SIZE)
    unsigned int strsize; //数据长度
    
    
    strsize = (unsigned int)strlen([string UTF8String]);
    NSLog(@"strsize == %d",strsize);
    
    //    fstream file;
    //    file.open(path, ios_base::in | ios_base::out | ios_base::binary);
    //    if (false == file.good()) {
    //    }
    // set the encryption length
    len = 0;
    
    if (strsize% AES_BLOCK_SIZE == 0)
    {
        len = (strsize / AES_BLOCK_SIZE + 1) * AES_BLOCK_SIZE;
        input_string = (unsigned char*)calloc(len, sizeof(unsigned char));
        memset(input_string,AES_BLOCK_SIZE,len);
    }
    else
    {
        if (strsize<16) {
            len =  1 * AES_BLOCK_SIZE;
            input_string = (unsigned char*)calloc(len, sizeof(unsigned char));
            int len_temp = (int)len - strsize;
            memset(input_string,len_temp,len);
        }
        else
        {
        len = (strsize / AES_BLOCK_SIZE + 1) * AES_BLOCK_SIZE;
        input_string = (unsigned char*)calloc(len, sizeof(unsigned char));
        int len_temp = (int)len - strsize;
        memset(input_string,len_temp,len);
        }
    }

    NSLog(@"len == %ld",len);
    // set the input string
    
    if (input_string == NULL) {
        //        fprintf(stderr, "Unable to allocate memory for input_string\n");
        NSLog(@"Unable to allocate memory for input_string");
        exit(-1);
    }
    strncpy((char*)input_string, [string UTF8String], strsize);
    
    if (AES_set_encrypt_key(key, 128, &aes) < 0) {
        NSLog(@"Unable to set encryption key in AES");
        //        fprintf(stderr, "Unable to set encryption key in AES\n");
        exit(-1);
    }
    // alloc encrypt_string
    encrypt_string = (unsigned char*)calloc(len, sizeof(unsigned char));
    if (encrypt_string == NULL) {
        NSLog(@"Unable to allocate memory for encrypt_string");
        exit(-1);
    }
    // encrypt (iv will change)
    AES_cbc_encrypt(input_string, encrypt_string, len, &aes, iv, AES_ENCRYPT);
    
    // alloc decrypt_string
    decrypt_string = (unsigned char*)calloc(len, sizeof(unsigned char));
    if (decrypt_string == NULL) {
        NSLog(@"Unable to allocate memory for decrypt_string");
        exit(-1);
    }
    
    
    if (AES_set_decrypt_key(key, 128, &aes) < 0) {
        NSLog(@"Unable to set decryption key in AES");
        exit(-1);
    }
    //unsigned char iv2[17] = {'f','e','d','c','b','a','9','8','7','6','5','4','3','2','1','0','\0'};
    
    // decrypt
    AES_cbc_encrypt(encrypt_string, decrypt_string, len, &aes, iv,
                    AES_DECRYPT);
    
    // print
    NSLog(@"input_string");
    for (int i = 0; i<len;i++)
    {
         NSLog(@"%x",input_string[i]);
    }
         NSLog(@"\n");
         NSLog(@"encrypted string =");
         for (int i = 0; i<len;i++)
         {
              //        NSLog(@"%x%x",(encrypt_string[i] >> 4) & 0xf,
              //              encrypt_string[i] & 0xf);
             
             //        printf("%x%x", (encrypt_string[i] >> 4) & 0xf,
             //               encrypt_string[i] & 0xf);
              printf("%X",encrypt_string[i]);
             
        }
              printf("\n");
    
   // NSLog(@"decrypted string = %s\n",decrypt_string);
    
    NSMutableString *restring = [NSMutableString stringWithCapacity:50];
          for (int i = 0; i<len;i++)
               {
                   //        NSLog(@"%x",decrypt_string[i]);
                   NSString *tmp = [[NSString alloc]initWithFormat:@"%x%x",(encrypt_string[i] >> 4) & 0xf,encrypt_string[i] & 0xf];
                   [restring appendString:tmp];
               }
    NSLog(@"restring == %@",restring);
    
    return restring;
}

+(NSString *)AES_CBC_PCKCS5PaddingEncrypt:(NSString *)string
{
    AES_KEY aes;
    unsigned char key[17] = "3e3acd08bb05bb1d";//密匙
    unsigned char iv[17] = "bb05bb1d3e3acd08";//向量
    unsigned char* input_string; //要加密的数据
    unsigned char* encrypt_string;//加密后的数据
    unsigned long len;        // encrypt length (in multiple of AES_BLOCK_SIZE)
    unsigned int strsize; //数据长度
    
    strsize = (unsigned int)strlen([string UTF8String]);//NSLog(@"strsize == %d",strsize);
    // set the encryption length
    len = 0;
    if (strsize% AES_BLOCK_SIZE == 0)
    {
        len = (strsize / AES_BLOCK_SIZE + 1) * AES_BLOCK_SIZE;
        input_string = (unsigned char*)calloc(len, sizeof(unsigned char));
        memset(input_string,AES_BLOCK_SIZE,len);
    }
    else
    {
        if (strsize<16) {
            len =  1 * AES_BLOCK_SIZE;
            input_string = (unsigned char*)calloc(len, sizeof(unsigned char));
            int len_temp = (int)len - strsize;
            memset(input_string,len_temp,len);
        }
        else
        {
            len = (strsize / AES_BLOCK_SIZE + 1) * AES_BLOCK_SIZE;
            input_string = (unsigned char*)calloc(len, sizeof(unsigned char));
            int len_temp = (int)len - strsize;
            memset(input_string,len_temp,len);
        }
    }// NSLog(@"len == %ld",len);
    
   
    // set the input string
    
    if (input_string == NULL) {//        fprintf(stderr, "Unable to allocate memory for input_string\n");
        NSLog(@"Unable to allocate memory for input_string");
        return nil;
    }
    strncpy((char*)input_string, [string UTF8String], strsize);
    
    if (AES_set_encrypt_key(key, 128, &aes) < 0) {
        NSLog(@"Unable to set encryption key in AES");
        //        fprintf(stderr, "Unable to set encryption key in AES\n");
        return nil;
    }
    // alloc encrypt_string
    encrypt_string = (unsigned char*)calloc(len, sizeof(unsigned char));
    if (encrypt_string == NULL) {
        NSLog(@"Unable to allocate memory for encrypt_string");
       return nil;
    }
    // encrypt (iv will change)
    AES_cbc_encrypt(input_string, encrypt_string, len, &aes, iv, AES_ENCRYPT);
    
    for (int i = 0; i<len;i++)
    {
        NSLog(@"%x",encrypt_string[i]);
    }
    NSLog(@"\n");
    
    NSMutableString *restring = [NSMutableString stringWithCapacity:50];
    for (int i = 0; i<len;i++)
    {
        NSString *tmp = [[NSString alloc]initWithFormat:@"%x%x",(encrypt_string[i] >> 4) & 0xf,encrypt_string[i] & 0xf];
        [restring appendString:tmp];
    }
    NSLog(@"encrypted string == %@",restring);
    return restring;
    
//    unsigned char iv1[17] = "bb05bb1d3e3acd08";//向量
//    
//    decrypt_string = (unsigned char*)calloc(len, sizeof(unsigned char));
//    if (decrypt_string == NULL) {
//        NSLog(@"Unable to allocate memory for decrypt_string");
//        return nil;
//    }
//    if (AES_set_decrypt_key(key, 128, &aes) < 0) {
//        NSLog(@"Unable to set decryption key in AES");
//        return nil;
//    }
//    
//    AES_cbc_encrypt(encrypt_string, decrypt_string, len, &aes, iv1,
//                    AES_DECRYPT);
    
}

//+(NSString *)AES_CBC_PCKCS5PaddingDECRYPT:(NSString *)string
//{
//    AES_KEY aes;
//    unsigned char key[17] = "3e3acd08bb05bb1d";//密匙
//    unsigned char iv[17] = "bb05bb1d3e3acd08";//向量
//    unsigned char* input_string; //要解密的数据
//    unsigned char* decrypt_string;//解密后的数据
//    unsigned long len;        // encrypt length (in multiple of AES_BLOCK_SIZE)
//    len=strlen([string UTF8String])/2;
//    
//    
//    const char *stringChar=[string UTF8String];
//    input_string = (unsigned char*)calloc(len, sizeof(unsigned char));
//    
//    for (int i=0; i<len; i++) {
//        input_string[i]=(stringChar[i] << 4) | (stringChar[i+1] & 0x0f);
//    }
//    
//  //  strncpy((char*)input_string, [string UTF8String], len);
//    
//    
//    
//    
//    decrypt_string = (unsigned char*)calloc(len, sizeof(unsigned char));
//    if (decrypt_string == NULL) {
//        NSLog(@"Unable to allocate memory for decrypt_string");
//       return nil;
//    }
//    if (AES_set_decrypt_key(key, 128, &aes) < 0) {
//        NSLog(@"Unable to set decryption key in AES");
//        return nil;
//    }
//    
//    AES_cbc_encrypt(input_string, decrypt_string, len, &aes, iv,
//                    AES_DECRYPT);
//
//    NSData *data=[NSData dataWithBytes:decrypt_string length:len];
//    
//    
//    NSString *restring = [[NSString alloc] initWithBytes:[data bytes] length:len encoding:NSUTF8StringEncoding];
////    for (int i = 0; i<len/2;)
////    {
////        NSString *tmp = [[NSString alloc]initWithFormat:@"%c",(decrypt_string[i] << 4) | (decrypt_string[i+1] & 0x0f)];
////        [restring appendString:tmp];
////        i+=2;
////    }
//     printf("decrypted string = %s\n", decrypt_string);
//    
//    
//    
//    return nil;
//
//    
//}



@end