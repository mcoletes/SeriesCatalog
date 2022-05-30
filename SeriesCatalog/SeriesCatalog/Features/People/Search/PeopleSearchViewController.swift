//
//  PeopleSearchViewController.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 29/05/22.
//

import UIKit
import Combine

typealias PeopleSearchCollectionDataSource = UICollectionViewDiffableDataSource<Int, PeopleSearchModel>
typealias PeopleSnapshot = NSDiffableDataSourceSnapshot<Int, PeopleSearchModel>

class PeopleSearchViewController: UICollectionViewController, LoadableProtocol, ErrorProtocol {
  
  // MARK: - Properties

  private let viewModel: PeopleSearchViewModelProtocol
  private var cancellables: Set<AnyCancellable> = []
  private lazy var datasource: PeopleSearchCollectionDataSource = makeDataSource()


  init(viewModel: PeopleSearchViewModelProtocol = PeopleSearchViewModel()) {
    self.viewModel = viewModel
    super.init(collectionViewLayout: SearchCollectionViewLayout().getLayout())
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  private func setup() {
    setupUI()
    registerCells()
    bind()
  }
  
  private func setupUI() {
    navigationItem.backButtonDisplayMode = .minimal
    setupSearchController()
  }
  
  private func registerCells() {
    collectionView.register(PeopleListCell.self)
  }
  
  private func setupSearchController() {
    let search = UISearchController(searchResultsController: nil)
    search.searchBar.delegate = self
    search.obscuresBackgroundDuringPresentation = false
    search.searchBar.placeholder = "Type a person name to search"
    navigationItem.searchController = search
  }
  
  private func bind() {
    viewModel.statePublisher
      .receive(on: RunLoop.main)
      .sink { [weak self] state in
        guard let self = self else { return }
        self.handleState(state: state)
      }.store(in: &cancellables)
  }
  
  private func handleState(state: RegularStates<[PeopleSearchModel]>) {
    
    state == .loading ? showLoading(): hideLoading()
    switch state {
    case .success(let models):
      var snapshot = PeopleSnapshot()
      snapshot.appendSections([0])
      snapshot.appendItems(models, toSection: 0)
      datasource.apply(snapshot)
    case .error(let error, let action):
      showError(serviceError: error, action: action)
    default:
      break
    }
  }
  
  
  // MARK: UICollectionViewDataSource
  
  func makeDataSource() -> PeopleSearchCollectionDataSource {
    return PeopleSearchCollectionDataSource(collectionView: collectionView) { collectionView, indexPath, model in
      let cell: PeopleListCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
      cell.setup(personURL: model.imageURL, name: model.name)
      return cell
    }
  }
  
  // MARK: UICollectionViewDelegate
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let person = viewModel.getPerson(for: indexPath.row) else { return }
    let personDetailVM = PersonDetailViewModel(person: person)
    navigationController?.pushViewController(PersonDetailViewController(viewModel: personDetailVM), animated: true)
  }
}

// MARK: - UISearchBarDelegate

extension PeopleSearchViewController: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let text = searchBar.text else { return }
    viewModel.search(text: text)
  }
}
