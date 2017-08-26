//
//  ArticleContentModel.swift
//  Today-News-Server
//
//  Created by 百城 on 16/10/29.
//
//

import PerfectLib
import Common
import MongoDB
import DataBase
import Config

public class ArticleContentModel {
    
    
    /// dataList
    public var dataList = [Any]()
    
    /// dartabase
    var db: DB
    
    /// colllection
    var collection: MongoCollection?
    
    public init() {
        db = DB(db: "today_news").collection(name: "article")
        collection =  db.collection
    }
    
    public func content(type: Int, page: Int) -> String {
        
        let queryBson = BSON()
        queryBson.append(key: "type", int: type)
        queryBson.append(key: "isDelete", bool: false)
        let fields = BSON()
        fields.append(key: "title", int: 1)
        fields.append(key: "createtime", int: 1)
        fields.append(key: "type", int: 1)
        fields.append(key: "source", int: 1)
        fields.append(key: "thumbnails", int: 1)
        let limit = 6
        let skip = limit * (page - 1)
        let cursor = collection?.find(query: queryBson, fields: fields, flags: MongoQueryFlag.none, skip: skip, limit: limit, batchSize: 0)

        var ary = [Any]()
        while let c = cursor?.next() {
            var data:[String: Any] = c.dict as [String : Any]
            let bson = BSON()
            let temp = data["_id"] as? [String : String]
            if let dict = temp {
                bson.append(key: "article_id", oid: BSON.OID(dict["$oid"]! as String))
            } else {
                bson.append(key: "article_id", oid: BSON.OID(""))
            }
            
            var thumbnails = [String]()
            if let imgArr = data["thumbnails"] as? [String] {
                for img in imgArr {
                    var thumbnail = img
                    thumbnail.removeSubrange(thumbnail.startIndex..<thumbnail.index(after: thumbnail.startIndex))
                    thumbnails.append(app["imghost"] as! String + thumbnail)
                }
            }

            data["thumbnails"] = thumbnails
            
            data["comment_count"] = ArticleCommentModel().comment_count(article_bson:bson)
            ary.append(data)
        }
        var response = [String:Any]()
        if ary.count > 0 {
            response["result"] = "success"
            response["total"] = total(query: queryBson)
            response["data"] = ary
        } else {
            response["result"] = "error"
        }
        
        db.close()
        
        return try! response.jsonEncodedString()
    }

    
    /// get total num
    public func total(query: BSON) -> Int {
        let result: MongoResult = collection!.count(query: query)
        switch result {
        case .replyInt(let total):
            return total
        default:
            return 0
        }
    }
    
}
