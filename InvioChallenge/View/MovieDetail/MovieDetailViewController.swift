//
//  MovieDetailViewController.swift
//  InvioChallenge
//
//  Created by EnsarKoseoglu on 16.02.2023.
//

import UIKit

protocol MovieDetailViewControllerDelegate: AnyObject {
  func willSetMovieFavoriteState(at indexPath: IndexPath?)
}

class MovieDetailViewController: BaseViewController {

  @IBOutlet weak private var detailContainerView: UIView!

  @IBOutlet weak private var moviePoster: UIImageView!
  @IBOutlet weak private var durationDetail: HeaderLabel!
  @IBOutlet weak private var yearDetail: HeaderLabel!
  @IBOutlet weak private var languageDetail: HeaderLabel!
  @IBOutlet weak private var ratingDetail: HeaderLabel!

  @IBOutlet weak private var plotDetail: DetailLabel!
  @IBOutlet weak private var directorDetail: DetailLabel!
  @IBOutlet weak private var writerDetail: DetailLabel!
  @IBOutlet weak private var actorsDetail: DetailLabel!
  @IBOutlet weak private var countryDetail: DetailLabel!
  @IBOutlet weak private var boxOfficeDetail: DetailLabel!

  weak var delegate: MovieDetailViewControllerDelegate?
  private var viewModel: MovieDetailViewModel!
  private var cellIndex: IndexPath?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if viewModel == nil {
      assertionFailure("Lütfen viewModel'ı inject ederek devam et!")
    }

    setupView()
    setupClosure()
    viewModel.start()
  }

  func inject(viewModel: MovieDetailViewModel, delegate: MovieDetailViewControllerDelegate, cellIndex: IndexPath) {
    self.viewModel = viewModel
    self.delegate = delegate
    self.cellIndex = cellIndex
  }

  private func setupView() {
    detailContainerView.isHidden = true
    showLoading()
  }

  private func updateUI() {
    guard let movie = viewModel.getMovieDetail() else { return }
    durationDetail.text = movie.duration
    yearDetail.text = movie.year
    languageDetail.text = movie.language
    ratingDetail.text = "\(movie.rating ?? "0.0")/10"
    plotDetail.text = movie.plot
    directorDetail.text = movie.director
    writerDetail.text = movie.writer
    actorsDetail.text = movie.actors
    countryDetail.text = movie.country
    boxOfficeDetail.text = movie.boxOffice

    moviePoster.cornerRadius = 10.0
    moviePoster.setImage(from: movie.poster, placeholder: Asset.placeholder.image)
    detailContainerView.isHidden = false

    var rightIcon = Asset.unlike.name
    if viewModel.isFavorite {
      rightIcon = Asset.like.name
    }
    setupNavBar(title: movie.title, leftIcon: Asset.back.name, rightIcon: rightIcon, leftItemAction: #selector(goBack), rightItemAction: #selector(setFavoriteState))
  }

  @objc private func setFavoriteState() {
    if !viewModel.isFavorite {
      viewModel.addToFavorites()
    } else {
      viewModel.removeFromFavorites()
    }
    delegate?.willSetMovieFavoriteState(at: cellIndex)
    updateNavBar()
  }

  private func updateNavBar() {
    if !viewModel.isFavorite {
      self.navigationItem.rightBarButtonItem?.image = Asset.unlike.image.withRenderingMode(.alwaysOriginal)
    } else {
      self.navigationItem.rightBarButtonItem?.image = Asset.like.image.withRenderingMode(.alwaysOriginal)
    }
  }
}

extension MovieDetailViewController {
  private func setupClosure() {
    viewModel.stateClosure = { [weak self] result in
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

  private func handleClosureData(data: MovieDetailViewModelImpl.ViewInteractivity) {
    switch data {
    case .didFetchMovieDetail:
      DispatchQueue.main.async {
        self.updateUI()
        self.hideLoading()
      }
    }
  }

  private func handleResponseError(_ error: ResponseError) {
    DispatchQueue.main.async {
      self.showError(with: error.error) { willRetry in
        if willRetry {
          self.viewModel.start()
        }
      }
    }
  }
}
