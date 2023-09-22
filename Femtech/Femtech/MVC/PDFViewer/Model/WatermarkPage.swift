//
//  WatermarkPage.swift
//  Femtech
//
//  Created by Lee on 2023/09/22.
//

import PDFKit

final class WatermarkPage: PDFPage {
    
    override func draw(with box: PDFDisplayBox, to context: CGContext) {
        super.draw(with: box, to: context)
        
        UIGraphicsPushContext(context)
        context.saveGState()

        let pageBounds = self.bounds(for: box)
        context.translateBy(x: 0.0, y: pageBounds.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
//        context.rotate(by: CGFloat.pi / 4.0)
        context.rotate(by: 0)

        
//        let string: NSString = "U s e r   3 1 4 1 5 9"
//        let attributes: [NSAttributedString.Key: Any] = [
//            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.4980392157, green: 0.4980392157, blue: 0.4980392157, alpha: 0.5),
//            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 64)
//        ]
//        string.draw(at: CGPoint(x: 250, y: 40), withAttributes: attributes)

        let notOriginalString: NSString = "원본대조필"
        let attributesForNotOriginalString: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.red,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)
        ]
        notOriginalString.draw(at: CGPoint(x: 20, y: 20), withAttributes: attributesForNotOriginalString)

//        context.rotate(by: -CGFloat.pi / 4.0)

        context.restoreGState()
        UIGraphicsPopContext()
    }
    
    
}
