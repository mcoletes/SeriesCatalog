//
//  FavoritesViewController.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 30/05/22.
//

import UIKit
import Combine

class FavoritesViewController: UITableViewController {

  // MARK: - Properties

  private let viewModel: FavoritesViewModelProtocol
  private var cancellables: Set<AnyCancellable> = []
  private lazy var datasource: SeriesListTableDataSource = makeDataSource()
  
  private lazy var segmentedControl: UISegmentedControl = {
    let segmentedControl = UISegmentedControl(items: ["Insertion", "Ascending", "Descending"])
    segmentedControl.selectedSegmentIndex = 0
    segmentedControl.backgroundColor = .systemBackground
    segmentedControl.sizeToFit()
    segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    return segmentedControl
  }()
  
  // MARK: - Initializers

  init(viewModel: FavoritesViewModelProtocol = FavoritesViewModel()) {
    self.viewModel = viewModel
    super.init(style: .plain)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.load()
  }
  
  // MARK: - Methods
  
  private func setup() {
    setupUI()
    setupTableView()
    bind()
  }
  
  @objc func segmentedControlValueChanged() {
    viewModel.sort(index: segmentedControl.selectedSegmentIndex)
  }
  
  private func setupUI() {
    navigationItem.backButtonDisplayMode = .minimal
    navigationItem.titleView = segmentedControl
  }
  
  private func setupTableView() {
    tableView.separatorColor = .clear
    registerCells()
  }
  
  private func registerCells() {
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
  
  private func handleState(state: FavoriteSeriesStates) {
    switch state {
    case .success(let models):
      var snapshot = SeriesListSnapshot()
      snapshot.appendSections([0])
      snapshot.appendItems(models, toSection: 0)
      datasource.apply(snapshot, animatingDifferences: false)
    default:
      break
    }
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
