//
//  ModelBooks.swift
//
//  Created by Osvaldo Arriaga Garduño on 23/08/23.
//

import Foundation

// MARK: - ModelBooks
struct ModelBooks: Decodable {
    let kind: String
    let totalItems: Int
    let items: [Item]
}

// MARK: - Item
struct Item: Decodable {
    let kind: String
    let id: String
    let etag: String
    let selfLink: String
    let volumeInfo: VolumeInfo
}

// MARK: - VolumeInfo
struct VolumeInfo: Decodable {
    let title: String
    let authors: [String]?
    let publishedDate: String?
    let description: String?
    let imageLinks: ImageLinks?
}

// MARK: - ImageLinks
struct ImageLinks: Decodable {
    let smallThumbnail: String?
    let thumbnail: String?
}
