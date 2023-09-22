//
//  PDFViewerController.swift
//  Femtech
//
//  Created by Lee on 2023/09/21.
//

import UIKit
import PDFKit
import UniformTypeIdentifiers

class ImageStampAnnotation: PDFAnnotation {
    
    var image: UIImage!
    
    // A custom init that sets the type to Stamp on default and assigns our Image variable
    init(with image: UIImage!, forBounds bounds: CGRect, withProperties properties: [AnyHashable : Any]?) {
        super.init(bounds: bounds, forType: PDFAnnotationSubtype.stamp, withProperties: properties)
        self.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(with box: PDFDisplayBox, in context: CGContext) {
        
        // Get the CGImage of our image
        guard let cgImage = self.image.cgImage else { return }
        // Draw our CGImage in the context of our PDFAnnotation bounds
        context.draw(cgImage, in: self.bounds)
    }
}

final class PDFViewerController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var addSignatureButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .compose,
                                     target: self,
                                     action: #selector(self.moveToSignViewController))
        return button
    }()
    private lazy var shareButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .action,
                                     target: self,
                                     action: #selector(self.sharePDFButton))
        return button
    }()
    
    // MARK:  PDF 관련 properties
    
    let pdfView = PDFView()
    var currentlySelectedAnnotation: PDFAnnotation?
    var signatureImage: UIImage?
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavigationButton()
        self.setPanGesture()
    }
    
    override func loadView() {
        super.loadView()
        self.view = pdfView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setImageStamp()
    }
    
    // MARK: - Helpers

    @objc private func sharePDFButton() {
        // pdf 공유 구현...
    }
    
    private func addNavigationButton() {
        self.navigationItem.rightBarButtonItem = self.addSignatureButton
    }
    
    @objc private func moveToSignViewController() {
        let signViewController = SignViewController()
        signViewController.delegate = self
        self.navigationController?.pushViewController(signViewController, animated: true)
    }
    
    private func setPanGesture() {
        self.pdfView.isUserInteractionEnabled = true
        let panAnnotationGesture = UIPanGestureRecognizer(target: self, action: #selector(self.didPanAnnotation(sender:)))
        self.pdfView.addGestureRecognizer(panAnnotationGesture)
    }
    
    // MARK: PDF 서명 이동 관련
    // 주의 : 이동을 원하는 page 전체가 화면에 보여졌을 때만 gesture recognizer 작동
    // 주의2 : 페이지를 넘어가는 이동은 불가 (-> 처음 입력할 때 이미지가 들어가는 페이지 설정할 수 있음)
    @objc private func didPanAnnotation(sender: UIPanGestureRecognizer) {
        let touchLocation = sender.location(in: self.pdfView)
        
        guard let page = self.pdfView.page(for: touchLocation, nearest: true) else {
                return
        }
        // Converts a point from view coordinates to page coordinates.
        let locationOnPage = self.pdfView.convert(touchLocation, to: page)
        
        switch sender.state {
        case .began:
            guard let annotation = page.annotation(at: locationOnPage) else {
                return
            }
            
            if annotation.isKind(of: ImageStampAnnotation.self) {
                currentlySelectedAnnotation = annotation
            }
            
        case .changed:
            guard let annotation = currentlySelectedAnnotation else {
                return
            }
            let initialBounds = annotation.bounds
            // Set the center of the annotation to the spot of our finger
            annotation.bounds = CGRect(x: locationOnPage.x - (initialBounds.width / 2), y: locationOnPage.y - (initialBounds.height / 2), width: initialBounds.width, height: initialBounds.height)
            
            print("move to \(locationOnPage)")
        case .ended, .cancelled, .failed:
            currentlySelectedAnnotation = nil
        default:
            break
        }
    }
    
    private func setImageStamp() {
        guard let signatureImage,
              let page = pdfView.currentPage else { return }
        let pageBounds = page.bounds(for: .cropBox)
        // 이미지 크기/위치 조정하는 부분
        // UI 이미지를 ImageStampAnnotation 객체를 통해 PDFannotation stamp로 변환해 입력
        let imageBounds = CGRect(x: pageBounds.midX,
                                 y: pageBounds.midY,
                                 width: 200,
                                 height: 200)
        let imageStamp = ImageStampAnnotation(with: signatureImage,
                                              forBounds: imageBounds,
                                              withProperties: nil)
        page.addAnnotation(imageStamp)
    }
   
}

extension PDFViewerController: SignViewControllereDelegate {
    func getSignatureImage(image: UIImage) {
        self.signatureImage = image
    }
}
