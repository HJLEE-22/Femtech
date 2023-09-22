//
//  PDFViewerMainController.swift
//  Femtech
//
//  Created by Lee on 2023/09/21.
//

import UIKit
import PDFKit
import UniformTypeIdentifiers

final class PDFViewerMainController: UIViewController {
    
    // MARK: - Properties
    
    private let pdfViewerView = PDFViewerView()
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setActionToBrowserDirectoryButton()
        self.setActionToBrowserURLButton()
        self.title = "PDF Viewer"
    }
    
    override func loadView() {
        super.loadView()
        self.view = pdfViewerView
    }
    
    // MARK: - Helpers

    // MARK: 파일 디렉토리에서 저장된 PDF 로드
    func setActionToBrowserDirectoryButton() {
        self.pdfViewerView.browseFileDirectoryButton.addTarget(self,
                                                               action: #selector(self.openDocumentPickerAction(_:)),
                                                               for: .touchUpInside)
    }
    

    @objc func openDocumentPickerAction(_ sender: UIButton) {
        self.showDocumentPicker()
    }
    
    private func showDocumentPicker() {
        let documentPicker: UIDocumentPickerViewController
        let pdfType = "com.adobe.pdf"
        
        if #available(iOS 14.0, *) {
            let documentTypes = UTType.types(tag: "pdf", tagClass: UTTagClass.filenameExtension, conformingTo: nil)
            documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: documentTypes, asCopy: true)
        } else {
            documentPicker = UIDocumentPickerViewController(documentTypes: [pdfType], in: .import)
        }
        
        documentPicker.delegate = self
        self.present(documentPicker, animated: true, completion: nil)
    }
    //
    private func displayPDF(url: URL) {
        guard let pdfDocument = PDFDocument(url: url) else {
            print("Failed to load the PDF document.")
            return
        }
        let pdfViewerController = PDFViewerController()
        pdfDocument.delegate = self
        pdfViewerController.pdfView.document = pdfDocument
        // Enable automatic scaling of the PDF view to fit the content within the available space
        pdfViewerController.pdfView.autoScales = true
        self.navigationController?.pushViewController(pdfViewerController, animated: true)
    }
    
    // MARK: 데이터 통신을 통한 PDF 로드
        // 현재는 사용자에게서 PDF 로드
    
    func setActionToBrowserURLButton() {
        self.pdfViewerView.browseFileFromURLButton.addTarget(self,
                                                               action: #selector(self.getPdfFromURLAction(_:)),
                                                               for: .touchUpInside)
    }
    

    @objc func getPdfFromURLAction(_ sender: UIButton) {
        self.setupPdfViewFromURL()
    }
    
    private func setupPdfViewFromURL() {
        // Download simple pdf document
        DispatchQueue.global().async {
            if let documentURL = URL(string: "https://www.africau.edu/images/default/sample.pdf"),
                let data = try? Data(contentsOf: documentURL),
                let document = PDFDocument(data: data) {
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    // Set document to the view, center it, and set background color
                    let pdfViewerController = PDFViewerController()
                    // pdfview.document에 워터마크용 PDFdocument델리게이트
                    document.delegate = self
                    pdfViewerController.pdfView.document = document
                    pdfViewerController.pdfView.autoScales = true
                    pdfViewerController.pdfView.backgroundColor = UIColor.lightGray
                    self.navigationController?.pushViewController(pdfViewerController, animated: true)
                }
            }
        }
    }
    
    
}

extension PDFViewerMainController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        print("DEBUG: url \(url)")
        self.displayPDF(url: url)
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PDFViewerMainController: PDFDocumentDelegate {
    func classForPage() -> AnyClass {
        return WatermarkPage.self
    }
}
