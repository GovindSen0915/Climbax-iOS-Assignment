//
//  RecipeCell.swift
//  Climbax-iOS-Assignment
//
//  Created by Govind Sen on 24/08/24.
//


import UIKit

class RecipeCell: UITableViewCell {
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var rating: UILabel!
    
    var toggleFavorite: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        recipeImageView.layer.cornerRadius = 10
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
    @objc private func favoriteButtonTapped() {
        toggleFavorite?()
    }
    
    func configure(with recipe: Recipe) {
        titleLabel.text = recipe.name
        descriptionLabel.text = recipe.cuisine
        rating.text = String(recipe.rating)
    }
    
}

