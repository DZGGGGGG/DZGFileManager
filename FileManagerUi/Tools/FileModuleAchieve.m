//
//  FileModuleAchieve.m
//  HippyDemo
//
//  Created by mt010 on 2020/6/29.
//  Copyright © 2020 tencent. All rights reserved.
//

#import "FileModuleAchieve.h"
#import "SSZipArchive.h"

@implementation FileModuleAchieve

+ (FileModuleAchieve *)defaultFileManager{
    static FileModuleAchieve *manager = nil;
       static dispatch_once_t predicate;
       dispatch_once(&predicate, ^{
           manager = [[self alloc] init];
       });
       return manager;
}
/*
 @Param ::
    path(String) :
        绝对路径
 @Describe :
    判断文件路径是否存在
 */
- (BOOL)isFileExist:(NSString *)path{
    NSFileManager *filemgr = [NSFileManager defaultManager]; //文件资源管理
        BOOL isDirectory = NO;
        BOOL result = [filemgr fileExistsAtPath:path isDirectory:&isDirectory];
        if (result){
            NSLog(@"文件存在");
            if (isDirectory) {
                NSLog(@"文件夹路径存在 但不是文件路径");
                return true;
            }else{
                NSLog(@"文件路径存在");
                return true;
            }
        }
        else{
            NSLog(@"给出的路径不存在");
            return false;
        }
}
- (BOOL)fileExist:(NSString *)path{
    NSFileManager *filemgr = [NSFileManager defaultManager]; //文件资源管理
    NSString * Localhostpath = [ToolsClass localhostUrlChange:path];

    BOOL result = [filemgr fileExistsAtPath:Localhostpath];
    return result;
}
/*
 @Param ::
    path(String) :
        前端传输的特殊路径格式 例如 data://test/1.png data://代表着根目录 后面的路径代表着根目录下的文件夹
    encoding(String) :
        读取文件的编码格式
 @Describe：
    获取指定文件的内容的同步方法；使用需谨慎，若读取的数据较多会导致UI卡顿
 */
- (void)readFileSync:(NSString *)path{
    // 字符串读取的方法
    if(![self isFileExist:path]){
        //判断路径是否存在
        return;
    }
    //判断文件是否可读
    BOOL isRead;
    NSFileManager *filemgr = [NSFileManager defaultManager]; //文件资源管理
    isRead = [filemgr isReadableFileAtPath:path];
    if (isRead) {
        NSLog(@"这个文件++++可读++++ ");
    }else{
        NSLog(@"这个文件++++不可读++++");
    }
    NSString *resultStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"resultStr is %@", resultStr);
}

/*
 @Param ::
    path(String) :
        前端传输的特殊路径格式 例如 data://test/1.png data://代表着根目录 后面的路径代表着根目录下的文件夹
 @Describe：
    获取目标文件大小
 */
- (NSInteger)getFileSize:(NSString *)path{
    NSString *localFilePath = [ToolsClass localhostUrlChange:path];
    if(![self isFileExist:localFilePath]){
        //判断路径是否存在
        return 0;
    }
    NSFileManager *filemgr = [NSFileManager defaultManager]; //文件资源管理
    NSDictionary *dic = [filemgr attributesOfItemAtPath:localFilePath error:nil];
    NSLog(@"该文件的大小%lld",[dic[@"NSFileSize"] longLongValue]);
    return [dic[@"NSFileSize"] longLongValue];
}

/*
 @Param ::
    folderPath(String) :
        前端传输的特殊路径格式 例如 data://test/1.png data://代表着根目录 后面的路径代表着根目录下的文件夹
 @Describe：
    获取指定目录下的所有文件(不包含文件夹) 不包含子孙文件及文件夹
 */
- (NSArray *)getFiles:(NSString *)folderPath{
    NSString *localFolderPath = [ToolsClass localhostUrlChange:folderPath];
    if(![self isFileExist:localFolderPath]){
        //判断路径是否存在
        return @[@"路径不存在"];
    }
    //创建信号量
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    __block NSMutableArray *result = [NSMutableArray new];
    
    NSFileManager *filemgr = [NSFileManager defaultManager]; //文件资源管理
    NSError *erroe = nil;
    //使用contentsOfDirectoryAtPath方法获取路径下的文件及文件夹
    NSArray *children =  [filemgr contentsOfDirectoryAtPath:localFolderPath error:&erroe];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        for (NSString *item in children) {
               NSString * subPath = nil;
               //子文件或者子文件夹的路径
               subPath  = [localFolderPath stringByAppendingPathComponent:item];
               BOOL issubDir = NO;
               [filemgr fileExistsAtPath:subPath isDirectory:&issubDir];
               //如果不是文件夹的话
               if (!issubDir){
                   [result addObject:item];
               }
               NSLog(@"%@",item);
           }
        //信号量+1
        dispatch_semaphore_signal(signal);
           NSLog(@"%@",result);
    });
    //信号量等待
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    NSArray *result1 = [[NSArray alloc] initWithArray:result];
    return result1;
   
}
/*
 @Param ::
    folderPath(String) :
        前端传输的特殊路径格式 例如 data://test/1.png data://代表着根目录 后面的路径代表着根目录下的文件夹
 @Describe：
    获取指定目录下的所有文件夹(不包含文件) 不包含子孙文件及文件夹
 */
