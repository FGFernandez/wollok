package org.uqbar.project.wollok.tests.xpect

import org.eclipse.xtext.testing.InjectWith
import org.junit.runner.RunWith
import org.junit.runner.Runner
import org.junit.runner.notification.RunNotifier
import org.junit.runners.model.InitializationError
import org.uqbar.project.wollok.scoping.WollokResourceCache
import org.uqbar.project.wollok.tests.injectors.WollokTestInjector
import org.xpect.runner.XpectRunner
import org.xpect.xtext.lib.tests.XtextTests

/**
 * @author jfernandes
 */
@RunWith(WollokXpectRunner)
@InjectWith(WollokTestInjector)
class WollokXPectTest extends XtextTests {
}

class WollokXpectRunner extends XpectRunner {
	new(Class<?> testClass) throws InitializationError {
		super(testClass)
	}

	override runChild(Runner child, RunNotifier notifier) {
		WollokResourceCache.clearCache
		super.runChild(child, notifier)
	}
}
