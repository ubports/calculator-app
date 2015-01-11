# -*- Mode: Python; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-

"""Calculator app autopilot tests."""

from autopilot.matchers import Eventually
from testtools.matchers import Equals

from ubuntu_calculator_app.tests import CalculatorAppTestCase


class MainTestCase(CalculatorAppTestCase):

    def setUp(self):
        super(MainTestCase, self).setUp()

    def test_operation_after_clear(self):
        self.app.main_view.insert('8*8=')

        self._assert_result_is('64')
        self._assert_history_contains('8×8=64')

        self.app.main_view.clear()
        self.app.main_view.insert('9*9=')

        self._assert_result_is('81')
        self._assert_history_contains('9×9=81')

    def test_small_numbers(self):
        self.app.main_view.insert('0.000000001+1=')
        self._assert_result_is('1.000000001')

        self.app.main_view.clear()

        self.app.main_view.insert('0.000000001/10=')
        self._assert_result_is('1e−10')

    def test_operators_precedence(self):
        self.app.main_view.insert('2+2*2=')

        self._assert_result_is('6')
        self._assert_history_contains('2+2×2=6')

        self.app.main_view.clear()
        self.app.main_view.insert('2-2*2=')

        self._assert_result_is('−2')
        self._assert_history_contains('2−2×2=-2')

        self.app.main_view.clear()
        self.app.main_view.insert('5+6/2=')

        self._assert_result_is('8')
        self._assert_history_contains('5+6÷2=8')

    def test_divide_with_zero(self):
        self.app.main_view.insert('0/5=')

        self._assert_result_is('0')
        self._assert_history_contains('0÷5=0')

    def test_divide_by_zero(self):
        self.app.main_view.insert('5/0=')

        self._assert_result_is(u'\u221e')
        self._assert_history_contains(u'5÷0=Infinity')

    def test_divide_zero_by_zero(self):
        self.app.main_view.insert('0/0=')

        self._assert_result_is('NaN')
        self._assert_history_contains(u'0÷0=NaN')

    def test_equals_doesnt_change_numbers(self):
        self.app.main_view.insert('125')
        self._assert_result_is('125')

        self.app.main_view.insert('=')
        self._assert_result_is('125')

    def test_divide_with_infinite_number_as_result(self):
        self.app.main_view.insert('1/3=')
        self._assert_result_is('0.3333333333333333')

    def test_operation_on_infinite_number(self):
        self.app.main_view.insert('5/3=')
        self._assert_result_is('1.6666666666666667')

        self.app.main_view.insert('-1=')
        self._assert_result_is('0.6666666666666667')

    def _assert_result_is(self, value):
        self.assertThat(self.app.main_view.get_result,
                        Eventually(Equals(value)))

    def _assert_history_contains(self, value):
        self.assertTrue(self.app.main_view.get_history().contains(value))
