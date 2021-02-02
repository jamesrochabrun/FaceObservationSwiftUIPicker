//
//  VNFaceLandMarks2D+Extension.swift
//  VisionSampleProject
//
//  Created by James Rochabrun on 2/1/21.
//

import Vision
import UIKit

extension Array where Element == CGPoint {
    
    var centerPoint: CGPoint {
        let elements = CGFloat(count)
        let totalX = reduce(0, { $0 + $1.x} )
        let totalY = reduce(0, { $0 + $1.y} )
        return CGPoint(x: totalX / elements, y: totalY / elements)
    }
}

extension VNFaceLandmarks2D {
    
    func anchorPointImage(_ image: UIImage) -> (center: CGPoint?, angle: CGFloat?) {
        // centre each set of points that may have been detected, if present
        let allPoints = self.allPoints?.pointsInImage(imageSize: image.size).centerPoint
        let leftPupil = self.leftPupil?.pointsInImage(imageSize: image.size).centerPoint
        let leftEye = self.leftEye?.pointsInImage(imageSize: image.size).centerPoint
        let leftEyebrow = self.leftEyebrow?.pointsInImage(imageSize: image.size).centerPoint
        let rightPupil = self.rightPupil?.pointsInImage(imageSize: image.size).centerPoint
        let rightEye = self.rightEye?.pointsInImage(imageSize: image.size).centerPoint
        let rightEyebrow = self.rightEyebrow?.pointsInImage(imageSize: image.size).centerPoint
        let outerLips = self.outerLips?.pointsInImage(imageSize: image.size).centerPoint
        let innerLips = self.innerLips?.pointsInImage(imageSize: image.size).centerPoint
     
        let leftEyeCenter = leftPupil ?? leftEye ?? leftEyebrow
        let rightEyeCenter = rightPupil ?? rightEye ?? rightEyebrow
        let mouthCenter = innerLips ?? outerLips
        
        if let leftEyePoint = leftEyeCenter,
           let rightEyePoint = rightEyeCenter,
           let mouthPoint = mouthCenter {
            let triadCenter = [leftEyePoint, rightEyePoint, mouthPoint].centerPoint
            let eyesCenter = [leftEyePoint, rightEyePoint].centerPoint
            return (eyesCenter, triadCenter.rotationDegreesTo(eyesCenter))
        }
        // fallback
        return (allPoints, 0.0)
    }
}

extension CGPoint {
    
    func rotationDegreesTo(_ otherPoint: CGPoint) -> CGFloat {
        let origiX = otherPoint.x - x
        let originY = otherPoint.y - y
        let degreesFromX = atan2f(Float(originY), Float(origiX)) * (180 / .pi)
        let degreesFromY = degreesFromX - 90.0
        let normalizedDegrees = (degreesFromY + 360.0).truncatingRemainder(dividingBy: 360.0)
        return CGFloat(normalizedDegrees)
    }
}
