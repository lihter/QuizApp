//
//  LeaderboardManager.swift
//  QuizApp
//
//  Created by Mac Use on 06.05.2021..
//

import UIKit

struct LeaderboardManager {
    
    func fetchLeaderboard(completion: @escaping(LeaderboardModel) -> Void) {
        
        guard let url = URL(string: "https://jsonkeeper.com/b/OZLE") else { return }//DODATI URL
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error fetching leaderboard: \(error.localizedDescription)")
            }
            
            guard let jsonData = data else { return }
            
            let decoder = JSONDecoder()
            
            do{
                let decodedData = try decoder.decode(LeaderboardModel.self, from: jsonData)
                completion(decodedData)
            } catch {
                print("Error decoding data.")
            }
            
        }
        dataTask.resume()
    }
}


/*
 OVO JE .json FILE KOJI JE NA LINKU KOJI JE GORE KORISTEN
 
 {
   "users": [
     {
       "username": "Lala",
       "points": 856
     },
     {
       "username": "Joza",
       "points": 1207
     },
     {
       "username": "Bloom",
       "points": 18
     },
     {
       "username": "Po",
       "points": 55
     },
     {
       "username": "Tom",
       "points": 124
     },
     {
       "username": "Jerry",
       "points": 126
     },
     {
       "username": "Verstappen",
       "points": 652
     },
     {
       "username": "Norris",
       "points": 582
     },
     {
       "username": "Bottas",
       "points": 355
     },
     {
       "username": "Hobotnica",
       "points": 561
     },
     {
       "username": "Moruzgva",
       "points": 126
     },
     {
       "username": "Hamilton",
       "points": 640
     },
     {
       "username": "Stroll",
       "points": 381
     },
     {
       "username": "Ricciardo",
       "points": 484
     },
     {
       "username": "Kodric",
       "points": 602
     },
     {
       "username": "Moruzgva",
       "points": 126
     }
   ]
 }
 */
