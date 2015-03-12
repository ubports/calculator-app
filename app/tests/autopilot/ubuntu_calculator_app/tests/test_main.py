# -*- Mode: Python; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-

"""Calculator app autopilot tests."""

from autopilot.matchers import Eventually
from testtools.matchers import Equals

from ubuntu_calculator_app.tests import CalculatorAppTestCase


class MainTestCase(CalculatorAppTestCase):

    def setUp(self):
        super(MainTestCase, self).setUp()

    def test_add_operator_after_result(self):
        self.app.main_view.insert('9*9=')

        self._assert_result_is(u'81')
        self._assert_history_contains(u'9×9=81')
        # We expect that after inserting operator,
        # the result will be used in next calculation
        self.app.main_view.insert('+9=')

        self._assert_result_is(u'90')
        self._assert_history_contains(u'81+9=90')

    def test_enter_number_after_result(self):
        self.app.main_view.insert('3*3=')

        self._assert_result_is(u'9')

        # We expect that after inserting number,
        # result will be deleted
        self._assert_history_contains(u'3×3=9')
        self.app.main_view.insert('2+3=')

        self._assert_result_is(u'5')
        self._assert_history_contains(u'2+3=5')

    def test_temporarly_result(self):
        self.app.main_view.insert('2450.1*369+')

        self._assert_result_is(u'904086.9+')
        self.app.main_view.insert('3.1=')

        self._assert_result_is(u'904090')
        self._assert_history_contains(u'2450.1×369+3.1=904090')

    def test_addding_operator_after_calculation(self):
        self.app.main_view.insert('8*8.1=')

        self._assert_result_is(u'64.8')
        self._assert_history_contains(u'8×8.1=64.8')

        self.app.main_view.insert('+5.2=')

        self._assert_result_is(u'70')
        self._assert_history_contains(u'64.8+5.2=70')

    def test_addding_number_after_calculation(self):
        self.app.main_view.insert('3*3.1=')

        self._assert_result_is(u'9.3')
        self._assert_history_contains(u'3×3.1=9.3')

        self.app.main_view.insert('8-7=')

        self._assert_result_is(u'1')
        self._assert_history_contains(u'8−7=1')

    def test_operation_after_clear(self):
        self.app.main_view.insert('7*7')

        self._assert_result_is(u'7×7')

        self.app.main_view.clear()
        self._assert_result_is(u'')
        self.app.main_view.insert('2*0=')

        self._assert_result_is(u'0')
        self._assert_history_contains(u'2×0=0')

    def test_operation_after_delete(self):
        self.app.main_view.insert('8*8=')

        self._assert_result_is(u'64')
        self._assert_history_contains(u'8×8=64')

        self.app.main_view.delete()
        self._assert_result_is(u'')
        self.app.main_view.insert('9*9=')

        self._assert_result_is(u'81')
        self._assert_history_contains(u'9×9=81')

    def test_small_numbers(self):
        self.app.main_view.insert('0.000000001+1=')
        self._assert_result_is(u'1.000000001')
        self._assert_history_contains(u'0.000000001+1=1.000000001')

        self.app.main_view.delete()

        self.app.main_view.insert('0.000000001/10=')
        self._assert_result_is(u'1e−10')
        self._assert_history_contains(u'0.000000001÷10=1e−10')

    def test_brackets_precedence(self):
        self.app.main_view.insert('2*')
        self.app.main_view.press_universal_bracket()
        self.app.main_view.insert('3+4')
        self.app.main_view.press_universal_bracket()
        self.app.main_view.insert('=')
        self._assert_result_is(u'14')
        self._assert_history_contains(u'2×(3+4)=14')

        self.app.main_view.delete()
        self.app.main_view.insert('4')
        self.app.main_view.press_universal_bracket()
        self.app.main_view.insert('3-2')
        self.app.main_view.press_universal_bracket()
        self._assert_result_is(u'4×(3−2)')
        self.app.main_view.insert('=')
        self._assert_result_is(u'4')
        self._assert_history_contains(u'4×(3−2)=4')

    def test_operators_precedence(self):
        self.app.main_view.insert('2+2*2=')

        self._assert_result_is(u'6')
        self._assert_history_contains(u'2+2×2=6')

        self.app.main_view.delete()
        self.app.main_view.insert('2-2*2=')

        self._assert_result_is(u'−2')
        self._assert_history_contains(u'2−2×2=−2')

        self.app.main_view.delete()
        self.app.main_view.insert('5+6/2=')

        self._assert_result_is(u'8')
        self._assert_history_contains(u'5+6÷2=8')

    def test_divide_with_zero(self):
        self.app.main_view.insert('0/5=')

        self._assert_result_is(u'0')
        self._assert_history_contains(u'0÷5=0')

    def test_divide_by_zero(self):
        self.app.main_view.insert('5/0=')

        self._assert_result_is(u'\u221e')
        self._assert_history_contains(u'5÷0=\u221e')

    def test_divide_zero_by_zero(self):
        self.app.main_view.insert('0/0=')

        self._assert_result_is(u'NaN')
        self._assert_history_contains(u'0÷0=NaN')

    def test_equals_doesnt_change_numbers(self):
        self.app.main_view.insert('125')
        self._assert_result_is(u'125')

        self.app.main_view.insert('=')
        self._assert_result_is(u'125')

    def test_divide_with_infinite_number_as_result(self):
        self.app.main_view.insert('1/3=')
        self._assert_result_is(u'0.3333333333333333')

    def test_operation_on_infinite_number(self):
        self.app.main_view.insert('5/3=')
        self._assert_result_is(u'1.6666666666666667')

        self.app.main_view.insert('-1=')
        self._assert_result_is(u'0.6666666666666667')

    def test_square(self):
        self.app.main_view.insert('2')
        self.app.main_view.show_scientific_keyboard()
        self.app.main_view.press('square')
        self.app.main_view.hide_scientific_keyboard()
        self.app.main_view.insert('=')

        self._assert_result_is(u'4')

    def test_cube(self):
        self.app.main_view.insert('3')
        self.app.main_view.show_scientific_keyboard()
        self.app.main_view.press('cube')
        self.app.main_view.hide_scientific_keyboard()
        self.app.main_view.insert('=')

        self._assert_result_is(u'27')

    def test_power(self):
        self.app.main_view.insert('2')
        self.app.main_view.show_scientific_keyboard()
        self.app.main_view.press('power')
        self.app.main_view.hide_scientific_keyboard()
        self.app.main_view.insert('3=')

        self._assert_result_is(u'8')

    def test_loge(self):
        self.app.main_view.show_scientific_keyboard()
        self.app.main_view.press('log')
        self.app.main_view.press('e')
        self.app.main_view.hide_scientific_keyboard()
        self.app.main_view.insert('=')

        self._assert_result_is(u'1')

    def test_factorial(self):
        self.app.main_view.insert('4')
        self.app.main_view.show_scientific_keyboard()
        self.app.main_view.press('!')
        self.app.main_view.hide_scientific_keyboard()
        self.app.main_view.insert('=')

        self._assert_result_is(u'24')
        self._assert_history_contains(u'4!=24')

    def test_sincos(self):
        self.app.main_view.show_scientific_keyboard()
        self.app.main_view.press('sin')
        self.app.main_view.hide_scientific_keyboard()
        self.app.main_view.insert('0=')

        self._assert_result_is(u'0')
        self._assert_history_contains(u'sin(0)=0')

        self.app.main_view.clear()
        self.app.main_view.show_scientific_keyboard()
        self.app.main_view.press('cos')
        self.app.main_view.hide_scientific_keyboard()
        self.app.main_view.insert('0=')

        self._assert_result_is(u'1')
        self._assert_history_contains(u'cos(0)=1')


    def test_complex_numbers(self):
        self.app.main_view.insert('66')
        self.app.main_view.show_scientific_keyboard()
        self.app.main_view.press('i')
        self.app.main_view.hide_scientific_keyboard()
        self.app.main_view.insert('*')
        self.app.main_view.show_scientific_keyboard()
        self.app.main_view.press('i')
        self.app.main_view.press('i')
        self.app.main_view.press('i')
        self._assert_result_is(u'66i×i')
        self.app.main_view.hide_scientific_keyboard()
        self.app.main_view.insert('33=')
        self._assert_result_is(u'−66')
        self._assert_history_contains(u'66i×i=−66')



    def _assert_result_is(self, value):
        self.assertThat(self.app.main_view.get_result,
                        Eventually(Equals(value)))

    def _assert_history_contains(self, value):
        self.assertTrue(self.app.main_view.get_history().contains(value))
