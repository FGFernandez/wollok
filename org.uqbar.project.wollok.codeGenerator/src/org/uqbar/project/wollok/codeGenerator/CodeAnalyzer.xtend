package org.uqbar.project.wollok.codeGenerator

import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.nodemodel.util.NodeModelUtils
import org.uqbar.project.wollok.codeGenerator.model.Assignment
import org.uqbar.project.wollok.codeGenerator.model.Block
import org.uqbar.project.wollok.codeGenerator.model.BooleanLiteral
import org.uqbar.project.wollok.codeGenerator.model.ClassDefinition
import org.uqbar.project.wollok.codeGenerator.model.ConstructorCall
import org.uqbar.project.wollok.codeGenerator.model.Context
import org.uqbar.project.wollok.codeGenerator.model.Expression
import org.uqbar.project.wollok.codeGenerator.model.IfExpression
import org.uqbar.project.wollok.codeGenerator.model.MessageSend
import org.uqbar.project.wollok.codeGenerator.model.Method
import org.uqbar.project.wollok.codeGenerator.model.NamedObject
import org.uqbar.project.wollok.codeGenerator.model.NativeMethod
import org.uqbar.project.wollok.codeGenerator.model.Null
import org.uqbar.project.wollok.codeGenerator.model.NumberLiteral
import org.uqbar.project.wollok.codeGenerator.model.Parameter
import org.uqbar.project.wollok.codeGenerator.model.Program
import org.uqbar.project.wollok.codeGenerator.model.Return
import org.uqbar.project.wollok.codeGenerator.model.Self
import org.uqbar.project.wollok.codeGenerator.model.Variable
import org.uqbar.project.wollok.codeGenerator.model.VariableRef
import org.uqbar.project.wollok.interpreter.WollokClassFinder
import org.uqbar.project.wollok.wollokDsl.WAssignment
import org.uqbar.project.wollok.wollokDsl.WBinaryOperation
import org.uqbar.project.wollok.wollokDsl.WBlockExpression
import org.uqbar.project.wollok.wollokDsl.WBooleanLiteral
import org.uqbar.project.wollok.wollokDsl.WClass
import org.uqbar.project.wollok.wollokDsl.WConstructorCall
import org.uqbar.project.wollok.wollokDsl.WFile
import org.uqbar.project.wollok.wollokDsl.WIfExpression
import org.uqbar.project.wollok.wollokDsl.WMemberFeatureCall
import org.uqbar.project.wollok.wollokDsl.WMethodDeclaration
import org.uqbar.project.wollok.wollokDsl.WNamedObject
import org.uqbar.project.wollok.wollokDsl.WNullLiteral
import org.uqbar.project.wollok.wollokDsl.WNumberLiteral
import org.uqbar.project.wollok.wollokDsl.WParameter
import org.uqbar.project.wollok.wollokDsl.WProgram
import org.uqbar.project.wollok.wollokDsl.WReturnExpression
import org.uqbar.project.wollok.wollokDsl.WSelf
import org.uqbar.project.wollok.wollokDsl.WStringLiteral
import org.uqbar.project.wollok.wollokDsl.WUnaryOperation
import org.uqbar.project.wollok.wollokDsl.WVariableDeclaration
import org.uqbar.project.wollok.wollokDsl.WVariableReference
import org.uqbar.project.wollok.wollokDsl.impl.WThrowImpl

import static extension org.uqbar.project.wollok.codeGenerator.ModelExtensions.*
import static extension org.uqbar.project.wollok.model.WollokModelExtensions.*
import org.uqbar.project.wollok.wollokDsl.WSetLiteral
import org.uqbar.project.wollok.services.WollokDslGrammarAccess.WLiteralElements
import org.uqbar.project.wollok.wollokDsl.WListLiteral

class CodeAnalyzer {
	val program = new Program(this)
	var WFile wfile
	
	def dispatch Expression analyze(WProgram wprogram, Expression parent) {
		wprogram.eContents.forEach [
			program.operations.add(it.analyze(program))
		]
		program
	}

	def dispatch Expression analyze(EObject o, Expression parent) {
		val node = NodeModelUtils.getNode(o);
		
		throw new RuntimeException("This should be implemented: " + o?.class.name + " filename: " + o.file.URI.toString + " Line:" + node.startLine)
	}
	

	def dispatch Expression analyze(WNumberLiteral o, Expression parent) { new NumberLiteral(parent, o.value) }

	def dispatch Expression analyze(WNamedObject o, Program parent){
		new NamedObject(o.name, parent) => [
			o.members.forEach[ e | e.analyze(it.classDefinition) ]	
			parent.putVariableNamed(o.name, new Variable(parent, o.name) =>[ v | v.initialValue = it ])
		]
	}
	
	def dispatch Expression analyze(WBooleanLiteral bl, Expression parent){
		new BooleanLiteral(parent, bl.isTrue)
	}
	
	def dispatch Expression analyze(WNullLiteral nl, Expression parent){
		new Null(parent)
	}

