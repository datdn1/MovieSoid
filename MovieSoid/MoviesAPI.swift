//
//  MoviesAPI.swift
//  MovieSoid
//
//  Created by datdn1 on 6/16/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import Foundation
import Moya

let apiKey = "45b7f99484f7012bd93bbf56b271faaf"

// MARK: - Provider setup
private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}

let MoviesProvider = MoyaProvider<MoviesAPI>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])

// MARK: - Provider support
private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

public enum MoviesAPI {
    case discover(String, Int)
    case getDetail(Int)
    case getCredits(Int)
    case getImages(Int)
    case getVideos(Int)
    case getSimilar(Int)
    case getReviews(Int)
}


// MARK: - Configure network client
extension MoviesAPI: TargetType {
    public var headers: [String : String]? {
        return ["Accept": "application/json", "Content-Type": "application/json"]
    }
    

    public var baseURL: URL { return URL(string: Constants.URL.EndpointBaseURL)! }

    public var path: String {
        switch self {
        case .discover:
            return "/discover/movie/"
        case .getDetail(let movieId):
            return "/movie/\(movieId)"
        case .getCredits(let movieId):
            return "/movie/\(movieId)/credits"
        case .getImages(let movieId):
            return "/movie/\(movieId)/images"
        case .getVideos(let movieId):
            return "/movie/\(movieId)/videos"
        case .getSimilar(let movieId):
            return "/movie/\(movieId)/similar"
        case .getReviews(let movieId):
            return "/movie/\(movieId)/reviews"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .discover, .getDetail, .getCredits, .getImages, .getVideos, .getSimilar, .getReviews:
            return .get
        }
    }

    public var parameters: [String: Any]? {
        switch self {
        case .discover(let sortBy, let page):
            return ["api_key": apiKey, "language" : "en-US", "sort_by" : sortBy, "page" : page]
        case .getDetail:
            return ["api_key": apiKey, "language" : "en-US"]
        case .getCredits, .getImages, .getVideos, .getSimilar, .getReviews:
            return ["api_key": apiKey]
        }
    }

    public var parameterEncoding: ParameterEncoding {
        switch self {
        case .discover, .getDetail, .getCredits, .getImages, .getVideos, .getSimilar, .getReviews:
            return URLEncoding.default
        }
    }

    public var task: Task {
        return .requestPlain
    }

    public var sampleData: Data {
        switch self {
        case .discover, .getDetail, .getCredits, .getImages, .getVideos, .getSimilar, .getReviews:
            return "Half measures are as bad as nothing at all.".data(using: String.Encoding.utf8)!
        }
    }
}



// MARK: - APIs
extension MoviesAPI {

    enum MoviesError {
        case ParseJSONError
        case NetworkError(String)
    }

    static func discoverMovies(page: Int, complete: @escaping ([Movies]?, MoviesError?) -> Void) {
        MoviesProvider.request(.discover("popularity.desc", page)) { result in
            switch result {
            case let .success(response):
                // parse json success
                do {
                    let moviesInfo: MoviesInfo? = try response.mapObject(MoviesInfo.self)
                    var movies: [Movies] = []
                    if let moviesInfo = moviesInfo, let mo = moviesInfo.movies {
                        movies = mo
                    }
                    complete(movies, nil)
                }
                // parse json failed
                catch { complete(nil, MoviesError.ParseJSONError) }

            case let .failure(error):
                complete(nil, .NetworkError(error.localizedDescription))
            }
        }
    }

    static func detailMovie(movieId: Int, complete: @escaping (Movies?, MoviesError?)-> Void) {
        MoviesProvider.request(.getDetail(movieId)) { (result) in
            switch result {
            case let .success(response):
                // parse json success
                do {
                    let movies: Movies? = try response.mapObject(Movies.self)
                    complete(movies, nil)
                }
                    // parse json failed
                catch { complete(nil, MoviesError.ParseJSONError) }

            case let .failure(error):
                complete(nil, .NetworkError(error.localizedDescription))
            }
        }
    }

    static func creditsInfo(movieId: Int, complete: @escaping (CastInfo?, MoviesError?) -> Void) {
        MoviesProvider.request(.getCredits(movieId)) { result in
            switch result {
            case let .success(response):
                // parse json success
                do {
                    let casts: CastInfo? = try response.mapObject(CastInfo.self)
                    complete(casts, nil)
                }
                    // parse json failed
                catch { complete(nil, MoviesError.ParseJSONError) }

            case let .failure(error):
                complete(nil, .NetworkError(error.localizedDescription))
            }
        }
    }

    static func imagesInfo(movieId: Int, complete: @escaping (ImagesInfo?, MoviesError?) -> Void) {
        MoviesProvider.request(.getImages(movieId)) { result in
            switch result {
            case let .success(response):
                // parse json success
                do {
                    let images: ImagesInfo? = try response.mapObject(ImagesInfo.self)
                    complete(images, nil)
                }
                    // parse json failed
                catch { complete(nil, MoviesError.ParseJSONError) }

            case let .failure(error):
                complete(nil, .NetworkError(error.localizedDescription))
            }
        }
    }

    static func videosInfo(movieId: Int, complete: @escaping (VideosInfo?, MoviesError?) -> Void) {
        MoviesProvider.request(.getVideos(movieId)) { result in
            switch result {
            case let .success(response):
                // parse json success
                do {
                    let videos: VideosInfo? = try response.mapObject(VideosInfo.self)
                    complete(videos, nil)
                }
                    // parse json failed
                catch { complete(nil, MoviesError.ParseJSONError) }

            case let .failure(error):
                complete(nil, .NetworkError(error.localizedDescription))
            }
        }
    }

    static func similarMoviesInfo(movieId: Int, complete: @escaping (MoviesInfo?, MoviesError?) -> Void) {
        MoviesProvider.request(.getSimilar(movieId)) { result in
            switch result {
            case let .success(response):
                // parse json success
                do {
                    let moviesInfo: MoviesInfo? = try response.mapObject(MoviesInfo.self)
                    complete(moviesInfo, nil)
                }
                    // parse json failed
                catch { complete(nil, MoviesError.ParseJSONError) }

            case let .failure(error):
                complete(nil, .NetworkError(error.localizedDescription))
            }
        }
    }

    static func reviewsInfo(movieId: Int, complete: @escaping (ReviewsInfo?, MoviesError?) -> Void) {
        MoviesProvider.request(.getReviews(movieId)) { result in
            switch result {
            case let .success(response):
                // parse json success
                do {
                    let reviewsInfo: ReviewsInfo? = try response.mapObject(ReviewsInfo.self)
                    complete(reviewsInfo, nil)
                }
                    // parse json failed
                catch { complete(nil, MoviesError.ParseJSONError) }

            case let .failure(error):
                complete(nil, .NetworkError(error.localizedDescription))
            }
        }
    }
}






