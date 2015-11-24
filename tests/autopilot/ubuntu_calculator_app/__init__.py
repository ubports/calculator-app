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

from time import sleep
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

        history = self.get_all_history_entries()
        for line in history:
            calculation = self._get_entry(line)
            if calculation == entry.strip():
                found = True
                break

        return found

    def get_all_history_entries(self):
        return self.app.select_many('QQuickRow', objectName='historyrow')

    def get_history_entry_count(self):
        return len(self.get_all_history_entries())

    def get_history_entry(self, entry):
        return self.app.select_single('QQuickText',
                                      objectName='result' + str(entry))

    def get_formula_entry(self, entry=0):
        return self.app.select_single('QQuickText',
                                      objectName='formula' + str(entry))

    def get_formula_value(self, entry=0):
        return self.get_formula_entry(entry).text.strip()

    def get_result_value(self, entry=0):
        return self.get_history_entry(entry).text.strip()

    def _get_entry(self, line):
        values = line.select_many('QQuickText')
        result = ''
        formula = ''
        for value in values:
            if 'result' in value.objectName:
                result = value.text.strip()
            elif 'formula' in value.objectName:
                formula = value.text.replace(" ", "")

        return formula + result


class MainView(ubuntuuitoolkit.MainView):
    """Calculator MainView Autopilot emulator."""

    BUTTONS = {'delete': 'deleteButton', '*': 'multiplyButton',
               '/': 'divideButton', '.': 'pointButton',
               '=': 'equalsButton', '-': 'minusButton', '+': 'plusButton',
               '0': 'zeroButton', '1': 'oneButton', '2': 'twoButton',
               '3': 'threeButton', '4': 'fourButton', '5': 'fiveButton',
               '6': 'sixButton', '7': 'sevenButton', '8': 'eightButton',
               '9': 'nineButton', 'bracket': 'universalBracketButton',
               'square': 'squareButton', 'cube': 'cubeButton',
               'power': 'powerButton', 'log': 'logarithmButton',
               'e': 'eNumberButton', '!': 'factorialNumberButton',
               'i': 'iButton', 'sin': 'sinusButton', 'cos': 'cosButton'}

    def __init__(self, *args):
        super(MainView, self).__init__(*args)
        self.visible.wait_for(True)

    def insert(self, expression):
        for operand in expression:
            self.press(operand)

    def press_universal_bracket(self):
        self.press('bracket')

    def delete(self):
        self.press('delete')

    def clear(self):
        self.press_and_hold('delete')

    def press_and_hold(self, button):
        button = self.wait_select_single('KeyboardButton',
                                         objectName=MainView.BUTTONS[button])

        self.pointing_device.move_to_object(button)
        self.pointing_device.press()
        button.pressed.wait_for(True)
        sleep(3)
        self.pointing_device.release()

    def press(self, button):
        button = self.wait_select_single('KeyboardButton',
                                         objectName=MainView.BUTTONS[button])

        self.pointing_device.move_to_object(button)
        # we use press and release so we can check the qml property
        # and ensure the button is pressed long enough to be recieved
        # and processed correctly
        # using a larger press_duration for click_object would be inferior
        # as it would cause longer delays (we are forced to arbitrarily decide
        # how long to press each time) and potentially fail.
        # balloons 2015-01-29
        self.pointing_device.press()
        # this sleeps represents our minimum press time,
        # should button.pressed be true without any wait
        sleep(0.1)
        button.pressed.wait_for(True)
        self.pointing_device.release()

    def get_history(self):
        history = self.wait_select_single('ScrollableView',
                                          objectName='scrollableView')

        return CalculationHistory(history)

    def get_result(self):
        return self.wait_select_single('TextField',
                                       objectName='textInputField').displayText

    def show_scientific_keyboard(self):
        self._scientific_keyboard()

    def hide_scientific_keyboard(self):
        self._scientific_keyboard(enable=False)

    def _scientific_keyboard(self, enable=True):
        y = (self.globalRect[1] + self.globalRect[3] / 2) + 150

        x_middle = self.globalRect[0] + self.globalRect[2] / 2

        if enable:
            x_start = x_middle + 150
            x_stop = x_middle - 150
        else:
            x_start = x_middle - 150
            x_stop = x_middle + 150

        self.pointing_device.drag(x_start, y, x_stop, y)

        # TODO: Find a better implementation to avoid this, if possible.
        sleep(2)

    def enter_text_via_keyboard(self, textToEnter):
        """Enter specific formula with keyboard

        :param text: text to enter via keyboard

        """
        ubuntuuitoolkit.get_keyboard().type(textToEnter, delay=0.1)

    def press_and_release_key(self, keyToPress):
        """Press and release specific key

        :param keyToPress: key to press

        """
        ubuntuuitoolkit.get_keyboard().press_and_release(keyToPress, delay=0.1)
