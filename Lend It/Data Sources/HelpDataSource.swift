//
//  HelpDataSource.swift
//  Lend It
//
//  Created by Grecia Escárcega on 2/1/19.
//  Copyright © 2019 Daniel Esteban Salinas Suárez. All rights reserved.
//

import Foundation

struct HelpDataSource {
    let helpItems = """
    [{"id":1,"title":"¿Cómo puedo rentar?","text":"Para rentar, lo unico que tienes que hacer es buscar el objeto que necesites en la barra de búsqueda que aparece en la parte superior del mapa. Si no ves alguna opción de renta en el mapa es porque nadie ha dado de alta ese objeto en el rango de búsqueda seleccionado. Si te aparecen varias opciones, selecciona cualquiera y te mostrará los detalles. Una vez que te hayas decidido por una opción, ve a la parte de abajo y selecciona el botón 'RENTAR', este te llevará al pago. Una vez realizado el pago, podrás ver el objeto que rentaste en la pestaña de 'Objetos rentados' en el menú principal."},{"id":2,"title":"No aparece el objeto que estoy buscando.","text":"Sólo los objetos que han sido dados de alta por otros usuarios y que están actualmente disponibles dentro de tu rango de búsqueda aparecerán. Por lo tanto, si no aparece el objeto que necesitas rentar, es porque ningún usuario cercano a tu ubicación lo ha dado de alta o porque todos los objetos cercanos a ti no están disponibles por el momento."}]
    """.data(using: .utf8)!
}
