//
//  CreatedbBase.swift
//  ProjectFramework
//
//  Created by hcy on 16/7/6.
//  Copyright © 2016年 HCY. All rights reserved.
//

import Foundation
import FMDB

class CreatedbBase {
    
    //SQL 代码说明
//    #define SQLITE_OK           0   /* 成功 | Successful result */
//    /* 错误码开始 */
//    #define SQLITE_ERROR        1   /* SQL错误 或 丢失数据库 | SQL error or missing database */
//    #define SQLITE_INTERNAL     2   /* SQLite 内部逻辑错误 | Internal logic error in SQLite */
//    #define SQLITE_PERM         3   /* 拒绝访问 | Access permission denied */
//    #define SQLITE_ABORT        4   /* 回调函数请求取消操作 | Callback routine requested an abort */
//    #define SQLITE_BUSY         5   /* 数据库文件被锁定 | The database file is locked */
//    #define SQLITE_LOCKED       6   /* 数据库中的一个表被锁定 | A table in the database is locked */
//    #define SQLITE_NOMEM        7   /* 某次 malloc() 函数调用失败 | A malloc() failed */
//    #define SQLITE_READONLY     8   /* 尝试写入一个只读数据库 | Attempt to write a readonly database */
//    #define SQLITE_INTERRUPT    9   /* 操作被 sqlite3_interupt() 函数中断 | Operation terminated by sqlite3_interrupt() */
//    #define SQLITE_IOERR       10   /* 发生某些磁盘 I/O 错误 | Some kind of disk I/O error occurred */
//    #define SQLITE_CORRUPT     11   /* 数据库磁盘映像不正确 | The database disk image is malformed */
//    #define SQLITE_NOTFOUND    12   /* sqlite3_file_control() 中出现未知操作数 | Unknown opcode in sqlite3_file_control() */
//    #define SQLITE_FULL        13   /* 因为数据库满导致插入失败 | Insertion failed because database is full */
//    #define SQLITE_CANTOPEN    14   /* 无法打开数据库文件 | Unable to open the database file */
//    #define SQLITE_PROTOCOL    15   /* 数据库锁定协议错误 | Database lock protocol error */
//    #define SQLITE_EMPTY       16   /* 数据库为空 | Database is empty */
//    #define SQLITE_SCHEMA      17   /* 数据结构发生改变 | The database schema changed */
//    #define SQLITE_TOOBIG      18   /* 字符串或二进制数据超过大小限制 | String or BLOB exceeds size limit */
//    #define SQLITE_CONSTRAINT  19   /* 由于约束违例而取消 | Abort due to constraint violation */
//    #define SQLITE_MISMATCH    20   /* 数据类型不匹配 | Data type mismatch */
//    #define SQLITE_MISUSE      21   /* 不正确的库使用 | Library used incorrectly */
//    #define SQLITE_NOLFS       22   /* 使用了操作系统不支持的功能 | Uses OS features not supported on host */
//    #define SQLITE_AUTH        23   /* 授权失败 | Authorization denied */
//    #define SQLITE_FORMAT      24   /* 附加数据库格式错误 | Auxiliary database format error */
//    #define SQLITE_RANGE       25   /* 传递给sqlite3_bind()的第二个参数超出范围 | 2nd parameter to sqlite3_bind out of range */
//    #define SQLITE_NOTADB      26   /* 被打开的文件不是一个数据库文件 | File opened that is not a database file */
//    #define SQLITE_ROW         100  /* sqlite3_step() 已经产生一个行结果 | sqlite3_step() has another row ready */
//    #define SQLITE_DONE        101  /* sqlite3_step() 完成执行操作 | sqlite3_step() has finished executing */
    
    /**
     创建DBSQL
     
     - parameter dbBase:
     */
    func CreateDB( ){
        var DBItem=[String]()
        //此次sql代码是测试代码，可以删除
//        let createSql:String = "CREATE TABLE IF NOT EXISTS test (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, pid integer,name TEXT,height REAL)"
//
        
//        DBItem.append(createSql) // 每个创建命令sql 都需要append进来
        
        for value in DBItem {
            CommonFunction.ExecuteUpdate(value, nil, callback: { (isOk) in
                if(isOk){
                     debugPrint("数据库创建成功！" ,value)
                }
                else{
                    debugPrint("数据库创建失败! ",value)
                }
            })
            
        }
        
    }
}
