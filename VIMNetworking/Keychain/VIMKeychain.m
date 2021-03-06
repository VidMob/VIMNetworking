//
//  KeychainUtility.m
//
//  Created by Alfie Hanssen on 3/1/13.
//
//

#import "VIMKeychain.h"

@interface VIMKeychain ()

@property (nonatomic, strong) NSString *service;
@property (nonatomic, strong) NSString *accessGroup;

@end

@implementation VIMKeychain

+ (void)configureWithService:(NSString *)service accessGroup:(NSString *)accessGroup
{
    NSAssert(service != nil, @"service cannot be nil");
    
    VIMKeychain *keychainUtility = [VIMKeychain sharedInstance];
    keychainUtility.service = service;
    keychainUtility.accessGroup = accessGroup;
}

+ (VIMKeychain *)sharedInstance
{
    static VIMKeychain *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[VIMKeychain alloc] init];
    });
    
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _service = @"default_service";
    }
    
    return self;
}

#pragma mark - Data

- (BOOL)setData:(NSData *)data forAccount:(NSString *)account
{
    return [self setData:data forAccount:account service:self.service];
}

- (NSData *)dataForAccount:(NSString *)account
{
    return [self dataForAccount:account service:self.service];
}

- (BOOL)deleteDataForAccount:(NSString *)account
{
    return [self deleteDataForAccount:account service:self.service];
}

#pragma mark - Private API

- (BOOL)setData:(NSData *)data forAccount:(NSString *)account service:(NSString *)service
{
    if (!data || !account || !service)
    {
        return NO;
    }
    
    BOOL success = [self deleteDataForAccount:account service:service];
    if (!success)
    {
        NSLog(@"Unable to delete data for account: %@ service: %@", account, service);
    }
    
    NSMutableDictionary *query = [self queryForService:service account:account];
    [query setValue:data forKey:(__bridge_transfer id)kSecValueData];
    [query setObject:(__bridge id)kSecAttrAccessibleAfterFirstUnlock forKey:(__bridge id)kSecAttrAccessible];

    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
    
    // Not sure why, but SecItemAdd sometimes returns -34018. This looks like an Apple issue. [ghking] 2/19/2016
    // See this SO post: http://stackoverflow.com/questions/20344255/secitemadd-and-secitemcopymatching-returns-error-code-34018-errsecmissingentit/22305193#22305193
    
    return (status == errSecSuccess);
}

- (NSData *)dataForAccount:(NSString *)account service:(NSString *)service
{
    if (!account || !service)
    {
        return nil;
    }
    
    NSMutableDictionary *query = [self queryForService:service account:account];
    [query setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    [query setObject:(__bridge_transfer id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    
    CFDataRef attributes = nil;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&attributes);
    NSData *data = (__bridge_transfer NSData *)attributes;
    
    if (status != errSecSuccess || data == nil)
    {
        return nil;
    }
    
    return data;
}

- (BOOL)deleteDataForAccount:(NSString *)account service:(NSString *)service
{
    if (!account || !service)
    {
        return NO;
    }
    
    NSMutableDictionary *query = [self queryForService:service account:account];
    CFTypeRef typeRef = (__bridge CFTypeRef)query;
    OSStatus status = SecItemDelete((CFDictionaryRef)typeRef);
    
    return (status == errSecSuccess);
}

- (NSMutableDictionary *)queryForService:(NSString *)service account:(NSString *)account
{
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    [query setValue:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [query setValue:service forKey:(__bridge id)kSecAttrService];
    [query setValue:account forKey:(__bridge id)kSecAttrAccount];
    
    if (self.accessGroup)
    {
        [query setValue:self.accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
    }
    
    return query;
}

@end
