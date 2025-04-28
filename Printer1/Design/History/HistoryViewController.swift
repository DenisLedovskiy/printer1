import UIKit
import WebKit
import QuickLook

protocol HistoryPresenterOutputInterface: AnyObject {
    func setFiles(_ files: [HistoryCellModel])
    func getSelectFile(_ file: FileModel)
}

final class HistoryViewController: GeneralViewController, QLPreviewControllerDataSource {

    private var presenter: HistoryPresenterInterface?
    private var router: HistoryRouterInterface?

    private var sections: [HistorySection] = [HistorySection]()
    private lazy var dataSource = makeDataSource()

    var fileURL: URL!

    private var selectedIndex = 0
    private var selectFile = FileModel(id: UUID(),
                                       title: "",
                                       type: "",
                                       date: Date())

    // MARK: - Value Types
    typealias DataSource = UICollectionViewDiffableDataSource<HistorySection, HistoryCellModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<HistorySection, HistoryCellModel>

    //MARK: - UI Propery

    //MARK: - UI
    private lazy var webView: WKWebView = {
        let view = WKWebView()
        view.backgroundColor = .clear
        view.isHidden = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = perevod("History")
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .prBlack
        label.font = .dmSans(.black, size: 30)
        return label
    }()

    private lazy var emptyView: EmptyHis = {
        let view = EmptyHis()
        view.didAddSelect = {
            self.selectAdd()
        }
        view.isHidden = true
        return view
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.contentInset.bottom = 20
        HistoryCell.register(collectionView)
        return collectionView
    }()

    //MARK: - Init
    init(presenter: HistoryPresenterInterface, router: HistoryRouterInterface) {
        self.presenter = presenter
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    //MARK: - Lifecicle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar(false)
        hideNavBar(true)
        presenter?.willAppear()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        customInit()
        presenter?.viewDidLoad(withView: self)
    }


    // MARK: - QLPreviewControllerDataSource

    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return fileURL as QLPreviewItem
    }

}

// MARK: - HistoryPresenterOutputInterface

extension HistoryViewController: HistoryPresenterOutputInterface {
    func getSelectFile(_ file: FileModel) {
        selectFile = file
    }
    
    func setFiles(_ files: [HistoryCellModel]) {
        DispatchQueue.main.async { [self] in
            if files.isEmpty {
                emptyView.isHidden = false
                collectionView.isHidden = true
            } else {
                emptyView.isHidden = true
                collectionView.isHidden = false
                setSections(HistorySection.makeSection(files))
            }
        }
    }
}

// MARK: - Action

private extension HistoryViewController {

    func selectAdd() {
        tabBar?.setHomeScreen()
    }
}

//MARK: - Sheet menu
private extension HistoryViewController {
    func presentSheet() {
        let alertStyle = UIAlertController.Style.actionSheet

        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: alertStyle)

        alert.addAction(UIAlertAction(title: perevod("View"),
                                      style: .default,
                                      handler: { (UIAlertAction) in
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            self.presenter?.selectView(self.selectedIndex)
        }))
        alert.addAction(UIAlertAction(title: perevod("Share"),
                                      style: .default,
                                      handler:{ (UIAlertAction) in
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            self.presenter?.selectShare(self.selectedIndex)
        }))
        alert.addAction(UIAlertAction(title: perevod("Print"),
                                      style: .default,
                                      handler:{ (UIAlertAction)in
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            self.print()
        }))
        alert.addAction(UIAlertAction(title: perevod("Delete"),
                                      style: .destructive,
                                      handler:{ (UIAlertAction)in
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            self.delete()
        }))

        alert.addAction(UIAlertAction(title: perevod("Cancel"),
                                      style: .cancel,
                                      handler: nil))

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: { })
        }
    }

    func delete() {
        presenter?.selectDelete(selectedIndex)
    }

    func routeInApp() {
        let vc = InAppInit.createViewController()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }

    func print() {
        guard MoneyManager.shared.isPremium else {
            routeInApp()
            return
        }

        if selectFile.type == "" {
            let printController = UIPrintInteractionController.shared
            printController.delegate = self
            let renderer = UIPrintPageRenderer()
            renderer.addPrintFormatter(webView.viewPrintFormatter(), startingAtPageAt: 0)

            printController.printPageRenderer = renderer
            printController.printInfo = UIPrintInfo(dictionary: nil)
            printController.printInfo?.outputType = .general
            printController.present(animated: true, completionHandler: nil)
        } else {
            let fileName = "\(selectFile.title).\(selectFile.type)"
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            guard let fileURL = documentsDirectory?.appendingPathComponent(fileName) else {return}

            let printController = UIPrintInteractionController.shared
            printController.delegate = self

            let file = selectFile
            if file.type == "pdf" {
                printController.printingItem = fileURL
            } else {
                let renderer = UIPrintPageRenderer()
                renderer.addPrintFormatter(webView.viewPrintFormatter(), startingAtPageAt: 0)
                printController.printPageRenderer = renderer
            }
            printController.printInfo = UIPrintInfo(dictionary: nil)
            printController.printInfo?.outputType = .general
            printController.present(animated: true, completionHandler: nil)
        }
    }

    func setWebView() {
        if selectFile.type == "" {
            let myURL = URL(string: selectFile.title)
            if let url = myURL {
                let request = URLRequest(url: url)
                webView.load(request)
            }
        } else if selectFile.type != "pdf" {
            let fileName = "\(selectFile.title).\(selectFile.type)"
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            guard let fileURL = documentsDirectory?.appendingPathComponent(fileName) else {return}
            let request = URLRequest(url: fileURL)
            webView.load(request)
        }

    }
}

//MARK: - UIPrintInteractionControllerDelegate
extension HistoryViewController: UIPrintInteractionControllerDelegate {

}


//MARK: - Collection

private extension HistoryViewController {

    // MARK: - makeDataSource
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) ->
                UICollectionViewCell? in
                let cell = HistoryCell.getCell(collectionView, for: indexPath)
                cell.setCell(item)
                return cell
            })
        return dataSource
    }

    // MARK: - makeLayout
    func makeLayout() -> UICollectionViewCompositionalLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()

        return UICollectionViewCompositionalLayout(sectionProvider: { [self] section, _ in
            setGrid(HistoryCell.size)
        }, configuration: configuration)
    }

    func setGrid(_ size: CGSize) -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(size.width),
                                              heightDimension: .absolute(size.height))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(size.height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
        group.interItemSpacing = .fixed(16)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        section.contentInsets = .init(top: 0,
                                      leading: 22,
                                      bottom: 0,
                                      trailing: 22)
        return section
    }

    private func setSections(_ section: [HistorySection]) {
        self.sections = section
        applySnapshot()
    }

    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

//MARK: - UICollectionViewDelegate

extension HistoryViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        selectedIndex = indexPath.row
        presenter?.selectFile(indexPath.row)
        presentSheet()
        setWebView()
    }
}

// MARK: - UISetup

private extension HistoryViewController {
    func customInit() {
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(emptyView)
        view.addSubview(collectionView)

        titleLabel.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(isSmallPhone ? 24 : 36)
            $0.leading.trailing.equalToSuperview().inset(22)
        })

        emptyView.snp.makeConstraints({
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })

        collectionView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(22)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })

        webView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
}
