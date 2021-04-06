//
//  TicketsTableViewController.m
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 16.03.2021.
//

#import "TicketsTableViewController.h"

#define TicketCellReuseIdentifier @"TicketCellIdentifier"

//#define Title NSLocalizedString(@"ticketsTitle", @"Title controller")
//#define Rubles NSLocalizedString(@"rubles", @"Current currency")
//#define NotificationTitleReminder NSLocalizedString(@"notificationTitleReminder", @"Notification title reminder")
//#define AlertTitle NSLocalizedString(@"alertTitle", @"Alert title")
//#define AlertMessage NSLocalizedString(@"alertMessage", @"Alert message")
//#define AlertActionClose NSLocalizedString(@"alertActionClose", @"Alert action close")
//
//#define ActionSheetTitle NSLocalizedString(@"actionSheetTitle", @"ActionSheet title")
//#define ActionSheetMessage NSLocalizedString(@"actionSheetMessage", @"ActionSheet message")
//#define ActionSheetActionRemind NSLocalizedString(@"actionSheetActionRemind", @"ActionSheet remind")
//#define ActionSheetClose NSLocalizedString(@"actionSheetClose", @"ActionSheet close")
//
//#define ActionTitleDelete NSLocalizedString(@"actionTitleDelete", @"Alert action delete from favorites")
//#define ActionTitleAdd NSLocalizedString(@"actionTitleAdd", @"Alert action add to favorites")


@interface TicketsTableViewController ()

@property (nonatomic, strong) NSArray *tickets;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UITextField *dateTextField;
@property (nonatomic, strong) TicketCell *selectedCell;

@end

@implementation TicketsTableViewController

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
    self.title = Title;
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
    if (self.datePicker.date && self.selectedCell) {
        NSString *message = [NSString stringWithFormat:@"%@ - %@  %@ %@.", self.selectedCell.ticket.from, self.selectedCell.ticket.to, self.selectedCell.ticket.price, Currency];
        
        NSURL *imageURL;
        if (self.selectedCell.airlineLogoView.image) {
            NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:[NSString stringWithFormat:@"/%@.png", self.selectedCell.ticket.airline]];
            if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
                UIImage *logo = self.selectedCell.airlineLogoView.image;
                NSData *pngData = UIImagePNGRepresentation(logo);
                [pngData writeToFile:path atomically:YES];
                
            }
            imageURL = [NSURL fileURLWithPath:path];
        }
        
        Notification notification = [[NotificationCenter sharedInstance] makeNotification:NotificationTitleReminder body:message date:self.datePicker.date imageURL:imageURL];
        [[NotificationCenter sharedInstance] sendNotification:notification];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:AlertTitle
                                                                                 message:[NSString stringWithFormat:@"%@ - %@", AlertMessage, _datePicker.date] preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:AlertActionClose
                                                               style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    self.datePicker.date = [NSDate date];
    self.selectedCell.isSelected = NO;
    self.selectedCell = nil;
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
    
    
    if (self.selectedCell) {
        self.selectedCell.isSelected = NO;
    }
    
    self.selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    self.selectedCell.isSelected = YES;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:ActionSheetTitle
                                                                             message:ActionSheetMessage
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *favoriteAction;
    Ticket *ticket = self.tickets[indexPath.row];
    
    if ([[CoreDataManager sharedInstance] isFavorite:ticket]) {
        favoriteAction = [UIAlertAction actionWithTitle:ActionTitleDelete
                                                  style:UIAlertActionStyleDestructive
                                                handler:^(UIAlertAction * _Nonnull action) {
            [[CoreDataManager sharedInstance] removeFromFavorite:ticket];
        }];
    } else {
        favoriteAction = [UIAlertAction actionWithTitle:ActionTitleAdd
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action) {
            [[CoreDataManager sharedInstance] addToFavorite:ticket];
        }];
    }
    
    UIAlertAction *notificationAction = [UIAlertAction actionWithTitle:ActionSheetActionRemind
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * _Nonnull action) {
    
        [self.dateTextField becomeFirstResponder];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:ActionSheetClose
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
        self.selectedCell.isSelected = NO;
        self.selectedCell = nil;
    }];
    
    [alertController addAction:favoriteAction];
    [alertController addAction:cancelAction];
    [alertController addAction:notificationAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.0;
}

@end
