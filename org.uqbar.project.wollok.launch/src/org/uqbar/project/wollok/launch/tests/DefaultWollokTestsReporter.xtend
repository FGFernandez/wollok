package org.uqbar.project.wollok.launch.tests

import java.util.List
import org.eclipse.emf.common.util.URI
import org.uqbar.project.wollok.interpreter.core.WollokObject
import org.uqbar.project.wollok.wollokDsl.WFile
import org.uqbar.project.wollok.wollokDsl.WTest
import wollok.lib.AssertionException

/**
 * Does nothing (?)
 * 
 * @author tesonep
 */
class DefaultWollokTestsReporter implements WollokTestsReporter {
	
	override reportTestAssertError(WTest test, AssertionException assertionError, WollokObject wollokException, int lineNumber, URI resource) {
		throw assertionError
	}
	
	override reportTestOk(WTest test) {}
	
	override testsToRun(WFile file, List<WTest> tests) {}
	
	override testStart(WTest test) {}
	
	override reportTestError(WTest test, Exception exception, int lineNumber, URI resource) {
		throw exception
	}
	
	override finished() {
	
	}
	
}