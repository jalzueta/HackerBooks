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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Creo el modelo
    NSData *booksData;
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if (![def objectForKey:IS_SAVED_JSON_DATA_KEY]) {
        // No hay datos guardados en local
        booksData = [NSData dataWithContentsOfURL:[NSURL URLWithString:JSON_DOWNLOAD_URL]];
        [self saveJSONInSandbox:booksData];
    }else{
        // Sí hay datos guardados en local
        booksData = [NSData dataWithContentsOfURL:[self urlForJSONDataInSandbox]];
    }
    
    FLGLibrary *library = [[FLGLibrary alloc] initWithData:booksData error:nil];
    
    // Creo los controladores
    FLGLibraryTableViewController *libraryVC = [[FLGLibraryTableViewController alloc] initWithModel:library style:UITableViewStyleGrouped];
    
    // Creo los navigation controller
    UINavigationController *libraryNC = [[UINavigationController alloc] initWithRootViewController:libraryVC];
    
    // Mostramos el controlador
    self.window.rootViewController = libraryNC;
    
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

- (NSURL *) urlForJSONDataInSandbox{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *urls = [fm URLsForDirectory:NSDocumentDirectory
                               inDomains:NSUserDomainMask];
    NSURL *url = [urls lastObject];
    
    // Añadir el componente del nombre del fichero
    url = [url URLByAppendingPathComponent:JSON_FILENAME];
    return url;
}

- (void) saveJSONInSandbox: (NSData *) jsonData{
    // Averigura la URL a la carpeta Caches
    NSURL *url = [self urlForJSONDataInSandbox];
    
    // Guardar algo
    NSError *err;
    BOOL rc = [jsonData writeToURL:url atomically:YES];
    
    // Comprobar que se guardó
    if (rc == NO) {
        // Hubo error al guardar
        NSLog( @"Error al guardar: %@", err.userInfo);
    }else{
        // No hubo error al guardar
        NSLog( @"JSON guardado correctamente");
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:@"YES" forKey:IS_SAVED_JSON_DATA_KEY];
    }
}

@end
