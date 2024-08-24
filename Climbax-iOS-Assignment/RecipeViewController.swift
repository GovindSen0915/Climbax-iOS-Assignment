//
//  ViewController.swift
//  Climbax-iOS-Assignment
//
//  Created by Govind Sen on 24/08/24.
//

import UIKit

class RecipeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = RecipeViewModel()
    private var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.fetchRecipes()
        setupTableView()
        setupLoadingIndicator()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "productCell", bundle: nil), forCellReuseIdentifier: "productCell")
    }
    
    func setupLoadingIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        tableView.tableFooterView = activityIndicator
    }
}

extension RecipeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recipesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as? RecipeCell else {
            return UITableViewCell()
        }
        
        let recipe = viewModel.recipe(at: indexPath.row)
        cell.configure(with: recipe)
        cell.favoriteButton.setImage(viewModel.isFavorite(at: indexPath.row) ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)
        
        if let imageURL = URL(string: recipe.image) {
            let task = URLSession.shared.dataTask(with: imageURL) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.image1.image = image
                    }
                } else {
                    print("Failed to load image")
                }
            }
            task.resume()
        } else {
            print("Invalid image URL")
        }
        
        cell.toggleFavorite = { [weak self] in
            self?.viewModel.toggleFavorite(at: indexPath.row)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        if indexPath.row == viewModel.recipesCount - 1 {
            viewModel.fetchRecipes()
        }
        
        return cell
    }
    
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        guard let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as? productCell else {
    //            return UITableViewCell()
    //        }
    //        let product = viewModel.recipe(at: indexPath.row)
    //        cell.titleLabel.text = product.name
    //        cell.descriptionLabel.text = product.difficulty
    //
    //        if let imageURL = URL(string: product.image) {
    //            let task = URLSession.shared.dataTask(with: imageURL) { data, response, error in
    //                if let data = data, let image = UIImage(data: data) {
    //                    DispatchQueue.main.async {
    //                        cell.image1.image = image
    //                    }
    //                } else {
    //                    print("Failed to load image")
    //                }
    //            }
    //            task.resume()
    //        } else {
    //            print("Invalid image URL")
    //        }
    //
    //        if indexPath.row == viewModel.recipesCount - 1 {
    //            viewModel.fetchRecipes()
    //        }
    //
    //        return cell
    //    }
}

//extension ViewController: RecipeViewModelDelegate {
//    func didReceiveData() {
//        tableView.reloadData()
//    }
//
//    func didFailWithError(_ error: Error) {
//        print("Error: \(error.localizedDescription)")
//    }
//
//    func didStartLoading() {
//        activityIndicator.startAnimating()
//    }
//
//    func didFinishLoading() {
//        activityIndicator.stopAnimating()
//    }
//}


extension RecipeViewController: RecipeViewModelDelegate {
    
    
    
    func didReceiveData() {
        tableView.reloadData()
    }
    
    func didFailWithError(_ error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
    func didStartLoading() {
        activityIndicator.startAnimating()
    }
    
    func didFinishLoading() {
        activityIndicator.stopAnimating()
    }
    
}


