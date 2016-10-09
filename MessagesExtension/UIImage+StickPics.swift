//
//  UIImage+StickPics.swift
//  StickPics
//
//  Created by Dylan Wight on 10/9/16.
//  Copyright © 2016 Dylan Wight. All rights reserved.
//

import UIKit

extension UIImage {
    func cropToSquare(_ center: CGPoint, cropSize: CGSize) -> UIImage {
        var cropCenter = center
        // fixes cropping distorion on edges
        if (center.x < cropSize.width/2) {
            cropCenter.x = cropSize.width/2
        } else if (center.x > self.size.width - cropSize.width/2){
            cropCenter.x = self.size.width - cropSize.width/2
        }
        if (center.y < cropSize.height/2) {
            cropCenter.y = cropSize.height/2
        } else if (center.y > self.size.height - cropSize.height/2){
            cropCenter.y = self.size.height - cropSize.height/2
        }
        
        let posX = cropCenter.x - cropSize.width / 2
        let posY = cropCenter.y - cropSize.height / 2
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cropSize.width, height: cropSize.height)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = self.cgImage!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef)
        
        return image
    }
    
    func toBase64() -> String {
        let imageData = UIImagePNGRepresentation(self)!
        let base64String: String = imageData.base64EncodedString(options: NSData.Base64EncodingOptions())
        return base64String
    }
    
    static func fromBase64(_ base64String: String) -> UIImage? {
        if let decodedData = Data(base64Encoded: base64String, options: NSData.Base64DecodingOptions()) {
            return UIImage(data: decodedData)
        }
        return nil
    }
}
