//
//  YKGetDataTaskManger.h
//  LYKAFN
//
//  Created by 凯 on 16/5/19.
//  Copyright © 2016年 凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Reachability.h"
typedef void(^YKBlockWithBlackDataSuccess)(id responseObject);
typedef void(^YKBlockWithBlackDataFail)(NSError * error);


@interface YKDataTaskManger : NSObject

#define IsOnline [YKDataTaskManger shareNetworkManger].isOnline;

#define IsWifi [YKDataTaskManger shareNetworkManger].isWifi;

#pragma mark - 关于网络状态的方法
/**
 *  是否有网络
 */
@property (nonatomic ,assign,getter=isOnline) BOOL isOnline;
/**
 *  是否为3G或者4G网络
 */
@property (nonatomic, assign,getter=isMobileNetwork) BOOL isMobileNetwork;
/**
 *  是否为Wifi网络
 */
@property (nonatomic ,assign,getter=isWifi)BOOL isWifi;




@property (nonatomic, strong) Reachability *conn;






#pragma mark - 关于网络请求的方法

/**
 *  基于AFN3.0通过GET方式请求一个网络数据,多用于小型数据的请求.
 *
 *  @param url        请求的地址URL
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param fail       请求失败的回调
 */
+(void)GetDataTaskWithUrl:(NSString *) url withParameters:(NSDictionary *)parameters withSuccess:(YKBlockWithBlackDataSuccess)success withFail:(YKBlockWithBlackDataFail)fail;



/**
 *  基于AFN3.0通过POST方式请求一个网络数据,多用于小型数据的请求.
 *
 *  @param url        请求的地址URL
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param fail       请求失败的回调
 */
+(void)PostDataTaskWithUrl:(NSString *) url withParameters:(NSDictionary *)parameters withSuccess:(YKBlockWithBlackDataSuccess)success withFail:(YKBlockWithBlackDataFail)fail;



/**
 *  基于AFN3.0请求一个网络数据,多用于大型数据的请求,并将数据保存在本地,支持断点续传.
 *
 *  @param style        请求的方式,GET或者POST
 *  @param url          请求的地址
 *  @param parameters   请求的参数
 *  @param success      成功的回调
 *  @param fail         失败的回调
 *  @param dataTask     传入一个dataTask
 *  @param DocumentsURL 文件存储的本地地址url
 *  @param progressView 文件下载的进度
 */
+(void)DownloadDataTaskwithStyle:(NSString *)style WithUrl:(NSString *) url withParameters:(NSDictionary *)parameters withSuccess:(YKBlockWithBlackDataSuccess)success withFail:(YKBlockWithBlackDataFail)fail withDataTask:(NSURLSessionDownloadTask*)dataTask withDocumentsDirectoryURL:(NSURL*)DocumentsURL withProgressView:(UIProgressView *)progressView;

/**
 *  基于AFN3.0请求一个网络数据,多用于大型数据的请求,断点续传.
 *
 *  @param data         上次下载的文件
 *  @param success      成功的回调(返回文件下载的地址)
 *  @param fail         失败的回调
 *  @param dataTask     传dataTask
 *  @param DocumentsURL 文件存储的本地地址url
 *  @param progressView 文件下载的进度
 */
+(void)DownloadDataTaskWithResumeData:(NSData *)data withSuccess:(YKBlockWithBlackDataSuccess)success withFail:(YKBlockWithBlackDataFail)fail withDataTask:(NSURLSessionDownloadTask*)dataTask withDocumentsDirectoryURL:(NSURL*)DocumentsURL withProgressView:(UIProgressView *)progressView;



/**
 *  网络状态管理
 *
 *  @return 网络状态管理对象
 */
+(instancetype)shareNetworkManger;


@end
