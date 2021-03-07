//
//  Country.h
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 06.03.2021.
//

#import <Foundation/Foundation.h>

@interface Country : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSDictionary *translations;
@property (nonatomic, strong) NSString *code;

-(NSString *)description;
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

