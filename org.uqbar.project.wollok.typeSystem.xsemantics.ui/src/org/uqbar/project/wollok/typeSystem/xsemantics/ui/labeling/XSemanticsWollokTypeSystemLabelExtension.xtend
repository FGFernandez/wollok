package org.uqbar.project.wollok.typeSystem.xsemantics.ui.labeling

import org.eclipse.emf.ecore.EObject
import org.uqbar.project.wollok.typesystem.WollokTypeSystemActivator
import org.uqbar.project.wollok.ui.labeling.WollokTypeSystemLabelExtension
import org.apache.log4j.Logger

/**
 * 
 */
// RENAME and move to typesystem project, since it is not coupled with xsemantics anymore. 
class XSemanticsWollokTypeSystemLabelExtension implements WollokTypeSystemLabelExtension {

	val Logger log = Logger.getLogger(this.class)

	override resolvedType(EObject o) {
		// if disabeld
		if (!WollokTypeSystemActivator.^default.isTypeSystemEnabled(o))
			return null

		this.doResolvedType(o) ?: "Any"
	}

	def doResolvedType(EObject o) {
		try {
			val typeSystem = WollokTypeSystemActivator.^default.getTypeSystem(o)
//			typeSystem.analyse(o.eResource.contents.get(0)) // analyses all the file
//			typeSystem.inferTypes
			return typeSystem.type(o)?.toString
		} catch (Exception e) {
			log.error("Error in type system !! " + e.message, e)
			return null
		}
	}

}
