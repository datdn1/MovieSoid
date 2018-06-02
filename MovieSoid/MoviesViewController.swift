//
//  ViewController.swift
//  MovieSoid
//
//  Created by datdn1 on 6/16/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import UIKit
import Moya_ObjectMapper
import AsyncDisplayKit

class MoviesViewController: ASViewController<ASCollectionNode> {

    @IBOutlet weak var collectionView: UICollectionView!

    let collectionNode: ASCollectionNode!

    var moviesInfo: MoviesInfo!

    var page: Int = 1
    var isLoading: Bool = false

    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 8
        self.collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        super.init(node: self.collectionNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        discoverMovies()
    }

    private func setupViews() {
        self.collectionNode.delegate = self
        self.collectionNode.dataSource = self
        self.collectionNode.registerSupplementaryNode(ofKind: UICollectionElementKindSectionHeader)
        self.collectionNode.view.leadingScreensForBatching = 1.0
        self.collectionNode.backgroundColor = Constants.Color.primaryColor
        self.title = "DISCOVER"
    }

    fileprivate func discoverMovies() {
        MoviesProvider.request(.discover("popularity.desc", page)) { result in
            switch result {
            case let .success(response):
                do {
                    let moviesInfo: MoviesInfo? = try response.mapObject(MoviesInfo.self)
                    if let moviesInfo = moviesInfo {
                        if self.page == 1 {
                            self.moviesInfo = moviesInfo
                            self.collectionNode.reloadData()
                        }
                        else {
                            let offset = self.moviesInfo.movies.count
                            self.moviesInfo.movies = self.moviesInfo.movies + moviesInfo.movies
                            self.collectionView.performBatchUpdates({
                                for i in offset..<self.moviesInfo.movies.count {
                                    self.collectionView.insertItems(at: [IndexPath(item: i, section: 0)])
                                }
                            }, completion: nil)
                        }
                    }
                }
                catch {
                    print("error")
                }
            case let .failure(error):
                let error = error as CustomStringConvertible
                print(error.description)
            }

            self.isLoading = false
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MoviesViewController: ASCollectionDataSource {
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        guard let moviesInfo = self.moviesInfo, let movies = moviesInfo.movies else { return 0 }
        return movies.count
    }

    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }

    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let movie = self.moviesInfo.movies[indexPath.item]
        return {
//            return MovieTableCell(model: movie)
            return MovieGridCell(model: movie)
        }
    }

    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            guard let moviesInfo = self.moviesInfo else {
                return ASCellNode()
            }
            return MovieHeader(model: moviesInfo)
        }

    }

//    func collectionNode(_ collectionNode: ASCollectionNode, nodeForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> ASCellNode {
//        return MovieHeader(model: self.moviesInfo)
//    }
}

extension MoviesViewController: ASCollectionViewLayoutInspecting {
    func collectionView(_ collectionView: ASCollectionView, constrainedSizeForNodeAt indexPath: IndexPath) -> ASSizeRange {
        let min = CGSize(width: UIScreen.main.bounds.size.width, height: 150)
        let max = CGSize(width: UIScreen.main.bounds.size.width, height: CGFloat(Float.greatestFiniteMagnitude))
        return ASSizeRange(min: min, max: max)
    }

    func scrollableDirections() -> ASScrollDirection {
        return [.up, .down]
    }

    func collectionView(_ collectionView: ASCollectionView, constrainedSizeForSupplementaryNodeOfKind kind: String, at indexPath: IndexPath) -> ASSizeRange {
        let min = CGSize(width: UIScreen.main.bounds.size.width, height: 50)
        let max = CGSize(width: UIScreen.main.bounds.size.width, height: 100)
        return ASSizeRange(min: min, max: max)
    }
}


extension MoviesViewController: ASCollectionDelegate {
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
//        let min = CGSize(width: UIScreen.main.bounds.size.width, height: 150)
//        let max = CGSize(width: UIScreen.main.bounds.size.width, height: CGFloat(Float.greatestFiniteMagnitude))
//        return ASSizeRange(min: min, max: max)


        let width = (UIScreen.main.bounds.width - (8.0 * 3)) / 2.0
        let height = width * 3.0 / 2
        let min = CGSize(width: width, height: height)
        let max = CGSize(width: UIScreen.main.bounds.size.width, height: CGFloat(Float.greatestFiniteMagnitude))
        return ASSizeRange(min: min, max: max)
    }

    func shouldBatchFetch(for collectionNode: ASCollectionNode) -> Bool {
        guard let moviesInfo = self.moviesInfo, let totalPage = moviesInfo.totalPages, page < totalPage else {
            return false
        }
        return true
    }

    // MARK: - Load next page on prefetch zone
    func collectionNode(_ collectionNode: ASCollectionNode, willBeginBatchFetchWith context: ASBatchContext) {
        if isLoading {
            return
        }

        page += 1
        isLoading = true
        MoviesAPI.discoverMovies(page: page) { movies, error in
            context.completeBatchFetching(true)
            self.isLoading = false
            guard let newMovies = movies else { return }
            guard self.moviesInfo != nil, self.moviesInfo.movies != nil else { return }

            let offset = self.moviesInfo.movies.count
            self.moviesInfo.movies = self.moviesInfo.movies + newMovies

            var insertIndexPaths: [IndexPath] = []
            for i in offset..<self.moviesInfo.movies.count {
                insertIndexPaths.append(IndexPath(item: i, section: 0))
            }
            DispatchQueue.main.async {
                self.collectionNode.insertItems(at: insertIndexPaths)
            }
        }
    }

    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        guard let moviesInfo = self.moviesInfo, let movies = moviesInfo.movies else { return }
        let movie = movies[indexPath.item]
        let detailController = DetailMovieController(movie: movie)
        self.navigationController?.pushViewController(detailController, animated: true)
    }
}

//extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return movies.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let movie = self.movies[indexPath.item]
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
//        cell.bindModel(movie: movie)
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if indexPath.item == movies.count - 1 && !isLoading {
//            page += 1
//            isLoading = true
//            self.discoverMovies()
//        }
//    }
//}

extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: 60)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 8, 8, 8)

    }
}

