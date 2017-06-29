package org.uqbar.project.wollok.typesystem.constraints.strategies

import org.uqbar.project.wollok.typesystem.constraints.variables.ClosureTypeInfo
import org.uqbar.project.wollok.typesystem.constraints.variables.SimpleTypeInfo
import org.uqbar.project.wollok.typesystem.constraints.variables.TypeVariable

/**
 * Base class for creating inference strategies that are only meant for SimpleTypeInfo variables.
 */
abstract class SimpleTypeInferenceStrategy extends AbstractInferenceStrategy {
	/**
	 * Delegate to the dispatch method that will select the right behavior according to the type info.
	 * If typeInfo is null it means we have no information yet, so just ignore this variable for now.
	 */
	override analiseVariable(TypeVariable tvar) {
		if (tvar.typeInfo != null) analiseVariable(tvar, tvar.typeInfo)
	}

	def dispatch analiseVariable(TypeVariable tvar, ClosureTypeInfo typeInfo) {
		// This strategy does not work in closures
	}

	def dispatch analiseVariable(TypeVariable tvar, SimpleTypeInfo type) {
		this.analiseSimpleType(tvar, type)
	}
	
	def void analiseSimpleType(TypeVariable tvar, SimpleTypeInfo type)
}