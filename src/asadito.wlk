import wollok.game.*

class Persona {

	var property posicion = new Position(x = 1, y = 1)
	const elementosCercanos = []
	const comidasDigeridas = []
	var property criterioPasarElemento = sordo
	var property criterioComida = vegetariano

	method agregarElementoCercano(elementos) {
		elementosCercanos.addAll(elementos)
	}

	method agregarComidas(comidas) {
		comidasDigeridas.addAll(comidas)
	}

	method elementoCercano() = elementosCercanos

	method eliminarElementos(elementos) {
		elementosCercanos.removeAllSuchThat{ elementoCercano => elementos.contains(elementoCercano)}
	}

	method darElemento(comenzalQuePide, elemento) {
		if (!self.tieneElElemento(elemento)) throw new Exception(message = "La persona no tiene el elemento y no puede pasarlo")
		criterioPasarElemento.pasarElemento(elemento, self, comenzalQuePide)
	}

	method tieneElElemento(elemento) = elementosCercanos.contains(elemento)

	method puedeComer(comida) = criterioComida.puedeComer(comida)

	method estaPipon() = self.comioAlgoPesado()

	method comioAlgoPesado() = comidasDigeridas.any{ comida => self.esPesada(comida) }

	method esPesada(comida) = comida.calorias() > 500

	method laEstaPasandoBien() = self.comioAlgo() && self.gustoExtra()

	method comioAlgo() = !comidasDigeridas.isEmpty()

	method gustoExtra()

}

class Criterio {

	method pasarElemento(elemento, comensalQueDa, comenzalQuePide) {
		const elementoASacar = self.elementosASacar(comensalQueDa, elemento)
		comenzalQuePide.agregarElementoCercano(elementoASacar)
		comensalQueDa.eliminarElementos(elementoASacar)
	}

	method elementosASacar(comensalQueDa, elemento)

}

object sordo inherits Criterio {

	override method elementosASacar(comensalQueDa, elemento) = [ comensalQueDa.elementoCercano().head() ]

}

object irritable inherits Criterio {

	override method elementosASacar(comensalQueDa, elemento) = comensalQueDa.elementoCercano()

}

object movedizo {

	method pasarElemento(elemento, comensalQueDa, comenzalQuePide) {
		const posicionPide = comenzalQuePide.posicion()
		comenzalQuePide.posicion(comensalQueDa.posicion())
		comensalQueDa.posicion(posicionPide)
	}

}

object obediente inherits Criterio {

	override method elementosASacar(comensalQueDa, elemento) = [ elemento ]

}

class Comida {

	const property esCarne
	const property calorias = 32

	method tieneCarne() = esCarne

}

class CriterioComida {

	method puedeComer(comida)

}

object vegetariano inherits CriterioComida {

	override method puedeComer(comida) = !comida.tieneCarne()

}

object dietetico inherits CriterioComida {

	var property caloriasMaxima = 500

	override method puedeComer(comida) = comida.calorias() < caloriasMaxima

}

class Alternado inherits CriterioComida {

	var acepta = false

	override method puedeComer(comida) {
		acepta = not acepta
		return not acepta
	}

}

class Combinada inherits CriterioComida {

	var property criteriosComida = []

	method agregarCriteriosComida(criterios) {
		criteriosComida.addAll(criterios)
	}

	override method puedeComer(comida) = criteriosComida.all{ criterio => criterio.puedeComer(comida) }

}

object osky inherits Persona {

	override method gustoExtra() = true

}

object moni inherits Persona {

	override method gustoExtra() = self.posicionDeseada()

	method posicionDeseada() = posicion == game.at(1, 1)

}

object facu inherits Persona {

	override method gustoExtra() = self.comioCarne()

	method comioCarne() = comidasDigeridas.any{ comida => comida.tieneCarne() }

}

object vero inherits Persona {

	override method gustoExtra() = self.tienePocosElementosCerca()
	
	method tienePocosElementosCerca() = elementosCercanos.size() <= 3

}

