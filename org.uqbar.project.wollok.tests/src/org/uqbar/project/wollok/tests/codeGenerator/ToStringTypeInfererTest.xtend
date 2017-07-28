package org.uqbar.project.wollok.tests.codeGenerator

import org.junit.Test
import org.uqbar.project.wollok.codeGenerator.model.types.NativeTypesEnum

class ToStringTypeInfererTest extends AbstractWollokCodeGeneratorTypeInfererTest {
	
	@Test
	def void inferOfSimplifiedToSmartString(){
		'''
			program p {
				var a = 23
				return a.simplifiedToSmartString()
			}
		'''.parseAndPerformAnalysis
		
		assertNativeTypeEquals(NativeTypesEnum.STRING, pgm.returnVariable) 
	}

	@Test
	def void inferOfToString(){
		'''
			program p {
				var a = #{}
				return a.toString()
			}
		'''.parseAndPerformAnalysis
		
		assertNativeTypeEquals(NativeTypesEnum.STRING, pgm.returnVariable) 
	}
}