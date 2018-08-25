//
//  CatFactViewController.swift
//  CatFactsAgain
//
//  Created by Soon Yin Jie on 25/8/18.
//  Copyright © 2018 Tinkertanker. All rights reserved.
//

import UIKit

class CatFactViewController: UIViewController {

    @IBOutlet weak var catFactLabel: UILabel!
    @IBOutlet weak var catImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func gimmeCatFact(_ sender: Any) {
        fetchOnlineCatFact { (catFact) in
            if let catFact = catFact {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.catFactLabel.text = catFact.text
                }
            }
        }
        
        fetchCatGif { (image) in
            if let image = image {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.catImageView.image = image
                }
            }
        }
        
    }
    
    func fetchOnlineCatFact(completion: @escaping (CatFact?) -> Void) {
        let url = URL(string: "https://cat-fact.herokuapp.com/facts/random")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            let jsonDecoder = JSONDecoder()
            
            if let data = data, let catFact = try? jsonDecoder.decode(CatFact.self, from: data) {
                completion(catFact)
            } else {
                completion(nil)
            }
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        task.resume()  // 🤷‍♂️
    }
    
    func fetchCatGif(completion: @escaping (UIImage?) -> Void) {
        let url = URL(string: "https://api.thecatapi.com/v1/images/search?format=src&mime_types=image/gif")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                        
            if let data = data, let image = UIImage.gif(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        task.resume()  // 🤷‍♂️

    }
    
}












