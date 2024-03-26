//
//  ViewController.swift
//  ios101-project5-tumbler
//

import UIKit
import Nuke

class ViewController: UIViewController, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell

                // Get the movie associated table view row
            let post = posts[indexPath.row]

            // Configure the cell (i.e., update UI elements like labels, image views, etc.)

            // Unwrap the optional poster path
            if let photo = post.photos.first {
                let url = photo.originalSize.url
                if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500/\(url)") {
                    Nuke.loadImage(with: imageUrl, into: cell.poster) { result in
                        switch result {
                        case .success:
                            // Image loaded successfully
                            break // No action needed
                        case .failure(let error):
                            // Handle image loading failure
                            print("Failed to load image: \(error)")
                        }
                    }
                }
            }

            // Set the text on the labels
            cell.caption.text = post.caption
            cell.summary.text = post.summary

            // Return the cell for use in the respective table view row
            return cell
    }
    

    @IBOutlet weak var tableView: UITableView!
    
    //Array to fetch blog posts
    private var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        fetchPosts()
    }



    func fetchPosts() {
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork/posts/photo?api_key=1zT8CiXGXFcQDyMFG7RtcfGLwTdDjFUJnZzKJaWTmgyK4lKGYk")!
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
                print("❌ Response error: \(String(describing: response))")
                return
            }

            guard let data = data else {
                print("❌ Data is NIL")
                return
            }

            do {
                let blog = try JSONDecoder().decode(Blog.self, from: data)

                DispatchQueue.main.async { [weak self] in

                    let posts = blog.response.posts


                    print("✅ We got \(posts.count) posts!")
                    for post in posts {
                        print("🍏 Summary: \(post.summary)")
                    }
                    
                    self?.posts = posts
                    self?.tableView.reloadData()
                }

            } catch {
                print("❌ Error decoding JSON: \(error.localizedDescription)")
            }
        }
        session.resume()
    }
}
