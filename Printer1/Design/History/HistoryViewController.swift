import UIKit

protocol HistoryPresenterOutputInterface: AnyObject {

}

final class HistoryViewController: GeneralViewController {

    private var presenter: HistoryPresenterInterface?
    private var router: HistoryRouterInterface?

    private var sections: [HistorySection] = [HistorySection]()
    private lazy var dataSource = makeDataSource()

    // MARK: - Value Types
    typealias DataSource = UICollectionViewDiffableDataSource<HistorySection, HistoryCellModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<HistorySection, HistoryCellModel>

    //MARK: - UI Propery

    //MARK: - UI
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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        customInit()
        presenter?.viewDidLoad(withView: self)

        let items = [HistoryCellModel(date: "10/04/2025 12:00", title: "dsd asdasfdf asfasf asf a", type: "DOC"),
                     HistoryCellModel(date: "10/04/2025 12:00", title: "dsd asdasfdf asfasf asf a", type: "DOcX"),
                     HistoryCellModel(date: "10/04/2025 12:00", title: "dsd asdasfdf asfasf asf a", type: "xlxs"),
                     HistoryCellModel(date: "10/04/2025 12:00", title: "dsd asdasfdf asfasf asf a", type: "pdf")]
        let sections = HistorySection.makeSection(items)
        self.setSections(sections)
    }
}

// MARK: - HistoryPresenterOutputInterface

extension HistoryViewController: HistoryPresenterOutputInterface {

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

        }))
        alert.addAction(UIAlertAction(title: perevod("Share"),
                                      style: .default,
                                      handler:{ (UIAlertAction) in
            UIImpactFeedbackGenerator(style: .light).impactOccurred()

        }))
        alert.addAction(UIAlertAction(title: perevod("Print"),
                                      style: .default,
                                      handler:{ (UIAlertAction)in
            UIImpactFeedbackGenerator(style: .light).impactOccurred()

        }))
        alert.addAction(UIAlertAction(title: perevod("Delete"),
                                      style: .destructive,
                                      handler:{ (UIAlertAction)in
            UIImpactFeedbackGenerator(style: .light).impactOccurred()

        }))

        alert.addAction(UIAlertAction(title: perevod("Cancel"),
                                      style: .cancel,
                                      handler: nil))

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: { })
        }
    }
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
//        presenter?.needShowDocument(indexPath.row)
        presentSheet()
    }
}

// MARK: - UISetup

private extension HistoryViewController {
    func customInit() {
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
    }
}
