//
//  MealsAPIClient.swift
//  MealDB-MVC
//
//  Created by Phil Wright on 12/7/21.
//  Copyright © 2021 Touchopia, LLC. All rights reserved.

import Foundation

typealias MealResultType = Result<Meal, Error>
typealias MealsResultType = Result<[Meal], Error>

final class MealsAPIClient {

    func getMeals(category: String, completion: @escaping (MealsResultType) -> Void) {
        guard let categoryURL = Endpoints.categoriesURL(with: category) else {
            let categoryError = NSError(domain: "Category :\(category) not found", code: 0)
            completion(.failure(categoryError))
            return
        }
        
        let task = URLSession.shared.dataTask(with: categoryURL) { data, _, error in
            
            guard let data = data, error == nil else {
                guard let error = error else { return }
                completion(.failure(error))
                return
            }
            
            do {
                let meals = try JSONDecoder().decode(MealsContainer.self, from: data)
                let mealsArray = meals.meals
                completion(.success(mealsArray))
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getMeal(idString: String, completion: @escaping (MealResultType) -> Void) {
        
        guard idString.isEmpty == false else {
            // TODO: Do Error Handling Here
            return
        }
        
        guard let url = Endpoints.mealURL(with: idString) else {
            // TODO: Do Error Handling Here
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let data=data, error == nil else {
                guard let error = error else { return }
                completion(.failure(error))
                return
            }
            
            do {
                let meals = try JSONDecoder().decode(MealsContainer.self, from: data)
                if let meal = meals.meals.first {
                    completion(.success(meal))
                }
            } catch let error {
                completion(.failure(error))
            }
        }.resume()
    }
}
