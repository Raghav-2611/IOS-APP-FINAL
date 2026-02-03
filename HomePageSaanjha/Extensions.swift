import UIKit

extension UIColor {
    static var saanjhaSoftPink: UIColor {
        UIColor(red: 247/255, green: 120/255, blue: 107/255, alpha: 1.0)
    }

    static var saanjhaLightPink: UIColor {
        UIColor(red: 254/255, green: 247/255, blue: 246/255, alpha: 1.0)
    }

    static var saanjhaDarker: UIColor {
        UIColor(red: 44/255, green: 44/255, blue: 44/255, alpha: 1.0)
    }

    var iconTintColor: UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: b * 0.8, alpha: 1.0)
    }
}

extension UIView {
    func applyClayStyle() {
        layer.cornerRadius = 32
        layer.backgroundColor = UIColor.white.cgColor

        layer.shadowColor = UIColor.saanjhaSoftPink.cgColor
        layer.shadowOpacity = 0.12
        layer.shadowOffset = CGSize(width: 8, height: 8)
        layer.shadowRadius = 15

        layer.borderWidth = 2.0
        layer.borderColor = UIColor.white.cgColor
        layer.masksToBounds = false
    }

    func applyClayShadow() {
        layer.shadowColor = UIColor.saanjhaSoftPink.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 0, height: 8)
        layer.shadowRadius = 12
        layer.masksToBounds = false
    }
}
