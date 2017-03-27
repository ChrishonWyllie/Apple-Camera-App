//
//  AppDelegate.swift
//  Apple-Camera-App
//
//  Created by Chrishon Wyllie on 3/27/17.
//  Copyright © 2017 Chrishon Wyllie. All rights reserved.
//

import UIKit
import Photos

public var phassetImageArray = [PHAsset]()
public var lastImageFromPhotoLibrary: UIImage?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        navigate_To_Programmatically_Created_CameraController()
        
        return true
    }
    
    
    
    
    func navigate_To_Programmatically_Created_CameraController() {
        
        // Load the images before navigating to the controller
        attempt_To_Retrieve_Photos_From_Library()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.makeKeyAndVisible()
        
        let cameraController = CameraController()
        
        window?.rootViewController = cameraController
        
    }
    
    
    // The reason this functuon takes in a UICollectionView parameter is because we must reload the UICollectionView
    // after the images have been loaded
    func attempt_To_Retrieve_Photos_From_Library() {
        
        // whenever you download and open a new app, you are often prompted allow the
        // app to access your camera, contacts, etc.
        // In this case, we want to determine whether we already have access to the user's photos gallery
        let status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        if status == .authorized {
            
            // User has pressed "Allow" when asked for access to their camera roll
            self.loadCameraImages()
            
        } else if status == .notDetermined {
            
            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({(_ status: PHAuthorizationStatus) -> Void in
                
                if status == .authorized {
                    
                    // Access has been granted.
                    self.loadCameraImages()
                    
                } else {
                    
                    /*Access has been denied.*/
                    
                }
            })
        }
        
        
    }
    
    func loadCameraImages() {
        
        let requestOptions = PHImageRequestOptions()
        
        // May slow down loading of images
        // Other options: .fastFormat | .opportunistic
        requestOptions.deliveryMode = .highQualityFormat
        
        let fetchOptions = PHFetchOptions()
        
        // This is for if you want the most recent image taken to be at the top of the UICollectionView
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        
        // Returns all PHAssets (images, videos) from the options you specified
        let fetchAllResults: PHFetchResult = PHAsset.fetchAssets(with: fetchOptions)
        
        if fetchAllResults.count > 0 {
            
            for i in 0..<fetchAllResults.count {
                
                phassetImageArray.append(fetchAllResults.object(at: i) )
                
            }
            
        }
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

