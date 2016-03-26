//
//  PortDefine.h
//  Sahara
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 scjy. All rights reserved.
//

#ifndef PortDefine_h
#define PortDefine_h
#define kWBAppKey @"2015788699"
#define kRedirectURL @"https://api.weibo.com/oauth2/default.html"
#define kWXAppKey @"wx2beb0c528b7fe7d0"
#define kMapKey @"ab84ece8092b73db9355fb53da0603c5"
//首页segement

#define kSegementort @"http://mrobot.pcauto.com.cn/configs/pcauto_v4_cms_android_channel_tree"
//找车接口
#define kFindCar @"http://mrobot.pcauto.com.cn/v2/price/brands?v=4.0.0"
#define kHotBrand @"http://mrobot.pcauto.com.cn/configs/pcauto_hot_brands"
#define kCarPrice @"http://mrobot.pcauto.com.cn/v3/price/modelLibraryHomePage?"
#define kHotCar @"http://mrobot.pcauto.com.cn/buy/price/hotSellSerials/"
#define kCarSummarize @"http://mrobot.pcauto.com.cn/xsp/s/auto/info/v4.7/serials.xsp?serialId="
#define kConfig @"http://mrobot.pcauto.com.cn/v3/price/detailComparev45?serialId="

#define kSegementPort @"http://mrobot.pcauto.com.cn/configs/pcauto_v4_cms_android_channel_tree"
#define kArticle @"http://mrobot.pcauto.com.cn/v3/price/getNewestInfoListBySerialId/"
#define kArticleDetail @"http://www.pcauto.com.cn/pingce/558/5588099.html"
//http://www.pcauto.com.cn/pingce/558/5588099.html
#define kComment @"http://mrobot.pcauto.com.cn/v3/price/serialCommentList/"
#define kCarForum @"http://mrobot.pcauto.com.cn/v3/bbs/newForumsv45/"
#define kCarImage @"http://mrobot.pcauto.com.cn/v2/price/nav_picturesv47?serialGroupId="
#define kStore @"http://mrobot.pcauto.com.cn/v3/price/dealersSerialv45?serialId="
#define kPrivilege @"http://mrobot.pcauto.com.cn/v3/price/promotionList?areaId=268&pageNo=1&pageSize=20&orderBy=discountRange&serialId="
#define kStoreDetail @"http://mrobot.pcauto.com.cn/v3/price/dealersDetailv45?"
#define kAreaID @"http://mrobot.pcauto.com.cn/v2/cms/area_tree?order=alpha"

//首页cell
#define kHomePagePort @"http://mrobot.pcauto.com.cn/v2/cms/channels/"
//首页详情
#define kDetailFront @"http://mrobot.pcauto.com.cn/v3/cms/articles/"
#define kDetailPort @"articleTemplate=4.8.0&app=pcautobrowser&channelId=9&serialId=0&size=18&picRule=2"
//直播详情
#define kTomLive @"http://mrobot.pcauto.com.cn/v3/zbDetail?order=0&size=18"
//直播另一种详情
#define kLiveOther @"http://mrobot.pcauto.com.cn/v2/bbs/topics/"
#define kOtherPort @"pageNo=1&pageSize=19&authorId=0&topicTemplate=4.5.0&app=pcautobrowser&picRule=2&size=18"
//直播评论
#define kCommentPort @"http://mrobot.pcauto.com.cn/v3/cmt/get_newest_floor?"
#define kApprisePort @"http://mrobot.pcauto.com.cn/xsp/s/auto/info/xueChe/newTopics.xsp?support=1&reverse=0"
#define kTypeIDPort @"http://cmt.pcauto.com.cn/templates/pcauto/getPartList.jsp?url=http://live.pcauto.com.cn/broadRecord.jsp?"
//违章查询
#define kCheckPort @"http://www.zonghengche.com/ad/pcautoweizhang/app/weizhang.html"
//bmob
#define kBmobKey @"94f1100bc7e5eebe98292eea9b012494"

#endif /* PortDefine_h */
