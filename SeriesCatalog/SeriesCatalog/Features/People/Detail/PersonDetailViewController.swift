//
//  PeopleDetailViewController.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 30/05/22.
//

import UIKit
import Combine

typealias PersonDetailDataSource = UITableViewDiffableDataSource<PersonDetailModels.Section, PersonDetailModels.Cell>
typealias PersonDetailSnapshot = NSDiffableDataSourceSnapshot<PersonDetailModels.Section, PersonDetailModels.Cell>

class PersonDetailViewController: UITableViewController, LoadableProtocol, ErrorProtocol {
  
  // MARK: - Properties

  private let viewModel: PersonDetailViewModelProtocol
  private var cancellables: Set<AnyCancellable> = []
  private lazy var datasource: PersonDetailDataSource = makeDataSource()
  private var model: PersonDetailModels.Model?
  
  // MARK: - Initializer

  init(viewModel: PersonDetailViewModelProtocol) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    viewModel.load()
  }
  
  // MARK: - Methods
  
  private func setup() {
    setupUI()
    registerCells()
    bind()
  }
  
  private func setupUI() {
    title = "Detail"
    navigationItem.backButtonDisplayMode = .minimal
  }
  
  private func registerCells() {
    tableView.separatorColor = .clear
    tableView.delegate = self
    tableView.register(SeriesListCell.self)
    tableView.register(DetailTitleCell.self)
  }
  
  func bind() {
    viewModel.statePublisher
      .receive(on: RunLoop.main)
      .sink { [weak self] state in
        guard let self = self else { return }
        self.handleState(state: state)
      }.store(in: &cancellables)
  }
  
  private func handleState(state: RegularStates<PersonDetailModels.Model>) {
    state == .loading ? showLoading() : hideLoading()
    switch state {
    case .success(let model):
      self.model = model
      loadContent(with: model)
    case .error(let error, let action):
      showError(serviceError: error, action: action)
    default:
      break
    }
  }
  
  private func loadContent(with model: PersonDetailModels.Model) {
    var snapshot = PersonDetailSnapshot()
    snapshot.appendSections(model.sections)
    model.sections.forEach({ snapshot.appendItems($0.cells, toSection: $0) })
    datasource.apply(snapshot, animatingDifferences: true)
  }

  // MARK: - Table view data source
  
  func makeDataSource() -> PersonDetailDataSource {
    return PersonDetailDataSource(tableView: tableView) { tableView, indexPath, model in
      switch model {
      case .logoAndTitle(let imageUrl, let title):
        let cell: DetailTitleCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setup(title: title, imageURL: imageUrl)
        return cell
      case .series(let listModel):
        let cell: SeriesListCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setup(with: listModel)
        return cell
      }
    }
  }

  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard hasTitle(for: section) else { return nil }
    let label = UILabel()
    label.text = model?.sections[section].title
    label.backgroundColor = .systemBackground
    return label
  }

  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return hasTitle(for: section) ? Constants.Header.defaultHeight: Constants.Header.emptyHeight
  }
  
  private func hasTitle(for section: Int) -> Bool {
    guard let sections = model?.sections else { return false }
    return section < sections.count && sections[section].title != nil
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let seriesId = viewModel.getSeriesId(for: indexPath.row, section: indexPath.section) else { return }
    let seriesDetailVM = SeriesDetailViewModel(id: seriesId)
    navigationController?.pushViewController(SeriesDetailViewController(viewModel: seriesDetailVM), animated: true)
  }
}
