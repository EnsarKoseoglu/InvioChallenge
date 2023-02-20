//
//  MovieListTableViewCell.swift
//  InvioChallenge
//
//  Created by invio on 12.11.2022.
//

import UIKit

protocol MovieListCellDelegate: AnyObject {
  func willSetFavoriteState(_ cell: MovieListTableViewCell)
}

class MovieListTableViewCell: UITableViewCell {

    weak var delegate: MovieListCellDelegate?

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieYearLabel: UILabel!
    @IBOutlet weak var movieTypeLabel: UILabel!
    @IBOutlet weak var movieImdbLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.cornerRadius = 12
    }
    
    func setupCell(movie: Movie) {
        movieNameLabel.text = movie.title
        movieYearLabel.text = movie.year
        movieTypeLabel.text = movie.type
        movieImdbLabel.text = "IMDB ID : \(movie.id)"
        posterImageView.setImage(from: movie.poster, placeholder: Asset.placeholder.image)
        if UserDefaults.standard.bool(forKey: movie.id) {
          likeButton.setImage(Asset.like.image, for: .normal)
        } else {
          likeButton.setImage(Asset.unlike.image, for: .normal)
        }
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
      self.delegate?.willSetFavoriteState(self)
    }
}