	def dispatch Expression analyze(WVariableDeclaration vd, Context parent) {
		new Variable(parent, vd.variable.name) => [
			initialValue = vd.right?.analyze(it)
			parent.putVariableNamed(name, it)
		]
	}

	def dispatch Expression analyze(WMemberFeatureCall mfc, Expression parent) {
		new MessageSend(parent) => [ ms |
			ms.receiver = mfc.memberCallTarget.analyze(ms)
			ms.selector = mfc.feature
			ms.parameters = mfc.memberCallArguments.map[analyze(ms)]
		]
	}

	def dispatch Expression analyze(WVariableReference vr, Expression parent) {
		new VariableRef(parent, vr.ref.name);
	}

	def dispatch Expression analyze(WReturnExpression wReturn, Expression parent) {
		new Return(parent) => [
			expression = wReturn.expression.analyze(it)
			parent.findContext.returnVariable.assignations.add(it)
		]
	}
	
	def dispatch Expression analyze(WBinaryOperation b, Expression parent) {
		new MessageSend(parent) =>[
			receiver = b.leftOperand.analyze(it)
			selector = b.feature
			parameters =  #[b.rightOperand.analyze(it)]
		]
	}
	
	def dispatch Expression analyze(WMethodDeclaration m, ClassDefinition classDefinition){
		if(!m.native){
				new Method(classDefinition, m.name) => [
						m.parameters.map[ e | e.analyze(it)]
						//I will ignore if the method is abstract.
						if(m.expression !== null){
							it.operations.addAll(m.expression.analyze(it))
							classDefinition.putMethodNamed(m.name, it)
						}
				]
			}else{
				new NativeMethod(classDefinition, m.name, m.parameters.size) => [
					classDefinition.putMethodNamed(m.name, it)
				]
			}
	}
	
	def dispatch Expression analyze(WParameter param, Method m){
		new Parameter(param.name, m) => [ m.addParameter(it) ]
	}
	
	def dispatch Expression analyze(WSelf s, Expression parent){
		new Self(parent)
	}
	
	def dispatch Expression analyze(WAssignment wa, Expression parent){
		new Assignment(parent) => [
			variableName = wa.feature.ref.name
			expression = wa.value.analyze(it)
			parent.findContext.getVariableNamed(variableName).assignations.add(expression)
		]
	}
	
	def dispatch Expression analyze(WBlockExpression b, Method parent){
		b.expressions.forEach[ e | parent.operations.add(e.analyze(parent))]
		parent
	}

	def dispatch Expression analyze(WBlockExpression b, Expression parent){
		new Block(parent) => [ blk | 
			b.expressions.forEach[e | blk.operations.add(e.analyze(parent))]
		]
	}
	
	def dispatch Expression analyze(WClass c, Program parent){
		val className = c.fqn
		var ClassDefinition superClass
		
		if(className == "wollok.lang.Object") 
			superClass = null 
		else if(c.parent === null){
			superClass = program.resolveWollokClass("wollok.lang.Object")
		}else{
			superClass = program.resolveWollokClass(c.parent.fqn)
		}
		
		new ClassDefinition(parent, className, superClass) => [
			c.members.forEach[ e | e.analyze(it)]
			parent.storeWollokClass(className, it)
		]
	}
	
	def dispatch Expression analyze(WUnaryOperation op, Expression parent){
		new MessageSend(parent) => [ ms |
			ms.receiver = op.operand.analyze(ms)
			ms.selector = op.feature
			ms.parameters = #[]
		]
	}

	def dispatch Expression analyze(WSetLiteral sl, Expression parent){
		new ConstructorCall(parent, WollokClassFinder.instance.getSetClass(sl).fqn)
	}

	def dispatch Expression analyze(WListLiteral ll, Expression parent){
		new ConstructorCall(parent, WollokClassFinder.instance.getListClass(ll).fqn)
	}
	
	def dispatch Expression analyze(WConstructorCall cc, Expression parent){
		new ConstructorCall(parent, cc.classRef.fqn) => [ 
			arguments = cc.arguments.map[ e | e.analyze(it)]
		]
	}
	
	def dispatch Expression analyze(WIfExpression ifExpr, Expression parent){
		new IfExpression(parent) => [ ie |
			ie.condition = ifExpr.condition.analyze(ie)
			ie.trueSide = ifExpr.then.analyze(ie)
			ie.falseSide = ifExpr.^else?.analyze(ie)
		]
	}
	
	def dispatch Expression analyze(WStringLiteral lit, Expression parent){
		new StringLiteral(lit.value, parent)
	}
	
	def dispatch Expression analyze(WThrowImpl throwExp, Expression parent){
		new ThrowExpression(parent)
	}
	
	def performAnalysis(WFile file) {
		this.wfile = file
		wfile.elements.forEach[it.analyze(program)]
		wfile.main.analyze(program)
		program
	}
	
	def tryToResolve(String name) {
		val wClass = WollokClassFinder.instance.getCachedClass(wfile, name)
		wClass.analyze(program) as ClassDefinition
	}

}
