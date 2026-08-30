import Foundation
import Vision
import AppKit

// 中文/英文图片 OCR 脚本（macOS 原生 Vision 框架，零第三方依赖）
// 用法: swift ocr_script.swift <图片路径...>
// 输出: 每张图片前打印 === FILE: <路径> ===，随后按阅读顺序输出识别文本

let args = CommandLine.arguments
guard args.count > 1 else {
    print("Usage: swift ocr_script.swift <image1> <image2> ...")
    exit(1)
}

for path in args.dropFirst() {
    print("=== FILE: \(path) ===")
    guard let image = NSImage(contentsOfFile: path),
          let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
        print("ERROR: 无法加载图片 \(path)")
        continue
    }

    let request = VNRecognizeTextRequest()
    request.recognitionLevel = .accurate                    // 高精度识别
    request.usesLanguageCorrection = true                   // 结合上下文纠错
    request.recognitionLanguages = ["zh-Hans", "en-US"]     // 简体中文 + 英文
    request.minimumTextHeight = 0.005                       // 滤除水印/过小文字

    let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    do {
        try handler.perform([request])
        guard let observations = request.results else {
            print("无识别结果")
            continue
        }
        // 按阅读顺序排序：上→下，同一行内左→右
        let sorted = observations.sorted { a, b in
            let ay = a.boundingBox.midY
            let by = b.boundingBox.midY
            if abs(ay - by) > 0.01 {
                return ay > by
            }
            return a.boundingBox.minX < b.boundingBox.minX
        }
        for obs in sorted {
            if let candidate = obs.topCandidates(1).first {
                print(candidate.string)
            }
        }
    } catch {
        print("ERROR: \(error)")
    }
    print("=== END ===")
}
