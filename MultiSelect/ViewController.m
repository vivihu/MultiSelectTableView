//
//  ViewController.m
//  MultiSelect
//
//  Created by icreative-mini on 14-2-12.
//  Copyright (c) 2014年 i-creative.cn. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSMutableArray *cellCount;
    UITableView *_tableView;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"没有标题不好看呐";
    UIBarButtonItem *barItemRight = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editAction:)];
    self.navigationItem.rightBarButtonItem = barItemRight;
    
    UIBarButtonItem *barItemLeft = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAction:)];
    self.navigationItem.leftBarButtonItem = barItemLeft;
    
    CGRect frame = self.navigationController.view.bounds;
    frame.origin.y += 64;
    frame.size.height -= 64;
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.allowsMultipleSelectionDuringEditing = YES;
    _tableView.editing = YES;

    cellCount = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < 10; i++) {
        NSString *number = [NSString stringWithFormat:@"%d",i];
        [cellCount addObject:number];
    }
}

- (void)editAction:(UIBarButtonItem *)button
{
    if (_tableView.editing) {
        [button setTitle:@"Edit"];
        [self.navigationItem.leftBarButtonItem setTitle:@"Add"];
        [_tableView setEditing:NO animated:YES];
        
    }
    else {
        [button setTitle:@"Cancel"];
        [self.navigationItem.leftBarButtonItem setTitle:@"Delete"];
        [_tableView setEditing:YES animated:YES];


    }
}

- (void)deleteAction:(UIBarButtonItem *)button
{
    if (_tableView.editing) {
        NSArray *selectedRows = [_tableView indexPathsForSelectedRows];

        NSMutableIndexSet *indicesOfItemsToDelete = [NSMutableIndexSet new];
        for (NSIndexPath *selectionIndex in selectedRows)
        {
            [indicesOfItemsToDelete addIndex:selectionIndex.row];
        }
        
        [cellCount removeObjectsAtIndexes:indicesOfItemsToDelete];
        [_tableView deleteRowsAtIndexPaths:selectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else {
        [cellCount addObject:@"New Item"];
        NSIndexPath *indexPathOfNewItem = [NSIndexPath indexPathForRow:(cellCount.count - 1) inSection:0];
        [_tableView insertRowsAtIndexPaths:@[indexPathOfNewItem]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [_tableView scrollToRowAtIndexPath:indexPathOfNewItem atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return cellCount.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCellID = @"cellID";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellID];

    cell.textLabel.text = [cellCount objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [cellCount removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
