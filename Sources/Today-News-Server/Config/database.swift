/// 数据库
public struct Database {
    
     public struct today_news {
        /// 数据库服务器地址
        public static let hostname = "182.92.83.11"
        /// 用户名
        public static let username = "lovemo"
        /// 密码
        public static let password = "perfect_swift"
        /// 数据库名
        public static let database =  "today_news"
        /// 数据库表前缀
        public static let dbprefix = ""
        /// 数据库端口号
        public static let dbport = "27017"
        /// 数据库连接地址
        public static var connection: String {
            return "mongodb://" +
                today_news.username  + ":" +
                today_news.password + "@" +
                today_news.hostname + ":" +
                today_news.dbport + "/"
        }
    }

    
}
