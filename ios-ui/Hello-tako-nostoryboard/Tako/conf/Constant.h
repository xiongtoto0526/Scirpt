//
//  Constant.h
//  HelloTako
//
//  Created by 熊海涛 on 16/2/25.
//  Copyright © 2016年 熊海涛. All rights reserved.
//


#ifndef Constant_h
#define Constant_h

#import "CocoaLumberjack.h"

// cocoahttpserver
#define HTTP_SERVER_PORT 12345

// screen
#define LAUNCH_SCREEN_TIME 2.0

// userinfo in userdefault
#define ALL_USER_ACCOUNT_KEY @"all_user_account"
#define USER_ACCOUNT_KEY @"user_account"

#define USER_ID_KEY @"user_id"
#define USER_TOKEN_KEY @"user_token"
#define USER_NAME_KEY @"user_name"
#define LOGIN_KEY @"is_tako_logined"
#define LOGIN_SUCCESS_KEY @"1"
#define LOGIN_FAILED_KEY @"0"
#define LOGIN_COOKIE_KEY @"user_cookie"

// appinfo in userdefault
#define DOWNLOADED_APP_INFO_KEY @"download_app_info"
#define IS_LOADD_BAR_VIEW_KEY @"is_load_bar_view"


// notification
#define CLICK_DOWNLOAD_BUTTON_NOTIFICATION @"click_download_button"
#define CLICK_DOWNLOAD_CANCEL_BUTTON_NOTIFICATION @"click_download_cancel_button"
#define CLICK_MORE_BUTTON_NOTIFICATION @"click_more_button"
#define CLICK_DETAIL_DOWNLOAD_BUTTON_NOTIFICATION @"click_detail_download_button"
#define USER_LOGOUT_NOTIFICATION @"user_logout_event"
#define APP_DELETE_NOTIFICATION @"app_delete_event"
#define APPLICATION_WILL_TERMINATE_NOTIFICATION @"application_will_terminate"
#define XHT_DOWNLOAD_PROGERSS_NOTIFICATION @"XHT_download_progress"
#define XHT_DOWNLOAD_FINISH_NOTIFICATION @"XHT_download_finish"
//#define APP_DOWNLOAD_FINISH_NOTIFICATION @"app_download_finish"// 仅用于通知app详情页

// notification key
#define CELL_INDEX_NOTIFICATION_KEY @"cellIndex"

// tag
#define CELL_FOR_TEST_PAGE_KEY 1
#define CELL_FOR_DOWNLOAD_MANAGE_PAGE_KEY 2

// download worker
#define MAX_DOWNLOAD_THREAD_COUNT 2

// tako server
#define TAKO_SERVER_KEY @"tako_server"
#define TAKO_SERVER_TIME_OUT 30
#define TAKO_DOWNLOAD_URL_TEST_TIME_OUT 3
#define TAKO_SERVER_APP_FETCH_SIZE @"10"
#define TAKO_SERVER_VERSION_FETCH_SIZE @"4"

// 调试开关
//#define IS_EXT_BUTTON_DISPLAY 1
//#define IS_CELL_EXT_BUTTON_DISPLAY 1

#define IS_APP_DETAIL_DISPLAY 1
#define IS_SIDE_MENU_ENABLE 1
#define IS_ADVANCE_SEARCH_ENABLE 1


// 支持 DDlog 
static const DDLogLevel ddLogLevel = DDLogLevelDebug;


// qa
#define TAKO_QA_SERVER_HOST @"http://qa.tako.im:28870/service"
#define TAKO_QA_APP_URL @"http://qa.tako.im:28870/takoios"

//oniste
#define TAKO_ONSITE_SERVER_HOST @"http://tako.im/service"
#define TAKO_ONSITE_APP_URL @"http://tako.im/takoios"


enum APPSTATUS{
    INITED = 0,
    STARTED,
    PAUSED,
    DOWNLOADED,
    DOWNLOADED_FAILED,
//    INSTALLING,
//    INSTALLED,
//    INSTALL_FAILED,
    TOBE_UPDATE,
};

#endif /* Constant_h */
