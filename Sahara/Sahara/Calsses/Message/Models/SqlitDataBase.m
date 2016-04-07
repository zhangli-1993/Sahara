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
#import "CarCollectModel.h"

@interface SqlitDataBase ()
{
    NSString *dataBasePath;
}
@property(nonatomic, strong) BmobUser *user;

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
     NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userName = [user objectForKey:@"userName"];
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE t%@ (number INTEGER PRIMARY KEY AUTOINCREMENT, headImage TEXT, title TEXT, cellID TEXT)",userName];
    NSString *Carsql =[NSString stringWithFormat:@"create table a%@ (number integer , dic blob not null)",userName];
    char *err = nil;
    sqlite3_exec(dataBase, [sql UTF8String], NULL, NULL, &err);
    sqlite3_exec(dataBase, [Carsql UTF8String], NULL, NULL, &err);
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
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userName = [user objectForKey:@"userName"];
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO t%@(headImage, title, cellID) VALUES(?,?,?)", userName];
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
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userName = [user objectForKey:@"userName"];
    NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM t%@", userName];
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
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userName = [user objectForKey:@"userName"];
    NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM t%@", userName];
    int result = sqlite3_prepare(dataBase, [deleteSql UTF8String], -1, &stmt, nil);
    if (result == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [title UTF8String], -1, nil);
        sqlite3_step(stmt);
    }else{
        NSLog(@"删除语句有问题");
    }
    sqlite3_finalize(stmt);
}
/****************收藏车系******************/
- (void)insertIntoCollect:(NSDictionary *)dic withNumber:(NSInteger)num{
    [self openDataBase];
    sqlite3_stmt *stmt = nil;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userName = [user objectForKey:@"userName"];
    NSData *dicData = [NSKeyedArchiver archivedDataWithRootObject:dic];
    NSString *sql =[NSString stringWithFormat:@"insert into a%@(number, dic) values(?, ?)", userName];
    int result = sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        //sql语句没有问题---绑定数据(绑定的是上边sql语句中的？。也就是讲？替换为应该存储的值)
        //绑定？时，标记从1开始，不是0
        
        sqlite3_bind_int(stmt,1, num);
        sqlite3_bind_blob(stmt, 2, [dicData bytes], [dicData length], NULL);
        
        //执行
        sqlite3_step(stmt);
        NSLog(@"收藏成功");
    }else{
        NSLog(@"sql语句有问题");
    }
    //删除释放掉
    sqlite3_finalize(stmt);
}



- (void)deleteWithNum:(NSInteger)num{
    [self openDataBase];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userName = [user objectForKey:@"userName"];
    //创建一个存储sql语句的变量
    sqlite3_stmt *stmt = nil;
    NSString *sql = [NSString stringWithFormat:@"delete from a%@ where number = ?", userName];
    //验证sql语句
    int result = sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        //绑定name的值
        
        sqlite3_bind_int(stmt, 1, num);
        sqlite3_step(stmt);
        
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
    //释放
    sqlite3_finalize(stmt);
    
    
}
- (NSMutableArray *)selectAllCollect{
    [self openDataBase];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userName = [user objectForKey:@"userName"];
    sqlite3_stmt *stmt = nil;
    NSString *sql = [NSString stringWithFormat:@"select *from a%@", userName];
    int result = sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, NULL);
    NSMutableArray *array = nil;
    if (result == SQLITE_OK) {
        array = [NSMutableArray new];
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const void *value = sqlite3_column_blob(stmt, 1);
            int bytes = sqlite3_column_bytes(stmt, 1);
            NSData *data = [NSData dataWithBytes:value length:bytes];
            NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            NSInteger num = (NSInteger)sqlite3_column_int64(stmt, 0);
            CarCollectModel *collect = [[CarCollectModel alloc]initWithDic:dic withNum:num];
            [array addObject:collect];
        }
    }
    else{
        NSLog(@"获取失败");
        array = [NSMutableArray new];
    }
    sqlite3_finalize(stmt);
    return array;
}

- (NSMutableArray *)selectAllCollectWithNum:(NSInteger)num{
    [self openDataBase];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userName = [user objectForKey:@"userName"];
    sqlite3_stmt *stmt = nil;
    NSString *sql =[NSString stringWithFormat:@"select * from a%@ where number = ?", userName];
    int result = sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, NULL);
    NSMutableArray *array = [NSMutableArray new];
    if (result == SQLITE_OK) {
        
        sqlite3_bind_int(stmt, 1, num);
        while (sqlite3_step(stmt) == SQLITE_ROW){
            const void *value = sqlite3_column_blob(stmt, 1);
            int bytes = sqlite3_column_bytes(stmt, 1);
            NSData *data = [NSData dataWithBytes:value length:bytes];
            NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            CarCollectModel *model = [[CarCollectModel alloc]initWithDic:dic withNum:num];
            [array addObject:model];
        }
    }
    else{
        NSLog(@"获取失败");
        
    }
    sqlite3_finalize(stmt);
    NSLog(@"%@", array);
    return array;
    
}

@end
