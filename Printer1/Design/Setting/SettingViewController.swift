import UIKit

protocol SettingPresenterOutputInterface: AnyObject {

}

final class SettingViewController: GeneralViewController {

    private var presenter: SettingPresenterInterface?
    private var router: SettingRouterInterface?

    private var sections: [SettingSection] = SettingSection.makeSection()
    private lazy var dataSource = makeDataSource()

    // MARK: - Value Types
    typealias DataSource = UICollectionViewDiffableDataSource<SettingSection, SettingCellModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<SettingSection, SettingCellModel>

    //MARK: - UI Propery

    //MARK: - UI
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = perevod("Settings")
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .prBlack
        label.font = .dmSans(.black, size: 30)
        return label
    }()

    private lazy var top: TopSett = {
        let view = TopSett()
        view.didSelect = {
            self.selectTry()
        }
        return view
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = isSmallPhone ? true : false
        collectionView.delegate = self
        SettingCell.register(collectionView)
        return collectionView
    }()

    //MARK: - Init

    init(presenter: SettingPresenterInterface, router: SettingRouterInterface) {
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
        setPremOrNotConstraits()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        customInit()
        presenter?.viewDidLoad(withView: self)
        applySnapshot()
    }
}

// MARK: - SettingPresenterOutputInterface

extension SettingViewController: SettingPresenterOutputInterface {

}

// MARK: - Actions

private extension SettingViewController {
    func selectTry() {
        presenter?.selectTry()
    }
}

//MARK: - Collection

private extension SettingViewController {

    // MARK: - makeDataSource
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) ->
                UICollectionViewCell? in
                let cell = SettingCell.getCell(collectionView, for: indexPath)
                cell.configCell(item)
                return cell
            })
        return dataSource
    }

    // MARK: - makeLayout
    func makeLayout() -> UICollectionViewCompositionalLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()

        return UICollectionViewCompositionalLayout(sectionProvider: { [self] section, _ in
            makeTableLayout(size: SettingCell.size)
        }, configuration: configuration)
    }

    func makeTableLayout(size: CGSize,
                         interGroupSpace: CGFloat = 16,
                         leftRightInset: CGFloat = 22,
                         topInset: CGFloat = 0) -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(size.width),
                                              heightDimension: .absolute(size.height))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, repeatingSubitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = interGroupSpace
        section.contentInsets = .init(top: topInset,
                                      leading: leftRightInset,
                                      bottom: 60,
                                      trailing: leftRightInset)
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

extension SettingViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        presenter?.selectMenu(indexPath.row)
    }
}


// MARK: - UISetup

private extension SettingViewController {
    func customInit() {
        view.addSubview(titleLabel)
        view.addSubview(top)
        view.addSubview(collectionView)

        titleLabel.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(isSmallPhone ? 24 : 36)
            $0.leading.trailing.equalToSuperview().inset(22)
        })

        setPremOrNotConstraits()
    }

    func setPremOrNotConstraits() {
        if MoneyManager.shared.isPremium {
            top.snp.removeConstraints()
            top.removeFromSuperview()
            view.addSubview(collectionView)

            collectionView.snp.remakeConstraints({
                $0.top.equalTo(titleLabel.snp.bottom).offset(22)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            })
        } else {
            view.addSubview(top)
            view.addSubview(collectionView)
            top.snp.remakeConstraints({
                $0.top.equalTo(titleLabel.snp.bottom).offset(15)
                $0.leading.trailing.equalToSuperview().inset(22)
                $0.height.equalTo(147)
            })

            collectionView.snp.remakeConstraints({
                $0.leading.trailing.equalToSuperview()
                $0.top.equalTo(top.snp.bottom).offset(22)
                $0.bottom.equalToSuperview()
            })
        }
    }
}
