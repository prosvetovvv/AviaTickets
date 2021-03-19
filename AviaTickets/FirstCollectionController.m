//
//  FirstCollectionController.m
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 18.03.2021.
//

#import "FirstCollectionController.h"

@interface FirstCollectionController () <UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UISearchResultsUpdating, UIImagePickerControllerDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray<Content *> *currentContents;
@property (nonatomic, strong) NSArray *searchContents;

@end

@implementation FirstCollectionController

static NSString * const reuseIdentifier = @"Cell";



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"plus"] style:UIBarButtonItemStylePlain target:self action:@selector(openImagePicker)];
  
    [self setupCollectionView];
    [self setupSearchController];
    
}

- (void) setupCollectionView {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.minimumLineSpacing = 10.0;
    layout.minimumInteritemSpacing = 10.0;
    layout.itemSize = CGSizeMake(100.0, 100.0);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    //[collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [collectionView registerClass:[ImageWithTitleCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.currentContents = [NSMutableArray new];
    
    [self.view addSubview: collectionView];
    self.collectionView = collectionView;
}

- (void)openImagePicker {
    UIImagePickerController *controller = [UIImagePickerController new];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}



- (void)setupSearchController {
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchController.obscuresBackgroundDuringPresentation = NO;
    searchController.searchResultsUpdater = self;
    
    self.searchContents = @[];
    
    self.navigationItem.searchController = searchController;
}


#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    //return self.currentContents.count;
    return self.searchContents.count > 0 ? self.searchContents.count : self.currentContents.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   ImageWithTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSArray<Content *> *array = self.searchContents.count > 0 ? self.searchContents : self.currentContents;
    
//    cell.imageView.image = self.currentContents[indexPath.row].image;
//    cell.titleLabel.text = self.currentContents[indexPath.row].title;
    
    cell.imageView.image = array[indexPath.row].image;
    cell.titleLabel.text = array[indexPath.row].title;
    
    return cell;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
   
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (image) {
        
        NSString *title = [NSString stringWithFormat:@"%li%li", self.currentContents.count + 1, self.currentContents.count + 2];
        Content *content = [[Content alloc] initWithImage:image title:title];
        
        [self.currentContents addObject:content];
        [self.collectionView reloadData];
    }
    
    //[picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(nonnull UISearchController *)searchController {
    if (searchController.searchBar.text.length > 0) {
        //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", searchController.searchBar.text];
        
            
        self.searchContents = [self.currentContents filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Content*  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return [evaluatedObject.title hasPrefix:searchController.searchBar.text];
        }]];
        
        [self.collectionView reloadData];
//        [self.searchContents filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Content* evaluatedObject, NSDictionary *bindings) {
//            return [evaluatedObject.title hasPrefix:searchController.searchBar.text];
//        }];
        

        
        //self.resultsViewController.results = [self.array filteredArrayUsingPredicate:predicate];
        //[self.resultsViewController update];
    } else {
        [self.collectionView reloadData];
    }
}


@end
