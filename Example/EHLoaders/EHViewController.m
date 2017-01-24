//
//  EHViewController.m
//  EHLoaders
//
//  Created by Eric Huang on 01/23/2017.
//  Copyright (c) 2017 Eric Huang. All rights reserved.
//

#import "EHViewController.h"
#import <Masonry/Masonry.h>
#import <EHLoaders/EHLoaders.h>
#import "EHSimpleHeadLoaderView.h"
#import "EHSimpleFootLoaderView.h"

static NSString * const kDefaultCellIdentifier = @"DefaultCell";

@interface EHViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger numberOfRows;

@end

@implementation EHViewController

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.numberOfRows = 10;
    
    [self configureForNavigationBar];
    [self configureForViews];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDefaultCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDefaultCellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"row %ld", (long)indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.numberOfRows;
}

#pragma mark - event response

- (void)refresh:(EHHeadLoader *)sender {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.numberOfRows = 5 + arc4random_uniform(10);
        [self.tableView reloadData];
        [self.tableView.eh_header endLoading];
        
        [self resetNoMoreData];
    });
}

- (void)loadMore:(EHFootLoader *)sender {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.numberOfRows += 3 + arc4random_uniform(5);
        [self.tableView reloadData];
        
        if (arc4random_uniform(2) > 0) {
            [self.tableView.eh_footer endLoading];
            self.navigationItem.rightBarButtonItem = nil;
        } else{
            [self.tableView.eh_footer endLoadingWithNoMoreData];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"ResetNoMoreData" style:UIBarButtonItemStylePlain target:self action:@selector(resetNoMoreData)];
        }
    });
}

- (void)resetNoMoreData {
    [self.tableView.eh_footer resetNoMoreData];
    self.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - private methods

- (void)configureForNavigationBar {
    self.navigationItem.title = @"Home";
}

- (void)configureForViews {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - getters & setters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.eh_header = [EHHeadLoader headerWithLoaderView:[[EHSimpleHeadLoaderView alloc] init] target:self action:@selector(refresh:)];
        _tableView.eh_footer = [EHFootLoader footerWithLoaderView:[[EHSimpleFootLoaderView alloc] init] target:self action:@selector(loadMore:)];
    }
    
    return _tableView;
}

@end
