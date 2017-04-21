/*
 * generated by Xtext
 */
package org.uqbar.project.wollok.ide

import com.google.inject.Guice
import org.eclipse.xtext.util.Modules2
import org.uqbar.project.wollok.WollokDslRuntimeModule
import org.uqbar.project.wollok.WollokDslStandaloneSetup

/**
 * Initialization support for running Xtext languages as language servers.
 */
class WollokDslIdeSetup extends WollokDslStandaloneSetup {

	override createInjector() {
		Guice.createInjector(Modules2.mixin(new WollokDslRuntimeModule, new WollokDslIdeModule))
	}
	
}