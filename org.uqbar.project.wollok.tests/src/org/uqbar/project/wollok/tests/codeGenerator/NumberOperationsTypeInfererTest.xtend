package org.uqbar.project.wollok.tests.codeGenerator

import org.junit.Test
import org.uqbar.project.wollok.codeGenerator.model.types.NativeTypesEnum

class NumberOperationsTypeInfererTest extends AbstractWollokCodeGeneratorTypeInfererTest {
	
	@Test
	def void smallSumProgram(){
		'''
			program p {
				var x = 23
				var y = 50
				
				return x + y
			}
		'''.parseAndPerformAnalysis
				
		assertNativeTypeEquals(NativeTypesEnum.INT, pgm.variables.get('x'))
		assertNativeTypeEquals(NativeTypesEnum.INT, pgm.returnVariable) 
	}

	@Test
	def void smallSumProgramUsingInmediates(){
		'''
			program p {
				var x = 23
				
				return x + 34
			}
		'''.parseAndPerformAnalysis
		
		assertNativeTypeEquals(NativeTypesEnum.INT, pgm.variables.get('x'))
		assertNativeTypeEquals(NativeTypesEnum.INT, pgm.returnVariable) 
	}


	@Test
	def void smallSumProgramWithWKO(){
		'''
			object obj {
				method suma(){
					return 23 + 24
				}
			}
			program p {
				return obj.suma()
			}
		'''.parseAndPerformAnalysis
		
		assertNativeTypeEquals(NativeTypesEnum.INT, pgm.returnVariable) 
	}


	@Test
	def void smallSumProgramWithWKOUsingVariables(){
		'''
			object obj {
				const a = 17
				
				method suma(){
					return 23 + a
				}
			}
			program p {
				return obj.suma()
			}
		'''.parseAndPerformAnalysis
		
		assertNativeTypeEquals(NativeTypesEnum.INT, pgm.returnVariable) 
	}


	@Test
	def void smallSumProgramWithWKOUsingVariablesShadowing(){
		'''
			object obj {
				const a = 17
				
				method suma(){
					return 23 + a
				}
			}
			program p {
				var a
				a = obj
				return a.suma()
			}
		'''.parseAndPerformAnalysis
		
		assertNativeTypeEquals(NativeTypesEnum.INT, pgm.returnVariable) 
	}


	@Test
	def void smallSumProgramWithWKOUsingDoubles(){
		'''
			object obj {
				const a = 17
				
				method suma(){
					return 23.25 + a
				}
			}
			program p {
				var a
				a = obj
				return a.suma()
			}
		'''.parseAndPerformAnalysis
		
		assertNativeTypeEquals(NativeTypesEnum.DOUBLE, pgm.returnVariable) 
	}

	@Test
	def void smallSumProgramWithWKOUsingDoublesAsParameter(){
		'''
			object obj {
				const a = 17.5
				
				method suma(){
					return 23 + a
				}
			}
			program p {
				var a
				a = obj
				return a.suma()
			}
		'''.parseAndPerformAnalysis
		
		assertNativeTypeEquals(NativeTypesEnum.DOUBLE, pgm.returnVariable) 
	}

}