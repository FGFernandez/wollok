package org.uqbar.project.wollok.codeGenerator.model

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Method extends AbstractCompositeContext {

	val parameters = <Parameter>newArrayList
	val ClassDefinition parent
	var Boolean nativeMethod = false
	val String name
	
	new(ClassDefinition parent, String name) {
		this.parent = parent
		this.name = name
	}
	
	def addParameter(Parameter parameter) {
		parameters.add(parameter)
	}
	
}