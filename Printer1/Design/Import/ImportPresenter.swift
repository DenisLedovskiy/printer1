import UIKit

protocol ImportPresenterInterface {
    func viewDidLoad(withView view: ImportPresenterOutputInterface)
    func selectAddPrinter()
    func selectBroweser()
    func doPdfFromImg(_ pictures: [UIImage])
    func needShowPreview(_ file: FileModel)
}

final class ImportPresenter: NSObject {

    private weak var view: ImportPresenterOutputInterface?
    private var router: ImportRouterInterface

    init(router: ImportRouterInterface) {
        self.router = router
    }
}

// MARK: - Private
private extension ImportPresenter {
//    func fetchDocs(_ completion: (() -> Void)? = nil) {
//        pdfDataSource.fetch { result in
//            switch result {
//            case .fail(let error): print("Error: ", error)
//            case .success:
//                print("Success fetch Docs. Count = \(self.pdfDataSource.count)")
//                if self.pdfDataSource.count > 0 {
//                    let docs = self.pdfDataSource.getAllPDFModels()
//                    self.allDocs = docs
//                    self.view?.setDocs(docs)
//                } else {
//                    self.allDocs = [PdfMainModel]()
//                    self.view?.setDocs([PdfMainModel]())
//                }
//                completion?()
//            }
//        }
//    }

//    func addNewPDF(_ title: String) {
//        var nameWithoutPdf = title
//        if let lastDotIndex = title.lastIndex(of: ".") {
//            let nameWithoutExtension = title[..<lastDotIndex]
//            nameWithoutPdf = String(nameWithoutExtension)
//        }
//        let model = PdfMainModel(id: UUID(),
//                                 name: nameWithoutPdf,
//                                 date: Date(),
//                                 isEdited: false)
//
//        Store.viewContext.addPDF(item: model) { result in
//            switch result {
//            case .fail(let error): print("Error: ", error)
//            case .success: print("Success add pdf in CD with name - \(title)")
//                self.fetchDocs()
//            }
//        }
//    }

    func saveAsPDF(images: [UIImage]) {
        let document = images.createPDF()
        let fileName = getFileNameForPDF()

        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let fileURL = documentsDirectory?.appendingPathComponent("\(fileName).pdf") else {return}

        document.write(to: fileURL)
        //TODO: - Сделать созрание в кор дату
//        self.addNewPDF(fileName)
    }

    //TODO: - Сделать создание имени не по дате
    func getFileNameForPDF() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy HH:mm"
        let currentDateTimeString = dateFormatter.string(from: Date())
        return "\(currentDateTimeString)"
    }
}

// MARK: - ImportPresenterInterface

extension ImportPresenter: ImportPresenterInterface {
    func needShowPreview(_ file: FileModel) {
        router.routeDocPreview(file: file)
    }
    
    func selectBroweser() {
        router.routeBroweser()
    }
    
    func selectAddPrinter() {
        router.routeAddPrinter()
    }
    
    func viewDidLoad(withView view: ImportPresenterOutputInterface) {
        self.view = view
    }

    func doPdfFromImg(_ pictures: [UIImage]) {
        saveAsPDF(images: pictures)
    }
}
