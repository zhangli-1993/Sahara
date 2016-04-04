//
//  SqlitDataBase.h
//  Sahara
//
//  Created by scjy on 16/3/23.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CollectionModel.h"
@interface SqlitDataBase : NSObject

+ (SqlitDataBase *)dataBaseManger;
- (void)creatDataBase;
- (void)creatDataBaseTable;
- (void)openDataBase;
- (void)closeDataBase;

- (void)insertDataIntoDataBase:(CollectionModel *)Cmodel;
- (NSMutableArray *)selectDataDic;
- (void)deleteData:(NSString *)title;
- (void)insertIntoCollect:(NSDictionary *)dic withNumber:(NSInteger)num;
- (void)deleteWithNum:(NSInteger)num;
- (NSMutableArray *)selectAllCollect;
- (NSMutableArray *)selectAllCollectWithNum:(NSInteger)num;

@end
