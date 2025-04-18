import UIKit

protocol ImportPresenterOutputInterface: AnyObject {

}

final class ImportViewController: GeneralViewController {

    private var presenter: ImportPresenterInterface?
    private var router: ImportRouterInterface?

    private var sections: [ImportSection] = ImportSection.makeSection()
    private lazy var dataSource = makeDataSource()

    // MARK: - Value Types
    typealias DataSource = UICollectionViewDiffableDataSource<ImportSection, ImportCellModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<ImportSection, ImportCellModel>

    //MARK: - UI Propery

    //MARK: - UI
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = perevod("Air Printer")
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .prBlack
        label.font = .dmSans(.black, size: 30)
        return label
    }()

    private lazy var top: ImportTop = {
        let view = ImportTop()
        view.didSelect = {
            self.select()
        }
        return view
    }()

    private let importLabel: UILabel = {
        let label = UILabel()
        label.text = perevod("Import Files")
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .prBlack
        label.font = .dmSans(.heavy, size: 20)
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        ImportCell.register(collectionView)
        return collectionView
    }()

    //MARK: - Init
    init(presenter: ImportPresenterInterface, router: ImportRouterInterface) {
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
        applySnapshot()
    }
}

// MARK: - ImportPresenterOutputInterface

extension ImportViewController: ImportPresenterOutputInterface {

}

// MARK: - Action

private extension ImportViewController {

    func select() {
        presenter?.selectAddPrinter()
    }
}

//MARK: - Collection

private extension ImportViewController {

    // MARK: - makeDataSource
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) ->
                UICollectionViewCell? in
                let cell = ImportCell.getCell(collectionView, for: indexPath)
                cell.setCell(item)
                return cell
            })
        return dataSource
    }

    // MARK: - makeLayout
    func makeLayout() -> UICollectionViewCompositionalLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()

        return UICollectionViewCompositionalLayout(sectionProvider: { [self] section, _ in
            setGrid(ImportCell.size)
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

extension ImportViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
//        presenter?.needShowDocument(indexPath.row)

        switch indexPath.row {
        case 3: presenter?.selectBroweser()
        default: return
        }
    }
}

// MARK: - UISetup

private extension ImportViewController {
    func customInit() {
        view.addSubview(titleLabel)
        view.addSubview(top)
        view.addSubview(importLabel)
        view.addSubview(collectionView)

        titleLabel.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(isSmallPhone ? 24 : 36)
            $0.leading.trailing.equalToSuperview().inset(22)
        })

        top.snp.makeConstraints({
            $0.top.equalTo(titleLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(22)
            $0.height.equalTo(147)
        })

        importLabel.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(22)
            $0.top.equalTo(top.snp.bottom).offset(22)
        })

        collectionView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(importLabel.snp.bottom).offset(12)
            $0.bottom.equalToSuperview()
        })
    }
}

