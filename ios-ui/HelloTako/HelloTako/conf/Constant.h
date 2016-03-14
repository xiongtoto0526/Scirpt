//
//  Constant.h
//  HelloTako
//
//  Created by 熊海涛 on 16/2/25.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

// cocoahttpserver
#define HTTP_SERVER_PORT 12345

// screen
#define LAUNCH_SCREEN_TIME 2.0

// userinfo in userdefault
#define USER_ACCOUNT_KEY @"user_account"
#define USER_TOKEN_KEY @"user_token"
#define USER_NAME_KEY @"user_name"
#define LOGIN_KEY @"is_tako_logined"
#define LOGIN_SUCCESS_KEY @"1"
#define LOGIN_FAILED_KEY @"0"

// appinfo in userdefault
#define DOWNLOADED_APP_INFO_KEY @"download_app_info"


// notification
#define CLICK_DOWNLOAD_BUTTON_NOTIFICATION @"click_download_button"
#define CLICK_DOWNLOAD_CANCEL_BUTTON_NOTIFICATION @"click_download_cancel_button"
#define APPLICATION_WILL_TERMINATE_NOTIFICATION @"application_will_terminate"
#define XHT_DOWNLOAD_PROGERSS_NOTIFICATION @"XHT_download_progress"
#define XHT_DOWNLOAD_FINISH_NOTIFICATION @"XHT_download_finish"

// notification key
#define CELL_INDEX_NOTIFICATION_KEY @"cellIndex"

// tag
#define CELL_FOR_TEST_PAGE_KEY 1
#define CELL_FOR_DOWNLOAD_MANAGE_PAGE_KEY 2

// download worker
#define MAX_DOWNLOAD_THREAD_COUNT 2

// tako server
//#define TAKO_SERVER_HOST @"http://qa.tako.im:28870/service"
#define TAKO_SERVER_HOST_KEY @"tako_server_host"
#define TAKO_SERVER_TIME_OUT 30
#define TAKO_SERVER_FETCH_SIZE @"10"

// 调试开关
#define IS_EXT_BUTTON_DISPLAY 1

enum APPSTATUS{
    INITED = 0,
    STARTED,
    PAUSED,
    DOWNLOADED,
    DOWNLOADED_FAILED,
    INSTALLING,
    INSTALLED,
    INSTALL_FAILED,
    TOBE_UPDATE,
};

#endif /* Constant_h */
