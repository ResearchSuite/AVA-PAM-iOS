//
//  RSOpenURLDelegate.swift
//  Pods
//
//  Created by James Kizer on 7/29/17.
//
//

import UIKit

public protocol RSOpenURLDelegate {
    
    func handleURL(app: UIApplication, url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool
    
}
