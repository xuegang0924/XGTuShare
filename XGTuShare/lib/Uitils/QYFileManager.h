//
//  QYFileManager.h
//  QiYiVideo
//
//  Created by tiger on 11-11-9.
//  Copyright (c) 2011年 QiYi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define  DownloadBashPath   @".download/"
//#define  DownloadCachePath @"
#define  MP4Path            @"mp4"
#define  qsvPath            @"qsv"
#define  M3U8Path           @"m3u8"
#define  TempDownloadPath   @".temp/"
#define  DownloadM3U8       @"download.m3u8"
#define  PLAYM3U8           @"play.m3u8"
#define  M3u8_old_path      @"cccsite"
#define  PFVPath            @"pfv"
#define  P2PPath            @"p2p"

#define kSDimage_folder    @"ImageCache"


#define ABSOLUTEMP4PATH  DownloadBashPath@"mp4"
#define ABSOLUTEqsvPATH  DownloadBashPath@"qsv"

@interface QYFileManager : NSObject {

    @public
    NSString*  mp4Path;
    NSString*  tempDownloadPath;

}
@property(nonatomic,copy)NSString*  mp4Path;
@property(nonatomic,copy)NSString*  tempDownloadPath;
//-(int)creatDownloadMP4Path;
//-(int)creatTempDownloadPath; 
/*
 *  移动文件 (改名）
 */
- (BOOL)moveFileFrom:(NSString *)sourceFile to:(NSString *)targetFile;
- (BOOL)copyFileFrom:(NSString *)sourceFile to:(NSString *)targetFile;

- (NSString*)creatMediaDir:(NSString*)relativePath;
- (NSString*)mp4FilePath:(NSString*)mediaName;
- (NSString*)oldMp4FilePath:(NSString*)mediaName;
- (NSString*)qsvFilePath:(NSString*)mediaName;
- (NSString*)playMediaPath:(NSString*)media;
- (BOOL)existsFileAtPath:(NSString*)path;
- (BOOL)deleteMP4Media:(NSString*)fileName;
- (BOOL)deleteMP4tmpMedia:(NSString*)fileName;
- (BOOL)deleteqsvMedia:(NSString*)fileName;
- (BOOL)deleteqsvtmpMedia:(NSString*)fileName;
- (BOOL)checkFileExisted:(NSString*)filePath;
- (BOOL)deleteMedia:(NSString*)media;
+ (NSString *)getFileAttr:(NSString*)fileName andPath:(NSString *)inputPath;
- (BOOL)clearMedias;
- (BOOL)clearMp4Medias;

- (NSString *)get_downloaded_file_path:(NSString*)media_name;
- (NSString *)get_downloaded_qvs_file_path:(NSString*)media_name;
- (NSString *)get_temp_file_path:(NSString*)media_name;
- (NSString *)get_m3u8_done_path:(NSString *)m3u8_tvid;
- (NSString *)get_m3u8_folder_path:(NSString *)m3u8_tvid; //old file  //add by xiwen


- (BOOL)copy_subfiles:(NSString *)source_path
            dest_path:(NSString *)dest_path;

- (BOOL)isdocmp4;
- (BOOL)isdocqsv;

- (BOOL)check_and_create_folder:(NSString*)dest_path;

/**
 *  基线直接返回tvid, 大播放内核返回
 */
+ (NSString*)getTVIDName:(NSString*)tvid isTemp:(BOOL)isTemp;

/**
 *  基线返回TempDownloadPath; 大播放内核返回DownloadBashPath;
 */
+ (NSString*)getTempDownloadDir;

+(NSString *)f4vAllFileSizeWithAlbumId:(NSString *)album_id fileName:(NSString *)p2pFilename;
@end

@interface QYFileManager(QYFileManagerSingleton) 

/*
 * Access the singleton instance: [[QYFileManager sharedInstance] <methods>]
 */
+ (QYFileManager*)sharedInstance;
/*
 * Release the shared instance.
 */
+(void)releaseSharedInstance;

@end