//
//  Constant.h
//  HelloTako
//
//  Created by 熊海涛 on 16/2/25.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

// http
#define HTTP_SERVER_PORT 12345

#define LAUNCH_SCREEN_TIME 2.0

// user default
#define USER_ACCOUNT_KEY @"user_account"
#define USER_TOKEN_KEY @"user_token"
#define USER_NAME_KEY @"user_name"
#define LOGIN_KEY @"is_logined"
#define LOGIN_SUCCESS_KEY @"1"
#define LOGIN_FAILED_KEY @"0"
#define APP_VERSION_KEY @"app_version"
#define APP_VERSION_CREATE_TIME_KEY @"app_version_create_time"

#define DOWNLOADED_APP_VERSION_KEY @"downloaded_app_version"
#define DOWNLOAD_APPID_KEY @"downlaod_appid"
#define DOWNLOAD_PASSWORD_KEY @"download_password"
#define DOWNLOAD_TOTAL_LENGTH_KEY @"download_total_length"
#define DOWNLOAD_CURRENT_LENGTH_KEY @"download_current_length"

// notification
#define LOGIN_BACK_TO_USER_NOTIFICATION @"login_back_to_user"
#define CLICK_DOWNLOAD_BUTTON_NOTIFICATION @"click_download_button"
#define CLICK_DOWNLOAD_CANCEL_BUTTON_NOTIFICATION @"click_download_cancel_button"
#define LOGIN_BACK_TO_TEST_NOTIFICATION @"login_back_to_test"
#define CELL_INDEX_NOTIFICATION_KEY @"cellIndex"

// download worker
#define MAX_DOWNLOAD_THREAD_COUNT 1

// tako server
#define TASKO_SERVER_HOST @"http://qa.tako.im:28870/service"
#define TASKO_SERVER_TIME_OUT 30

#endif /* Constant_h */
