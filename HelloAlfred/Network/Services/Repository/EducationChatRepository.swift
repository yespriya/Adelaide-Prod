//
//  EducationChatRepository.swift
//  Adelaide Prod
//
//  Created by Prit  on 08/02/26.
//

import Foundation
import RxSwift
import Alamofire

struct EducationChatRepository {
    let api: APIService = .shared
    /*
    // save chat
    func saveChat(with model: ChatSaveModel, isShowLoader: Bool) -> Single<SimpleResponse> {
        return api.request(router: .saveChat(model: model), checking: isShowLoader ? .checked : .unchecked)
    }
    
    // pereference chat
    func pereferenceChat(with model: PrefereceChatModel, isShowLoader: Bool) -> Single<SimpleResponse> {
        return api.request(router: .preferenceChat(model: model), checking: isShowLoader ? .checked : .unchecked)
    }
    
    func getBotStaticMessage(isShowLoader: Bool) -> Single<BaseResponse<BotStaticMessage>> {
        return api.request(router: .getBotStaticMessage, checking: isShowLoader ? .checked : .unchecked)
    }
    */
}
