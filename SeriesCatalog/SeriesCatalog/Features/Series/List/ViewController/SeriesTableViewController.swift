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


class SeriesTableViewController: UITableViewController, UITableViewDataSourcePrefetching {

  private let viewModel: SeriesListViewModelProtocol
  var cancellables: Set<AnyCancellable> = []
  lazy var datasource: TableDataSource = makeDataSource()
  
  init(viewModel: SeriesListViewModelProtocol = SeriesListViewModel()) {
    self.viewModel = viewModel
    super.init(style: .plain)
  }
  
  required init?(coder: NSCoder) {
    self.viewModel = SeriesListViewModel()
    super.init(coder: coder)
  }
  
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
    registerCells()
    bind()
  }
  
  private func barButton() {
    let button = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
    navigationItem.rightBarButtonItem = button
  }
  
  private func registerCells() {
    tableView.separatorColor = .clear
    tableView.prefetchDataSource = self
    tableView.register(SeriesListCell.self)
  }
  
  @objc private func searchTapped() {
    navigationController?.pushViewController(SearchSeriesViewController(), animated: true)
  }
  
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
