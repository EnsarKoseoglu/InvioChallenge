//
//  MovieListViewController.swift
//  InvioChallenge
//
//  Created by invio on 12.11.2022.
//

import UIKit

class MovieListViewController: BaseViewController {

  @IBOutlet weak var topContentView: UIView!
  @IBOutlet weak var searchContainerView: UIView!
  @IBOutlet weak var searchField: UITextField!
  @IBOutlet weak var searchButton: UIButton!
  @IBOutlet weak var tableView: UITableView!

  private var viewModel: MovieListViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()
    if viewModel == nil {
      assertionFailure("Lütfen viewModel'ı inject ederek devam et!")
    }

    setupView()
    setupTableView()
    addObservationListener()
    viewModel.start()
  }

  func inject(viewModel: MovieListViewModel) {
    self.viewModel = viewModel
  }

  private func setupView() {
    topContentView.roundBottomCorners(radius: 20)
    searchContainerView.cornerRadius = 10
    searchField.font = .avenir(.Book, size: 16)
    searchField.textColor = .softBlack
  }

  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(cellType: MovieListTableViewCell.self)
    tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 30, right: 0)
    tableView.separatorStyle = .none
  }

  @IBAction func searchButtonTapped(_ sender: Any) {
    performSearch()
  }

  private func performSearch() {
    guard let searchText = searchField.text, !searchText.isEmpty else { return }

    viewModel.resetSearching()
    viewModel.willSetSearchTitle(title: searchText)
    viewModel.searchMovies()
    tableView.showLoading()
  }

  private func showMovieDetail(_ indexPath: IndexPath) {
    guard let movie = viewModel.getMovieForCell(at: indexPath) else { return }

    let movieDetailVC = MovieDetailViewController(nibName: MovieDetailViewController.className, bundle: nil)
    let viewModel = MovieDetailViewModelImpl(apiService: MovieService(), movieId: movie.id)
    movieDetailVC.inject(viewModel: viewModel, delegate: self, cellIndex: indexPath)
    let nav = UINavigationController(rootViewController: movieDetailVC)
    self.present(nav, animated: true)
  }
}

// MARK: - TableView Delegate & DataSource
extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.getNumberOfRowsInSection()
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let movie = viewModel.getMovieForCell(at: indexPath) else { return UITableViewCell() }
    let cell = tableView.dequeueReusableCell(withIdentifier: MovieListTableViewCell.className, for: indexPath) as! MovieListTableViewCell
    cell.setupCell(movie: movie)
    cell.delegate = self
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    showMovieDetail(indexPath)
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == viewModel.getNumberOfRowsInSection() - 1 && viewModel.isFetchEnabled {
      tableView.showLoading()
      viewModel.isFetchEnabled = false
      viewModel.willFetchNextPage()
    }
  }
}

extension MovieListViewController: MovieDetailViewControllerDelegate {
  func willSetMovieFavoriteState(at indexPath: IndexPath?) {
    guard let index = indexPath,
          let movie = viewModel.getMovieForCell(at: index),
          let cell = self.tableView.cellForRow(at: index) as? MovieListTableViewCell else { return }

    if UserDefaults.standard.bool(forKey: movie.id) {
      cell.likeButton.setImage(Asset.like.image, for: .normal)
    } else {
      cell.likeButton.setImage(Asset.unlike.image, for: .normal)
    }
  }
}

extension MovieListViewController: MovieListCellDelegate {
  func willSetFavoriteState(_ cell: MovieListTableViewCell) {
    guard let index = self.tableView.indexPath(for: cell),
          let movie = viewModel.getMovieForCell(at: index) else { return }

    if UserDefaults.standard.bool(forKey: movie.id) {
      UserDefaults.standard.removeObject(forKey: movie.id)
      cell.likeButton.setImage(Asset.unlike.image, for: .normal)
    } else {
      UserDefaults.standard.set(true, forKey: movie.id)
      cell.likeButton.setImage(Asset.like.image, for: .normal)
    }
  }
}

extension MovieListViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField.isFirstResponder {
      performSearch()
      return true
    }
    return false
  }
}

// MARK: - ViewModel Listener
extension MovieListViewController {
  func addObservationListener() {
    self.viewModel.stateClosure = { [weak self] result in
      switch result {
      case .success(let data):
        self?.handleClosureData(data: data)
      case .failure(let error):
        if let res = error as? ResponseError {
          self?.handleResponseError(res)
        }
      }
    }
  }

  private func handleClosureData(data: MovieListViewModelImpl.ViewInteractivity) {
    switch data {
    case .updateMovieList:
      DispatchQueue.main.async {
        self.tableView.hideLoading()
        self.tableView.reloadData()
        self.view.endEditing(true)
        self.viewModel.isFetchEnabled = true
        if self.viewModel.isLastPage {
          self.viewModel.isFetchEnabled = false
          self.tableView.showRecordSummary(with: "\(self.viewModel.getNumberOfRowsInSection()) Movie")
        }
      }
    case .willBeginNewSearch:
      self.tableView.reloadData()
      self.view.endEditing(true)
    }
  }

  private func handleResponseError(_ error: ResponseError) {
    DispatchQueue.main.async {
      self.showError(with: error.error) { willRetry in
        if willRetry {
          self.performSearch()
        }
      }
    }
  }
}