- (NSArray *)getDirs:(NSString *)folderPath{
    NSString *localFolderPath = [ToolsClass localhostUrlChange:folderPath];
    if(![self isFileExist:localFolderPath]){
        //判断路径是否存在
        return @[@"路径不存在"];
    }
    
    //创建信号量
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    __block NSMutableArray *result = [NSMutableArray new];
    
    NSFileManager *filemgr = [NSFileManager defaultManager]; //文件资源管理
    NSError *erroe = nil;
    //使用contentsOfDirectoryAtPath方法获取路径下的文件及文件夹
    NSArray *children =  [filemgr contentsOfDirectoryAtPath:localFolderPath error:&erroe];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        for (NSString *item in children) {
            NSString * subPath = nil;
            //子文件或者子文件夹的路径
            subPath  = [localFolderPath stringByAppendingPathComponent:item];
            BOOL issubDir = NO;
            [filemgr fileExistsAtPath:subPath isDirectory:&issubDir];
            //如果不是文件夹的话
            if (issubDir){
                [result addObject:item];
            }
            NSLog(@"%@",item);
        }
        //信号量+1
        dispatch_semaphore_signal(signal);
    });
    //信号量等待
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    NSArray *result1 = [[NSArray alloc] initWithArray:result];
    return result1;
}

/*
 @Param ::
    folderPath(String) :
        前端传输的特殊路径格式 例如 data://test/1.png data://代表着根目录 后面的路径代表着根目录下的文件夹
 @Describe：
    删除指定目录以及这个目录下所有目录和文件，
 */
- (BOOL)deletePath:(NSString *)folderPath{
    NSString *localFolderPath = [ToolsClass localhostUrlChange:folderPath];
    if(![self isFileExist:localFolderPath]){
        //判断路径是否存在
        return false;
    }
    //创建信号量
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    __block BOOL isSuccess = false;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        NSFileManager *filemgr = [NSFileManager defaultManager]; //文件资源管理
        NSError *error = nil;
        isSuccess = [filemgr removeItemAtPath:localFolderPath error:&error];
        //信号量+1
        dispatch_semaphore_signal(signal);
    });
    //信号量等待
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    return isSuccess;
    
}

/*
@Param ::
   path(String) :
       前端传输的特殊路径格式 例如 data://test/1.png data://代表着根目录 后面的路径代表着根目录下的文件夹
@Describe：
   获取指定文件的内容
*/
- (void)readFile:(NSString *)path HippyPromiseResolveBlock:(HippyPromiseResolveBlock)callback HippyPromiseRejectBlock:(HippyPromiseRejectBlock)failar{
    NSString *localFilePath = [ToolsClass localhostUrlChange:path];
    if(![self isFileExist:localFilePath]){
        //判断路径是否存在
        failar(@"-1",@"文件不存在",nil);
        return;
    }
    //判断文件是否可读
    BOOL isRead;
    NSFileManager *filemgr = [NSFileManager defaultManager]; //文件资源管理
    isRead = [filemgr isReadableFileAtPath:localFilePath];
    if (isRead) {
        NSLog(@"这个文件++++可读++++ ");
    }else{
        NSLog(@"这个文件++++不可读++++");
        failar(@"-1",@"文件不可读",nil);
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *resultStr = [NSString stringWithContentsOfFile:localFilePath encoding:NSUTF8StringEncoding error:nil];
           NSLog(@"resultStr is %@", resultStr);
        callback(resultStr);
    });
}

