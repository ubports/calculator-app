# -*- Mode: Python; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-

"""Calculator app autopilot tests."""

from autopilot.matchers import Eventually
from testtools.matchers import Equals

from ubuntu_calculator_app.tests import CalculatorAppTestCase


class MainTestCase(CalculatorAppTestCase):

    def setUp(self):
        super(MainTestCase, self).setUp()

    def test_calculator_visible(self):
        self.assertThat(self.app.main_view.visible,
                        Eventually(Equals(True)))
