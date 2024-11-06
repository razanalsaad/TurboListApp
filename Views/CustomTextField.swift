import Foundation
import SwiftUI
import UIKit

struct CustomTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: CustomTextField
        var isPlaceholderVisible = true
        
        init(_ parent: CustomTextField) {
            self.parent = parent
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if isPlaceholderVisible {
                textView.text = ""
                textView.textColor = UIColor(named: "nameColor") ?? UIColor.black // استخدم nameColor هنا
                isPlaceholderVisible = false
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = parent.placeholder
                textView.textColor = UIColor(named: "CustomDarkGray") ?? UIColor.systemGray
                isPlaceholderVisible = true
            } else {
                parent.text = textView.text
                textView.textColor = UIColor(named: "nameColor") ?? UIColor.black // استخدم nameColor هنا
            }
        }
        
        func textViewDidChange(_ textView: UITextView) {
            if !isPlaceholderVisible {
                parent.text = textView.text
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        
        if text.isEmpty {
            textView.text = placeholder
            textView.textColor = UIColor(named: "CustomDarkGray") ?? UIColor.systemGray
            context.coordinator.isPlaceholderVisible = true
        } else {
            textView.text = text
            textView.textColor = UIColor(named: "nameColor") ?? UIColor.black // استخدم nameColor هنا
            context.coordinator.isPlaceholderVisible = false
        }
        
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.isScrollEnabled = true
        
        // إعدادات التصحيح الإملائي
        textView.autocorrectionType = .yes // تمكين التصحيح التلقائي
        textView.spellCheckingType = .yes // تمكين تصحيح الإملاء
        textView.layer.borderWidth = 0
        textView.layer.borderColor = UIColor(named: "bakgroundTap")?.cgColor
        textView.layer.cornerRadius = 11
        textView.backgroundColor = UIColor(named: "bakgroundTap")

        textView.layer.shadowColor = UIColor.black.cgColor
        textView.layer.shadowOpacity = 0.1
        textView.layer.shadowOffset = CGSize(width: 0, height: 5)
        textView.layer.shadowRadius = 10
        textView.layer.masksToBounds = false
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        if text.isEmpty && !uiView.isFirstResponder {
            uiView.text = placeholder
            uiView.textColor = UIColor(named: "CustomDarkGray") ?? UIColor.systemGray
            context.coordinator.isPlaceholderVisible = true
        } else if !text.isEmpty && context.coordinator.isPlaceholderVisible {
            uiView.text = text
            uiView.textColor = UIColor(named: "nameColor") ?? UIColor.black // استخدم nameColor هنا
            context.coordinator.isPlaceholderVisible = false
        }
    }
}
