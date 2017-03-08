//
//  CategoryViewController.swift
//  PokedexLab
//
//  Created by SAMEER SURESH on 2/25/17.
//  Copyright © 2017 iOS Decal. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var pokemonArray: [Pokemon]?
    var cachedImages: [Int:UIImage] = [:]
    var selectedIndexPath: IndexPath?
    
    @IBOutlet weak var pokemonTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonTableView.delegate = self
        pokemonTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (pokemonArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "categoryToInfo", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell2 = pokemonTableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! cellelements
        let pokemon: Pokemon! = pokemonArray![indexPath.row]
        if let image = cachedImages[indexPath.row] {
            cell2.pokePic.image = image // may need to change this!
        } else {
            let url = URL(string: pokemon.imageUrl)!
            let session = URLSession(configuration: .default)
            let downloadPicTask = session.dataTask(with: url) { (data, response, error) in
                if let e = error {
                    print("Error downloading picture: \(e)")
                } else {
                    if let _ = response as? HTTPURLResponse {
                        if let imageData = data {
                            let image = UIImage(data: imageData)
                            self.cachedImages[indexPath.row] = image
                            cell2.pokePic.image = UIImage(data: imageData) // may need to change this!
                            
                        } else {
                            print("Couldn't get image: Image is nil")
                        }
                    } else {
                        print("Couldn't get response code")
                    }
                }
            }
            downloadPicTask.resume()
        }
        cell2.name.text = pokemon?.name
        cell2.number.text = "#\(String(pokemon.number))"
        cell2.stats.text = "\(pokemon.attack!)/\(pokemon.defense!)/\(pokemon.health!)"
        return cell2
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "categoryToInfo" {
                if let dest = segue.destination as? PokemonInfoViewController {
                    dest.pokemon = pokemonArray?[(selectedIndexPath?.row)!]
                    dest.image = cachedImages[(selectedIndexPath?.row)!]
                }
            }
        }
    }


}
