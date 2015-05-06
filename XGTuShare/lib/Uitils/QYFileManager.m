//
//  QYFileManager.m
//  QiYiVideo
//
//  Created by tiger on 11-11-9.
//  Copyright (c) 2011年 QiYi. All rights reserved.
//

#import "QYFileManager.h"
#import "QYDebug.h"
#import  "QYErrorCode.h"
#import "QYCoreMacros.h"
#import "QYUtil.h"
#import "QYUserConfig.h"
#import "NSURLAdditions.h"

@interface  QYFileManager(Private) 

- (NSString*)mediaFolder:(NSString*)media;
- (NSString*)filePath:(NSString*)media file:(NSString*)fileName;
- (void)fixedServerPort:(NSMutableString*)fileContent;

@end


@implementation QYFileManager
@synthesize mp4Path;
@synthesize tempDownloadPath;
-(id)init {

    self=[super init];
    if(self) {
        
        //[self creatDownloadMP4Path];
    }
    return self;
}

-(NSString*)creatMediaDir:(NSString*)relativePath {
    
    
    NSFileManager * fileManager=[NSFileManager defaultManager];
    
    //NSString * path=[NSString stringWithFormat:@"%@%@",DownloadBashPath,MP4Path];
    NSString * path=PathForLibraryResource(relativePath);
    BOOL isDir;
    if(![fileManager fileExistsAtPath:path isDirectory:&isDir]) {
        
        NSError *   error;
        if(![fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
            // QY_RELEASE_SAFELY(mp4Path);
            QYD_ERROR(@"Create Download directory[%@] error[%@]",path,[error localizedDescription]);
            return nil;//kDownloadPathMP4CreateError;
        }
        
    }
    QYD_INFO(@"the   path:%@", path);
    return  path;//kDownloadPathMP4CreateSuccess;
    
}
/*
 - (NSString*)createFolderForMedia:(NSString*)media {//此处media即为tvid
 
 NSString* path = [NSString stringWithFormat:@"%@%@", _basePath, media];
 NSFileManager* fileManager = [NSFileManager defaultManager];
 if ([fileManager fileExistsAtPath:path isDirectory:nil]) {
 [self deleteMedia:media];
 }
 if (![fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil]) {
 QYD_ERROR(@"创建文件目录失败！[%@]", path]);
 return nil;
 }
 QYD_ERROR(@"New Folder: %@", path);
 return path;
 }*/

- (BOOL)deleteMedia:(NSString*)media {//此处media即为tvid
	//删除索引中相关信息，目前应结构改变，功能失效
	//[self setResIndex:nil forKey:media];
	//删除本地中的文件夹
    NSString* relativePath = [NSString stringWithFormat:@"%@%@/%@",DownloadBashPath,M3U8Path,media];
    
    NSString * path=PathForLibraryResource(relativePath);
    
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSError* error = nil;
	if ([fileManager isDeletableFileAtPath:path]) {
		[fileManager removeItemAtPath:path error:&error];
		if (error) {
			QYD_ERROR(@"%@删除失败！",media);
			return NO;
		}
	}else {
		QYD_ERROR(@"不存在%@文件夹！", media);
		return NO;
	}
	return YES;
}
- (BOOL)deleteqsvMedia:(NSString*)fileName{
    NSString* relativePath = [NSString stringWithFormat:@"%@%@/%@",DownloadBashPath,qsvPath,fileName];
    
    NSString * path=PathForLibraryResource(relativePath);
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error = nil;
    if ([fileManager isDeletableFileAtPath:path]) {
        [fileManager removeItemAtPath:path error:&error];
        if (error) {
            QYD_ERROR(@"%@删除失败！",fileName);
            return NO;
        }
    }else {
        QYD_ERROR(@"不存在%@文件夹！", fileName);
        return NO;
    }
    return YES;
}

- (BOOL)deleteqsvtmpMedia:(NSString*)fileName{
    NSString* relativePath = [NSString stringWithFormat:@"%@/%@.qsv.temp",[QYFileManager getTempDownloadDir],fileName];
    
    NSString * path=PathForLibraryResource(relativePath);
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error = nil;
    if ([fileManager isDeletableFileAtPath:path]) {
        [fileManager removeItemAtPath:path error:&error];
        if (error) {
            QYD_ERROR(@"%@删除失败！",fileName);
            return NO;
        }
    }else {
        QYD_ERROR(@"不存在%@文件夹！", fileName);
        return NO;
    }
    return YES;
}

-(void)deletePPSDownloadFile:(NSString *)p2pFileName albumId:(NSString *)album_id
{
//    NSFileManager *manager  = [NSFileManager defaultManager];
//    NSString *folderPath = [[QYOfflineManager sharedInstance] pathForP2PDownloadAlbumID:album_id];
//    NSError *error = nil;
//    NSArray *fileList = [manager contentsOfDirectoryAtPath:folderPath error:&error];
//    for (NSString *str in fileList) {
//        if ([str hasPrefix:p2pFileName]) {
//            
//            NSString *aPath = [NSString stringWithFormat:@"%@/%@",folderPath,str];
//            [manager removeItemAtPath:aPath error:nil];
//        }
//    }
//    
//    NSArray *fileListA = [manager contentsOfDirectoryAtPath:folderPath error:&error];
//    if (fileListA.count<=0) {
//        [manager removeItemAtPath:folderPath error:nil];
//    }
}

- (BOOL)deleteMP4Media:(NSString*)fileName {
    
    NSString* relativePath = [NSString stringWithFormat:@"%@%@/%@",DownloadBashPath,MP4Path,fileName];
    
    NSString * path=PathForLibraryResource(relativePath);
    
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSError* error = nil;
	if ([fileManager isDeletableFileAtPath:path]) {
		[fileManager removeItemAtPath:path error:&error];
		if (error) {
			QYD_ERROR(@"%@删除失败！",fileName);
			return NO;
		}
	}else {
		QYD_ERROR(@"不存在%@文件夹！", fileName);
		return NO;
	}
	return YES;
}

- (BOOL)deleteMP4tmpMedia:(NSString*)fileName {
#if PLAY_KERNEL
    NSString* relativePath = [NSString stringWithFormat:@"%@%@.temp",[QYFileManager getTempDownloadDir],fileName];
#else
    NSString* relativePath = [NSString stringWithFormat:@"%@%@",TempDownloadPath,fileName];
#endif
    
    NSString * path=PathForLibraryResource(relativePath);
    
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSError* error = nil;
	if ([fileManager isDeletableFileAtPath:path]) {
		[fileManager removeItemAtPath:path error:&error];
		if (error) {
			QYD_ERROR(@"%@删除失败！",fileName);
			return NO;
		}
	}else {
		QYD_ERROR(@"不存在%@文件夹！", fileName);
		return NO;
	}
	return YES;
}



-(BOOL) clearMp4Medias {
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
	NSError* error = nil;
    NSString* relativePath = [NSString stringWithFormat:@"%@%@",DownloadBashPath,MP4Path];
    NSString * path=PathForLibraryResource(relativePath);
	if ([fileManager isDeletableFileAtPath:path]) {
		[fileManager removeItemAtPath:path error:&error];
		if (error) {
			QYD_ERROR(@"删除失败！");
			return NO;
		}
		//重新创建cccsite目录结构
		
		return YES;
	}else {
		QYD_ERROR(@"不存在文件夹！");
		return NO;
	}
    
    
    
}

- (BOOL)moveFileFrom :(NSString *)sourceFile to:(NSString *)targetFile //add by xiwen
{
	NSError * err;
    NSFileManager * meFileManager = [NSFileManager defaultManager];
    if ([meFileManager fileExistsAtPath:targetFile])
    {
        BOOL R = [meFileManager removeItemAtPath:targetFile error:&err];
        if (!R)
        return YES;
    }
    else if ([meFileManager fileExistsAtPath:sourceFile])
    {

        BOOL R = [meFileManager moveItemAtPath:sourceFile toPath:targetFile error:&err];
        if (!R)
        {
            QYD_INFO(@"移动失败了啊~~~");
            return NO;
        }
        return YES;
    }
    return NO;
}
- (BOOL)copyFileFrom:(NSString *)sourceFile to:(NSString *)targetFile //add by xiwen
{
	NSError * err;
    NSFileManager * meFileManager = [NSFileManager defaultManager];
    if ([meFileManager fileExistsAtPath:sourceFile])
    {
        
        BOOL R = [meFileManager copyItemAtPath:sourceFile toPath:targetFile error:&err];
        if (!R)
        {
            QYD_INFO(@"移动失败了啊~~~");
            return NO;
        }else{
             BOOL R = [meFileManager removeItemAtPath:sourceFile error:&err];
            if (R) {
                 QYD_INFO(@"移动成功了啊~~~");
            }
        }
        return YES;
    }
    return NO;
}

- (BOOL)clearMedias {
	//清除所有已下载的文件。cccsite文件夹删除
    
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSError* error = nil;
    NSString* relativePath = [NSString stringWithFormat:@"%@%@",DownloadBashPath,M3U8Path];
    NSString * path=PathForLibraryResource(relativePath);
	if ([fileManager isDeletableFileAtPath:path]) {
		[fileManager removeItemAtPath:path error:&error];
		if (error) {
			QYD_ERROR(@"删除失败！");
			return NO;
		}
		//重新创建cccsite目录结构
		
		return YES;
	}else {
		QYD_ERROR(@"不存在文件夹！");
		return NO;
	}
}

- (NSString*)mp4FilePath:(NSString*)mediaName {
    
	NSString* relativePath = [NSString stringWithFormat:@"%@%@/%@",DownloadBashPath,MP4Path,mediaName];
    
    NSString * path=PathForLibraryResource(relativePath);
    
	if (![self existsFileAtPath:path]) {
        
        QYD_ERROR(@"不存在文件！");
		//[self creatDir:media];
	}
	return path;
}
- (NSString*)qsvFilePath:(NSString*)mediaName {
    
    NSString* relativePath = [NSString stringWithFormat:@"%@%@/%@",DownloadBashPath,qsvPath,mediaName];
    
    NSString * path=PathForLibraryResource(relativePath);
    
    if (![self existsFileAtPath:path]) {
        
        QYD_ERROR(@"不存在文件！");
        //[self creatDir:media];
    }
    return path;
}

- (NSString*)oldMp4FilePath:(NSString*)mediaName{
    NSString* relativePath = [NSString stringWithFormat:@"%@%@/%@",DownloadBashPath,MP4Path,mediaName];
    
    NSString * path=PathForCachesResource(relativePath);
    
	if (![self existsFileAtPath:path]) {
        
        QYD_ERROR(@"不存在文件！");
		//[self creatDir:media];
        return nil;
	}
	return path;
    
}
- (NSString*)mediaFolder:(NSString*)media {
    
	NSString* relativePath = [NSString stringWithFormat:@"%@%@/%@",DownloadBashPath,M3U8Path,media];
    
    NSString * path=PathForLibraryResource(relativePath);
    
	if (![self existsFileAtPath:path]) {
        
        QYD_ERROR(@"不存在文件夹！");
		//[self creatDir:media];
	}
	return path;
}

- (NSString *)get_downloaded_file_path:(NSString*)media_name //add by xiwen
{
#if PLAY_KERNEL
    NSString * relative_path = [NSString stringWithFormat:@"%@%@/%@",DownloadBashPath,qsvPath,media_name];
#else
	NSString * relative_path = [NSString stringWithFormat:@"%@%@/%@",DownloadBashPath,MP4Path,media_name];
#endif
	NSString * real_path = PathForLibraryResource(relative_path);
	return real_path;
}
- (NSString *)get_downloaded_qvs_file_path:(NSString*)media_name //add by xiwen
{
    NSString * relative_path = [NSString stringWithFormat:@"%@%@/%@",DownloadBashPath,qsvPath,media_name];
    NSString * real_path = PathForLibraryResource(relative_path);
    return real_path;
}

- (NSString *)get_temp_file_path:(NSString*)media_name;		//add by xiwen
{
	NSString * relative_path = [NSString stringWithFormat:@"%@/%@",TempDownloadPath,media_name];
	NSString * real_path = PathForLibraryResource(relative_path);
	return real_path;
}

- (NSString *)get_m3u8_done_path:(NSString *)m3u8_tvid; //old file  //add by xiwen
{
	NSString * relative_path = [NSString stringWithFormat:@"%@/%@/%@",M3u8_old_path,m3u8_tvid,@"play.m3u8"];
	NSString * real_path = PathForLibraryResource(relative_path);
	return real_path;
}

- (NSString *)get_m3u8_folder_path:(NSString *)m3u8_tvid; //old file  //add by xiwen
{
	NSString * relative_path = [NSString stringWithFormat:@"%@/%@",M3u8_old_path,m3u8_tvid];
	NSString * real_path = PathForLibraryResource(relative_path);
	return real_path;
}


- (NSString*)filePath:(NSString*)media file:(NSString*)fileName {
	NSString* fileFolder = [self mediaFolder:media];
	NSString* path = [fileFolder stringByAppendingPathComponent:fileName];
	if ([self existsFileAtPath:path]) {
		return path;
	}
	QYD_WARNING(@"指定文件不存在：%@",path);
	return nil;
}


//获取将要播放的media的文件路径。在这里要对play.m3u8文件进行处理：制作实时IP域名，并copy保存到本地，文件以当前IP命名。
- (NSString*)playMediaPath:(NSString*)media {
	NSString* filePath = nil;
	NSString* mediaPath = [self filePath:media file:PLAYM3U8];
	if (mediaPath) {
		NSMutableString* fileContent = [NSMutableString stringWithContentsOfFile:mediaPath usedEncoding:nil error:nil];
        
		NSMutableString* IP = [NSMutableString stringWithString:IPAddr_WiFi()];
		[IP replaceOccurrencesOfString:@"." withString:@"_" options:NSCaseInsensitiveSearch range:NSMakeRange(0, IP.length-1)];
		NSString* fileFolder = [self mediaFolder:media];
		filePath = [NSString stringWithFormat:@"%@/%@.m3u8", fileFolder, IP];
		if ([self existsFileAtPath:filePath]) {
			NSMutableString* rawFile = [NSMutableString stringWithContentsOfFile:filePath usedEncoding:nil error:nil];
			[self fixedServerPort:rawFile];
			if (rawFile.length == fileContent.length) {
				return filePath;
			}
            
		}
		[self fixedServerPort:fileContent];
		[fileContent replaceOccurrencesOfString:[[QYUserConfig standardUserConfig] loadUserInfoForAttribute:kHost]
									 withString:IPAddr_WiFi() options:NSCaseInsensitiveSearch range:NSMakeRange(0, fileContent.length-1)];
		NSError* error = nil;
		[fileContent writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
		if (error) {
			QYD_ERROR(@"创建播放的.m3u8文件[%@]失败",filePath);
			return nil;
		}
		
	}
	return filePath;
}


#pragma mark === 为解决２.０到>２.０版本后由于端口改变而造成无法正常播放的问题 ===

- (void)fixedServerPort:(NSMutableString*)fileContent {
	QYUserConfig* sharedSetting = [QYUserConfig standardUserConfig];
	NSString* host = [sharedSetting loadUserInfoForAttribute:kHost];
	NSString* port = [sharedSetting loadUserInfoForAttribute:kPort];
	NSMutableString* IPStr = [[NSMutableString alloc] initWithString:IPAddr_WiFi()];
	[IPStr replaceOccurrencesOfString:@"." withString:@"_" options:NSCaseInsensitiveSearch range:NSMakeRange(0, IPStr.length-1)];
	
	NSString* wrongDomain01 = @"http://localhost:8080";
	NSMutableString* wrongDomain02 = [NSMutableString stringWithFormat:@"http://%@:8080", IPStr];
	NSString* correctDomain01 = [NSString stringWithFormat:@"http://%@:%@", host, port];
	NSString* correctDomain02 = [NSString stringWithFormat:@"http://%@:%@", IPStr, port];
	[IPStr release];
	NSArray* contentItems = [fileContent componentsSeparatedByString:@"\n"];
	for (NSString* item in contentItems) {
		if ([item hasPrefix:@"http://localhost:"]) {
			if ([item hasPrefix:wrongDomain01]) {
				[fileContent replaceOccurrencesOfString:wrongDomain01 
											 withString:correctDomain01
												options:NSCaseInsensitiveSearch 
												  range:NSMakeRange(0, fileContent.length-1)];
			}
			return;
		}
		if ([item hasPrefix:[NSString stringWithFormat:@"http://%@:", IPAddr_WiFi()]]) {
			if ([item hasPrefix:wrongDomain02]) {
				[fileContent replaceOccurrencesOfString:wrongDomain02 
											 withString:correctDomain02
												options:NSCaseInsensitiveSearch 
												  range:NSMakeRange(0, fileContent.length-1)];
			}
			return;
		}
	}
}


- (BOOL)existsFileAtPath:(NSString*)path
{
	NSFileManager* fileManager = [NSFileManager defaultManager];
	return [fileManager fileExistsAtPath:path];
}

-(void)_finalizition {
    
    // QY_RELEASE_SAFELY(mp4Path);
    // QY_RELEASE_SAFELY(tempDownloadPath);
}

+ (NSString *)getFileAttr:(NSString*)fileName andPath:(NSString *)inputPath
{
    //NSString* relativePath = [NSString stringWithFormat:@"%@/%@",inputPath,fileName];
    NSString* relativePath = [inputPath stringByAppendingPathComponent:fileName];
    
    NSString * path=PathForLibraryResource(relativePath);
    NSURL *fileUrl = [NSURL fileURLWithPath:path];
    [fileUrl urlShouldSkipBackup:YES];
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSError* error = nil;
    NSMutableDictionary * reDict = [NSMutableDictionary dictionary];
	if ([fileManager fileExistsAtPath:path])
    {
        [reDict setDictionary:[fileManager attributesOfItemAtPath:path error:&error]];
		if (error)
        {
			QYD_ERROR(@"%@失败！",fileName);
		}
        else
        {
            NSString* reString = [NSString stringWithFormat:@"%@",[reDict objectForKey:@"NSFileSize"]];
            return reString;
        }
	}
    else
    {
//		QYD_ERROR(@"不存在%@文件！", fileName);
	}
    return @"0";
    
}

- (BOOL)checkFileExisted:(NSString*)filePath
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    BOOL R = [fileManager fileExistsAtPath:filePath];
    return R;
}

- (BOOL)check_and_create_folder:(NSString*)dest_path
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:dest_path])
    {
        return YES;
    }
    else
    {
        NSError * err = nil;
        [fileManager createDirectoryAtPath:dest_path withIntermediateDirectories:NO attributes:nil error:&err];
        if (err)
        {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isdocmp4
{
    NSFileManager * fmanager = [NSFileManager defaultManager];
    NSArray * arr =  [fmanager contentsOfDirectoryAtPath:PathForDocumentsResource(nil) error:nil];
    for (NSString * files in arr)
    {
        if ([[files lowercaseString] hasSuffix:@"mp4"])
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isdocqsv
{
    NSFileManager * fmanager = [NSFileManager defaultManager];
    NSArray * arr =  [fmanager contentsOfDirectoryAtPath:PathForDocumentsResource(nil) error:nil];
    for (NSString * files in arr)
    {
        if ([[files lowercaseString] hasSuffix:@"qsv"])
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL)copy_subfiles:(NSString *)source_path
            dest_path:(NSString *)dest_path
{
    NSFileManager * fmanager = [NSFileManager defaultManager];
    NSArray * arr =  [fmanager contentsOfDirectoryAtPath:source_path error:nil];
    BOOL R = YES;
    for (NSString * file_name in arr)
    {
        NSError * err = nil;
        NSString * s_path = [NSString stringWithFormat:@"%@/%@",source_path, file_name];
        NSString * d_path = [NSString stringWithFormat:@"%@/%@",dest_path, file_name];
        [fmanager copyItemAtPath:s_path toPath:d_path error:&err];
        if (err)
        {
            R = NO;
            QYD_ERROR(@"%@",err);
        }
    }
    return R;
}

+ (NSString*)getTempDownloadDir{
#ifdef PLAY_KERNEL
    return [NSString stringWithFormat:@"%@%@",DownloadBashPath,qsvPath];
#else
    return TempDownloadPath;
#endif
}

+ (NSString*)getTVIDName:(NSString*)tvid isTemp:(BOOL)isTemp{
#ifdef PLAY_KERNEL
    if (isTemp) {
        return [NSString stringWithFormat:@"%@.qsv.temp", tvid];
    }else{
        return tvid;
    }
#else
    return tvid;
#endif
}

+(NSString *)f4vAllFileSizeWithAlbumId:(NSString *)album_id fileName:(NSString *)p2pFilename
{
    float size = 0.0;;
    NSError *error = nil;
    
    NSString* downloadDir=[NSString stringWithFormat:@"%@%@",DownloadBashPath,PFVPath];
    QYFileManager * fileManager=[QYFileManager sharedInstance];
    NSString *mmovieFolder = [fileManager creatMediaDir:downloadDir];
    NSString *mdirectoryPath = [NSString stringWithFormat:@"%@/%@_videos/",mmovieFolder,album_id];
    
    NSFileManager *ffileManager = [NSFileManager defaultManager];
    NSArray *fileList = [ffileManager contentsOfDirectoryAtPath:mdirectoryPath error:&error];
    for (NSString *str in fileList) {
        if ([str hasPrefix:p2pFilename]) {
            NSDictionary *dic = [[NSFileManager defaultManager] attributesOfItemAtPath:[NSString stringWithFormat:@"%@/%@",mdirectoryPath,str] error:nil];
            float sizeC = [[dic objectForKey:NSFileSize] intValue];
            size += sizeC;
        }
    }
    return [NSString stringWithFormat:@"%.1f",size];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
static QYFileManager* sharedInstance = nil;

@implementation QYFileManager(QYFileManagerSingleton)

////////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)sharedInstance {
	@synchronized(self) {
		if (nil == sharedInstance) {
			sharedInstance = [[self alloc] init];
		}
	}
	return sharedInstance;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (oneway void)superRelease {
	[self _finalizition];
	[super release];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)releaseSharedInstance {
	@synchronized(self) {
		[sharedInstance superRelease];
		sharedInstance = nil;
	}
}


////////////////////////////////////////////////////////////////////////////////////////////////////
// Ensure that [TTEntityTables alloc] returns the singleton object.
+ (id)allocWithZone:(NSZone*)zone {
	@synchronized(self) {
		if (nil == sharedInstance) {
			sharedInstance = [super allocWithZone:zone];
		}
	}
	
	return sharedInstance;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)copyWithZone:(NSZone *)zone {
	return sharedInstance;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)retain {
	return sharedInstance;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (unsigned)retainCount {
	return NSUIntegerMax;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (oneway void)release {
	// Do nothing.
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)autorelease {
	return sharedInstance;
}
@end
