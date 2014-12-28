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
        self.assertThat(self.app.main_view.get_result,
                        Eventually(Equals('64')))

        self.assertTrue(self.app.main_view.get_history().contains('8×8=64'))

        self.app.main_view.clear()

        self.app.main_view.insert('9*9=')
        self.assertThat(self.app.main_view.get_result,
                        Eventually(Equals('81')))

        self.assertTrue(self.app.main_view.get_history().contains('9×9=81'))

    def test_small_numbers(self):
        self.app.main_view.insert('0.000000001+1=')
        self.assertThat(self.app.main_view.get_result,
                        Eventually(Equals('1.000000001')))

        self.app.main_view.clear()

        self.app.main_view.insert('0.000000001/10=')
        self.assertThat(self.app.main_view.get_result,
                        Eventually(Equals('1e−10')))
