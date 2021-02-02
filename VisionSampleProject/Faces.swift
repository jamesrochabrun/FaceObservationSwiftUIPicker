//
//  Faces.swift
//  VisionSampleProject
//
//  Created by James Rochabrun on 2/1/21.
//

import Vision
import UIKit

extension Collection where Element == VNFaceObservation {
    
    func drawOn(_ image: UIImage) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, 1.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        context.setStrokeColor(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1).cgColor)
        context.setLineWidth(0.01 * image.size.width)
        let transform = CGAffineTransform.init(scaleX: 1, y: -1).translatedBy(x: 0, y: -image.size.height)
        
        forEach {
            let rect = $0.boundingBox
            let normalizedRect = VNImageRectForNormalizedRect(rect, Int(image.size.width), Int(image.size.height))
                .applying(transform)
            context.stroke(normalizedRect)
        }
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
