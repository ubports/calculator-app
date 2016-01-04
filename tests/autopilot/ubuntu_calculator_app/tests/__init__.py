# -*- Mode: Python; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-
#
# Copyright (C) 2013-2015 Canonical Ltd
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 3 as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

"""Calculator app autopilot tests."""

import os
import shutil
import logging
import fixtures

import ubuntu_calculator_app

from autopilot.testcase import AutopilotTestCase
from autopilot import logging as autopilot_logging

import ubuntuuitoolkit
from ubuntuuitoolkit import base

logger = logging.getLogger(__name__)


class CalculatorAppTestCase(AutopilotTestCase):
    """A common test case class that provides several useful methods for
    the ubuntu-calculator-app tests.

    """

    local_location = os.path.dirname(os.path.dirname(os.getcwd()))

    local_location_qml = os.path.join(local_location,
                                      'app/ubuntu-calculator-app.qml')

    installed_location_qml = os.path.join('/usr/share/ubuntu-calculator-app/',
                                          'ubuntu-calculator-app.qml')

    def get_launcher_and_type(self):
        if os.path.exists(self.local_location_qml):
            launcher = self.launch_test_local
            test_type = 'local'
        elif os.path.exists(self.installed_location_qml):
            launcher = self.launch_test_installed
            test_type = 'deb'
        else:
            launcher = self.launch_test_click
            test_type = 'click'
        return launcher, test_type

    def setUp(self):
        super(CalculatorAppTestCase, self).setUp()
        self.clear_calculator_database()
        self.launcher, self.test_type = self.get_launcher_and_type()

        # Unset the current locale to ensure locale-specific data
        # (day and month names, first day of the week, …) doesn’t get
        # in the way of test expectations.
        self.useFixture(fixtures.EnvironmentVariable('LC_ALL', 'C'))
        self.app = ubuntu_calculator_app.CalculatorApp(self.launcher(),
                                                       self.test_type)

    @autopilot_logging.log_action(logger.info)
    def launch_test_local(self):
        return self.launch_test_application(
            base.get_qmlscene_launch_command(),
            self.local_location_qml,
            app_type='qt',
            emulator_base=ubuntuuitoolkit.UbuntuUIToolkitCustomProxyObjectBase)

    @autopilot_logging.log_action(logger.info)
    def launch_test_installed(self):
        return self.launch_test_application(
            base.get_qmlscene_launch_command(),
            self.installed_location_qml,
            app_type='qt',
            emulator_base=ubuntuuitoolkit.UbuntuUIToolkitCustomProxyObjectBase)

    @autopilot_logging.log_action(logger.info)
    def launch_test_click(self):
        return self.launch_click_package(
            "com.ubuntu.calculator",
            emulator_base=ubuntuuitoolkit.UbuntuUIToolkitCustomProxyObjectBase)

    def clear_calculator_database(self):
        calculator_database_path = os.path.join(
            os.path.expanduser('~'),
            '.local',
            'share',
            'com.ubuntu.calculator'
        )

        if os.path.exists(calculator_database_path):
            shutil.rmtree(calculator_database_path)
            lambda: os.path.exists(calculator_database_path).wait_for(False)
