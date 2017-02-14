//
//  StickPicProducts.swift
//  StickPics
//
//  Created by Dylan Wight on 2/14/17.
//  Copyright © 2017 Dylan Wight. All rights reserved.
//

import Foundation

public struct StickPicsProducts {
    
    public static let StickPicsPremium = "DylanWight.StickPixs.Premium"
    
    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [StickPicsProducts.StickPicsPremium]
    
    public static let store = IAPHelper(productIds: StickPicsProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
