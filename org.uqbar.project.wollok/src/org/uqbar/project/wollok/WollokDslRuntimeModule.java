/*
 * generated by Xtext
 */
package org.uqbar.project.wollok;

import org.eclipse.xtext.naming.IQualifiedNameProvider;
import org.eclipse.xtext.resource.IDefaultResourceDescriptionStrategy;
import org.eclipse.xtext.scoping.IGlobalScopeProvider;
import org.eclipse.xtext.scoping.IScopeProvider;
import org.uqbar.project.wollok.manifest.WollokManifestFinder;
import org.uqbar.project.wollok.manifest.classpath.WollokClasspathManifestFinder;
import org.uqbar.project.wollok.scoping.WollokGlobalScopeProvider;
import org.uqbar.project.wollok.scoping.WollokImportedNamespaceAwareLocalScopeProvider;
import org.uqbar.project.wollok.scoping.WollokQualifiedNameProvider;
import org.uqbar.project.wollok.scoping.WollokResourceDescriptionStrategy;

import com.google.inject.Binder;

/**
 * Use this class to register components to be used at runtime / without the
 * Equinox extension registry.
 */
public class WollokDslRuntimeModule extends
		org.uqbar.project.wollok.AbstractWollokDslRuntimeModule {

	@Override
	public void configure(Binder binder) {
		super.configure(binder);
		// TYPE SYSTEM
		//binder.bind(TypeSystem.class).to(ConstraintBasedTypeSystem.class);
	}
	// customize exported objects
	public Class<? extends IDefaultResourceDescriptionStrategy> bindIDefaultResourceDescriptionStrategy() {
		return WollokResourceDescriptionStrategy.class;
	}

	public Class<? extends IGlobalScopeProvider> bindIGlobalScopeProvider() {
		return WollokGlobalScopeProvider.class;
	}

	/*
	public Class<? extends IScopeProvider> bindIScopeProvider() {
		return WollokImportedNamespaceAwareLocalScopeProvider.class;
	}
	 */

	public Class<? extends WollokManifestFinder> bindWollokManifestFinder() {
		return WollokClasspathManifestFinder.class;
	}

	public void configureIScopeProviderDelegate(com.google.inject.Binder binder) {
		binder.bind(org.eclipse.xtext.scoping.IScopeProvider.class)
				.annotatedWith(
						com.google.inject.name.Names
								.named(org.eclipse.xtext.scoping.impl.AbstractDeclarativeScopeProvider.NAMED_DELEGATE))
				.to(WollokImportedNamespaceAwareLocalScopeProvider.class);
	}

	public Class<? extends IQualifiedNameProvider> bindIQualifiedNameProvider() {
		return WollokQualifiedNameProvider.class;
	}

}
