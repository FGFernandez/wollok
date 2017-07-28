package org.uqbar.project.wollok.codeGenerator.model

import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.project.wollok.codeGenerator.model.types.TypeExtensions
import org.uqbar.project.wollok.codeGenerator.model.types.context.TypeContext
import org.uqbar.project.wollok.interpreter.nativeobj.NativeMessage
import org.uqbar.project.wollok.interpreter.natives.DefaultNativeObjectFactory

@Accessors
class NativeMethod extends Method {

	val int numberOfParamters

	new(ClassDefinition parent, String methodName, int numberOfParameters) {
		super(parent, methodName)
		this.numberOfParamters = numberOfParameters
	}

	override returnTypeFor(TypeContext tc) {
		val javaClassName = DefaultNativeObjectFactory.wollokToJavaFQN(parent.name)
		val c = Class.forName(javaClassName)
		val m = c.methods.findFirst [
			((it.isAnnotationPresent(NativeMessage) && it.getAnnotation(NativeMessage).value == it.name) ||
				it.name == this.name) && it.parameters.size == numberOfParamters
		]
		TypeExtensions.convertJavaType(m.returnType.name)
	}

}
