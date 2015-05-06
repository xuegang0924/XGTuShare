#pragma once 
// errno定义：

  //101：vrs vd访问超时
#define error_code_vd_Time_out  101

  //102：vrs vd访问出错
#define error_code_vd_acc_failed  102

  //103：vrs vd数据异常
#define error_code_vd_data_error  103

  //104：vrs vd状态码不在[100，200]时，表示未授权观看
#define error_code_vd_unauthorize  104

//105 vrs 返回的数据逻辑上有问题
#define error_code_vd_data_logic_erorr 105

  //201:meata 访问超时（针对系统播放器，是关键路径）
#define error_code_meta_timeout  201

  //202:meata 访问出错（针对系统播放器，是关键路径）
#define error_code_meta_acc_failed  202

  //203:meata 数据异常（针对系统播放器，是关键路径)
#define error_code_meta_data_error  203

  //501: 会员签权 超时
#define error_code_authorize_timeout  501

  //502：会员签权 出错
#define error_code_authorize_exception  502

  //503: 签权结果数据异常
#define error_code_authorize_data_error  503

  //504：会员签权不通过
#define error_code_authorize_unauthorize  504

//505 用户密码已更改，请重新登录（只针对奇艺用户）
#define error_code_authorize_password_changed 505

// VIP验证超时
#define error_code_vip_auth_timeout 601
// VIP验证出错
#define error_code_vip_auth_failed 602
// VIP验证结果数据异常
#define error_code_vip_auth_data_error 603
// VIP验证不通过
#define error_code_vip_auth_unauthorize 604

  //播放内核内部使用
#define error_model_create_failed 3000

  //3101：取key超时
#define error_code_get_key_timeout  3101

  //3102：取Key出错（网络错误）
#define error_code_get_key_net_error  3102

  //3103：取Key返回数据异常
#define error_code_get_key_data_error  3103

  //3201：调度超时
#define error_code_schedule_timeout  3201

  //3202：调度出错
#define error_code_schedule_error  3202

  //3203：调度返回数据异常
#define error_code_schedule_data_error  3203

  //4011: 连接超时（用户连接不了CDN或网络过慢而超时）；
#define error_code_network_timeout  4011

  //4012: 连接错误 (通常由于网络原因所致，比如用户网络断开，服务器返回大于400错误信息)
#define error_code_network_error  4012

  //4016: 视频数据文件格式不正确(不是合法的FLV文件)
#define error_code_video_data_error  4016

//打开本地文件失败（包含qsv,pfv）
#define error_open_local_failed 4017

// 直播时发生错误
#define error_code_live_error 4018
// 直播连接错误
#define error_code_live_connect_error 4019
//直播获取源数据失败
#define error_code_live_read_error 4020
//直播库报错
#define error_code_live5_error 4021

// p2p错误
#define error_code_p2p_error 8100

//p2p常见错误分类

//p2p服务未初始化
#define error_p2p_service_not_load  8101

//p2p创建任务失败
#define error_p2p_create_task_failed  8102

//p2p激活失败（连续不上peer,下载不了数据，或网络问题）
#define error_p2p_active_failed  8103

//p2p连接超时
#define error_p2p_connect_timeout  8104

//其它p2p错误
#define error_p2p_common_failed  8105

//p2p kernel上报此影片为地域限制 ，无法播放
#define error_p2p_area_limit  8106



//播放器致命错误
#define error_code_fatal_error (655360)


// VRS  VP/NP 
//接口返回值， 该值实际对应的是VRS 返回值中的 st 字段， 
//为了区别现播放内核现有的错误码，将该值赋值为负值，
