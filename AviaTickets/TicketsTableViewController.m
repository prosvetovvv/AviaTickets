//
//  TicketsTableViewController.m
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 16.03.2021.
//

#import "TicketsTableViewController.h"

#define TicketCellReuseIdentifier @"TicketCellIdentifier"

@interface TicketsTableViewController ()

@property (nonatomic, strong) NSArray *tickets;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UITextField *dateTextField;

@end

@implementation TicketsTableViewController

TicketCell *notificationCell;

- (instancetype)initWithTickets:(NSArray *)tickets {
    self = [super init];
    if (self) {
        _tickets = tickets;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSelf];
    [self setupDatePicker];
    [self setupTextField];
    [self setupToolBar];
}

#pragma mark - Setup UI

- (void)setupSelf {
    self.title = @"Tickets";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[TicketCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
}

- (void)setupDatePicker {
    self.datePicker = [UIDatePicker new];
    self.datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    self.datePicker.minimumDate = [NSDate date];
}

- (void)setupTextField {
    self.dateTextField = [[UITextField alloc] initWithFrame:self.view.bounds];
    self.dateTextField.hidden = YES;
    self.dateTextField.inputView = self.datePicker;
    
    [self.view addSubview:self.dateTextField];
}

- (void)setupToolBar {
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonDidTap:)];
    
    keyboardToolbar.items = @[flexBarButton, doneBarButton];
    self.dateTextField.inputAccessoryView = keyboardToolbar;
}

#pragma mark - Private

- (void)doneButtonDidTap:(UIBarButtonItem *)sender {
    if (self.datePicker.date && notificationCell) {
        NSString *message = [NSString stringWithFormat:@"%@ - %@ за %@ руб.", notificationCell.ticket.from, notificationCell.ticket.to, notificationCell.ticket.price];

        NSURL *imageURL;
        if (notificationCell.airlineLogoView.image) {
            NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:[NSString stringWithFormat:@"/%@.png", notificationCell.ticket.airline]];
            if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
                UIImage *logo = notificationCell.airlineLogoView.image;
                NSData *pngData = UIImagePNGRepresentation(logo);
                [pngData writeToFile:path atomically:YES];

            }
            imageURL = [NSURL fileURLWithPath:path];
        }
        
        Notification notification = [[NotificationCenter sharedInstance] makeNotification:@"Напоминание о билете" body:message date:self.datePicker.date imageURL:imageURL];
        [[NotificationCenter sharedInstance] sendNotification:notification];

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Успешно" message:[NSString stringWithFormat:@"Уведомление будет отправлено - %@", _datePicker.date] preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    self.datePicker.date = [NSDate date];
    notificationCell = nil;
    [self.view endEditing:YES];
}


#pragma mark - TableView data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tickets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TicketCell *cell = [tableView dequeueReusableCellWithIdentifier:TicketCellReuseIdentifier forIndexPath:indexPath];
    
    cell.ticket = [self.tickets objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    notificationCell = [tableView cellForRowAtIndexPath:indexPath];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Action with ticket" message:@"What should do with this ticket?" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *favoriteAction;
    Ticket *ticket = self.tickets[indexPath.row];
    
    if ([[CoreDataManager sharedInstance] isFavorite:ticket]) {
        favoriteAction = [UIAlertAction actionWithTitle:@"Delete from Favorites" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[CoreDataManager sharedInstance] removeFromFavorite:ticket];
        }];
    } else {
        favoriteAction = [UIAlertAction actionWithTitle:@"Add to Favorites" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[CoreDataManager sharedInstance] addToFavorite:ticket];
        }];
    }
    
    [notificationCell startAnimation];
    
    UIAlertAction *notificationAction = [UIAlertAction actionWithTitle:@"Напомнить" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //notificationCell = [tableView cellForRowAtIndexPath:indexPath];
        [self.dateTextField becomeFirstResponder];
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:favoriteAction];
    [alertController addAction:cancelAction];
    [alertController addAction:notificationAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.0;
}

@end
