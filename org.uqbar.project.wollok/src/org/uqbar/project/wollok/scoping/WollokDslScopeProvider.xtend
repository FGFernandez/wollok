/*
 * generated by Xtext
 */
package org.uqbar.project.wollok.scoping

import com.google.inject.Inject
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.xtext.resource.EObjectDescription
import org.eclipse.xtext.scoping.IScope
import org.eclipse.xtext.scoping.impl.AbstractDeclarativeScopeProvider
import org.eclipse.xtext.scoping.impl.ImportedNamespaceAwareLocalScopeProvider
import org.eclipse.xtext.scoping.impl.SimpleScope
import org.uqbar.project.wollok.wollokDsl.WCatch
import org.uqbar.project.wollok.wollokDsl.WClass
import org.uqbar.project.wollok.wollokDsl.WClosure
import org.uqbar.project.wollok.wollokDsl.WConstructor
import org.uqbar.project.wollok.wollokDsl.WExpression
import org.uqbar.project.wollok.wollokDsl.WMethodDeclaration
import org.uqbar.project.wollok.wollokDsl.WNamed
import org.uqbar.project.wollok.wollokDsl.WObjectLiteral
import org.uqbar.project.wollok.wollokDsl.WProgram
import org.uqbar.project.wollok.wollokDsl.WVariableDeclaration

import static extension org.uqbar.project.wollok.model.WollokModelExtensions.*
import static extension org.uqbar.project.wollok.utils.XTextExtensions.*

/**
 * This class contains custom scoping description.
 * 
 * see : http://www.eclipse.org/Xtext/documentation.html#scoping
 * on how and when to use it 
 *
 */
class WollokDslScopeProvider extends AbstractDeclarativeScopeProvider {

	@Inject
	ImportedNamespaceAwareLocalScopeProvider globalScopeProvider

	def IScope scope_WReferenciable(EObject ctx, EReference ref){
		val globalScope = globalScopeProvider.getScope(ctx,ref)
		val elements = ctx.scope.allElements
		new SimpleScope(globalScope, elements)
	}
	
	// scope extension methods for variable refs (with multiple dispatch)

	def dispatch IScope scope(WProgram prog) {
		val declaredVariables = prog.elements.filter(WVariableDeclaration).map[variable]
		new SimpleScope(declaredVariables.asScopeList)
	}
	
	def dispatch IScope scope(WClass clazz) {
		if (clazz.parent != null)
			clazz.parent.scope + clazz.declaredVariables
		else
			clazz.declaredVariables.asScope
	}
	
	// containers which declares elements
	def dispatch IScope scope(WObjectLiteral obj){ obj.declaredVariables.asScope }
	def dispatch IScope scope(WConstructor ctr) { ctr.eContainer.scope + ctr.parameters }
	def dispatch IScope scope(WClosure closure){ closure.eContainer.scope + closure.parameters }
	def dispatch IScope scope(WMethodDeclaration method){ method.eContainer.scope + method.parameters }
	def dispatch IScope scope(WCatch cach){ cach.eContainer.scope + cach.exceptionVarName }

	// usage
	def dispatch IScope scope(WExpression exp) {
		exp.eContainer.scope + exp.allSiblingsBefore.filter(WVariableDeclaration).map[variable]
	}
	
	// *******************************************
	// ** helper methods (OPERATOR OVERLOADING)
	// *******************************************
	
	def IScope operator_plus(IScope parent, EList<? extends WNamed> more) {
		new SimpleScope(parent, more.asScopeList)
	}
	
	def IScope operator_plus(IScope parent, WNamed oneMore) { parent + #[oneMore] }
	
	def IScope operator_plus(IScope parent, Iterable<? extends WNamed> more) {
		if (more.nullOrEmpty)
			parent
		else
			new SimpleScope(parent, more.asScopeList)
	}
	
	def asScopeList(Iterable<? extends WNamed> referenciables) {
		referenciables.map[
			EObjectDescription.create(QualifiedName.create(name), it)
		]
	}
	
	def asScope(Iterable<? extends WNamed> referenciables) {
		new SimpleScope(referenciables.asScopeList)
	}
}
