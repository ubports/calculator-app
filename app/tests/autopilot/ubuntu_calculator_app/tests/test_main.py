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

    def _assert_result_is(self, value):
        self.assertThat(self.app.main_view.get_result,
                        Eventually(Equals(value)))

    def _assert_history_contains(self, value):
        self.assertTrue(self.app.main_view.get_history().contains(value))
