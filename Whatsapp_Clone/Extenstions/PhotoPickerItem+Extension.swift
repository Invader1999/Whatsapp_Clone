//
//  PhotoPickerItem+Extension.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 28/05/24.
//

import Foundation
import _PhotosUI_SwiftUI

extension PhotosPickerItem{
    var isVideo:Bool{
        let videoUTTypes:[UTType] = [
            .avi,
            .video,
            .mpeg2Video,
            .mpeg4Movie,
            .movie,
            .quickTimeMovie,
            .audiovisualContent,
            .mpeg,
            .appleProtectedMPEG4Video
        ]
        return videoUTTypes.contains(where: supportedContentTypes.contains)
    }
}

