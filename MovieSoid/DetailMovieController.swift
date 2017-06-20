//
//  DetailMovieController.swift
//  MovieSoid
//
//  Created by datdn1 on 6/18/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import IGListKit

class DetailMovieController: ASViewController<ASCollectionNode> {

    let collectionNode: ASCollectionNode!
    let backgroundImageNode: ASNetworkImageNode!
    let movie: Movies

    var detailInfo: [DetailInfoSortProtocol] = []

    lazy var adapter: IGListAdapter = {
        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()

    init(movie: Movies) {
        self.movie = movie
        let flowLayout = UICollectionViewFlowLayout()
        self.collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        self.backgroundImageNode = ASNetworkImageNode()
        self.backgroundImageNode.contentMode = .scaleAspectFill
        self.backgroundImageNode.url = URL(string: Constants.URL.ImageBaseURL + movie.posterPath)
        super.init(node: self.collectionNode)
        self.adapter.setASDKCollectionNode(self.collectionNode)
        self.adapter.dataSource = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.movie.title
        self.node.backgroundColor = Constants.Color.primaryColor
        customBackBarButton()

        // get movie detail
        fetchDetailInfo()
    }

    func customBackBarButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back"), style: .plain, target: self, action: #selector(back))
    }

    func back() {
        self.navigationController?.popViewController(animated: true)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        self.backgroundImageNode.frame = self.view.bounds
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        hiddenNavigationBar(hidden: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        hiddenNavigationBar(hidden: false)
    }

    private func hiddenNavigationBar(hidden: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(hidden ? UIImage() : nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = hidden ? UIImage() : nil
        self.navigationController?.view.backgroundColor = hidden ? .clear : Constants.Color.headerColor
    }

    private func fetchDetailInfo() {
        let group = DispatchGroup()
        group.enter()
        MoviesAPI.detailMovie(movieId: self.movie.id) { movie, error in
            if let movie = movie {
                movie.identifier = Constants.DetailSectionIndex.DetailSection
                self.detailInfo.append(movie)
            }
            group.leave()
        }

        group.enter()
        MoviesAPI.creditsInfo(movieId: self.movie.id) { casts, error in
            if let casts = casts {
                casts.identifier = Constants.DetailSectionIndex.CreditsSection
                self.detailInfo.append(casts)
            }
            group.leave()
        }

        group.enter()
        MoviesAPI.videosInfo(movieId: self.movie.id) { (videos, error) in
            if let videos = videos {
                videos.detailIndex = Constants.DetailSectionIndex.VideosSection
                self.detailInfo.append(videos)
            }
            group.leave()
        }

        group.enter()
        MoviesAPI.imagesInfo(movieId: self.movie.id) { imagesInfo, error in
            if let imagesInfo = imagesInfo {
                imagesInfo.detailIndex = Constants.DetailSectionIndex.ImagesSection
                self.detailInfo.append(imagesInfo)
            }
            group.leave()
        }


        group.enter()
        MoviesAPI.similarMoviesInfo(movieId: self.movie.id) { moviesInfo, error in
            if let moviesInfo = moviesInfo {
                moviesInfo.detailIndex = Constants.DetailSectionIndex.SimilarSection
                self.detailInfo.append(moviesInfo)
            }
            group.leave()
        }

        group.enter()
        MoviesAPI.reviewsInfo(movieId: self.movie.id) { (reviewsInfo, error) in
            if let reviewsInfo = reviewsInfo {
                reviewsInfo.detailIndex = Constants.DetailSectionIndex.ReviewsSection
                self.detailInfo.append(reviewsInfo)
            }
            group.leave()
        }

        group.notify(queue: DispatchQueue.main) {
            self.detailInfo.sort(by: { $0.identifier < $1.identifier  })
            self.updateUI()
        }
    }

    private func updateUI() {
        adapter.performUpdates(animated: true, completion: nil)
    }
}


extension DetailMovieController: IGListAdapterDataSource {
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        if object is Movies {
            return MovieInfoSection()
        }
        else if object is CastInfo {
            return CastInfoSection()
        }
        else if object is VideosInfo {
            return VideosInfoSection()
        }
        else if object is ImagesInfo {
            return ImagesInfoSection()
        }
        else if object is MoviesInfo {
            return SimilarInfoSection()
        }
        else {
            return ReviewsInfoSection()
        }
    }

    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        return detailInfo as! [IGListDiffable]
    }

    func emptyView(for listAdapter: IGListAdapter) -> UIView? { return nil }
}






