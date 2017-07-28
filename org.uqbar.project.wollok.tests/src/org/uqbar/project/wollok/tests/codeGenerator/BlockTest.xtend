package org.uqbar.project.wollok.tests.codeGenerator

import org.junit.Test
import org.uqbar.project.wollok.codeGenerator.model.types.NativeTypesEnum
import org.uqbar.project.wollok.codeGenerator.model.types.NumericType
import org.uqbar.project.wollok.codeGenerator.model.types.UnionType
import org.uqbar.project.wollok.codeGenerator.model.types.StringType

class BlockTest extends AbstractWollokCodeGeneratorTypeInfererTest {
	
	@Test
	def void simpleType() {
		'''
			program p {
				if(2 > 3) {
					return 3
				}else{
					return "asd"
				}
			}
		'''.parseAndPerformAnalysis

		assertTypeIs(UnionType, pgm.returnVariable)
		assertUnionType(#{new NumericType(NativeTypesEnum.INT), new StringType}, pgm.returnVariable)
	}

	@Test
	def void simpleBlock() {
		'''
			program p {
				return { 123 }
			}
		'''.parseAndPerformAnalysis

		assertTypeIs(UnionType, pgm.returnVariable)
		assertUnionType(#{new NumericType(NativeTypesEnum.INT), new StringType}, pgm.returnVariable)
	}
}
