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
}

