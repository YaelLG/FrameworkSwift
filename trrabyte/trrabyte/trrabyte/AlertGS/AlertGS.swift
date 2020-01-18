//
//  AlertV.swift
//
//  Created by Diego Yael on 2/20/19.
//  Copyright © 2019 Diego Yael. All rights reserved.
//

import Foundation
import UIKit

protocol OptionAlertSelectedDelegate{
    func optionSelected(tipoDeOpcion: tipoDeOpcion!)
}

@objc enum tipoDeAlerta: Int {
    case alertaOK = 0
    case alertaConDosOpciones
}

enum tipoDeOpcion: Int {
    case tipoDeOpcionOK = 0
    case tipoDeOpcionUnoConDosOpciones
    case tipoDeOpcionDosConDosOpciones
}

class AlertGS: UIView
{
    static let constHeightOptions : CGFloat = 23.5
    static let minHeightView : CGFloat = 160
    static var customAlert : AlertGS!
    static var opcionSelected : tipoDeOpcion = .tipoDeOpcionOK
    
    var delegate: OptionAlertSelectedDelegate?
    
    @IBOutlet weak var view_tap: UIView!
    @IBOutlet weak var view_contenido: UIView!
    @IBOutlet weak var view_contenidoBlanco: UIView!
    @IBOutlet weak var view_dosOpciones: UIView!
    @IBOutlet weak var view_unaOpcion: UIView!
    
    @IBOutlet weak var lb_titulo: UILabel!
    @IBOutlet weak var lb_descripcion: UILabel!
    
    @IBOutlet weak var btn_optionOne: UIButton!
    @IBOutlet weak var btn_optionTwo: UIButton!
    
    class func customInitOneOption(titulo : String?, descripcion: String?, tipo: tipoDeAlerta, delegate : OptionAlertSelectedDelegate) -> AlertGS
    {
        self.initAlertGS(titulo: titulo, descripcion: descripcion, tipo: tipo, delegate: delegate)
        return customAlert
    }

    class func customInitTwoOptions(titulo : String?, descripcion: String?, tipo: tipoDeAlerta, delegate : OptionAlertSelectedDelegate, textOptionOne : String?, textOptionTwo : String?) -> AlertGS
    {
        self.initAlertGS(titulo: titulo, descripcion: descripcion, tipo: tipo, delegate: delegate)
        
        customAlert.btn_optionOne.setTitle(textOptionOne, for: .normal)
        customAlert.btn_optionTwo.setTitle(textOptionTwo, for: .normal)

        return customAlert
    }
    
    
    private class func initAlertGS(titulo : String?, descripcion: String?, tipo: tipoDeAlerta, delegate : OptionAlertSelectedDelegate)
    {
        customAlert = Bundle.main.loadNibNamed("AlertGS", owner: nil, options: nil)?.first! as? AlertGS
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapSelectorView))
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(tapSelectorView))
        
        customAlert.view_tap.addGestureRecognizer(gesture)
        customAlert.view_tap.addGestureRecognizer(tapGesture)
        customAlert.delegate = delegate
        
        customAlert.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        customAlert.lb_titulo.text = titulo
        
        customAlert.lb_descripcion.text = descripcion
        
        customAlert.lb_descripcion.frame = {
            var frame = customAlert.lb_descripcion.frame
            frame.origin.y = customAlert.lb_titulo.frame.maxY + 8
            return frame
        }()
        
        customAlert.view_contenidoBlanco.frame = {
            var frame = customAlert.view_contenidoBlanco.frame
            frame.size.height = customAlert.lb_descripcion.frame.size.height + 50 < 200 ? minHeightView : customAlert.lb_descripcion.frame.size.height + 50
            frame.origin = CGPoint.init(x: 0, y: 0)
            return frame
        }()
        
        switch tipo
        {
        case .alertaOK:
            customAlert.view_unaOpcion.isHidden = false
            customAlert.view_dosOpciones.isHidden = true
            
            customAlert.view_unaOpcion.frame = {
                var frame = customAlert.view_unaOpcion.frame
                frame.origin.y = customAlert.view_contenidoBlanco.frame.size.height - (customAlert.view_dosOpciones.frame.size.height/2)
                return frame
            }()
            
        case .alertaConDosOpciones:
            customAlert.view_unaOpcion.isHidden = true
            customAlert.view_dosOpciones.isHidden = false
            
            customAlert.view_dosOpciones.frame = {
                var frame = customAlert.view_dosOpciones.frame
                frame.origin.y = customAlert.view_contenidoBlanco.frame.size.height - (customAlert.view_dosOpciones.frame.size.height/2)
                return frame
            }()
        }
        
        customAlert.lb_descripcion.center = CGPoint.init(x:customAlert.view_contenidoBlanco.frame.midX, y: customAlert.view_contenidoBlanco.frame.midY)
    }
    
    //MARK: - Selectores
    
    @objc class func tapSelectorView()
    {
        customAlert.delegate?.optionSelected(tipoDeOpcion: opcionSelected)
    }
    
    //MARK: - Click actions

    @IBAction func click_ok(_ sender: UIButton)
    {
        AlertGS.customAlert.delegate?.optionSelected(tipoDeOpcion: .tipoDeOpcionOK)
    }
    
    @IBAction func click_optionOne(_ sender: UIButton)
    {
        AlertGS.customAlert.delegate?.optionSelected(tipoDeOpcion: .tipoDeOpcionUnoConDosOpciones)
    }
    
    @IBAction func click_optionTwo(_ sender: UIButton)
    {
        AlertGS.customAlert.delegate?.optionSelected(tipoDeOpcion: .tipoDeOpcionDosConDosOpciones)
    }
    
}
