//
//  SupabaseManager.swift
//  Layman
//
//  Created by Aryan Gupta on 02/04/26.
//

import Foundation
import Supabase

class SupabaseManager {

    static let shared = SupabaseManager()

    let client: SupabaseClient

    private init() {

        client = SupabaseClient(
            supabaseURL: URL(string: "https://oriffclbqpcvlrynfuqv.supabase.co")!,
            supabaseKey: "sb_publishable_NmJt_FIY3JXs3NrnB1VgcA_E2I5agd9"
        )
    }
}
