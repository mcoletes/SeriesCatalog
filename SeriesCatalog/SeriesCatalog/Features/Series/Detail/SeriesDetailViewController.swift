//
//  SeriesDetailViewController.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 28/05/22.
//

import UIKit
import Combine

typealias SeriesDetailDataSource = UITableViewDiffableDataSource<SeriesDetailModels.Section, SeriesDetailModels.Cell>
typealias SeriesDetailSnapshot = NSDiffableDataSourceSnapshot<SeriesDetailModels.Section, SeriesDetailModels.Cell>

class SeriesDetailViewController: UITableViewController, LoadableProtocol {
  
  private lazy var segmentedControl: UISegmentedControl = {
    let segmentedControl = UISegmentedControl(items: ["Details", "Episodes"])
    segmentedControl.selectedSegmentIndex = 0
    segmentedControl.backgroundColor = .systemBackground
    segmentedControl.sizeToFit()
    segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    return segmentedControl
  }()
  
  let viewModel: SeriesDetailViewModelProtocol
  var cancellables: Set<AnyCancellable> = []
  lazy var datasource: SeriesDetailDataSource = makeDataSource()
  private var model: SeriesDetailModels.Model?
  
  init(viewModel: SeriesDetailViewModelProtocol) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    viewModel.load()
    navigationItem.titleView = segmentedControl
  }
  
  private func setup() {
    registerCells()
    bind()
  }
  
  private func registerCells() {
    tableView.separatorColor = .clear
    tableView.delegate = self
    tableView.register(DetailInfoCell.self)
    tableView.register(DetailTitleCell.self)
    tableView.register(DetailInfoImageCell.self)
  }
  
  func bind() {
    viewModel.statePublisher
      .receive(on: RunLoop.main)
      .sink { [weak self] state in
        guard let self = self else { return }
        self.handleState(state: state)
      }.store(in: &cancellables)
  }
  
  private func handleState(state: SeriesDetailState) {
    switch state {
    case .loading:
      showLoading()
    case .loaded(let model):
      hideLoading()
      self.model = model
      loadContent(with: model)
      break
    default:
      break
    }
  }
  
  @objc func segmentedControlValueChanged() {
    guard let model = model else { return }
    loadContent(with: model)
  }
  
  private func loadContent(with model: SeriesDetailModels.Model) {
    switch segmentedControl.selectedSegmentIndex {
    case 0:
      loadMainDetailContent(with: model.mainDetailSection)
    case 1:
      loadEpisodesContent(with: model.episodeSections)
    default:
      break
    }
  }
  
  private func loadMainDetailContent(with mainSection: SeriesDetailModels.Section) {
    var snapshot = SeriesDetailSnapshot()
    snapshot.appendSections([mainSection])
    snapshot.appendItems(mainSection.rows, toSection: mainSection)
    datasource.apply(snapshot, animatingDifferences: true)
  }
  
  private func loadEpisodesContent(with episodesSections: [SeriesDetailModels.Section]) {
    var snapshot = SeriesDetailSnapshot()
    snapshot.appendSections(episodesSections)
   
    episodesSections.forEach { section in
      snapshot.appendItems(section.rows, toSection: section)
    }
    datasource.apply(snapshot, animatingDifferences: true)
  }
  
  // MARK: - Table view data source
  
  func makeDataSource() -> SeriesDetailDataSource {
    return SeriesDetailDataSource(tableView: tableView) { tableView, indexPath, model in
      switch model {
      case .logoAndTitle(let imageUrl, let title):
        let cell: DetailTitleCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setup(title: title, imageURL: imageUrl)
        return cell
      case .detalInfo(let title, let description):
        let cell: DetailInfoCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setup(title: title, description: description)
        return cell
      case .detalInfoImage(let imageUrl, let title, let description):
        let cell: DetailInfoImageCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setup(imageUrl: imageUrl, title: title, description: description)
        return cell
      }
    }
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard shouldAddHeader(), let model = model, section < model.episodeSections.count else { return nil }
    let label = UILabel()
    label.text = model.episodeSections[section].type.title
    label.backgroundColor = .systemBackground
    return label
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return shouldAddHeader() ? 30: 0
  }
  
  private func shouldAddHeader() -> Bool {
    return segmentedControl.selectedSegmentIndex != 0
  }
}