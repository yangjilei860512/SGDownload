//
//  SGDownloadTools.m
//  SGDownload
//
//  Created by Single on 2017/3/23.
//  Copyright © 2017年 single. All rights reserved.
//

#import "SGDownloadTools.h"

static NSString * HomeDirectoryRegexPattern = @"(\\w*-){4}(\\w*)";      // 98996CAA-7F3B-41A9-A651-9AB15D554E86

@implementation SGDownloadTools

+ (NSURL *)replacehHomeDirectoryForFileURL:(NSURL *)fileURL
{
    if (!fileURL) return nil;
    
    NSString * path = [self replacehHomeDirectoryForFilePath:fileURL.path];
    return [NSURL fileURLWithPath:path];
}

+ (NSString *)replacehHomeDirectoryForFilePath:(NSString *)filePath
{
    if (!filePath) return nil;
    
    NSError * error;
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:@"(\\w*-){4}(\\w*)" options:0 error:&error];
    if (!error) {
        NSTextCheckingResult * match = [regex firstMatchInString:filePath options:0 range:NSMakeRange(0, filePath.length)];
        if (match) {
            NSString * currentName = NSHomeDirectory().lastPathComponent;
            filePath = [filePath stringByReplacingCharactersInRange:match.range withString:currentName];
        }
    }
    return filePath;
}

+ (NSInteger)sizeWithFileURL:(NSURL *)fileURL
{
    if (!fileURL) return 0;
    
    NSError * error;
    NSDictionary <NSFileAttributeKey, id> * attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fileURL.path error:&error];
    if (!error || attributes.count > 0) {
        NSNumber * fileSize = [attributes objectForKey:NSFileSize];
        return fileSize.integerValue;
    }
    return 0;
}

+ (NSError *)removeFileWithFileURL:(NSURL *)fileURL
{
    if (!fileURL) return nil;
    
    NSError * error = nil;
    BOOL isDirectory = NO;
    BOOL result = [[NSFileManager defaultManager] fileExistsAtPath:fileURL.path isDirectory:&isDirectory];
    if (result && !isDirectory) {
        result = [[NSFileManager defaultManager] removeItemAtURL:fileURL error:&error];
    }
    return error;
}

@end
