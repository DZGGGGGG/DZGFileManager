//
//  FileModuleAchieve.h
//  HippyDemo
//
//  Created by mt010 on 2020/6/29.
//  Copyright © 2020 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileModuleAchieve : NSObject

+ (FileModuleAchieve*)defaultFileManager;
/* 判断文件是否存在 */
- (BOOL)fileExist:(NSString *)path;
/* 获取指定文件大小是否存在 */
- (NSInteger)getFileSize:(NSString *)path;
/* 获取指定路径文件列表 */
- (NSArray *)getFiles:(NSString *)folderPath;
/* 获取指定路径文件夹列表 */
- (NSArray *)getDirs:(NSString *)folderPath;
/* 新建文件夹 */
- (BOOL)makeDir:(NSString *)path;
/* 删除指定路径的文件 */
- (BOOL)deletePath:(NSString *)folderPath;
/* 写入指定文件内容 */
- (void)writeFile:(NSString *)filePath data:(NSString *)text append:(BOOL)isAppend;
/* 读取指定文件内容 */
- (void)readFile:(NSString *)path;
/* 压缩指定文件 */
- (void)zip:(NSString *)source target:(NSString *)target;
/* 压缩多个指定文件 */
- (void)zipFiles:(NSArray *)source target:(NSString *)target;
/* 解压指定压缩文件 */
- (void)unzip:(NSString *)source target:(NSString *)target;
@end

NS_ASSUME_NONNULL_END
