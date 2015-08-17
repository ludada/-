//
//  URLMacro.h
//  FasterRunner
//
//  Created by HLKJ on 15-4-27.
//  Copyright (c) 2015年 HLKJ. All rights reserved.
//


#pragma mark - 网络请求(这里是全部的网络请求)

// 域名
#define HTTP_NET @"http://123.57.61.27:8080"      //衡联

//#define HTTP_NET @"http://123.57.222.175:8080"  //快跑

// 1 引导页查询
//type:1=引导页 2=商圈广告位 3=快跑商城广告位
//返回值:imgUrl：图片地址


#define ONLINE [NSString stringWithFormat:@"%@/runfast/UsersAction!usersOnline.action?", HTTP_NET]


#define POST_ADVERTISE [NSString stringWithFormat:@"%@/runfast/GraphicAction!graphicGuidePage.action?", HTTP_NET]
    
//2 获取地址列表
#define POST_ADRESS(id) [NSString stringWithFormat:@"%@/runfast/AdressAction! AdressAction.action?",HTTP_NET]

//3 获取商圈类型列表
#define GET_STORE_TYPE [NSString stringWithFormat:@"%@/runfast/BusinessCircleAction!businessCircleList.action", HTTP_NET]

//4  商铺店面列表
//id是商圈id
#define POST_STORE_LIST [NSString stringWithFormat:@"%@/runfast/BusinessStoreAction! businessStoreList.action?", HTTP_NET]

//5  商铺店面详情
//id是商圈店面id
#define POST_STORE_DETAIL [NSString stringWithFormat:@"%@/runfast/BusinessStoreAction!businessStoreView.action?", HTTP_NET]

//6  优惠券列表
#define POST_COUPONS_LIST [NSString stringWithFormat:@"%@/runfast/CouponsAction!couponsList.action?", HTTP_NET]

//7 优惠券兑换
#define POST_COUPONS_RECORD(coupId,custId,points) [NSString stringWithFormat:@"%@/runfast/CouponsRecordAction!couponsRecordAdd.action?",HTTP_NET]

//8 快跑商城（推荐、本地生活、精品购物、搜索）
#define POST_FASTERRUNNER_STORES [NSString stringWithFormat:@"%@/runfast/CouponsAction!couponsView.action?", HTTP_NET]

//9 注册、登录、忘记密码（用户）
//
#define POST_LOGIN_REGIST_FORGET [NSString stringWithFormat:@"%@/runfast/CustomerAction!customerLogin.action?", HTTP_NET]

//10 修改密码（用户）
#define POST_USER_CHANGE_PASSWORD(id,password) [NSString stringWithFormat:@"%@/runfast/CustomerAction!customerEditPassWord.action?", HTTP_NET]

//11、注册、登录、修改密码（服务者）(三合一)

//12、获取用户资料
#define POST_USER_INFO [NSString stringWithFormat:@"%@/runfast/CustomerAction!customerList.action?", HTTP_NET]

//13、编辑资料
#define POST_EDIT_USER [NSString stringWithFormat:@"%@/runfast/CustomerAction!customerSaveEdit.action?", HTTP_NET]


//14、发送信息添加（语音、文本）
#define POST_SEND_MESSAGE [NSString stringWithFormat:@"%@/runfast/VoiceMessagesAction!voiceMessagesAdd.action?", HTTP_NET]

//15、确认发出（订单添加）
#define POST_ADD_ORDER [NSString stringWithFormat:@"%@/runfast/OrderAction!orderAdd.action?", HTTP_NET]

// 16、订单详情
#define POST_ORDER_DETAIL [NSString stringWithFormat:@"%@/runfast/OrderRecordAction!orderList.action?",HTTP_NET]

//17、我的订单
#define POST_MY_ORDER [NSString stringWithFormat:@"%@/runfast/OrderAction!orderMyList.action?",HTTP_NET]

//18、订单状态
#define POST_ORDER_STATUS [NSString stringWithFormat:@"%@/runfast/OrderRecordAction! orderRecordList.action?",id]

//19、充值记录
#define POST_RECHARGE_RECORD [NSString stringWithFormat:@"%@/runfast/RechargeAction! rechargeAdd.action?",HTTP_NET]

//20、我的金币
#define POST_MY_COIN [NSString stringWithFormat:@"%@/runfast/PointsAction!pointsList.action?", HTTP_NET]

//21、商品详情
#define POST_GOODS_DETAIL [NSString stringWithFormat:@"%@/runfast/CouponsImgAction!couponsImgView.action?", HTTP_NET]


//22.商铺搜索

#define POST_SHOP_SEARCH [NSString stringWithFormat:@"%@/runfast/BusinessStoreAction!businessStoreSerch.action?", HTTP_NET]

//22、获取坐标
#define GET_LOCATION  [NSString stringWithFormat:@"%@/runfast/SalesmanAction!salesmanItue.action?", HTTP_NET]

//23、取消订单
#define POST_CANCELORDER [NSString stringWithFormat:@"%@/runfast/OrderAction!orderCancel.action", HTTP_NET]

//24. 获取短信验证码
#define POST_GETCHECKNUM   [NSString stringWithFormat:@"%@/runfast/CustomerAction!sendMsg.action?", HTTP_NET]

//25 获取服务者资料
#define POST_SALESINFORMATION  [NSString stringWithFormat:@"%@/runfast/SalesmanAction!salesmanList.action?", HTTP_NET]

//25 确定购买
#define POST_CERTAIN_BUY  [NSString stringWithFormat:@"%@/runfast/OrderAction!orderCoupons.action?", HTTP_NET]




//25.省 市 区   选择

#define POST_PROVINCE  [NSString stringWithFormat:@"%@/runfast/provincesAction!provList.action", HTTP_NET]


#define POST_CITY  [NSString stringWithFormat:@"%@/runfast/citysAction!cityList.action?", HTTP_NET]


#define POST_AREA  [NSString stringWithFormat:@"%@/runfast/districtsAction!distList.action?", HTTP_NET]





