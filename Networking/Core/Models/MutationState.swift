//
//  MutationState.swift
//  Networking
//
//  Created by user on 18.05.2026.
//

import Foundation

enum MutationState{
  case idle
  case inProgress(MutationOperation)
  case succeded(MutationOperation)
  case failed(MutationOperation, String)
}


enum MutationOperation{
  case create
  case update
  case delete
}
