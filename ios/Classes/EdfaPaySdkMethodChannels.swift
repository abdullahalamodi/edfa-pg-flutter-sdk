//
//  EdfaPaySdkEventChannels.swift
//  EdfaPaySdk
//
//  Created by Zohaib Kambrani on 02/03/2023.
//

import Foundation
import Flutter
import UIKit
import EdfaPgSdk


public class EdfapaySdkMethodChannels: NSObject{
    var edfaPaySdk:FlutterMethodChannel? = nil;

    final let methodGetPlatformVersion = "getPlatformVersion";
    final let methodConfig = "config";
    final let methodSetSuccessAnimation = "setSuccessAnimation";
    final let methodSetFailureAnimation = "setFailureAnimation";
    final let methodSetAnimationDelay = "setAnimationDelay";

    public func initiate(with messenger: FlutterBinaryMessenger){
            
        edfaPaySdk = FlutterMethodChannel(name: "com.edfapg.flutter.sdk", binaryMessenger: messenger)
    }
    
}

