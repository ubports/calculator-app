# -*- Mode: Python; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-
#
# Copyright (C) 2013 Canonical Ltd.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation; version 3.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

"""Calculator app autopilot emulators."""

import ubuntuuitoolkit


class CalculatorApp(object):
    """Autopilot helper object for the calculator application."""

    def __init__(self, app_proxy, test_type):
        self.app = app_proxy
        self.test_type = test_type
        self.main_view = self.app.select_single(MainView)

    @property
    def pointing_device(self):
        return self.app.pointing_device


class MainView(ubuntuuitoolkit.MainView):
    """Calculator MainView Autopilot emulator."""

    BUTTONS = {'clear': 'clearButton', '*': 'multiplyButton',
               '8': 'eightButton', '9': 'nineButton', '=': 'equalsButton'}

    def __init__(self, *args):
        super(MainView, self).__init__(*args)
        self.visible.wait_for(True)

    def insert(self, expression):
        for operand in expression:
            self.press(operand)

    def clear(self):
        self.press('clear')

    def press(self, button):
        button = self.wait_select_single('KeyboardButton',
                                         objectName=MainView.BUTTONS[button])

        self.pointing_device.click_object(button)

    def get_result(self):
        return self.wait_select_single('TextField',
                                       objectName='textInputField').displayText
