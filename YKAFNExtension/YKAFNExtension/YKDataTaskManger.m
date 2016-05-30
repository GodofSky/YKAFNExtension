//
//  YKGetDataTaskManger.m
//  LYKAFN
//
//  Created by 凯 on 16/5/19.
//  Copyright © 2016年 凯. All rights reserved.
//  基于AFN3.0方法获取数据

#import "YKDataTaskManger.h"





@implementation YKDataTaskManger


+(instancetype)shareNetworkManger
{
    static YKDataTaskManger *sharedAPI;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedAPI = [[self alloc] init];
        //添加检测网络的通知
        [[NSNotificationCenter defaultCenter] addObserver:sharedAPI selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];
        sharedAPI.conn = [Reachability reachabilityForInternetConnection];
        
        [sharedAPI.conn startNotifier];
        //检测网络
        [sharedAPI networkStateChange];
        
    });
    return sharedAPI;
}


- (void)networkStateChange
{
    // 1.检测wifi状态
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    
    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    
    // 3.判断网络状态
    if ([wifi currentReachabilityStatus] != NotReachable) { // 有wifi
        self.isOnline= YES;
        self.isWifi = YES;
        if ([conn currentReachabilityStatus] != NotReachable)
        {
            self.isMobileNetwork = YES;
        }
        else
        {
            self.isMobileNetwork = NO;
        }
        
        
    } else if ([conn currentReachabilityStatus] != NotReachable) { // 没有使用wifi, 使用手机自带网络进行上网
        self.isOnline = YES;
        self.isMobileNetwork = YES;
        self.isWifi = NO;
        
    } else { // 没有网络
        
        self.isOnline = NO;
        self.isMobileNetwork = NO;
        self.isWifi = NO;
    }
}


+(void)GetDataTaskWithUrl:(NSString *) url withParameters:(NSDictionary *)parameters withSuccess:(YKBlockWithBlackDataSuccess)success withFail:(YKBlockWithBlackDataFail)fail
{
    
    
 NSMutableURLRequest * request =   [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:url parameters:parameters error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    AFHTTPResponseSerializer * res = manager.responseSerializer;
    res.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    
    
  NSURLSessionDataTask *dataTask =   [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error) {
            if (fail) {
                fail(error);
            }
            
        } else {
            if (success) {
                success(responseObject);
            }
        }
        
    }];
    [dataTask resume];
    
}


+(void)PostDataTaskWithUrl:(NSString *) url withParameters:(NSDictionary *)parameters withSuccess:(YKBlockWithBlackDataSuccess)success withFail:(YKBlockWithBlackDataFail)fail
{
    
    
    NSMutableURLRequest * request =   [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:parameters error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    AFHTTPResponseSerializer * res = manager.responseSerializer;
    res.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    
    
    NSURLSessionDataTask *dataTask =   [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error) {
            if (fail) {
                fail(error);
            }
            
        } else {
            if (success) {
                success(responseObject);
            }
        }
        
    }];
    [dataTask resume];
    
}

+(void)DownloadDataTaskwithStyle:(NSString *)style WithUrl:(NSString *) url withParameters:(NSDictionary *)parameters withSuccess:(YKBlockWithBlackDataSuccess)success withFail:(YKBlockWithBlackDataFail)fail withDataTask:(NSURLSessionDownloadTask*)dataTask withDocumentsDirectoryURL:(NSURL*)DocumentsURL withProgressView:(UIProgressView *)progressView
{
    
    
    NSMutableURLRequest * request =   [[AFHTTPRequestSerializer serializer] requestWithMethod:style URLString:url parameters:parameters error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    
    dataTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //Update the progress view
            if (progressView) {
                 [progressView setProgress:downloadProgress.fractionCompleted];
            }
           
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [DocumentsURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (error) {
            if (fail) {
                fail(error);
            }
            
        } else {
            if (success) {
                success(filePath);
            }
        }

        
    }];
    [dataTask resume];
    
    
    
}

+(void)DownloadDataTaskWithResumeData:(NSData *)data withSuccess:(YKBlockWithBlackDataSuccess)success withFail:(YKBlockWithBlackDataFail)fail withDataTask:(NSURLSessionDownloadTask*)dataTask withDocumentsDirectoryURL:(NSURL*)DocumentsURL withProgressView:(UIProgressView *)progressView
{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    dataTask = [manager downloadTaskWithResumeData:data progress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //Update the progress view
            if (progressView) {
                [progressView setProgress:downloadProgress.fractionCompleted];
            }
            
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
          return [DocumentsURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        
        if (error) {
            if (fail) {
                fail(error);
            }
            
        } else {
            if (success) {
                success(filePath);
            }
        }
        
    }];
}



-(void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
