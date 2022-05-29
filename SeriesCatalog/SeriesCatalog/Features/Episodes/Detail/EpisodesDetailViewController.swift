//
//  EpisodesDetailViewController.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 28/05/22.
//

import UIKit
import Combine

typealias EpisodesDetailDataSource = UITableViewDiffableDataSource<Int, EpisodesDetailCellModel>


class EpisodesDetailViewController: UITableViewController {
  
  let viewModel: EpisodesDetailViewModelProtocol
  
  init(viewModel: EpisodesDetailViewModelProtocol) {
    self.viewModel = viewModel
    super.init(style: .plain)
  }
  
  var cancellables: Set<AnyCancellable> = []
  lazy var datasource: EpisodesDetailDataSource = makeDataSource()
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Episode"
    setup()
    viewModel.load()
  }
  
  private func setup() {
    registerCells()
    bind()
  }
  
  private func registerCells() {
    tableView.register(EpisodeDetailLogoTitleCell.self)
    tableView.register(DetailInfoCell.self)
  }
  
  func bind() {
    viewModel.statePublisher
      .receive(on: RunLoop.main)
      .sink { [weak self] state in
        guard let self = self else { return }
        self.handleState(state: state)
      }.store(in: &cancellables)
  }
  
  private func handleState(state: EpisodesDetailState) {
    switch state {
    case .loaded(let models):
      var snapshot = datasource.snapshot()
      snapshot.appendSections([0])
      snapshot.appendItems(models, toSection: 0)
      datasource.apply(snapshot)
    default:
      break
    }
  }
  
  // MARK: - Table view data source
  
  func makeDataSource() -> EpisodesDetailDataSource {
    return EpisodesDetailDataSource(tableView: tableView) { tableView, indexPath, model in
      switch model {
      case .logoAndTitle(let imageUrl, let title):
        let cell: EpisodeDetailLogoTitleCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setup(logoUrl: imageUrl, title: title)
        return cell
      case .detalInfo(let title, let description):
        let cell: DetailInfoCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setup(title: title, description: description)
        return cell
      }
    }
  }
}
