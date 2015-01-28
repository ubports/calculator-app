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


class CalculationHistory(object):
    """Helper object for the calculation history."""

    def __init__(self, app_proxy):
        self.app = app_proxy

    def contains(self, entry):
        found = False

        calculations = self.app.select_many('QQuickRectangle',
                                            objectName='mainItem')

        for calculation in calculations:
            if entry.strip() == self._get_entry(calculation):
                found = True

        return found

    def _get_entry(self, calc):
        return self._get_formula(calc) + '=' + self._get_result(calc)

    def _get_formula(self, calc):
        return calc.wait_select_single('QQuickText',
                                       objectName='formula').text.strip()

    def _get_result(self, calc):
        return calc.wait_select_single('QQuickText',
                                       objectName='result').text.strip()


class MainView(ubuntuuitoolkit.MainView):
    """Calculator MainView Autopilot emulator."""

    BUTTONS = {'clear': 'clearButton', '*': 'multiplyButton',
               '/': 'divideButton', '.': 'pointButton', 'bracket': 'universalBracketButton',
               '=': 'equalsButton', '-': 'minusButton', '+': 'plusButton',
               '0': 'zeroButton', '1': 'oneButton', '2': 'twoButton',
               '3': 'threeButton', '4': 'fourButton', '5': 'fiveButton',
               '6': 'sixButton', '7': 'sevenButton', '8': 'eightButton',
               '9': 'nineButton'}

    def __init__(self, *args):
        super(MainView, self).__init__(*args)
        self.visible.wait_for(True)

    def insert(self, expression):
        for operand in expression:
            self.press(operand)

    def press_universal_bracket(self):
        self.press('bracket')

    def clear(self):
        self.press('clear')

    def press(self, button):
        button = self.wait_select_single('KeyboardButton',
                                         objectName=MainView.BUTTONS[button])

        button_area = button.wait_select_single('QQuickMouseArea',
                                                objectName='buttonMA')

        self.pointing_device.move_to_object(button)
        # we use press and release so we can check the qml property
        # and ensure the button is pressed long enough to be recieved
        # and processed correctly
        # using a larger press_duration for click_object would be inferior
        # as it would cause longer delays (we are forced to arbitrarily decide
        # how long to press each time) and potentially fail.
        # Also, https://bugs.launchpad.net/autopilot/+bug/1366949
        # causes press_duration argument to be ignored currently
        # balloons 2014-09-08
        self.pointing_device.press()
        button_area.pressed.wait_for(True)
        self.pointing_device.release()

    def get_history(self):
        history = self.wait_select_single('ScrollableView',
                                          objectName='scrollableView')

        return CalculationHistory(history)

    def get_result(self):
        return self.wait_select_single('TextField',
                                       objectName='textInputField').displayText
