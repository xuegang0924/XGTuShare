/*******************************************************
 * Copyright (C) 2014 iQIYI.COM - All Rights Reserved
 *
 * This file is part of puma.
 * Unauthorized copy of this file, via any medium is strictly prohibited.
 * Proprietary and Confidential./../../../../puma/trunk/puma/common/
 *
 * Authors: dengzhimin <likaikai@qiyi.com>
 *
 *******************************************************/

#ifndef pumasdkimp_pumastructs_h
#define pumasdkimp_pumastructs_h
#import "enums.h"

typedef struct
{
	/**
     *平台
     */
    QiyiPlatform platform;
    
    /**print_in_console, 是否控制台输出，
     *对于windows 控制ontputdebugstring，
     *对于android 控制logcat 输出
     *对于ios， mac，控制控制台输出
     */
    bool print_in_console;
    
	/**
     *用于APP设置log输出路径,绝对路径含文件名
     */
	char log_path_file[1024];
    
	/**
     *用于APP设置Player配置文件路径，绝对路径不含文件名，如果路径下有config.xml则使用，没有则从网络中获取
     */
	char config_path[1024];
    /*
     * [must]广告缓存路径, 路径必须要存在
     */
    char ad_cache_path[1024];
    
    /**
     *  
     */
    char external_module_path[1024];


} PumaInitPlayerParam;


#endif
