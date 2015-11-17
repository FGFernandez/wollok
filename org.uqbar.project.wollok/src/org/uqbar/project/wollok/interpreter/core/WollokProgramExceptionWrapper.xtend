package org.uqbar.project.wollok.interpreter.core

import org.uqbar.project.wollok.sdk.WollokDSK

import static extension org.uqbar.project.wollok.interpreter.nativeobj.WollokJavaConversions.*

/**
 * Wraps a user exception (an exception thrown in the user code
 * written in Wollok lang) into a java exception so we can reuse
 * java exception mechanism. 
 * 
 * @author jfernandes
 */
class WollokProgramExceptionWrapper extends RuntimeException {
	WollokObject wollokException
	
	new(WollokObject exception) {
		wollokException = exception
	}
	
	def getWollokException() {
		wollokException
	}
	
	def boolean isMessageNotUnderstood() {
		wollokException.call("className").wollokToJava(String) != WollokDSK.MESSAGE_NOT_UNDERSTOOD_EXCEPTION
	}
	
}