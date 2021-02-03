//
//  String+Extension.swift
//  VisionSampleProject
//
//  Created by James Rochabrun on 2/2/21.
//

import UIKit

extension String {
    
    func image(of size: CGSize, scale: CGFloat = 0.94) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.set()
        let rect: CGRect = .init(origin: .zero, size: .zero)
        UIRectFill(.init(origin: .zero, size: .zero))
        (self as AnyObject).draw(with: rect, options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: size.height * scale)], context: nil)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
