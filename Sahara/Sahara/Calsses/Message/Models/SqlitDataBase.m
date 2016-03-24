//
//  SqlitDataBase.m
//  Sahara
//
//  Created by scjy on 16/3/23.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "SqlitDataBase.h"
#import <sqlite3.h>
#import <BmobSDK/Bmob.h>

@interface SqlitDataBase ()
{
    NSString *dataBasePath;
}
@end

@implementation SqlitDataBase

//静态单例对象
static SqlitDataBase *dbManger = nil;
+ (SqlitDataBase *)dataBaseManger{
    if (dbManger == nil) {
        dbManger = [[SqlitDataBase alloc] init];
    }
    return dbManger;
}

//创建数据库
static sqlite3 *dataBase = nil;
- (void)creatDataBase{
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    dataBasePath = [document stringByAppendingPathComponent:@"/mango.sqlite3"];
    NSLog(@"%@", dataBasePath);
}

- (void)openDataBase{
    if (dataBase != nil) {
        return;
    }
    [self creatDataBase];
    int result = sqlite3_open([dataBasePath UTF8String], &dataBase);
    if (result == SQLITE_OK) {
        [self creatDataBaseTable];
    }else{
        NSLog(@"数据库打开失败");
    }
    
}

- (void)creatDataBaseTable{
    BmobUser *user = [BmobUser getCurrentUser];
//    NSString *sql = @"CREATE TABLE essayTable1 (number INTEGER PRIMARY KEY AUTOINCREMENT, headImage TEXT, title TEXT, cellID TEXT)";
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE %@Table (number INTEGER PRIMARY KEY AUTOINCREMENT, headImage TEXT, title TEXT, cellID TEXT)", user.username];
    
    char *err = nil;
    sqlite3_exec(dataBase, [sql UTF8String], NULL, NULL, &err);
}

- (void)closeDataBase{
    int result = sqlite3_close(dataBase);
    if (result == SQLITE_OK) {
        dataBase = nil;
    }else{
        NSLog(@"数据库关闭失败");
    }
}

//数据库方法
- (void)insertDataIntoDataBase:(CollectionModel *)Cmodel{
    [self openDataBase];
    sqlite3_stmt *stmt = nil;
//    NSString *insertSql = @"INSERT INTO essayTable1(headImage, title, cellID) VALUES(?,?,?)";
    BmobUser *user = [BmobUser getCurrentUser];

    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@Table(headImage, title, cellID) VALUES(?,?,?)", user.username];
    int reslut = sqlite3_prepare(dataBase, [insertSql UTF8String], -1, &stmt, nil);
    if (reslut == SQLITE_OK) {
        //绑定
        if (Cmodel.image == nil) {
            Cmodel.image = @"http://img0.pcauto.com.cn/pcauto/1511/02/g_7275908_1446429511732_240x160.jpg";
        }else{
        sqlite3_bind_text(stmt, 1, [Cmodel.image UTF8String], -1, nil);
        }
        sqlite3_bind_text(stmt, 2, [Cmodel.title UTF8String], -1, nil);
       NSString *cellID = [NSString stringWithFormat:@"%@", Cmodel.messageID];
        sqlite3_bind_text(stmt, 3, [cellID UTF8String], -1, nil);
        
        sqlite3_step(stmt);
    }else{
        NSLog(@"添加语句有问题");
    }
    
    sqlite3_finalize(stmt);
    
}

- (NSMutableArray *)selectDataDic{
    [self openDataBase];
    sqlite3_stmt *stmt = nil;
    BmobUser *user = [BmobUser getCurrentUser];
    NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM %@Table", user.username];
//    NSString *selectSql = @"SELECT * FROM essayTable1";
    int result = sqlite3_prepare(dataBase, [selectSql UTF8String], -1, &stmt, nil);
    NSMutableArray *selectArray = [NSMutableArray new];
    if (result == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            NSMutableDictionary *dic = [NSMutableDictionary new];
    
            NSString *headImage = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            NSString *title = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];

            NSString *messageID = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
            [dic setValue:headImage forKey:@"image"];
            [dic setValue:title forKey:@"title"];
            [dic setValue:messageID forKey:@"cellID"];
            [selectArray addObject:dic];
        }
    }
    sqlite3_finalize(stmt);
    return selectArray;
}


- (void)deleteData:(NSString *)title{
    [self openDataBase];
    sqlite3_stmt *stmt = nil;
    BmobUser *user = [BmobUser getCurrentUser];
    NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM %@Table", user.username];
//    NSString *deleteSql = @"DELETE FROM essayTable1 WHERE title = ?";
    int result = sqlite3_prepare(dataBase, [deleteSql UTF8String], -1, &stmt, nil);
    if (result == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [title UTF8String], -1, nil);
        sqlite3_step(stmt);
    }else{
        NSLog(@"删除语句有问题");
    }
    sqlite3_finalize(stmt);
}

@end
