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

#define LAUNCH_SCREEN_TIME 2.0

// user default
#define USER_ACCOUNT_KEY @"user_account"
#define USER_TOKEN_KEY @"user_token"
#define USER_NAME_KEY @"user_name"
#define LOGIN_KEY @"is_tako_logined"
#define LOGIN_SUCCESS_KEY @"1"
#define LOGIN_FAILED_KEY @"0"
#define APP_VERSION_KEY @"app_version"

#define DOWNLOADED_APP_INFO_KEY @"downlaod_app_info"
#define DOWNLOADED_APP_VERSION_KEY @"downloaded_app_version"
#define DOWNLOAD_APPID_KEY @"downlaod_appid"
#define DOWNLOAD_PASSWORD_KEY @"download_password"
#define DOWNLOAD_TOTAL_LENGTH_KEY @"download_total_length"
#define DOWNLOAD_CURRENT_LENGTH_KEY @"download_current_length"
#define DOWNLOAD_STATUS_KEY @"downlaod_status"
// notification
#define LOGIN_BACK_TO_USER_NOTIFICATION @"login_back_to_user"
#define CLICK_DOWNLOAD_BUTTON_NOTIFICATION @"click_download_button"
#define CLICK_DOWNLOAD_CANCEL_BUTTON_NOTIFICATION @"click_download_cancel_button"
#define LOGIN_BACK_TO_TEST_NOTIFICATION @"login_back_to_test"
#define DOWNLAOD_MANAGE_PAGE_FINISH_NOTIFICATION @"download_manage_page_finish"

// notification key
#define CELL_INDEX_NOTIFICATION_KEY @"cellIndex"
#define DOWNLOAD_RESULT_KEY @"download_result"
#define DOWNLOAD_PROGRESS_KEY @"download_progress"
#define DOWNLOAD_TAG_KEY @"download_tag"

// download worker
#define MAX_DOWNLOAD_THREAD_COUNT 1

// tako server
#define TAKO_SERVER_HOST @"http://qa.tako.im:28870/service"
#define TAKO_SERVER_HOST_KEY @"tako_server_host"
#define TAKO_SERVER_TIME_OUT 30


// 0 停止下载，1 下载中，2下载成功，3下载失败
enum DOWNLOADSTATUS{
    DOWNLOAD_STOP = 0,
    DOWNLOAD_START,
    DOWNLOAD_PAUSE,
    DOWNLOAD_FINISH_SUCCESS,
    DOWNLOAD_FINISH_FAIL,
};

#endif /* Constant_h */
