//
//  AppDelegate.m
//  HackerBooks
//
//  Created by Javi Alzueta on 30/3/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "AppDelegate.h"
#import "FLGConstants.h"
#import "FLGLibrary.h"
#import "FLGLibraryTableViewController.h"
#import "FLGConstants.h"
#import "FLGSandboxUtils.h"
#import "FLGBookViewController.h"
#import "FLGJSONUtils.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Compruebo si hay datos guardados en local
    NSData *booksData;
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if (![def objectForKey:IS_SAVED_JSON_DATA_KEY]) {
        // No hay datos guardados en local
        
        // Descargo el JSON del servidor
        booksData = [NSData dataWithContentsOfURL:[NSURL URLWithString:JSON_DOWNLOAD_URL]];
        
        // Descargo las imagenes y modifico el JSON
        booksData = [FLGSandboxUtils downloadAndSaveLibraryImages:booksData];
        
        // Guardo el JSON actualizado en local
        [FLGSandboxUtils saveLibraryJson:booksData];
    }else{
        // Sí hay datos guardados en local
        // Cojo el JSON de local
        booksData = [NSData dataWithContentsOfURL:[FLGSandboxUtils urlForJSONDataInSandbox]];
    }
    
    // Creo el modelo con los datos obtenidos (server/local)
    self.library = [[FLGLibrary alloc] initWithJsonData:booksData error:nil];
    
    // Detectamos el tipo de pantalla
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        // Tipo tableta
        [self configureForPadWithModel:self.library];
    }else{
        
        // Tipo telefono
        [self configureForPhoneWithModel:self.library];
    }
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // Se guarda el modelo libreria en el Sandbox
    self.library = self.libraryVC.model;
    [FLGSandboxUtils saveLibraryJson:[FLGJSONUtils jsonDataWithBooksArray:self.libraryVC.model.booksArray]];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Utils

- (void) configureForPadWithModel: (FLGLibrary *) library{
    
    // Creamos los controladores
    FLGBook *lastSelectedBook = [self lastSelectedBookInModel: library];
    self.libraryVC = [[FLGLibraryTableViewController alloc] initWithModel:library
                                                             selectedBook:lastSelectedBook
                                                         showSelectedCell: YES
                                                                    style:UITableViewStylePlain];
    
    FLGBookViewController *bookVC = [[FLGBookViewController alloc] initWithModel:lastSelectedBook];
    
    // Creo los navigationControllers
    UINavigationController *libraryNavVC = [[UINavigationController alloc] initWithRootViewController:self.libraryVC];
    UINavigationController *bookNavVC = [[UINavigationController alloc] initWithRootViewController:bookVC];
    
    // Creo el SplitViewController
    UISplitViewController *spliVC = [[UISplitViewController alloc] init];
    spliVC.viewControllers = @[libraryNavVC, bookNavVC];
    
    // Asignamos delegados
    spliVC.delegate = bookVC;
    self.libraryVC.delegate = bookVC;
    
    // Mostramos el controlador en pantalla
    self.window.rootViewController = spliVC;
}

- (void) configureForPhoneWithModel: (FLGLibrary *) library{
    
    // Creamos los controladores
    self.libraryVC = [[FLGLibraryTableViewController alloc] initWithModel:library
                                                             selectedBook:nil
                                                         showSelectedCell: NO
                                                                    style:UITableViewStylePlain];

    // Creo los navigationControllers
    UINavigationController *libraryNavVC = [[UINavigationController alloc] initWithRootViewController:self.libraryVC];
    
    // Asignamos delegados
    self.libraryVC.delegate = self.libraryVC;
    
    // Mostramos el controlador en pantalla
    self.window.rootViewController = libraryNavVC;
}

- (FLGBook *) lastSelectedBookInModel: (FLGLibrary *) library{

    // Obtengo el NSUserDefaults
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    // Saco las coordenadas del ultimo personaje
    NSArray *coords = [def objectForKey:LAST_SELECTED_BOOK];
    NSString *tag = [coords objectAtIndex:0];
    if (!tag) {
        tag = [library.tags objectAtIndex:0];
    }
    NSUInteger index = [[coords objectAtIndex:1] integerValue];
    
    // Obtengo el personaje
    FLGBook *book = [library bookForTag:tag atIndex:index];
    
    // Lo devuelvo
    return book;
}


@end
