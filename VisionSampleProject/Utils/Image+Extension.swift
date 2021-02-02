//
//  Image+Extension.swift
//  VisionSampleProject
//
//  Created by James Rochabrun on 2/1/21.
//

import UIKit
import SwiftUI
import Vision

extension UIImage {
    
    func detectFaces(_ completion: @escaping (([VNFaceObservation]?) -> Void)) {
        
        guard let image = cgImage else { return completion(nil) }
        let request = VNDetectFaceRectanglesRequest()
        DispatchQueue.global().async {
            let handler: VNImageRequestHandler = .init(cgImage: image, orientation: self.cgImageOrientation, options: [:])
            try? handler.perform([request])
            guard let observations = request.results as? [VNFaceObservation] else { return completion(nil) }
            completion(observations)
        }
    }
    
    func fixOrientation() -> UIImage? {
        UIGraphicsBeginImageContext(size)
        draw(at: .zero)
        let newimage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newimage
    }
    
    var cgImageOrientation: CGImagePropertyOrientation {
        switch imageOrientation {
        case .up: return .up
        case .down: return .down
        case .left: return .left
        case .right: return .right
        case .upMirrored: return .upMirrored
        case .downMirrored: return .downMirrored
        case .leftMirrored: return .leftMirrored
        case .rightMirrored: return .rightMirrored
        @unknown default:
            fatalError()
        }
    }
    
    func rotatedBy(degrees: CGFloat, clockwise: Bool = false) -> UIImage? {
        var radians = (degrees) * (.pi / 180)
        
        if !clockwise {
            radians = -radians
        }
        let transform: CGAffineTransform = .init(rotationAngle: CGFloat(radians))
        
        let newSize = CGRect(origin: .zero, size: self.size).applying(transform).size
        let roundedSize: CGSize = .init(width: floor(newSize.width), height: floor(newSize.height))
        let centeredRect: CGRect = .init(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(roundedSize, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.translateBy(x: roundedSize.width / 2, y: roundedSize.height / 2)
        context.rotate(by: radians)
        draw(in: centeredRect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}