/*
@Param ::
   path(String) :
       前端传输的特殊路径格式 例如 data://test/1.png data://代表着根目录 后面的路径代表着根目录下的文件夹
   data(String) :
       需要写入文件的内容字符串
   isAppend(Boolean) :
       是否以追加方式写文件
@Describe：
   获取指定文件的内容
*/ //没搞定
- (void)writeFile:(NSString *)filePath data:(NSString *)text append:(BOOL)isAppend HippyPromiseResolveBlock:(HippyPromiseResolveBlock)callback HippyPromiseRejectBlock:(HippyPromiseRejectBlock)failar{
    
    NSString *localFilePath = [ToolsClass localhostUrlChange:filePath];
    if(![self isFileExist:localFilePath]){
        //判断路径是否存在
        failar(@"-1",@"文件不存在",nil);
        return;
    }
    __block BOOL isSuccess = false;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
          NSFileManager *filemgr = [NSFileManager defaultManager]; //文件资源管理
          BOOL isWrite;
          isWrite = [filemgr isWritableFileAtPath:localFilePath];
          if (isWrite) {
              NSLog(@"这个文件或者文件夹----可写----");
          }else{
              NSLog(@"这个文件或者文件夹----不可写----");
              failar(@"-1",@"文件不可写",nil);
          }
          NSString *string = text;
          // 字符串写入时执行的方法
        if (isAppend){
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:localFilePath];
            [fileHandle seekToEndOfFile];  //将节点跳到文件的末尾
            NSData* stringData  = [string dataUsingEncoding:NSUTF8StringEncoding];
            [fileHandle writeData:stringData]; //追加写入数据
            [fileHandle closeFile];
            callback(nil);
        }else{
            isSuccess = [string writeToFile:localFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
            callback(nil);
        }
          
    });
    
}
/*
@Param ::
   path(String) :
       目标地址
@Describe：
   创建文件夹
*/
- (BOOL)makeDir:(NSString *)path{
    NSFileManager *filemgr = [NSFileManager defaultManager]; //文件资源管理
    NSString *localTargetPath = [ToolsClass localhostUrlChange:path];
    
    return [filemgr createDirectoryAtPath:localTargetPath withIntermediateDirectories:YES attributes:nil error:nil];
}
/*
@Param ::
   source(String) :
       文件资源地址
   target(String) :
       压缩后目标资源地址
@Describe：
   压缩单个指定文件或者文件夹
*/
- (void)zip:(NSString *)source target:(NSString *)target{
    NSString *localSource = [ToolsClass localhostUrlChange:source];
    NSString *localTarget = [ToolsClass localhostUrlChange:target];
    if(![self isFileExist:localSource]){
        //判断路径是否存在
        return;
    }
    NSFileManager *filemgr = [NSFileManager defaultManager]; //文件资源管理
    BOOL isDirectory = false;
    __block BOOL isSuccess = false;
    //试文件夹
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL result = [filemgr fileExistsAtPath:localSource isDirectory:&isDirectory];
          if (result){
              NSLog(@"文件存在");
              if (isDirectory) {
                  NSLog(@"文件夹路径存在");
                  //文件夹压缩
                  isSuccess = [SSZipArchive createZipFileAtPath:localTarget withContentsOfDirectory:localSource];
              }else{
                  //文件压缩
                  NSLog(@"文件路径存在");
                  isSuccess = [SSZipArchive createZipFileAtPath:localTarget withFilesAtPaths:@[localSource]];
              }
          }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"执行结束");
            
        });
    });
}

/*
@Param ::
   source(Array) :
       文件资源地址
   target(String) :
       压缩后目标资源地址
@Describe：
   压缩单个指定文件或者文件夹
*/
- (void)zipFiles:(NSArray *)source target:(NSString *)target{
    //将地址转换
    NSMutableArray *sourceArray = [NSMutableArray new];
    for (NSString *url in source) {
        [sourceArray addObject:[ToolsClass localhostUrlChange:url]];
    }
    NSString *localTarget = [ToolsClass localhostUrlChange:target];
    __block BOOL isSuccess = false;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        isSuccess = [SSZipArchive createZipFileAtPath:localTarget withFilesAtPaths:sourceArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"执行结束");
        });
    });
}


/*
@Param ::
   source(string) :
       文件资源地址
   target(String) :
       解压缩后目标资源地址
@Describe：
   指定的路径
*/
- (void)unzip:(NSString *)source target:(NSString *)target{
    
    NSFileManager *filemgr = [NSFileManager defaultManager]; //文件资源管理
    NSError *error;
    
    NSString *localSource = [ToolsClass localhostUrlChange:source];
    NSString *localTarget = [ToolsClass localhostUrlChange:target];
    if(![self isFileExist:localTarget]){
        //判断路径是否存在
        if(![filemgr createDirectoryAtPath:localTarget withIntermediateDirectories:YES attributes:nil error:&error])
        {
            NSLog(@"Failed to create cache directory at %@", localTarget);
            target = nil;
        }
    }
    __block BOOL isSuccess = false;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        isSuccess = [SSZipArchive unzipFileAtPath:localSource toDestination:localTarget];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"执行结束");
        });
    });
}

@end
