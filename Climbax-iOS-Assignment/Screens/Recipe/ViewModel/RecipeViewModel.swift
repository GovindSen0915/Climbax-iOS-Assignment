//
//  RecipeViewModel.swift
//  Climbax-iOS-Assignment
//
//  Created by Govind Sen on 24/08/24.
//


import Foundation


protocol RecipeViewModelDelegate: AnyObject {
    func didReceiveData()
    func didFailWithError(_ error: Error)
    func didStartLoading()
    func didFinishLoading()
}

class RecipeViewModel {
    
    weak var delegate: RecipeViewModelDelegate?
    
    
    private var recipes: [Recipe] = []
    private var favoriteRecipes: Set<Int> = [] // Track favorite recipe indices
    private var currentPage = 1
    private var isFetchingData = false
    
    var recipesCount: Int {
        return recipes.count
    }
    
    init() {
        loadFavorites()
    }
    
    func recipe(at index: Int) -> Recipe {
        return recipes[index]
    }
    
    func isFavorite(at index: Int) -> Bool {
        return favoriteRecipes.contains(index)
    }
    
    func toggleFavorite(at index: Int) {
        if favoriteRecipes.contains(index) {
            favoriteRecipes.remove(index)
        } else {
            favoriteRecipes.insert(index)
        }
        saveFavorites()
    }
    
    private func saveFavorites() {
        UserDefaults.standard.set(Array(favoriteRecipes), forKey: "FavoriteRecipes")
    }
    
    func favoriteRecipesList() -> [Recipe] {
        return favoriteRecipes.map { recipes[$0] }
    }
    
    private func loadFavorites() {
        if let savedFavorites = UserDefaults.standard.array(forKey: "FavoriteRecipes") as? [Int] {
            favoriteRecipes = Set(savedFavorites)
        }
    }
    
    func fetchRecipes() {
        guard !isFetchingData else { return }
        isFetchingData = true
        
        DispatchQueue.main.async {
            self.delegate?.didStartLoading()
        }
        
        let limit = 20
        let urlString = "https://dummyjson.com/recipes?page=\(currentPage)&limit=\(limit)"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            self.isFetchingData = false
            
            DispatchQueue.main.async {
                self.delegate?.didFinishLoading()
            }
            
            if let error = error {
                self.delegate?.didFailWithError(error)
                return
            }
            
            guard let data = data else {
                self.delegate?.didFailWithError(NSError(domain: "NoData", code: 0, userInfo: nil))
                return
            }
            
            do {
                let responseObject = try JSONDecoder().decode(RecipeResponse.self, from: data)
                self.recipes.append(contentsOf: responseObject.recipes)
                self.currentPage += 1
                DispatchQueue.main.async {
                    self.delegate?.didReceiveData()
                }
            } catch {
                self.delegate?.didFailWithError(error)
            }
        }
        task.resume()
    }
}

