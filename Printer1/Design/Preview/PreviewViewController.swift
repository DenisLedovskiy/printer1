import UIKit
import WebKit
import PDFKit
import QuickLook

protocol PreviewPresenterOutputInterface: AnyObject {

}

final class PreviewViewController: GeneralViewController {

    private var presenter: PreviewPresenterInterface?
    private var router: PreviewRouterInterface?

    private var file: FileModel
    var fileURL: URL!

    //MARK: - UI
    private lazy var webView: WKWebView = {
        let view = WKWebView()
        let configuration = WKWebViewConfiguration()
        view.backgroundColor = .clear
        return view
    }()

    private lazy var pdfView: PDFView = {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.interpolationQuality = .low
        pdfView.backgroundColor = .clear
        return pdfView
    }()

    private lazy var backBtn: UIButton = {
        let button = UIButton()
        button.setImage(.brBack, for: .normal)
        button.setImage(.brBack, for: .highlighted)
        button.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
        return button
    }()

    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.font = .dmSans(.heavy, size: 22)
        label.textColor = .prBlack
        label.numberOfLines = 1
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 40
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]

        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 30
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.07).cgColor
        view.clipsToBounds = false
        return view
    }()

    private lazy var bottomView: BPMenu = {
        let view = BPMenu()
        view.didTap = { menuIndex in
            self.selectMenu(index: menuIndex)
        }
        return view
    }()

//MARK: - Init
    init(file: FileModel, presenter: PreviewPresenterInterface, router: PreviewRouterInterface) {
        self.presenter = presenter
        self.router = router
        self.file = file
        super.init(nibName: nil,bundle: nil)
        self.titleLabel.text = file.title
    }

    required init?(coder: NSCoder) {
        self.file = FileModel(id: UUID(), title: "", type: "", date: Date())
        super.init(coder: coder)
    }

    //MARK: -  Lifecicle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar(true)
        hideNavBar(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        customInit()
        presenter?.viewDidLoad(withView: self)
    }
}

// MARK: - PreviewPresenterOutputInterface

extension PreviewViewController: PreviewPresenterOutputInterface {

}

//MARK: - Private
private extension PreviewViewController {

    @objc func tapBack() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        close()
    }

    func close() {
        navigationController?.popViewController(animated: true)
    }

    func selectMenu(index: Int) {
//        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
//        let fileName = "\(file.title).\(file.type)"
//        guard let fileURL = documentsDirectory?.appendingPathComponent(fileName) else {return}

        guard let fileURL = Bundle.main.url(forResource: file.title, withExtension: file.type) else { return }

        switch index {
        case 0:
//            let interactionController = UIDocumentInteractionController(url: fileURL)
//            interactionController.delegate = self
//            interactionController.presentPreview(animated: true)

            self.fileURL = fileURL
                       let previewController = QLPreviewController()
                       previewController.dataSource = self
                       present(previewController, animated: true, completion: nil)
        case 1:
            let printController = UIPrintInteractionController.shared
            printController.delegate = self
            if file.type == "pdf" {
                guard let fileURL = Bundle.main.url(forResource: file.title, withExtension: "pdf") else { return }
                printController.printingItem = fileURL
            } else {
                let renderer = UIPrintPageRenderer()
                renderer.addPrintFormatter(webView.viewPrintFormatter(), startingAtPageAt: 0)
                printController.printPageRenderer = renderer
            }
            printController.printInfo = UIPrintInfo(dictionary: nil)
            printController.printInfo?.outputType = .general
            printController.present(animated: true, completionHandler: nil)
        case 2:
            return
            //TODO: Вставить функционал добавления страниц
        default: return
        }
    }
}

//MARK: - UIDocumentInteractionControllerDelegate
extension PreviewViewController: UIDocumentInteractionControllerDelegate {

    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}

// MARK: - QLPreviewControllerDataSource
extension PreviewViewController: QLPreviewControllerDataSource {

    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return fileURL as QLPreviewItem
    }
}


//MARK: - UIPrintInteractionControllerDelegate
extension PreviewViewController: UIPrintInteractionControllerDelegate {

}


// MARK: - UISetup

private extension PreviewViewController {
    func customInit() {
        if file.type == "pdf" {
            view.addSubview(pdfView)
        } else {
            view.addSubview(webView)
        }

        view.addSubview(topView)
        topView.addSubview(backBtn)
        topView.addSubview(titleLabel)
        view.addSubview(bottomView)

        topView.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(140)
        })

        titleLabel.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.bottom.equalToSuperview().offset(-18)
        })

        backBtn.snp.makeConstraints({
            $0.size.equalTo(27)
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.leading.equalToSuperview().offset(14)
        })

        bottomView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(110)
        })

        if file.type == "pdf" {
            pdfView.snp.makeConstraints({
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(bottomView.snp.top)
                $0.top.equalTo(topView.snp.bottom)
            })


            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let fileName = "\(file.title).\(file.type)"
            if let fileURL = documentsDirectory?.appendingPathComponent(fileName) {
//            guard let fileURL = Bundle.main.url(forResource: file.title, withExtension: "pdf") else { return }
                let newPdfDoc = PDFDocument(url: fileURL)
                pdfView.document = newPdfDoc
            }

            bottomView.isPDF = true
        } else {
            webView.snp.makeConstraints({
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(bottomView.snp.top)
                $0.top.equalTo(topView.snp.bottom)
            })

            //TODO: - gjvtyznm yf ad a
            if let path = Bundle.main.path(forResource: file.title, ofType: file.type) {
                let url = URL(fileURLWithPath: path)
                let request = URLRequest(url: url)
                webView.load(request)
            }

            bottomView.isPDF = false
        }

        bottomView.setCollection()
    }
}
