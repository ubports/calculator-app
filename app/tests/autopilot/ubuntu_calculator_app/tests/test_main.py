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

        self.app.main_view.clear()

        self.app.main_view.insert('9*9=')
        self.assertThat(self.app.main_view.get_result,
                        Eventually(Equals('81')))
