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

    private let printerDS: PrinterCDDataSource = Store.viewContext.printeDS

    init(router: ImportRouterInterface) {
        self.router = router
    }
}

// MARK: - Private
private extension ImportPresenter {

    func saveFileInCD(_ file: FileModel) {
        Store.viewContext.addFile(item: file) { result in
            switch result {
            case .fail(let error): print("Error: ", error)
            case .success: print("Success save file in CD")
            }
        }
    }

    func saveAsPDF(images: [UIImage]) {
        let document = images.createPDF()
        let fileName = getFileNameForPDF()

        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let fileURL = documentsDirectory?.appendingPathComponent("\(fileName).pdf") else {return}

        document.write(to: fileURL)

        let file = FileModel(id: UUID(),
                             title: fileName,
                             type: "pdf",
                             date: Date())
        saveFileInCD(file)
        router.routeDocPreview(file: file)
    }

    func getFileNameForPDF() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy HH:mm"
        let currentDateTimeString = dateFormatter.string(from: Date())
        return "PDF \(currentDateTimeString)"
    }
}

// MARK: - ImportPresenterInterface

extension ImportPresenter: ImportPresenterInterface {
    func needShowPreview(_ file: FileModel) {
        saveFileInCD(file)
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
