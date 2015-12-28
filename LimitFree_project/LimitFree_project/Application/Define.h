//
//  Define.h
//  该文件定义了爱限免项目所需的接口以及常用的宏
//

#ifndef LimitFree_Define_h
#define LimitFree_Define_h

#define kScreenSize [UIScreen mainScreen].bounds.size

// 数据库存储收藏/浏览/下载记录
//声明 三个 全局变量 (声明的是外部其他文件所定义的)
//extern 表示连接外部其他文件的全局变量

extern NSString * const kRecordTypeFavorite;
extern NSString * const kRecordTypeDownloads;
extern NSString * const kRecordTypeBrowses;

/*
 界面类型
 */
#define kLimitType    @"limited"
#define kReduceType   @"sales"
#define kFreeType     @"free"
#define kHotType      @"hot"
#define kSubjectType  @"subject"

/*
 以下API接口若要获取指定分类的数据需要追加cate_id参数，不写则表示全部分类
 完整接口示例：http://www.1000phone.net:8088/app/iAppFree/api/limited.php?page=1&number=20&search=12&cate_id=6000
 */
//限免页面接口
#define kLimitUrl @"http://www.1000phone.net:8088/app/iAppFree/api/limited.php?page=%d&number=20&search=%@"

//降价页面接口
#define kReduceUrl @"http://www.1000phone.net:8088/app/iAppFree/api/reduce.php?page=%d&number=20&search=%@"

//免费页面接口
#define kFreeUrl @"http://www.1000phone.net:8088/app/iAppFree/api/free.php?page=%d&number=20&search=%@"

//专题页面接口
#define kSubjectUrl @"http://1000phone.net:8088/app/iAppFree/api/topic.php?page=%ld&number=5"

//热榜页面接口
#define kHotUrl @"http://1000phone.net:8088/app/iAppFree/api/hot.php?page=%ld&number=20&search=%@"


//分类界面接口
#define kCateUrl @"http://1000phone.net:8088/app/iAppFree/api/appcate.php"

//详情页面接口
// http://iappfree.candou.com:8080/free/applications/688743207?currency=rmb
// 参数要传一个applicationid
#define kDetailUrl @"http://iappfree.candou.com:8080/free/applications/%@?currency=rmb"

//周边使用应用接口:
//http://iappfree.candou.com:8080/free/applications/recommend?longitude=116.344539&latitude=40.034346
//参数longitude,latitude填写经度和纬度。
#define kNearAppUrl @"http://iappfree.candou.com:8080/free/applications/recommend?longitude=%lf&latitude=%lf"




#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

#endif
