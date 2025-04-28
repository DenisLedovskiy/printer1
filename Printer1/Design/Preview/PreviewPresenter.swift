import UIKit
import PDFKit

protocol PreviewPresenterInterface {
    func viewDidLoad(withView view: PreviewPresenterOutputInterface)
    func addImgToPDF(title: String, pdf: PDFDocument, images: [UIImage])
    func needSplitPDF(title: String, pdf1: PDFDocument, pdf2: PDFDocument)
}

final class PreviewPresenter: NSObject {

    private weak var view: PreviewPresenterOutputInterface?
    private var router: PreviewRouterInterface

    init(router: PreviewRouterInterface) {
        self.router = router
    }
}

private extension PreviewPresenter {

    func addImagesToPDf(title: String, pdf: PDFDocument, images: [UIImage]) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileName = "\(title).pdf"
        guard let fileURL = documentsDirectory?.appendingPathComponent(fileName) else {return}

        let pdfFromImg = images.createPDF()

        let myDocPageCount = pdf.pageCount
        for index in 0..<pdfFromImg.pageCount {
            if let page = pdfFromImg.page(at: index) {
                pdf.insert(page, at: myDocPageCount + index)
            }
        }
        pdf.write(to: fileURL)
        view?.reloadPDF()
    }

    func splitPDF(title: String, pdfDoc1: PDFDocument, pdfDoc2: PDFDocument) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileName = "\(title).pdf"
        guard let fileURL = documentsDirectory?.appendingPathComponent(fileName) else {return}

        let myDocPageCount = pdfDoc1.pageCount
        for index in 0..<pdfDoc2.pageCount {
            if let page = pdfDoc2.page(at: index) {
                pdfDoc1.insert(page, at: myDocPageCount + index)
            }
        }
        pdfDoc1.write(to: fileURL)
        view?.reloadPDF()
    }
}

// MARK: - PreviewPresenterInterface

extension PreviewPresenter: PreviewPresenterInterface {
    func needSplitPDF(title: String, pdf1: PDFDocument, pdf2: PDFDocument) {
        splitPDF(title: title, pdfDoc1: pdf1, pdfDoc2: pdf2)
    }
    
    func addImgToPDF(title: String, pdf: PDFDocument, images: [UIImage]) {
        addImagesToPDf(title: title, pdf: pdf, images: images)
    }
    
    func viewDidLoad(withView view: PreviewPresenterOutputInterface) {
        self.view = view
    }
}
