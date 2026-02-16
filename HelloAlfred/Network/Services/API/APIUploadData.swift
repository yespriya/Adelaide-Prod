//
//  APIUploadData.swift
//  Adelaide Prod
//
//  Created by Prit  on 04/02/26.
//

import Alamofire
import Foundation

struct APIUploadData {
    var id: String?
    var image: Data?
    var pdf: Data?
    var fileType: String = ""
    var mimeType: String = ""
    var fileName: String = ""
    
    var params: [String: Any] {
        var params: [String: Any] = [:]
        params["fileType"] = fileType
        return params
    }
}

extension MultipartFormData {
    func appendUploadData(_ uploadData: APIUploadData) {
        for (key, value) in uploadData.params {
            if let data = "\(value)".data(using: String.Encoding.utf8) {
                append(data, withName: key)
            }
        }

        if let image = uploadData.image {
            append(image, withName: "file_", fileName: uploadData.fileName, mimeType: uploadData.mimeType)
        } else if let pdf = uploadData.pdf {
            append(pdf, withName: "file", fileName: uploadData.fileName, mimeType: uploadData.mimeType)
        }
    }
}
