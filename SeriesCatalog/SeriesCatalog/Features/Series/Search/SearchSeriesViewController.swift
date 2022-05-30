//
//  SearchSeriesViewController.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 28/05/22.
//

import UIKit
import Combine

class SearchSeriesViewController: UITableViewController, LoadableProtocol, ErrorProtocol {
  
  // MARK: - Properties

  private let viewModel: SearchSeriesViewModelProtocol
  private var cancellables: Set<AnyCancellable> = []
  private lazy var datasource: SeriesListTableDataSource = makeDataSource()

  init(viewModel: SearchSeriesViewModelProtocol = SearchSeriesViewModel()) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Search"
    setup()
  }
  
  // MARK: - Methods
  
  private func setup() {
    setupSearchController()
    registerCells()
    bind()
  }
  
  private func registerCells() {
    tableView.separatorColor = .clear
    tableView.delegate = self
    tableView.register(SeriesListCell.self)
  }
  
  private func bind() {
    viewModel.statePublisher
      .receive(on: RunLoop.main)
      .sink { [weak self] state in
        guard let self = self else { return }
        self.handleState(state: state)
      }.store(in: &cancellables)
  }
  
  private func handleState(state: RegularStates<[SeriesListCellModel]>) {
    
    state == .loading ? showLoading(): hideLoading()
    switch state {
    case .success(let models):
      var snapshot = SeriesListSnapshot()
      snapshot.appendSections([0])
      snapshot.appendItems(models, toSection: 0)
      datasource.apply(snapshot)
    case .error(let error, let action):
      showError(serviceError: error, action: action)
    default:
      break
    }
  }
  
  private func setupSearchController() {
    let search = UISearchController(searchResultsController: nil)
    search.searchBar.delegate = self
    search.obscuresBackgroundDuringPresentation = false
    search.searchBar.placeholder = "Type a series name to search"
    navigationItem.searchController = search
  }
  
  // MARK: - Table view data source

  func makeDataSource() -> SeriesListTableDataSource{
    return SeriesListTableDataSource(tableView: tableView) { tableView, indexPath, model in
      let cell: SeriesListCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
      cell.setup(with: model)
      return cell
    }
  }
  
  // MARK: - Table view delegate

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let id = viewModel.getId(for: indexPath.row) else { return }
    let detailVM = SeriesDetailViewModel(id: id)
    navigationController?.pushViewController(SeriesDetailViewController(viewModel: detailVM), animated: true)
  }
}

// MARK: - UISearchBarDelegate

extension SearchSeriesViewController: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let text = searchBar.text else { return }
    viewModel.search(text: text)
  }
}
