//
//  CoreDataManager.m
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 23.03.2021.
//

#import "CoreDataManager.h"

@interface CoreDataManager ()

@property (readonly, strong)NSPersistentContainer *persistentContainer;

@end

@implementation CoreDataManager

+ (instancetype)sharedInstance {
    static CoreDataManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [CoreDataManager new];
    });
    return instance ;
}

#pragma mark - CoreData Stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"SelectedTickets"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    return _persistentContainer;
}

#pragma mark - CoreData Saving

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

#pragma mark - Favorites tickets

- (FavoriteTicket *)favoriteFromTicket:(Ticket *)ticket {
    NSError *error;
    NSFetchRequest *request = [FavoriteTicket fetchRequest];
    NSString *format = @"price == %ld AND airline == %@ AND from == %@ AND to == %@ AND departure == %@ AND expires == %@ AND flightNumber == %ld";
    
    request.predicate = [NSPredicate predicateWithFormat:format, (long)ticket.price.integerValue, ticket.airline, ticket.from, ticket.to, ticket.departure, ticket.expires, (long)ticket.flightNumber.integerValue];
    NSArray *tickets = [self.persistentContainer.viewContext executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error.localizedDescription);
        return nil;
    }
    return tickets.firstObject;
}

- (BOOL)isFavorite:(Ticket *)ticket {
    return [self favoriteFromTicket:ticket] != nil;
}

- (void)addToFavorite:(Ticket *)ticket {
    FavoriteTicket *favorite = [NSEntityDescription insertNewObjectForEntityForName:@"FavoriteTicket" inManagedObjectContext:self.persistentContainer.viewContext];
    
    favorite.price = ticket.price.intValue;
    favorite.airline = ticket.airline;
    favorite.departure = ticket.departure;
    favorite.expires = ticket.expires;
    favorite.flightNumber = ticket.flightNumber.intValue;
    favorite.returnDate = ticket.returnDate;
    favorite.from = ticket.from;
    favorite.to = ticket.to;
    favorite.created = [NSDate date];
    
    [self saveContext];
}

- (void)removeFromFavorite:(Ticket *)ticket {
    FavoriteTicket *favorite = [self favoriteFromTicket:ticket];
    if (favorite) {
        [self.persistentContainer.viewContext deleteObject:favorite];
        [self saveContext];
    }
}

- (NSArray *)favorites {
    NSError *error;
    NSFetchRequest *request = [FavoriteTicket fetchRequest];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO]];
    
    NSArray *tickets = [self.persistentContainer.viewContext executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }
    return tickets;
}

#pragma mark - Map tickets

- (MapTicket *)mapTicketFromTicket:(Ticket *)ticket {
    NSError *error;
    NSFetchRequest *request = [MapTicket fetchRequest];
    NSString *format = @"price == %ld AND airline == %@ AND from == %@ AND to == %@ AND departure == %@";
    
    request.predicate = [NSPredicate predicateWithFormat:format, (long)ticket.price.integerValue, ticket.airline, ticket.from, ticket.to, ticket.departure];
    NSArray *tickets = [self.persistentContainer.viewContext executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error.localizedDescription);
        return nil;
    }
    
    return tickets.firstObject;
}

- (void)addToSelectedFromMap:(Ticket *)ticket {
    MapTicket *mapTicket = [NSEntityDescription insertNewObjectForEntityForName:@"MapTicket" inManagedObjectContext:self.persistentContainer.viewContext];
    
    mapTicket.price = ticket.price.intValue;
    mapTicket.airline = ticket.airline;
    mapTicket.departureDate = ticket.departure;
    mapTicket.from = ticket.from;
    mapTicket.to = ticket.to;
    mapTicket.created = [NSDate date];
    
    [self saveContext];
}

- (void)removeFromSelectedFromMap:(Ticket *)ticket {
    MapTicket *mapTicket = [self mapTicketFromTicket:ticket];
    
    if (mapTicket) {
        [self.persistentContainer.viewContext deleteObject:mapTicket];
        [self saveContext];
    }
}

- (NSArray *)mapTickets {
    NSError *error;
    NSFetchRequest *request = [MapTicket fetchRequest];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO]];
    
    NSArray *tickets = [self.persistentContainer.viewContext executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }
    return tickets;
}

@end
