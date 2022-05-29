//
//  SeriesTableViewController.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 27/05/22.
//

import UIKit
import Combine

typealias TableDataSource = UITableViewDiffableDataSource<Int, SeriesListCellModel>
typealias Snapshot = NSDiffableDataSourceSnapshot<Int, SeriesListCellModel>

class SeriesTableViewController: UITableViewController, UITableViewDataSourcePrefetching, ErrorProtocol {

  // MARK: - Properties

  private let viewModel: SeriesListViewModelProtocol
  private var cancellables: Set<AnyCancellable> = []
  private lazy var datasource: TableDataSource = makeDataSource()
  
  // MARK: - Initializers

  init(viewModel: SeriesListViewModelProtocol = SeriesListViewModel()) {
    self.viewModel = viewModel
    super.init(style: .plain)
  }
  
  required init?(coder: NSCoder) {
    self.viewModel = SeriesListViewModel()
    super.init(coder: coder)
  }
  
  // MARK: - View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Series List"
    navigationItem.backButtonDisplayMode = .minimal
    setup()
    viewModel.load()
  }
  
  // MARK: - Setup
  
  private func setup() {
    barButton()
    setupTableView()
    bind()
  }
  
  private func barButton() {
    let button = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
    navigationItem.rightBarButtonItem = button
  }
  
  private func setupTableView() {
    tableView.prefetchDataSource = self
    tableView.separatorColor = .clear
    registerCells()
    setupTableFooterView()
  }
  
  private func registerCells() {
    tableView.register(SeriesListCell.self)
  }
  
  private func setupTableFooterView() {
    let activityIndicator = UIActivityIndicatorView(style: .large)
    activityIndicator.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50)
    activityIndicator.startAnimating()
    tableView.tableFooterView = activityIndicator
  }
  
  @objc private func searchTapped() {
    navigationController?.pushViewController(SearchSeriesViewController(), animated: true)
  }
  
  // MARK: - Bind

  func bind() {
    viewModel.statePublisher
      .receive(on: RunLoop.main)
      .sink { [weak self] state in
        guard let self = self else { return }
        self.handleState(state: state)
      }.store(in: &cancellables)
  }
  
  private func handleState(state: SeriesListState) {
    
    switch state {
    case .loaded(let models):
      var snapshot = datasource.snapshot()
      if snapshot.numberOfSections == 0 {
        snapshot.appendSections([0])
      }
      snapshot.appendItems(models, toSection: 0)
      datasource.apply(snapshot)
    case .error(let error, let action):
      showError(serviceError: error, action: action)
    default:
      break
    }
  }
  
  // MARK: - Table view data source
  
  func makeDataSource() -> TableDataSource{
    return TableDataSource(tableView: tableView) { tableView, indexPath, model in
      let cell: SeriesListCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
      cell.setup(with: model)
      return cell
    }
  }
  
  // MARK: - Table view prefetch
  
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    guard let maxRow = indexPaths.max()?.row else { return }
    viewModel.prefetching(row: maxRow)
  }
  
  // MARK: - Table view delegate
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let id = viewModel.getId(for: indexPath.row) else { return }
    let detailVM = SeriesDetailViewModel(id: id)
    navigationController?.pushViewController(SeriesDetailViewController(viewModel: detailVM), animated: true)
  }
}
