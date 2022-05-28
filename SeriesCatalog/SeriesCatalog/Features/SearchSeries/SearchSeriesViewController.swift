//
//  SearchSeriesViewController.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 28/05/22.
//

import UIKit
import Combine

class SearchSeriesViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  let viewModel: SearchSeriesViewModelProtocol
  var cancellables: Set<AnyCancellable> = []
  lazy var datasource: TableDataSource = makeDataSource()

  init(viewModel: SearchSeriesViewModelProtocol = SearchSeriesViewModel()) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  private func setup() {
    setupSearchController()
    registerCells()
    bind()
  }
  
  private func registerCells() {
    tableView.separatorColor = .clear
    tableView.register(SeriesListCell.self)
  }
  
  func bind() {
    viewModel.statePublisher
      .receive(on: RunLoop.main)
      .sink { [weak self] state in
        guard let self = self else { return }
        self.handleState(state: state)
      }.store(in: &cancellables)
  }
  
  private func handleState(state: SeriesSearchState) {
    
    switch state {
    case .loading:
      activityIndicator.startAnimating()
    case .loaded(let models):
      activityIndicator.stopAnimating()
      var snapshot = Snapshot()
      snapshot.appendSections([0])
      snapshot.appendItems(models, toSection: 0)
      datasource.apply(snapshot)
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
  
  func makeDataSource() -> TableDataSource{
    return TableDataSource(tableView: tableView) { tableView, indexPath, model in
      let cell: SeriesListCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
      cell.setup(with: model)
      return cell
    }
  }
}

extension SearchSeriesViewController: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let text = searchBar.text else { return }
    viewModel.search(text: text)
  }
}
