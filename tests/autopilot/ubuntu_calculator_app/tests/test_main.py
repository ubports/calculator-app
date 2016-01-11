# -*- Mode: Python; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-

"""Calculator app autopilot tests."""

from autopilot.matchers import Eventually
from testtools.matchers import Equals
from ubuntu_calculator_app.tests import CalculatorAppTestCase


class MainTestCase(CalculatorAppTestCase):

    def setUp(self):
        super(MainTestCase, self).setUp()

        self.app.main_view.get_walkthrough_page().skip()

    def test_simple_calculation_via_keyboard(self):
        self.app.main_view.enter_text_via_keyboard('.9')
        self._assert_result_is(u'0.9')

        self.app.main_view.enter_text_via_keyboard('*9/')
        self._assert_result_is(u'8.1÷')

        self.app.main_view.enter_text_via_keyboard('.3=')
        self._assert_result_is(u'27')
        self._assert_history_contains(u'0.9×9÷0.3=27')

        self.app.main_view.enter_text_via_keyboard('+3')
        self.app.main_view.press_and_release_key('Enter')
        self._assert_result_is(u'30')
        self._assert_history_contains(u'0.9×9÷0.3=27')

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
        self.app.main_view.insert('0.0000000001+1=')
        self._assert_result_is(u'1.0000000001')
        self._assert_history_contains(u'0.0000000001+1=1.0000000001')

        self.app.main_view.delete()

        self.app.main_view.insert('0.0000000001/10=')
        self._assert_result_is(u'1e−11')
        self._assert_history_contains(u'0.0000000001÷10=1e−11')

    def test_operation_on_large_numbers(self):
        self.app.main_view.insert('99999999999*99999999999=')
        self._assert_result_is(u'9.9999999998e+21')
        self._assert_history_contains(u'99999999999×99999999999='
                                      '9.9999999998e+21')

        self.app.main_view.insert('*100=')

        self._assert_result_is(u'9.9999999998e+23')
        self._assert_history_contains(u'9.9999999998e+21×100='
                                      '9.9999999998e+23')

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
        count_one = self.app.main_view.get_history().get_history_entry_count()

        self.app.main_view.insert('5*5=')
        self._assert_result_is(u'25')
        count_two = self.app.main_view.get_history().get_history_entry_count()
        self.assertTrue(count_one == count_two - 1)

        self.app.main_view.insert('===')
        self._assert_result_is(u'25')
        count_three = self.app.main_view.get_history() \
                          .get_history_entry_count()
        self.assertTrue(count_two == count_three)

    def test_divide_with_infinite_number_as_result(self):
        self.app.main_view.insert('1/3=')
        self._assert_result_is(u'0.333333333333')
        self._assert_history_contains(u'1÷3=0.333333333333')

    def test_operation_on_infinite_number(self):
        self.app.main_view.insert('5/3=')
        self._assert_result_is(u'1.666666666667')
        self._assert_history_contains(u'5÷3=1.666666666667')

        self.app.main_view.insert('-1=')
        self._assert_result_is(u'0.666666666667')

    def test_adding_comma_without_number(self):
        # Validation of the decimal separator
        # We are trying to add several commas into one number
        # Only first comma in the number should be allowed
        self.app.main_view.insert('..1.3*.*5.=')
        self._assert_result_is(u'0.065')
        self._assert_history_contains(u'0.13×0.5=0.065')
        self.app.main_view.insert('.7')
        self._assert_result_is(u'0.7')

    def test_adding_comma_without_number_on_temp_result(self):
        self.app.main_view.insert('3+6*9')
        self._assert_result_is(u'3+6×9')
        self.app.main_view.insert('+')
        self._assert_result_is(u'57+')
        self.app.main_view.insert('.0')
        self._assert_result_is(u'57+0.0')
        self.app.main_view.insert('=')
        self._assert_history_contains(u'3+6×9+0.0=57')
        self._assert_result_is(u'57')

    def test_square(self):
        self.app.main_view.insert('4')
        self.app.main_view.press('square')
        self.app.main_view.insert('=')

        self._assert_result_is(u'16')
        self._assert_history_contains(u'4^2=16')

    def test_adding_square_to_empty_formula(self):
        self.app.main_view.press('square')
        self._assert_result_is(u'')

    def test_adding_square_after_operator(self):
        self.app.main_view.insert('6/')
        self.app.main_view.press('square')
        self._assert_result_is(u'6÷')

    def test_cube(self):
        self.app.main_view.insert('3')
        self.app.main_view.press('cube')
        self.app.main_view.insert('=')

        self._assert_result_is(u'27')
        self._assert_history_contains(u'3^3=27')

    def test_power(self):
        self.app.main_view.insert('2')
        self.app.main_view.press('power')
        self.app.main_view.insert('-4=')

        self._assert_result_is(u'0.0625')
        self._assert_history_contains(u'2^−4=0.0625')

    def test_loge(self):
        self.app.main_view.press('log')
        self.app.main_view.press('e')
        self.app.main_view.insert('=')

        self._assert_result_is(u'1')

    def test_factorial(self):
        self.app.main_view.insert('4')
        self.app.main_view.press('!')
        self.app.main_view.insert('=')

        self._assert_result_is(u'24')
        self._assert_history_contains(u'4!=24')

    def test_factorial_with_brackets(self):
        self.app.main_view.press_universal_bracket()
        self.app.main_view.insert('3')
        self.app.main_view.press('!')
        self.app.main_view.insert('*2')
        self.app.main_view.press_universal_bracket()
        self.app.main_view.insert('=')

        self._assert_result_is(u'12')
        self._assert_history_contains(u'(3!×2)=12')

    def test_sin(self):
        self.app.main_view.press('sin')
        self.app.main_view.insert('0=')

        self._assert_result_is(u'0')
        self._assert_history_contains(u'sin(0)=0')

    def test_cos(self):
        self.app.main_view.press('cos')
        self.app.main_view.insert('0')
        self.app.main_view.press_universal_bracket()
        self.app.main_view.insert('=')

        self._assert_result_is(u'1')
        self._assert_history_contains(u'cos(0)=1')

    def test_validation_complex_numbers(self):
        self.app.main_view.insert('66')
        self.app.main_view.press('i')
        self.app.main_view.insert('*')
        self.app.main_view.press('i')
        self.app.main_view.press('i')
        self.app.main_view.press('i')
        self._assert_result_is(u'66i×i')
        self.app.main_view.insert('33=')
        self._assert_result_is(u'−66')
        self._assert_history_contains(u'66i×i=−66')

    def test_formatting_long_complex_numbers(self):
        self.app.main_view.press_universal_bracket()
        self.app.main_view.insert('3+4')
        self.app.main_view.press('i')
        self.app.main_view.press_universal_bracket()
        self._assert_result_is(u'(3+4i)')
        self.app.main_view.press('square')
        self.app.main_view.insert('=')
        self._assert_result_is(u'−6.999999999999997+24i')
        self._assert_history_contains(u'(3+4i)^2=−6.999999999999997+24i')

    def test_floating_point_round_error(self):
        self.app.main_view.insert('0.1+0.2=')
        self._assert_result_is(u'0.3')
        self._assert_history_contains(u'0.1+0.2=0.3')

    def _assert_result_is(self, value):
        self.assertThat(self.app.main_view.get_result,
                        Eventually(Equals(value)))

    def _assert_history_contains(self, value):
        self.assertTrue(self.app.main_view.get_history().contains(value))
