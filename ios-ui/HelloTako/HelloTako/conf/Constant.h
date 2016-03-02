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
//#define USER_IMAGE_KEY @"user_image"
#define LOGIN_KEY @"is_logined"
#define LOGIN_SUCCESS_KEY @"1"
#define LOGIN_FAILED_KEY @"0"
#define DOWNLOADED_APP_KEY @"downloaded_app"
#define APP_VERSION_KEY @"app_version"
#define APP_VERSION_CREATE_TIME_KEY @"app_version_create_time"
#define CURRENT_LENGTH_KEY @"current_length"
#define APPID_KEY @"appid"
#define TOTAL_LENGTH_KEY @"total_length"

// notification
#define LOGIN_BACK_TO_USER_NOTIFICATION @"login_back_to_user"
#define CLICK_DOWNLOAD_BUTTON_NOTIFICATION @"click_download_button"
#define CLICK_DOWNLOAD_CANCEL_BUTTON_NOTIFICATION @"click_download_cancel_button"
#define LOGIN_BACK_TO_TEST_NOTIFICATION @"login_back_to_test"
#define CELL_INDEX_NOTIFICATION_KEY @"cellIndex"

// download
#define MAX_DOWNLOAD_THREAD_COUNT 1

// tako server
#define TASKO_SERVER_HOST @"http://qa.tako.im:28870/service"
#define TASKO_SERVER_TIME_OUT 30

#endif /* Constant_h */
